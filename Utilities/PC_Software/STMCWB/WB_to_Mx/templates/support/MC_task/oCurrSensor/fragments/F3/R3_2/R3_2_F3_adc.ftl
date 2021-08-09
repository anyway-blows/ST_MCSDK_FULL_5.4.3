<#import "../../../../../ui.ftl" as ui>
<#import "../../../../../utils.ftl" as utils>
<#import "../../../../../fp.ftl" as fp >

<#--<#include "../../Fx_commons/adc_overlap.ftl">-->
<#import "../../../../ADC/adc_overlap.ftl" as adc_ov>

<#import "../../../../utils/meta_parameters.ftl" as meta>
<#import "../../../../utils/pins_mng.ftl"        as ns_pin>
<#import "../../../../utils/ips_mng.ftl"         as ns_ip>

<#import "../com/F3_adc.ftl" as ap>
<#import "../../../../ADC/ADC_cs_info.ftl" as info >

<#function cs_ADC_settings motor internal_opamps=false >
    <#local timer = utils.v("PWM_TIMER_SELECTION", motor) >

    <#local adc_idx = motor>

    <#local adc = ns_ip.collectIP( utils.v("ADC_${adc_idx}_PERIPH", motor) )>

    <#local ranks = internal_opamps?then(1,2) >
    <#if internal_opamps >
        <#local infs1  = fp.map_ctx(motor, info.adc_info, [["U"]
                                                          ,["V"]][adc_idx-1]) >
    <#else>
        <#local infs1  = [
            [ info.adc_info(1, "V")   ,  info.adc_info(2, "V")
            , info.adc_info(1, "U")   ,  info.adc_info(2, "U") ]
        ,
            [ info.adc_info(1, "U")   ,  info.adc_info(2, "U")
            , info.adc_info(1, "W")   ,  info.adc_info(2, "W") ]
        ][adc_idx-1] >
    </#if>

    <#local sectionTitle = "${adc} settings for Current Sensing " >

    <#local adc_1_sectionTitle = "${adc} settings for Current Sensing" >
    <#local adc_1_settings  = ns_ip.IP_settings(adc_1_sectionTitle, adc, ap.cs_adc_parameters(timer, "3Sh", infs1)) >
    <#local adc_1_settings_parameters = adc_ov.update_ADCs_IPParameters( adc_1_settings ) >

    <#local installed_recoveries = ap.recovery_4_extra_regular_cnv_and_ScanConvMode(adc, infs1[0]) >


    <#if internal_opamps >
        <#local ctx1 = {"adc" : adc}>
        <#-- since there ia an internal OPAMP, the pin Label will used from it, so I set a pinLabel == "" her eon the ADC pin-->
        <#local ctx1 = ctx1 + {"pinLabel": "" }>
        <#local gpios1 = fp.map_ctx(ctx1, ap.cs_create_adc_pins, infs1) >
    <#else>
        <#local gpios1 = ext_opamp_ADC_generate_gpio_pins(motor) >
    </#if>

    <#return
        { "settings" :
                { sectionTitle : ui._comment("The ${adc} settings section was POSTPONED.\nIt will be part of a cumulative section dedicated to all ADCs")
                , "${adc} IRQ" : ap.cs_adc_irq(adc)
                }
        , "GPIOs"    : gpios1
        }>
</#function>

<#function ext_opamp_ADC_generate_gpio_pins motor>
    <#local adc1 = ns_ip.collectIP( utils.v("ADC_1_PERIPH", motor) )>
    <#local adc2 = ns_ip.collectIP( utils.v("ADC_2_PERIPH", motor) )>

    <#return [
        [ ap.cs_create_adc_pins( {"adc" : adc1}, info.adc_info(1, "U") )
        , ap.cs_create_adc_pins( {"adc" : adc2}, info.adc_info(1, "U") )
        , ap.cs_create_adc_pins( {"adc" : adc1}, info.adc_info(1, "V") )
        , ap.cs_create_adc_pins( {"adc" : adc2}, info.adc_info(1, "W") )]
        ,
        [ ap.cs_create_adc_pins( {"adc" : adc1}, info.adc_info(2, "U") )
        , ap.cs_create_adc_pins( {"adc" : adc2}, info.adc_info(2, "U") )
        , ap.cs_create_adc_pins( {"adc" : adc1}, info.adc_info(2, "V") )
        , ap.cs_create_adc_pins( {"adc" : adc2}, info.adc_info(2, "W") )]
        ] [motor-1] >
</#function>