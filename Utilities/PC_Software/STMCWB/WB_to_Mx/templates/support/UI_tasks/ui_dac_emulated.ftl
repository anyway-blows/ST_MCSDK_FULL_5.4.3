<#import "../MC_task/utils/meta_parameters.ftl" as meta >

<#function dac_emulated_settings timer>
    <#if timer!="TIM14">
        <#return
        { "Prescaler"               : "0"
        , "CounterMode"             : "TIM_COUNTERMODE_UP"
        , "Period"                  : "0x800"
        , "ClockDivision"           : "TIM_CLOCKDIVISION_DIV1"
        , "AutoReloadPreload"       : "TIM_AUTORELOAD_PRELOAD_DISABLE"
        , "TIM_MasterSlaveMode"     : "TIM_MASTERSLAVEMODE_DISABLE"
        , "TIM_MasterOutputTrigger" : "TIM_TRGO_RESET"
        }>
    <#else>
        <#return
        { "Prescaler"               : "0"
        , "CounterMode"             : "TIM_COUNTERMODE_UP"
        , "Period"                  : "0x800"
        , "ClockDivision"           : "TIM_CLOCKDIVISION_DIV1"
        , "AutoReloadPreload"       : "TIM_AUTORELOAD_PRELOAD_DISABLE"

        , "Channel"                 : "TIM_CHANNEL_1"
        , "Pulse"                   : "0x400"
        }>
    </#if>

</#function>