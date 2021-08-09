<#import "../../ui.ftl" as ui >
<#import "../../fp.ftl" as fp >
<#import "../../utils.ftl" as utils >
<#import "../ADC/adc_overlap.ftl" as adc_ov>
<#import "ADC_Temp_and_Bus_sense.ftl" as adc_tb>
<#--

-->
<#macro oTemp_and_Bus_Sense>
<#--
    <@ui.boxed_loop "TEMPERATURE and BUS VOLTAGE SENSING" fp.flatMap(tb_mapper, 1..WB_NUM_MOTORS) ; idx, section >
        <#if section?has_content >
            <@Temp_and_Bus_Sensing_macro section />
        <#else>
            <@temp_bus_no_request idx+1 />
        </#if>
    </@ui.boxed_loop>
-->
    <@ui.boxed "TEMPERATURE and BUS VOLTAGE SENSING" >
        <#local by_adc_grouped_received_requests = fp.groupBy("ip", fp.flatMap(tb_required_conversions, 1..WB_NUM_MOTORS)) >
        <@comment_grouped_request by_adc_grouped_received_requests />
        <@ui.hline "x"/>
<#--

            any xs item of xss represents the set of reqs that can be considered equals indeed
            any xs have to bebome a single unified request ~~> fusion of more requests -->
        <#local xss_by_adc_grouped_unified_requests = fp.map(to_common_sensors, fp.map(fp.values, fp.map(tb_group_by_similarity, by_adc_grouped_received_requests?values) ) ) >

        <#local sections = fp.map(tb_create_adc_section, xss_by_adc_grouped_unified_requests)>
        <#list sections as section>
            <@Temp_and_Bus_Sensing_macro section />
            <#sep >
                <@ui.hline "x"/>
            </#sep>
        <#else>
            <@temp_bus_no_request 1 />
            <@temp_bus_no_request 2 />
        </#list>
    </@ui.boxed>
</#macro>

<#macro comment_grouped_request grouped_requests>
    <#list grouped_requests as ip, reqs>
        <@ui.box "sensing section for ${ip}" '' 'x' false />
        <#list reqs as sensor>
            <@ui.comment
            [ "    ${sensor.label}"
            , "        pin            : ${sensor.pin            }"
            , "        ip             : ${sensor.ip             }"
            , "        channel        : ${sensor.channel        }"
            , "        isChShared     : ${sensor.isChShared?c   }"
            , "        sampling_time  : ${sensor.sampling_time  }"
            , "        sampling_cycles: ${sensor.sampling_cycles}"
            , "        motor          : ${sensor.motor          }"
            ]?join("\n") />
            <#sep >
                <@ui.hline "."/>
            </#sep>
        </#list>
        <#sep >
            <@ui.hline "x"/>
        </#sep>
    </#list>
</#macro>

<#macro Temp_and_Bus_Sensing_macro section >
    <@tb_IP_section section />
    <@ui.hline '~' />
    <@tb_PIN_section section />
</#macro>

<#macro temp_bus_no_request motor >
    <@ui.box "NO TEMPERATURE-VBUS SENSING REQUIRED for M${motor}" '' ''/>
</#macro>

<#import "../utils/ips_mng.ftl"  as ns_ip>
<#import "../utils/pins_mng.ftl" as ns_pin>

<#macro tb_IP_section section>
    <#local ip_stored = ns_ip.collectIP( section.ip )>
    <@ui.box "${section.ip} ${section.title} Sensing settings" '' '.' />
    <#-- adc_settings not used here but stored for later use  -->
    <#local adc_settings = adc_ov.update_ADCs_IPParameters(
        ns_ip.IP_settings( "${section.ip} ${section.title} Sensing settings"
                         , section.ip
                         , section.parameters
                         )
    )>
    <@ui.box "The ADC settings section was POSTPONED. Will be part of a cumulative section dedicated to all ADCs" '' '' false/>
</#macro>

<#import "../utils/mcu_pin_setting_mng.ftl" as cs >
<#macro tb_PIN_section section>
             <#-- map any section.sensor to its textual representation -->
    <#local ret = fp.map(_tb_PIN_section_, section.sensors)  >
    <#local sensorsSep = "\n${ui._hline('~')}\n" >
    <@ui.line ret?join( sensorsSep ) />
