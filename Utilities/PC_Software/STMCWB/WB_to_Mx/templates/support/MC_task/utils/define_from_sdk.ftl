<#import "../../fp.ftl" as fp>

<#function define k v>
    <#global usrCONSTs = usrConstDB() + { k : v } >
    <#return { k : v } >
</#function>

<#function usrConstDB>
    <#return (.globals["usrCONSTs"])!{} >
</#function>

<#function serialize_collected_defines >
    <#local xss = fp.hash_to_seq( usrConstDB() )>
    <#return fp.map_ctx(",", join, xss)?join(";") >
</#function>

<#function join sep xs>
    <#return xs?join(sep)>
</#function>

<#function has_defines>
    <#return usrConstDB()?has_content >
</#function>

<#function has_define key>
    <#return (usrConstDB()[key])?? >
</#function>
<#function define_value key>
    <#return (usrConstDB()[key])!"" >
</#function>
