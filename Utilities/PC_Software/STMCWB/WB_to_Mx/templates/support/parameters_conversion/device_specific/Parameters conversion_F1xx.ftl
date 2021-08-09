<#include "../../utils.ftl">

<#if ! __PARAMETERS_CONVERSION_F1XX_H??>
    <#assign __PARAMETERS_CONVERSION_F1XX_H></#assign>


    <#import "../../names_map.ftl" as rr>

    <#assign
        VBUS_ADC_SAMPLING_CYCLE = {"value": 5}
        TEMP_ADC_SAMPLING_CYCLE = {"value": 5}

        USART4 = "UART4"
        USART5 = "UART5"
        UART_RX_MODE = "INPUT"

        START_STOP_BTN_EXTI_IRQ =
            [ { "name": "EXTI0"    , "line":  0 }
            , { "name": "EXTI1"    , "line":  1 }
            , { "name": "EXTI2"    , "line":  2 }
            , { "name": "EXTI3"    , "line":  3 }
            , { "name": "EXTI4"    , "line":  4 }
            , { "name": "EXTI9_5"  , "line":  9 }
            , { "name": "EXTI15_10", "line": 15 }
            ]
    in rr>

   <#-- <#assign IRQ_TIM_NAME = { "TIM2" : "TIM2"
                            , "TIM3" : "TIM3"
                            , "TIM4" : "TIM4"
                            , "TIM5" : "TIM5"
                            , "TIM6" : "TIM6"
                            } in rr >-->


    <#import "../../../support/FreeRTOS/Has_RTOS.ftl" as rtos >
    <#if rtos.has_rtos()>
        <#assign SET_IRQ_ADC = (WB_RTOS_USE_IRQ!false)?then([true, 7, 0, true, true,  false,  true, false]
                                                           ,[true, 2, 0, true, true,  false, false, true])
        ,

                 SET_IRQ_TIM = (WB_RTOS_USE_IRQ!false)?then([true, 5, 0, true, true, false, true, true]
                                                           ,[true, 0, 0, true, true, false, false,true])
        ,
             SET_IRQ_TIM_BRK = (WB_RTOS_USE_IRQ!false)?then([true, 9, 0, true, true, false, true,  true]
                                                           ,[true, 4, 0, true, true, false, false, true])
        ,
          SET_IRQ_START_STOP = (WB_RTOS_USE_IRQ!false)?then([true, 8, 0, true, false, false, true,  true]
                                                           ,[true, 3, 0, true, false, false, false, true])
        ,
            SET_IRQ_PFCTIMER = (WB_RTOS_USE_IRQ!false)?then([true, 6, 0, true, false, false, true,  true]
                                                           ,[true, 1, 0, true, false, false, false, true])
        ,
          SET_IRQ_POS_CON_ENCODER_Z = (WB_RTOS_USE_IRQ!false)?then([true, 8, 0, true, false, false, true,  true]
                                                                  ,[true, 3, 0, true, false, false, false, true])

        in rr>
    </#if>


    <#assign ADC_SAMPLETIME_SUFFIX= "_5" in rr>

    <#import "Parameters conversion_Fx.ftl" as pcx>
    <#assign defines_pre_clk = pcx.add_defines_pre_clk()>
    <#include "../clk.ftl" >

        <#if CPU_CLK_MHz == 56 >
                <#global ADC_CLK_MHz = 14 >
        <#else>
                <#global ADC_CLK_MHz = 12 >
        </#if>

        <#global ADC_CLK_Hz  = ADC_CLK_MHz * 1000000>
        <#assign defines_post_clk = pcx.add_defines_post_clk(3.5, 0)>



<#--
    <#global ADC_CLK_MHz = 12 >

    <#global ADC_CLK_Hz  = ADC_CLK_MHz * 1000000>
    <#assign defines_post_clk = pcx.add_defines_post_clk(3.5, 0)>
-->
<#--<#assign CORR_FACTOR_SAMPLING_TIME = 0.5>-->
<#--<#assign TRIG_CONV_LATENCY_NS = 259>-->
</#if>
