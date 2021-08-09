<#import  "../../../ui.ftl" as ui >
<#--

-->
<#function dev_family_oCurrSensor >
<#-- support only SINGLEDRIVE -->
    <#if     STM32PERFORMANCE?? ><#return "STM32PERFORMANCE"             > <#-- exp -->
    <#elseif STM32VALUE??       ><#return "STM32VALUE"                   > <#-- exp -->
    <#elseif STM32F0XX??        ><#return "STM32F0XX"                    >
    <#elseif STM32F302X8??      ><#return "STM32F302X8"                  >
    <#elseif STM32F401XX??      ><#return "STM32F401XX"                  >
    <#elseif STM32L452XX??      ><#return "STM32L452XX"                  >
    <#elseif STM32L476XX??      ><#return "STM32L476XX"                  >

    <#elseif STM32F746XX??      ><#return "STM32F746XX"                  >
    <#elseif STM32F769XX??      ><#return "STM32F769XX"                  >

    <#elseif STM32G071XX??      ><#return "STM32G071XX"                  >
    <#elseif STM32G081XX??      ><#return "STM32G081XX"                  >

    <#elseif STM32G431CB??      ><#return "STM32G431CB"                  >
    <#elseif STM32G431RB??      ><#return "STM32G431RB"                  >
    <#--<#elseif STM32G474QE??      ><#return "STM32G474QE"                  >-->

    <#-- support both SINGLE and DUALDRIVE -->
    <#elseif STM32HD??          ><#return "STM32HD"                      > <#-- exp -->
    <#elseif STM32F2XX??        ><#return "STM32F2XX"                    >
    <#elseif STM32F4XX??        ><#return "STM32F4XX"                    >
    <#elseif STM32G474QE??      ><#return "STM32G474QE"                  >
    <#-- it is important to put STM32F30X after STM32F302X8 because the latter is more particular and have to be used in case of both presence -->
    <#elseif STM32F30X??        ><#return "STM32F30X"                    > <#-- exp -->



    <#else                      ><#return "NONE"                         >
    </#if>
</#function>

<#---------------+-----------------------------------+-----------------------+
PSEUDO DEV CLASS | SENSING                           | DEV  | SENSE | isDUAL |
-----------------+-----------------------------------+-----------------------+
STM32F0XX        | SINGLE_SHUNT                      | F0XX   R1             |
STM32F0XX        | THREE_SHUNT                       | F0XX   R3             |

STM32F2XX        | ICS_SENSORS                       | F2XX   ICS    DUAL    |
STM32F2XX        | SINGLE_SHUNT                      | F2XX   R1     DUAL    |
STM32F2XX        | THREE_SHUNT                       | F2XX   R3     DUAL    |

STM32F302X8      | SINGLE_SHUNT                      | F30X   R1             |
STM32F302X8      | THREE_SHUNT                       | F30X   R3_1           |

STM32F30X        | ICS_SENSORS                       | F30X   ICS    DUAL    |
STM32F30X        | SINGLE_SHUNT                      | F30X   R1     DUAL    |
STM32F30X        | THREE_SHUNT                       | F30X   R3_1           |
STM32F30X        | THREE_SHUNT_SHARED_RESOURCES      | F30X   R3_2   DUAL    |
STM32F30X        | THREE_SHUNT_INDEPENDENT_RESOURCES | F30X   R3_4   DUAL    |
                 |                                   |                       |
STM32F4XX        | ICS_SENSORS                       | F4XX   ICS    DUAL    |
STM32F4XX        | SINGLE_SHUNT                      | F4XX   R1     DUAL    |
STM32F4XX        | THREE_SHUNT                       | F4XX   R3     DUAL    |

STM32F401XX      | THREE_SHUNT                       | F4XX   R3             |
STM32F401XX      | SINGLE_SHUNT                      | F4XX   R1             |

STM32HD          | ICS_SENSORS                       | HD2    ICS    DUAL    |
STM32HD          | SINGLE_SHUNT                      | HD2    R1     DUAL    |
STM32HD          | THREE_SHUNT                       | HD2    R3     DUAL    |

