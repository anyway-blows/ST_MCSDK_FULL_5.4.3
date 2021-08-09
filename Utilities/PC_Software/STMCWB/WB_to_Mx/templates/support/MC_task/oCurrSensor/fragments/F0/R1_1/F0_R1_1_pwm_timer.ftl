<#import "../com/F0_pwm_timer.ftl" as cmns>

<#function cs_PWM_TIMER_patameters timer>
    <#return cmns.cs_PWM_TIMER_patameters(timer, [4]) +
        { "CounterMode"              : "TIM_COUNTERMODE_CENTERALIGNED3"}>
</#function>

