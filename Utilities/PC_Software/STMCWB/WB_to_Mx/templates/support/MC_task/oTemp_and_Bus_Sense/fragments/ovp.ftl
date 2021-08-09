<#import "../../../utils.ftl" as utils>
<#import "../../../fp.ftl" as fp>
<#import "../../utils/ips_mng.ftl" as ns_ip>
<#import "../../utils/pins_mng.ftl" as ns_pin>

<#-- OVER VOLTAGE PROTECTION -->
<#function tb_over_current_prot motor comps = [""]>

    <#local hasProtection = utils.v("BKIN_MODE", motor) != "NONE" >
    <#if !hasProtection >
        <#return
            { "settings" : {"No Over Current Protection": ""}
            , "GPIOs"    : []
            }>
    </#if>



    <#local pwm_timer = ns_ip.collectIP( utils._last_word( utils.v("PWM_TIMER_SELECTION", motor)) ) >

    <#if utils.v("INTERNAL_OVERVOLTAGEPROTECTION", motor) >
        <@'<#global OVERCURR_FEEDBACK_POLARITY${ (motor==2)?then("2", "") } = "HIGH">'?interpret />
        <#return int_comp(motor, comps, pwm_timer) >
    <#else>
        <#return ext_comp(motor, pwm_timer) >
    </#if>
</#function>


<#function int_comp motor comps pwm_timer>
    <#local settings = {}
            GPIOs    = [] >

    <#list comps as c>
        <#local comp = compX(motor, c) >

        <#if c?index == 0 && isDacVRef(comp) >
            <#local GPIOs = GPIOs + [ tb_DAC_GPIO(comp) ] >
        </#if>

        <#local sx = tb_COMP_settings(comp, pwm_timer) >

        <#local settings  = settings  + sx.settings >
        <#local GPIOs     = GPIOs     + sx.GPIOs    >
    </#list>

    <#return
        { "settings" : settings
        , "GPIOs"    : GPIOs
        }>
</#function>

<#function isDacVRef comp>
    <#return   comp.OCP_INVERTINGINPUT_MODE != "EXT_MODE"
          && ! comp.OCP_INVERTINGINPUT?starts_with("COMPX_InvertingInput_VREF") >
</#function>

<#function ext_comp motor pwm_timer>
<#-- External Comparator output have to be connected to the TIMER(Activate-Break-Input-2) so in case of overcurrent
 #   the timer activities can be stopped
 #   Here we configure the mcu Pin to be connected to the timer active-break input
 -->
    <#local bkin_channel=2 >
    <#local pinName = ns_pin.name2(motor, "EMERGENCY_STOP") />

<#-- it is correct tu map ACTIVE_HIGH to PULLDOWN and ACTIVE_LOW to PULLUP -->
    <#local pull = utils._last_word( utils.v("OVERCURR_FEEDBACK_POLARITY", motor))?switch("HIGH","PULLDOWN",  "LOW","PULLUP") >

    <#local active_break2_pin =
        [ "${pinName}.GPIOParameters=GPIO_PuPd,GPIO_Label"
        , "${pinName}.GPIO_Label=M${motor}_OCP"
        , "${pinName}.GPIO_PuPd=GPIO_${pull}"
        , "${pinName}.Locked=true"
        , "${pinName}.Mode=Activate-Break-Input-2"
        , "${pinName}.Signal=${pwm_timer}_BKIN${bkin_channel}"
        ]?join('\n')>

    <#return
        { "settings" : { "eXternal COMP connected to ${pwm_timer}_BKIN${bkin_channel}": active_break2_pin }
        , "GPIOs"    : []
        }>
</#function>



