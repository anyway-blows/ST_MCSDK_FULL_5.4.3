<#function collectIP ip>
<#--####################################################################################################################
 #-- HERE THE SIDE EFFECT
 #-->
    <#--<#if ipDB()[ip]?? >-->
        <#global IPs = ipDB() + { ip: true } >
    <#--</#if>-->
<#--#################################################################################################################-->

    <#return ip >
</#function>

<#function ipDB>
    <#return IPs!{} >
</#function>

<#macro used_Mcu_IPs >
    <#import "used_Mcu_xs.ftl" as used_ips >
    <@used_ips.used_Mcu_xs "IP" "" ipDB()?keys />
</#macro>

<#function irq_idx >
    <#global _IRQ_idx = (_IRQ_idx!0) + 1>
    <#return _IRQ_idx >
</#function>

<#function ip_irq name items>
    <#import "../../fp.ftl" as fp>
    <#import "../../utils.ftl" as utils>

    <#if items?size == 7 || items?size == 8  >
   <#--<#if items?size gte 8 >-->
        <#local items = fp.foldl(nvic_apply_ord, {}, items).vs  >
        <#local values = fp.map(utils.toStr, items) >
    <#else>
        <#local values = fp.map(utils.toStr, items) >
    </#if>

    <#local nvic>NVIC.${name}_IRQn=${ values?join("\\:") }</#local>
    <#return nvic >
</#function>

<#function nvic_apply_ord state item>
    <#local idx = (state.idx)!0 >
    <#local vs  = (state.vs)![] >
    <#return idx?switch( 4, {"idx": idx+1, "vs": vs + [true]}
                       , 6, {"idx": idx+1, "vs": vs + [ irq_idx(), item ]}
                       ,    {"idx": idx+1, "vs": vs + [ item ] } ) >
</#function>

<#function IP_settings title ip parameters>
    <#import "../../fp.ftl" as fp>
    <#import "../utils/meta_parameters.ftl" as meta>

    <#return
        { "title"          : title
        , "ip"             : ip
        , "parameters"     : parameters
        , "str_parameters" : meta.ioc_istructions_to_str(ip, parameters)
        , "IPParameters"   : meta.get_IPParameters( parameters )
        }>
</#function>