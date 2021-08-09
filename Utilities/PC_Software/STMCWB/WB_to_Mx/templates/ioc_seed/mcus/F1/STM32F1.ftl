<#--

  +-------------------------+----------------------------+---------+-------------+--------+-------------------------------+
  | wb define               | wb_combo_label             | Packege | MX Part No  | Family | ioc seed file                 |
  +-------------------------+----------------------------+---------+-------------+--------+-------------------------------+
  |STM32F103 High   Density | STM32F103 High   Density   | LQFP144 | STM32F103ZG |   F1   | STM32F103ZG - ${clk_MHz} MHz  |
  |STM32F103 Medium Density | STM32F103 Medium Density   | LQFP100 | STM32F103VB |   F1   | STM32F103VB - ${clk_MHz} MHz  |
  |STM32F103 Low    Density | STM32F103 Low    Density   | LQFP64  | STM32F103R6 |   F1   | STM32F103R6 - ${clk_MHz} MHz  |
  +-------------------------+----------------------------+---------+-------------+--------+-------------------------------+


  +----------------+--------------------------+--------------+----------+
  |                | MCU_TYPE                 | Targeted MCU | Package  |
  +----------------+--------------------------+--------------+----------+
  |                | STM32F103 High Density   | STM32F103ZG  | LQFP144  |
  | High Density   | STM32F103 High Density   | STM32F103ZE  | LQFP144  |
  |                | STM32F103 High Density   | STM32F103RC  | LQFP64   |
  +----------------+--------------------------+--------------+----------+
  | Medium Density | STM32F103 Medium Density | STM32F103VB  | LQFP100  |
  |                | STM32F103 Medium Density | STM32F103RB  | LQFP64   |
  +----------------+--------------------------+--------------+----------+
  | Low Density    | STM32F103 Low Density    | STM32F103R6  | LQFP64   |
  +----------------+--------------------------+--------------+----------+

-->
<#import "../../../support/utils.ftl" as utils>
<#import "../../../support/ui.ftl" as ui>

<#function f1_ioc_seed wb_mcu_define clk_MHz>
    <#local file_prefix = wb_mcu_define?switch(
    <#-- wb define        | file prefix   -->

    "STM32F103x_HD"    , "STM32F103ZG" ,
    "STM32F103ZG"      , "STM32F103ZG" ,
    "STM32F103ZE"      , "STM32F103ZE" ,
    "STM32F103RC"      , "STM32F103RC" ,
    "STM32F103x_MD"    , "STM32F103RB" ,
    "STM32F103VB"      , "STM32F103VB" ,
    "STM32F103RB"      , "STM32F103RB" ,

    "STM32F103x_LD"    , "STM32F103R6" ,
    "STM32F103R6"      , "STM32F103R6" ,

    <#-- otherwise -->  ""            )
    >
    <#return file_prefix?has_content?
    then( "${file_prefix}/${file_prefix} - ${clk_MHz} MHz.ftl"
    , "../ERROR_unsupported_device.ftl"
    )>
</#function>

<#macro include_f1_seed_file wb_mcu_define clk_MHz >
    <#local file = f1_ioc_seed(wb_mcu_define, clk_MHz) >
    <@ui.comment ["mcu: ${wb_mcu_define}", "seed file: ${file}", "clk: ${clk_MHz} MHz"]?join("\n") />
    <@ui.hline "x" />

    <#global DAC1 = "DAC" >
    <#include file >


    <#include "../../mcus/cmns/FreeRTOS_IsAvaliable.ftl">
</#macro>
<@include_f1_seed_file cpu.PN clk_MHz/>

