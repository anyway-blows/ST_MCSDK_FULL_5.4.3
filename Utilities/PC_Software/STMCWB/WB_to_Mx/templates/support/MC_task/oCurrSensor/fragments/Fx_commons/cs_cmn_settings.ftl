<#import "../../../../utils.ftl" as utils >
<#import "../../../../ui.ftl" as ui >
<#import "../../../utils/mcu_pin_setting_mng.ftl" as cs >
<#import "../../../../fp.ftl" as fp >

<#import "../../../../../config.ftl" as config >

<#macro curr_sense_GENETATE_CONSOLIDATED_PIN_SETTING motor>

    <#if motor < WB_NUM_MOTORS >
        <#-- Accumulate and not write in the output stream -->
        <#local store_for_later_use = cs.add_motor_info(motor) >

    <#elseif motor == WB_NUM_MOTORS>
        <#-- Accumulate this other -->
        <#local store_for_later_use = cs.add_motor_info(motor) >

        <#-- Combines the accumulated definitions into a single structure grouped by Pin Name -->
        <#local new_fused_db = cs.condolidate_fuse_motors()>

       <#-- Writes to the output stream -->
        <@ui.box "CONSOLIDATED PIN SETTING for MOTOR ${ (1..motor)?join(' and ') }" "x" "x" false/>
        <@ui.line cs.genetate_pin_setting( new_fused_db ) />
    </#if>

    <#local emptyDB = cs.resetDB() >
</#macro>

<#macro curr_sense_SINCRONIZATION_TIMERs motor>
</#macro>

<#macro curr_sense_section title config>
    <#local settings     = config.settings >
    <#local gpios        = config.GPIOs >
    <#local stored_gpios_settings = fp.map(cs.storePinConfig, gpios) >
<#-- -->
    <@ui.boxed title '~' >
        <#list settings as key, value>
            <@ui.box "${key}" '' '.' />
            <@ui.line value />
            <#sep>
                <@ui.hline '.' />
            </#sep>
        </#list>
    </@ui.boxed>
</#macro>

<#--
<#macro curr_sense_TIMER config>
    <@curr_sense_section "PWM TIMER" config />
</#macro>
-->

<#macro curr_sense_OPAMPs config>
    <@curr_sense_section "OPAMP" config />
</#macro>

<#macro curr_sense_ADC config>
    <@curr_sense_section "ADC" config />
</#macro>

<#macro curr_sense_OCP config>
    <@curr_sense_section "OVER CURRENT PROTECTION" config />
</#macro>

<#macro curr_sense_TIMER config>
    <@curr_sense_section "TIMER" config />
</#macro>

<#macro curr_sense_DMA config>
    <@curr_sense_section "DMA" config />
</#macro>
