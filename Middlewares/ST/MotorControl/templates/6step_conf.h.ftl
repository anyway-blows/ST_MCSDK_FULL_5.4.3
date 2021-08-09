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
<#-- Condition for STM32F401 MCU -->
<#assign CondMcu_STM32F401xxx = (McuName?? && McuName?matches("STM32F401.*"))>
<#-- Condition for STM32G4 Family -->
<#assign CondFamily_STM32G4 = (FamilyName?? && FamilyName == "STM32G4") >
<#-- Condition for STM32F031 MCU (STSPIN MCU)-->
<#assign CondMcu_STM32F031Cxx = (McuName?? && McuName?matches("STM32F031C.*"))>
/**
 ******************************************************************************
 * @file    6step_conf.h
 * @author  IPC Rennes & Motor Control SDK, ST Microelectronics
 * @brief   Header file for the 6step_conf.c file
 ******************************************************************************
 * @attention
 *
 * <h2><center>&copy; Copyright (c) 2019 STMicroelectronics International N.V.
 * All rights reserved.</center></h2>
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted, provided that the following conditions are met:
 *
 * 1. Redistribution of source code must retain the above copyright notice,
 *    this list of conditions and the following disclaimer.
 * 2. Redistributions in binary form must reproduce the above copyright notice,
 *    this list of conditions and the following disclaimer in the documentation
 *    and/or other materials provided with the distribution.
 * 3. Neither the name of STMicroelectronics nor the names of other
 *    contributors to this software may be used to endorse or promote products
 *    derived from this software without specific written permission.
 * 4. This software, including modifications and/or derivative works of this
 *    software, must execute solely and exclusively on microcontroller or
 *    microprocessor devices manufactured by or for STMicroelectronics.
 * 5. Redistribution and use of this software other than as permitted under
 *    this license is void and will automatically terminate your rights under
 *    this license.
 *
 * THIS SOFTWARE IS PROVIDED BY STMICROELECTRONICS AND CONTRIBUTORS "AS IS"
 * AND ANY EXPRESS, IMPLIED OR STATUTORY WARRANTIES, INCLUDING, BUT NOT
 * LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY, FITNESS FOR A
 * PARTICULAR PURPOSE AND NON-INFRINGEMENT OF THIRD PARTY INTELLECTUAL PROPERTY
 * RIGHTS ARE DISCLAIMED TO THE FULLEST EXTENT PERMITTED BY LAW. IN NO EVENT
 * SHALL STMICROELECTRONICS OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT,
 * INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
 * LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA,
 * OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF
 * LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING
 * NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE,
 * EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 *
 ******************************************************************************
 */

/* Define to prevent recursive inclusion -------------------------------------*/
#ifndef __6STEP_CONF_H
#define __6STEP_CONF_H

#ifdef __cplusplus
extern "C" {
#endif

/* Includes ------------------------------------------------------------------*/
#include "Motor_Configuration.h"
<#if CondMcu_STM32F401xxx>
#include "stm32f4xx_hal.h"
#include "stm32f4xx_ll_tim.h"
#include "stm32f4xx_ll_gpio.h"
#include "stm32f4xx_ll_adc.h"
<#elseif CondFamily_STM32G4>
#include "stm32g4xx_hal.h"
#include "stm32g4xx_ll_tim.h"
#include "stm32g4xx_ll_gpio.h"
#include "stm32g4xx_ll_adc.h"
<#elseif CondMcu_STM32F031Cxx>
#include "stm32f0xx_hal.h"
#include "stm32f0xx_ll_tim.h"
#include "stm32f0xx_ll_gpio.h"
#include "stm32f0xx_ll_adc.h"
<#else>
#include "stm32xxx_hal.h"  /* replace 'stm32xxx' with your HAL driver header filename, ex: stm32f0xx.h */
#include "stm32xxx_ll_tim.h" /* replace 'stm32xxx' with your LL driver header filename, ex: stm32f0xx_ll_tim.h */
#include "stm32xxx_ll_gpio.h" /* replace 'stm32xxx' with your LL driver header filename, ex: stm32f0xx_ll_gpio.h */
#include "stm32xxxx_ll_adc.h" /* replace 'stm32xxx' with your LL driver header filename, ex: stm32f0xx_ll_adc.h */
</#if>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>


/** @addtogroup MIDDLEWARES
  * @brief  Middlewares Layer
  * @{ 
  */
  
/** @addtogroup MC_LIB_6STEP
  * @{
  */
 
/** @defgroup MC_6STEP_CONF
  * @{
  */ 

/** @defgroup MC_6STEP_CONF_Exported_Defines
  * @{
  */

/*!< Manage the overall system configuration */
/*!< Number of motor devices */
#define NUMBER_OF_DEVICES       (<#if MC.DUALDRIVE>2<#else>1</#if>)
    
/*!< Motor control sensing : set one definition to 1, others to 0 */
#define SENSORS_LESS            (<#if MC.SIX_STEP_SENSING == "SENSORS_LESS">1<#else>0</#if>)
#define HALL_SENSORS            (<#if MC.SIX_STEP_SENSING == "HALL_SENSORS">1<#else>0</#if>)
#define SENSE_COMPARATORS       (<#if MC.SIX_STEP_SENSING == "COMPARATORS">1<#else>0</#if>)
    
/*!< Motor control mode */
/*!< Set VOLTAGE_MODE to 1 and CURRENT_MODE to 0 or the contrary */
#define VOLTAGE_MODE            (<#if MC.SIX_STEP_CONTROL_MODE == "VOLTAGE">1<#else>0</#if>)
#define CURRENT_MODE            (<#if MC.SIX_STEP_CONTROL_MODE == "CURRENT">1<#else>0</#if>)

/*!< Motor control additional features */
/*!< Set independantly SPEED_LOOP either to 1 or 0 */ 
#define SPEED_LOOP              (<#if MC.SIX_STEP_SPEED_LOOP == true>1<#else>0</#if>)
/*!< Set independantly SET_POINT_RAMPING either to 1 or 0 */  
#define SET_POINT_RAMPING       (<#if MC.SIX_STEP_SET_POINT_RAMPING == true>1<#else>0</#if>)
/*!< Set independantly gate driver pwm interface THREE_PWM either to 1 or 0 */  
#define THREE_PWM               (<#if MC.SIX_STEP_THREE_PWM == true>1<#else>0</#if>)

/*!< Motor control user interface : set one definition to 1, others to 0 */
#define UART_INTERFACE          (<#if MC.SERIAL_COMMUNICATION == false>1<#else>0</#if>)
#define POTENTIOMETER_INTERFACE (0)
#define PWM_INTERFACE           (0)

/**
  * @} end MC_6STEP_CONF_Exported_Defines
  */

/**
  * @}  end MC_6STEP_CONF
  */ 

/**
  * @}  end MC_LIB_6STEP
  */

/**
  * @}  end MIDDLEWARES
  */

#ifdef __cplusplus
}
#endif

#endif /* __6STEP_CONF_H */

/************************ (C) COPYRIGHT STMicroelectronics *****END OF FILE****/