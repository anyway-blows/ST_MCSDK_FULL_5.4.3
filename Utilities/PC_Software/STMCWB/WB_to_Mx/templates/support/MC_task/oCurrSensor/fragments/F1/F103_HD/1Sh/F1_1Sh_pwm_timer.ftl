<#import "../../com/F1_pwm_timer.ftl" as cmns>

<#function get_settings motor>
    <#return cmns.cs_TIMER_settings(motor, cs_PWM_TIMER_patameters) >
</#function>

<#function cs_PWM_TIMER_patameters timer>
    <#return cmns.cs_PWM_TIMER_patameters(timer, [4]) +
        { "CounterMode"              : "TIM_COUNTERMODE_CENTERALIGNED3"
        , "LockLevel"                : "TIM_LOCKLEVEL_1"
        <#--, "Pulse-PWM\\ Generation4\\ No\\ Output"      : "${ ( timer.PWM_PERIOD_CYCLES - timer.HTMIN )?floor }"-->
        }>
</#function>

