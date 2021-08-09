<#import "../../fp.ftl" as fp >
<#import "../../utils.ftl" as utils >
<#import "../utils/meta_parameters.ftl" as meta >
<#import "../../../ioc_seed/hw_info.ftl" as hw >

<#function Temp_Bus_sense_adc_parameters sensors>
    <#if !sensors?has_content >
        <#return {} >
    </#if>

    <#local scanModeEnable  = (ScanConvMode_V.ENABLE )!"ADC_SCAN_ENABLE"  >
    <#local scanModeDisable = (ScanConvMode_V.DISABLE)!"ADC_SCAN_DISABLE" >

    <#local scanMode = ( hw.cpu.family == "F4"
                      || hw.cpu.family == "F7"
                       )?then( scanModeEnable
                             ,(sensors?size lt 2)?then(scanModeDisable, scanModeEnable))>

    <#if hw.cpu.family == "F0" || hw.cpu.family== "G0" >
        <#return meta.comment("${hw.cpu.family} does not require additional ADC parameter settings for BUS_VOLTAGE and TEMPERATURE sensing") >
    <#else>

        <#-- I look at no more than 4 items -->
        <#local sensors = sensors[0..*4] >

        <#local parameters =
        { "EnableRegularConversion" : "ENABLE"
        , meta.blankLn_key()        : ""

        , "ExternalTrigConv"        : "ADC_SOFTWARE_START"
        , "ExternalTrigConvEdge"    : "ADC_EXTERNALTRIGCONVEDGE_NONE"
        , meta.blankLn_key()        : ""

        <#--, "ScanConvMode"            : (sensors?size lt 2)?then("ADC_SCAN_DISABLE", "ADC_SCAN_ENABLE")-->
        , "ScanConvMode"            : scanMode
        , "NbrOfConversionFlag"     : (sensors?size gt 0)?then("1", "0")
        , "NbrOfConversion"         : sensors?size
        }>

        <#local addComments = sensors?size gt 1>
        <#list sensors as sensor>
            <#local idx = 1 + sensor?index >

            <#if addComments >
                <#local parameters = parameters + meta.comment( sensor.label ) >
            </#if>

            <#local sampl_suffix = (sensor.sampling_time > 1)?then("CYCLES", "CYCLE") >
            <#if sensor.sampling_cycles gt 0  && hw.cpu.family != "F7" >
                <#local sampl_suffix = "${sampl_suffix}_${sensor.sampling_cycles}" >
            </#if>


            <#local parameters = parameters +
            { "Rank-${        idx}\\#ChannelRegularConversion" : sensor?index + 1
            , "Channel-${     idx}\\#ChannelRegularConversion" : sensor.channel?upper_case
            , "SamplingTime-${idx}\\#ChannelRegularConversion" : "ADC_SAMPLETIME_${sensor.sampling_time}${sampl_suffix}"
            , "OffsetNumber-${idx}\\#ChannelRegularConversion" : "ADC_OFFSET_NONE"
            , "Offset-${      idx}\\#ChannelRegularConversion" : 0
            } >

        </#list>

        <#return parameters >
    </#if>
</#function>
