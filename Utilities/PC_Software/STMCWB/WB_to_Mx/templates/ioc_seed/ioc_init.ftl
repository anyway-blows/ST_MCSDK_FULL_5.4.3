<#import "../support/utils.ftl" as utils>
<#import "../support/ui.ftl" as ui>
<#import "extras/project_settings.ftl" as prj_mng>

<#function brd_ioc_seed hw>
    <#import "supported_boards.ftl" as supported>

    <#local file_name = supported.boards?seq_contains(hw.board.name)?then( "${hw.cpu.family}/${hw.board.name}", "ERROR_unsupported_board" ) >
    <#return
        { "title" : "Initialization Fragment for board: \"${hw.board.name}\" - (${hw.board.mcu} @ ${hw.clk_MHz} MHz - ${ hw.ext_clk_src?then('ext.', 'int.') } Clk: ${hw.ext_clk_MHz} MHz)"
        , "file"  : "./boards/${file_name}.ftl"
        } >
</#function>

<#function mcu_ioc_seed hw>
    <#return
        { "title" : "Initialization Fragment for STM32${ hw.cpu.family } @ ${hw.clk_MHz} MHz - ${ hw.ext_clk_src?then('ext.', 'int.') } Clk: ${hw.ext_clk_MHz} MHz"
        , "file"  : "./mcus/${hw.cpu.family}/STM32${hw.cpu.family}.ftl"
        } >
</#function>

<#macro init_ioc hw>
    <@ui.boxed "WB_to_Mx versions" '~'>
        <#include "extras/wb_to_mx_ver.ftl">
    </@ui.boxed>

    <@ui.boxed "CubeMX versions" '~'>
        <#include "extras/cubemx_version.ftl">
    </@ui.boxed>

    <@ui.boxed "Common stuffs" '~'>
        <@ui.line [ "KeepUserPlacement=false"
                  , "PinOutPanel.RotationAngle=0"] />
    </@ui.boxed>

    <@ui.boxed "Project settings" '~'>
        <@prj_mng._project_settings />
    </@ui.boxed>

    <#assign clk_MHz     = hw.clk_MHz
             ext_clk_MHz = hw.ext_clk_MHz
             ext_clk_src = hw.ext_clk_src
             int_clk_src = hw.int_clk_src
             hw = hw
             >
    <#local seed = hw.board.isCustom?then(mcu_ioc_seed,brd_ioc_seed)(hw) >
    <#import "ioc_collect_pins_and_ips.ftl" as Mcu>
    <@ui.boxed    seed.title >
        <#-- the included file will see the Mcu namespace and can invoke Mcu.IPs and/or Mcu.PINs functions to collect
             IPs and PINs that have to be added in the generate ioc like:
                Mcu.IP0=NVIC
                Mcu.IP1=RCC
                Mcu.IP2=SYS
                ...

                Mcu.Pin0=PF0-OSC_IN
                Mcu.Pin1=VP_SYS_VS_Systick
                ...
         -->
        <#include seed.file>

        <#-- WARNING: the above line has to left empty -->
    </@ui.boxed>
</#macro>