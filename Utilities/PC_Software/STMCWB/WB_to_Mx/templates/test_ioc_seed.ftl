<#setting locale="en_US">
<#setting number_format="computer">
<#setting boolean_format="true,false" >

<#--
MCU_TYPE         = "STM32F030x"
                   "STM32F031x"
                   "STM32F050x"
                   "STM32F051x"
                   "STM32F072x"
                   "STSPIN32F0"
                   "STM32F100x_LD"
                   "STM32F100x_MD"
                   "STM32F103x_HD"
                   "STM32F103x_LD"
                   "STM32F103x_MD"
                   "STM32F2xx"

                   "STM32F302X8"
                   "STM32F302xB"
                   "STM32F302xC"
                   "STM32F303xB"
                   "STM32F303xC"

                   "STM32F446xC_xE"
                   "STM32F4xx"

BOARD            = "CUSTOM"
CLOCK_FREQUENCY  = "CPU_CLK_72_MHZ"

TARGET_TOOLCHAIN = "EWARM"
-->
<#import "support/ui.ftl" as ui >
<#import "ioc_seed/hw_info.ftl" as hw >
<@ui.boxed "ioc file generated by ST MC-Workbench" >
    <#global cpu         = hw.cpu
             board       = hw.board
             projectName = "${MCU_TYPE}_${ hw.clk_MHz}_MHz_ioc_seed"
             >
    <@ui.comment "wb_mcu = \"${cpu.name}\"" />
    <@ui.comment "board  = \"${board.name}\" - mcu = ${board.mcu}" />
</@ui.boxed>

<#import "ioc_seed/ioc_init.ftl" as ioc_init >
<@ioc_init.init_ioc hw />

<#import "support/MC_task/utils/pins_mng.ftl" as ns_pin>
<@ns_pin.used_Mcu_Pins />

<#import "support/MC_task/utils/ips_mng.ftl" as ns_ip>
<@ns_ip.used_Mcu_IPs />

<#import "support/MC_task/utils/user_constants.ftl" as mcu>
Mcu.UserConstants=${ mcu.serialize_collected_defines() }
