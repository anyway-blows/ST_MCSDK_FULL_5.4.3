<#include "../../utils.ftl"   >
<#import  "../../ui.ftl" as ui >

<#macro block title sections section_separator='=' border='#'>
    <@ui.boxed title border>
        <#list sections as sec>
            <@digital_out_section sec/>
            <#sep><@ui.hline section_separator /></#sep>
        </#list>
    </@ui.boxed>
</#macro>

<#macro digital_out_section src>
    <#--################################################################################################################
     #  src have to be something like that
    { "label"    : string
    , "port"     : "GPIOx"
    , "pin"      : "GPIO_Pin_x"
    , "polarity" : "ACTIVE_LOW" | "ACTIVE_HIGH"
    }
    OR
    { "error": string }
    -->
    <#if src.error?has_content >
        <@ui.box src.error '' ''/>
    <#else >
        <@digital_out_pin_setting
            src.label
            src.port
            src.pin
            src.polarity />
    </#if>
</#macro>

<#function _digital_out_section src>
<#--################################################################################################################
 #  src have to be something like that
        { "label"    : string
        , "port"     : "GPIOx"
        , "pin"      : "GPIO_Pin_x"
        , "polarity" : "ACTIVE_LOW" | "ACTIVE_HIGH"
        }
        OR
        { "error": string }
-->
    <#if src.error?has_content >
        <#local ret><@ui.box src.error '' ''/></#local>
    <#else >
        <#local ret><@digital_out_pin_setting
        src.label
        src.port
        src.pin
        src.polarity /></#local>
    </#if>

    <#return ret>
</#function>

<#import  "../utils/pins_mng.ftl" as pins>
<#macro digital_out_pin_setting label port pinN polarity>
    <#local pinName = pins.name(port, pinN) >
    <#local topComment>Digital Output PIN setting ${label} on ${pinName}</#local>
    <@ui.box topComment '' '.' />
<#--


   it is correct to map ACTIVE_HIGH to PULLDOWN and ACTIVE_LOW to PULLUP -->
    <#local pull = _last_word(polarity)?switch("HIGH","PULLDOWN",  "LOW","PULLUP") >
${pinName}.GPIOParameters=GPIO_Speed,GPIO_PuPd,GPIO_Label
${pinName}.GPIO_Label=${label}
${pinName}.GPIO_PuPd=GPIO_${pull}
${pinName}.GPIO_Speed=GPIO_SPEED_FREQ_HIGH
${pinName}.Locked=true
${pinName}.Signal=GPIO_Output
</#macro>
