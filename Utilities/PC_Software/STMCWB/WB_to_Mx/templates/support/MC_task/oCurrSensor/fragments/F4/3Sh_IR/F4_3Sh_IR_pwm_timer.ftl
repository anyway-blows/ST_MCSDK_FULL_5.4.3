<#import "../com/F4_pwm_timer.ftl" as cmns>

<#function get_settings motor>
    <#return cmns.cs_TIMER_settings(motor, cs_PWM_TIMER_patameters) >
</#function>

<#function cs_PWM_TIMER_patameters timer motor>
    <#local motor_n = (motor == 2)?then ("2","")>
    <#import "../../../../utils/meta_parameters.ftl" as meta>
    <#return cmns.cs_PWM_TIMER_patameters(timer, [4], motor) +
        { "CounterMode"              : "TIM_COUNTERMODE_CENTERALIGNED1"
        , "TIM_MasterOutputTrigger"  : "TIM_TRGO_RESET"
        , "LockLevel"                : "TIM_LOCKLEVEL_1"

        , meta.no_chk("Pulse-PWM\\ Generation1\\ CH1") : "((PWM_PERIOD_CYCLES${motor_n}) / 4)"
        , meta.no_chk("Pulse-PWM\\ Generation2\\ CH2") : "((PWM_PERIOD_CYCLES${motor_n}) / 4)"
        , meta.no_chk("Pulse-PWM\\ Generation3\\ CH3") : "((PWM_PERIOD_CYCLES${motor_n}) / 4)"
        }>
</#function>

