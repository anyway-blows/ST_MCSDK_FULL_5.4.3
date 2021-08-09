<#function _dead_time_counts dead_time_counts_1 divider offset>
    <#return ( offset + dead_time_counts_1 / divider )?floor >
</#function>

<#function dead_time_counts dead_time_counts_1>
    <#if     dead_time_counts_1 <  256 ><#return _dead_time_counts(dead_time_counts_1,  1,   0) >
    <#elseif dead_time_counts_1 <  509 ><#return _dead_time_counts(dead_time_counts_1,  2, 128) >
    <#elseif dead_time_counts_1 < 1009 ><#return _dead_time_counts(dead_time_counts_1,  8, 320) >
    <#elseif dead_time_counts_1 < 2016 ><#return _dead_time_counts(dead_time_counts_1, 16, 384) >
    <#else                             ><#return 510 >
    </#if>
</#function>
