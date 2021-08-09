<#import "../../../ui.ftl" as ui >

<#macro R1___L4XX_PWMCurrFdbk motor device sense>
    <#local topComment>R1___L4XX_PWMCurrFdbk M${motor} ${device} ${sense}</#local>
    <@ui.comment topComment />
    <#if motor == 2  >
        <@ui.box "The device doesn't support DUALDRIVE mode" '' '.' />
        <#return>
    </#if>
    <#import "L4/R1_x/R1_x_L4_all_settings.ftl" as all>
    <@all.R1_x_L4_all_settings motor device sense />
</#macro>


<#macro R3_1_L4XX_PWMCurrFdbk motor device sense>
    <#local topComment>R3_1_L4XX_PWMCurrFdbk: motor=${motor} device=${device} sense=${sense}</#local>
    <@ui.comment topComment />
    <#if motor == 2 >
        <@ui.box "The device doesn't support DUALDRIVE mode" '' '.' />
        <#return>
    </#if>
    <#import "L4/R3_1/R3_1_L4_all_settings.ftl" as R3_1_L4>
    <@R3_1_L4.R3_1_L4_all_settings motor device sense />
</#macro>


<#macro R3_4_L4XX_PWMCurrFdbk motor device sense>
    <#import "L4/R3_4/R3_4_L4_all_settings.ftl" as ns>
    <@ns.R3_4_L4_all_settings motor device sense />
</#macro>

<#macro ICS__L4XX_PWMCurrFdbk motor device sense>
    <#local topComment>ICS__L4XX_PWMCurrFdbk: motor=${motor} device=${device} sense=${sense}</#local>#
    <@ui.box topComment />
    <#import "L4/ICS/ICS_L4_all_settings.ftl" as ics>
    <@ics.ICS_L4_all_settings motor device sense />
</#macro>