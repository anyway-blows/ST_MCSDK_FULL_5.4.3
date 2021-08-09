<#ftl strip_whitespace = true>
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
	<#if MC??>
	<#else>
	<#stop "No MotorControl SW IP data found">
	</#if>
</#if>
<#-- Condition for STM32G4 Family -->
<#assign CondFamily_STM32G4 = (FamilyName?? && FamilyName == "STM32G4")>
<#if CondFamily_STM32G4>
<#assign ADC_BEMF_CH1 = "LL_ADC_CHANNEL_6">
<#assign ADC_BEMF_CH2 = "LL_ADC_CHANNEL_9">
<#assign ADC_BEMF_CH3 = "LL_ADC_CHANNEL_7">
<#assign ADC_SPEED = "LL_ADC_CHANNEL_8">
<#assign ADC_CURRENT = "LL_ADC_CHANNEL_14">
<#assign ADC_VBUS = "LL_ADC_CHANNEL_1">
<#assign ADC_TEMP = "LL_ADC_CHANNEL_5">
<#assign ADC_VREF = "LL_ADC_CHANNEL_VREFINT">
<#assign ADC_SAMP_TIME="LL_ADC_SAMPLINGTIME_12CYCLES_5">
<#assign ADC_SAMP_TIME_VREF="LL_ADC_SAMPLINGTIME_92CYCLES_5">
</#if>
<#-- Condition for STM32F401 Series -->
<#assign CondMcu_STM32F401xxx = (McuName?? && McuName?matches("STM32F401.*"))>
<#if CondMcu_STM32F401xxx>
<#assign ADC_BEMF_CH1 = "LL_ADC_CHANNEL_10">
<#assign ADC_BEMF_CH2 = "LL_ADC_CHANNEL_13">
<#assign ADC_BEMF_CH3 = "LL_ADC_CHANNEL_11">
<#assign ADC_SPEED = "LL_ADC_CHANNEL_12">
<#assign ADC_CURRENT = "LL_ADC_CHANNEL_9">
<#assign ADC_VBUS = "LL_ADC_CHANNEL_15">
<#assign ADC_TEMP = "LL_ADC_CHANNEL_14">
<#assign ADC_VREF = "LL_ADC_CHANNEL_17">
<#assign ADC_SAMP_TIME="LL_ADC_SAMPLINGTIME_13CYCLES_5">
<#assign ADC_SAMP_TIME_VREF="LL_ADC_SAMPLINGTIME_144CYCLES_5">
</#if>
/**
 ******************************************************************************
 * @file    ihm16m1_conf.h
 * @author  IPC Rennes & Motor Control SDK, ST Microelectronics
 * @brief   IHM16M1 configuration file.
 ******************************************************************************
 * @attention
 *
 * <h2><center>&copy; COPYRIGHT(c) 2019 STMicroelectronics</center></h2>
 *
 * Redistribution and use in source and binary forms, with or without modification,
 * are permitted provided that the following conditions are met:
 *   1. Redistributions of source code must retain the above copyright notice,
 *      this list of conditions and the following disclaimer.
 *   2. Redistributions in binary form must reproduce the above copyright notice,
 *      this list of conditions and the following disclaimer in the documentation
 *      and/or other materials provided with the distribution.
 *   3. Neither the name of STMicroelectronics nor the names of its contributors
 *      may be used to endorse or promote products derived from this software
 *      without specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
 * AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
 * IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
 * DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE
 * FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
 * DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
 * SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
 * CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
 * OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
 * OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 *
 ******************************************************************************
 */

/* Define to prevent recursive inclusion -------------------------------------*/
#ifndef __IHM16M1_CONF_H__
#define __IHM16M1_CONF_H__