</#macro>

<#function _tb_PIN_section_ sensor>
    <#local channel= "IN${ utils._last_word(sensor.channel)}" >
    <#local signal = "${sensor.ip}_${channel}" >

    <#local mode   = "${channel}${ utils.mx_name(\"ADC_PIN_MODE_SUFFIX\") }" >

    <#local pinDef =
        { "name"   : sensor.pin
        , "label"  : sensor.label, "customLabel": true
        , "signal" : signal
        , "mode"   : mode
        , "motor"  : ""
        , "ip"     : { "name": sensor.ip , "pin" : "IN${channel}" }
        } >

    <#if sensor.isChShared>
        <#local pinDef = pinDef + { "sh_signal": "ADCx_${channel}" } >
    </#if>

    <#local strPinDef = cs.csf_pin_GPIO(pinDef) />

    <#local title>GPIO settings for ${sensor.label} Sensing </#local>
    <#return [ui._box(title '' '.'), strPinDef]?join("\n") >
</#function>

<#function tb_label x><#return x.label></#function>

<#-- return the list of used sensors on the given motor -->
<#function tb_required_conversions motor>
    <#local is_vbus_enabled
         = utils.v("BUS_VOLTAGE_READING"      , motor)
       <#-- && utils.v("OV_VOLTAGE_PROT_ENABLING" , motor)
        && utils.v("UV_VOLTAGE_PROT_ENABLING" , motor)--> >

    <#local is_temp_enabled
         = utils.v("TEMPERATURE_READING"         , motor)
        <#--&& utils.v("OV_TEMPERATURE_PROT_ENABLING", motor) -->>

    <#local ret = [] >
    <#if is_vbus_enabled ><#local ret = ret + [busSensorInfo(motor)]  ></#if>
    <#if is_temp_enabled ><#local ret = ret + [tempSensorInfo(motor)] ></#if>
    <#return ret>
</#function>

<#-- create a section collecting all the Regular Conversions, one for each sensor -->
<#function tb_create_adc_section sensors>
    <#return
        { "ip"         : sensors[0].ip
        , "parameters" : adc_tb.Temp_Bus_sense_adc_parameters(sensors)
        , "sensors"    : sensors
        , "title"      : fp.map(tb_label, sensors)?join(" and ")
        }>
</#function>


<#--#################################################################
 #   <define key="VBUS_ADC"               value="ADC1"          />  #
 #   <define key="VBUS_CHANNEL"           value="ADC_Channel_1" />  #
 #   <define key="VBUS_GPIO_PORT"         value="GPIOA"         />  #
 #   <define key="VBUS_GPIO_PIN"          value="GPIO_Pin_0"    />  #
 #   <define key="VBUS_ADC_SAMPLING_TIME" value="61"            />  #
 ####################################################################-->
<#function busSensorInfo m >
<#-- VBUS_ADC -->
    <#local sampling_cycles = utils.mx_name("VBUS_ADC_SAMPLING_CYCLE") >

    <#return
    { "ip"              :utils.mx_name( utils.v("VBUS_ADC"   , m) )
    , "channel"         :      utils.v("VBUS_CHANNEL"          , m)?upper_case
    , "isChShared"      :      false<#--utils.v("VBUS_ADC"              , m)?contains('_')-->
    , "pin"             : ns_pin.name2(m,"VBUS")
    , "sampling_time"   :      utils.v("VBUS_ADC_SAMPLING_TIME", m)
    , "sampling_cycles" : sampling_cycles?is_hash?then(sampling_cycles.value!5, 5)
    , "label"           : "M${m}_BUS_VOLTAGE"
    , "motor"           : m
    , "type"            : "BUS_VOLTAGE"
    }>
</#function>


<#--#################################################################
 #  <define key="TEMP_FDBK_ADC"          value="ADC1"          />   #
 #  <define key="TEMP_FDBK_CHANNEL"      value="ADC_Channel_5" />   #
 #  <define key="TEMP_FDBK_GPIO_PORT"    value="GPIOF"         />   #
 #  <define key="TEMP_FDBK_GPIO_PIN"     value="GPIO_Pin_4"    />   #
 #  <define key="TEMP_ADC_SAMPLING_TIME" value="61"            />   #
 ####################################################################-->
