<#--
  +-------------+-------------------------------+---------+-------------+--------+-------------------------------------------+
  | wb define   | wb_combo_label                | Packege | MX Part No  | Family | ioc seed file                             |
  +-------------+-------------------------------+---------+-------------+--------+-------------------------------------------+
  |             |                               | LQFP64  | STM32G431RB |   G4   | STM32G431RB - ${clk_MHz} MHz              |
  | STM32G431RB | STM32G431RB                   |---------+-------------+--------+-------------------------------------------+
  |             |                               |         |             |        |                                           |
  +-------------+-------------------------------+---------+-------------+--------+-------------------------------------------+
  |             |                               | UFQFPN48| STM32G431CB |   G4   | STM32G431CB - ${clk_MHz} MHz              |
  |STM32G431ESC | STM32G431ESC                  |---------+-------------+--------+-------------------------------------------+
  |             |                               |         |             |        |                                           |
  +-------------+-------------------------------+---------+-------------+--------+-------------------------------------------+
  |             |                               | LQFP128 | STM32G474QE |   G4   | STM32G474QE - ${clk_MHz} MHz              |
  | STM32G474QE | STM32G474QE                   |---------+-------------+--------+-------------------------------------------+
  |             |                               |         |             |        |                                           |
  +-------------+-------------------------------+---------+-------------+--------+-------------------------------------------+

-->

<#import "../../../support/utils.ftl" as utils>
<#import "../../../support/ui.ftl" as ui>

<#function g4_ioc_seed wb_mcu_define hw>
    <#local file_prefix = wb_mcu_define?switch(
    <#-- wb define        | file prefix   -->

    "STM32G431RB"     , "STM32G431RB"

    "STM32G431CB"     , "STM32G431CB"

    "STM32G474QE"     , "STM32G474QE"

    <#-- otherwise -->  ""            )
    >
    <#local src =  hw.int_clk_src?then(" - Int", " - Ext") >

    <#return file_prefix?has_content?
    then( "${file_prefix}/${file_prefix} - ${hw.clk_MHz} MHz${ src }.ftl"
    , "../ERROR_unsupported_device.ftl"
    )>
</#function>

<#macro include_g4_seed_file wb_mcu_define hw>
    <#local file = g4_ioc_seed(wb_mcu_define, hw) >
    <@ui.comment
    [ "mcu: ${wb_mcu_define}"
    , "seed file: ${file}"
    , "clk: ${clk_MHz} MHz"
    ]?join("\n") />
    <@ui.hline "x" />

    <#global DAC1 = "DAC1" >
    <#include file >
    <#--<#include "../cmns/basic_ips_and_pins_int.ftl">-->
    <#include "../../mcus/cmns/FreeRTOS_IsAvaliable.ftl">
</#macro>
<@include_g4_seed_file cpu.PN hw/>

