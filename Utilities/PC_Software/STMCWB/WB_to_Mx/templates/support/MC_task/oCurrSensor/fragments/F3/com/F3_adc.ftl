<#import "../../../../utils/meta_parameters.ftl" as meta>
<#import "../../../../../utils.ftl" as utils>
<#import "../../../../ADC/ADC_cs_info.ftl" as info >
<#import "../../../../utils/ips_mng.ftl" as ns_ip>
<#import "../../../../utils/pins_mng.ftl" as ns_pin>

<#import "../../Fx_commons/cs_cmn_create_adc_pin.ftl" as adc_pin>

<#-- this has to be managed with assign and not global! It has to remain within the namespace -->
<#assign cs_create_adc_pins = adc_pin.cs_create_adc_pins >

<#--
    To manage the R3_2, that whants 4 injected conversion to be initialized coming from both motors
    I have to tie any single conversion to its motor or better, I can provide the data-source directly
-->
<#function cs_adc_parameters timer sense cnvs >
    <#local tmr_idx = utils._last_char( timer ) >

    <#local InjectedConvMode      = (sense == "3Sh" || sense == "ICS")?then("None", "Discontinuous") >
    <#--<#local InjectedConvMode      = (sense == "3Sh")?then("None", "Discontinuous") >-->
    <#local ExternalTrigInjecConv = "ADC_EXTERNALTRIGINJECCONV_T${tmr_idx}_TRGO${ (sense == '1Sh')?then('2', '') }" >

    <#local parameters =
        { "EnableInjectedConversion"  : "ENABLE", meta.blankLn_key():""

        , "InjectedConvMode"          : InjectedConvMode
        , "ExternalTrigInjecConv"     : ExternalTrigInjecConv

        , "ExternalTrigInjecConvEdge" : "ADC_EXTERNALTRIGINJECCONV_EDGE_RISING"
        , "QueueInjectedContext"      : "ENABLE", meta.blankLn_key():""

        , "InjNumberOfConversion"     : cnvs?size
        } + (sense == "ICS")?then(
        { "QueueInjectedContext"      : "DISABLE" }, {} )
        >

    <#list cnvs as cnv>
        <#local idx = cnv?index + 1 >
        <#local chInjectedConversion = "${idx}\\#ChannelInjectedConversion" >

        <#local cycle = (cnv.samplingTime > 1)?then("CYCLES", "CYCLE") >

        <#local parameters = parameters +
            { meta.comment_key() : "SAMPLING ${idx} --> M${cnv.motor} ${ cnv.what }"
            , "InjectedRank-${        chInjectedConversion}" : idx
            , "InjectedChannel-${     chInjectedConversion}" : "ADC_CHANNEL_${ cnv.channel.idx }"
            , "InjectedSamplingTime-${chInjectedConversion}" : "ADC_SAMPLETIME_${ cnv.samplingTime }${cycle}_5"
            , "InjectedOffsetNumber-${chInjectedConversion}" : "ADC_OFFSET_NONE"
            , "InjectedOffset-${      chInjectedConversion}" : 0
            }>
    </#list>

    <#return parameters >
</#function>

<#function cs_adc_irq ip >
    <#import "../../../../../ui.ftl" as ui>
    <#import "../../../../../names_map.ftl" as rr>

    <#local irqs = utils.mx_name("ADC_IRQs") >
    <#if irqs?is_hash && irqs[ip]?? >
        <#local set_irq_adc = rr["SET_IRQ_ADC"]!([true, 2, 0, true, false, false, true]) >
        <#return ns_ip.ip_irq(irqs[ip], set_irq_adc) >
    <#else>
        <#return ui._comment("ERROR: unable to find ADC IRQ name for ${ip}, it should be defined within ParameterConversion file") >
    </#if>
</#function>


<#function add_extra_regular_cnv_if_needed adc cnv>
    <#import "../../Fx_commons/Ticket_43328/extra_regular_cnv_trick.ftl" as ex>
    <#return ex.add_extra_regular_cnv_if_needed(adc, cnv, true)>
</#function>

<#function ScanConvMode_recovery adc>
    <#import "../../Fx_commons/adc_ScanConvMode.ftl" as ex>
    <#return ex.ScanConvMode_recovery(adc) >
</#function>

<#function recovery_4_extra_regular_cnv_and_ScanConvMode adc cnv>
    <#local installed_recoveries = [add_extra_regular_cnv_if_needed(adc, cnv), ScanConvMode_recovery(adc)] >
</#function>




