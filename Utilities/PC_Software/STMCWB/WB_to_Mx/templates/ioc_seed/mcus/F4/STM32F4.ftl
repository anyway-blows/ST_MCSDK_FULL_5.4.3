<#--
  +------------------------------------------------+-------------+--------+----------+---------------------------------------------------------+
  |                 from WORKBENCH                 |  WB_to_Mx
  +----------------+----------------+--------------+-------------+--------+----------+---------------------------------------------------------+
  | wb_combo_label | MCU_TYPE       | MCU          | cpn         | Family | Package  | ioc seed file                                           |
  +----------------+----------------+--------------+-------------+-------------------+---------------------------------------------------------+
  | STM32F4xx      | STM32F4xx      | STM32F417IG  | STM32F417IG |   F4   | UFBGA176 |  STM32F417IG - ${clk_MHz} MHz  - Ext_${ext_clk_MHz} MHz |
  |                |                | STM32F415ZG  | STM32F415ZG |        | LQFP144  |                                                         |
  |                |                | STM32F407IG  | STM32F407IG |        | UFBGA176 |                                                         |
  +----------------+----------------+--------------+-------------+-------------------+---------------------------------------------------------+
  | STM32F446xC_xE | STM32F446xC_xE | STM32F446ZE  | STM32F446ZE |   F4   | LQFP144  |  STM32F446ZE - ${clk_MHz} MHz - Ext_${ext_clk_MHz} MHz  |
  |                |                | STM32F446RE  | STM32F446RE |   F4   | LQFP64   |  STM32F446RE - ${clk_MHz} MHz - Ext_${ext_clk_MHz} MHz  |
  +----------------+----------------+--------------+-------------+-------------------+---------------------------------------------------------+

        +------------+--------------+----------+
        | MCU_TYPE   | Targeted MCU | Package  |
  +-----+------------+--------------+----------+
  | 4xx | STM32F4xx  | STM32F417IG  | UFBGA176 |
  |     | STM32F4xx  | STM32F415ZG  | UFBGA176 |
  |     | STM32F4xx  | STM32F407IG  | UFBGA176 |
  +-----+------------+--------------+----------+
  | 446 | STM32F446x | STM32F446ZE  | LQFP144  |
  |     | STM32F446x | STM32F446RE  | LQFP144  |
  +-----+------------+--------------+----------+


-->
<#import "../../../support/utils.ftl" as utils>
<#import "../../../support/ui.ftl" as ui>

<#function f4_ioc_seed wb_mcu_define clk_MHz ext_clk_MHz>
    <#local file_prefix = wb_mcu_define?switch(
    <#-- mcu_define       | file prefix            -->
        "STM32F4xx"       , "STM32F417IG" ,
        "STM32F417IG"     , "STM32F417IG" ,
        "STM32F415ZG"     , "STM32F415ZG" ,
        "STM32F407IG"     , "STM32F407IG" ,

         "STM32F401RE"     , "STM32F401RE" ,
         "STM32F401VE"     , "STM32F401VE" ,


        "STM32F446xC_xE"  , "STM32F446ZE" ,
        "STM32F446ZE"     , "STM32F446ZE" ,
        "STM32F446RE"     , "STM32F446RE" ,
        <#-- otherwise  --> ""            )
        >
    <#return file_prefix?has_content?
        then( "${file_prefix}/${file_prefix} - ${clk_MHz} MHz - Ext_${ext_clk_MHz} MHz.ftl"
            , "../ERROR_unsupported_device.ftl"
            )>
</#function>

<#macro include_f4_seed_file wb_mcu_define clk_MHz ext_clk_MHz>
    <#local file = f4_ioc_seed(wb_mcu_define, clk_MHz, ext_clk_MHz) >
    <@ui.comment ["mcu: ${wb_mcu_define}", "seed file: ${file}", "clk: ${clk_MHz} MHz", "ext_clk: ${ext_clk_MHz} MHz"]?join("\n") />
    <@ui.hline "x" />
    <#include file >
</#macro>
<@include_f4_seed_file cpu.PN clk_MHz ext_clk_MHz />
