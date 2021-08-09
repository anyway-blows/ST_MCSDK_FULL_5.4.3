<#import "../../../../../utils.ftl" as utils>
<#import "../../../../../ui.ftl" as ui>

<#import "../../../../utils/ips_mng.ftl"   as ns_ip>
<#import "../../../../ADC/ADC_cs_info.ftl" as info >

<#import "../com/F4_adc.ftl" as ap>

<#assign title = "ADC">
<#function get_settings motor>
    <#import "F4_1Sh_aux_pwm_timer.ftl" as aux_timer >
    <#local timer_idx = aux_timer.cs_F4_aux_timer_idx(motor)>

    <#local adc = ns_ip.collectIP( utils.v("ADC_PERIPH", motor) )
            cnv = info.adc_info(motor, "x")
            >

    <#import "../../Fx_commons/Ticket_43328/extra_regular_cnv_trick.ftl" as ex>
    <#local opt_extras_reg_conv = ex.add_extra_regular_cnv_if_needed(adc, cnv) >

    <#local gpios = ap.register_ADC_and_generatePinDefinition(adc, [cnv, cnv], timer_idx, "1Sh") >

    <#local sectionTitle = "${adc} settings for Current Sensing" >
    <#return
        { "settings" :
                { sectionTitle : ui._comment("The ${adc} settings section was POSTPONED.\nIt will be part of a cumulative section dedicated to all ADCs ")

                , "${adc} IRQ" : ap.cs_adc_irq("ADC")
                }
        , "GPIOs": gpios
        }>
</#function>
