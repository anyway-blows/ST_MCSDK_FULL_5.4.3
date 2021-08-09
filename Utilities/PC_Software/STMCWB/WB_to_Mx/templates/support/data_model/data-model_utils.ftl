<#if ! __dm_utils_ftl?? >
    <#global __dm_utils_ftl = 1>
    <#include "../utils.ftl" >
<#-- this ftl generate a the WB item that contains all the original datamodel entries win the known vaues applied and any value EVALUATED
 *   the same entries are replicated with a WB_ prefix
 #
 #-->
    <#function typed val>
        <#if val?is_boolean>
            <#return {"value": val, "type": "boolean", "str": val?c} >
        <#elseif val?is_number >
            <#return {"value": val, "type": "number", "str": val?c}>

        <#-- otherwise is_string -->
        <#elseif val?matches("^(true|false)$") >
            <#return {"value": val?boolean, "type": "boolean", "str": val?boolean?c} >
        <#elseif val?matches("^[-+]?\\d*\\.?\\d+([eE][-+]?\\d+)?$")>
            <#return {"value": val?number, "type": "number", "str": val?number?c}>
        <#else>
            <#return {"value": val, "type": "string", "str": val} >
        </#if>
    </#function><#--

 --><#function _decorated value>
        <#local tmp = value?is_hash?then(value, typed(value))>
        <#if tmp.type == "string" ><#return quote(tmp.str)>
        <#else                    ><#return tmp.str>
        </#if>
    </#function><#--

 --><#macro decorated value>${_decorated(value)}</#macro><#--


 --><#function apply_known_values src_hash={} known_values={} >
        <#local str_dst_hash = "" >
        <#local sep = "" >
        <#list src_hash as key, value>
            <#-- here I decided to use a single level search on known_value and not a recursive rearch in the whole datamodel (valueOf) -->
            <#if !value?is_hash>
                <#local typed_val = typed( known_values[value]!value )  >
                <#--<#local typed_val = typed( valueOf(value, [known_values]) )  >-->
                <#local val = _decorated( typed_val ) >
                <#local str_dst_hash>${str_dst_hash?trim}${sep}"${key}": ${val}</#local>
                <#local sep = "," >
            </#if>
        </#list>
        <#local str_dst_hash>{ ${str_dst_hash} }</#local>
        <#return str_dst_hash?eval >
    </#function>
</#if>