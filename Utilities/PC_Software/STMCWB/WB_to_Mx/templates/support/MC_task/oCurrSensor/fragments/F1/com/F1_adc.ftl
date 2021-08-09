<#import "../../../../utils/meta_parameters.ftl" as meta>
<#import "../../../../../utils.ftl" as utils>
<#import "../../../../../fp.ftl" as fp>
<#import "../../../../ADC/ADC_cs_info.ftl" as info >
<#import "../../../../utils/ips_mng.ftl" as ns_ip>
<#import "../../../../utils/pins_mng.ftl" as ns_pin>

<#import "../../Fx_commons/cs_cmn_create_adc_pin.ftl" as adc_pin>

<#function register_ADC_and_generatePinDefinition adc cnvs timer_idx sense isAdc2=false>
    <#import "../../../../ADC/adc_overlap.ftl" as adc_ovp >
    <#local adc_sectionTitle = "${adc} settings for Current Sensing" >
    <#local adc_settings  = ns_ip.IP_settings(adc_sectionTitle, adc, cs_adc_parameters(timer_idx, sense, cnvs,isAdc2)) >

<#-- the following will store the ADC parameters for later use  -->
    <#local adc_settings_parameters = adc_ovp.update_ADCs_IPParameters( adc_settings ) >

    <#local ctx  = {"adc": adc} >
    <#return fp.map_ctx(ctx, adc_pin.cs_create_adc_pins, cnvs) >
</#function>

<#function cs_adc_parameters timer_idx sense cnvs isAdc2>

    <#local trig_suffix = sense?switch
        ( "1Sh", "_TRGO"
        , "3Sh", '_CC4'
        , "ICS", '_CC4'
        )>

    <#local MD_mcu = (utils._last_word(WB_MCU_TYPE)?upper_case !"") >

    <#local InjectedConvMode = (sense == "ICS" || MD_mcu == "MD" || MD_mcu == "LD"  )?then("None", "Discontinuous") >

    <#local ExternalTrigInjecConv = "ADC_EXTERNALTRIGINJECCONV_T${timer_idx}${ (MD_mcu == 'LD')?then('_CC4', trig_suffix)}" >

<#--Paramiters for F103_HD-->
    <#local mode = "__NULL">
    <#local ContinuousConvMode = "DISABLE">
<#--********************************************-->

<#--Paramiters for F103_MD-->
    <#--<#if MD_mcu == "MD" && sense == "3Sh" >-->
    <#if !(MD_mcu == "HD") && !(sense == "1Sh") >
        <#local mode = "ADC_DUALMODE_INJECSIMULT">

        <#if (sense == "ICS") || !(isAdc2!false)>
            <#local ContinuousConvMode = "ENABLE">
         <#--<#else>
            <#local ContinuousConvMode = (isAdc2!false)?then("DISABLE","ENABLE")>-->
        </#if>
    </#if>
<#--********************************************-->

    <#local parameters =
    {
     "Mode"                       : "${mode}"
    , "ContinuousConvMode"        : "${ContinuousConvMode}"
    , "EnableInjectedConversion"  : "ENABLE", meta.blankLn_key():""
    , "InjectedConvMode"          :  InjectedConvMode
    , "ExternalTrigInjecConv"     :  ExternalTrigInjecConv
    , "ExternalTrigInjecConvEdge" : "ADC_EXTERNALTRIGINJECCONVEDGE_RISING"

    , "InjNumberOfConversion"     : cnvs?size
    }>

    <#list cnvs as cnv>
        <#local idx = cnv?index + 1 >
        <#local chInjectedConversion = "${idx}\\#ChannelInjectedConversion" >

        <#local cycle = (cnv.samplingTime > 1)?then("CYCLES", "CYCLE") >

        <#local parameters = parameters +
            { meta.comment_key() : "SAMPLING ${idx} --> M${cnv.motor} ${ cnv.what }"
            , "Rank-${          chInjectedConversion}" : idx
            , "Channel-${       chInjectedConversion}" : "ADC_CHANNEL_${ cnv.channel.idx }"
            , "SamplingTime-${  chInjectedConversion}" : "ADC_SAMPLETIME_${ cnv.samplingTime }${cycle}_5"
            , "InjectedOffset-${chInjectedConversion}" : 0
            }>
    </#list>

    <#return parameters >
</#function>

<#function cs_adc_irq ip >
    <#import "../../../../../names_map.ftl" as rr>
    <#local set_irq_adc = rr["SET_IRQ_ADC"]!([true, 2, 0, true, false, false, false]) >
    <#return ns_ip.ip_irq(ip, set_irq_adc) >
<#--<#return ns_ip.ip_irq(ip, [true, 2, 0, true, false, false, false]) >-->
</#function>

