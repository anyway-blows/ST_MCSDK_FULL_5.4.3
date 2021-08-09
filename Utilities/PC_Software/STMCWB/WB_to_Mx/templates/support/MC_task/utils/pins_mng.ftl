<#import "../../utils.ftl" as utils>
<#function name gpio_port gpio_pin>
    <#local pinName = "P${utils._last_char(gpio_port)}${utils._last_word(gpio_pin)}"
        ?replace("\\#",   "#")
        ?replace(  "#", "\\#")
        ?replace("\\ ",   " ")
    >
    <#return  collectPin( pinName ) >
</#function>

<#function name_ what motor=1>
    <#local m = (motor==1)?then('', '2')>
    <#return name( "${what}_GPIO_PORT${m}"?eval
                 , "${what}_GPIO_PIN${ m}"?eval) >
</#function>

<#function name2 motor item>
    <#local pinName = "M${motor}_${ item }_GPIO"?eval >
    <#return collectPin( pinName ) >
</#function>


<#function collectPin pinName>
<#--####################################################################################################################
 #-- HERE THE SIDE EFFECT
 #-->
    <#global PINs = pinDB() + { pinName: true } >
<#--
    <#if pinDB()[pinName]?? >
    </#if>
-->
<#--#################################################################################################################-->

    <#return pinName >
</#function>

<#function pinDB>
    <#return PINs!{} >
</#function>

<#import "used_Mcu_xs.ftl" as used_pins >
<#macro used_Mcu_Pins >
    <@used_pins.used_Mcu_xs "Pin" "s" pinDB()?keys />
</#macro>
