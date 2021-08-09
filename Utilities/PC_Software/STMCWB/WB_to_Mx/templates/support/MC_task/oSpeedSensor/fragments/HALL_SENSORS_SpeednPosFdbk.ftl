<#import "../../../ui.ftl" as ui >
<#import "../../../utils.ftl" as utils >
<#import "../../utils/ips_mng.ftl" as ns_ip >

<#macro HALL_SENSORS_SpeednPosFdbk who motor>
    <#local macroName>HALL_SENSORS_SpeednPosFdbk</#local>
    <@ui.box "${who} HALL SENSOR for motor ${motor}" '' '~' false />
    <@all_settings_HALL_SENSORS_SpeednPosFdbk who motor />
</#macro>

<#macro all_settings_HALL_SENSORS_SpeednPosFdbk who motor>
    <#local timer = ns_ip.collectIP( utils._last_word( utils.v("HALL_TIMER_SELECTION", motor) ) ) >
<#--
-->
    <@ui.line fp.flatten(
        [ hall_speed_sense_IRQ(timer)
        , hall_speed_sense_TIMER(motor, timer)
        , hall_speed_sense_CLK(timer)
        , hall_speed_sense_GPIOs(motor, timer)
        ])
    />
</#macro>

<#function hall_speed_sense_IRQ timer>
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

<#function hall_speed_sense_TIMER motor timer>

    <#local src_hall_ic_filter  = utils.v("HALL_ICx_FILTER", motor)
            src_hall_tim_period = 65535
            >

    <#return
        [ ui._box("${timer} settings", ' ', '', false)
        , "${timer}.IC1Filter=M${motor}_HALL_IC_FILTER"
        , "${timer}.Period=M${   motor}_HALL_TIM_PERIOD"
        , "${timer}.IPParameters=IC1Filter,Period"
    <#--, "${timer}.IC1Polarity=TIM_ICPOLARITY_FALLING"
        , "${timer}.IPParameters=IC1Filter,IC1Polarity,Period" -->
        , "${timer}.IPParametersWithoutCheck=IC1Filter,Period"
        ] >
</#function>

<#function hall_speed_sense_CLK timer>
    <#local vsignal = "${timer}_VS_ClockSourceINT">
    <#local vpin    = pins.collectPin( "VP_${vsignal}" ) >
    <#return
        [ ui._box("TIM clock config", ' ', '', false)
        , "${vpin}.Mode=Internal"
        , "${vpin}.Signal=${vsignal}"
        ]>
</#function>

<#function hall_speed_sense_GPIOs motor timer>
    <#local chs = [["CH1","_ETR","1"], ["CH2","","2"], ["CH3","","3"]] >
    <#local map_ctx = {"motor": motor, "timer": timer} >
    <#return fp.flatMap_ctx(map_ctx, hall_channel, chs) >
</#function>



<#-- services -->
<#function hall_channel ctx channel_definition>
    <#return speed_sense_TIMER_GPIO(ctx.motor, ctx.timer
        , channel_definition[0]
        , channel_definition[1]
        , channel_definition[2]
    ) >
</#function>

<#import "../../utils/pins_mng.ftl" as pins>
<#function speed_sense_TIMER_GPIO motor timer ch ex idx>

    <#local mode     = "Xored_Inputs_Hall_Sensor_Interface" >
    <#local signal   = "${timer}_${ch}"    >
    <#local s_signal = "S_${signal}${ex}"  >

    <#local pinName = pins.name2(motor, "H${idx}" ) >

    <#return
        [ ui._box( "HALL SENSOR - ${pinName} for M${motor} ${timer} ${ch}", " ","", false)
        , "${pinName}.GPIOParameters=GPIO_Label,GPIO_Speed"
        , "${pinName}.GPIO_Label=M${motor}_HALL_H${idx}"
        , "${pinName}.GPIO_Speed=GPIO_SPEED_FREQ_HIGH"
        , "${pinName}.Locked=true"

        , "${pinName}.Signal=${s_signal}"
        , "SH.${s_signal}.0=${signal},${mode}"
        , "SH.${s_signal}.ConfNb=1"
        ]>
</#function>



<#--
<#macro speed_sense_RCC motor timer>
&lt;#&ndash;
    <@ui.box "RCC setting" '~' '~' />
    <@ui.line "RCC.${timer}Freq_Value = ${HALL_TIM_CLK}" />
&ndash;&gt;
</#macro>
-->


