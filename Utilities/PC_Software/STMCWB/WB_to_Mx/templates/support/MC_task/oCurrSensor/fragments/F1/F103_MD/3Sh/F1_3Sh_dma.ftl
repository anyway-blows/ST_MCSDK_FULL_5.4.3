<#import "../../../../../../utils.ftl" as utils>
<#import "../../../../../../PFC_tasks/pfc.ftl" as pfc>


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

    <#--<#local pwm_timer =  utils._last_word( utils.v("PWM_TIMER_SELECTION", motor) ) >-->

    <#--<#local requests_for_pwm_timer = pwm_timer?switch
        ("TIM1", {"dma_request": "TIM1_UP" , "channel": "DMA1_Channel5",  "priority": "LOW" }
    )>-->

    <#local request_for_ADC = [
                                 {"dma_request": "TIM1_UP",  "channel": "DMA1_Channel5",  "allignment": "WORD",                "priority": "LOW" ,  "mem_inc" : "DISABLE"}
                                ,{"dma_request": "ADC1",     "channel": "DMA1_Channel1",  "direction": "DMA_PERIPH_TO_MEMORY", "priority": "LOW" ,  "mem_inc" : "DISABLE"}
                              ]>

        <#return request_for_ADC >


</#function>



