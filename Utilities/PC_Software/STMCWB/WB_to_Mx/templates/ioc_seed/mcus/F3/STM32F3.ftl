<#--

  +-------------+-------------------------------+---------+-------------+--------+-------------------------------------------+
  | wb define   | wb_combo_label                | Packege | MX Part No  | Family | ioc seed file                             |
  +-------------+-------------------------------+---------+-------------+--------+-------------------------------------------+
  | STM32F302xB | STM32F302xB                   | LQFP100 | STM32F302VB |   F3   | STM32F302VB/STM32F302VB - ${clk_MHz} MHz  |
  | STM32F302xC | STM32F302xC                   | LQFP100 | STM32F302VC |   F3   | STM32F302VC/STM32F302VC - ${clk_MHz} MHz  |
  | STM32F302X8 | STM32F301x6/8 - STM32F302x6/8 | LQFP64  | STM32F302R8 |   F3   | STM32F302R8/STM32F302R8 - ${clk_MHz} MHz  |
  |                                                                                                                          |
  | STM32F303xB | STM32F303xB                   | LQFP100 | STM32F303VB |   F3   | STM32F303VB/STM32F303VB - ${clk_MHz} MHz  |
  | STM32F303xC | STM32F303xC                   | LQFP100 | STM32F303VC |   F3   | STM32F303VC/STM32F303VC - ${clk_MHz} MHz  |
  | STM32F303xE | STM32F303xE                   | LQFP144 | STM32F303ZE |   F3   | STM32F303ZE/STM32F303ZE - ${clk_MHz} MHz  |
  +-------------+-------------------------------+---------+-------------+--------+-------------------------------------------+

  +-----+-------------+--------------+----------+
  |     | MCU_TYPE    | Targeted MCU | Package  |
  +-----+-------------+--------------+----------+
  |     | STM32F302xB | STM32F302VB  | LQFP100  |
  | 302 | STM32F302xC | STM32F302VC  | LQFP100  |
  |     | STM32F302X8 | STM32F302R8  | LQFP64   |
  +-----+-------------+--------------+----------+
  |     | STM32F303xB | STM32F303VB  | LQFP100  |
  |     | STM32F303xB | STM32F303RB  | LQFP64   |
  |     | STM32F303xB | STM32F303CC  | LQFP48   |
  |     | STM32F303xC | STM32F303VC  | LQFP100  |
  | 303 | STM32F303xE | STM32F303ZE  | LQFP144  |
  |     | STM32F303xE | STM32F303VE  | LQFP100  |
  |     | STM32F303xE | STM32F303RE  | LQFP64   |
  +-----+-------------+--------------+----------+

-->
<#import "../../../support/utils.ftl" as utils>
<#import "../../../support/ui.ftl" as ui>

<#function f3_ioc_seed wb_mcu_define hw>
    <#local file_prefix = wb_mcu_define?switch(
    <#-- wb define        | file prefix   -->
        "STM32F302xB"     , "STM32F302VB" ,
        "STM32F302VB"     , "STM32F302VB" ,

        "STM32F302xC"     , "STM32F302VC" ,
        "STM32F302VC"     , "STM32F302VC" ,

        "STM32F302X8"     , "STM32F302R8" ,
        "STM32F302R8"     , "STM32F302R8" ,

        "STM32F303xB"     , "STM32F303VB" ,
        "STM32F303CB"     , "STM32F303CB" ,
        "STM32F303RB"     , "STM32F303RB" ,
        "STM32F303VB"     , "STM32F303VB" ,
        "STM32F303CC"     , "STM32F303CC" ,

        "STM32F303xC"     , "STM32F303VC" ,
        "STM32F303VC"     , "STM32F303VC" ,

        "STM32F303xE"     , "STM32F303ZE" ,
        "STM32F303RE"     , "STM32F303RE" ,
        "STM32F303VE"     , "STM32F303VE" ,
        "STM32F303ZE"     , "STM32F303ZE" ,
        <#-- otherwise -->  ""            )
        >
    <#local src =  hw.int_clk_src?then(" - int", "") >

    <#return file_prefix?has_content?
        then( "${file_prefix}/${file_prefix} - ${hw.clk_MHz} MHz${ src }.ftl"
            , "../ERROR_unsupported_device.ftl"
            )>
</#function>

<#macro include_f3_seed_file wb_mcu_define hw>
    <#local file = f3_ioc_seed(wb_mcu_define, hw) >
    <@ui.comment
        [ "mcu: ${wb_mcu_define}"
        , "seed file: ${file}"
        , "clk: ${clk_MHz} MHz"
        ]?join("\n") />
    <@ui.hline "x" />

    <#global DAC1 = "DAC" >
    <#include file >


    <#include "../../mcus/cmns/FreeRTOS_IsAvaliable.ftl">

    <#if  !hw.int_clk_src >
        <#include "../cmns/OSC_IN-OSC_OUT.ftl" >
    </#if>

</#macro>
<@include_f3_seed_file cpu.PN hw/>

