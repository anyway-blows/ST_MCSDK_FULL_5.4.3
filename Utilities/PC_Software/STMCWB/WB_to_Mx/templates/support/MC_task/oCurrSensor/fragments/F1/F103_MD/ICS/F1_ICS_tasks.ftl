<#function get_cs_sub_tasks>
    <#import "../../com/F1_ocp.ftl"                as ocp >
    <#import "../../com/ADC_3Sh_ICS_settings.ftl"  as adc >

    <#import "../../F103_MD/3Sh/F1_3Sh_dma.ftl"          as dma >
    <#import "../../F103_HD/ICS/F1_ICS_pwm_timer.ftl"    as tmr >

    <#return
    [ [ "OCP"      , ocp.get_settings ]
    , [ "ADC"      , adc.get_settings ]
    , [ "TIMER"    , tmr.get_settings ]
    , [ "DMA"      , dma.get_settings ]
    ]>
</#function>
