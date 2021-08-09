<#import "../../../../../ui.ftl" as ui >

<#import "../../../../utils/ips_mng.ftl" as ns_ip>
<#import "../../Fx_commons/cs_cmn_settings.ftl" as cmn_sets >

<#macro R3_1_L4_all_settings motor device sense>
   <@curr_sense_OCP                                         motor /><@ui.hline ' '/>
   <@curr_sense_TIMER                                       motor /><@ui.hline ' '/>
   <@curr_sense_ADC                                         motor /><@ui.hline ' '/>
   <@cmn_sets.curr_sense_GENETATE_CONSOLIDATED_PIN_SETTING  motor /><@ui.hline ' '/>
   <@cmn_sets.curr_sense_SINCRONIZATION_TIMERs              motor />
</#macro>

<#macro curr_sense_OCP motor>
    <#import "../com/L4_ocp.ftl" as ns_ocp >
    <@cmn_sets.curr_sense_OCP ns_ocp.cs_over_current_prot(motor, ["U", "V", "W"]) />
</#macro>

<#macro curr_sense_TIMER motor>
    <#import "../com/L4_pwm_timer.ftl" as cmns_tmr>
    <#import "R3_1_L4_pwm_timer.ftl" as tmr >
    <#--<@cmns_tmr.curr_sense_TIMER motor tmr.cs_PWM_TIMER_patameters />-->
    <#local config = cmns_tmr.cs_TIMER_settings(motor, tmr.cs_PWM_TIMER_patameters) >
    <#local config = extra_TIM_UP_IRQ_settings(cmns_tmr.timer_srcs(motor), config) >
    <@cmn_sets.curr_sense_TIMER config />
</#macro>

<#function extra_TIM_UP_IRQ_settings timer config>
    <#local irq_name = timer.name?switch
    ( "TIM1", "TIM1_UP_TIM16"
    , "TIM8", "TIM8_UP"
    , "")
    >
    <#if irq_name?has_content >
        <#import "../../../../../names_map.ftl" as rr>
        <#local set_irq_tim = rr["SET_IRQ_TIM"]!([true, 0, 0, false, false, false, true]) >
        <#local tim_up_IRQ = ns_ip.ip_irq( irq_name,set_irq_tim) >

    <#--<#local tim_up_IRQ = ns_ip.ip_irq( irq_name, [true, 0,0,false, false, false, true]) >-->
        <#local settings = config.settings
        + { "Extra ${timer.name}_UP IRQ (Required in conf: L4 R3_1 )" : tim_up_IRQ }>
        <#local config = config + {"settings": settings} >
    </#if>

    <#return config >
</#function>


<#macro curr_sense_ADC motor>
    <#import "R3_1_L4_adc.ftl" as ns_adc >
    <#local config = ns_adc.cs_ADC_settings(motor) >
    <@cmn_sets.curr_sense_ADC config />
</#macro>
