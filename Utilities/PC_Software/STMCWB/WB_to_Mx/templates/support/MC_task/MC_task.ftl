<#import "../conditional_task.ftl" as task >
<#macro MC_tasks config>
    <#--################################################################################################################
     #  PARTIAL: F3 Family is complete apart ICS                                                                       #
     #           R3_2_F3 coniguration have to be validated on real board                                               #
     ################################################################################################################-->
    <@task.task "CURRENT SENSING" config.currentSense!false >
        <#include "oCurrSensor/oCurrSensor.ftl">
        <@oCurrSensor />
    </@task.task>

    <#--################################################################################################################
     #  COMPLETE: HALL is complete                                                                                     #
     #            ENCODER is complete                                                                                  #
     ################################################################################################################-->
    <@task.task "SPEED SENSING" config.speedSense!false >
        <#include "oSpeedSensor/oSpeedSensor.ftl">
        <@oSpeedSensor />
    </@task.task>

    <#--################################################################################################################
     #  COMPLETE: Temperature and VBUS Sensing                                                                         #
     ################################################################################################################-->
    <@task.task "BUS and TEMPERATURE SENSING" config.tempAndBusSense!false >
        <#include "oTemp_and_Bus_Sense/oTemp_and_Bus_Sense.ftl" >
        <@oTemp_and_Bus_Sense />
    </@task.task>

    <#--################################################################################################################
     #  NONE: GATE DRIVING                                                                                             #
     ################################################################################################################-->
    <@task.task "GATE DRIVING" config.gateDriver!false >
        <#include "oGateDriver/oGateDriver.ftl" >
        <@oGateDriver />
    </@task.task>


    <#-- Consolidate the ADCs settings for the ones used in Current, Temperature and VBus sensing -->
    <#import "../shared_ip/ip_overlap.ftl" as ip_ov>
    <#import "oCurrSensor/extra_settings.ftl" as adc_extra >
    <#local dummy = adc_extra.manage_extras(ip_ov) >
<#--
    <@ui.comment "Consolidated IPs" />
    <@ip_ov.consolidated_IPs_settings />
-->

    <#--################################################################################################################
     #  COMPLETE: Digital Output                                                                                       #
     ################################################################################################################-->
    <@task.task "DIGITAL I/O" config.digitalIO!false >
        <#import "digital_output/utils.ftl"                       as io  >
        <#import "digital_output/oOCPDisabling/oOCPDisabling.ftl" as ocp >
        <#import "digital_output/oR_Brake/oR_Brake.ftl"           as dbo >
        <#import "digital_output/oICL/oICL.ftl"                   as icl >

        <@ui.box "DIGITAL OUTPUTs" "#" '#' />
        <@ui.hline ' '/>
        <#list
        [ { "title": "OVER CURRENT PROTECTION", "io_description": ocp.io_description}
        , { "title": "DISSIPATIVE BRAKE"      , "io_description": dbo.io_description}
        , { "title": "INRUSH CURRRENT LIMIT"  , "io_description": icl.io_description}
        ] as io_section>
            <@io.block io_section.title fp.map(io_section.io_description, 1..WB_NUM_MOTORS) '=' '~'/>
            <#sep>
                <@ui.hline ' '/>
            </#sep>
        </#list>
    </@task.task>
</#macro>

