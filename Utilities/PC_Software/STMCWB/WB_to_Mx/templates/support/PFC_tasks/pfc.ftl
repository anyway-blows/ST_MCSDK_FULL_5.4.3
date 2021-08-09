<#import "../utils.ftl"                                       as utils  >
<#import "../MC_task/utils/meta_parameters.ftl"               as meta   >
<#import "../MC_task/utils/ips_mng.ftl"                       as ns_ip  >
<#import "../MC_task/utils/pins_mng.ftl"                      as ns_pin >
<#import "../fp.ftl"                                          as fp     >
<#import "../ui.ftl"                                          as ui     >



<#function adc_pin_setting port pin ch_idx>
    <#local pin = ns_pin.name(port, pin) >
    <#local pin_setting =
                           [ "# ${pin}"
                           , "${pin}.Locked=true"
                           , "${pin}.Signal=${WB_PFC_ADC}_IN${ch_idx}"
                           ]>

    <#local s_signal = "ADCx_IN${ch_idx}" >
    <#local signal   = "${WB_PFC_ADC}_IN${ch_idx}" >

    <#local signal_settings =
                                [ "#SH_${WB_PFC_ADC}"
                                , "SH.${s_signal}.0=${signal},IN${ch_idx}"
                                , "SH.${s_signal}.ConfNb=1"
                                ]>

    <#return pin_setting + signal_settings>
</#function>

<#function pwm_pin_setting>
     <#local pin = ns_pin.name(WB_PWMPORT, WB_PWMPIN) >

     <#local pin_setting =
                            [ "# ${pin}"
                            , "${pin}.GPIOParameters=GPIO_Speed"
                            , "${pin}.GPIO_Speed=GPIO_SPEED_FREQ_HIGH"
                            , "${pin}.Locked=true"
                            , "${pin}.Signal=S_${WB_PFCTIMER}_CH2"
                            ]>

    <#local signal_settings =
                             [ "#SH_${WB_PFCTIMER}_CH2"
                              , "SH.S_${WB_PFCTIMER}_CH2.0=${WB_PFCTIMER}_CH2,PWM Generation2 CH2"
                              , "SH.S_${WB_PFCTIMER}_CH2.ConfNb=1"
                             ]>

    <#return pin_setting + signal_settings>
</#function>


<#function ac_pin_setting>
    <#local pin = ns_pin.name(WB_SYNCPORT, WB_SYNCPIN) >
    <#local pin_setting =
                         [ "# ${pin}"
                         , "${pin}.Locked=true"
                         , "${pin}.Signal=S_${WB_PFCTIMER}_CH1"
                         ]>

    <#local signal_settings =
                            [ "#SH_${WB_PFCTIMER}_CH1"
                            , "SH.S_${WB_PFCTIMER}_CH1.0=${WB_PFCTIMER}_CH1,Input_Capture1_from_TI1"
                            , "SH.S_${WB_PFCTIMER}_CH1.ConfNb=1"
                            ]>

    <#return pin_setting + signal_settings>
</#function>

<#function ocs_pin_setting>
    <#local pin = ns_pin.name(WB_FAULTPORT, WB_FAULTPIN) >
    <#local pin_setting =
                        [ "# ${pin}"
                        , "${pin}.Locked=true"
                        , "${pin}.Signal=S_${WB_PFCTIMER}_ETR"
                        ]>

    <#local signal_settings =
                            [ "#SH_${WB_PFCTIMER}_ETR"
                            , "SH.S_${WB_PFCTIMER}_ETR.0=${WB_PFCTIMER}_ETR,TriggerSource_ETR"
                            , "SH.S_${WB_PFCTIMER}_ETR.ConfNb=1"
                            ]>
    <#return pin_setting + signal_settings>
</#function>


<#function tim_etr_polarity wb_define>
    <#return wb_define?lower_case?contains("noninverted")?then("NONINVERTED", "INVERTED") >
</#function>

