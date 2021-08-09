<#import "../com/F4_pwm_timer.ftl" as cmns>

<#function get_settings motor>
    <#return cmns.cs_TIMER_settings(motor, cs_PWM_TIMER_patameters) >
</#function>

<#function cs_PWM_TIMER_patameters timer motor>
    <#return cmns.cs_PWM_TIMER_patameters(timer, [4], motor) +
        { "CounterMode"              : "TIM_COUNTERMODE_CENTERALIGNED3"
        , "TIM_MasterOutputTrigger"  : "TIM_TRGO_UPDATE"
        , "LockLevel"                : "TIM_LOCKLEVEL_OFF"
        }>
</#function>

