<#if ! __PARAMETERS_CONVERSION_F0_H??>
    <#assign __PARAMETERS_CONVERSION_F0_H></#assign>

    <#import "../../names_map.ftl" as rr>
    <#assign
        ADC1 = "ADC"
        USER_IRQ_SUB_PRI = 0

        START_STOP_BTN_EXTI_IRQ =
            [ {"name": "EXTI0_1" , "line":  1}
            , {"name": "EXTI2_3" , "line":  3}
            , {"name": "EXTI4_15", "line": 15}
            ]
    in rr>

    <#import "Parameters conversion_Fx.ftl" as pcx>
    <#assign defines_pre_clk = pcx.add_defines_pre_clk()>
    <#include "../clk.ftl" >

<#--
       POST CLK F0 specific re-defines -->
    <#global ADC_CLK_MHz = 14 >
    <#global ADC_CLK_Hz  = ADC_CLK_MHz * 1000000>
    <#assign defines_post_clk = pcx.add_defines_post_clk(0.5, 259)>
</#if>