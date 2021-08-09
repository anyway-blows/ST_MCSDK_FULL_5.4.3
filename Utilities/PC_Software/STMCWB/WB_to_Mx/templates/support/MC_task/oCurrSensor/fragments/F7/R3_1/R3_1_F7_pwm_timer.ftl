<#--
<#import "../../../../utils.ftl" as utils>
<#import "../../../utils/meta_parameters.ftl" as meta>
-->
<#import "../com/F7_pwm_timer.ftl" as cmns>

<#function cs_PWM_TIMER_patameters timer>
    <#return cmns.cs_PWM_TIMER_patameters(timer, [4]) +
        { "CounterMode"              : "TIM_COUNTERMODE_CENTERALIGNED1"
        , "TIM_MasterOutputTrigger"  : "TIM_TRGO_RESET"
        , "TIM_MasterOutputTrigger2" : "TIM_TRGO2_RESET"
        }>

<#--
    <#list [4] as idx>
        <#local mode      = "PWM Generation${idx} No Output" >
        <#local vs_signal = "${timer.name}_VS_no_output${idx}" >
        <#local vp_pin    = ns_pin.collectPin("VP_${vs_signal}") >

        <#local parameters = parameters +
            { "Channel-PWM\\ Generation${idx}\\ No\\ Output" : "TIM_CHANNEL_${idx}" }
            + meta.text( "${vp_pin}.Mode=${mode}" )
            + meta.text( "${vp_pin}.Signal=${vs_signal}")
            >
    </#list>

    <#return parameters + { "Channel" : "TIM_CHANNEL_4" } >
-->
</#function>

