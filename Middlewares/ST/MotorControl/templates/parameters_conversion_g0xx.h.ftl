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
  * @file    parameters_conversion_g0xx.h
  * @author  Motor Control SDK Team, ST Microelectronics
  * @brief   This file contains the definitions needed to convert MC SDK parameters
  *          so as to target the STM32G0 Family.
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
#ifndef __PARAMETERS_CONVERSION_G0XX_H
#define __PARAMETERS_CONVERSION_G0XX_H

/************************* CPU & ADC PERIPHERAL CLOCK CONFIG ******************/
<#assign SYSCLKFreq = RCC.get("SYSCLKFreq_VALUE")?number>
<#assign TIM1Freq = RCC.get("TIM1Freq_Value")?number>
<#assign ADCFreq = RCC.get("ADCFreq_Value")?number>


#define SYSCLK_FREQ      ${SYSCLKFreq}uL
#define TIM_CLOCK_DIVIDER  1 
#define ADV_TIM_CLK_MHz    ${(TIM1Freq/(1000000))?floor}
#define ADC_CLK_MHz    ${(ADCFreq/(1000000))?floor} /* Maximum ADC Clock Frequency expressed in MHz */
#define HALL_TIM_CLK   ${SYSCLKFreq}uL
#define ADC1_2  ADC1

									  														  
/*************************  IRQ Handler Mapping  *********************/														  
 #define CURRENT_REGULATION_IRQHandler          DMA1_Channel1_IRQHandler
#define TIMx_UP_BRK_M1_IRQHandler               TIM1_BRK_UP_TRG_COM_IRQHandler
#define DMAx_R1_M1_IRQHandler                   DMA1_Channel4_5_IRQHandler

/*************************  ADC Physical characteristics  ************/			
#define ADC_TRIG_CONV_LATENCY_CYCLES 3
#define ADC_SAR_CYCLES 12.5 


#define M1_VBUS_SW_FILTER_BW_FACTOR      10u

#endif /*__PARAMETERS_CONVERSION_G0XX_H*/

/******************* (C) COPYRIGHT 2019 STMicroelectronics *****END OF FILE****/
