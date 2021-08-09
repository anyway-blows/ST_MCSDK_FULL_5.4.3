<#import "../../../../../utils.ftl" as utils>
<#import "../../../../../ui.ftl" as ui>
<#import "../../../../../fp.ftl" as fp>

<#import "../../../../utils/mcu_pin_setting_mng.ftl" as cs>
<#import "../../../../utils/pins_mng.ftl" as ns_pin>
<#import "../../../../utils/ips_mng.ftl"  as ns_ip >
<#import "../../../../utils/meta_parameters.ftl" as meta>

<#import "../com/G4_opamp.ftl" as cmns_op>

<#function cs_OPAMPs_settings motor>
    <#local opamp1 = cmns_op.opamp_srcs(motor, 1) >
    <#local opamp2 = cmns_op.opamp_srcs(motor, 2) >
    <#local itemList= [{"opamp":opamp1, "phase": "U"}, {"opamp":opamp2, "phase": "V"}]>

    <#if WB_USE_3OPAMPS!false >
        <#local opamp3 = cmns_op.opamp_srcs(motor, 3) >
        <#local itemList = itemList + [{"opamp":opamp3, "phase": "W"}]>
    </#if>

    <#local setgs = []>
    <#local gpios = []>


    <#local sensing = utils.current_sensing_topology(motor) >

    <#--<#list [{"opamp":opamp1, "phase": "U"}, {"opamp":opamp2, "phase": "V"},{"opamp":opamp3, "phase": "W"}] as item>-->
    <#list itemList as item>
        <#if item.opamp.USE_INTERNAL_OPAMP >
            <#local store_opamp_name = ns_ip.collectIP( item.opamp.name ) >
            <#local config = cmns_op.cs_single_OPAMP_settings(item.opamp, item.phase) >

            <#local setgs = setgs + [config.settings] >
            <#local gpios = gpios + config.GPIOs    >

            <#-- PHASE W : configure the pin to be connected to the OPAMP2_VINP_SEC of the  -->
            <#if item.phase == "V" && ! sensing?contains("ICS") && !(WB_USE_3OPAMPS!false)  >
                <#local ctx = {"opamp" : config.ctx.opamp, "phase": "W"} >
                <#local pinW = cmns_op.create_opamp_pin(ctx, "VINP") >
                <#local gpios = gpios + [ pinW + {"signal" : "${pinW.signal}_SEC"} ] >
            </#if>
        </#if>
    </#list>





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
