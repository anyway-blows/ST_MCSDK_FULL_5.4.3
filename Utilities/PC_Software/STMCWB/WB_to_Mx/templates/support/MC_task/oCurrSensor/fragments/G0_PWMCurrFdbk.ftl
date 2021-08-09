<#import "../../../ui.ftl" as ui >

<#macro R1___G0XX_PWMCurrFdbk motor device sense>
    <#local topComment>R3_1_G0XX_PWMCurrFdbk: motor=${motor} device=${device} sense=${sense}</#local>
    <@ui.comment topComment />
    <#if motor == 2 >
        <@ui.box "The STM32G0 devices doesn't support DUALDRIVE mode" '' '.' />
        <#return>
    </#if>
    <#import "G0/R1_1/G0_R1_1_all_settings.ftl" as G0_R1_1>
    <@G0_R1_1.G0_R1_1_all_settings motor device sense />
</#macro>

<#macro R3___G0XX_PWMCurrFdbk motor device sense>
    <#local topComment>R3___G0XX_PWMCurrFdbk: motor=${motor} device=${device} sense=${sense}</#local>
    <@ui.box topComment />
    <#if motor == 2 >
        <@ui.box "The STM32G0 devices doesn't support DUALDRIVE mode" '' '.' />
        <#return>
    </#if>
    <#import "G0/R3_1/G0_R3_1_all_settings.ftl" as G0_R3_1>
    <@G0_R3_1.G0_R3_1_all_settings motor device sense />
</#macro>