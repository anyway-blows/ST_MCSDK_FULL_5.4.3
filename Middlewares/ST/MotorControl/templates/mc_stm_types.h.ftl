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
<#if MC??>
<#else>
<#stop "No MotorControl SW IP data found">
</#if>
</#if>
<#-- Condition for STM32F302x8x MCU -->
<#assign CondMcu_STM32F302x8x = (McuName?? && McuName?matches("STM32F302.8.*"))>
<#-- Condition for STM32F072xxx MCU -->
<#assign CondMcu_STM32F072xxx = (McuName?? && McuName?matches("STM32F072.*"))>
<#-- Condition for Line STM32F1xx Value -->
<#assign CondLine_STM32F1_Value = (McuName?? && (McuName?matches("STM32F100.(4|6|8|B).*")))>
<#-- Condition for Line STM32F1xx Performance -->
<#assign CondLine_STM32F1_Performance = (McuName?? && McuName?matches("STM32F103.(4|6|8|B).*"))>
<#-- Condition for Line STM32F1xx High Density -->
<#assign CondLine_STM32F1_HD = (McuName?? && McuName?matches("STM32F103.(C|D|E|F|G).*"))>
<#-- Condition for STM32F0 Family -->
<#assign CondFamily_STM32F0 = (FamilyName?? && FamilyName=="STM32F0")>
<#-- Condition for STM32F1 Family -->
<#assign CondFamily_STM32F1 = (CondLine_STM32F1_Value || CondLine_STM32F1_Performance || CondLine_STM32F1_HD)>
<#-- Condition for STM32F3 Family -->
<#assign CondFamily_STM32F3 = (FamilyName?? && FamilyName == "STM32F3")>
<#-- Condition for STM32F4 Family -->
<#assign CondFamily_STM32F4 = (FamilyName?? && FamilyName == "STM32F4")>
<#-- Condition for STM32G4 Family -->
<#assign CondFamily_STM32G4 = (FamilyName?? && FamilyName == "STM32G4") >
<#-- Condition for STM32L4 Family -->
<#assign CondFamily_STM32L4 = (FamilyName?? && FamilyName == "STM32L4") >
<#-- Condition for STM32F7 Family -->
<#assign CondFamily_STM32F7 = (FamilyName?? && FamilyName == "STM32F7") >
<#-- Condition for STM32F7 Family -->
<#assign CondFamily_STM32H7 = (FamilyName?? && FamilyName == "STM32H7") >
<#-- Condition for STM32G0 Family -->
<#assign CondFamily_STM32G0 = (FamilyName?? && FamilyName == "STM32G0") >
/**
  ******************************************************************************
  * @file    mc_stm_types.h 
  * @author  Motor Control SDK Team, ST Microelectronics
  * @brief   Includes HAL/LL headers relevant to the current configuration.
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
#ifndef __MC_STM_TYPES_H
#define __MC_STM_TYPES_H
  
#ifndef USE_FULL_LL_DRIVER
#define USE_FULL_LL_DRIVER
#endif

#ifdef MISRA_C_2004_BUILD
#error "The code is not ready for that..."
#endif

<#if CondFamily_STM32F1>
  #include "stm32f1xx_ll_rcc.h"
  #include "stm32f1xx_ll_system.h"
  #include "stm32f1xx_ll_adc.h"
  #include "stm32f1xx_ll_tim.h"
  #include "stm32f1xx_ll_gpio.h"
  #include "stm32f1xx_ll_usart.h"
  #include "stm32f1xx_ll_dac.h"
  #include "stm32f1xx_ll_dma.h"
  #include "stm32f1xx_ll_spi.h"
  #include "stm32f1xx_ll_bus.h"
  #include "stm32f1xx_ll_system.h"
<#if MC.PFC_ENABLED == true >
	#include "stm32f1xx_ll_exti.h"
</#if>
<#elseif CondFamily_STM32F4>
  #include "stm32f4xx_ll_system.h"
  #include "stm32f4xx_ll_adc.h"
  #include "stm32f4xx_ll_tim.h"
  #include "stm32f4xx_ll_gpio.h"
  #include "stm32f4xx_ll_usart.h"
  #include "stm32f4xx_ll_dac.h"
  #include "stm32f4xx_ll_dma.h"
  #include "stm32f4xx_ll_bus.h"
<#elseif CondFamily_STM32F7>
  #include "stm32f7xx_ll_system.h"
  #include "stm32f7xx_ll_adc.h"
  #include "stm32f7xx_ll_tim.h"
  #include "stm32f7xx_ll_gpio.h"
  #include "stm32f7xx_ll_usart.h"
  #include "stm32f7xx_ll_dac.h"
  #include "stm32f7xx_ll_dma.h"
  #include "stm32f7xx_ll_bus.h"
<#elseif CondFamily_STM32H7>
  #include "stm32h7xx_ll_bus.h"
  #include "stm32h7xx_ll_rcc.h"
  #include "stm32h7xx_ll_system.h"
  #include "stm32h7xx_ll_adc.h"
  #include "stm32h7xx_ll_tim.h"
  #include "stm32h7xx_ll_gpio.h"
  #include "stm32h7xx_ll_usart.h"
  #include "stm32h7xx_ll_dac.h"
  #include "stm32h7xx_ll_dma.h"
  #include "stm32h7xx_ll_comp.h"
  #include "stm32h7xx_ll_opamp.h"
<#elseif CondFamily_STM32L4>
  #include "stm32l4xx_ll_system.h"
  #include "stm32l4xx_ll_adc.h"
  #include "stm32l4xx_ll_tim.h"
  #include "stm32l4xx_ll_gpio.h"
  #include "stm32l4xx_ll_usart.h"
  #include "stm32l4xx_ll_dac.h"
  #include "stm32l4xx_ll_dma.h"
  #include "stm32l4xx_ll_bus.h"
  #include "stm32l4xx_ll_comp.h"
  #include "stm32l4xx_ll_opamp.h"
<#elseif CondFamily_STM32F0>
  #include "stm32f0xx_ll_bus.h"
  #include "stm32f0xx_ll_rcc.h"
  #include "stm32f0xx_ll_system.h"
  #include "stm32f0xx_ll_adc.h"
  #include "stm32f0xx_ll_tim.h"
  #include "stm32f0xx_ll_gpio.h"
  #include "stm32f0xx_ll_usart.h"
  #include "stm32f0xx_ll_dac.h"
  #include "stm32f0xx_ll_dma.h"
  #include "stm32f0xx_ll_comp.h"
<#elseif CondFamily_STM32F3>
  #include "stm32f3xx_ll_bus.h"
  #include "stm32f3xx_ll_rcc.h"
  #include "stm32f3xx_ll_system.h"
  #include "stm32f3xx_ll_adc.h"
  #include "stm32f3xx_ll_tim.h"
  #include "stm32f3xx_ll_gpio.h"
  #include "stm32f3xx_ll_usart.h"
  #include "stm32f3xx_ll_dac.h"
  #include "stm32f3xx_ll_dma.h"
  #include "stm32f3xx_ll_comp.h"
  #include "stm32f3xx_ll_opamp.h"
  #include "stm32f3xx_ll_spi.h"
<#elseif CondFamily_STM32G4>
  #include "stm32g4xx_ll_bus.h"
  #include "stm32g4xx_ll_rcc.h"
  #include "stm32g4xx_ll_system.h"
  #include "stm32g4xx_ll_adc.h"
  #include "stm32g4xx_ll_tim.h"
  #include "stm32g4xx_ll_gpio.h"
  #include "stm32g4xx_ll_usart.h"
  #include "stm32g4xx_ll_dac.h"
  #include "stm32g4xx_ll_dma.h"
  #include "stm32g4xx_ll_comp.h"
  #include "stm32g4xx_ll_opamp.h"
  #include "stm32g4xx_ll_cordic.h"
<#elseif CondFamily_STM32G0>
  #include "stm32g0xx_ll_bus.h"
  #include "stm32g0xx_ll_rcc.h"
  #include "stm32g0xx_ll_system.h"
  #include "stm32g0xx_ll_adc.h"
  #include "stm32g0xx_ll_tim.h"
  #include "stm32g0xx_ll_gpio.h"
  #include "stm32g0xx_ll_usart.h"
  #include "stm32g0xx_ll_dac.h"
  #include "stm32g0xx_ll_dma.h"
  #include "stm32g0xx_ll_comp.h"
<#else>
  #error "No MCU selected"
</#if>
<#if CondFamily_STM32F0 || CondFamily_STM32G0>

/* Enable Fast division optimization for cortex-M0[+] micros*/
  # define FASTDIV
