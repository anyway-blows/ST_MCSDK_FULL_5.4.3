<#import "../../../ui.ftl" as ui >

<#macro ICS__F30X_PWMCurrFdbk motor device sense>
    <#local topComment>ICS__F30X_PWMCurrFdbk: motor=${motor} device=${device} sense=${sense}</#local>#
    <@ui.box topComment />
    <#import "F3/ICS/ICS_F3_all_settings.ftl" as ics>
    <@ics.ICS_F3_all_settings motor device sense />
</#macro>

<#macro R1___F30X_PWMCurrFdbk motor device sense>
    <#local topComment>R1___F30X_PWMCurrFdbk M${motor} ${device} ${sense}</#local>
    <@ui.comment topComment />
    <#if motor == 2 && device == "STM32F302X8" >
        <@ui.box "The STM32F302X8 device doesn't support DUALDRIVE mode" '' '.' />
        <#return>
    </#if>
    <#import "F3/R1_x/R1_x_F3_all_settings.ftl" as all>
    <@all.R1_x_F3_all_settings motor device sense />
</#macro>

<#macro R3_1_F30X_PWMCurrFdbk motor device sense>
    <#local topComment>R3_1_F30X_PWMCurrFdbk: motor=${motor} device=${device} sense=${sense}</#local>
    <@ui.comment topComment />
    <#if motor == 2 && device == "STM32F302X8" >
        <@ui.box "The STM32F302X8 device doesn't support DUALDRIVE mode" '' '.' />
        <#return>
    </#if>
    <#import "F3/R3_1/R3_1_F3_all_settings.ftl" as R3_1_F3>
    <@R3_1_F3.R3_1_F3_all_settings motor device sense />
</#macro>

<#macro R3_2_F30X_PWMCurrFdbk motor device sense>
    <#local topComment>R3_2_F30X_PWMCurrFdbk: motor=${motor} device=${device} sense=${sense}</#local>
    <@ui.comment topComment />
    <#import "F3/R3_2/R3_2_F3_all_settings.ftl" as ns>
    <@ns.R3_2_F3_all_settings motor device sense />
</#macro>

<#macro R3_4_F30X_PWMCurrFdbk motor device sense>
    <#import "F3/R3_4/R3_4_F3_all_settings.ftl" as ns>
    <@ns.R3_4_F3_all_settings motor device sense />
</#macro>