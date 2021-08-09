<#import "../../../../../utils.ftl" as utils>
<#import "../../../../../ui.ftl" as ui>
<#import "../../../../ADC/adc_overlap.ftl" as adc_ov>

<#import "../../../../utils/meta_parameters.ftl" as meta>
<#import "../../../../utils/pins_mng.ftl"        as ns_pin>
<#import "../../../../utils/ips_mng.ftl"         as ns_ip>

<#import "../com/F7_adc.ftl" as ap>
<#import "../../../../ADC/ADC_cs_info.ftl" as info >
<#import "../../../../../fp.ftl" as fp >

<#function cs_ADC_settings motor internal_opamps=false >
    <#local timer = utils.v("PWM_TIMER_SELECTION", motor) >

    <#local adc1 = ns_ip.collectIP( utils.v("ADC_1_PERIPH", motor) )>
    <#local adc2 = ns_ip.collectIP( utils.v("ADC_2_PERIPH", motor) )>

    <#local ranks = internal_opamps?then(1,2) >
    <#local adc1_cnvs = fp.map_ctx(motor, info.adc_info, ["U","V"][0..*ranks] )
            adc2_cnvs = fp.map_ctx(motor, info.adc_info, ["V","W"][0..*ranks] ) >
<#--
    the above syntax ["U","V"][0..*ranks] means sub-sequence
    [0..*ranks] extract the head subsequence of length ranks | Range Syntax: start..*length

    Sequence slicing
        With seq[range], were range is a range value as described here, you can take a slice of the sequence.
        The resulting sequence will contain the items from the original sequence (seq) whose indexes are in the range. For example:
    https://freemarker.apache.org/docs/dgui_template_exp.html#dgui_template_exp_seqenceop_slice
-->
    <#local adc1_gpios = register_ADC_and_generatePinDefinition(adc1, adc1_cnvs, timer, internal_opamps, "3Sh_IR")
            adc2_gpios = register_ADC_and_generatePinDefinition(adc2, adc2_cnvs, timer, internal_opamps, "3Sh_IR") >

    <#local sectionTitle = "${adc1} and ${adc2} settings for Current Sensing " >
    <#return
        { "settings" :
            { sectionTitle : ui._comment("The ${adc1} and ${adc2} settings section was POSTPONED.\nIt will be part of a cumulative section dedicated to all ADCs")
            , "${adc1} and ${adc2} IRQ" : ap.cs_adc_irq(adc1)
            }
        , "GPIOs"    : adc1_gpios
                     + adc2_gpios
        }>
</#function>

<#function register_ADC_and_generatePinDefinition adc infs timer internal_opamps, sense>
    <#local installed_recoveries = ap.recovery_4_extra_regular_cnv_and_ScanConvMode(adc, infs[0]) >

    <#local adc_sectionTitle = "${adc} settings for Current Sensing" >
    <#local adc_settings  = ns_ip.IP_settings(adc_sectionTitle, adc, ap.cs_adc_parameters(timer, sense, infs)) >
    <#-- the following will store the ADC parameters for later use  -->
    <#local adc_settings_parameters = adc_ov.update_ADCs_IPParameters( adc_settings ) >

    <#-- when we use internal OPAMP, the pin Label will be one imposed by the opampOut, so here I set a pinLabel == "" for the ADC pin -->
    <#local ctx  = internal_opamps?then
        ( {"adc": adc, "pinLabel": ""}
        , {"adc": adc                }
        ) >
    <#return fp.map_ctx(ctx, ap.cs_create_adc_pins, infs) >

</#function>
