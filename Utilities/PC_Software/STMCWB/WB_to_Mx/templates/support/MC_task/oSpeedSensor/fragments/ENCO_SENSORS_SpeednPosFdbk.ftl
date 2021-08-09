<#import "../../../ui.ftl" as ui >
<#import "../../../fp.ftl" as fp >
<#import "../../../utils.ftl" as utils >
<#import "../../utils/ips_mng.ftl" as ns_ip>

<#macro ENCO_SENSORS_SpeednPosFdbk who motor>
    <#local macroName>ENCO_SENSORS_SpeednPosFdbk</#local>
    <@ui.box "${who} ENCO SENSOR for motor ${motor}" '' '~' false />
    <@all_settings_ENCO_SENSORS_SpeednPosFdbk who motor />
</#macro>

<#macro all_settings_ENCO_SENSORS_SpeednPosFdbk who motor>
    <#local timer = ns_ip.collectIP( utils._last_word( utils.v("ENC_TIMER_SELECTION", motor) ) ) >
<#--
-->
    <@ui.line fp.flatten(
        [ enco_speed_sense_IRQ(timer)

        , enco_speed_sense_TIMER(motor, timer)

        , enco_speed_sense_GPIOs(motor, timer)
        ]) />
    <#--<@enco_speed_sense_CLK         timer />-->
</#macro>

<#function enco_speed_sense_IRQ timer>

    <#import "../../../../support/FreeRTOS/Has_RTOS.ftl" as rtos >
    <#if rtos.has_rtos()>
        <#local irq_set = (WB_RTOS_USE_IRQ!false)?then(
                                                       [true, 8, 0, true, false, false, true , true],
                                                       [true, 3, 0, true, false, false, false, true])>
    <#else>
        <#local irq_set = [true, 3, 0, false, false, false, true] >
    </#if>


    <#return
        [ ui._comment("Interrupt setting")
        , ns_ip.ip_irq(timer, irq_set)
        ] >
</#function>


<#--<#import "../../utils/user_constants.ftl" as mcu>-->
<#function enco_speed_sense_TIMER motor timer>

    <#local src_encoder_ppr      = utils.v("ENCODER_PPR"     , motor)
            src_enc_ic_filter    = utils.v("ENC_ICx_FILTER"  , motor)
            src_enc_invert_speed = utils.v("ENC_INVERT_SPEED", motor)
            >

    <#-- [Ticket 44552](https://intbugzilla.st.com/show_bug.cgi?id=44552)
      DETAILS: The ENC TIM polarity of Ch2 is not changed according to the ENC_INVERT_SPEED value in the Cube MX project.
               If the ENC_INVERT_SPEED is ENABLE the ENC TIM CH2 polarity has to be set as Falling else if it is DISABLE
               the configuration polarity is Rising. The ENC TIM Ch1 polarity is Rising in both cases.

      EXPECTED BEHAVIOUR: The ECN TIM CH1 polarity is always rising.

      HOW TO REPRODUCE: Select the reverse counting in the Main sensor when the Quadrature encoder is selected and generate the projetc.

      OCCURENCE: systematic
    -->
    <#local ch1_polarity = "RISING" >
    <#local ch2_polarity = src_enc_invert_speed?then("FALLING", "RISING") >

    <#return
        [ ui._box("${timer} settings", " ", "", false)
        , "${timer}.EncoderMode=TIM_ENCODERMODE_TI12"
        , "${timer}.Period=M${   motor}_PULSE_NBR"

        , "${timer}.IC1Filter=M${motor}_ENC_IC_FILTER"
        , "${timer}.IC1Polarity=TIM_ICPOLARITY_${ ch1_polarity }"

        , "${timer}.IC2Filter=M${motor}_ENC_IC_FILTER"
        , "${timer}.IC2Polarity=TIM_ICPOLARITY_${ ch2_polarity }"
        , "${timer}.IPParameters=EncoderMode,Period,IC1Filter,IC1Polarity,IC2Filter,IC2Polarity"
        , "${timer}.IPParametersWithoutCheck=Period,IC1Filter,IC2Filter"
        ]>
</#function>

