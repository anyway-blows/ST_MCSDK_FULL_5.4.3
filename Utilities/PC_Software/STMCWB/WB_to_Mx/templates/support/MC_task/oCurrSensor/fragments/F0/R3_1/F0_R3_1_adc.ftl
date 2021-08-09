<#import "../../../../../utils.ftl" as utils>
<#import "../../../../../ui.ftl" as ui>
<#--
<#include "../../../../ADC/adc_overlap.ftl">

<#import "../../../../utils/meta_parameters.ftl" as meta>
<#import "../../../../utils/pins_mng.ftl"  as ns_pin>

-->
<#import "../../../../utils/ips_mng.ftl"   as ns_ip>
<#import "../../../../ADC/ADC_cs_info.ftl" as info >
<#import "../../../../../fp.ftl" as fp >

<#import "../../Fx_commons/cs_cmn_create_adc_pin.ftl" as adc_pin>
<#import "../../../../ADC/adc_overlap.ftl" as adc_ovp >

<#function cs_ADC_settings motor adc>
    <#local infs = fp.map_ctx(motor, info.adc_info, ["U","V", "W"]) >
    <#local gpios = fp.map_ctx({"adc": adc}, adc_pin.cs_create_adc_pins, infs) >

    <#local sectionTitle = "${adc} settings for Current Sensing" >
    <#local adc_settings  = ns_ip.IP_settings(sectionTitle, adc, F0_ADC_cs_parameters() ) >
    <#-- the following will store the ADC parameters for later use  -->
    <#local adc_settings_parameters = adc_ovp.update_ADCs_IPParameters( adc_settings ) >


    <#return
        { "settings" :
                { sectionTitle : ui._comment("The ${adc} settings section was POSTPONED.\nIt will be part of a cumulative section dedicated to all ADCs ")

                , "${adc} IRQ" : cs_adc_irq(adc)
                }
        , "GPIOs": gpios
        }>
</#function>

<#function update_ADCs_IPParameters adc_parameters>
<#-- adc_parameters must have the following structure:
{ "title"          : title
, "ip"             : the used IP, like ADC1
, "parameters"     : parameters
, "str_parameters" : string representation of the parameters
, "IPParameters"   : keys of parameters without IPParameters and meta Items (comments | text | blank)
}
It can pe produced with the function IP_settings(title, ip, parameters)
-->

    <#import "../../../../../shared_ip/ip_overlap.ftl" as ip_ov>
    <#return ip_ov.update_IP_parameters( adc_parameters )>
</#function>


<#function cs_adc_irq ip >
    <#--<#local irqs = { "ADC" : "ADC"} >-->
    <#--<#return ns_ip.ip_irq("ADC1", [true, 2, 0, true, false, false, true]) >-->
    <#return ui._comment(
    [ "It seems that this interrupt handler does not have to be enabled because,"
    , "perhaps, the reading is done through the DMA and therefore the signaling "
    , "of the end of conversion takes place through the interrupt of the latter."
    , ns_ip.ip_irq("ADC1", [true, 2, 0, true, false, false, true])
    ]) >
</#function>

<#import "../../../../utils/meta_parameters.ftl" as meta >
<#function F0_ADC_cs_parameters>
    <#return meta.comment("F0 does not require additional ADC parameter settings for Current settings") >
</#function>
