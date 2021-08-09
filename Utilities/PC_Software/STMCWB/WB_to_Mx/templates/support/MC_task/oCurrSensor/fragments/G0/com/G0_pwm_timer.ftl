<#import "../../../../../utils.ftl" as utils>
<#import "../../../../../fp.ftl" as fp>
<#import "../../../../../ui.ftl" as ui>

<#import "../../../../../../ioc_seed/hw_info.ftl" as hw  >


<#import "../../../../utils/meta_parameters.ftl" as meta>
<#import "../../../../utils/pins_mng.ftl"  as ns_pin>
<#import "../../../../utils/ips_mng.ftl"   as ns_ip>

<#function cs_TIMER_settings motor get_parameter use_aux_tim=false>
    <#import "../../Fx_commons/Fx_pwm_timer_pins.ftl"   as pwm_pins>

    <#local timer = timer_srcs(motor) >
    <#local timer_name = ns_ip.collectIP( timer.name ) >

    <#local general_settings = meta.ip_params_to_str(timer.name, get_parameter(timer)) >

    <#--<#local aux_timer_setting = use_aux_tim?then(cs_AUX_TIMER_settings(motor).settings, {}) >-->
    <#return
        { "settings" :
            { "PWM TIMER settings"               : general_settings
            , "${timer.name} IRQ"                : cs_timer_irq(timer.name)
            <#--Removed: requested by Daniel/Fouad, Email 01/21/2018 -->
            <#--, "${timer.name} TriggerSource_ITR1" : TriggerSource_ITR1(timer.name)-->
            }
            <#--+ aux_timer_setting-->
        , "GPIOs" : pwm_pins.cs_create_timer_pins(timer)
        }>
</#function>
<#--
<#function cs_AUX_TIMER_settings motor>
    <#local timer = timer_srcs(motor) >
    <#local tim_15 = { "name": "TIM15", "idx": 15, "extra_sts_ch": 1 } >
    <#local tim_3  = { "name": "TIM3" , "idx":  3, "extra_sts_ch": 4 } >
    <#local aux_timer = hw.cpu.name?switch
        ( "STM32F051x", tim_15
        , "STM32F072x", tim_15
                      , tim_3
        )>
    <#local timer = timer + aux_timer >
    <#local registered_timer_name = ns_ip.collectIP( timer.name ) >

    <#local aux_settings_parameters =
        { meta.no_chk("Period") : "((PWM_PERIOD_CYCLES) - 1)"
                                            &lt;#&ndash;Formula TIM3 or TIM15 TIMxx.Period = (TIM1.Period * 2)-1 &ndash;&gt;
        , "Prescaler"                : "${ ( timer.TIM_CLOCK_DIVIDER - 1         )?floor }"
        , "RepetitionCounter"        : "${ ( timer.REP_COUNTER                   )?floor }"

        , "AutoReloadPreload"        : "TIM_AUTORELOAD_PRELOAD_DISABLE"
        , "ClockDivision"            : "TIM_CLOCKDIVISION_DIV2"

        , "TIM_MasterOutputTrigger"                                     : "TIM_TRGO_OC${ timer.extra_sts_ch}REF"
        , "Channel-PWM\\ Generation${timer.extra_sts_ch}\\ No\\ Output" : "TIM_CHANNEL_${timer.extra_sts_ch}"
        , "Channel"                                                     : "TIM_CHANNEL_${timer.extra_sts_ch}"
        }>
    <#local str_aux_settings = meta.ip_params_to_str(timer.name, aux_settings_parameters ) >

    &lt;#&ndash; Virtual Pin &ndash;&gt;
    <#local vp_mode   = "Internal"                           >
    <#local vs_signal = "${timer.name}_VS_ClockSourceINT"    >
    <#local vp_pin    = ns_pin.collectPin("VP_${vs_signal}") >

    <#local str_vp_setting =
        [ "${vp_pin}.Mode=${vp_mode}"
        , "${vp_pin}.Signal=${vs_signal}"
        ]?join("\n") >

    <#return
        { "settings" : { "PWM AUX TIMER settings"             : str_aux_settings
                       , "PWM AUX TIMER Virtual Pin settings" : str_vp_setting
                       }
        , "GPIOs" : []
        }>
