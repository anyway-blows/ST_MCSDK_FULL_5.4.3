<#import "../../../../../ui.ftl"        as ui>
<#import "../../../../../utils.ftl"        as utils>
<#import "../../../../ADC/adc_overlap.ftl" as adc_ov>
<#import "../../../../utils/ips_mng.ftl"   as ns_ip>

<#import "../com/F4_adc.ftl" as ap>

<#import "../dual_drive/F4_2Ms_adc_pins.ftl" as pin_utils >
<#import "../dual_drive/F4_2Ms_adc_cnvs.ftl" as adc_cnvs >

<#function cs_ADC_settings motor senses>
    <#local sense = senses[motor-1]>

    <#local timer = utils.v("PWM_TIMER_SELECTION", motor) >
    <#local timer_idx = utils._last_char( timer ) >

    <#local adc_idx = motor>

    <#local adc   = ns_ip.collectIP( utils.v("ADC_${adc_idx}_PERIPH", motor) )>
    <#local cnvs  = adc_cnvs.F4_2Ms_adc_cnvs(senses?join("_"))[adc_idx-1] >

    <#import "../../Fx_commons/Ticket_43328/extra_regular_cnv_trick.ftl" as ex>
    <#local opt_extras_reg_conv = ex.add_extra_regular_cnv_if_needed(adc, cnvs[0]) >


    <#local sectionTitle = "${adc} settings for Current Sensing " >

    <#local adc_1_sectionTitle = "${adc} settings for Current Sensing" >
    <#local adc_1_settings = ns_ip.IP_settings(adc_1_sectionTitle, adc, ap.cs_adc_parameters(timer_idx, '3Sh_IR', cnvs)) >
    <#-- the following will store the ADC parameters for later use  -->
    <#local adc_1_settings_parameters = adc_ov.update_ADCs_IPParameters( adc_1_settings ) >

    <#local gpios = pin_utils.F4_2Ms_adc_pins(motor, sense) >

    <#return
        { "settings" :
                { sectionTitle : ui._comment("The ${adc} settings section was POSTPONED.\nIt will be part of a cumulative section dedicated to all ADCs")
                , "${adc} IRQ" : ap.cs_adc_irq("ADC")
                }
        , "GPIOs"    : gpios
        }>
</#function>

