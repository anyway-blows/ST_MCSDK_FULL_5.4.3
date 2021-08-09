<#import "../../../../../../utils.ftl" as utils>
<#import "../../../../../../ui.ftl" as ui>

<#import "../../../../../utils/ips_mng.ftl"   as ns_ip>
<#import "../../../../../ADC/ADC_cs_info.ftl" as info >

<#import "../../com/F1_adc.ftl" as ap>

<#assign title = "ADC">
<#function get_settings motor>
    <#local MD_mcu = (utils._last_word(WB_MCU_TYPE)?upper_case !"") >

    <#if (MD_mcu == "HD")>
        <#import "F1_1Sh_aux_pwm_timer.ftl" as aux_timer >
    <#else>
        <#import "../../F103_MD/1Sh/F1_1Sh_aux_pwm_timer.ftl" as aux_timer >
    </#if>

    <#local timer_idx = aux_timer.cs_F1_aux_timer_idx(motor)>

    <#local adc = ns_ip.collectIP( utils.v("ADC_PERIPH", motor) )
            cnv = info.adc_info(motor, "x")
            >

    <#import "../../../Fx_commons/Ticket_43328/extra_regular_cnv_trick.ftl" as ex>
    <#local opt_extras_reg_conv = ex.add_extra_regular_cnv_if_needed(adc, cnv, true) >

    <#import "../../../Fx_commons/adc_ScanConvMode.ftl" as ex2>
    <#local RecoveryScanConvMode = ex2.ScanConvMode_recovery(adc) >

    <#local gpios = ap.register_ADC_and_generatePinDefinition(adc, [cnv, cnv], timer_idx, "1Sh") >

    <#local adc = (MD_mcu == "HD")?then(adc ,"ADC1_2" )>
    <#local sectionTitle = "${adc} settings for Current Sensing" >
    <#return
        { "settings" :
                { sectionTitle : ui._comment("The ${adc} settings section was POSTPONED.\nIt will be part of a cumulative section dedicated to all ADCs ")
                , "${adc} IRQ" : ap.cs_adc_irq (adc)
                }
        , "GPIOs": gpios
        }>
</#function>
