<#import "../ui.ftl" as ui >
<#import "../shared_ip/ip_overlap.ftl" as ip_ov>
<#import "../../support/MC_task/utils/ips_mng.ftl" as ns_ip >
<#import "../fp.ftl"                     as fp     >

<#macro ui_dac title>
    <@ui.boxed title>
        <@ui.line dac_settings() />
    </@ui.boxed>
</#macro>


<#function dac_settings>

    <#local dacName = DAC1!"DAC1" >

    <#if DAC_EMULATED!false >
        <#import "../UI_tasks/ui_dac_emulated.ftl"                   as emu_dac >
        <#import "../../support/MC_task/utils/meta_parameters.ftl"   as meta    >
        <#import "../../support/MC_task/utils/pins_mng.ftl"          as ns_pin  >
        <#import "../utils.ftl" as utils>

        <#local timer = ns_ip.collectIP( DAC_TIMER_SELECTION ) >

        <#local parameters = emu_dac.dac_emulated_settings(timer)>

        <#local gpios = []>

        <#local chs = [] >


        <#if DEBUG_DAC_CH1 >
            <#local ch1 = (WB_DAC_EMULATED_1?has_content)?then( utils._last_word(WB_DAC_EMULATED_1,""),3) >
            <#local chs += [ { "idx": 1, "ch": ch1}]>
        </#if>
        <#if DEBUG_DAC_CH2 >
            <#local ch2 = (WB_DAC_EMULATED_2?has_content)?then( utils._last_word(WB_DAC_EMULATED_2,""),4) >
            <#local chs += [ { "idx": 2, "ch": ch2 }]>
        </#if>

        <#list chs as x>
            <#local gpioLabel  = "DAC_EMUL_CH${ x.idx }" >
            <#local gpioSignal = "${timer}_CH${ x.ch }" >
            <#local gpioMode   = "PWM Generation${x.ch} CH${x.ch}" >

            <#local baseRet =
            { "name"   : ns_pin.name2(1, "DAC_TIMER_CH${ x.idx }")
            , "label"  : gpioLabel
            , "signal" : gpioSignal
            , "mode"   : gpioMode
            , "customLabel":true
            , "ip"     : {"name": timer, "pin": "CH${ x.idx }" }
            }>
            <#local gpios += [baseRet]>

            <#if timer!="TIM14">
                <#local pwm_generation = "-PWM\\ Generation${x.ch}\\ CH${x.ch}">
                <#local parameters +=
                { "OCMode_PWM${     pwm_generation}" : "TIM_OCMODE_PWM1"
                , "Pulse${          pwm_generation}" : "0x400"
                , "OCFastMode_PWM${ pwm_generation}" : "TIM_OCFAST_DISABLE"
                , "OCPolarity_${              x.ch}" : "TIM_OCPOLARITY_HIGH"
                }>
            <#else>
                <#local VPs = build_VPs()>
            </#if>
        </#list>

        <#local store_for_later_use_dac_settings = ip_ov.update_IP_parameters(ns_ip.IP_settings
            ( "DAC Emulation with ${ timer } - settings"
            , timer
            , parameters
            ))>


        <#import "../../support/MC_task/utils/mcu_pin_setting_mng.ftl" as cs >
        <#import "../fp.ftl" as fp >
        <#local stored_gpios_settings = fp.map(cs.storePinConfig, gpios) >
        <#local store_for_later_use = cs.add_motor_info(1) >
        <#local pin_config_db = cs.condolidate_fuse_motors()>

        <#local ret = cs.genetate_pin_setting( pin_config_db ) />
        <#local emptyDB = cs.resetDB() >
        <#if timer != "TIM14">
            <#return ret  >
        <#else>
            <#return [ret + ("\n") + VPs] >
        </#if>
    <#else>
        <#local sx = []>

        <#if WB_DEBUG_DAC_CH1 >
            <#local sx = sx + dac_gpio(ns_ip.collectIP(dacName), "1") >
            <#local tmp = postponed_dac_settings(dacName, "1") >
        </#if>

        <#if WB_DEBUG_DAC_CH2 >
            <#local sx = sx + [""] + dac_gpio(ns_ip.collectIP(dacName), "2") >
            <#local tmp = postponed_dac_settings(dacName, "2") >
        </#if>

        <#return sx >
    </#if>
</#function>

<#function postponed_dac_settings dac dac_ch>

    <#import "../names_map.ftl" as rr>

    <#local dac_setting_key_suffix = (dac_ch=="2")?then("2", "") >

    <#local DAC_Trigger_key_suffix = rr["DAC_Trigger_key_suffix"]!"${dac_setting_key_suffix}" >

    <#--<#local DAC_OutputBuffer_key_suffix = rr["DAC_OutputBuffer_key_suffix"]!"${dac_setting_key_suffix}" >-->

<#--Viene chiamata quando DAC in Debug-->
    <#local dac_IP_settings = ns_ip.IP_settings("${dac} Settings for ${ DAC1 }", dac,
       { "DAC_Trigger${ DAC_Trigger_key_suffix }" : "DAC_TRIGGER_SOFTWARE"
       , "DAC_OutputBuffer${ dac_setting_key_suffix }" : "DAC_OUTPUTBUFFER_DISABLE"
       }
        )>

    <#local dac_settings = ip_ov.update_IP_parameters(dac_IP_settings)>

</#function>


<#function dac_gpio dac dac_ch>

<#--
    <define key="DAC_TIMER_CH1_GPIO_PORT" value="GPIOA" />
    <define key="DAC_TIMER_CH1_GPIO_PIN"  value="GPIO_Pin_4" />
    <define key="DAC_TIMER_CH2_GPIO_PORT" value="GPIOA" />
    <define key="DAC_TIMER_CH2_GPIO_PIN"  value="GPIO_Pin_5" />
-->

    <#--<#local motor = (DEFAULT_DAC_MOTOR!0) + 1 >-->
    <#local dac_pin = ns_pin.collectPin( {"1": "PA4", "2": "PA5"}[dac_ch] ) >
    <#local sh_signal = "COMP_${dac}${dac_ch}_group" >

    <#local signal = "${dac}_OUT${ dac_ch }" >
    <#local mode   = "Enable_${dac}_OUT${ dac_ch }" >

    <#return
        [ "${dac_pin}.GPIOParameters=GPIO_Label"
        , "${dac_pin}.GPIO_Label=DBG_DAC_CH${dac_ch}"
        , "${dac_pin}.Locked=true"
        , "${dac_pin}.Signal=${sh_signal}"
        , "SH.${sh_signal}.0=${ signal },${ mode }"
        , "SH.${sh_signal}.ConfNb=1"
        ]>
</#function>

<#function build_VPs >
    <#local signal  =  "ClockSourceINT">
    <#local mode    =  "Enable_Timer"  >
    <#local vps = {} >

    <#local v_signal = "TIM14_VS_${signal}" >
    <#local vp = "VP_${v_signal}" >
    <#local vps = vps +
    { vp : [ "${vp}.Mode=${mode}"
    , "${vp}.Signal=${v_signal}"
    ]
    }>

    <#local registered_vps = fp.map(ns_pin.collectPin, vps?keys) >

    <#return fp.flatten(vps?values)?join("\n") >
</#function>
