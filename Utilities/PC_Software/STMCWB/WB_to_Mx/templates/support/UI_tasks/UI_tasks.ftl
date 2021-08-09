<#import "../conditional_task.ftl" as task >
<#import "../ui.ftl"               as ui   >
<#macro UI_tasks config>
<#--################################################################################################################
 #  DAC                                                                                                            #
 ################################################################################################################-->
    <@task.task "DAC" config.dac!false >
        <#import "ui_dac.ftl" as dac>
        <@dac.ui_dac "DAC"/>
    </@task.task>

<#--################################################################################################################
 #  SERIAL COMMUNICATION                                                                                           #
 ################################################################################################################-->
    <@task.task "SERIAL COMMUNICATION" config.serial!false >
        <#import "ui_serial.ftl" as serial>
        <@ui.boxed "SERIAL COMMUNICATION">
            <@ui.line serial.serial_settings()?join('\n') />
        </@ui.boxed>
    </@task.task>

<#--################################################################################################################
 #  LCD                                                                                                            #
 ################################################################################################################-->
    <@task.task "LCD" config.lcd!false >
        <#include "ui_lcd.ftl" >
        <#--<@oTemp_and_Bus_Sense />-->
    </@task.task>


<#--################################################################################################################
 #  START/STOP PUSH BUTTON                                                                                         #
 ################################################################################################################-->
    <@task.task "START/STOP PUSH BUTTON" config.start_stop_btn!false >
        <#import "ui_start_stop_btn.ftl" as btn>
        <@ui.boxed "START/STOP PUSH BUTTON">
            <@ui.line btn.start_stop_btn_settings() />
        </@ui.boxed>
    </@task.task>


</#macro>