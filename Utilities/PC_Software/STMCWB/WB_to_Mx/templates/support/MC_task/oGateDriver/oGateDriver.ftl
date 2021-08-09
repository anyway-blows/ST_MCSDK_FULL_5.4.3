<#include "fragments/GAP_F1_GateDriverCtrl.ftl" >
<#include "fragments/GAP_F3_GateDriverCtrl.ftl" >
<#include "fragments/GAP_F4_GateDriverCtrl.ftl" >
<#import "../../ui.ftl" as ui >
<#macro oGateDriver>
    <@ui.boxed "GATE DRIVER">
        <#if USE_STGAP1S! false >
            <#switch cpu.family>
                <#case "F1"><@GAP_F1_GateDriverCtrl motor/><#break >
                <#case "F3"><@GAP_F3_GateDriverCtrl 1/><#break >
                <#case "F4"><@GAP_F4_GateDriverCtrl motor/><#break >
            </#switch>
        <#else>
            <@ui.box "NO GATE DRIVER REQUIRED" '' ''/>
        </#if>
    </@ui.boxed>
</#macro>
