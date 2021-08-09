<#--

  +-------------+------------+-------------+--------+----------+--------------------------+
  | wb define   | short      | cpn         | Family | Packege  | ioc seed file            |
  +-------------+------------+-------------+--------+----------+--------------------------+
  | STM32F030x  | F030x      * STM32F030RC | F0     | LQFP64   | STM32F030RC - 48 MHz.ftl |
  | STM32F030x  | F030x      | STM32F030R8 | F0     | LQFP64   | STM32F030R8 - 48 MHz.ftl |
  |             |            |                                                            |
  | STM32F031x  | F031x      * STM32F031C6 | F0     | LQFP48   | STM32F031C6 - 48 MHz.ftl |
  |             |            |             |        |          |                          |
  | STM32F051x  | F051x      * STM32F051R8 | F0     | LQFP64   | STM32F051R8 - 48 MHz.ftl |
**  STM32F051x    F051x        STM32F051C8 | F0     | LQFP64   | STM32F051C8 - 48 MHz.ftl |

  |             |            |             |        |          |                          |
  | STM32F072x  | F072x      * STM32F072VB | F0     | LQFP100  | STM32F072VB - 48 MHz.ftl |
  | STM32F072x  | F072x      | STM32F072RB | F0     | LQFP64   | STM32F072RB - 48 MHz.ftl |
  |             |            |             |        |          |                          |
  | STSPIN32F0  | STSPIN32F0 | STSPIN32F0  | F0     | VFQFPN48 | STSPIN32F0  - 48 MHz.ftl |
  +-------------+------------+-------------+--------+----------+--------------------------+


        +-------------+--------------+----------+
        | MCU_TYPE    | Targeted MCU | Package  |
  +-----+-------------+--------------+----------+
  | 030 | STM32F030x  | STM32F030RC  | LQFP64   |
  |     | STM32F030x  | STM32F030R8  | LQFP64   |
  +-----+-------------+--------------+----------+
  | 031 | STM32F031x  | STM32F031C6  | LQFP48   |
  +-----+-------------+--------------+----------+
  | 051 | STM32F051x  | STM32F051R8  | LQFP64   |
  |     | STM32F051x  | STM32F051C8  | LQFP64   |
  +-----+-------------+--------------+----------+
  | 072 | STM32F072x  | STM32F072VB  | LQFP100  |
  |     | STM32F072x  | STM32F072RB  | LQFP64   |
  +-----+-------------+--------------+----------+



-->
# STM32F0.ftl ioc initialization seed file
<#import "../../../support/ui.ftl" as ui>

<#macro include_f0_seed_file wb_mcu_define>
    <@ui.comment ["mcu: ${wb_mcu_define}", "clk: ${clk_MHz} MHz"]?join("\n") />
    <@ui.hline "x" />
    <#local src =  hw.int_clk_src?then(" - int", "") >
    <#switch wb_mcu_define>
        <#case "STM32F030x" ><#include "STM32F030R8 - 48 MHz.ftl"><#break >
        <#case "STM32F030RC"><#include "STM32F030RC - 48 MHz.ftl"><#break >
        <#case "STM32F030R8"><#include "STM32F030R8 - 48 MHz.ftl"><#break >

        <#case "STM32F031x" ><#include "STM32F031C6 - 48 MHz.ftl"><#break >
        <#case "STM32F031C6"><#include "STM32F031C6 - 48 MHz.ftl"><#break >

        <#case "STM32F051x" ><#include "STM32F051R8 - 48 MHz.ftl"><#break >
        <#case "STM32F051R8"><#include "STM32F051R8 - 48 MHz.ftl"><#break >

        <#case "STM32F072x" ><#include "STM32F072VB - 48 MHz.ftl"><#break >
        <#case "STM32F072VB"><#include "STM32F072VB - 48 MHz.ftl"><#break >
        <#case "STM32F072RB"><#include "STM32F072RB - 48 MHz.ftl"><#break >

        <#case "STSPIN32F0" >
              <#if hw.int_clk_src><#include "STSPIN32F0 - 48 MHz - int.ftl" >
              <#else             ><#include "STSPIN32F0 - 48 MHz.ftl"       ></#if><#break >

        <#case "STSPIN32F0A">
              <#if hw.int_clk_src><#include "STSPIN32F0A - 48 MHz - int.ftl" >
              <#else             ><#include "STSPIN32F0A - 48 MHz.ftl"       ></#if><#break >

        <#case "STSPIN32F0251">
              <#if hw.int_clk_src><#include "STSPIN32F031 - 48 MHz - int.ftl" >
              <#else             ><#include "STSPIN32F031 - 48 MHz.ftl"       ></#if><#break >

        <#case "STSPIN32F0252">
              <#if hw.int_clk_src><#include "STSPIN32F031 - 48 MHz - int.ftl" >
              <#else             ><#include "STSPIN32F031 - 48 MHz.ftl"       ></#if><#break >

        <#case "STSPIN32F0601">
              <#if hw.int_clk_src><#include "STSPIN32F031 - 48 MHz - int.ftl" >
              <#else             ><#include "STSPIN32F031 - 48 MHz.ftl"       ></#if><#break >

        <#case "STSPIN32F0602">
              <#if hw.int_clk_src><#include "STSPIN32F031 - 48 MHz - int.ftl" >
              <#else             ><#include "STSPIN32F031 - 48 MHz.ftl"       ></#if><#break >

        <#default           ><#include "../ERROR_unsupported_device.ftl"  >
    </#switch>
</#macro>
<@include_f0_seed_file cpu.PN/>

