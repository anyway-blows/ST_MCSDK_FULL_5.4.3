<#import "../../../../../ui.ftl" as ui>
<#import "../../../../../utils.ftl" as utils>
<#import "../../../../../fp.ftl" as fp>

<#import "../../../../utils/mcu_pin_setting_mng.ftl" as cs>
<#import "../../../../utils/pins_mng.ftl" as ns_pin>
<#import "../../../../utils/ips_mng.ftl"  as ns_ip >
<#import "../../../../utils/meta_parameters.ftl" as meta>

<#import "../com/F3_opamp.ftl" as cmns_op>

<#function cs_OPAMPs_settings motor>
    <#local opamp_idx = motor >
    <#local opamp = cmns_op.opamp_srcs(motor, opamp_idx) >

    <#--<#local pin_U = opamp.OPAMP_VINP_GPIO>-->

    <#local setgs = []>
    <#local gpios = []>

    <#if opamp.USE_INTERNAL_OPAMP >
        <#local store_opamp_name = ns_ip.collectIP( opamp.name ) >
        <#local config = cmns_op.cs_single_OPAMP_settings(opamp, "U") >

        <#local setgs = setgs + [config.settings] >

        <#-- PINS -->
        <#--<#local pin_U = ns_pin.name2(motor, "OPAMP${opamp_idx}_NONINVERTINGINPUT_PHA") >-->
        <#local pin_V = ns_pin.name2(motor, "OPAMP${    1    }_NONINVERTINGINPUT_PHB") >
        <#local pin_W = ns_pin.name2(motor, "OPAMP${    2    }_NONINVERTINGINPUT_PHC") >
        <#local gpios = gpios + config.GPIOs + [ gpio_analog(opamp.name, "V", pin_V), gpio_analog(opamp.name, "W", pin_W) ]>
    </#if>

    <#local internal_opamps = setgs?has_content >

    <#if ! internal_opamps >
        <#local setgs = [ {"General Settings": ui._left_comment_line("INTERNAL_OPAMP NOT ENABLE") } ] >
    </#if>

    <#return
        { "settings" : fp.foldl(fp.concat, {}, setgs)
        , "GPIOs"    : gpios
        , "internal_opamps" : internal_opamps
        }>
</#function>

<#function gpio_analog opamp_name phase pin>
    <#local pinLabel = "CURR_SHUNT_${phase}" >
    <#local pinName = pin >

<#--
    PA9.GPIOParameters=GPIO_Label
    PA9.GPIO_Label=M1_CURR_SHUNT_W
    PA9.Locked=true
    PA9.Signal=GPIO_Analog
-->
    <#return
        { "name"   : pinName
        , "label"  : pinLabel
        , "signal" : "GPIO_Analog"
        , "mode"   : ""
        , "ip"     : {"name": opamp_name, "pin": "VINP"}
        }>
</#function>


<#--
OPAMP_TYPE_GAIN                     EXTERNAL
FEEDBACK_NET_FILTERING                 FALSE
OPAMP_PGAGAIN                              2
#
OPAMP_SELECTION                       OPAMP1
OPAMP_NONINVERTINGINPUT_GPIO             PA7
OPAMP_INVERTINGINPUT_GPIO                PA3
OPAMP_OUT_GPIO                           PA2
#
OPAMP1_SELECTION                      OPAMP1
OPAMP1_INVERTINGINPUT_GPIO               PA3
OPAMP1_NONINVERTINGINPUT_PHA_GPIO        PA1
OPAMP1_NONINVERTINGINPUT_PHB_GPIO        PA7
OPAMP1_OUT_GPIO                          PA2
#
OPAMP2_SELECTION                      OPAMP2
OPAMP2_INVERTINGINPUT_GPIO               PC5
OPAMP2_NONINVERTINGINPUT_PHA_GPIO        PB0
OPAMP2_NONINVERTINGINPUT_PHB_GPIO        PA7
OPAMP2_NONINVERTINGINPUT_PHC_GPIO        PB0
OPAMP2_OUT_GPIO                          PA6
-->
