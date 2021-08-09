<#import "support/speedSensor_baseDefinitions.ftl" as ss_norm>
<#import "support/includeFragmentDefinitions.ftl"  as ss_m>

<#import "../../ui.ftl" as ui >
<#import "support/utils.ftl" as ss >
<#import "../../fp.ftl" as fp >
<#--

-->
<#macro oSpeedSensor >
    <@ui.boxed_loop "SPEED SENSING" fp.flatMap(ss_mapper, 1..WB_NUM_MOTORS) ; idx, sensor >
        <@sensing_macro(sensor.sensing_type) sensor.name sensor.motor />
    </@ui.boxed_loop>
</#macro>

<#function sensing_macro sensing_type>
    <#return sensing_type?switch
        ( "HALL_SENSORS" , ss_m.HALL_SENSORS_SpeednPosFdbk
        , "ENCODER"      , ss_m.ENCO_SENSORS_SpeednPosFdbk
                         , ss.speed_sensing_no_request
        )>
</#function>
<#--

-->
<#function ss_mapper motor>
    <#return [ss_norm.speed_Sensor("MAIN", motor), ss_norm.speed_Sensor("AUXI", motor)] >
</#function>