STM32PERFORMANCE | ICS_SENSORS                       | LM1    ICS            |
STM32PERFORMANCE | SINGLE_SHUNT                      | LM1    R1             |
STM32PERFORMANCE | THREE_SHUNT                       | LM1    R3             |

STM32VALUE       | SINGLE_SHUNT                      | VL1    R1             |

STM32L452XX      | SINGLE_SHUNT                      | L4XX   R1             |
STM32L452XX      | THREE_SHUNT                       | L4XX   R3_1           |

STM32L476XX      | ICS_SENSORS                       | L4XX   ICS            |
STM32L476XX      | SINGLE_SHUNT                      | L4XX   R1             |
STM32L476XX      | THREE_SHUNT                       | L4XX   R3_1           |
STM32L476XX      | THREE_SHUNT_INDEPENDENT_RESOURCES | L4XX   R3_4           |

STM32F746XX      |ICS_SENSORS                        | F7XX   ICS            |
STM32F746XX      |SINGLE_SHUNT                       | F7XX   R1             |
STM32F746XX      |THREE_SHUNT                        | F7XX   R3_1           |
STM32F746XX      |THREE_SHUNT_INDEPENDENT_RESOURCES  | F7XX   R3_4           |

STM32F769XX      |ICS_SENSORS                        | F7XX   ICS            |
STM32F769XX      |SINGLE_SHUNT                       | F7XX   R1             |
STM32F769XX      |THREE_SHUNT                        | F7XX   R3_1           |
STM32F769XX      |THREE_SHUNT_INDEPENDENT_RESOURCES  | F7XX   R3_4           |

STM32G071XX      |SINGLE_SHUNT                       | G0XX   R1             |
STM32G071XX      |THREE_SHUNT                        | G0XX   R3_1           |

STM32G081XX      |SINGLE_SHUNT                       | G0XX   R1             |
STM32G081XX      |THREE_SHUNT                        | G0XX   R3_1           |

STM32G431RB      | ICS_SENSORS                       | G4XX   ICS  Not supported |
STM32G431RB      | SINGLE_SHUNT                      | G4XX   R1             |
STM32G431RB      | THREE_SHUNT                       | G4XX   R3_1 Not supported |
STM32G431RB      | THREE_SHUNT_INDEPENDENT_RESOURCES | G4XX   R3_4           |

STM32G431CB      | THREE_SHUNT_INDEPENDENT_RESOURCES  | G4XX  R3_4 ESC       |

STM32G474QE      | ICS_SENSORS                       | G4XX   ICS  Not supported|
STM32G474QE      | SINGLE_SHUNT                      | G4XX   R1             |
STM32G474QE      | THREE_SHUNT                       | G4XX   R3_1  Not supported|
STM32G474QE      | THREE_SHUNT_INDEPENDENT_RESOURCES | G4XX   R3_4    Dual   |

-----------------+-----------------------------------+----------------------->
<#function supportedCurrSenseMacros devClass sense motor >

    <#local shortSense =
    { "ICS_SENSORS"                                     : "ICS"
    , "SINGLE_SHUNT"                                    : "R1"
    , "THREE_SHUNT":'${ ["STM32F302X8", "STM32F30X"
                        , "STM32L452XX","STM32L476XX"
                        , "STM32F769XX","STM32F746XX" ]?seq_contains(devClass)?then
                                                        ( "R3_1"
                                                        , "R3"  )}'

    , "THREE_SHUNT_SHARED_RESOURCES"                    : "R3_2"
    , "THREE_SHUNT_INDEPENDENT_RESOURCES"               : "R3_4"

    }
