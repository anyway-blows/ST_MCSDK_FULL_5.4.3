<#import "../../../../support/FreeRTOS/Has_RTOS.ftl" as rtos >
<#if rtos.has_rtos()>
    <#include "FreeRTOS_NVIC_seed.ftl" >
    <#include "../../../mcus/cmns/FreeRTOS_basic_ips_and_pins_int.ftl" >
<#else>
    <#include "NVIC_seed.ftl" >
    <#include "../../../mcus/cmns/basic_ips_and_pins_int.ftl" >
</#if>
