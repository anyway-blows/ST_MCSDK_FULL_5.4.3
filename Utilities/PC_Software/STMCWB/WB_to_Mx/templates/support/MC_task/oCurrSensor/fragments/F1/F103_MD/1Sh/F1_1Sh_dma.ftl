<#import "../../../../../../utils.ftl" as utils>



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

    <#local MD_mcu = (utils._last_word(WB_MCU_TYPE)?upper_case !"") >
    <#local requests_for_pwm_timer = (MD_mcu == "LD")?then
                                ({"dma_request":"TIM3_CH4/UP" , "channel": "DMA1_Channel3"}
                                ,{"dma_request": "TIM1_UP"    , "channel": "DMA1_Channel5"}  )>



    <#local requests_for_pwm_timer =[    requests_for_pwm_timer
                                      , {"dma_request": "TIM1_CH4/TRIG/COM" , "channel": "DMA1_Channel4"}
                                      , {"dma_request": "ADC1"              , "channel": "DMA1_Channel1", "direction": "DMA_PERIPH_TO_MEMORY", "priority": "LOW" ,  "mem_inc" : "DISABLE"}]>


     <#return requests_for_pwm_timer >


</#function>



