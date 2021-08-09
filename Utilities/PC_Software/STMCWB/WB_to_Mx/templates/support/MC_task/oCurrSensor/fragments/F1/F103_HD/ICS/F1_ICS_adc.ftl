<#import "../../../../../../utils.ftl" as utils>
<#import "../../../../../../ui.ftl" as ui>

<#import "../../../../../utils/ips_mng.ftl"   as ns_ip>
<#import "../../../../../ADC/ADC_cs_info.ftl" as info >

<#import "../../com/F1_adc.ftl" as ap>

<#assign title = "ADC">
<#function get_settings motor >

    <#local timer = utils.v("PWM_TIMER_SELECTION", motor) >
    <#local timer_idx = utils._last_char( timer ) >

    <#local adc1  = ns_ip.collectIP( utils.v("ADC_1_PERIPH", motor) )
            adc2  = ns_ip.collectIP( utils.v("ADC_2_PERIPH", motor) )
            cnv_U = info.adc_info(motor, "U")
            cnv_V = info.adc_info(motor, "V")
            >

    <#import "../../../Fx_commons/Ticket_43328/extra_regular_cnv_trick.ftl" as ex>
    <#local opt_extras_reg_conv_1 = ex.add_extra_regular_cnv_if_needed(adc1, cnv_U, true)
            opt_extras_reg_conv_2 = ex.add_extra_regular_cnv_if_needed(adc2, cnv_V, true) >


    <#local gpios_U = ap.register_ADC_and_generatePinDefinition(adc1, [cnv_U], timer_idx, "ICS", false)
            gpios_V = ap.register_ADC_and_generatePinDefinition(adc2, [cnv_V], timer_idx, "ICS", true)>

    <#local adc = [adc1, adc2]>
    <#local sectionTitle = "${ adc?join(' and ')} settings for Current Sensing " >
    <#return
        { "settings" :
                { sectionTitle : ui._comment("The ${adc?join(' and ')} settings section was POSTPONED.\nIt will be part of a cumulative section dedicated to all ADCs ")
                , "${adc?join(' and ')} IRQ" : ap.cs_adc_irq("ADC1_2")
                }
        , "GPIOs": gpios_U + gpios_V
        }>
</#function>
