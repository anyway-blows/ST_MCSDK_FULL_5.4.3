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
<#-- Condition for Line STM32F1xx High Density -->
<#assign CondLine_STM32F1_HD = (McuName?? && McuName?matches("STM32F103.(C|D|E|F|G).*"))>

<#assign CondMcu_STM32F103xx = (McuName?? && McuName?matches("STM32F103.*"))>

/**
  ******************************************************************************
  * @file    parameters_conversion_f10x.h
  * @author  Motor Control SDK Team, ST Microelectronics
  * @brief   This file contains the definitions needed to convert MC SDK parameters
  *          so as to target the STM32F1 Family.
  *
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
#ifndef __PARAMETERS_CONVERSION_F10X_H
#define __PARAMETERS_CONVERSION_F10X_H

#include "pmsm_motor_parameters.h"
#include "drive_parameters.h"
#include "power_stage_parameters.h"
<#if MC.PFC_ENABLED == true>
#include "pfc_parameters.h"
</#if>
#include "mc_math.h"

<#function Fx_ADC_Freq SysFreq MaxADCFreq>
    <#list [2, 4, 6, 8] as divider>
       <#if (SysFreq/(divider*1000000)) <= MaxADCFreq >
            <#return  (SysFreq/(divider*1000000)) >
        </#if>
    </#list>
    <#return MaxADCFreq >
</#function>

<#assign SYSCLKFreq = RCC.get("SYSCLKFreq_VALUE")?number>

#define SYSCLK_FREQ    ${SYSCLKFreq}uL
#define TIM_CLOCK_DIVIDER  1 
#define ADV_TIM_CLK_MHz    ${(SYSCLKFreq/(1000000))?floor}
#define ADC_CLK_MHz        ${Fx_ADC_Freq(SYSCLKFreq,14)}
#define HALL_TIM_CLK       ${SYSCLKFreq}uL
<#if MC.DUALDRIVE == true>
#define ADV_TIM_CLK_MHz2    ${(SYSCLKFreq/(1000000))?floor}
#define ADC_CLK_MHz2        ${Fx_ADC_Freq(SYSCLKFreq,14)}
#define HALL_TIM_CLK2      ${SYSCLKFreq}uL
</#if>

#define ADC1_2 ADC1

/*************************  IRQ Handler Mapping  *********************/

<#if MC.PWM_TIMER_SELECTION == 'PWM_TIM1' || MC.PWM_TIMER_SELECTION == 'TIM1'>
#define TIMx_UP_M1_IRQHandler TIM1_UP_IRQHandler
#define DMAx_R1_M1_IRQHandler DMA1_Channel4_IRQHandler
#define TIMx_BRK_M1_IRQHandler TIM1_BRK_IRQHandler
<#elseif MC.PWM_TIMER_SELECTION == 'PWM_TIM8' || MC.PWM_TIMER_SELECTION == 'TIM8'>
#define TIMx_UP_M1_IRQHandler TIM8_UP_IRQHandler
#define DMAx_R1_M1_IRQHandler DMA2_Channel2_IRQHandler
#define TIMx_BRK_M1_IRQHandler TIM8_BRK_TIM12_IRQHandler
</#if>

<#if MC.DUALDRIVE == true>
<#if MC.PWM_TIMER_SELECTION2 == 'PWM_TIM1' || MC.PWM_TIMER_SELECTION2 == 'TIM1'>
#define TIMx_UP_M2_IRQHandler TIM1_UP_IRQHandler
#define DMAx_R1_M2_IRQHandler DMA1_Channel4_IRQHandler
#define TIMx_BRK_M2_IRQHandler TIM1_BRK_TIM9_IRQHandler
</#if>
<#if MC.PWM_TIMER_SELECTION2 == 'PWM_TIM8' || MC.PWM_TIMER_SELECTION2 == 'TIM8'>
#define TIMx_UP_M2_IRQHandler TIM8_UP_IRQHandler
#define DMAx_R1_M2_IRQHandler DMA2_Channel2_IRQHandler
#define TIMx_BRK_M2_IRQHandler  TIM8_BRK_TIM12_IRQHandler
</#if>
</#if>

<#if MC.PFC_ENABLED == true>
#define PFC_TIM_IRQHandler TIM3_IRQHandler
</#if>


/**********  AUXILIARY TIMER (SINGLE SHUNT) *************/
<#if MC.STM32F103x_LD>
#define R1_PWM_AUX_TIM                  TIM3
<#else>
#define R1_PWM_AUX_TIM                  TIM4
</#if>

/*******************  ADC Physical characteristics  ************/
#define ADC_TRIG_CONV_LATENCY_CYCLES 3
#define ADC_SAR_CYCLES 13

#define M1_VBUS_SW_FILTER_BW_FACTOR      10u
<#if MC.DUALDRIVE == true>
#define M2_VBUS_SW_FILTER_BW_FACTOR     10u
</#if>

#endif /*__PARAMETERS_CONVERSION_F10X_H*/

/******************* (C) COPYRIGHT 2019 STMicroelectronics *****END OF FILE****/
