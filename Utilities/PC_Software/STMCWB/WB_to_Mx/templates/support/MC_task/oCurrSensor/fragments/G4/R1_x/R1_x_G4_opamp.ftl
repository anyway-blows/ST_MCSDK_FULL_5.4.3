<#import "../../../../../utils.ftl" as utils>
<#import "../../../../../ui.ftl" as ui>

<#import "../../../../utils/mcu_pin_setting_mng.ftl" as cs>
<#import "../../../../utils/pins_mng.ftl" as ns_pin>
<#import "../../../../utils/ips_mng.ftl"  as ns_ip >
<#import "../../../../utils/meta_parameters.ftl" as meta>

<#import "../com/G4_opamp.ftl" as cmns_op>


<#function cs_OPAMPs_settings motor>
    <#local opamp = cmns_op.opamp_srcs(motor, 0) >

    <#if ! opamp.USE_INTERNAL_OPAMP >
        <#return
            { "settings" : { "General Settings": ui._left_comment_line("INTERNAL_OPAMP NOT ENABLE") }
            , "GPIOs"    : []
            , "internal_opamp" : false
            }>
    </#if>

    <#local opamp_name = ns_ip.collectIP( opamp.name ) >

    <#local config = cmns_op.cs_single_OPAMP_settings(opamp, "") >
    <#return { "settings" : config.settings
             , "GPIOs"    : config.GPIOs
             , "internal_opamp" : true
             }>
</#function>


<#--
<#assign opamps_nonInvertingInput_pin_mapping = {
    "OPAMP1" : { "PA1"  : "IO0"
               , "PA7"  : "IO1"
               , "PA3"  : "IO2"
               , "PA5"  : "IO3" },

    "OPAMP2" : { "PA7"  : "IO0"
               , "PD14" : "IO1"
               , "PB0"  : "IO2"
               , "PB14" : "IO3" },

    "OPAMP3" : { "PB0"  : "IO0"
               , "PB13" : "IO1"
               , "PA1"  : "IO2"
               , "PA5"  : "IO3" },

    "OPAMP4" : { "PB13" : "IO0"
               , "PD11" : "IO1"
               , "PA4"  : "IO2"
               , "PB11" : "IO3" }
}>
<#function nonInverting opamp pin>
    <#return opamps_nonInvertingInput_pin_mapping[opamp][pin] >
&lt;#&ndash;
  { "OPAMP1" , { "PA1"  : "IO0"
               , "PA7"  : "IO1"
               , "PA3"  : "IO2"
               , "PA5"  : "IO3" },

    "OPAMP2" : { "PA7"  : "IO0"
               , "PD14" : "IO1"
               , "PB0"  : "IO2"
               , "PB14" : "IO3" },

    "OPAMP3" : { "PB0"  : "IO0"
               , "PB13" : "IO1"
               , "PA1"  : "IO2"
               , "PA5"  : "IO3" },

    "OPAMP4" : { "PB13" : "IO0"
               , "PD11" : "IO1"
               , "PA4"  : "IO2"
               , "PB11" : "IO3" }
    }
&ndash;&gt;
</#function>
-->
