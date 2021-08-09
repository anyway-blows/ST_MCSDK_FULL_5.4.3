<#import "../../../../utils/meta_parameters.ftl" as meta >

<#function ADC_common_parameters>
    <#return
        { meta.comment_key():"ADC_Settings"
        , "ClockPrescaler"              : "ADC_CLOCK_SYNC_PCLK_DIV4"
        , "Resolution"                  : "ADC_RESOLUTION_12B"
        , "DataAlign"                   : "ADC_DATAALIGN_LEFT"
        , "ContinuousConvMode"          : "DISABLE"
        , "DiscontinuousConvMode"       : "DISABLE"
        , "DMAContinuousRequests"       : "DISABLE"
        , "EOCSelection"                : "ADC_EOC_SINGLE_CONV"
        , "EnableAnalogWatchDog"        : "false"
        }>
</#function>

<#--
From file NUCLEO-F446RE-IHM07M1-BULLRUNNING-1S.ioc - Daniel BERGANTIN
Sent: January 29, 2018
Subject: F4 1 shunt and 3 shunts IOC

ADC.ClockPrescaler=ADC_CLOCK_SYNC_PCLK_DIV4
ADC1.Resolution=ADC_RESOLUTION_12B
ADC.DataAlign=ADC_DATAALIGN_LEFT
ADC.ContinuousConvMode=DISABLE
ADC.DiscontinuousConvMode=DISABLE
ADC.DMAContinuousRequests=DISABLE
ADC.EOCSelection=ADC_EOC_SEQ_CONV
ADC.EnableAnalogWatchDog=false
-->

