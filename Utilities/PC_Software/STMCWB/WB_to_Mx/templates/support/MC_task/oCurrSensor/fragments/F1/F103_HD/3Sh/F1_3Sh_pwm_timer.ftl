<#import "../../com/F1_pwm_timer.ftl" as cmns>

<#function get_settings motor>
    <#return cmns.cs_TIMER_settings(motor, cs_PWM_TIMER_patameters) >
</#function>

<#function cs_PWM_TIMER_patameters timer>
    <#return cmns.cs_PWM_TIMER_patameters(timer, [4]) +
        { "CounterMode"              : "TIM_COUNTERMODE_CENTERALIGNED1"
        , "TIM_MasterOutputTrigger"  : "TIM_TRGO_RESET"
        , "LockLevel"                : "TIM_LOCKLEVEL_1"
        }>
</#function>