>

    <#local shortDev =
    { "STM32F0XX"        : "F0XX"
    , "STM32F2XX"        : "F2XX"
    , "STM32F302X8"      : "F30X"
    , "STM32F30X"        : "F30X"
    , "STM32F4XX"        : "F4XX"
    , "STM32F401XX"      : "F4XX"
    , "STM32HD"          : "HD2"
    , "STM32PERFORMANCE" : "LM1"
    , "STM32VALUE"       : "VL1"
    , "STM32L452XX"      : "L4XX"
    , "STM32L476XX"      : "L4XX"
    , "STM32F769XX"      : "F7XX"
    , "STM32F746XX"      : "F7XX"
    , "STM32G071XX"      : "G0XX"
    , "STM32G081XX"      : "G0XX"
    , "STM32G431RB"      : "G4XX"
    , "STM32G431CB"      : "G4XX"
    , "STM32G474QE"      : "G4XX"

    }
    >

    <#local supportDual =
    { "STM32F0XX"         : false
    , "STM32F2XX"         : true
    , "STM32F302X8"       : false
    , "STM32F30X"         : true
    , "STM32F4XX"         : true
    , "STM32F401XX"       : false
    , "STM32HD"           : true
    , "STM32PERFORMANCE"  : false
    , "STM32VALUE"        : false
    , "STM32L452XX"       : false
    , "STM32L476XX"       : false
    , "STM32F769XX"       : false
    , "STM32F746XX"       : false
    , "STM32G071XX"       : false
    , "STM32G081XX"       : false
    , "STM32G431RB"       : false
    , "STM32G431CB"       : false
    , "STM32G474QE"       : true
    } >

    <#local devMap =           {
    "STM32F0XX"        : [ "SINGLE_SHUNT"
                         , "THREE_SHUNT"
                         ],
    "STM32F2XX"        : [ "ICS_SENSORS"
                         , "SINGLE_SHUNT"
                         , "THREE_SHUNT"
                         ],
    "STM32F302X8"      : [ "SINGLE_SHUNT"
                         , "THREE_SHUNT"
                         ],
    "STM32F30X"        : [ "ICS_SENSORS"
                         , "SINGLE_SHUNT"
                         , "THREE_SHUNT"
                         , "THREE_SHUNT_SHARED_RESOURCES"
                         , "THREE_SHUNT_INDEPENDENT_RESOURCES"
                         ],
    "STM32F4XX"        : [ "ICS_SENSORS"
                         , "SINGLE_SHUNT"
                         , "THREE_SHUNT"
                         , "THREE_SHUNT_INDEPENDENT_RESOURCES"
                         ],
    "STM32F401XX"      : [
                          "SINGLE_SHUNT"
                          ,"THREE_SHUNT"
                         ],

    "STM32HD"          : [ "ICS_SENSORS"
                         , "SINGLE_SHUNT"
                         , "THREE_SHUNT"
                         ],
    "STM32PERFORMANCE" : [ "ICS_SENSORS"
                         , "SINGLE_SHUNT"
                         , "THREE_SHUNT"
                         ],
    "STM32VALUE"       : [ "SINGLE_SHUNT"
                         ],
    "STM32L452XX"      : [ "SINGLE_SHUNT"
                         , "THREE_SHUNT"
                         ],
    "STM32L476XX"      : [ "ICS_SENSORS"
                         , "SINGLE_SHUNT"
                         , "THREE_SHUNT"
                         , "THREE_SHUNT_INDEPENDENT_RESOURCES"
                         ],
    "STM32F769XX"      : [ "ICS_SENSORS"
                         , "SINGLE_SHUNT"
                         , "THREE_SHUNT"
                         , "THREE_SHUNT_INDEPENDENT_RESOURCES"
                         ],
    "STM32F746XX"      : [ "ICS_SENSORS"
                         , "SINGLE_SHUNT"
                         , "THREE_SHUNT"
                         , "THREE_SHUNT_INDEPENDENT_RESOURCES"
                         ],
    "STM32G071XX"      : [ "SINGLE_SHUNT"
                         , "THREE_SHUNT"
                         ],
    "STM32G081XX"      : [ "SINGLE_SHUNT"
                         , "THREE_SHUNT"
                         ],
    "STM32G431RB"      : [ "ICS_SENSORS"
                         , "SINGLE_SHUNT"
                         , "THREE_SHUNT"
                         , "THREE_SHUNT_INDEPENDENT_RESOURCES"
                         ],
    "STM32G431CB"      : [ "ICS_SENSORS"
                         , "SINGLE_SHUNT"
                         , "THREE_SHUNT"
                         , "THREE_SHUNT_INDEPENDENT_RESOURCES"
                         ],
    "STM32G474QE"      : [ "ICS_SENSORS"
                         , "SINGLE_SHUNT"
                         , "THREE_SHUNT"
                         , "THREE_SHUNT_INDEPENDENT_RESOURCES"
                         ],
    "NONE"             : []
    }>

    <#if devMap?keys?seq_contains(devClass) >
        <#local supportedSensing = devMap[devClass] >
        <#if supportedSensing?seq_contains( sense )
        && (motor!=2 || supportDual[devClass] )
        >
            <#local d_prefix = shortDev[devClass]?right_pad(4, '_')>
            <#if d_prefix == "F4XX">
                <#local macroName>F4_PWM_and_CurrentFdbk</#local>
            <#else>
                <#local s_prefix = shortSense[sense]?right_pad(4, '_')>
                <#local macroName>${s_prefix}_${d_prefix}_PWMCurrFdbk</#local>
            </#if>


            <#return
                { "macroName" : macroName
<#--
                , "info"      :
                        { "supportDual" : supportDual[devClass]
                        , "devClass"    : devClass
                        , "sense"       : sense
                        , "motor"       : motor
                        , "shortDevName": shortDev[devClass]
                        , "shortSense"  : shortSense[sense]     }
-->
                }>
        </#if>
    </#if>

