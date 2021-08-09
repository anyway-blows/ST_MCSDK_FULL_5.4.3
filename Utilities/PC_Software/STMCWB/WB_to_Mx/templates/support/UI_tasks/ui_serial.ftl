<#import "../MC_task/utils/meta_parameters.ftl" as meta >

<#import "../utils.ftl"     as utils >
<#import "../names_map.ftl" as rr >
<#import "../MC_task/utils/pins_mng.ftl" as ns_pin>
<#import "../MC_task/utils/ips_mng.ftl"  as ns_ip>

<#function serial_settings>
<#--
    /* Serial communication */
    #define USART_SELECTION                 USE_USART2
    #define USART_REMAPPING                 NO_REMAP_USART2

    #define USART_TX_GPIO_PORT              GPIOA
    #define USART_TX_GPIO_PIN               GPIO_Pin_2

    #define USART_RX_GPIO_PORT              GPIOA
    #define USART_RX_GPIO_PIN               GPIO_Pin_3

    #define USART_SPEED						115200



    SERIAL_COM_MODE        COM_UNIDIRECTIONAL | COM_BIDIRECTIONAL


    ###############################################################################

    NVIC.USART2_IRQn=true\:3\:1\:true\:false\:true\:true

    USART2.BaudRate=${USART_SPEED}
    USART2.VirtualMode-Asynchronous=VM_ASYNC
    USART2.WordLength=WORDLENGTH_8B
    USART2.IPParameters=BaudRate,WordLength,VirtualMode-Asynchronous

    # TX
    PA2.GPIOParameters=GPIO_Speed,GPIO_PuPd,GPIO_Label,GPIO_Mode
    PA2.GPIO_Label=USART_TX
    PA2.GPIO_Mode=GPIO_MODE_AF_PP
    PA2.GPIO_PuPd=GPIO_NOPULL
    PA2.GPIO_Speed=GPIO_SPEED_FREQ_LOW
    PA2.Locked=true
    PA2.Mode=Asynchronous
    PA2.Signal=USART2_TX

    # RX
    PA3.GPIOParameters=GPIO_Speed,GPIO_PuPd,GPIO_Label,GPIO_Mode
    PA3.GPIO_Label=USART_RX
    PA3.GPIO_Mode=GPIO_MODE_AF_PP
    PA3.GPIO_PuPd=GPIO_NOPULL
    PA3.GPIO_Speed=GPIO_SPEED_FREQ_LOW
    PA3.Locked=true
    PA3.Mode=Asynchronous
    PA3.Signal=USART2_RX

-->
    <#local sx = [] >

    <#if WB_SERIAL_COMMUNICATION >
        <#local ip = ns_ip.collectIP( utils.mx_name( utils._last_word(USART_SELECTION) ) ) >

        <#if SERIAL_COM_MODE == "COM_BIDIRECTIONAL" >
            <#local virtual_mode = "VirtualMode-Asynchronous" >
            <#local mode = "" >
            <#local mode_tx = "" >
        <#else>
            <#local virtual_mode = "VirtualMode-Half_duplex(single_wire_mode)" >
            <#local mode = ",Mode" >
            <#local mode_tx ="${ip}.Mode=MODE_TX" >
        </#if>



        <#local irqs = utils.mx_name("USART_IRQs") >
        <#local ip_usart = ( irqs?is_hash && irqs[ip]?? )?then(irqs[ip], ip) >
<#--
        <#if irqs?is_hash && irqs[ip]?? >
            <#local ip_usart = irqs[ip] >
        <#else>
            <#local ip_usart = ip >
        </#if>
-->
        <#import "../../support/FreeRTOS/Has_RTOS.ftl" as rtos >
        <#if rtos.has_rtos()>
            <#local irq_set = (WB_RTOS_USE_IRQ!false)?then(
                                                           [true, 8,  0, true, false, false, true , true],
                                                           [true, 3,  0, true, false, false, false, true])>
        <#else>
            <#local irq_set = [true, 3, rr.USER_IRQ_SUB_PRI!1, true, false, false, true] >
        </#if>

        <#local sx = sx + [mode_tx] +
            [ "# ${ip} General Settings"
            , "${ip}.BaudRate=${USART_SPEED}"
            , "${ip}.WordLength=WORDLENGTH_8B"

            , "${ip}.${virtual_mode}=VM_ASYNC"
            , "${ip}.IPParameters=BaudRate,WordLength,${virtual_mode}${mode}"

            , "\n# IRQ for ${ip_usart}"
            <#--, "\n# IRQ for ${ip}"-->
            , ns_ip.ip_irq(ip_usart, irq_set)
            , "\n# GPIOs"
            ]>

    <#-- GPIO TX and/or RX -->




        <#if SERIAL_COM_MODE == "COM_BIDIRECTIONAL" >
            <#local sx = sx + serial_gpio(ip, "TX", true) >
            <#local sx = sx + serial_gpio(ip, "RX", true) >
        <#else>
            <#local sx = sx + serial_gpio(ip, "TX", false) >
        </#if>
    </#if>

    <#return sx >
</#function>


<#function serial_gpio ip ch full=true>
    <#local mode = full?then("Asynchronous", "Half_duplex(single_wire_mode)") >

    <#local pin = ns_pin.name2(1, "USART_${ch}") >
    <#--<#local pin = ns_pin.name( "USART_${ch}_GPIO_PORT"?eval, "USART_${ch}_GPIO_PIN"?eval ) >-->

    <#local mode = rr["UART_${ch}_MODE"]!"AF_PP" >

    <#if SERIAL_COM_MODE == "COM_UNIDIRECTIONAL" >
        <#local gpio_speed = "HIGH" >

        <#local defaultOD  = ",GPIO_ModeDefaultOD">
        <#local pin_OD     = "${pin}.GPIO_ModeDefaultOD=GPIO_MODE_${mode}">

    <#else>
        <#local gpio_speed  = "LOW" >
        <#local defaultOD   = "" >
        <#local pin_OD      = "" >
    </#if>


    <#return
        [ "# ${ch}"
        , "${pin}.GPIOParameters=GPIO_Speed,GPIO_PuPd,GPIO_Label,GPIO_Mode${defaultOD}"
        , "${pin}.GPIO_Label=UART_${ch}"
        , "${pin}.GPIO_Mode=GPIO_MODE_${mode}"
        , "${pin}.GPIO_PuPd=GPIO_NOPULL"
        , "${pin}.GPIO_Speed=GPIO_SPEED_FREQ_${gpio_speed}"
        , "${pin}.Locked=true"
        , "${pin}.Mode=${mode}"
        , "${pin}.Signal=${ip}_${ch}"
        ]
        +
        [pin_OD]
    >
</#function>