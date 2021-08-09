<#import "../../../../../utils.ftl" as utils>
<#import "../../../../utils/ips_mng.ftl" as ns_ip>
<#import "../../../../utils/meta_parameters.ftl" as meta>
<#import "../com/F4_pwm_timer.ftl" as cmns_tmr>

<#function get_settings motor>
<#--
    <#local timer     = cmns_tmr.timer_srcs(motor) >
    <#local aux_timer = cs_F4_aux_timer(motor)     >
    <#local timer     = timer + aux_timer          >
-->
    <#local timer = cmns_tmr.timer_srcs(motor) + cs_F4_aux_timer(motor) >

    <#local registered_timer_name = ns_ip.collectIP( timer.name ) >

    <#local motor_n = (motor == 2)?then ("2","")>
    <#--<#import "../../../../utils/user_constants.ftl" as mcu>-->
    <#--<#local _define_HALF_PWM_PERIOD_MINUS_1 = mcu.define("HALF_PWM_PERIOD_MINUS_1", "((HALF_PWM_PERIOD) - 1)" )>-->

    <#local aux_settings_parameters =
        { meta.no_chk("Period"           ) : "(((PWM_PERIOD_CYCLES${motor_n}) / 2) - 1)"
        , meta.no_chk("Prescaler"        ) : "((TIMAUX_CLOCK_DIVIDER${motor_n}) - 1)"
        , meta.no_chk("RepetitionCounter") : "(REP_COUNTER${motor_n})"

        , "ClockDivision"            : "TIM_CLOCKDIVISION_DIV2"

        , "TIM_MasterOutputTrigger"  : "TIM_TRGO_OC${timer.extra_sts_ch}REF"

        , "Channel-PWM\\ Generation${   timer.extra_sts_ch}\\ No\\ Output" : "TIM_CHANNEL_${timer.extra_sts_ch}"
        , "OCMode_PWM-PWM\\ Generation${timer.extra_sts_ch}\\ No\\ Output" : "TIM_OCMODE_PWM2"
        }>

    <#local str_aux_settings = meta.ip_params_to_str(timer.name, aux_settings_parameters ) >

<#-- Virtual Pin -->
<#--
    VP_TIM5_VS_ClockSourceITR.Mode          = TriggerSource_ITR0
    VP_TIM5_VS_ClockSourceITR.Signal        = TIM5_VS_ClockSourceITR
    VP_TIM5_VS_ControllerModeTrigger.Mode   = Trigger Mode
    VP_TIM5_VS_ControllerModeTrigger.Signal = TIM5_VS_ControllerModeTrigger
    VP_TIM5_VS_no_output4.Mode              = PWM Generation4 No Output
    VP_TIM5_VS_no_output4.Signal            = TIM5_VS_no_output4
-->

    <#--
        According Bug [Ticket 44527](https://intbugzilla.st.com/show_bug.cgi?id=44527)
        and the datasheet,
        TriggerSource for `TIM4` has to be `ITR1` while for `TIM5` has to be `ITR0`
        -->
    <#local ITRx = (timer.name == "TIM5")?then("ITR0","ITR1") >

    <#local str_vp_setting = cmns_tmr.build_VPs(timer.name,
        { "ClockSourceITR"                 : "TriggerSource_${ITRx}"
        , "ControllerModeTrigger"          : "Trigger Mode"
        , "no_output${timer.extra_sts_ch}" : "PWM Generation${timer.extra_sts_ch} No Output"
        })>

    <#return
        { "settings" : { "PWM AUX TIMER settings"             : str_aux_settings
                       , "PWM AUX TIMER Virtual Pin settings" : str_vp_setting
        }
        , "GPIOs"    : []
        }>
</#function>

<#function cs_F4_aux_timer motor>
    <#local adc_name = utils.v("ADC_PERIPH", motor)>
    <#return (adc_name == "ADC3")?then
        ( {"name": "TIM5",  "idx": 5, "extra_sts_ch": 4}
        , {"name": "TIM4" , "idx": 4, "extra_sts_ch": 2}
        )>
</#function>
<#function cs_F4_aux_timer_idx motor>
    <#return cs_F4_aux_timer(motor).idx >
</#function>
<#function cs_F4_aux_timer_name motor>
    <#return cs_F4_aux_timer(motor).name >
</#function>
