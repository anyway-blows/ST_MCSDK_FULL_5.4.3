<#--

  +-------------+-------------------------------+---------+-------------+--------+-------------------------------------------+
  | wb define   | wb_combo_label                | Packege | MX Part No  | Family | ioc seed file                             |
  +-------------+-------------------------------+---------+-------------+--------+-------------------------------------------+
  |             |                               | LQFP64  | STM32L476RG |   L4   | STM32L476RG - ${clk_MHz} MHz              |
  | STM32L476XX | STM32L476XX                   |---------+-------------+--------+-------------------------------------------+
  |             |                               | LQFP144 | STM32L476ZG |   L4   | STM32L476ZG - ${clk_MHz} MHz              |
  +-------------+-------------------------------+---------+-------------+--------+-------------------------------------------+
  |             |                               | LQFP100 | STM32L452VE |   L4   | STM32L452VE - ${clk_MHz} MHz              |
  | STM32L452XX | STM32L452XX                   |---------+-------------+--------+-------------------------------------------+
  |             |                               | LQFP64  | STM32L452RE |   L4   | STM32L452RE - ${clk_MHz} MHz              |
  +-------------+-------------------------------+---------+-------------+--------+-------------------------------------------+
-->
<#import "../../../support/utils.ftl" as utils>
<#import "../../../support/ui.ftl" as ui>

<#function l4_ioc_seed wb_mcu_define hw>
    <#local file_prefix = wb_mcu_define?switch(
    <#-- wb define        | file prefix   -->

    "STM32L476XX"     , "STM32L476ZG"
    "STM32L476ZG"     , "STM32L476ZG"
    "STM32L476RG"     , "STM32L476RG"

    "STM32L452XX"     , "STM32L452VE"
    "STM32L452VE"     , "STM32L452VE"
    "STM32L452RE"     , "STM32L452RE"



    <#-- otherwise -->  ""            )
    >
    <#local src =  hw.int_clk_src?then(" - int", "") >

    <#return file_prefix?has_content?
    then( "${file_prefix}/${file_prefix} - ${hw.clk_MHz} MHz${ src }.ftl"
    , "../ERROR_unsupported_device.ftl"
    )>
</#function>

<#macro include_l4_seed_file wb_mcu_define hw>
    <#local file = l4_ioc_seed(wb_mcu_define, hw) >
    <@ui.comment
    [ "mcu: ${wb_mcu_define}"
    , "seed file: ${file}"
    , "clk: ${clk_MHz} MHz"
    ]?join("\n") />
    <@ui.hline "x" />

    <#global DAC1 = "DAC" >
    <#include file >
    <#--<#include "../cmns/basic_ips_and_pins_int.ftl">-->
    <#include "../../mcus/cmns/FreeRTOS_IsAvaliable.ftl">
</#macro>
<@include_l4_seed_file cpu.PN hw/>

