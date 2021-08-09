<#import "../../../../../ui.ftl" as ui >
<#import "../../../../../utils.ftl" as utils>
<#import "../../../../utils/ips_mng.ftl" as ns_ip>
<#import "../../Fx_commons/cs_cmn_settings.ftl" as cmn_sets >

<#macro F0_R3_1_all_settings motor device sense>
    <@curr_sense_OCP                                        motor />
    <@curr_sense_TIMER                                      motor />
    <@curr_sense_ADC                                        motor />
    <@curr_sense_DMA                                              />

    <@cmn_sets.curr_sense_GENETATE_CONSOLIDATED_PIN_SETTING motor />
    <@cmn_sets.curr_sense_SINCRONIZATION_TIMERs             motor />
</#macro>

<#macro curr_sense_OCP motor>
    <#import "../../F0/com/F0_ocp.ftl" as ns_ocp >
    <#local config = ns_ocp.cs_over_current_prot(motor, [""] ) >
    <@cmn_sets.curr_sense_OCP config />
</#macro>

<#macro curr_sense_TIMER motor>
    <#import "../com/F0_pwm_timer.ftl" as cmns_tmr>
    <#import "F0_R3_1_pwm_timer.ftl" as tmr >
    <#local config = cmns_tmr.cs_TIMER_settings(motor, tmr.cs_PWM_TIMER_patameters, false) >
    <@cmn_sets.curr_sense_TIMER config />
</#macro>


<#macro curr_sense_ADC motor>
    <#import "F0_R3_1_adc.ftl" as ns_adc >
    <#local adc_name = ns_ip.collectIP("ADC") >
    <#local config = ns_adc.cs_ADC_settings(motor, adc_name) >
    <@cmn_sets.curr_sense_ADC config />
</#macro>

<#macro curr_sense_DMA>
    <#import "../../Fx_commons/DMA_Settings.ftl" as dma>
    <#local single_request_for_ADC = {"dma_request": "ADC", "channel": "DMA1_Channel1", "direction": "DMA_PERIPH_TO_MEMORY", "priority": "HIGH", "irq_priority" : "1"} >
    <@ui.boxed "DMA" '~' >
        <@dma.DMA_settings [single_request_for_ADC] />
    </@ui.boxed>
</#macro>
