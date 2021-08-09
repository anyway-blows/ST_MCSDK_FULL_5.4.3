<#include "known_values.ftl" >
<#include "data-model_utils.ftl" >
<#macro expose_data_model_to_freemarker_applying_known_values_and_type_info >
    <#global WB = apply_known_values(.data_model, _known_values) >
    <#list WB as key, value>
        <#local val = _decorated( value ) >
        <@'<#global WB_${key}=${val} >'?interpret />
        <@'<#global    ${key}=${val} >'?interpret />
    </#list>
</#macro>
<@expose_data_model_to_freemarker_applying_known_values_and_type_info />