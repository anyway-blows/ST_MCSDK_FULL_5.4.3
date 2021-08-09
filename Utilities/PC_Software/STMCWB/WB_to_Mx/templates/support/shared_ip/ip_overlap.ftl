<#function update_IP_parameters ip_parameters>
<#-- ip_parameters must have the following structure:
    { "title"          : title
    , "ip"             : the used IP, like DAC1
    , "parameters"     : parameters
    , "str_parameters" : string representation of the parameters
    , "IPParameters"   : keys of parameters without IPParameters and meta Items (comments | text | blank)
    }

    It can pe produced with the function IP_settings(title, ip, parameters)


-->

<#--####################################################################################################################
 #-- HERE THE SIDE EFFECT
 #-- to update a global variable that hold the used parameters organized by contributors (current sense, temp sense...)
 #-- at the end of mc_tast I have to write all the parameters of any used IP
 #-->
    <#global IPs_DB = updateIPs_DB(ips_db(), ip_parameters) >
<#--#################################################################################################################-->

    <#return ip_parameters >
</#function>

<#function ips_db>
    <#return IPs_DB!{}>
</#function>



<#-- COMMON PARAMETERS -->
<#function add_ip_cmns_mng mng>
    <#global ip_cmns_mngs = [mng] + ip_cmns_mngs![] >
    <#return ip_cmns_mngs>
</#function>
<#function get_ip_cmns ctx mng>
    <#return ctx + {"cmns": ctx.cmns + mng(ctx.ip)} >
</#function>
<#function common_parts ip>
    <#import "../../support/fp.ftl" as fp >
    <#local ctx = {"ip":ip, "cmns":{}} >
    <#local cmns = fp.foldl(get_ip_cmns, ctx, ip_cmns_mngs![]).cmns >

    <#if cmns?has_content >
        <#import "../MC_task/utils/ips_mng.ftl" as ns_ip>
        <#return ns_ip.IP_settings("${ip} Common settings", ip, cmns) >
    <#else>
        <#return {} >
    </#if>
</#function>


<#macro consolidated_IPs_settings >
    <@strIPs ips_db() />
</#macro>

<#function v_union xs ys>
    <#return v_union2(xs, ys) >
</#function>

<#function v_union1 xs ys>
    <#local ret = xs>
    <#list ys as y>
        <#if ! xs?seq_contains(y) >
            <#local ret = ret + [y]>
        </#if>
    </#list>
    <#return ret>
</#function>

<#function v_union2 xs ys>
    <#local ret = {}>
    <#list xs as x>
        <#local ret = ret + {x:1}>
    </#list>
    <#list ys as y>
        <#local ret = ret + {y:1}>
    </#list>
    <#return ret?keys >
</#function>

<#function updateIPs_DB db ip_params>
<#--
    ip_params =
    { "title"          : title
    , "ip"             : ip
    , "parameters"     : parameters
    , "str_parameters" : ioc_istructions_to_str(ip, parameters)
    , "IPParameters"   : parameters?keys
    }
-->
    <#if ! (ip_params?has_content && ip_params.parameters?has_content) >
        <#return db >
    </#if>


    <#local ip = ip_params.ip>
    <#if ! db[ip]?? >
        <#-- new item -->
        <#-- since it is new I add now the common parts and then the new ones -->
        <#--<#local dummy_init_db_with_ip = initialized_db(db, ip) >-->
        <#return fp.foldl(updateIPs_DB, initialized_db(db, ip), [common_parts(ip), ip_params]) >
        <#--
        //equivalent to the above
        <#return updateIPs_DB( updateIPs_DB(dummy_init_db_with_ip, common_parts(ip)), ip_params) >
        -->
    <#else>
        <#-- IT is already present so I just update the content (using the operator "db + {updated item}" ) -->
        <#local prec_info = db[ip] >
        <#return db + new_db_item(ip, v_union(prec_info.IPParameters, ip_params.IPParameters), prec_info.sections + [ip_params]) >
    </#if>
</#function>


<#function initialized_db db ip>
    <#return db + new_db_item(ip, [], []) >
</#function>
<#function new_db_item ip IPParameters sections>
    <#return {
        ip : { "IPParameters": IPParameters
             , "sections"    : sections
             }
    }>
</#function>

<#macro strIPs db>
    <#import "../ui.ftl" as ui >
    <#list db as ip, info>
        <@ui.boxed ip>
            <#list info.sections as section>
                <@ui.box section.title '' '~' />
                <@ui.line section.str_parameters />
                <#sep><@ui.hline '~'/></#sep>
            </#list>
            <#if info.IPParameters?size gt 0 >
                <@ui.box '${ip} IPParameters' '~' '~' />
                <#local IPParameters>${ip}.IPParameters=${ info.IPParameters?join(',') }</#local>
                <@ui.line IPParameters />
            </#if>
        </@ui.boxed>
        <#sep>

        </#sep>
    </#list>
</#macro>
