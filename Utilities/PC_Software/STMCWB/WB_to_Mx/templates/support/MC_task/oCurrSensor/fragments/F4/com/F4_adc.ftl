<#import "../../../../utils/meta_parameters.ftl" as meta>
<#import "../../../../../utils.ftl" as utils>
<#import "../../../../../fp.ftl" as fp>
<#import "../../../../ADC/ADC_cs_info.ftl" as info >
<#import "../../../../utils/ips_mng.ftl" as ns_ip>
<#import "../../../../utils/pins_mng.ftl" as ns_pin>
<#import "../../../../utils/mxInfo_ver.ftl" as mx_ver>
<#import "../../Fx_commons/cs_cmn_create_adc_pin.ftl" as adc_pin>

<#function register_ADC_and_generatePinDefinition adc cnvs timer_idx sense>
    <#import "../../../../ADC/adc_overlap.ftl" as adc_ovp >
    <#local adc_sectionTitle = "${adc} settings for Current Sensing" >
    <#local adc_settings  = ns_ip.IP_settings(adc_sectionTitle, adc, cs_adc_parameters(timer_idx, sense, cnvs)) >

<#-- the following will store the ADC parameters for later use  -->
    <#local adc_settings_parameters = adc_ovp.update_ADCs_IPParameters( adc_settings ) >

    <#local ctx  = {"adc": adc} >
    <#return fp.map_ctx(ctx, adc_pin.cs_create_adc_pins, cnvs) >
</#function>


<#--<#function get_cubeMXver>
    <#local ver_info = MxInfo.version>
    <#local res = ver_info?matches("^(\\d)+")>
    <#if res[0]??>
        <#return res[0]>
    <#else>
        <#return "5">
    </#if>
</#function>-->



<#function cs_adc_parameters timer_idx sense cnvs >
    <#-- shunts == 0 ==> ICS -->
    <#local trig_suffix = sense?switch
        ( "1Sh"   , "_TRGO"
        , "3Sh_IR", '_CC4'
        , "3Sh"   , '_CC4'
        , "ICS"   , '_CC4'
        )>

   <#-- <#local InjectedConvMode =  (sense != "3Sh")?then("Discontinuous","None")>-->
   <#local InjectedConvMode =  (sense = "3Sh" || sense = "ICS" )?then("None","Discontinuous")>

    <#local ExternalTrigInjecConv = "ADC_EXTERNALTRIGINJECCONV_T${timer_idx}${trig_suffix}" >

    <#local parameters =
        { "EnableInjectedConversion"  : "ENABLE", meta.blankLn_key():""

        , "InjectedConvMode"          : InjectedConvMode
        , "ExternalTrigInjecConv"     : ExternalTrigInjecConv
        , "ExternalTrigInjecConvEdge" : "ADC_EXTERNALTRIGINJECCONVEDGE_RISING"

        , "InjNumberOfConversion"     : cnvs?size
        }>


    <#local ver= mx_ver.get_cubeMXver()>
    <#local injected =(ver?number >= 5)?then("Injected","")>

    <#list cnvs as cnv>

        <#local idx = cnv?index + 1 >
        <#local chInjectedConversion = "${idx}\\#ChannelInjectedConversion" >

        <#local cycle = (cnv.samplingTime > 1)?then("CYCLES", "CYCLE") >

        <#local parameters = parameters +
            { meta.comment_key() : "SAMPLING ${idx} --> M${cnv.motor} ${ cnv.what }"
          <#--  , "Rank-${          chInjectedConversion}" : idx-->
            <#--, "InjectedRank-${chInjectedConversion}" : idx-->
            , "${injected}Rank-${chInjectedConversion}" : idx
            , "Channel-${       chInjectedConversion}" : "ADC_CHANNEL_${ cnv.channel.idx }"
            , "SamplingTime-${  chInjectedConversion}" : "ADC_SAMPLETIME_${ cnv.samplingTime }${cycle}"
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

