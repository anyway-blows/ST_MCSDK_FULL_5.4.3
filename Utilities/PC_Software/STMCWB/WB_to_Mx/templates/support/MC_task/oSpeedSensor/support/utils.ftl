<#import "../../../ui.ftl" as ui >

<#macro oSpeedSensor_unable_to_find_macro who motor>
    <@ui.comment "oSpeedSensor: ERROR - unable to find the macro definition to be called with: sensor=${who} motor=${motor}" />
</#macro>

<#--<#function ENCO_SpeedSensorMacro macroName ctx>
    <#if macroName?has_content
      && ctx[macroName]??
      && ctx[macroName]?is_macro >
        <#return ctx[macroName]>
    <#else>
        <#return oSpeedSensor_unable_to_find_macro >
    </#if>
</#function>-->

<#macro oSpeedSensor_doNothing who motor></#macro>

<#macro speed_sensing_no_request sensor motor>
    <@ui.comment "NO SPEED SENSING REQUIRED for M${motor} on sensor ${sensor}" />
</#macro>