<#-- as fallback calls a dummy doNothing macro so the caller can avoid extra check -->
    <#return {"macroName" : "oCurrSensor_doNothing"}>
</#function>

<#macro oCurrSensor_doNothing m d s>
    <@ui.comment
        [ "MOTOR:  ${m}"
        , "DEVICE: ${d}"
        , "SENSE:  ${s}"
        ]?join("\n") />
</#macro>





<#--
    TTTTTT  EEEEEE  SSSSSS  TTTTTT
      TT    EE      SS        TT
      TT    EEEE    SSSSSS    TT
      TT    EE          SS    TT
      TT    EEEEEE  SSSSSS    TT
-->
<#macro test_callAll >
    <#local devices =
    [ "STM32F0XX"
    , "STM32F2XX"
    , "STM32F302X8"
    , "STM32F30X"
    , "STM32F4XX"
    , "STM32F401XX"
    , "STM32HD"
    , "STM32PERFORMANCE"
    , "STM32VALUE"
    , "STM32L452XX"
    , "STM32F769XX"
    , "STM32F746XX"
    , "STM32G071XX"
    , "STM32G081XX"
    , "STM32G431RB"
    , "STM32G431CB"
    , "STM32G474QE"
    , "NONE" ] >

    <#local senses =
    [ "ICS_SENSORS"
    , "SINGLE_SHUNT"
    , "THREE_SHUNT"
    , "THREE_SHUNT_SHARED_RESOURCES"
    , "THREE_SHUNT_INDEPENDENT_RESOURCES" ]>

    <#list [1, 2] as m>
        <#list devices as d>
            <#list senses as s>
                <@callCurrSensorMacro supportedCurrSenseMacros(d,s,m).macroName m d s />
            </#list>
        </#list>
    </#list>
</#macro>
<#macro callCurrSensorMacro macroName motor device sense >
<#--
    <#if .vars[macroName]?? && .vars[macroName]?is_macro >
        <@.vars[macroName] motor device sense />
-->
    <#if (macroName?eval)?? && macroName?eval?is_macro >
        <@macroName?eval motor device sense />
    <#else>
        <@ui.box "ERROR: unable to find the definition for macro \"${ macroName }\""        '' '' false />
        <@ui.box "       to be called with: motor=${motor} device=${device} sense=${sense}" '' '' false />
    </#if>
</#macro>
