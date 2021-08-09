
<#function get_cubeMXver>
    <#local ver_info = MxInfo.version>
    <#local res = ver_info?matches("^(\\d)+")>
    <#if res[0]??>
        <#return res[0]>
    <#else>
        <#return "5">
    </#if>
</#function>
