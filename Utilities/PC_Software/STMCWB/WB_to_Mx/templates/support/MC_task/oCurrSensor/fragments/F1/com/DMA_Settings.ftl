<#import "../../../../../ui.ftl" as ui >
<#import "../../../../utils/ips_mng.ftl" as ns_ip >
<#macro DMA_settings requestes>
    <#local dma = ns_ip.collectIP( "DMA" )?lower_case?cap_first >
    <@ui.box "DMA settings" '' '.' />
<#--

-->
    <#list requestes>
        <@ui.line "${dma}.RequestsNb=${ requestes?size }" />

        <#items as x>
            <#local idx = x?index >
            <#local
                mem_inc      = (x.mem_inc   )!"ENABLE"
                allignment   = (x.allignment)!"HALFWORD"
                mode         = (x.mode      )!"CIRCULAR"
                direction    = (x.direction )!"DMA_MEMORY_TO_PERIPH"
                priority     = (x.priority  )!"HIGH"
                irq_name     = (x.irq_name  )!x.channel
                irq_priority = (x.irq_priority)!0
            >
            <@ui.line "${dma}.Request${           idx }=${x.dma_request}"                            />
            <@ui.line "${dma}.${x.dma_request}.${ idx }.Instance=${ x.channel }"                     />

            <@ui.line "${dma}.${x.dma_request}.${ idx }.MemInc=DMA_MINC_${                    mem_inc    }" />
            <@ui.line "${dma}.${x.dma_request}.${ idx }.PeriphDataAlignment=DMA_PDATAALIGN_${ allignment }" />
            <@ui.line "${dma}.${x.dma_request}.${ idx }.MemDataAlignment=DMA_MDATAALIGN_${    allignment }" />
            <@ui.line "${dma}.${x.dma_request}.${ idx }.Mode=DMA_${                           mode       }" />

            <@ui.line "${dma}.${x.dma_request}.${ idx }.Direction=${                          direction  }" />
            <@ui.line "${dma}.${x.dma_request}.${ idx }.PeriphInc=DMA_PINC_DISABLE" />
            <@ui.line "${dma}.${x.dma_request}.${ idx }.Priority=DMA_PRIORITY_${              priority   }" />
            <@ui.line "${dma}.${x.dma_request}.${ idx }.RequestParameters=Instance,Direction,PeriphInc,MemInc,PeriphDataAlignment,MemDataAlignment,Mode,Priority" />

            <@ui.comment "${irq_name} IRQ" />
            <@ui.line ns_ip.ip_irq(irq_name, [true, irq_priority, 0, true, false, false, true])  />
            <#sep >

            </#sep>
        </#items>
    <#else>
        <@ui.box "NO requests" '' '' />
    </#list>
</#macro>



<#function collectDMA_requests requests>
    <#global _DMA_reqs_DB = DMA_reqs_DB() + requests>
    <#return requests >
</#function>

<#function DMA_reqs_DB>
    <#return _DMA_reqs_DB![] >
</#function>

<#macro consolidate_DMA_requestes >
    <@dma.DMA_settings DMA_reqs_DB() />
</#macro>
