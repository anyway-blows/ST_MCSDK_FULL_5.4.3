<#import "../../../../../utils.ftl" as utils>
<#import "../../../../ADC/adc_overlap.ftl" as adc_ov>

<#import "../../../../utils/meta_parameters.ftl" as meta>
<#import "../../../../utils/ips_mng.ftl"         as ns_ip>

<#import "../../../../ADC/ADC_cs_info.ftl" as info >
<#import "../../../../../fp.ftl" as fp >
<#import "../../../../../ui.ftl" as ui >

<#import "../com/F7_adc.ftl" as ap>

<#function cs_ADC_settings motor internal_opamp>
    <#local timer = utils.v("PWM_TIMER_SELECTION", motor) >

    <#local adc  = ns_ip.collectIP( utils.v("ADC_PERIPH", motor) )>
    <#local infs = fp.map_ctx(motor, info.adc_info, ["x","x"]) >

    <#local sectionTitle = "${adc} settings for Current Sensing" >
    <#local adc_settings  = ns_ip.IP_settings(sectionTitle, adc, ap.cs_adc_parameters(timer, "1Sh", infs)) >
    <#local adc_settings_parameters = adc_ov.update_ADCs_IPParameters( adc_settings ) >

    <#local installed_recoveries = ap.recovery_4_extra_regular_cnv_and_ScanConvMode(adc, infs[0]) >

    <#-- when we use internal OPAMP, the pin Label will be one imposed by the opampOut, so here I set a pinLabel == "" for the ADC pin -->
    <#local ctx  = internal_opamp?then
        ( {"adc": adc, "pinLabel": ""}
        , {"adc": adc                }
        ) >

    <#return
        { "settings" :
                { sectionTitle : ui._comment("The ${adc} settings section was POSTPONED.\nIt will be part of a cumulative section dedicated to all ADCs")
                , "${adc} IRQ" : ap.cs_adc_irq(adc)
                }
        , "GPIOs"    :  fp.map_ctx(ctx, ap.cs_create_adc_pins, [infs[0]])
        }>
</#function>
