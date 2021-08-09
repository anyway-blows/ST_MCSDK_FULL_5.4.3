<#import "../ui.ftl" as ui>
<#import "../fp.ftl" as fp>

<#function driverFunctionName ip >
    <#if ip == "RCC">
        <#return "SystemClock_Config">

    <#elseif ip?starts_with("USART") || ip?starts_with("UART") >
        <#return "MX_${ip}_UART_Init">

    <#else>
        <#return "MX_${ip}_Init">
    </#if>
</#function>
<#function driverVisibility ip >
    <#return (ip != "RCC")?c >
</#function>


<#function mc_used_ips ip >
    <#return ! ["NVIC", "SYS"          <#-- do not support Driver -->
               , "MotorControl", "RCC", "DMA" <#-- their rank have to be modified -->
               ]?seq_contains(ip) >
</#function>
<#function supportDriverLL ip >
    <#return ! ["MotorControl"]?seq_contains(ip) >
</#function>
<#function driver ip>
    <#return supportDriverLL(ip)?then(TARGET_DRIVER!"HAL", "HAL") >
</#function>

<#function to_driver_item rank ip >
    <#--<#return "${driverFunctionName(ip) }-${ip}-false-${driver(ip)}-true" >-->
    <#return
        [ rank
        , driverFunctionName(ip)
        , ip
        , "false"
        , driver(ip)
        , driverVisibility(ip)
        ]?join("-") >
</#function>


<#function _apply_selected_driver used_IPs>
    <#local ips = (used_IPs?seq_contains("DMA"))?then([ "GPIO", "RCC", "DMA" ] , ["GPIO", "RCC"])
    + fp.filter(mc_used_ips, used_IPs?sort)
    + ["MotorControl"] >

    <#local items = [] >
    <#list ips as ip>
        <#local rank = (ip?index + 1)?c >
        <#local items += [ to_driver_item(rank, ip) ] >
    </#list>

    <#local target_driver = TARGET_DRIVER!"HAL">
    <#local draw = (target_driver == "HAL")?then(ui.comment, ui.line) >
    <#return
        { "draw" : draw
        , "body" : [ "ProjectManager.functionlistsort=\\" ] + items?join(",\\\n")?split("\n")
        , "target_driver" : target_driver
        }>
</#function>

<#macro apply_selected_driver used_IPs>
    <#local drv = _apply_selected_driver(used_IPs) >
    <@ui.boxed "DRIVER management - ${drv.target_driver}">
        <@drv.draw drv.body />
    </@ui.boxed>
</#macro>
