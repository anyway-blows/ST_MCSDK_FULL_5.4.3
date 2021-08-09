<#import "../../../../../ui.ftl" as ui>
<#import "../../../../../utils.ftl" as utils>
<#import "../../../../ADC/adc_overlap.ftl" as adc_ov>

<#import "../../../../utils/meta_parameters.ftl" as meta>
<#import "../../../../utils/pins_mng.ftl"        as ns_pin>
<#import "../../../../utils/ips_mng.ftl"         as ns_ip>

<#import "../com/G4_adc.ftl" as ap>
<#import "../../../../ADC/ADC_cs_info.ftl" as info >
<#import "../../../../../fp.ftl" as fp >

<#function cs_ADC_settings motor internal_opamps=false >
    <#local timer = utils.v("PWM_TIMER_SELECTION", motor) >

    <#local adc1 = ns_ip.collectIP( utils.v("ADC_1_PERIPH", motor) )>
    <#local adc2 = ns_ip.collectIP( utils.v("ADC_2_PERIPH", motor) )>

    <#local cnv_U = info.adc_info(motor, "U")
            cnv_V = info.adc_info(motor, "V") >

    <#local gpio_U = register_ADC_and_generatePinDefinition(adc1, [cnv_U], timer, internal_opamps, "ICS")
            gpio_V = register_ADC_and_generatePinDefinition(adc2, [cnv_V], timer, internal_opamps, "ICS") >

    <#local adc   = [ adc1, adc2 ] >
    <#local sectionTitle = "${ adc?join(' and ')} settings for Current Sensing " >
    <#return
        { "settings" :
            { sectionTitle : ui._comment("The ${adc?join(' and ')} settings section was POSTPONED.\nIt will be part of a cumulative section dedicated to all ADCs")
            , "${adc?join(' and ')} IRQ" : ap.cs_adc_irq(adc1)
            }
        , "GPIOs"    : gpio_U + gpio_V
        }>
</#function>

<#function register_ADC_and_generatePinDefinition adc infs timer internal_opamps, sense>
    <#local installed_recoveries = ap.recovery_4_extra_regular_cnv_and_ScanConvMode(adc, infs[0]) >


    <#local adc_sectionTitle = "${adc} settings for ICS Current Sensing" >
    <#local adc_settings  = ns_ip.IP_settings(adc_sectionTitle, adc, ap.cs_adc_parameters(timer, sense, infs, WB_USE_3OPAMPS!false))>
    <#-- the following will store the ADC parameters for later use  -->
    <#local adc_settings_parameters = adc_ov.update_ADCs_IPParameters( adc_settings ) >

    <#-- when we use internal OPAMP, the pin Label will be one imposed by the opampOut, so here I set a pinLabel == "" for the ADC pin -->
    <#local ctx  = internal_opamps?then
        ( {"adc": adc, "pinLabel": ""}
        , {"adc": adc}
        ) >
    <#return fp.map_ctx(ctx, ap.cs_create_adc_pins, infs) >

</#function>


<#--

+----+-------+-------+
| id |  M1   |   M2  |
+----+-------+-------+
|  0 |  Sh1  |  Sh1  |
|  1 |  Sh1  |  Sh3  |
|  2 |  Sh1  |  ICS  | /!\
+----+-------+-------+
|  3 |  Sh3  |  Sh1  |
|  4 |  Sh3  |  Sh3  |
|  5 |  Sh3  |  ICS  | /!\
+----+-------+-------+
|  6 |  ICS  |  Sh1  | /!\
|  7 |  ICS  |  Sh3  | /!\
|  8 |  ICS  |  ICS  | /!\
+----+-------+-------+

/!\ ICS FW hard coded ADC1 for phase U and ADC2 for Phase V

Configurations id2 and id6 can work if the Sh1 will use the ADC3 or 4 and this is assured/controlled by WB only when the user allocate ADC1/2 for ICS
so it is up to the user to guarantee the right allocation  for the used ADCs in ICS!

Configurations id5 and id7 can work if the Sh3 will use the ADC3/4 and this is assured by WB only when the user allocate ADC1/2 for ICS
even in this case, it is up to the user to guarantee the right allocation for the used ADCs in ICS!

Configuration 8 cannot works due to the fixed allocation of ADC1/2 by the Fw in both Motors.
This Configuration, will require Fw modification to be usable.


-->
