<#import "../../../ui.ftl" as ui >

<#macro R1___G4XX_PWMCurrFdbk motor device sense>
    <#local topComment>R1___G4XX_PWMCurrFdbk M${motor} ${device} ${sense}</#local>
    <@ui.comment topComment />
   <#-- <#if motor == 2  >
        <@ui.box "The device doesn't support DUALDRIVE mode" '' '.' />
        <#return>
    </#if>-->
    <#import "G4/R1_x/R1_x_G4_all_settings.ftl" as all>
    <@all.R1_x_G4_all_settings motor device sense />
</#macro>


<#macro R3_1_G4XX_PWMCurrFdbk motor device sense>
    <#local topComment>R3_1_G4XX_PWMCurrFdbk: motor=${motor} device=${device} sense=${sense}</#local>
    <@ui.comment topComment />
    <#if motor == 2 >
        <@ui.box "The device doesn't support DUALDRIVE mode" '' '.' />
        <#return>
    </#if>
    <#--<#import "G4/R3_1/R3_1_G4_all_settings.ftl" as R3_1_G4>-->
    <@ui.box "The device doesn't supported" '' '.' />
<#--<@ui.box "The device doesn't support DUALDRIVE mode2" '' '.' />-->
    <#--<@R3_1_G4.R3_1_G4_all_settings motor device sense />&ndash;&gt;-->
</#macro>


<#macro R3_4_G4XX_PWMCurrFdbk motor device sense>
    <#local topComment>R3_4_G4XX_PWMCurrFdbk: motor=${motor} device=${device} sense=${sense}</#local>
    <#import "G4/R3_4/R3_4_G4_all_settings.ftl" as ns>
    <@ns.R3_4_G4_all_settings motor device sense />
</#macro>

<#macro ICS__G4XX_PWMCurrFdbk motor device sense>
    <#local topComment>ICS__G4XX_PWMCurrFdbk: motor=${motor} device=${device} sense=${sense}</#local>
    <@ui.box topComment />
    <#import "G4/ICS/ICS_G4_all_settings.ftl" as ics>
   <#-- <@ui.box "The device doesn't support DUALDRIVE mode4" '' '.' />-->
    <@ics.ICS_G4_all_settings motor device sense />
    <#--<@ui.box "The device doesn't supported" '' '.' />-->
</#macro>