<#function compX motor uvw>
    <#local x = uvw?switch("U","A", "V","B", "W","C", "") >
    <#local comp = ns_ip.collectIP( utils._last_word( utils.v("OCP${x}_SELECTION", motor) ) ) >
    <#return
        { "name"  : comp
        , "phase" : uvw
        , "nic"   : x
        , "OCP_SELECTION" : comp


        , "OCP_INVERTINGINPUT_MODE"           : utils.v( "OCP${x}_INVERTINGINPUT_MODE"        , motor)
        , "OCP_INVERTINGINPUT"                : utils.v( "OCP${x}_INVERTINGINPUT"             , motor)
        , "OCP_INVERTINGINPUT_GPIO_PORT"      : utils.v( "OCP${x}_INVERTINGINPUT_GPIO_PORT"   , motor)
        , "OCP_INVERTINGINPUT_GPIO_PIN"       : utils.v( "OCP${x}_INVERTINGINPUT_GPIO_PIN"    , motor)

        , "OCP_NONINVERTINGINPUT"             : utils.v( "OCP${x}_NONINVERTINGINPUT"          , motor)
        , "OCP_NONINVERTINGINPUT_GPIO_PORT"   : utils.v( "OCP${x}_NONINVERTINGINPUT_GPIO_PORT", motor)
        , "OCP_NONINVERTINGINPUT_GPIO_PIN"    : utils.v( "OCP${x}_NONINVERTINGINPUT_GPIO_PIN" , motor)

        , "OCP_OUTPUT_MODE"                   : utils.v( "OCP${x}_OUTPUT_MODE"                , motor)
        , "OCP_OUTPUT"                        : utils.v( "OCP${x}_OUTPUT"                     , motor)
        , "OCP_OUTPUT_GPIO_PORT"              : utils.v( "OCP${x}_OUTPUT_GPIO_PORT"           , motor)
        , "OCP_OUTPUT_GPIO_PIN"               : utils.v( "OCP${x}_OUTPUT_GPIO_PIN"            , motor)
        , "OCP_OUTPUT_GPIO_AF"                : utils.v( "OCP${x}_OUTPUT_GPIO_AF"             , motor)
        , "OCP_OUTPUTPOL"                     : utils.v( "OCP${x}_OUTPUTPOL"                  , motor)
        }>
</#function>

<#function tb_DAC_GPIO comp>
    <#local dac    = ns_ip.collectIP( DAC1 ) >
    <#local dac_ch = "${ utils._last_char(comp.OCP_INVERTINGINPUT) }" >
    <#local dac_pin = ns_pin.collectPin( {"1": "PA4", "2": "PA5"}[dac_ch] ) >

    <#local dac_setting_key_suffix = (dac_ch=="2")?then("2", "") >
    <#import "../../../../shared_ip/ip_overlap.ftl" as ip_ov>
    <#local dac_IP_settings = ns_ip.IP_settings("${dac} Settings for ${comp.name}", dac,
        { "DAC_Trigger${      dac_setting_key_suffix }" : "DAC_TRIGGER_SOFTWARE"
        , "DAC_OutputBuffer${ dac_setting_key_suffix }" : "DAC_OUTPUTBUFFER_DISABLE"
        }
    )>
    <#local dac_settings = ip_ov.update_IP_parameters(dac_IP_settings)>

    <#return
        { "name"   : dac_pin
        , "label"  : "OCP_DAC_REF"
        , "signal" : "${dac}_OUT${ dac_ch }"
        , "mode"   : "Enable_${dac}_OUT${ dac_ch }"
        , "ip"     : { "name": dac, "pin" : "OUT${ dac_ch }" }
        }>
</#function>



<#function tb_COMP_GPIO_xxx comp who>
    <#local p =
      { "INM": { "mcu_pin_src" : "OCP_INVERTINGINPUT_GPIO"   , "ip_pin" : who, "mode": who }
      , "INP": { "mcu_pin_src" : "OCP_NONINVERTINGINPUT_GPIO", "ip_pin" : who, "mode": who }
      , "OUT": { "mcu_pin_src" : "OCP_OUTPUT_GPIO"           , "ip_pin" : who, "mode": "ExternalOutput" }
      }[who] >

    <#return
        { "name"   : ns_pin.name( comp["${p.mcu_pin_src}_PORT"], comp["${p.mcu_pin_src}_PIN"] )
        , "signal" : "${comp.name}_${p.ip_pin}"
        , "mode"   : p.mode
        , "ip"     : { "name": comp.name, "pin" : p.ip_pin }
    }>
</#function>
<#function tb_COMP_GPIO_INP_settings comp>
    <#return tb_COMP_GPIO_xxx(comp, "INP") + { "label"  : "BUS_VOLTAGE" } >
</#function>
<#function tb_COMP_GPIO_INM_settings comp, label>
    <#return tb_COMP_GPIO_xxx(comp, "INM") + { "label"  : label } >
