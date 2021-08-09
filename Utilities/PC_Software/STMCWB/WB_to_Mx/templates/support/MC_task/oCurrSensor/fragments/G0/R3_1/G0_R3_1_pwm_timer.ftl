<#import "../com/G0_pwm_timer.ftl" as cmns>

<#function cs_PWM_TIMER_patameters timer>
    <#return cmns.cs_PWM_TIMER_patameters(timer, [4]) +
        { "TIM_MasterOutputTrigger"  : "TIM_TRGO_OC4REF"
        , "CounterMode"              : "TIM_COUNTERMODE_CENTERALIGNED1"
        , "TIM_MasterOutputTrigger2" : "TIM_TRGO2_RESET"
        }>
</#function>

