 <#include "../../utils.ftl">

<#if ! __PARAMETERS_CONVERSION_F4XX_H??>
    <#assign __PARAMETERS_CONVERSION_F4XX_H></#assign>

    <#import "../../names_map.ftl" as rr>
    <#assign
        VBUS_ADC_SAMPLING_CYCLE = {"value": 0}
        TEMP_ADC_SAMPLING_CYCLE = {"value": 0}
    in rr>

    <#assign
        USART4 = "UART4"
        USART5 = "UART5"
        START_STOP_BTN_EXTI_IRQ =
            [ {"name": "EXTI0"     , "line":  0}
            , {"name": "EXTI1"     , "line":  1}
            , {"name": "EXTI2"     , "line":  2}
            , {"name": "EXTI3"     , "line":  3}
            , {"name": "EXTI4"     , "line":  4}
            , {"name": "EXTI9_5"   , "line":  9}
            , {"name": "EXTI15_10" , "line": 15}
            ]
    in rr >

    <#assign IRQ_TIM_NAME = { "TIM6" : "TIM6_DAC" } in rr >

    <#import "../../../support/FreeRTOS/Has_RTOS.ftl" as rtos >
    <#if rtos.has_rtos()>
        <#assign SET_IRQ_ADC = (WB_RTOS_USE_IRQ!false)?then([true, 7, 0, true, true , false,  true, false]
                                                           ,[true, 2, 0, true, false, false, false, true])

                 SET_IRQ_TIM = (WB_RTOS_USE_IRQ!false)?then([true, 5, 0, true, true, false, true, true]
                                                           ,[true, 0, 0, true, true, false, false,true])
        ,
             SET_IRQ_TIM_BRK = (WB_RTOS_USE_IRQ!false)?then([true, 9, 0, true,  true, false, true,  true]
                                                           ,[true, 4, 0, true, true, false, false, true])
        ,
          SET_IRQ_START_STOP = (WB_RTOS_USE_IRQ!false)?then([true, 8, 0, true, false, false, true,  true]
                                                           ,[true, 3, 0, true, false, false, false, true])
        ,
        SET_IRQ_POS_CON_ENCODER_Z = (WB_RTOS_USE_IRQ!false)?then([true, 8, 0, true, false, false, true,  true]
                                                                ,[true, 3, 0, true, false, false, false, true])

        in rr>
    </#if>



    <#import "Parameters conversion_Fx.ftl" as pcx>

    <#assign defines_pre_clk = pcx.add_defines_pre_clk()>
    <#-- PRE CLK F4 specific define -->
    <#global TIM_CLOCK_DIVIDER = 2 >
    <#include "../clk.ftl" >
    <#--
        POST CLK F4 specific re-defines -->
    <#global ADC_CLK_MHz = (CPU_CLK_MHz == 180)?then(22, 21) >
    <#global ADC_CLK_Hz  = ADC_CLK_MHz * 1000000>
    <#assign defines_post_clk = pcx.add_defines_post_clk(3.5, 0)>
</#if>
