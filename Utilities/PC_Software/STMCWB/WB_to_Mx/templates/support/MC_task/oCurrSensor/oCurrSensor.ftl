<#include "support/includeFragmentDefinitions.ftl" >
<#include "support/utils.ftl" >
<#import "../../fp.ftl" as fp>
<#import "../../utils.ftl" as utils>
<#import "fragments/Fx_commons/DMA_Settings.ftl" as dma >
<#--<#include "../../../utils.ftl" >-->

<#--

-->
<#macro oCurrSensor >
    <@ui.boxed_loop "CURRENT SENSING" fp.map(curr_sensing_for, 1..WB_NUM_MOTORS) ; idx, macroDef >
        <@ui.comment
            [ "MOTOR:  ${macroDef.motor}"
            , "DEVICE: ${macroDef.device}"
            , "SENSE:  ${macroDef.sense}"
            , "MACRO:  ${macroDef.macroName}"
            ]?join("\n") />
        <#local macroName = macroDef.macroName >
        <#if (macroName?eval)?? && macroName?eval?is_macro >
            <@macroName?eval macroDef.motor macroDef.device macroDef.sense />
        <#else>
            <@ui.comment ["ERROR: unable to find the definition for macro \"${ macroName }\""
                         ,"       to be called with: motor=${macroDef.motor} device=${macroDef.device} sense=${macroDef.sense}"]?join("\n") />
        </#if>
    </@ui.boxed_loop>

    <@ui.boxed "Consolidated DMA Requests from CURRENT SENSING">
        <@dma.consolidate_DMA_requestes />
    </@ui.boxed>
</#macro>
<#--

-->
<#function curr_sensing_for motor >
    <#local device          = dev_family_oCurrSensor() >
    <#local sense           = utils.current_sensing_topology(motor)!"SINGLE_SHUNT" >
    <#local macroDefinition = supportedCurrSenseMacros(device, sense, motor) >
    <#return
    { "macroName": macroDefinition.macroName
    , "motor"    : motor
    , "device"   : device
    , "sense"    : sense
    }>
</#function>