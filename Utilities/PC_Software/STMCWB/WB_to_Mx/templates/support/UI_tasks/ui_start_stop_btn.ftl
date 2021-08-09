<#import "../utils.ftl" as utils >
<#import "../MC_task/utils/ips_mng.ftl"  as ns_ip>

<#function start_stop_btn_settings>
    <#if START_STOP_BTN >
        <#return start_stop_gpio() >
    <#else>
        <#return ui._comment("Disabled from WB") >
    </#if>
</#function>

<#function start_stop_gpio>

    <#local pin = ns_pin.name_("START_STOP") >
    <#local pin_num = pin[2..] >
    <#local vs_signal = "GPXTI${ pin_num }" >

    <#import "../names_map.ftl" as rr>
    <#local irq_name = EXT_IRQNbr(pin_num, rr["START_STOP_BTN_EXTI_IRQ"] ) >

<#--
#define START_STOP_GPIO_PORT             GPIOC
#define START_STOP_GPIO_PIN              GPIO_Pin_13
#define START_STOP_POLARITY              DIN_ACTIVE_LOW
START_STOP_BTN
-->
    <#local edge = (utils._last_word(START_STOP_POLARITY) == "LOW")?then("FALLING", "RISING")  >
    <#local pull = START_STOP_POLARITY_EDGE!"GPIO_NOPULL" >


    <#return
        [ "${pin}.GPIOParameters=GPIO_PuPd,GPIO_Label,GPIO_ModeDefaultEXTI"
        , "${pin}.GPIO_Label=Start/Stop [PushButton]"
        , "${pin}.GPIO_ModeDefaultEXTI=GPIO_MODE_IT_${edge}"
        , "${pin}.GPIO_PuPd=${pull}"
        , "${pin}.Locked=true"
        , "${pin}.Signal=${ vs_signal }"


        , ns_ip.ip_irq(irq_name, (rr["SET_IRQ_START_STOP"]![true, 3, 0, false, false, false, true]))

        , "SH.${vs_signal}.0=GPIO_EXTI${ pin_num }"
        , "SH.${vs_signal}.ConfNb=1"
        ]>
</#function>

<#function EXT_IRQNbr line handlers>
    <#list handlers as handler>
        <#if line?number <= (handler.line ) >
            <#return handler.name >
        </#if>
    </#list>
    <#return handlers?last >
</#function>
