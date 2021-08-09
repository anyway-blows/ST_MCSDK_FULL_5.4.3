<#import "../../Fx_commons/cs_cmn_settings.ftl" as cmn_sets >

<#macro F4_2Ms_all_settings_combining_3Sh_and_ICS motor senses>
    <@curr_sense_OCP   motor />
    <@curr_sense_TIMER motor senses[motor-1]/>
    <@curr_sense_ADC   motor senses />

    <@cmn_sets.curr_sense_GENETATE_CONSOLIDATED_PIN_SETTING motor />
</#macro>

<#macro curr_sense_OCP motor>
    <#import "../../F4/com/F4_ocp.ftl" as ocp >
    <#local config = ocp.get_settings(motor) >
    <@cmn_sets.curr_sense_OCP config />
</#macro>

<#macro curr_sense_TIMER motor str_sense>
    <#switch str_sense >
        <#case "1Sh">
            <#import "../1Sh/F4_1Sh_pwm_timer.ftl" as tmr >
            <#break>
        <#case "3Sh_IR">
            <#import "../3Sh_IR/F4_3Sh_IR_pwm_timer.ftl" as tmr >
            <#break>
        <#case "ICS">
            <#import "../ICS/F4_ICS_pwm_timer.ftl" as tmr >
            <#break>
    </#switch>
    <#local config = tmr.get_settings(motor) >
    <@cmn_sets.curr_sense_TIMER config />
</#macro>

<#macro curr_sense_ADC motor senses>
    <#import "../dual_drive/F4_2Ms_adc_settings.ftl" as adc >
    <#local config = adc.cs_ADC_settings(motor, senses) >
    <@cmn_sets.curr_sense_ADC config />
</#macro>

