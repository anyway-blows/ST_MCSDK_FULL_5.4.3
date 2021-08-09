<#import "../../Fx_commons/cs_cmn_settings.ftl" as cmn_sets >

<#macro F4_all_settings tasks motor device sense>
    <#list tasks as t>
        <#local title = t[0] config = t[1](motor)>
        <@cmn_sets.curr_sense_section title config />
    </#list>
    <@cmn_sets.curr_sense_GENETATE_CONSOLIDATED_PIN_SETTING motor />
</#macro>
