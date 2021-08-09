<#ftl>
<#if !MC??>
<#if SWIPdatas??>
<#list SWIPdatas as SWIP>
<#if SWIP.ipName == "MotorControl">
<#if SWIP.parameters??>
<#assign MC = SWIP.parameters>
<#break>
</#if>
</#if>
</#list>
</#if>
<#if !MC??>
<#stop "No MotorControl SW IP data found">
</#if>
<#if configs[0].peripheralParams.get("RCC")??>
<#assign RCC = configs[0].peripheralParams.get("RCC")>
</#if>
<#if !RCC??>
<#stop "No RCC found">
</#if>
</#if>
/**
  ******************************************************************************
  * @file    parameters_conversion_f4xx.h
  * @author  Motor Control SDK Team, ST Microelectronics
  * @brief   This file implements the Parameter conversion on the base
  *          of stdlib F4xx for the first drive
  ******************************************************************************
  * @attention
  *
  * <h2><center>&copy; Copyright (c) 2019 STMicroelectronics.
  * All rights reserved.</center></h2>
  *
  * This software component is licensed by ST under Ultimate Liberty license
  * SLA0044, the "License"; You may not use this file except in compliance with
  * the License. You may obtain a copy of the License at:
  *                             www.st.com/SLA0044
  *
  ******************************************************************************
  */
  
/* Define to prevent recursive inclusion -------------------------------------*/
#ifndef __PARAMETERS_CONVERSION_F4XX_H
#define __PARAMETERS_CONVERSION_F4XX_H

#include "pmsm_motor_parameters.h"
#include "power_stage_parameters.h"
#include "drive_parameters.h"
#include "mc_math.h"

/************************* CPU & ADC PERIPHERAL CLOCK CONFIG ******************/
<#function Fx_TIM_Div TimFreq PWMFreq>
    <#list [1,2,3,4,5] as divider>
       <#if (TimFreq/(PWMFreq *divider)) < 65535 >
            <#return divider >
        </#if>
    </#list>
    <#return 1 >
</#function>


<#assign SYSCLKFreq = RCC.get("SYSCLKFreq_VALUE")?number>
<#assign AUXTIMFreq = RCC.get("APB1TimFreq_Value")?number>
<#assign PWMTIMFreq = RCC.get("APB2TimFreq_Value")?number>
<#assign ADCFreq = RCC.get("APB2Freq_Value")?number>
<#assign TimerDivider = Fx_TIM_Div(SYSCLKFreq,(MC.PWM_FREQUENCY)?number) >
<#assign TimerDivider2 = Fx_TIM_Div(SYSCLKFreq,(MC.PWM_FREQUENCY2)?number) >

#define SYSCLK_FREQ      ${SYSCLKFreq}uL
#define TIM_CLOCK_DIVIDER  ${TimerDivider}
<#-- Timer Auxiliary must be half of the PWM timer, because it is the case for high end F4-->
#define TIMAUX_CLOCK_DIVIDER (TIM_CLOCK_DIVIDER<#if AUXTIMFreq == PWMTIMFreq>*2</#if>)
#define ADV_TIM_CLK_MHz  ${(PWMTIMFreq/(1000000))?floor}/TIM_CLOCK_DIVIDER
#define ADC_CLK_MHz     ${(ADCFreq/(4*1000000))?floor}
#define HALL_TIM_CLK    ${AUXTIMFreq}uL

 <#if MC.DUALDRIVE == true>
#define TIM_CLOCK_DIVIDER2  ${TimerDivider2} //Not used, both motors configured to same freq
<#-- Timer Auxiliary must be half of the PWM timer, because it is the case for high end F4-->
#define TIMAUX_CLOCK_DIVIDER2 (TIM_CLOCK_DIVIDER2<#if AUXTIMFreq == PWMTIMFreq>*2</#if>)
#define ADV_TIM_CLK_MHz2  ${(PWMTIMFreq/(1000000))?floor}/TIM_CLOCK_DIVIDER2
#define ADC_CLK_MHz2      ${(ADCFreq/(4*1000000))?floor}
#define HALL_TIM_CLK2     ${AUXTIMFreq}uL
 </#if>

#define ADC1_2  ADC1

/*************************  IRQ Handler Mapping  *********************/
<#if MC.PWM_TIMER_SELECTION == 'PWM_TIM1' || MC.PWM_TIMER_SELECTION == 'TIM1'>
#define TIMx_UP_M1_IRQHandler TIM1_UP_TIM10_IRQHandler
#define DMAx_R1_M1_IRQHandler DMA2_Stream4_IRQHandler
#define DMAx_R1_M1_Stream     DMA2_Stream4
#define TIMx_BRK_M1_IRQHandler TIM1_BRK_TIM9_IRQHandler
</#if>
<#if MC.PWM_TIMER_SELECTION == 'PWM_TIM8' || MC.PWM_TIMER_SELECTION == 'TIM8'>
#define TIMx_UP_M1_IRQHandler TIM8_UP_TIM13_IRQHandler
#define DMAx_R1_M1_IRQHandler DMA2_Stream7_IRQHandler
#define DMAx_R1_M1_Stream     DMA2_Stream7
#define TIMx_BRK_M1_IRQHandler  TIM8_BRK_TIM12_IRQHandler
</#if>
<#if MC.DUALDRIVE == true>
<#if MC.PWM_TIMER_SELECTION2 == 'PWM_TIM1' || MC.PWM_TIMER_SELECTION2 == 'TIM1'>
#define TIMx_UP_M2_IRQHandler TIM1_UP_TIM10_IRQHandler
#define DMAx_R1_M2_IRQHandler DMA2_Stream4_IRQHandler
#define DMAx_R1_M2_Stream     DMA2_Stream4
#define TIMx_BRK_M2_IRQHandler TIM1_BRK_TIM9_IRQHandler
</#if>
<#if MC.PWM_TIMER_SELECTION2 == 'PWM_TIM8' || MC.PWM_TIMER_SELECTION2 == 'TIM8'>
#define TIMx_UP_M2_IRQHandler TIM8_UP_TIM13_IRQHandler
#define DMAx_R1_M2_IRQHandler DMA2_Stream7_IRQHandler
#define DMAx_R1_M2_Stream     DMA2_Stream7
#define TIMx_BRK_M2_IRQHandler  TIM8_BRK_TIM12_IRQHandler
</#if>
</#if>

/**********  AUXILIARY TIMER (SINGLE SHUNT) *************/
/* Defined here for legacy purposes */
#define R1_PWM_AUX_TIM                  TIM4

/*************************  ADC Physical characteristics  ************/			
#define ADC_TRIG_CONV_LATENCY_CYCLES 3
#define ADC_SAR_CYCLES 12

#define M1_VBUS_SW_FILTER_BW_FACTOR      10u
<#if MC.DUALDRIVE == true>
#define M2_VBUS_SW_FILTER_BW_FACTOR      6u
</#if>

#endif /*__PARAMETERS_CONVERSION_F4XX_H*/

/******************* (C) COPYRIGHT 2019 STMicroelectronics *****END OF FILE****/