<#function enco_speed_sense_GPIOs motor timer>

    <#local chs_2 = [["CH1","_ETR","A"], ["CH2","","B"]] >
    <#local chs_3 = [["CH1","_ETR","A"], ["CH2","","B"],["CH3","","Z"]] >

    <#local chs = (utils.v("ENC_USE_CH3", motor)!false)?then( chs_3 , chs_2 )>

    <#local map_ctx = {"motor": motor, "timer": timer} >

    <#return fp.flatMap_ctx(map_ctx, enco_channel, chs) >
</#function>
<#function enco_channel ctx channel_definition>

    <#return enco_speed_sense_TIMER_GPIO(ctx.motor, ctx.timer
        , channel_definition[0]
        , channel_definition[1]
        , channel_definition[2]
        ) >
</#function>


<#import "../../utils/pins_mng.ftl" as pins>
<#function enco_speed_sense_TIMER_GPIO motor timer ch ex idx>
<#--
    idx =    A |   B  |   Z
    ch  =  CH1 | CH2  | CH3
    ex  = _ETR | ""   | ""
-->

    <#if (ch != "CH3")>

    <#local mode     = "Encoder_Interface" >
    <#local signal   = "${timer}_${ch}"    >
    <#local s_signal = "S_${signal}${ex}"  >

<#--    <#local pinName = (utils.v("ENC_USE_CH3", motor)!false)?then( pins.name_("ENC_${idx}",motor ) , pins.name2(motor,"ENC_${idx}") )>-->
    <#local pinName = pins.name2(motor,"ENC_${idx}")>
    <#return
        [ ui._box("${pinName} GPIO settings for M${motor}_ENCODER_${idx} on ${signal}${ex}", " ", "", false )
        , "${pinName}.GPIOParameters=GPIO_Label"
        , "${pinName}.GPIO_Label=M${motor}_ENCODER_${idx}"
        , "${pinName}.Locked=true"

        , "${pinName}.Signal=${s_signal}"
        , "SH.${s_signal}.0=${signal},${mode}"
        , "SH.${s_signal}.ConfNb=1"
        ]>
    <#else>
            <#local pin = pins.name_("ENC_${idx}",motor)>
            <#local pin_num = pin[2..] >
            <#local vs_signal = "GPXTI${ pin_num }" >

            <#import "../../../names_map.ftl" as rr>
            <#local irq_name = EXT_IRQNbr(pin_num, rr["START_STOP_BTN_EXTI_IRQ"] ) >
            <#local irq_setting = ns_ip.ip_irq(irq_name, (rr["SET_IRQ_POS_CON_ENCODER_Z"]![true, 3, 0, false, false, false, true]))>

            <#return
            [ ui._box("${pin} GPIO settings for M${motor}_ENCODER_${idx}", " ", "", false )
            , "${pin}.GPIOParameters=GPIO_Label,GPIO_ModeDefaultEXTI"
            , "${pin}.GPIO_Label=M${motor}_ENCODER_${idx}"
            , "${pin}.GPIO_ModeDefaultEXTI=GPIO_MODE_IT_RISING"
            , "${pin}.Locked=true"
            , "${pin}.Signal=${ vs_signal }"
            , "${irq_setting}"
            , "SH.${vs_signal}.0=GPIO_EXTI${ pin_num }"
            , "SH.${vs_signal}.ConfNb=1"
            ]>
    </#if>
</#function>



<#function EXT_IRQNbr line handlers>
    <#list handlers as handler>
        <#if line?number <= (handler.line ) >
            <#return handler.name >
        </#if>
    </#list>
    <#return handlers?last >
</#function>

<#--
<#macro enco_speed_sense_RCC motor timer>
&lt;#&ndash;
    <@ui.box "RCC setting" '~' '~' />
RCC.TIM2Freq_Value=72000000
    <@ui.line "RCC.${timer}Freq_Value = ${ENC_TIM_CLK}" />
&ndash;&gt;
</#macro>
-->

<#--
<#macro enco_speed_sense_CLK timer>
    <@ui.box "TIM clock config" '~' '~' />
    <@ui.line "VP_${timer}_VS_ClockSourceINT.Mode=Internal" />
    <@ui.line "VP_${timer}_VS_ClockSourceINT.Signal=${timer}_VS_ClockSourceINT" />
</#macro>
-->