</#function>-->

<#function TriggerSource_ITR1 timerName>
    <#local sig_mode  = { "ClockSourceITR"        : "TriggerSource_ITR1"
                        , "ControllerModeTrigger" : "Trigger Mode"
                        } >

    <#local vps = {} >
    <#list sig_mode as signal, mode>
        <#local v_signal = "${timerName?upper_case}_VS_${signal}" >
        <#local vp = "VP_${v_signal}" >
        <#local vps = vps +
            { vp : [ "${vp}.Mode=${mode}"
                   , "${vp}.Signal=${v_signal}"
                   ]
            }>
    </#list>

    <#local settigs = fp.flatten(vps?values) >
    <#local limit = (config.syncTimers_min_num_motors)!100  >
    <#if WB_NUM_MOTORS gte limit >
        <#local registered_vps = fp.map(ns_pin.collectPin, vps?keys) >
        <#return settigs?join("\n") >
    <#else>
        <#return ui._comment( (
            [ "According the \"syncTimers_min_num_motors\" flag in the config file,"
            , "the following instructions will be activated when num-motors >= ${limit}"
            , "Currently you are using ${WB_NUM_MOTORS} motor${ WB_NUM_MOTORS?switch(1, '', 's') }"
            ] + settigs
            )?join("\n") )>
    </#if>
</#function>

<#function cs_timer_irq ip>
    <#local irqs =
        { "TIM1" : "TIM1_BRK_UP_TRG_COM"
        <#--, "TIM8" : "TIM8_BRK"-->
        } >

    <#return ns_ip.ip_irq( irqs[ip], [true, 0, 0, false, false, false, true]) >
</#function>


