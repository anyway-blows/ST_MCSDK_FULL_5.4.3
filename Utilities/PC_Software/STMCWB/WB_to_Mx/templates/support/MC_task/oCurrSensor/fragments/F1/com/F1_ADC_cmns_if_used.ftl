<#import "../../../../utils/meta_parameters.ftl" as meta >
<#import "../../../../../utils.ftl" as utils>


<#function ADC_common_parameters>

        <#return
        { meta.comment_key():"ADC_Settings"
        , "DataAlign"                   : "ADC_DATAALIGN_LEFT"
        , "DiscontinuousConvMode"       : "DISABLE"
        , "EnableAnalogWatchDog"        : "false"
        }>
</#function>