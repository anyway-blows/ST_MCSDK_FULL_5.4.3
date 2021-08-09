<#import "../../../ui.ftl" as ui >

<#macro R1___F0XX_PWMCurrFdbk motor device sense>
    <#local topComment>R3_1_F0XX_PWMCurrFdbk: motor=${motor} device=${device} sense=${sense}</#local>
    <@ui.comment topComment />
    <#if motor == 2 >
        <@ui.box "The STM32F0 devices doesn't support DUALDRIVE mode" '' '.' />
        <#return>
    </#if>
    <#import "F0/R1_1/F0_R1_1_all_settings.ftl" as F0_R1_1>
    <@F0_R1_1.F0_R1_1_all_settings motor device sense />
</#macro>

<#macro R3___F0XX_PWMCurrFdbk motor device sense>
    <#local topComment>R3___F0XX_PWMCurrFdbk: motor=${motor} device=${device} sense=${sense}</#local>
    <@ui.box topComment />
    <#if motor == 2 >
        <@ui.box "The STM32F0 devices doesn't support DUALDRIVE mode" '' '.' />
        <#return>
    </#if>
    <#import "F0/R3_1/F0_R3_1_all_settings.ftl" as F0_R3_1>
    <@F0_R3_1.F0_R3_1_all_settings motor device sense />
</#macro>