<#function  cs_PWM_TIMER_patameters timer no_outs>

    <#local HALF_PWM_PERIOD = "((PWM_PERIOD_CYCLES) / 2)">

    <#local parameters =
    { "AutoReloadPreload": "TIM_AUTORELOAD_PRELOAD_DISABLE"
    , "AutomaticOutput"  : "TIM_AUTOMATICOUTPUT_DISABLE"

    , meta.blankLn_key() : ""
    , "BreakFilter"      : "${timer.BKIN1_FILTER}"
    , "BreakPolarity"    : "TIM_BREAKPOLARITY_LOW"
    <#--, "BreakState"       : "TIM_BREAK_DISABLE"-->
    , "BreakState"      : "TIM_BREAK_${ (timer.BKIN_MODE=='NONE')?then('DISABLE', 'ENABLE')  }"
    , meta.blankLn_key()  : ""
    , "Break2Filter"      : "${timer.BKIN2_FILTER}"
    <#--, "Break2Polarity"    : "TIM_BREAK2POLARITY_${utils._last_word( timer.OVERCURR_FEEDBACK_POLARITY ) }"-->
    , "Break2Polarity"   : "TIM_BREAK2POLARITY_HIGH"


    , "SourceBRK2DigInput": "TIM_BREAKINPUTSOURCE_${ (timer.BKIN2_MODE=='NONE')?then('DISABLE', 'ENABLE') }"
    , "SourceBRK2DigInputPolarity":"TIM_BREAKINPUTSOURCE_POLARITY_${utils._last_word( timer.OVERCURR_FEEDBACK_POLARITY)}"
    , "Break2AFMode"      : "TIM_BREAK_AFMODE_INPUT"
    , "Break2State"       : "TIM_BREAK2_${ (timer.BKIN2_MODE=='NONE')?then('DISABLE', 'ENABLE')  }"


    , "ClearChannel1"    : ""
    , "ClearChannel2"    : ""
    , "ClearChannel3"    : ""
    , "ClearChannel4"    : ""
    , "ClearChannel5"    : ""
    , "ClearChannel6"    : ""
    , "ClearInputSource" : "TIM_CLEARINPUTSOURCE_NONE"
    , "ClearInputState"  : "ENABLE"
    , "ClockDivision"    : "TIM_CLOCKDIVISION_DIV2"
    , "CounterMode"      : "---TIM_COUNTERMODE_CENTERALIGNED3---"
    <#--, "DeadTime"         : (timer.DEAD_TIME_COUNTS / 2)?floor-->

    , meta.blankLn_key() : ""
    , "LockLevel"      : "TIM_LOCKLEVEL_1"
    , "OCFastMode_PWM" : "TIM_OCFAST_DISABLE"

    , meta.comment_key() : "IDLE_UH_POLARITY"

    , "OCIdleState_1" : "TIM_OCIDLESTATE_${ utils.polarity(timer.HIGH_SIDE_IDLE_STATE, timer.PHASE_UH_POLARITY) }"
    , "OCIdleState_2" : "TIM_OCIDLESTATE_${ utils.polarity(timer.HIGH_SIDE_IDLE_STATE, timer.PHASE_VH_POLARITY) }"
    , "OCIdleState_3" : "TIM_OCIDLESTATE_${ utils.polarity(timer.HIGH_SIDE_IDLE_STATE, timer.PHASE_WH_POLARITY) }"
    , "OCIdleState_4" : "TIM_OCIDLESTATE_RESET"
    , "OCIdleState_5" : "TIM_OCIDLESTATE_RESET"
    , "OCIdleState_6" : "TIM_OCIDLESTATE_RESET"

    , meta.blankLn_key() : ""
    , "OCPolarity_1"     : "TIM_OCPOLARITY_${ utils._last_word( timer.PHASE_UH_POLARITY ) }"
    , "OCPolarity_2"     : "TIM_OCPOLARITY_${ utils._last_word( timer.PHASE_VH_POLARITY ) }"
    , "OCPolarity_3"     : "TIM_OCPOLARITY_${ utils._last_word( timer.PHASE_WH_POLARITY ) }"
    , "OCPolarity_4"     : "TIM_OCPOLARITY_HIGH"
    , "OCPolarity_5"     : "TIM_OCPOLARITY_HIGH"
    , "OCPolarity_6"     : "TIM_OCPOLARITY_HIGH"
    , "OffStateIDLEMode" : "TIM_OSSI_ENABLE"
    , "OffStateRunMode"  : "TIM_OSSR_ENABLE"

    <#--Removed: requested by Maxime DORTEL , Email 02/13/2018
                 CubeMX import failure due to unexpected IOC line  -->
    <#--  , "Pulse"                                 : "0"-->

    <#--
        , "Period"                                : "${ ( timer.HALF_PWM_PERIOD               )?floor }"
        , "Prescaler"                             : "${ ( timer.TIM_CLOCK_DIVIDER - 1         )?floor }"
        , "Pulse-PWM\\ Generation1\\ CH1"         : "${ ( timer.HALF_PWM_PERIOD / 2           )?floor }"
        , "Pulse-PWM\\ Generation2\\ CH2"         : "${ ( timer.HALF_PWM_PERIOD / 2           )?floor }"
        , "Pulse-PWM\\ Generation3\\ CH3"         : "${ ( timer.HALF_PWM_PERIOD / 2           )?floor }"
        , "Pulse-PWM\\ Generation4\\ No\\ Output" : "${ ( timer.HALF_PWM_PERIOD - timer.HTMIN )?floor }"
        , "Pulse-PWM\\ Generation5\\ No\\ Output" : "${ ( timer.HALF_PWM_PERIOD + 1           )?floor }"
        , "Pulse-PWM\\ Generation6\\ No\\ Output" : "${ ( timer.HALF_PWM_PERIOD + 1           )?floor }"
        , "RepetitionCounter"                     : "${ ( timer.REP_COUNTER                   )?floor }"
    -->

    , meta.no_chk("Period"                                ) :  "((PWM_PERIOD_CYCLES) / 2)"
    , meta.no_chk("Prescaler"                             ) :  "((TIM_CLOCK_DIVIDER) - 1)"
    , meta.no_chk("Pulse-PWM\\ Generation1\\ CH1"         ) :  "((PWM_PERIOD_CYCLES) / 4)"
    , meta.no_chk("Pulse-PWM\\ Generation2\\ CH2"         ) :  "((PWM_PERIOD_CYCLES) / 4)"
    , meta.no_chk("Pulse-PWM\\ Generation3\\ CH3"         ) :  "((PWM_PERIOD_CYCLES) / 4)"
    , meta.no_chk("Pulse-PWM\\ Generation4\\ No\\ Output" ) : "(((PWM_PERIOD_CYCLES) / 2) - (HTMIN))"
    , meta.no_chk("Pulse-PWM\\ Generation5\\ No\\ Output" ) : "(((PWM_PERIOD_CYCLES) / 2) + 1)"
    , meta.no_chk("Pulse-PWM\\ Generation6\\ No\\ Output" ) : "(((PWM_PERIOD_CYCLES) / 2) + 1)"
    , meta.no_chk("RepetitionCounter"                     ) : "(REP_COUNTER)"
    , meta.no_chk("DeadTime"                              ) : "((DEAD_TIME_COUNTS) / 2)"

    <#--, "TIM_MasterOutputTrigger"  : "TIM_TRGO_OC4REF"-->
    <#--, "TIM_MasterOutputTrigger2" : "TIM_TRGO2_RESET"-->
    , "TIM_MasterSlaveMode"      : "TIM_MASTERSLAVEMODE_DISABLE"

    , "TIM_SlaveMode"            : "TIM_SLAVEMODE_TRIGGER"

    }>

    <#if timer.LOW_SIDE_SIGNALS_ENABLING == "LS_PWM_TIMER" >
        <#local parameters = parameters +
        { "OCNPolarity_1"     : "TIM_OCNPOLARITY_${ utils._last_word( timer.PHASE_UL_POLARITY ) }"
        , "OCNPolarity_2"     : "TIM_OCNPOLARITY_${ utils._last_word( timer.PHASE_VL_POLARITY ) }"
        , "OCNPolarity_3"     : "TIM_OCNPOLARITY_${ utils._last_word( timer.PHASE_WL_POLARITY ) }"

        , "OCNIdleState_1"    : "TIM_OCNIDLESTATE_${ utils.polarity(timer.LOW_SIDE_IDLE_STATE, timer.PHASE_UL_POLARITY) }"
        , "OCNIdleState_2"    : "TIM_OCNIDLESTATE_${ utils.polarity(timer.LOW_SIDE_IDLE_STATE, timer.PHASE_VL_POLARITY) }"
        , "OCNIdleState_3"    : "TIM_OCNIDLESTATE_${ utils.polarity(timer.LOW_SIDE_IDLE_STATE, timer.PHASE_WL_POLARITY) }"
        } >
    </#if>


