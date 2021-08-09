<#import "../../../../../ui.ftl" as ui >
<#import "../../../../../utils.ftl" as utils>
<#import "../../../../utils/ips_mng.ftl" as ns_ip>
<#import "../../Fx_commons/cs_cmn_settings.ftl" as cmn_sets >

<#macro G0_R1_1_all_settings motor device sense>
    <@curr_sense_OCP                                        motor />
    <@curr_sense_ADC                                        motor />
    <@curr_sense_DMA                                              />
    <@curr_sense_TIMER                                      motor />

    <@cmn_sets.curr_sense_GENETATE_CONSOLIDATED_PIN_SETTING motor />
    <@cmn_sets.curr_sense_SINCRONIZATION_TIMERs             motor />
</#macro>

<#macro curr_sense_OCP motor>
    <#import "../../G0/com/G0_ocp.ftl" as ns_ocp >
    <#local config = ns_ocp.cs_over_current_prot(motor, [""] ) >
    <@cmn_sets.curr_sense_OCP config />
</#macro>

<#macro curr_sense_TIMER motor>
    <#import "../com/G0_pwm_timer.ftl" as cmns_tmr>
    <#import "G0_R1_1_pwm_timer.ftl" as tmr >
    <#local config = cmns_tmr.cs_TIMER_settings(motor, tmr.cs_PWM_TIMER_patameters) >
    <@cmn_sets.curr_sense_TIMER config />
</#macro>

<#macro curr_sense_ADC motor>
    <#import "G0_R1_1_adc.ftl" as ns_adc >

    <#local adc_name = ns_ip.collectIP( utils.v("ADC_1_PERIPH", motor) )>
    <#local config = ns_adc.cs_ADC_settings(motor, adc_name) >
    <@cmn_sets.curr_sense_ADC config />
</#macro>

<#macro curr_sense_DMA>
    <#import "../../Fx_commons/DMA_Settings.ftl" as dma>


    <#local requests =
        [ {"dma_request": "ADC1",      "channel": "DMA1_Channel1", "direction": "DMA_PERIPH_TO_MEMORY", "priority": "VERY_HIGH", "irq_priority" : "1"}
        , {"dma_request": "TIM1_CH4" , "channel": "DMA1_Channel4" }
        , {"dma_request": "TIM1_UP",   "channel": "DMA1_Channel5",  "irq_name":"DMA1_Ch4_7_DMAMUX1_OVR", "allignment": "WORD", "mode" : "NORMAL", "mem_inc" :"DISABLE" }
        ]  >

    <@ui.boxed "DMA" '~' >
        <@dma.DMA_settings requests />
    </@ui.boxed>
</#macro>

