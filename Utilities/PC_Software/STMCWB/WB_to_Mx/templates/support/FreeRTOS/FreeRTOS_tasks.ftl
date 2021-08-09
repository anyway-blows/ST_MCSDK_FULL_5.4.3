<#import "../conditional_task.ftl"  as task >
<#import "../ui.ftl"                as ui   >
<#import "../utils.ftl"             as utils  >
<#import "../FreeRTOS/settings.ftl" as FreeRTOS  >

<#--<#macro FreeRTOS_tasks config>-->
<#macro FreeRTOS_tasks >
    <#--<@task.task "PFC TIMER" config.tim!false >-->
    <#import "../../support/FreeRTOS/Has_RTOS.ftl" as rtos >
        <#if rtos.has_rtos()>
           <@ui.boxed "FreeRTOS_tasks">
               <@ui.line FreeRTOS.set_ip(WB_RTOS)/>
               <@ui.line FreeRTOS.build_VPs(WB_RTOS)/>
               <@ui.line FreeRTOS.build_VPs2(WB_RTOS_TIMER)/>
               <@ui.line FreeRTOS.IRQ(WB_RTOS_TIMER)/>
               <@ui.line FreeRTOS.NVIC_TB(WB_RTOS_TIMER)/>
               <@ui.boxed "FreeRTOS Tasks & Queues"/>
               <@ui.line FreeRTOS.tasks_and_queues()/>

            </@ui.boxed>
        <#else>


            <@ui.boxed "FreeRTOS_tasks DISABLED"/>



        </#if>
    <#--</@task.task>-->
</#macro>