<#--
    <#local pattern = "-#idx#-" >
    <#local suffix = (timer.LOW_SIDE_SIGNALS_ENABLING == "LS_PWM_TIMER")?then("\\ CH${pattern}N", "") >
    <#list 1..3 as idx>
        <#local parameters = parameters +
        { "Channel-PWM\\ Generation${idx}\\ CH${idx}${ suffix?replace(pattern, idx?c) }" : "TIM_CHANNEL_${idx}" }
        >
    </#list>
-->

    <#local PWM_Generation_xs                = fp.map_ctx(timer, PWM_Generation_x, 1..3) >
    <#local extra_PWM_Generation_x_No_Output = fp.map_ctx(timer, PWM_Generation_x_No_Output, no_outs) >


    <#local OCMode_Generation_xs                = fp.map_ctx(timer, OCMode_Generation_x, 1..3) >
    <#local extra_OCMode_Generation_x_No_Output = fp.map_ctx(timer, OCMode_Generation_x_No_Output, no_outs) >


    <#return fp.foldl(fp.concat, parameters, PWM_Generation_xs + extra_PWM_Generation_x_No_Output
    + OCMode_Generation_xs + extra_OCMode_Generation_x_No_Output)
    + meta.blankLn("")
    + {"Channel" : "TIM_CHANNEL_${ PWM_Generation_xs?size + extra_PWM_Generation_x_No_Output?size}"}
    >
</#function>