</#if>
/**
 * @name Predefined Speed Units
 *
 * Each of the following symbols defines a rotation speed unit that can be used by the 
 * functions of the API for their speed parameter. Each Unit is defined by expressing 
 * the value of 1 Hz in this unit.
 *
 * These symbols can be used to set the #SPEED_UNIT macro which defines the rotation speed
 * unit used by the functions of the API.
 *
 * @anchor SpeedUnit
 */
/** @{ */
/** Revolutions Per Minute: 1 Hz is 60 RPM */
#define _RPM 60
/** Tenth of Hertz: 1 Hz is 10 01Hz */
#define _01HZ 10
/** Hundreth of Hertz: 1 Hz is 100 001Hz */
#define _001HZ 100
/** @} */ 

/* USER CODE BEGIN DEFINITIONS */
/* Definitions placed here will not be erased by code generation */
/**
 * @brief Rotation speed unit used at the interface with the application 
 *
 * This symbols defines the value of 1 Hertz in the unit used by the functions of the API for 
 * their speed parameters. 
 *
 * For instance, if the chosen unit is the RPM, SPEED_UNIT is defined to 60, since 1 Hz is 60 RPM.
 *
 * @note This symbol should not be set to a literal numeric value. Rather, it should be set to one
 *       of the symbols predefined for that purpose such as #_RPM, #_01HZ,... See @ref SpeedUnit for 
 *       more details. 
 */
#define SPEED_UNIT _01HZ

/**
 * @brief use a circle limitation that privileges Vd component instead of Vdq angle (uses more MIPS)
 *  
 *        to use a circle limitation that keeps Vdq angle uncomment the define below 
 *        (Beware: this uses more MIPS)
 */
/*#define CIRCLE_LIMITATION_VD*/

/* USER CODE END DEFINITIONS */


#endif /* __MC_STM_TYPES_H */
/******************* (C) COPYRIGHT 2019 STMicroelectronics *****END OF FILE****/
