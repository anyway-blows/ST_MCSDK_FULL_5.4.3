#
# ERROR: Board "${ board.name }" is not supported
#
<#import "../../support/ui.ftl" as ui >
<#macro recovery_ioc_init fragment>
    <@ui.box "I will recover using standard ${fragment.title}" "x" "x" false/>
    <#include "../${fragment.file}" >
</#macro>
<#import "../ioc_init.ftl" as ioc_init >
<#import "../hw_info.ftl" as hw >
<@recovery_ioc_init ioc_init.mcu_ioc_seed( hw.hw_info ) />
