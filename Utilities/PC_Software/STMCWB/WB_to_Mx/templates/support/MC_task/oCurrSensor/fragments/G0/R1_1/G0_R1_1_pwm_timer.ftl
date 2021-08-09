<#import "../com/G0_pwm_timer.ftl" as cmns>

<#function cs_PWM_TIMER_patameters timer>
    <#return cmns.cs_PWM_TIMER_patameters(timer, 4..6) +
        { "CounterMode"              : "TIM_COUNTERMODE_CENTERALIGNED3"
        , "TIM_MasterOutputTrigger"  : "TIM_TRGO_RESET"
        , "TIM_MasterOutputTrigger2" : "TIM_TRGO2_OC5REF_RISING_OC6REF_RISING"}
    >
</#function>

