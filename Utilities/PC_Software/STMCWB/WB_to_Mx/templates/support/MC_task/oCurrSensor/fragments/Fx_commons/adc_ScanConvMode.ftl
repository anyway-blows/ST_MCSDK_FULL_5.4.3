<#import "../../../ADC/adc_overlap.ftl" as adc_ovp >
<#import "../../extra_settings.ftl" as adc_extra>
<#import "../../../utils/ips_mng.ftl" as ns_ip>

<#function ScanConvMode_recovery adc>
    <#local installed_recovery = adc_extra.add_extras( "ScanConvMode Recovery"
    , adc, _add_ScanConvMode_recovery
    , adc
    ) >
</#function>

<#function _add_ScanConvMode_recovery info adc>
    <#if ! info?? >
        <#return false>
    </#if>

    <#local InjNumberOfConversion = 0
            NbrOfConversion       = 0
            >

    <#local scanModeEnable  = (ScanConvMode_V.ENABLE )!"ADC_SCAN_ENABLE"  >
    <#local scanModeDisable = (ScanConvMode_V.DISABLE)!"ADC_SCAN_DISABLE" >

    <#--<#local mode = "ADC_SCAN_DISABLE" >-->
    <#--<#local mode = (hw.cpu.family == "F7")?then("DISABLE" , "ADC_SCAN_DISABLE")>-->
    <#local mode = scanModeDisable >

    <#list info.sections as section>
        <#local InjNumberOfConversion = InjNumberOfConversion + (section.parameters.InjNumberOfConversion?number)!0 >
        <#local NbrOfConversion       = NbrOfConversion       + (section.parameters.NbrOfConversion      )!0 >

        <#if InjNumberOfConversion gt 1 || NbrOfConversion gt 1>
            <#local mode = scanModeEnable >
            <#--<#local mode = (hw.cpu.family == "F7")?then("ENABLE" , "ADC_SCAN_ENABLE")>-->
            <#--<#break >-->
        </#if>
    </#list>

    <#local scanConvMode = ns_ip.IP_settings
    ( "Recovery ScanConvMode for ${adc}: ${InjNumberOfConversion} InjConv - ${NbrOfConversion} RegConv"
    , adc, {"ScanConvMode" : mode}
    )>
    <#local apply_recovery = adc_ovp.update_ADCs_IPParameters( scanConvMode ) >

    <#return true>
</#function>