</#function>
<#function tb_COMP_GPIO_OUT_settings comp>
    <#local lbl = concatenate("OVP_OUT", comp.phase) >
    <#return tb_COMP_GPIO_xxx(comp, "OUT") + { "label"  : lbl } >
</#function>

<#function concatenate a b>
    <#return fp.filter(utils.hasContent, [a, b])?join("_") >
</#function>


<#function tb_COMP_settings comp pwm_timer>
    <#if comp.OCP_INVERTINGINPUT_MODE == "EXT_MODE" >
        <#local ret = tb_COMP_external_VRef(comp, pwm_timer) >

    <#elseif comp.OCP_INVERTINGINPUT?starts_with("COMPX_InvertingInput_VREF") >
        <#local ret = tb_COMP_internal_VRef(comp, pwm_timer) >

    <#else>
        <#local ret = tb_COMP_internal_DAC(comp, pwm_timer) >
    </#if>

    <#if comp.OCP_OUTPUT_MODE == "EXT_MODE" >
        <#local out_pin = tb_COMP_GPIO_OUT_settings(comp) >
        <#local ret = ret + { "GPIOs": ret["GPIOs"]+[out_pin] } >
    </#if>

    <#return ret >
</#function>




<#function tb_COMP_external_VRef comp pwm_timer>
    <#local comp_setting =
        [ "${comp.name}.IPParameters=Output"
        , "${comp.name}.Output=COMP_OUTPUT_${pwm_timer}BKIN2"
        ] >

    <#return { "settings" : { "COMP${comp.nic} Settings": comp_setting?join('\n') }
             , "GPIOs"    : [ tb_COMP_GPIO_INP_settings(comp)
                            , tb_COMP_GPIO_INM_settings(comp, "OVP_EXT_REF")
                            ]
             }>
</#function>

<#function tb_COMP_internal_VRef comp pwm_timer>
    <#local threshold =
        { "COMPX_InvertingInput_VREF"    : {"L": ""   , "s": ""   , "m": ""  }
        , "COMPX_InvertingInput_VREF_3_4": {"L": "3_4", "s": "34" , "m": "_34"}
        , "COMPX_InvertingInput_VREF_1_2": {"L": "1_2", "s": "12" , "m": "_12"}
        , "COMPX_InvertingInput_VREF_1_4": {"L": "1_4", "s": "14" , "m": "_14"}
        }[comp.OCP_INVERTINGINPUT] >

    <#-- VREFINTx_y is a virtual signal so it has to be mapped to a virtual Pin -->
    <#local ph_signal = "VREFINT${threshold.s}" >
    <#local vr_signal = "${comp.name}_VS_${ ph_signal }" >
    <#local vr_pin    = ns_pin.collectPin("VP_${ vr_signal }") >

    <#local comp_setting =
        [ "${comp.name}.IPParameters=Output,InvertingInput"
        , "${comp.name}.Output=COMP_OUTPUT_${pwm_timer}BKIN2"
        , "${comp.name}.InvertingInput=COMP_INVERTINGINPUT_${ threshold.L }VREFINT"

        , "${vr_pin}.Mode=VREFINT${ threshold.m }"
        , "${vr_pin}.Signal=${vr_signal}"
        ]>

    <#return { "settings" : { "COMP${ comp.nic } Settings": comp_setting?join('\n') }
             , "GPIOs"    : [ tb_COMP_GPIO_INP_settings(comp) ]
             }>
</#function>

<#function tb_COMP_internal_DAC comp pwm_timer >
    <#local dac    = ns_ip.collectIP( DAC1 ) >
    <#local dac_ch = "${ utils._last_char(comp.OCP_INVERTINGINPUT) }" >

    <#local comp_setting =
        [ "${comp.name}.IPParameters=Output,InvertingInput"
        , "${comp.name}.Output=COMP_OUTPUT_${pwm_timer}BKIN2"
        , "${comp.name}.InvertingInput=COMP_INVERTINGINPUT_${dac}_CH${dac_ch}"
        ]>

    <#return
        { "settings" : { "COMP${ comp.nic } Settings": comp_setting?join('\n') }
        , "GPIOs"    : [ tb_COMP_GPIO_INP_settings(comp)
                       , tb_COMP_GPIO_INM_settings(comp, "OCP_DAC_CH${dac_ch}_REF")
                       ]
        }>
</#function>
