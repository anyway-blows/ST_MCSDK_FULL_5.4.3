<#import "../utils.ftl" as utils >
<#import "../ui.ftl" as ui >
<#import "../../config.ftl" as config>

<#-- -->
<#function gpio_def motor item pinName>
    <#local left  = "M${motor}_${ item }_GPIO" >
    <#local right = utils.quote(pinName) >
    <#return "${left?right_pad(80,' ')} = ${right?right_pad(10)}" >
</#function>

<#macro define_and_show_as_comment definitions>
    <#local ret = "<#global ${definitions} >" >
    <#if config.show_new_GPIO_def_comment!true >
        <@ui.comment ret />
    </#if>
    <@ret?interpret  />
</#macro>

<#function simplify_GPIO_def motor item>
    <#local m = (motor==1)?then('', '2')>

    <#local port_src = "${item}_GPIO_PORT${m}" >
    <#local pin_src  = "${item}_GPIO_PIN${m}"  >

    <#if (port_src?eval)?? && (pin_src?eval)?? >

        <#local port = utils._last_char( port_src?eval ) >
        <#local pin  = utils._last_word( pin_src?eval  ) >
        <#local pinName = "P${port}${pin}"
                                    ?replace("\\#",   "#")
                                    ?replace(  "#", "\\#")
                                    ?replace("\\ ",   " ") >

        <#local definitions = [ gpio_def(motor, item, pinName) ]>
        <#if item == "PHASE_CURRENTS">
            <#local definitions = definitions + [ gpio_def(motor, "PHASE_x", pinName) ]  >
        </#if>
        <#local str_defs = definitions?join('\n         ') >
        <#local ret = "<@define_and_show_as_comment '${definitions?join('\n         ')}' />" >
    <#else>
        <#local ret = "<@ui.comment 'Missing \"${port_src}\"\n and/or \"${pin_src}\"' />" >
    </#if>

    <#return ret >
</#function>
<#-- -->
<#macro expose_symplified_GPIO_to_freemarker >
    <#list .data_model as key, value>
        <#assign res = "${key}"?matches("^(.*)_GPIO_PORT$")>
        <#if res>
            <#local item = res?groups[1] >
            <@simplify_GPIO_def(1, item)?interpret />
            <#if .globals["${item}_GPIO_PORT2"]?? >
                <@simplify_GPIO_def(2, item)?interpret />
            </#if>
        </#if>
    </#list>
</#macro>
<@expose_symplified_GPIO_to_freemarker />