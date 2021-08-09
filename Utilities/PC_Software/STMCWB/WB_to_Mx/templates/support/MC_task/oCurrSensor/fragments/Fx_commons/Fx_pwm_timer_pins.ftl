<#import "../../../../utils.ftl" as utils>
<#import "../../../../fp.ftl"    as fp>
<#import "../../../../ui.ftl"    as ui>

<#import "../../../utils/pins_mng.ftl"  as ns_pin>

<#function cs_create_timer_pins timer>
    <#local xs = [] >

    <#switch timer.LOW_SIDE_SIGNALS_ENABLING>
        <#case "LS_PWM_TIMER">
            <#list ["U", "V", "W"] as phase>
                <#local hi = pwm_pin_setting("${phase}H", timer, true)  >
                <#local lo = pwm_pin_setting("${phase}L", timer, false) >
                <#local xs = xs + [hi, lo] >
            </#list>
            <#break >

        <#-- LowSide Complemented from HighSide -->
        <#-- Driving Enabling Signal = true -->
        <#case "ES_GPIO">
            <#list ["U", "V", "W"] as phase>
                <#local hi = pwm_pin_setting("${phase}H", timer, false) >
                <#--<#local lo = en_pin_setting ("${phase}L", timer) >-->
                <#--<#local xs = xs + [hi, lo] >-->
                <#local xs = xs + [hi] >
            </#list>
            <#local xs = xs + en_pin_settings(timer.motor) >
            <#break >

        <#-- Driving Enabling Signal = false -->
        <#case "LS_DISABLED">
            <#list ["U", "V", "W"] as phase>
                <#local hi = pwm_pin_setting("${phase}H", timer, false) >
                <#local xs = xs + [ {"name":hi.name, "str":hi.str + "\n" + ui._box("LOW SIDE SIGNALS DISABLED", 'x', 'x')} ] >
            </#list>
    </#switch>

    <#return xs >
</#function>

<#function pwm_pin_setting phase timer complementary=false>
    <#local motor = timer.motor >
    <#local pinName = ns_pin.name2(motor, "PHASE_${phase}") >

    <#local lowSide   = utils._last_char(phase) == "L" >
    <#local highSide  = !lowSide >

    <#local idleState = highSide?then(timer.HIGH_SIDE_IDLE_STATE, timer.LOW_SIDE_IDLE_STATE) >
    <#local polarity  = utils.polarity(idleState, timer.polarity[phase]) >
    <#local pull = polarity?switch("SET","UP",    "RESET","DOWN") >

    <#local ch_idx = {"U": 1, "V": 2, "W": 3}[phase[0]] >

    <#local signal   = "${timer.name}_CH${ch_idx}" >
    <#local ip_mode = "PWM Generation${ch_idx} CH${ch_idx} CH${ch_idx}N" >
    <#if lowSide >
        <#local signal_settings =
            [ "${pinName}.Mode=${ip_mode}"
            , "${pinName}.Signal=${signal}N"
            ]>
    <#else>
        <#local s_signal = "S_${signal}" >
        <#if complementary >
            <#local mode = "PWM Generation${ch_idx} CH${ch_idx} CH${ch_idx}N">
        <#else>
            <#local mode = "PWM Generation${ch_idx} CH${ch_idx}">
        </#if>

        <#local signal_settings =
            [ "${pinName}.Signal=${ s_signal }"
            , "SH.${s_signal}.0=${signal},${mode}"
            , "SH.${s_signal}.ConfNb=1"
            ]>
    </#if>

    <#return {"name" : pinName , "str": (
        [ ui._box("PWM_pin_setting PHASE_${phase} ${timer.name}", '.', '.')
        , "${pinName}.GPIOParameters=GPIO_Speed,GPIO_PuPd,GPIO_Label"
        , "${pinName}.GPIO_Label=M${motor}_PWM_${phase}"
        , "${pinName}.GPIO_PuPd=GPIO_PULL${pull}"
        , "${pinName}.GPIO_Speed=GPIO_SPEED_FREQ_HIGH"
        , "${pinName}.Locked=true"
        , ui._comment("\nSignal Setting")
        ] + signal_settings )?join("\n")
    }>
</#function>

<#function en_pin_settings motor>
    <#local pinName_U = ns_pin.name2(motor, "PHASE_UL") >
    <#local pinName_V = ns_pin.name2(motor, "PHASE_VL") >
    <#local pinName_W = ns_pin.name2(motor, "PHASE_WL") >

    <#if pinName_U == pinName_V && pinName_V == pinName_W >
        <#-- un solo pin -->
        <#local pinLabel   = "M${motor}_PWM_EN_UVW"     >
        <#local pinComment = "EN_pin_setting PHASE_UVW" >
        <#return [_en_pin_setting(pinName_U, pinLabel, pinComment)] >
    <#else>
        <#-- tre pin indipendenti -->
        <#return fp.map_ctx(motor, en_pin_setting, ["U", "V", "W"]) >
    </#if>
</#function>

<#function en_pin_setting motor phase>
    <#local pinName    = ns_pin.name2(motor, "PHASE_${phase}L") >
    <#local pinlabel   = "M${motor}_PWM_EN_${phase}" >
    <#local pinComment = "EN_pin_setting PHASE_${phase}L" >

    <#return _en_pin_setting(pinName, pinlabel, pinComment) >
</#function>

<#function _en_pin_setting pinName pinLabel pinComment>
    <#return
        { "name" : pinName
        , "str" :
            [ ui._box(pinComment, 'x', 'x')
            , "${pinName}.GPIOParameters=GPIO_Speed,GPIO_PuPd,GPIO_Label"
            , "${pinName}.GPIO_Label=${pinLabel}"
            , "${pinName}.GPIO_PuPd=GPIO_PULLDOWN"
            , "${pinName}.GPIO_Speed=GPIO_SPEED_FREQ_HIGH"
            , "${pinName}.Locked=true"
            , "${pinName}.Signal=GPIO_Output"
            ]?join("\n")
        }>
</#function>
