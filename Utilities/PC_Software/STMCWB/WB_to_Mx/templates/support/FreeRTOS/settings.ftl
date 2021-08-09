<#import "../MC_task/utils/ips_mng.ftl"  as ns_ip  >
<#import "../fp.ftl"                     as fp     >
<#import "../MC_task/utils/pins_mng.ftl" as ns_pin >
<#import "../utils.ftl"                  as utils  >
<#import "../../support/names_map.ftl"   as rr     >

<#function set_ip free_rtos>
    <#return   ns_ip.collectIP(free_rtos) >
</#function>


<#function build_VPs free_rtos>
    <#local vector = []>
    <#list MxInfo.version?split(".") as verNumber>
        <#local vector = vector + [verNumber] >
    </#list>

    <#local major = (vector[0]??)?then(vector[0]?number, 0)>
    <#local minor = (vector[1]??)?then(vector[1]?number, 0)>
    <#if (major >=5 && minor >=2)>
        <#local sig_mode_s  = { "CMSIS_V1" : "CMSIS_V1"}>
    <#else>
        <#local sig_mode_s  = { "ENABLE" : "Enabled" }>
    </#if>

    <#local vps = {} >
    <#list sig_mode_s as signal, mode>
    <#--<#local v_signal = "${WB_PFCTIMER?upper_case}_VS_${signal}" >-->
        <#local v_signal = "${free_rtos}_VS_${signal}" >
        <#local vp = "VP_${v_signal}" >
        <#local vps = vps +
        { vp : [ "${vp}.Mode=${mode}"
        , "${vp}.Signal=${v_signal}"
        ]
        }>
    </#list>

    <#local registered_vps = fp.map(ns_pin.collectPin, vps?keys) >

    <#return fp.flatten(vps?values)?join("\n") >
</#function>


<#function build_VPs2 timer>

    <#local tim = timer?lower_case>
    <#local sig_mode_s  = { tim : tim}>

    <#local vps = {} >
    <#list sig_mode_s as signal, mode>
    <#--<#local v_signal = "${WB_PFCTIMER?upper_case}_VS_${signal}" >-->
        <#local v_signal = "SYS_VS_${signal}" >
        <#local vp = "VP_${v_signal}" >
        <#local vps = vps +
        { vp : [ "${vp}.Mode=${mode?upper_case}"
        , "${vp}.Signal=${v_signal}"
        ]
        }>
    </#list>
    <#local registered_vps = fp.map(ns_pin.collectPin, vps?keys) >

    <#return fp.flatten(vps?values)?join("\n") >
</#function>

<#function get_name_TimeBase ip_tim>
    <#local timer = utils.mx_name("IRQ_TIM_NAME") >
    <#local timeBase_IRQ = ( timer?is_hash && timer[ip_tim]?? )?then(timer[ip_tim], ip_tim) >
    <#return timeBase_IRQ>
</#function>


<#function IRQ tim>
    <#local timer = get_name_TimeBase(tim) >
    <#return  ns_ip.ip_irq(timer, [true, 0, 0, false, false, true, false, false])>
</#function>



<#function NVIC_TB ip_tim>
  <#--  <#local timer = utils.mx_name("IRQ_TIM_NAME") >
    <#local ip_IRQ = ( timer?is_hash && timer[ip_tim]?? )?then(timer[ip_tim], ip_tim) >-->
    <#local  ip_IRQ = get_name_TimeBase(ip_tim)>
    <#local TimeBase   = "NVIC.TimeBase=${ip_IRQ}_IRQn\n" >
    <#local TimeBaseIP = "NVIC.TimeBaseIP=${ip_tim}\n">
    <#return  [TimeBase + TimeBaseIP]>

</#function>




<#function tasks_and_queues>
   <#local footprint = "FREERTOS.FootprintOK=true\n">
   <#local ipparameters = "FREERTOS.IPParameters=Tasks01,FootprintOK\n">
   <#local tasks = "FREERTOS.Tasks01=mediumFrequency,0,128,startMediumFrequencyTask,As weak,NULL,Dynamic,NULL,NULL;safety,1,128,StartSafetyTask,As external,NULL,Dynamic,NULL,NULL\n">
   <#return [footprint + ipparameters + tasks]>
</#function>