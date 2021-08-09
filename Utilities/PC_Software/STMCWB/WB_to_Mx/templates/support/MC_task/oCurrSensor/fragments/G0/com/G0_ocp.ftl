<#import "../../../../../utils.ftl" as utils>
<#import "../../../../../fp.ftl" as fp>
<#import "../../../../../ui.ftl" as ui>

<#import "../../../../utils/ips_mng.ftl" as ns_ip>
<#import "../../../../utils/pins_mng.ftl" as ns_pin>

<#-- OVER CURRENT PROTECTION -->
<#function cs_over_current_prot motor phases = [""]>
    <#local hasProtection = utils.v("BKIN_MODE", motor) != "NONE" >
    <#if !hasProtection >
        <#return
            { "settings" : {"No Over Current Protection": ""}
            , "GPIOs"    : []
            }>
    </#if>

    <#local pwm_timer = ns_ip.collectIP( utils._last_word( utils.v("PWM_TIMER_SELECTION", motor)) ) >
    <#return ext_comp(motor, pwm_timer) >
</#function>



<#function ext_comp motor pwm_timer>
<#-- External Comparator output have to be connected to the TIMER(Activate-Break-Input) so in case of overcurrent
 #   the timer activities can be stopped
 #   Here we configure the mcu Pin to be connected to the timer active-break input -->

    <#local pinName = ns_pin.name2(motor, "EMERGENCY_STOP") />

<#-- it is correct tu map ACTIVE_HIGH to PULLDOWN and ACTIVE_LOW to PULLUP -->

    <#local pull = utils._last_word( utils.v("OVERCURR_FEEDBACK_POLARITY", motor))?switch("HIGH","PULLDOWN",  "LOW","PULLUP") >

    <#local active_break_pin =
        [ "${pinName}.GPIOParameters=GPIO_PuPd,GPIO_Label"
        , "${pinName}.GPIO_Label=M${motor}_OCP"
        , "${pinName}.GPIO_PuPd=GPIO_${pull}"
        , "${pinName}.Locked=true"
        , "${pinName}.Mode=Activate-Break-Input"
        , "${pinName}.Signal=${pwm_timer}_BK"
        ]?join('\n')>

    <#local gpio = { "name": pinName
                   , "str" : active_break_pin
                   }>

    <#return
        { "settings" : { "eXternal COMP connected to ${pwm_timer}_BKIN$": ui._comment( active_break_pin ) }
        , "GPIOs"    : [gpio]
        }>
</#function>


