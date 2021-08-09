<#import "../../fp.ftl" as fp>

<#function _ioc_istructions_to_str ip parameters>
    <#local vector = []>
    <#list parameters as k, v>
        <#if     isComment(k) ><#local strValue>${'\n'}# ${v?replace("\n", "\n# ")}</#local>
        <#elseif isBlank(k)   ><#local strValue = "">
        <#elseif isText(k)    ><#local strValue = v>

        <#elseif isNoCheck(k) ><#local strValue>${ip}.${ noCheckKey(k) }=${v}</#local>
        <#else                ><#local strValue>${ip}.${ k?trim        }=${v}</#local>
        </#if>

        <#local vector = vector + [strValue] >
    </#list>
    <#return vector>
</#function>

<#function _ip_params_to_str ip parameters>
    <#local IPParameters             = get_IPParameters(parameters) >
    <#local IPParametersWithoutCheck = get_IPParametersWithoutCheck(parameters) >

    <#local all_parameters = parameters + {"IPParameters": IPParameters?join(',')} >

    <#if IPParametersWithoutCheck?size gt 0>
        <#local all_parameters += {"IPParametersWithoutCheck" : IPParametersWithoutCheck?join(',')} >
    </#if>

    <#return _ioc_istructions_to_str(ip, all_parameters) >
</#function>


<#--####################################################################################################################
 #                                                                                                                     #
 #  Public API                                                                                                         #
 #                                                                                                                     #
 ####################################################################################################################-->
<#function ioc_istructions_to_str ip parameters>
    <#return _ioc_istructions_to_str(ip, parameters)?join('\n', '', '\n')>
</#function>

<#function ip_params_to_str ip parameters>
    <#return _ip_params_to_str(ip, parameters)?join('\n', '', '\n') >
</#function>
<#--#################################################################################################################-->


<#function isNoCheck k>
    <#return k?starts_with("#nochk") >
</#function>
<#function noCheckKey k>
    <#return isNoCheck(k)?then(k?split("?")[1..]?join(""), k?trim) >
</#function>


<#function isComment k>
    <#return k?starts_with("#comment") >
</#function>

<#function isBlank k>
    <#return k?starts_with("#blank") >
</#function>

<#function isText k>
    <#return k?starts_with("#text") >
</#function>

<#function _filter_meta_parameters k>
    <#return
    !( isComment(k)
    || isBlank  (k)
    || isText   (k)
    || isNoCheck(k))>
</#function>

<#function trim_str str>
    <#return str?trim>
</#function>

<#function get_IPParameters parameters>
    <#return fp.map(trim_str, fp.filter(_filter_meta_parameters, parameters?keys))
           + get_IPParametersWithoutCheck(parameters)
           >
</#function>

<#function get_IPParametersWithoutCheck parameters>
    <#return fp.map(noCheckKey, fp.filter(isNoCheck, parameters?keys) )>
</#function>

<#assign _meta_seed = 0>
<#function nextSeed>
    <#assign _meta_seed = 1 + _meta_seed>
    <#return _meta_seed >
</#function>

<#function comment_key ><#return "#comment ${ nextSeed()}" ></#function>
<#function blankLn_key ><#return "#blank ${   nextSeed()}" ></#function>
<#function    text_key ><#return "#text ${    nextSeed()}" ></#function>

<#function no_chk key  ><#return "#nochk?${key}" ></#function>

<#function comment txt><#return { comment_key(): txt } ></#function>
<#function blankLn txt><#return { blankLn_key(): txt } ></#function>
<#function    text txt><#return {    text_key(): txt } ></#function>