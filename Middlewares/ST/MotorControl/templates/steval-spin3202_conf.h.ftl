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
<#-- Condition for STM32F031 MCU (STSPIN MCU)-->
<#assign CondMcu_STM32F031Cxx = (McuName?? && McuName?matches("STM32F031C.*"))>
/**
 ******************************************************************************
 * @file    steval-spin3202_conf.h
 * @author  IPC Rennes & Motor Control SDK, ST Microelectronics
 * @brief   Header file for the steval_spin3202.h file
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
#ifndef __STEVAL_SPIN3202_CONF_H__
#define __STEVAL_SPIN3202_CONF_H__

#ifdef __cplusplus
extern "C" {
#endif

/* Includes ------------------------------------------------------------------*/
<#if CondMcu_STM32F031Cxx>
#include "stm32f0xx_hal.h"
#include "f031c6_bus.h"
#include "f031c6_errno.h"
<#else>
#include "stm32yyxx_hal.h"
#include "nucleo_xyyyzz_bus.h"
#include "nucleo_xyyyzz_errno.h"
</#if>

#define STEVAL_SPIN3202_ADC_BEMF_CH1    LL_ADC_CHANNEL_0   /*BEMF1*/
#define STEVAL_SPIN3202_ADC_BEMF_CH2    LL_ADC_CHANNEL_1   /*BEMF2*/
#define STEVAL_SPIN3202_ADC_BEMF_CH3    LL_ADC_CHANNEL_2   /*BEMF3*/
#define STEVAL_SPIN3202_ADC_SPEED       LL_ADC_CHANNEL_3   /*POTENTIOMETER FOR SPEED*/
#define STEVAL_SPIN3202_ADC_CURRENT     LL_ADC_CHANNEL_4   /*CURRENT*/
#define STEVAL_SPIN3202_ADC_VBUS        LL_ADC_CHANNEL_9   /*VBUS*/
#define STEVAL_SPIN3202_ADC_TEMP        LL_ADC_CHANNEL_16  /*TEMPERATURE*/
#define STEVAL_SPIN3202_ADC_VREF        LL_ADC_CHANNEL_17  /*VOLTAGE REFERENCE*/

#define STEVAL_SPIN3202_ADC_BEMF_ST     LL_ADC_SAMPLINGTIME_13CYCLES_5   /*ADC Sampling Time for BEMF measurements*/
#define STEVAL_SPIN3202_ADC_SPEED_ST    LL_ADC_SAMPLINGTIME_13CYCLES_5   /*ADC Sampling Time for SPEED measurements*/
#define STEVAL_SPIN3202_ADC_CURRENT_ST  LL_ADC_SAMPLINGTIME_13CYCLES_5   /*ADC Sampling Time for CURRENT measurements*/
#define STEVAL_SPIN3202_ADC_VBUS_ST     LL_ADC_SAMPLINGTIME_13CYCLES_5   /*ADC Sampling Time for VBUS measurements*/
#define STEVAL_SPIN3202_ADC_TEMP_ST     LL_ADC_SAMPLINGTIME_239CYCLES_5  /*ADC Sampling Time for TEMPERATURE measurements*/
#define STEVAL_SPIN3202_ADC_VREF_ST     LL_ADC_SAMPLINGTIME_239CYCLES_5  /*ADC Sampling Time for VOLTAGE REFERENCE measurements*/

#define STEVAL_SPIN3202_Init            BSP_GPIO_Init
#define STEVAL_SPIN3202_DeInit          BSP_GPIO_DeInit
#define STEVAL_SPIN3202_GetOcVis        BSP_GetOcVis
#define STEVAL_SPIN3202_SetOcVis        BSP_SetOcVis
#define STEVAL_SPIN3202_GetOcTh         BSP_GetOcTh
#define STEVAL_SPIN3202_SetOcTh         BSP_SetOcTh
  
#ifdef __cplusplus
}
#endif

#endif /* __STEVAL_SPIN3202_CONF_H__*/

/************************ (C) COPYRIGHT STMicroelectronics *****END OF FILE****/

