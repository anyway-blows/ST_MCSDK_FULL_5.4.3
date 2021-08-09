<#import "ui.ftl" as ui >
<#macro task title condition if_not_enabled="disabled by config">
    <#if condition >
        <#nested >
    <#else >
        <@ui.messageBox title if_not_enabled />
    </#if>
</#macro>
