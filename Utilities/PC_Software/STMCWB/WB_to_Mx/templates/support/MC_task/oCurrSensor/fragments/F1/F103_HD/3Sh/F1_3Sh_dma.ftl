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

    <#local single_request_for_ADC = {"dma_request": "ADC1", "channel": "DMA1_Channel1", "direction": "DMA_PERIPH_TO_MEMORY", "priority": "LOW" ,  "mem_inc" : "DISABLE"} >

    <#local single_request_for_PFC = pfc.DMA_PFC()>

    <#if WB_PFC_ENABLED ! false >
        <#return [single_request_for_ADC,single_request_for_PFC] >
    <#else>
        <#return [single_request_for_ADC] >
    </#if>

</#function>