#ifdef __cplusplus
extern "C" {
#endif

/* Includes ------------------------------------------------------------------*/
<#if CondFamily_STM32G4>
#include "stm32g4xx_hal.h"
<#elseif CondMcu_STM32F401xxx>
#include "stm32f4xx_hal.h"
<#else>
#include "stm32yyxx_hal.h"
#include "nucleo_xyyyzz_bus.h"
#include "nucleo_xyyyzz_errno.h"
</#if>
#include "g431rb_bus.h"
#include "g431rb_errno.h"

#define DEGREE_TO_KELVIN(__DEGREE__)  (__DEGREE__ + 273)
  
#define IHM16M1_ADC_BEMF_CH1    ${ADC_BEMF_CH1}  /*BEMF1*/
#define IHM16M1_ADC_BEMF_CH2    ${ADC_BEMF_CH2}  /*BEMF2*/
#define IHM16M1_ADC_BEMF_CH3    ${ADC_BEMF_CH3}  /*BEMF3*/
#define IHM16M1_ADC_SPEED       ${ADC_SPEED}     /*POTENTIOMETER FOR SPEED*/
#define IHM16M1_ADC_CURRENT     ${ADC_CURRENT}   /*CURRENT*/
#define IHM16M1_ADC_VBUS        ${ADC_VBUS}      /*VBUS*/
#define IHM16M1_ADC_TEMP        ${ADC_TEMP}      /*TEMPERATURE*/
#define IHM16M1_ADC_VREF        ${ADC_VREF}      /*VOLTAGE REFERENCE*/

#define IHM16M1_ADC_BEMF_ST     ${ADC_SAMP_TIME}   /*ADC Sampling Time for BEMF measurements*/
#define IHM16M1_ADC_SPEED_ST    ${ADC_SAMP_TIME}   /*ADC Sampling Time for SPEED measurements*/
#define IHM16M1_ADC_CURRENT_ST  ${ADC_SAMP_TIME}   /*ADC Sampling Time for CURRENT measurements*/
#define IHM16M1_ADC_VBUS_ST     ${ADC_SAMP_TIME}   /*ADC Sampling Time for VBUS measurements*/
#define IHM16M1_ADC_TEMP_ST     ${ADC_SAMP_TIME}   /*ADC Sampling Time for TEMPERATURE measurements*/
#define IHM16M1_ADC_VREF_ST     ${ADC_SAMP_TIME_VREF}  /*ADC Sampling Time for VOLTAGE REFERENCE measurements*/
  
#define IHM16M1_NTC_TEMP_1_C     ((int8_t) 25)
#define IHM16M1_NTC_TEMP_2_C     ((int8_t) 50)    
#define IHM16M1_NTC_R_1_OHMS     ((uint16_t) 47000)
#define IHM16M1_NTC_R_2_OHMS     ((uint16_t) 16432)
#define IHM16M1_DIV_R_OHMS       ((uint16_t) 10000)
#define IHM16M1_DIV_RATIO_1      ((uint16_t) (((uint32_t)(1000 * IHM16M1_DIV_R_OHMS)) / ((uint32_t)(IHM16M1_DIV_R_OHMS + IHM16M1_NTC_R_1_OHMS))))
#define IHM16M1_DIV_RATIO_2      ((uint16_t) (((uint32_t)(1000 * IHM16M1_DIV_R_OHMS)) / ((uint32_t)(IHM16M1_DIV_R_OHMS + IHM16M1_NTC_R_2_OHMS))))
#define IHM16M1_ADC_RESOLUTION   ((uint8_t) 12)
#define IHM16M1_ADC_FULL_SCALE   ((uint16_t) ((1<<IHM16M1_ADC_RESOLUTION)-1))
#define IHM16M1_TS_CAL_1         ((uint16_t) (((uint32_t) (IHM16M1_ADC_FULL_SCALE * IHM16M1_DIV_RATIO_1))/1000))
#define IHM16M1_TS_CAL_2         ((uint16_t) (((uint32_t) (IHM16M1_ADC_FULL_SCALE * IHM16M1_DIV_RATIO_2))/1000))

#define IHM16M1_Init            BSP_GPIO_Init
#define IHM16M1_DeInit          BSP_GPIO_DeInit
#define IHM16M1_GetPwrStage     BSP_GetPwrStage
#define IHM16M1_SetPwrStage     BSP_SetPwrStage
#define IHM16M1_GetStby         BSP_GetStby
#define IHM16M1_SetStby         BSP_SetStby
  
#ifdef __cplusplus
}
#endif

#endif /* __IHM16M1_CONF_H__*/

/************************ (C) COPYRIGHT STMicroelectronics *****END OF FILE****/

