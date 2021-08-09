<#import "../../../../utils/meta_parameters.ftl" as meta >
<#import "../../../../../utils.ftl" as utils >

<#function ADC_common_parameters>
    <#local cycle = (CURR_SAMPLING_TIME > 1)?then("CYCLES", "CYCLE") >

    <#return
        { meta.comment_key():"ADC_Settings"
        , "ClockPrescaler"        : "ADC_CLOCK_ASYNC_DIV1"
        , "Resolution"            : "ADC_RESOLUTION_12B"
        , "DataAlign"             : "ADC_DATAALIGN_LEFT"
        , "ScanConvMode"          : "ADC_SCAN_DIRECTION_FORWARD"
        , "ContinuousConvMode"    : "DISABLE"
        , "DiscontinuousConvMode" : "DISABLE"
        , "DMAContinuousRequests" : "ENABLE"
        , "EOCSelection"          : "ADC_EOC_SINGLE_CONV"
        , "Overrun"               : "ADC_OVR_DATA_PRESERVED"

        , "LowPowerAutoWait"      : "DISABLE"
        , "LowPowerAutoPowerOff"  : "DISABLE"

        , meta.comment_key():"ADC_Regular_ConversionMode"
        , "SamplingTime"          : "ADC_SAMPLETIME_${ CURR_SAMPLING_TIME }${ cycle }_5"
        , "ExternalTrigConv"      : "ADC_EXTERNALTRIGCONV_T1_TRGO"
        , "ExternalTrigConvEdge"  : "ADC_EXTERNALTRIGCONVEDGE_RISING"

        , meta.comment_key():"WatchDog"
        , "EnableAnalogWatchDog"  : "false"
        }>
</#function>

