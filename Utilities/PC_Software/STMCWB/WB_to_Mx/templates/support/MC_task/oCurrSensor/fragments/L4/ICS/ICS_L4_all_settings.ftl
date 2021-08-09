<#import "../../../../../ui.ftl" as ui >
<#import "../../Fx_commons/cs_cmn_settings.ftl" as cmn_sets >
<#import "../../../../../utils.ftl" as utils>

<#import "../R3_4/R3_4_L4_all_settings.ftl" as R3_4>

<#macro ICS_L4_all_settings motor device sense>
    <@curr_sense_OCP                                        motor /><@ui.hline ' '/>
    <@R3_4.curr_sense_TIMER                                 motor /><@ui.hline ' '/>
    <@curr_sense_OPAMPs_and_ADCs                            motor /><@ui.hline ' '/>
    <@cmn_sets.curr_sense_GENETATE_CONSOLIDATED_PIN_SETTING motor /><@ui.hline ' '/>
    <@cmn_sets.curr_sense_SINCRONIZATION_TIMERs             motor />
</#macro>

<#macro curr_sense_OCP motor>
    <#import "../com/L4_ocp.ftl" as ns_ocp >
    <#local config = ns_ocp.cs_over_current_prot(motor, ["U", "V"]) >
    <@cmn_sets.curr_sense_OCP config />
</#macro>


<#macro curr_sense_OPAMPs_and_ADCs motor>
    <#local opamp_config = R3_4.curr_sense_OPAMPs(motor) >
    <#local adc_config   = curr_sense_ADC(motor, opamp_config.internal_opamps) >
<#-- -->
    <@cmn_sets.curr_sense_OPAMPs opamp_config />
    <@cmn_sets.curr_sense_ADC    adc_config />
</#macro>

<#function curr_sense_ADC motor internal_opamps=false>
    <#import "ICS_L4_adc.ftl" as ics_adc >
    <#return ics_adc.cs_ADC_settings(motor, internal_opamps)>
</#function>
