<#import "../../utils/ips_mng.ftl" as ns_ip>
<#import "../../utils/pins_mng.ftl"  as ns_pin>
<#import "../../../ui.ftl" as ui >

<#macro GAP_F3_GateDriverCtrl motor >
    <@ui.line STGAP_F3_settings(motor)?join('\n') />
</#macro>

<#function STGAP_F3_settings motor >

<#--    <#local sx = [] >-->

<#--  When Data model will contain STGAP1AS parameters
<#local ip = ns_ip.collectIP( utils.mx_name( utils._last_word(STGAP1AS_SPI_SELECTION) ) ) >
-->
    <#local ip = ns_ip.collectIP("SPI2") >

    <#local general_settings =
    [ "# ${ip} General Settings"
    ,"${ip}.BaudRatePrescaler=SPI_BAUDRATEPRESCALER_64"
    ,"${ip}.CalculateBaudRate=562.5 KBits/s"
    ,"${ip}.CLKPhase=SPI_PHASE_2EDGE"
    ,"${ip}.DataSize=SPI_DATASIZE_16BIT"
    ,"${ip}.Direction=SPI_DIRECTION_2LINES"
    ,"${ip}.IPParameters=VirtualType,Mode,Direction,CalculateBaudRate,DataSize,BaudRatePrescaler,CLKPhase"
    ,"${ip}.Mode=SPI_MODE_MASTER"
    ,"${ip}.VirtualType=VM_MASTER"
    , "\n# GPIOs"
    ]>

<#--  When Data model will contain STGAP1AS parameters
 <#local sx = sx + spi_gpio(motor, ip, "MISO") >
 <#local sx = sx + spi_gpio(motor, ip, "MOSI") >
 <#local sx = sx + spi_gpio(motor, ip, "SCK") >
 <#local sx = sx + spi_gpio_output(motor, ip, "NSD") >
 <#local sx = sx + spi_gpio_output(motor, ip, "NCS") >
-->
<#--    <#local sx = sx + spi_gpio(motor, ip, "SCK",  ns_pin.collectPin( "PB13" )) >
    <#local sx = sx + spi_gpio(motor, ip, "MISO", ns_pin.collectPin( "PB14" )) >
    <#local sx = sx + spi_gpio(motor, ip, "MOSI", ns_pin.collectPin( "PB15" )) >
    <#local sx = sx + spi_gpio_output(motor, "NSD", ns_pin.collectPin( "PC9" )) >
    <#local sx = sx + spi_gpio_output(motor, "NCS", ns_pin.collectPin( "PD2" )) >

    <#return sx >-->

    <#return general_settings
    + spi_gpio(motor, ip,    "SCK", ns_pin.collectPin( "PB13" ))
    + spi_gpio(motor, ip,   "MISO", ns_pin.collectPin( "PB14" ))
    + spi_gpio(motor, ip,   "MOSI", ns_pin.collectPin( "PB15" ))
    + spi_gpio_output(motor, "NSD", ns_pin.collectPin( "PC9"  ))
    + spi_gpio_output(motor, "NCS", ns_pin.collectPin( "PD2"  ))
    >

</#function>

<#function spi_gpio motor ip ch pin>
<#--  When Data model will contain STGAP1AS parameters
    <#local pin = ns_pin.name2(motor, "STGAP1S_SPI_${ch}") >
-->
    <#return
    [ "# ${ch}"
    , "${pin}.GPIOParameters=GPIO_Label"
    , "${pin}.GPIO_Label=M${motor}_STGAP1S_SPI_${ch}"
    , "${pin}.Locked=true"
    , "${pin}.Mode=Full_Duplex_Master"
    , "${pin}.Signal=${ip}_${ch}"
    ]>
</#function>

<#function spi_gpio_output motor ch pin>
<#--  When Data model will contain STGAP1AS parameters
    <#local pin = ns_pin.name2(motor, "STGAP1S_SPI_${ch}") >
-->
    <#return
    [ "# ${ch}"
    , "${pin}.GPIO_Label=M${motor}_STGAP1S_SPI_${ch}"
    , "${pin}.GPIO_PuPd=GPIO_PULLUP"
    , "${pin}.GPIOParameters=PinState,GPIO_PuPd,GPIO_Label"
    , "${pin}.Locked=true"
    , "${pin}.PinState=GPIO_PIN_SET"
    , "${pin}.Signal=GPIO_Output"
    ]>
</#function>
