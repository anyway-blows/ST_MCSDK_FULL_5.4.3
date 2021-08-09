<#import "../../../../utils/meta_parameters.ftl" as meta >
<#import "../../../../../utils.ftl" as utils >

<#function ADC_common_parameters>
    <#local cycle = (CURR_SAMPLING_TIME > 1)?then("CYCLES", "CYCLE")>

    <#local sense = utils.current_sensing_topology(1) >
   <#if utils.current_sensing_topology(1) == "SINGLE_SHUNT" >
           <#local value            = "ENABLE"
                   overrun          = "PRESERVED"
                   externalTrigConv = "TRGO2"
                   eoc_Selection    = "SINGLE_CONV"
           >
       <#else>
           <#local value            = "DISABLE"
                   overrun          = "OVERWRITTEN"
                   externalTrigConv = "CC4"
                   eoc_Selection    = "SEQ_CONV"
           >
   </#if>

        <#return
        { meta.comment_key():"ADC_Settings"
        , "ClockPrescaler"        : "ADC_CLOCK_ASYNC_DIV${ ADC_CLOCK_WB_DIV }"
        , "Resolution"            : "ADC_RESOLUTION_12B"
        , "DataAlign"             : "ADC_DATAALIGN_LEFT"
        , "NbrOfConversionFlag"   : "1"
        , "Sequencer"             : "NOT_FULLY_CONFIGURABLE"
        , "ScanConvMode"          : "ADC_SCAN_SEQ_FIXED"
        , "ContinuousConvMode"    : "DISABLE"
        , "DiscontinuousConvMode" : "${value}"
        , "DMAContinuousRequests" : "${value}"
        , "EOCSelection"          : "ADC_EOC_${eoc_Selection}"
        , "Overrun"               : "ADC_OVR_DATA_${overrun}"
        , "LowPowerAutoWait"      : "DISABLE"
        , "LowPowerAutoPowerOff"  : "DISABLE"
        , "OversamplingMode"      : "DISABLE"





        , meta.comment_key():"ADC_Regular_ConversionMode"
        , "SamplingTimeCommon1"   : "ADC_SAMPLETIME_${ CURR_SAMPLING_TIME }${ cycle }_5"
        , "SamplingTimeCommon2"   : "ADC_SAMPLETIME_${ CURR_SAMPLING_TIME }${ cycle }_5"
        , "ExternalTrigConv"      : "ADC_EXTERNALTRIG_T1_${externalTrigConv}"
        , "ExternalTrigConvEdge"  : "ADC_EXTERNALTRIGCONVEDGE_RISING"
        , "TriggerFrequencyMode"  : "ADC_TRIGGER_FREQ_HIGH"

        , meta.comment_key():"WatchDog"
        , "EnableAnalogWatchDog1"  : "false"
        }>
</#function>

