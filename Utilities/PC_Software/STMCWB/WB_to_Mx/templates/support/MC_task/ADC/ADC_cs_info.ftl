<#import "../utils/meta_parameters.ftl" as meta >
<#import "../../utils.ftl" as utils >
<#import "../../fp.ftl" as fp >

<#function adc_info motor phase>
    <#local src = (phase == "x")?then(
        [ "PHASE_CURRENTS_ADC"
        , "PHASE_CURRENTS_CHANNEL"
        , "PHASE_CURRENTS_GPIO_PORT"
        , "PHASE_CURRENTS_GPIO_PIN"

        , "PHASE_CURRENTS"
        , "CURR_SAMPLING_TIME"
        ]
    ,
        [ "PHASE_${phase}_CURR_ADC"
        , "PHASE_${phase}_CURR_CHANNEL"
        , "PHASE_${phase}_GPIO_PORT"
        , "PHASE_${phase}_GPIO_PIN"

        , "PHASE_${phase}_CURR"
        , "CURR_SAMPLING_TIME"
        ]
    )>

    <#local
        ADC  = utils.v( src[0], motor)
        CH   = utils.v( src[1], motor)
        PORT = utils.v( src[2], motor)
        PIN  = utils.v( src[3], motor)

        what = src[4]
        samplingTime = utils.v( src[5], motor)
        >

    <#local port       = utils._last_char(PORT) >
    <#local pin        = utils._last_word(PIN)  >
    <#local ch_idx     = utils._last_word(CH) >
    <#local isChShared = ADC?contains('_') >

    <#return
    { "src" :
        { "ADC"       : ADC
        , "CHANNEL"   : CH
        , "GPIO_PORT" : PORT
        , "GPIO_PIN"  : PIN
        }
    , "motor": motor
    , "what" : what
    , "channel"   :
        { "idx"      : ch_idx
        , "isShared" : isChShared
        , "adcs"     : fp.map( utils._last_char, ADC?split("_") )
        }
    , "gpio" :
        "P${port}${pin}"
            ?replace("\\#",   "#")
            ?replace(  "#", "\\#")
            ?replace("\\ ",   " ")

    , "samplingTime" : samplingTime
    , "phase"        : phase
    }>
</#function>


<#function adc_info_internal_opamp motor phase>
<#if phase == "V">
    <#return adc_info (motor, phase)>

<#else>
    <#return
    { "src" :
    { "ADC"       : "ADC2"
    , "CHANNEL"   : "VOPAMP3_ADC2"
    }
    , "motor": motor
    , "what" : "PHASE_W_CURR_INTERNAL_OPAMP"
    , "channel"   :
    { "idx"      : "VOPAMP3_ADC2"
    , "isShared" : false
    , "adcs"     : "ADC2"
    }

    , "samplingTime" : utils.v( "CURR_SAMPLING_TIME", motor)
    , "phase"        : "W"
    }>
</#if>
</#function>




