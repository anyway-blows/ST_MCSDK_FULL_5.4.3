<#if ! _Definition_ftl?? >
    <#global _Definition_ftl = 1>
    <#include "data_model/known_values.ftl">
    <#include "data_model/data-model_utils.ftl"><#--


 --><#macro expose_known_values_to_data_model values>
        <#list values as key, value>
            <@'<#global ${key} = ${_decorated(value)} >'?interpret />
        </#list>
    </#macro>
    <@expose_known_values_to_data_model _known_values /><#--


 --><#-- Number of Motors -->
    <#switch DRIVES_NUMBER_SELECTION!"SINGLEDRIVE">
        <#case "DUALDRIVE"  >
            <#global
                WB_NUM_MOTORS = 2
                WB_DRIVES_NUMBER_SELECTION = 2
                WB_SINGLEDRIVE=false
                WB_DUALDRIVE=true
                WB_DRIVE="DUAL" >
            <#break ><#--


     --><#default ><#--<#case "SINGLEDRIVE">-->
            <#global
                WB_NUM_MOTORS = 1
                WB_DRIVES_NUMBER_SELECTION = 1
                WB_SINGLEDRIVE=true
                WB_DUALDRIVE=false
                WB_DRIVE="SINGLE" >
    </#switch>
</#if>