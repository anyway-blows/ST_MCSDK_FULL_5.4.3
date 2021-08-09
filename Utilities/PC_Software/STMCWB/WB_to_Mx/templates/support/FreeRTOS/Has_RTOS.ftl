<#function has_rtos >
    <#if (WB_RTOS?has_content) >
        <#return (WB_RTOS == "FREERTOS")?then(true,false)>
    </#if>
    <#return false>
</#function>