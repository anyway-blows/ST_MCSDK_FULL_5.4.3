<#import "../../../../utils.ftl"       as utils>
<#import "../../../utils/pins_mng.ftl" as ns_pin>

<#function cs_create_adc_pins ctx inf>
    <#local adc     = ctx.adc
            channel = inf.channel.idx
            pinName = ns_pin.collectPin( inf.gpio )
            >

<#-- ######################################################## -->
    <#if ctx.pinLabel?? >
        <#local gpioLabel = ctx.pinLabel >
    <#else>
        <#if inf.phase == 'x' >
            <#local gpioLabel = "CURR_AMPL" >
        <#else>
            <#local gpioLabel = "CURR_AMPL_${inf.phase}" >
        </#if>
    </#if>




    <#local gpioSignal = "${adc}_IN${channel}" >
    <#local gpioMode   = "IN${channel}${ utils.mx_name('ADC_PIN_MODE_SUFFIX') }" >

    <#local baseRet =
        { "name"   : pinName
        , "label"  : gpioLabel
        , "signal" : gpioSignal
        , "mode"   : gpioMode
        , "ip"     : { "name": adc, "pin" : "IN${channel}" }
        } >

    <#if inf.channel.isShared >
        <#return baseRet + { "sh_signal" : "ADCx_IN${channel}" } >
    <#else>
        <#return baseRet >
    </#if>
</#function>
