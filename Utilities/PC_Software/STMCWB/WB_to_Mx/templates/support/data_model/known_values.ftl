<#if ! __known_values_ftl?? >
    <#global __known_values_ftl=1 ><#--

    Values previously defined in Definition.h -->
    <#global _known_values =
        { "TRUE"              : true
        , "FALSE"             : false

        , "ENABLE"            : true
        , "DISABLE"           : false

        , "TURN_ON"           : true
        , "TURN_OFF"          : false

        , "INRUSH_ACTIVE"     : true
        , "INRUSH_INACTIVE"   : false

        , "TURN_OFF_PWM"      : 0
        , "TURN_ON_R_BRAKE"   : 1
        , "TURN_ON_LOW_SIDES" : 2

        , "SQRT_2"            :  1.4142
        , "SQRT_3"            :  1.732

        , "DEGREES_120"       :  0
        , "DEGREES_60"        :  1

        , "VFQFPN36"          :  1
        , "VFQFPN48"          :  2
        , "LQFP48"            :  3
        , "LQFP64"            :  4
        , "LQFP100"           :  5
        , "LQFP144"           :  6
        , "WLCSP64"           :  7
        , "LFBGA100"          :  8
        , "LFBGA144"          :  9
        , "BGA100"            : 10
        , "BGA64"             : 11
        , "TFBGA64"           : 12

        , "LOWEST_FREQ"       :  1
        , "HIGHEST_FREQ"      :  2

<#--
        , "TIM_ExtTRGPolarity_Inverted"    : "TIM_TRIGGERPOLARITY_INVERTED"
        , "TIM_ExtTRGPolarity_NonInverted" : "TIM_TRIGGERPOLARITY_NONINVERTED"
-->

        }><#--
        , "HALL_TIM2"         :  2
        , "HALL_TIM3"         :  3
        , "HALL_TIM4"         :  4
        , "HALL_TIM5"         :  5

        , "ENC_TIM2"          :  2
        , "ENC_TIM3"          :  3
        , "ENC_TIM4"          :  4
        , "ENC_TIM5"          :  5

 --><#global NaN = "NaN"?number >
</#if>
