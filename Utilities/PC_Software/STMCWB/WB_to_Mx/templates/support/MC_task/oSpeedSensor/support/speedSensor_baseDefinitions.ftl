<#-- ------------------------------------------------------------------------------------------------------------------+
| BASE MAPPING: I try to normalize the base macro definition                                                           |
+----------------------------------------------------------------------------------------------------------------------+
|  MAIN_SPEED_SENSOR_M1 = "ENCODER" | "HALL_SENSORS" | "other"   ==> defaulted to ""                                   |
|  MAIN_SPEED_SENSOR_M2 = "ENCODER" | "HALL_SENSORS" | "other"   ==> defaulted to ""                                   |
|  AUXI_SPEED_SENSOR_M1 = "ENCODER" | "HALL_SENSORS" | "other"   ==> defaulted to ""                                   |
|  AUXI_SPEED_SENSOR_M2 = "ENCODER" | "HALL_SENSORS" | "other"   ==> defaulted to ""                                   |
|                                                                                                                      |
|  originally they were                                                                                                |
|       * SPEED_SENSOR_SELECTION .......................................for Main Sensor of Motor-1                     |
|         with possible values: "ENCODER" | "HALL_SENSORS"                                                             |
|       * AUXILIARY_SPEED_MEASUREMENT_SELECTION ........................for AUX  sensor of Motor-1                     |
|         with possible values: "AUX_ENCODER" | "AUX_HALL_SENSORS"                                                     |
|                                                                                                                      |
|       * SPEED_SENSOR_SELECTION2.......................................for Main Sensor of Motor-2                     |
|         with possible values: "ENCODER" | "HALL_SENSORS"                                                             |
|       * AUXILIARY_SPEED_MEASUREMENT_SELECTION2........................for AUX  sensor of Motor-2                     |
|         with possible values: "AUX_ENCODER" | "AUX_HALL_SENSORS"                                                     |
|                                                                                                                      |
+----------------------------------------------------------------------------------------------------------------------+

M1 -->
<#global SPEED_SENSOR_SELECTION = SPEED_SENSOR_SELECTION!"" >
<#global M1_MAIN_SPEED_SENSOR = SPEED_SENSOR_SELECTION >
<#---->
<#global AUXILIARY_SPEED_MEASUREMENT_SELECTION = AUXILIARY_SPEED_MEASUREMENT_SELECTION!"" >
<#global M1_AUXI_SPEED_SENSOR = AUXILIARY_SPEED_MEASUREMENT_SELECTION?switch
    ( "AUX_ENCODER"      , "ENCODER"
    , "AUX_HALL_SENSORS" , "HALL_SENSORS"
    , AUXILIARY_SPEED_MEASUREMENT_SELECTION
    )>
<#--

M2 -->
<#global SPEED_SENSOR_SELECTION2 = SPEED_SENSOR_SELECTION2!"" >
<#global M2_MAIN_SPEED_SENSOR = SPEED_SENSOR_SELECTION2?switch
    ( "ENCODER2"      , "ENCODER"
    , "HALL_SENSORS2" , "HALL_SENSORS"
    , SPEED_SENSOR_SELECTION2
    )>
<#-- -->
<#global AUXILIARY_SPEED_MEASUREMENT_SELECTION2 = AUXILIARY_SPEED_MEASUREMENT_SELECTION2!"" >
<#global M2_AUXI_SPEED_SENSOR = AUXILIARY_SPEED_MEASUREMENT_SELECTION2?switch
    ( "AUX_ENCODER2"      , "ENCODER"
    , "AUX_HALL_SENSORS2" , "HALL_SENSORS"
    , AUXILIARY_SPEED_MEASUREMENT_SELECTION2
    )>
<#--

-->
<#function ss_sensing_type who motor>
    <#return "M${motor}_${who}_SPEED_SENSOR"?eval >
</#function>

<#function speed_Sensor who motor>
    <#return
        { "motor"        : motor
        , "name"         : who
        , "sensing_type" : ss_sensing_type(who, motor)
        }>
</#function>