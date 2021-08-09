<#import "../../../../../../utils.ftl" as utils>
<#import "../../../../../utils/ips_mng.ftl" as ns_ip>
<#import "../../../../../utils/meta_parameters.ftl" as meta>
<#import "../../com/F1_pwm_timer.ftl" as cmns_tmr>

<#function get_settings motor>

    <#local timer = cmns_tmr.timer_srcs(motor) + cs_F1_aux_timer(motor) >

    <#local registered_timer_name = ns_ip.collectIP( timer.name ) >

    <#local aux_settings_parameters =
        { meta.no_chk("Period")            : "((PWM_PERIOD_CYCLES) - 1)"
        , meta.no_chk("Prescaler")         : "((TIM_CLOCK_DIVIDER) - 1)"
        , meta.no_chk("RepetitionCounter") : "REP_COUNTER"

        , "ClockDivision"            : "TIM_CLOCKDIVISION_DIV2"

        , "TIM_MasterOutputTrigger"  : "TIM_TRGO_OC${timer.extra_sts_ch}REF"
        <#--, "TIM_MasterOutputTrigger"  : "TIM_TRGO_OC3REF"-->

        , "Channel-PWM\\ Generation${   timer.extra_sts_ch}\\ No\\ Output" : "TIM_CHANNEL_${timer.extra_sts_ch}"
        , "OCMode_PWM-PWM\\ Generation${timer.extra_sts_ch}\\ No\\ Output" : "TIM_OCMODE_PWM2"
        , "Pulse-PWM\\ Generation${     timer.extra_sts_ch}\\ No\\ Output" : "0"
        }>

    <#local str_aux_settings = meta.ip_params_to_str(timer.name, aux_settings_parameters ) >

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

<#function cs_F1_aux_timer motor>
    <#local MD_mcu = (utils._last_word(WB_MCU_TYPE)?upper_case !"") >
        <#return (MD_mcu == "MD")?then
        ( {"name": "TIM4" , "idx": 4, "extra_sts_ch": 3}
        , {"name": "TIM3" , "idx": 3, "extra_sts_ch": 4}
        )>
</#function>

<#function cs_F1_aux_timer_idx motor>
    <#return cs_F1_aux_timer(motor).idx >
</#function>


<#function cs_F1_aux_timer_name motor>
    <#return cs_F1_aux_timer(motor).name >
</#function>

