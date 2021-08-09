<#import "../../ui.ftl" as ui >
<#--<#include "../../utils.ftl">-->

<#macro used_Mcu_xs t suffix xs >
    <@ui.boxed "Mcu ${t}s" >
        <#list xs>
            <#items as x>
                <#local str>Mcu.${t}${ x?index }=${ x }</#local>
                <@ui.line str />
            </#items>
            <@ui.line "Mcu.${t}${suffix}Nb=${xs?size}" />
        <#else>
            <@ui.box "NO ${t}s Configured" '' '' false/>
        </#list>
    </@ui.boxed>
</#macro>

<#--
<#macro used_Mcu_xs2 t suffix xs >
    <@ui.boxed "Mcu ${t}s" >
        <#list xs as k, v>
            <#local str>Mcu.${t}${ k?index }=${ k }</#local>
            <@ui.line str />
            <#if v?has_content >
                <@ui.line v />
            </#if>
        </#list>
        <#if xs?has_content >
            <@ui.line "Mcu.${t}${suffix}Nb=${xs?size}" />
        <#else>
            <@ui.box "NO ${t}s Configured" '' '' false/>
        </#if>
    </@ui.boxed>
</#macro>
-->
