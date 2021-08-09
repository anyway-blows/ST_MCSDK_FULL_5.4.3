<#import "../../../ui.ftl" as ui >
<#import "../../../utils.ftl" as utils >
<#import "../../../fp.ftl" as fp >

<#macro F4_PWM_and_CurrentFdbk motor device sense_unused_here_>
    <@ui.comment "F4 PWM & CurrFdbk" />
    <#if motor == 2>
        <@ui.box "IMPLEMENTED in motor1 cycle" />
    <#else>
        <#local M1_sense = utils.current_sensing_topology(1)!"SINGLE_SHUNT" >
        <#if WB_NUM_MOTORS == 1>
            <@cs_F4_base_call 1 device M1_sense/>
<#--

        DUAL DRIVE  ==> WB_NUM_MOTORS == 2
-->
        <#else>
            <@ui.comment "DUAL DRIVE" />
            <#local M2_sense = utils.current_sensing_topology(2)!"SINGLE_SHUNT" >
            <#if M1_sense == "SINGLE_SHUNT" || M2_sense == "SINGLE_SHUNT">
                <@cs_F4_base_call 1 device M1_sense/>
                <@cs_F4_base_call 2 device M2_sense/>
            <#else>
                <@cs_F4_dual fp.map((utils.short_sense), [M1_sense, M2_sense]) />
            </#if>
        </#if>
    </#if>
</#macro>

<#macro cs_F4_base_call motor device sense>
    <#switch sense>
        <#case "SINGLE_SHUNT">
            <#import "F4/1Sh/F4_1Sh_tasks.ftl" as ns>
            <#break >
        <#case "THREE_SHUNT_INDEPENDENT_RESOURCES">
            <#import "F4/3Sh_IR/F4_3Sh_IR_tasks.ftl" as ns>
            <#break >
        <#case "THREE_SHUNT">
            <#import "F4/3Sh/F4_3Sh_tasks.ftl" as ns>
            <#break >
        <#case "ICS_SENSORS">
            <#import "F4/ICS/F4_ICS_tasks.ftl" as ns>
            <#break >
        <#default >
            <@ui.comment "${sense} not supported"/>
    </#switch>
    <#import "F4/com/F4_cs_tasks.ftl" as all>
    <@all.F4_all_settings ns.get_cs_sub_tasks() motor device sense />
</#macro>

<#macro cs_F4_dual senses>
    <#import "F4/dual_drive/F4_2Ms_all_settings_combining_3Sh_and_ICS.ftl" as ns_2Ms>
    <@ui.boxed "F4 current sense for DUAL DRIVE ${ senses?join(' ') }">
        <@ns_2Ms.F4_2Ms_all_settings_combining_3Sh_and_ICS 1, senses />
        <@ns_2Ms.F4_2Ms_all_settings_combining_3Sh_and_ICS 2, senses />
    </@ui.boxed>
</#macro>
<#--<#function short_sense sense>
    <#return sense?switch
        ( "THREE_SHUNT" , "3Sh"
        , "THREE_SHUNT_INDEPENDENT_RESOURCES" , "3Sh_IR"
        , "ICS_SENSORS" , "ICS"
        , "SINGLE_SHUNT", "1Sh"
        )>
</#function>-->
