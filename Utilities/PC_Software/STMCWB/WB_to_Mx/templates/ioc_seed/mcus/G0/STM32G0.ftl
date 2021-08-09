<#--
  +-------------+-------------------------------+---------+-------------+--------+-------------------------------------------+
  | wb define   | wb_combo_label                | Packege | MX Part No  | Family | ioc seed file                             |
  +-------------+-------------------------------+---------+-------------+--------+-------------------------------------------+
  |             |                               | LQFP64  | STM32G071RB |   GO   | STM32G071RB - ${clk_MHz} MHz              |
  | STM32GO71XX | STM32GO71XX                   |---------+-------------+--------+-------------------------------------------+
  |             |                               |         |             |        |                                           |
  +-------------+-------------------------------+---------+-------------+--------+-------------------------------------------+
  |             |                               | LQFP64  | STM32G081RB |   GO   | STM32G081RB - ${clk_MHz} MHz              |
  | STM32GO81XX | STM32GO81XX                   |---------+-------------+--------+-------------------------------------------+
  |             |                               |         |             |        |                                           |
  +-------------+-------------------------------+---------+-------------+--------+-------------------------------------------+
-->
<#import "../../../support/utils.ftl" as utils>
<#import "../../../support/ui.ftl" as ui>

<#function g0_ioc_seed wb_mcu_define hw>
    <#local file_prefix = wb_mcu_define?switch(
    <#-- wb define        | file prefix   -->

    "STM32G071XX"     , "STM32G071RB"
    "STM32G071RB"     , "STM32G071RB"

    "STM32G081XX"     , "STM32G081RB"
    "STM32G081RB"     , "STM32G081RB"

    <#-- otherwise -->  ""            )
    >
    <#local src =  hw.int_clk_src?then(" - Int", " - Ext") >

    <#return file_prefix?has_content?
    then( "${file_prefix}/${file_prefix} - ${hw.clk_MHz} MHz${ src }.ftl"
    , "../ERROR_unsupported_device.ftl"
    )>
</#function>

<#macro include_g0_seed_file wb_mcu_define hw>
    <#local file = g0_ioc_seed(wb_mcu_define, hw) >
    <@ui.comment
    [ "mcu: ${wb_mcu_define}"
    , "seed file: ${file}"
    , "clk: ${clk_MHz} MHz"
    ]?join("\n") />
    <@ui.hline "x" />

    <#global DAC1 = "DAC1" >
    <#include file >
    <#include "../cmns/basic_ips_and_pins_int.ftl">
</#macro>
<@include_g0_seed_file cpu.PN hw/>

