<#import "../../../../../../utils.ftl" as utils>
<#--<#import "F1_3Sh_aux_pwm_timer.ftl" as aux_timer >-->

<#function get_settings motor>
    <#import "../../../Fx_commons/DMA_Settings.ftl" as dma>
    <#local collected_reqs = dma.collectDMA_requests( cs_DMA_requests(motor) ) >
    <#local sectionTitle = "DMA settings" >
    <#return
    { "settings" : { sectionTitle : ui._comment("DMA settings for motor M${motor} was postponed, see below") }
    , "GPIOs" : []
    }>
</#function>

<#function cs_DMA_requests motor>
<#--
    <#local pwm_timer      =  utils._last_word( utils.v("PWM_TIMER_SELECTION", motor) ) >
    <#local aux_timer_name = aux_timer.cs_F1_aux_timer_name(motor) >

    <#local requests_for_pwm_timer = pwm_timer?switch
        ("TIM1", {"dma_request": "TIM1_CH4/TRIG/COM" , "channel": "DMA1_Channel4"                        }
               , {"dma_request": "TIM8_CH4/TRIG/COM" , "channel": "DMA2_Channel2"                        }
        )>
&lt;#&ndash;
    with the ADC3 the auxiliary Timer is TIM5
    with the ADC1 the auxiliary Timer is TIM4
&ndash;&gt;
    <#local requests_for_aux_timer_xADC = aux_timer_name?switch
        ("TIM5", {"dma_request": "TIM5_CH4/TRIG"     , "channel": "DMA2_Channel1"} &lt;#&ndash;, "allignment": "WORD" }&ndash;&gt;
               , {"dma_request": "TIM4_CH2"          , "channel": "DMA1_Channel3"} &lt;#&ndash;, "allignment": "WORD" }&ndash;&gt;
        )>
-->
    <#local single_request_for_ADC = {"dma_request": "ADC1", "channel": "DMA1_Channel1", "direction": "DMA_PERIPH_TO_MEMORY", "priority": "LOW" ,  "mem_inc" : "DISABLE"} >

    )>


    <#--<#return [requests_for_pwm_timer, requests_for_aux_timer_xADC,single_request_for_ADC] >-->
    <#return [single_request_for_ADC] >
</#function>



