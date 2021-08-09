<#if ! _ParametersConversion_ftl?? >
    <#assign _ParametersConversion_ftl = 1 >
    <#import "../ui.ftl" as ui>
<#--

-->
    <#import "../names_map.ftl" as rr>
    <#assign ADC_PIN_MODE_SUFFIX = "" in rr>
    <#switch cpu.family >
        <#case 'F0' >
        <#case 'F1' >
        <#case 'F2' >
        <#case 'F3' >
        <#case 'F4' >
        <#case 'F7' >
        <#case 'L4' >
        <#case 'G0' >
        <#case 'G4' >
            <#include "device_specific/Parameters conversion_${cpu.family}xx.ftl" >
            <#break >
        <#default>
            <@ui.box "ERROR: \"Parameter conversion.ftl\" NON MCU DEFINITION FOUND for ${cpu.family}" />
    </#switch>
</#if>
