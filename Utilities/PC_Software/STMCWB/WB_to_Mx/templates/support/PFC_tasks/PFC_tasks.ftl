<#import "../conditional_task.ftl" as task >
<#import "../ui.ftl"               as ui   >
<#import "../utils.ftl"          as utils  >

<#macro PFC_tasks config>
    <@task.task "PFC TIMER" config.tim!false >
        <#import "pfc.ftl" as pfc>
        <#import "PFC_ADC/pfc_adc.ftl" as pfc_adc>
        <#if WB_PFC_ENABLED ! false >
            <@ui.boxed "PFC TIMER">
                <@ui.line pfc.tim_setting()/>

                <@ui.left_comment_line "Pin Map [PWM - AC Mains - OCS]"/>
                <@ui.line pfc.pwm_pin_setting()/>
                <@ui.line pfc.ac_pin_setting() />
                <@ui.line pfc.ocs_pin_setting()/>

                <@ui.left_comment_line "Virtual Pins"/>
                <@ui.line pfc.build_VPs()/>

                <@ui.left_comment_line "IRQ"/>
                <@ui.line pfc.IRQ()/>

                <@ui.left_comment_line "ADC_PFC"/>
                <@ui.line pfc.adc_pin_setting(WB_VMPORT, WB_VMPIN, utils._last_word(WB_VMCHANNEL)) />
                <@ui.line pfc.adc_pin_setting(WB_IPORT,  WB_IPIN,  utils._last_word(WB_ICHANNEL )) />
                <@ui.line pfc_adc.adc_setting()/>
            </@ui.boxed>
        <#else>
            <@ui.boxed "PFC DISABLED"/>
        </#if>
    </@task.task>
</#macro>

