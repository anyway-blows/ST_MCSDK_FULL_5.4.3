<#import "fp.ftl" as fp >

<#macro box caption top_char='#' bottom_char='#' center=true>
<#--

    TOP side, 120 chars length line filled with top_char's
--><#if top_char?has_content
    ><@hline top_char />
</#if><#--


    BODY, 120 chars length line filled with 'content' ; can be centered
--><#if caption?has_content>
    <#if center
        ><@center_comment_line caption />
    <#else
        ><@left_comment_line caption />
    </#if>
</#if><#--


    BOTTOM side, 120 chars length line filled with bottom_char's
--><#if bottom_char?has_content
    ><@hline bottom_char />
</#if>
</#macro>

<#macro hline ch='-'>${ _hline(ch) }
</#macro>

<#macro boxed title border='#'>
    <@ui.box title border border false />
    <#nested >
    <@ui.hline border />
</#macro>


<#macro boxed_loop title xs sep='='>
    <@ui.boxed title >
        <#list xs as x>
            <#nested x?index x>
            <#sep><@ui.hline sep /></#sep>
        </#list>
    </@ui.boxed>
</#macro>

<#macro line x>${ _line(x) }
</#macro>
<#function _line x >
    <#if x?is_sequence>
        <#return x?join("\n") >
    <#else>
        <#return x >
    </#if>
</#function>


<#macro comment text>${ _comment(text) }
</#macro>

<#function _comment text>
    <#if ! text?is_sequence>
        <#local ts = text?split("\n") >
    <#else>
        <#local ts = text >
    </#if>
    <#return fp.map(_left_comment_line, ts)?join('\n') >
</#function>


<#macro center_comment_line text >${ _center_comment_line(text) }
</#macro>

<#macro left_comment_line text >${ _left_comment_line(text) }
</#macro>


<#function _hline ch='-'>
    <#return "#${ ch?right_pad(118, ch) }#" >
</#function>

<#function _center_comment_line title >
    <#return "#${ title?right_pad((118 + title?length)/2)?left_pad(118) }#" >
</#function>

<#function _left_comment_line title >
    <#return "# ${ title?right_pad(116) } #">
</#function>


<#function _box caption
    top_char   = '#'
    bottom_char= '#'
    center     = true >

    <#local sx = []>

    <#-- TOP side, 120 chars length line filled with top_char's -->
    <#if top_char?has_content>
        <#local sx = sx + [_hline(top_char)] />
    </#if>

    <#-- BODY, 120 chars length line filled with 'content' ; can be centered -->
    <#if caption?has_content>
        <#if center>
            <#local sx = sx + [_center_comment_line(caption)] />
        <#else>
            <#local sx = sx + [_left_comment_line(caption)] />
        </#if>
    </#if>

    <#-- BOTTOM side, 120 chars length line filled with bottom_char's -->
    <#if bottom_char?has_content>
        <#local sx = sx + [_hline(bottom_char)] />
    </#if>

    <#return sx?join("\n") >
</#function>


<#macro messageBox title body>
    <@ui.boxed title>
        <@ui.comment body />
    </@ui.boxed>
</#macro>
