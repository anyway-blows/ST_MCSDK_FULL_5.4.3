<#import "../../../ui.ftl" as ui >

<#macro R1___F7XX_PWMCurrFdbk motor device sense>
    <#local topComment>R1___F7XX_PWMCurrFdbk M${motor} ${device} ${sense}</#local>
    <@ui.comment topComment />
    <#if motor == 2  >
        <@ui.box "The device doesn't support DUALDRIVE mode" '' '.' />
        <#return>
    </#if>
    <#import "F7/R1_x/R1_x_F7_all_settings.ftl" as all>
    <@all.R1_x_F7_all_settings motor device sense />
</#macro>


<#macro R3_1_F7XX_PWMCurrFdbk motor device sense>
    <#local topComment>R3_1_F7XX_PWMCurrFdbk: motor=${motor} device=${device} sense=${sense}</#local>
    <@ui.comment topComment />
    <#if motor == 2 >
        <@ui.box "The device doesn't support DUALDRIVE mode" '' '.' />
        <#return>
    </#if>
    <#import "F7/R3_1/R3_1_F7_all_settings.ftl" as R3_1_F7>
    <@R3_1_F7.R3_1_F7_all_settings motor device sense />
</#macro>


<#macro R3_4_F7XX_PWMCurrFdbk motor device sense>
    <#import "F7/R3_4/R3_4_F7_all_settings.ftl" as ns>
    <@ns.R3_4_F7_all_settings motor device sense />
</#macro>

<#macro ICS__F7XX_PWMCurrFdbk motor device sense>
    <#local topComment>ICS__F7XX_PWMCurrFdbk: motor=${motor} device=${device} sense=${sense}</#local>#
    <@ui.box topComment />
    <#import "F7/ICS/ICS_F7_all_settings.ftl" as ics>
    <@ics.ICS_F7_all_settings motor device sense />
</#macro>