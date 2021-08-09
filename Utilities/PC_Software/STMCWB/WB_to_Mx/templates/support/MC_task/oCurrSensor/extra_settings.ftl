
<#--  empty: please, do not remove this file  -->

<#assign extras = {} >

<#function add_extras title, ip, f_manage, extra_parameters>
    <#assign meta_extras =
        { "manage"  : f_manage
        , "extras" : extra_parameters
        , "title"  : title
        }>

    <#local array_of_extra_requests_for_this_ip = (extras[ip]![]) + [meta_extras] >
    <#assign extras = extras + {ip: array_of_extra_requests_for_this_ip} >
    <#return extra_parameters >
</#function>

<#function manage_extras ip_ov>
    <#local ret = []>

    <#list extras as ip, exs>
        <#list exs as meta_extras>
            <#-- sinse any step can modify the info collected on an ip
                it is required to reload the info here, at any step
            -->
            <#local info = ip_ov.ips_db()[ip]! >
            <#if ! meta_extras.manage(info, meta_extras.extras) >
                <#local ret = ret + ["${ip}: [${meta_extras.title}] - do not requires extras"]>
            </#if>
        </#list>

    </#list>

    <#return ret>
</#function>