<#function timer_srcs motor>
    <#local timer_name = utils._last_word( utils.v("PWM_TIMER_SELECTION", motor) ) >

    <#local polarities =
        { "UL": utils.v("PHASE_UL_POLARITY", motor), "UH": utils.v("PHASE_UH_POLARITY", motor)
        , "VL": utils.v("PHASE_VL_POLARITY", motor), "VH": utils.v("PHASE_VH_POLARITY", motor)
        , "WL": utils.v("PHASE_WL_POLARITY", motor), "WH": utils.v("PHASE_WH_POLARITY", motor)
        } >

    <#return
        { "name" : timer_name
        , "idx"  : utils._last_char(timer_name)
        , "motor" : motor

        , "polarity" : polarities
        , "PHASE_UL_POLARITY" : polarities.UL, "PHASE_UH_POLARITY" : polarities.UH
        , "PHASE_VL_POLARITY" : polarities.VL, "PHASE_VH_POLARITY" : polarities.VH
        , "PHASE_WL_POLARITY" : polarities.WL, "PHASE_WH_POLARITY" : polarities.WH
        }
        + m_item("LOW_SIDE_SIGNALS_ENABLING"  , motor)
        + m_item("BKIN1_FILTER"               , motor)
        + m_item("BKIN2_FILTER"               , motor)
        + m_item("BKIN2_MODE"                 , motor)
        + m_item("BKIN_MODE"                 , motor)
        + m_item("OVERCURR_FEEDBACK_POLARITY" , motor)
        + m_item("DEAD_TIME_COUNTS"           , motor)

        + m_item("HIGH_SIDE_IDLE_STATE"       , motor)
        + m_item("LOW_SIDE_IDLE_STATE"        , motor)

        + m_item("TIM_CLOCK_DIVIDER"          , motor)
        + m_item("HALF_PWM_PERIOD"            , motor)
        + m_item("HTMIN"                      , motor)
        + m_item("REP_COUNTER"                , motor)
        >
</#function>

<#function m_item item m>
    <#return { item : utils.v(item , m) } >
</#function>


<#function PWM_Generation_x timer idx>
    <#local suffix = (timer.LOW_SIDE_SIGNALS_ENABLING == "LS_PWM_TIMER")?then("\\ CH${idx}N", "") >
    <#return { "Channel-PWM\\ Generation${idx}\\ CH${idx}${ suffix }" : "TIM_CHANNEL_${idx}" } >
</#function>

<#function PWM_Generation_x_No_Output timer idx>
    <#local mode      = "PWM Generation${idx} No Output"     >
    <#local vs_signal = "${timer.name}_VS_no_output${idx}"   >
    <#local vp_pin    = ns_pin.collectPin("VP_${vs_signal}") >

    <#return meta.blankLn("")
        + { "Channel-PWM\\ Generation${idx}\\ No\\ Output" : "TIM_CHANNEL_${idx}" }
        + meta.text( "${vp_pin}.Mode=${mode}" )
        + meta.text( "${vp_pin}.Signal=${vs_signal}")
        >
</#function>


<#function OCMode_Generation_x timer idx>
    <#local suffix = (timer.LOW_SIDE_SIGNALS_ENABLING == "LS_PWM_TIMER")?then("\\ CH${idx}N", "") >
    <#return { "OCMode_PWM-PWM\\ Generation${idx}\\ CH${idx}${ suffix }" : "TIM_OCMODE_PWM1" } >
</#function>

<#function OCMode_Generation_x_No_Output timer idx>
    <#local mode      = "PWM Generation${idx} No Output"     >
    <#local vs_signal = "${timer.name}_VS_no_output${idx}"   >
    <#local vp_pin    = ns_pin.collectPin("VP_${vs_signal}") >

    <#return meta.blankLn("")
    + { "OCMode_PWM-PWM\\ Generation${idx}\\ No\\ Output" : "TIM_OCMODE_PWM2" }
    <#--+ meta.text( "${vp_pin}.Mode=${mode}" )
    + meta.text( "${vp_pin}.Signal=${vs_signal}")-->
    >
</#function>
