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
  * @file    parameters_conversion_f7xx.h
  * @author  Motor Control SDK Team, ST Microelectronics
  * @brief   This file implements the Parameter conversion on the base
  *          of stdlib F7xx for the first drive
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
#ifndef __PARAMETERS_CONVERSION_F7XX_H
#define __PARAMETERS_CONVERSION_F7XX_H

#include "pmsm_motor_parameters.h"
#include "power_stage_parameters.h"
#include "drive_parameters.h"
#include "mc_math.h"

/************************* CPU & ADC PERIPHERAL CLOCK CONFIG ******************/
<#assign SYSCLKFreq = RCC.get("SYSCLKFreq_VALUE")?number>
<#-- For futur use 
<#assign ADC12outputFreq ${RCC.get("ADC12outputFreq_Value")}>
<#assign ADC34outputFreq ${RCC.get("ADC34outputFreq_Value")}>
-->
#define SYSCLK_FREQ      ${SYSCLKFreq}uL
#define TIM_CLOCK_DIVIDER  2 
#define ADV_TIM_CLK_MHz  ${(SYSCLKFreq/(2*1000000))?floor}
#define ADC_CLK_MHz     ${(SYSCLKFreq/(2*4*1000000))?floor}
#define HALL_TIM_CLK    ${SYSCLKFreq/2}uL

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

/*************************  ADC Physical characteristics  ************/	
#define ADC_TRIG_CONV_LATENCY_CYCLES 3
#define ADC_SAR_CYCLES 12

#define M1_VBUS_SW_FILTER_BW_FACTOR      10u

#endif /*__PARAMETERS_CONVERSION_F7XX_H*/

/******************* (C) COPYRIGHT 2019 STMicroelectronics *****END OF FILE****/
