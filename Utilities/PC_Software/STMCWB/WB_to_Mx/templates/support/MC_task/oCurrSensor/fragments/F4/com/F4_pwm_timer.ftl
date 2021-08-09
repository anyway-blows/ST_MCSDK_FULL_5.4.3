<#import "../../../../../../config.ftl" as config>
<#import "../../../../../utils.ftl" as utils>
<#import "../../../../../fp.ftl" as fp>
<#import "../../../../../ui.ftl" as ui>

<#import "../../../../utils/meta_parameters.ftl" as meta>
<#import "../../../../utils/pins_mng.ftl"  as ns_pin>
<#import "../../../../utils/ips_mng.ftl"   as ns_ip>

<#function cs_TIMER_settings motor get_parameter>
    <#import "../../Fx_commons/Fx_pwm_timer_pins.ftl"   as pwm_pins>

    <#local timer = timer_srcs(motor) >
    <#local timer_name = ns_ip.collectIP( timer.name ) >

    <#local general_settings = meta.ip_params_to_str(timer.name, get_parameter(timer, motor)) >

    <#return
        { "settings" :
            { "PWM TIMER settings"               : general_settings
            , "${timer.name} IRQ"                : cs_timer_irq(timer.name)
            , "${timer.name} TriggerSource_ITR1" : TriggerSource_ITR1(timer.name)
            }
        , "GPIOs" : pwm_pins.cs_create_timer_pins(timer)
        }>
</#function>


<#function build_VPs timerName, sig_mode_s, register_pins = true>
    <#local vps = {} >
    <#list sig_mode_s as signal, mode>
        <#local v_signal = "${timerName?upper_case}_VS_${signal}" >
        <#local vp = "VP_${v_signal}" >
        <#local vps = vps +
                    { vp : [ "${vp}.Mode=${mode}"
                           , "${vp}.Signal=${v_signal}"
                           ]
                    }>
    </#list>

    <#if register_pins >
        <#local registered_vps = fp.map(ns_pin.collectPin, vps?keys) >
    </#if>

    <#return fp.flatten(vps?values)?join("\n") >
</#function>




<#function TriggerSource_ITR1 timerName>
    <#local limit = (config.syncTimers_min_num_motors)!100  >
    <#local use_vps = WB_NUM_MOTORS gte limit >

    <#local sig_mode  =
        { "ClockSourceITR"        : "TriggerSource_ITR1"
        , "ControllerModeTrigger" : "Trigger Mode"       }>
    <#local str_settigs = build_VPs(timerName, sig_mode, use_vps) >

    <#if use_vps >
        <#return str_settigs >
    <#else>
        <#return ui._comment(
            [ "According the \"syncTimers_min_num_motors\" flag in the config file,"
            , "the following instructions will be activated when num-motors >= ${limit}"
            , "Currently you are using ${WB_NUM_MOTORS} motor${ WB_NUM_MOTORS?switch(1, '', 's') }"
            ]?join("\n")
            + str_settigs)>
    </#if>
</#function>

<#function cs_timer_irq ip>
    <#local irqs =
        { "TIM1"     : "TIM1_UP_TIM10"
        , "TIM8"     : "TIM8_UP_TIM13"
        , "TIM1_BRK" : "TIM1_BRK_TIM9"
        , "TIM8_BRK" : "TIM8_BRK_TIM12"
        } >

    <#import "../../../../../names_map.ftl" as rr>
    <#local set_irq_tim = rr["SET_IRQ_TIM"]!([true, 0, 0, false, true, false, true]) >

    <#local set_irq_tim_brk = rr["SET_IRQ_TIM_BRK"]!([true, 4, 1, false, true, false, true]) >

    <#return [ ns_ip.ip_irq( irqs[ip          ], set_irq_tim)
             , ns_ip.ip_irq( irqs["${ip}_BRK"], set_irq_tim_brk)
             ]?join("\n") >

<#--    <#return [ ns_ip.ip_irq( irqs[ip         ], [true, 0, 0, false, true, false, true])
             , ns_ip.ip_irq( irqs["${ip}_BRK"], [true, 4, 1, false, true, false, true])
             ]?join("\n") >-->
</#function>

