<#setting locale="en_US">
<#setting number_format="computer">
<#setting boolean_format="true,false" >
<#import "support/ui.ftl" as ui >
<#import "config.ftl" as config>

<#import "header.ftl" as hh>
<#assign file_name = .current_template_name>
<@hh.header file_name>
    This file translates a Motor Control Workbench output file to a fully working STM32CubeMx project (ioc file).
</@hh.header>
<#--

-->
    <@ui.box "ioc file generated by ST MC-Workbench" />
    <#--<#include "support/utils.ftl" >-->
    <#include "support/data_model/known_values.ftl" >
    <#include "support/Definitions.ftl">
    <#include "support/data_model/expose_typed-defines_to_freemarker.ftl" >
    <#include "support/data_model/expose_symplified_GPIO_to_freemarker.ftl" >
    <#import "support/conditional_task.ftl" as task >
<#--

-->
    <#import "ioc_seed/hw_info.ftl" as hw >
    <#global cpu   = hw.cpu   >
    <#global board = hw.board >
    <@ui.comment "wb_mcu = \"${cpu.name}\"" />
    <@ui.comment "board  = \"${board.name}\" - mcu = ${board.mcu}" />
<#-- -->
    <#import "ioc_seed/ioc_init.ftl" as ioc_init >
    <@task.task "IOC INIT" config.mcu!true>
        <@ioc_init.init_ioc hw />
    </@task.task>
    <#global DAC1 = DAC1!"DAC">

    <@task.task "FORWARDs the WB generated #defines to MX" config.forward_defines_to_mx!true >
        <#include "support/data_model/forward_defines_to_mx.ftl" >
    </@task.task>

<#-- --------------------------------------------------------------------------------------------------------------- -->
<#-- Introduce additional defines according the selected device                                                      -->
<#-- --------------------------------------------------------------------------------------------------------------- -->
<#include "support/device_name_mapping.ftl" >
<#--

-->
<#-- --------------------------------------------------------------------------------------------------------------- -->
<#-- Parameter conversions and Mc_Task                                                                               -->
<#-- --------------------------------------------------------------------------------------------------------------- -->
<#include "support/parameters_conversion/Parameters conversion.ftl" >

<#import "support/MC_task/MC_task.ftl" as mc_tasks>
<@mc_tasks.MC_tasks config />

<#import "support/UI_tasks/UI_tasks.ftl" as ui_tasks>
<@ui_tasks.UI_tasks (config.ui)!{} />

<#import "support/PFC_tasks/PFC_tasks.ftl" as pfc_tasks>
<@pfc_tasks.PFC_tasks (config.pfc)!{} />

<#import "support/FreeRTOS/FreeRTOS_tasks.ftl" as FreeRTOS>
<@FreeRTOS.FreeRTOS_tasks />

<#import "support/shared_ip/ip_overlap.ftl" as ip_ov>
<@ui.comment "Consolidated IPs" />
<@ip_ov.consolidated_IPs_settings />


<#import "support/MC_task/utils/pins_mng.ftl" as ns_pin>
<@ns_pin.used_Mcu_Pins />

<#import "support/MC_task/utils/ips_mng.ftl" as ns_ip>
<@ns_ip.used_Mcu_IPs />

<#import "support/hal_ll_drivers/driver_mng.ftl" as ns_dr>
<@ns_dr.apply_selected_driver ns_ip.ipDB()?keys />

<#import "support/MC_task/utils/user_constants.ftl" as mcu>
Mcu.UserConstants=${ mcu.serialize_collected_defines() }

<@task.task "...more" config.more!false>
    <#import "more.ftl" as more>
    <@more.do_more />
</@task.task>

<#--
# CLOCK_SOURCE = ${ CLOCK_SOURCE }
# clk_MHz     = ${ hw.clk_MHz     }
# ext_clk_MHz = ${ hw.ext_clk_MHz }
# ext_clk_src = ${ hw.ext_clk_src?c }
# int_clk_src = ${ hw.int_clk_src?c }
-->
