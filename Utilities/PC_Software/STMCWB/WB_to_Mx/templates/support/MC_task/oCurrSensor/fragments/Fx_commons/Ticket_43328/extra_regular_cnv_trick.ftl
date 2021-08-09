<#import "../../../../utils/ips_mng.ftl" as ns_ip>
<#import "../../../../ADC/adc_overlap.ftl" as adc_ovp >
<#import "../../../../utils/meta_parameters.ftl" as meta>

<#import "../../../../../../ioc_seed/hw_info.ftl" as hw>

<#-- Patch for [Ticket 43328](https://intbugzilla.st.com/show_bug.cgi?id=43328) -->
<#function add_extra_regular_cnv_if_needed adc cnv simpleMode=false>
    <#import "../../../extra_settings.ftl" as adc_extra >

    <#-- the following data will be passed to `check_if_need_extra_regular_cnv` together with the `info` collected on adc -->
    <#local data_to_be_passed_back = {"adc": adc, "cnv": cnv, "simpleMode": simpleMode}>

    <#return adc_extra.add_extras( "add_extra_regular_cnv_if_needed"
        , adc
        , check_if_need_extra_regular_cnv
        , data_to_be_passed_back) >
</#function>

<#function check_if_need_extra_regular_cnv info adc_cnv>
    <#if ! info?? || info.IPParameters?seq_contains("EnableRegularConversion") >
<#--
        <#list info.sections as section>
            <#if (section.parameters[EnableRegularConversion])!"DISABLE"  == "ENABLE" >
                <#return false>
            </#if>
        </#list>
-->
        <#return false>
    </#if>

    <#local adc = adc_cnv.adc
            cnv = adc_cnv.cnv
     simpleMode = adc_cnv.simpleMode >

    <#local extra_parameters = simpleMode?then( {"EnableRegularConversion": "DISABLE"}, _cs_extra_regular_cnv_parameters(cnv)) >

    <#local extras_regular_cnv = ns_ip.IP_settings
        ( "${adc} - Extra Regular Conversion - [Ticket 43328](https://intbugzilla.st.com/show_bug.cgi?id=43328)"
        , adc, extra_parameters) >
    <#local applied = adc_ovp.update_ADCs_IPParameters(extras_regular_cnv) >

    <#return true>
</#function>

<#function _cs_extra_regular_cnv_parameters cnv >
    <#import "../../../../../names_map.ftl" as rr>
    <#local sampleng_suffix = rr["ADC_SAMPLETIME_SUFFIX"]!"" >

    <#local idx = 1 >
    <#local chConversion = "${idx}\\#ChannelRegularConversion" >

    <#local cycle = (cnv.samplingTime > 1)?then("CYCLES", "CYCLE") >

    <#local scanModeEnable  = (ScanConvMode_V.ENABLE )!"ADC_SCAN_ENABLE" >
    <#local scanConvMode = (hw.cpu.family == "F4")?then({"ScanConvMode" : scanModeEnable}, {}) >

    <#local parameters =
    { "EnableRegularConversion"  : "ENABLE", meta.blankLn_key():""

    , "ExternalTrigConv"          : "ADC_SOFTWARE_START"
    , "ExternalTrigConvEdge"      : "ADC_EXTERNALTRIGCONVEDGE_NONE"
    } + scanConvMode +
    { "NbrOfConversion"     : 1
    , "NbrOfConversionFlag" : 1

    , meta.comment_key() : "SAMPLING ${idx} --> M${cnv.motor} ${ cnv.what }"
    , "Rank-${          chConversion}" : idx
    , "Channel-${       chConversion}" : "ADC_CHANNEL_${ cnv.channel.idx }"
    , "SamplingTime-${  chConversion}" : "ADC_SAMPLETIME_${ cnv.samplingTime }${cycle}${sampleng_suffix}"
    }>

    <#return parameters >
</#function>
