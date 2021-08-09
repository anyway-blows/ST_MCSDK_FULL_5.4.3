<#function get_cs_sub_tasks >
    <#import "../com/F4_ocp.ftl"        as ocp >
    <#import "F4_1Sh_adc.ftl"           as adc >
    <#import "F4_1Sh_pwm_timer.ftl"     as tmr >
    <#import "F4_1Sh_aux_pwm_timer.ftl" as aux >
    <#import "F4_1Sh_dma.ftl"           as dma >

    <#return
    [ [ "OCP"      , ocp.get_settings ]
    , [ "ADC"      , adc.get_settings ]
    , [ "TIMER"    , tmr.get_settings ]

    , [ "AUX TIMER", aux.get_settings ]
    , [ "DMA"      , dma.get_settings ]
    ]>
</#function>
