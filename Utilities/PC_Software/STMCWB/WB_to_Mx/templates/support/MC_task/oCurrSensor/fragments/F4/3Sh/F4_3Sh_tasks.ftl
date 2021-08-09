<#function get_cs_sub_tasks>
    <#import "../com/F4_ocp.ftl"       as ocp >
    <#import "F4_3Sh_adc.ftl"          as adc >
    <#import "F4_3Sh_pwm_timer.ftl"    as tmr >

    <#return
    [ [ "OCP"      , ocp.get_settings ]
    , [ "ADC"      , adc.get_settings ]
    , [ "TIMER"    , tmr.get_settings ]
    ]>
</#function>