<#function tim_setting>

    <#local pin = ns_pin.name(WB_PWMPORT, WB_PWMPIN) >
    <#local timName     = WB_PFCTIMER ! "TIM3">
    <#local registered_timer_name = ns_ip.collectIP( timName ) >

    <#local adv_tim_pwm      = "((TIM_CLK) / (PFC_PWMFREQ))" >
    <#local half_adv_tim_pwm = "(${adv_tim_pwm} / 2)" >
    <#local adv_tim_adc = "((TIM_CLK) / (ADC_CLK_MHz*1000000))" >
    <#local pulse = "(TIM_CLK * ( ((15.0 + 2.0 * PFC_ISAMPLINGTIMEREAL)/(ADC_CLK_MHz*1000000)) + (1.0/(2.0*PFC_PWMFREQ)) ))" >

    <#local xs =
        { "AutoReloadPreload                         " : "TIM_AUTORELOAD_PRELOAD_DISABLE"
        , "Channel-Input_Capture1_from_TI1           " : "TIM_CHANNEL_1"
        , "Channel-PWM\\ Generation2\\ CH2           " : "TIM_CHANNEL_2"
        , "Channel-PWM\\ Generation3\\ No\\ Output   " : "TIM_CHANNEL_3"
        , "Channel-PWM\\ Generation4\\ No\\ Output   " : "TIM_CHANNEL_4"
        , "Channel.Ext                               " : "TIM_CHANNEL_4"
        , "ClockDivision                             " : "TIM_CLOCKDIVISION_DIV4"
        , "CounterMode.Ext                           " : "TIM_COUNTERMODE_UP"
        , "ICPolarity_CH1                            " : "TIM_INPUTCHANNELPOLARITY_FALLING"
        , "ICPrescaler.Ext                           " : "TIM_ICPSC_DIV1"
        , "ICSelection.Ext                           " : "TIM_ICSELECTION_DIRECTTI"
        , "OCFastMode_PWM.Ext                        " : "TIM_OCFAST_DISABLE"
        , "OCMode_PWM-PWM\\ Generation3\\ No\\ Output" : "TIM_OCMODE_PWM2"
        , "OCMode_PWM-PWM\\ Generation4\\ No\\ Output" : "TIM_OCMODE_PWM2"
        , "OCMode_PWM.Ext                            " : "TIM_OCMODE_PWM1"
        , "OCPolarity_2                              " : "TIM_OCPOLARITY_${utils._last_word(WB_PWMPOLARITY)?upper_case}"
        , "OCPolarity_3.Ext                          " : "TIM_OCPOLARITY_HIGH"
        , "OCPolarity_4.Ext                          " : "TIM_OCPOLARITY_HIGH"

        , "Prescaler.Ext                             " : "0"
        , "Pulse.Ext                                 " : "0"

        , meta.no_chk("ICFilter_CH1"                          ) : "PFC_SYNCFILTER_IC"
        , meta.no_chk("Slave_TriggerFilter"                   ) : "PFC_ETRFILTER_IC"
        , meta.no_chk("Period"                                ) : "(${adv_tim_pwm} - 1)"
        , meta.no_chk("Pulse-PWM\\ Generation3\\ No\\ Output" ) : "${pulse}"
        , meta.no_chk("Pulse-PWM\\ Generation4\\ No\\ Output" ) : "${half_adv_tim_pwm}"
        , "Slave_TriggerPolarity                     " : "TIM_TRIGGERPOLARITY_${ tim_etr_polarity( WB_ETRPOLARITY! ) }"
        , "Slave_TriggerPolarity.Ext                 " : "TIM_TRIGGERPOLARITY_NONINVERTED"
        , "Slave_TriggerPrescaler.Ext                " : "TIM_TRIGGERPRESCALER_DIV1"
        , "TIM_MasterOutputTrigger.Ext               " : "TIM_TRGO_RESET"
        , "TIM_MasterSlaveMode.Ext                   " : "TIM_MASTERSLAVEMODE_DISABLE"
        , "TIM_SlaveMode.Ext                         " : "TIM_SLAVEMODE_RESET"

        <#--      , meta.comment_key() :                    "vALORI cALCOLATI"-->
        }>
    <#return meta._ip_params_to_str(timName, xs) >
</#function>

 <#function build_VPs>
        <#local sig_mode_s  =
        { "ControllerModeReset" : "Reset Mode"
        , "no_output3" : "PWM Generation3 No Output"
        , "no_output4" : "PWM Generation4 No Output" }>

        <#local vps = {} >
        <#list sig_mode_s as signal, mode>
                <#local v_signal = "${WB_PFCTIMER?upper_case}_VS_${signal}" >
                <#local vp = "VP_${v_signal}" >
                <#local vps = vps +
                { vp : [ "${vp}.Mode=${mode}"
                , "${vp}.Signal=${v_signal}"
                ]
                }>
        </#list>

        <#local registered_vps = fp.map(ns_pin.collectPin, vps?keys) >

        <#return fp.flatten(vps?values)?join("\n") >
</#function>

<#function IRQ>
    <#import "../names_map.ftl" as rr>
    <#local set_irq_pfc_timer = rr["SET_IRQ_PFCTIMER"]!([true, 1, 0, false, false, false, true]) >

    <#return  ns_ip.ip_irq(WB_PFCTIMER, set_irq_pfc_timer)>
</#function>


<#function DMA_PFC>
    <#return {"dma_request": "TIM3_CH4/UP", "channel": "DMA1_Channel3", "direction": "DMA_MEMORY_TO_PERIPH", "priority": "HIGH" ,  "mem_inc" : "DISABLE" , "allignment" : "WORD"} >
</#function>