<#function tempSensorInfo m>
    <#local sampling_cycles = utils.mx_name("TEMP_ADC_SAMPLING_CYCLE") >
<#--TEMP_FDBK_ADC-->
    <#return
    { "ip"              :utils.mx_name(utils.v("TEMP_FDBK_ADC"    , m))
    , "channel"         :      utils.v("TEMP_FDBK_CHANNEL"     , m)?upper_case
    , "isChShared"      :      false<#--utils.v("TEMP_FDBK_ADC"         , m)?contains('_')-->
    , "pin"             : ns_pin.name2(m,"TEMP_FDBK")
    , "sampling_time"   :      utils.v("TEMP_ADC_SAMPLING_TIME", m)
    , "sampling_cycles" : sampling_cycles?is_hash?then(sampling_cycles.value!0, 5)
    , "label"           : "M${m}_TEMPERATURE"
    , "motor"           : m
    , "type"            : "TEMPERATURE"
    }>
</#function>





<#-- UTILITIES -->
<#import "../utils/user_constants.ftl" as mcu>
<#--
<#assign M1_a = mcu.define("M1_BUS_VOLTAGE_GPIO_Port", "BUS_VOLTAGE_GPIO_Port") >
<#assign M1_b = mcu.define("M1_BUS_VOLTAGE_GPIO_Pin" , "BUS_VOLTAGE_GPIO_Pin" )  >
<#assign M2_a = mcu.define("M2_BUS_VOLTAGE_GPIO_Port", "BUS_VOLTAGE_GPIO_Port") >
<#assign M2_b = mcu.define("M2_BUS_VOLTAGE_GPIO_Pin" , "BUS_VOLTAGE_GPIO_Pin" )  >
-->

<#function to_common_sensors rss>
    <#return fp.map(fuse_sensors, rss) >
</#function>
<#function fuse_sensors rs>
    <#local r = fp.foldl(_fuse_sensors, {}, rs) >

    <#local lbs = []>

    <#list r.lbs as type, ms>
        <#if ms?size == 1 >
            <#local lbs = lbs + [ "M${ms[0]}_${type}" ] >
        <#else>
            <#local lbs = lbs + [type] >
            <#list ms as m>
                <#local user_constant_port = mcu.define("M${m}_${type}_GPIO_Port", "${type}_GPIO_Port") >
                <#local user_constant_pin  = mcu.define("M${m}_${type}_Pin"      , "${type}_Pin"      ) >
            </#list>
        </#if>
    </#list>

    <#return r + {"label": lbs?join("-")} >
</#function>
<#function _fuse_sensors acc s>
    <#if ! acc.ip?? >
        <#local acc = acc +
            { "ip"              : s.ip
            , "channel"         : s.channel
            , "isChShared"      : s.isChShared
            , "pin"             : s.pin
            , "sampling_time"   : s.sampling_time
            , "sampling_cycles" : s.sampling_cycles

            , "lbs" : {}
            } >
    </#if>

    <#if ! acc.lbs[s.type]?? >
        <#local lbs = acc.lbs + { s.type :                   [s.motor] } >
    <#else>
        <#local lbs = acc.lbs + { s.type : acc.lbs[s.type] + [s.motor] } >
    </#if>
    <#return acc + { "lbs" : lbs }>
</#function>





<#function min a b>
    <#return (a lte b)?then(a, b) >
</#function>
<#--
    Generate a string representing the essence/fingerprint of the "sensing request"/"conversion request" (here called sensor)
    This will allow me to group requests/sensors by similarity
-->
<#function tb_sensor_essence ctx sensor>
    <#return
        [ "${sensor.ip}"
        , "${sensor.channel}"
        , "${sensor.isChShared?c}"
        , "${sensor.pin}"
        , "${sensor.sampling_time}"
        , "${sensor.sampling_cycles}"
        ]
        ?join("-") >
</#function>

<#function tb_group_by_similarity rs>
    <#return fp.groupBy_ctx([], tb_sensor_essence, rs) >
</#function>