<#function cs_PWM_TIMER_patameters timer no_outs motor>

    <#local motor_n = (motor == 2)?then ("2","")>

    <#local parameters =
    {
      "BreakState"      : "TIM_BREAK_${ (timer.BKIN_MODE=='NONE')?then('DISABLE', 'ENABLE')  }"
    , "BreakPolarity"   : "TIM_BREAKPOLARITY_${utils._last_word( timer.OVERCURR_FEEDBACK_POLARITY ) }"
    <#--"BreakPolarity"                              : "TIM_BREAKPOLARITY_LOW"-->
    , meta.blankLn_key()                           : ""
    , "ClockDivision"                              : "TIM_CLOCKDIVISION_DIV2"
    , "CounterMode"                                : "---TIM_COUNTERMODE_CENTERALIGNED3---"
    , meta.blankLn_key()                           : ""
    , "LockLevel"                                  : "---TIM_LOCKLEVEL_OFF---"
    , "OCMode_PWM-PWM\\ Generation4\\ No\\ Output" : "TIM_OCMODE_PWM2"
    , "OffStateIDLEMode"                           : "TIM_OSSI_ENABLE"
    , "OffStateRunMode"                            : "TIM_OSSR_ENABLE"

    , meta.blankLn_key()                           : ""

<#--
    , "Period"                                     : "HALF_PWM_PERIOD"
    , "Prescaler"                                  : "${ ( timer.TIM_CLOCK_DIVIDER - 1         )?floor }"
    , "Pulse-PWM\\ Generation4\\ No\\ Output"      : "${ ( timer.HALF_PWM_PERIOD - timer.HTMIN )?floor }"
    , "RepetitionCounter"                          : "${ ( timer.REP_COUNTER                   )?floor }"
-->
    , meta.no_chk("Period"                                ) : "((PWM_PERIOD_CYCLES${motor_n}) / 2)"
    , meta.no_chk("Prescaler"                             ) : "((TIM_CLOCK_DIVIDER${motor_n}) - 1)"
    , meta.no_chk("Pulse-PWM\\ Generation4\\ No\\ Output" ) : "(((PWM_PERIOD_CYCLES${motor_n}) / 2) - (HTMIN${motor_n}))"
    , meta.no_chk("RepetitionCounter"                     ) : "(REP_COUNTER${motor_n})"
    , meta.no_chk("DeadTime"                              ) : "((DEAD_TIME_COUNTS${motor_n}) / 2)"

    , "TIM_MasterOutputTrigger"                    : "---TIM_TRGO_RESET---"

<#--
    Ticket 48299
    https://intbugzilla.st.com/show_bug.cgi?id=48299
-->
    , "OCPolarity_1"  : "TIM_OCPOLARITY_${ utils._last_word( timer.PHASE_UH_POLARITY ) }"
    , "OCPolarity_2"  : "TIM_OCPOLARITY_${ utils._last_word( timer.PHASE_VH_POLARITY ) }"
    , "OCPolarity_3"  : "TIM_OCPOLARITY_${ utils._last_word( timer.PHASE_WH_POLARITY ) }"

    , "OCIdleState_1" : "TIM_OCIDLESTATE_${ utils.polarity(timer.HIGH_SIDE_IDLE_STATE, timer.PHASE_UH_POLARITY) }"
    , "OCIdleState_2" : "TIM_OCIDLESTATE_${ utils.polarity(timer.HIGH_SIDE_IDLE_STATE, timer.PHASE_VH_POLARITY) }"
    , "OCIdleState_3" : "TIM_OCIDLESTATE_${ utils.polarity(timer.HIGH_SIDE_IDLE_STATE, timer.PHASE_WH_POLARITY) }"
    }>

    <#if timer.LOW_SIDE_SIGNALS_ENABLING == "LS_PWM_TIMER" >
        <#local parameters = parameters +
        { "OCNPolarity_1"  : "TIM_OCNPOLARITY_${ utils._last_word( timer.PHASE_UL_POLARITY ) }"
        , "OCNPolarity_2"  : "TIM_OCNPOLARITY_${ utils._last_word( timer.PHASE_VL_POLARITY ) }"
        , "OCNPolarity_3"  : "TIM_OCNPOLARITY_${ utils._last_word( timer.PHASE_WL_POLARITY ) }"

        , "OCNIdleState_1" : "TIM_OCNIDLESTATE_${ utils.polarity(timer.LOW_SIDE_IDLE_STATE, timer.PHASE_UL_POLARITY) }"
        , "OCNIdleState_2" : "TIM_OCNIDLESTATE_${ utils.polarity(timer.LOW_SIDE_IDLE_STATE, timer.PHASE_VL_POLARITY) }"
        , "OCNIdleState_3" : "TIM_OCNIDLESTATE_${ utils.polarity(timer.LOW_SIDE_IDLE_STATE, timer.PHASE_WL_POLARITY) }"
        } >
    </#if>



    <#local PWM_Generation_xs                = fp.map_ctx(timer, PWM_Generation_x, 1..3) >
    <#local extra_PWM_Generation_x_No_Output = fp.map_ctx(timer, PWM_Generation_x_No_Output, no_outs) >

<#--
    <#import "../../../../utils/user_constants.ftl" as mcu>
    <#local _period     = mcu.define("HALF_PWM_PERIOD"      , timer.HALF_PWM_PERIOD?floor)>
-->

    <#return fp.foldl(fp.concat, parameters, PWM_Generation_xs + extra_PWM_Generation_x_No_Output )
        <#--+ meta.blankLn("")-->
        <#--+ {"Channel" : "TIM_CHANNEL_${ PWM_Generation_xs?size + extra_PWM_Generation_x_No_Output?size}"}-->
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
        + m_item("BKIN_MODE"                  , motor)
        + m_item("OVERCURR_FEEDBACK_POLARITY" , motor)
        + m_item("DEAD_TIME_COUNTS"           , motor)

        + m_item("HIGH_SIDE_IDLE_STATE"       , motor)
        + m_item("LOW_SIDE_IDLE_STATE"        , motor)

       <#-- + m_item("TIM_CLOCK_DIVIDER"          , motor)
        + m_item("HALF_PWM_PERIOD"            , motor)
        + m_item("HTMIN"                      , motor)
        + m_item("REP_COUNTER"                , motor)-->
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
