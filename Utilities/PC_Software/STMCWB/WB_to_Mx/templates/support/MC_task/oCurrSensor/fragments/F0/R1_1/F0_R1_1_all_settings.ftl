<#import "../../../../../ui.ftl" as ui >
<#import "../../../../../utils.ftl" as utils>
<#import "../../../../utils/ips_mng.ftl" as ns_ip>
<#import "../../Fx_commons/cs_cmn_settings.ftl" as cmn_sets >

<#macro F0_R1_1_all_settings motor device sense>
    <@curr_sense_OCP                                        motor />
    <@curr_sense_ADC                                        motor />
    <@curr_sense_DMA                                              />
    <@curr_sense_TIMER                                      motor />

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
    <#import "F0_R1_1_pwm_timer.ftl" as tmr >
    <#local config = cmns_tmr.cs_TIMER_settings(motor, tmr.cs_PWM_TIMER_patameters) >
    <@cmn_sets.curr_sense_TIMER config />
</#macro>

<#macro curr_sense_ADC motor>
    <#import "F0_R1_1_adc.ftl" as ns_adc >
    <#local adc_name = ns_ip.collectIP("ADC") >
    <#local config = ns_adc.cs_ADC_settings(motor, adc_name) >
    <@cmn_sets.curr_sense_ADC config />
</#macro>

<#macro curr_sense_DMA>
    <#import "../../Fx_commons/DMA_Settings.ftl" as dma>

    <#local DMA_ADC_channel_irq = "DMA1_Channel2_3" >

    <#local DMA_TIM1_channel_irq = hw.cpu.name?switch
        ( "STM32F072x", "DMA1_Channel4_5_6_7"
                      , "DMA1_Channel4_5" )>

    <#local tim_15 = {"dma_request": "TIM15_CH1/UP/TRIG/COM", "channel": "DMA1_Channel5" , "direction" : "DMA_MEMORY_TO_PERIPH", "priority": "HIGH" } >
    <#local tim_3  = {"dma_request": "TIM3_CH4/UP"          , "channel": "DMA1_Channel3"  , "direction" : "DMA_MEMORY_TO_PERIPH", "priority": "HIGH" }>
    <#local aux_timer_dma_request = hw.cpu.name?switch
        ( "STM32F051x", tim_15
        , "STM32F072x", tim_15
                      , tim_3
        )>
    <#local requests =
        [ {"dma_request": "ADC"               , "channel": "DMA1_Channel2", "direction" : "DMA_PERIPH_TO_MEMORY", "priority": "LOW"  , "irq_priority": "1"
          , "irq_name": DMA_ADC_channel_irq}
        , {"dma_request": "TIM1_CH4/TRIG/COM" , "channel": "DMA1_Channel4", "direction" : "DMA_MEMORY_TO_PERIPH", "priority": "HIGH"
          , "irq_name": DMA_TIM1_channel_irq }
        ] + [aux_timer_dma_request] >

    <@ui.boxed "DMA" '~' >
        <@dma.DMA_settings requests />
    </@ui.boxed>
</#macro>
