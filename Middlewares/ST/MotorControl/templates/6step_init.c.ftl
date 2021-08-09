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
<#-- Condition for STM32F0 Family -->
<#assign CondFamily_STM32F0 = (FamilyName?? && FamilyName=="STM32F0")>
<#-- Condition for STM32F401xxx MCU -->
<#assign CondMcu_STM32F401xxx = (McuName?? && McuName?matches("STM32F401.*"))>
<#-- Condition for STM32G4 Family -->
<#assign CondFamily_STM32G4 = (FamilyName?? && FamilyName == "STM32G4") >
/**
  ******************************************************************************
  * @file    6step_init.c
  * @author  Motor Control SDK Team, ST Microelectronics
  * @brief   This file implements 6 step application initialization
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

#include "adc.h"
#include "tim.h"
#include "usart.h"
#include "6step_init.h"
#include "6step_conf.h"
<#-- Manage the Power board usage -->
<#switch MC.SIX_STEP_POWER_BOARD>
  <#case "IHM07M1">
#include "ihm07m1_conf.h"
#include "ihm07m1.h"
  <#break>

  <#case "IHM08M1">
#include "ihm08m1_conf.h"
#include "ihm08m1.h"
  <#break>

  <#case "IHM16M1">
#include "ihm16m1_conf.h"
#include "ihm16m1.h"
  <#break>

  <#case "STSPIN3202">
#include "steval-spin3202_conf.h"
#include "steval-spin3202.h"
  <#break>

  <#case "STSPIN3204">
#include "steval-spin3204_conf.h"
#include "steval-spin3204.h"
  <#break>

  <#default>
  #error "This platform is not supported for 6-Steps"
  <#break>
</#switch>

/** @addtogroup MIDDLEWARES
  * @brief  Middlewares Layer
  * @{ 
  */

/** @addtogroup MC_LIB_6STEP
  * @{
  */

/* Initializes the Motor subsystem core according to user defined parameters */
void MCboot( MC_Handle_t* pMCIList[] )
{
<#-- Manage the Power board usage -->
<#-- This comes from USER CODE sections in main.c file -->
<#if (CondFamily_STM32G4 == true) || (CondFamily_STM32F0 == true)>
<#assign pTrigTim = "(uint32_t *)&htim1">
<#assign TrigTimChannel = "(uint16_t)LL_TIM_CHANNEL_CH4">
<#elseif (CondMcu_STM32F401xxx == true)>
<#assign pTrigTim = "(uint32_t *)&htim3">
<#assign TrigTimChannel = "(uint16_t)LL_TIM_CHANNEL_CH4">
</#if>
<#switch MC.SIX_STEP_POWER_BOARD>
  <#case "IHM07M1">
    <#if CondFamily_STM32G4 == true>
  /* NUCLEO-STM32G431RB + X-NUCLEO-IHM07M1, ADC1 config */
  LL_ADC_SetCommonPathInternalCh( __LL_ADC_COMMON_INSTANCE( hadc1.Instance ), LL_ADC_PATH_INTERNAL_VREFINT );
    </#if>
  /* TIM1 config */
  LL_TIM_OC_SetDeadTime( htim1.Instance, DEAD_TIME );
  <#break>

  <#case "IHM08M1">
  <#-- BEWARE of: same code as for IHM07M1 -->
    <#if CondFamily_STM32G4 == true>
  /* NUCLEO-STM32G431RB + X-NUCLEO-IHM08M1, ADC1 config */
  LL_ADC_SetCommonPathInternalCh(__LL_ADC_COMMON_INSTANCE(hadc1.Instance), LL_ADC_PATH_INTERNAL_VREFINT);
    </#if>
  /* TIM1 config */
  LL_TIM_OC_SetDeadTime(htim1.Instance, DEAD_TIME);
  <#break>

  <#case "IHM16M1">
  <#-- BEWARE of: same code as for IHM07M1 -->
    <#if CondFamily_STM32G4 == true>
  /* NUCLEO-STM32G431RB + X-NUCLEO-IHM16M1, ADC1 config */
  LL_ADC_SetCommonPathInternalCh(__LL_ADC_COMMON_INSTANCE(hadc1.Instance), LL_ADC_PATH_INTERNAL_VREFINT);
    </#if>
  /* TIM1 config */
  LL_TIM_OC_SetDeadTime(htim1.Instance, DEAD_TIME);
  <#break>

  <#case "STSPIN3202">
  /* STEVAL-SPIN3202, TIM1 config */
	<#if MC.SIX_STEP_CONTROL_MODE == "CURRENT">
  LL_TIM_DisableBRK(htim1.Instance);
	</#if>
  LL_TIM_OC_SetDeadTime(htim1.Instance, DEAD_TIME);
  <#break>

  <#case "STSPIN3204">
  <#-- BEWARE of: same code as for STEVAL-SPIN3202 -->
  /* STEVAL-SPIN3204, TIM1 config */
	<#if MC.SIX_STEP_CONTROL_MODE == "CURRENT">
  LL_TIM_DisableBRK(htim1.Instance);
	</#if>
  LL_TIM_OC_SetDeadTime(htim1.Instance, DEAD_TIME);
  <#break>

  <#default>
  #error "This platform is not supported for 6-Steps"
  <#break>
</#switch>
  
<#-- Manage the Power board usage -->
<#switch MC.SIX_STEP_POWER_BOARD>
  <#case "IHM07M1">
  <#-- This comes from USER CODE sections in function HAL_TIM_Base_MspInit in stm32xxx_hal_msp.c file -->
  /* Timers initialization */
  __HAL_DBGMCU_FREEZE_TIM1();    
  __HAL_TIM_ENABLE_IT( &htim1, TIM_IT_BREAK );
  __HAL_DBGMCU_FREEZE_TIM4();
  <#break>

  <#case "IHM08M1">
  <#-- This comes from USER CODE sections in function HAL_TIM_Base_MspInit in stm32xxx_hal_msp.c file -->
  /* Timers initialization */
  __HAL_DBGMCU_FREEZE_TIM1();    
  __HAL_TIM_ENABLE_IT( &htim1, TIM_IT_BREAK );
  __HAL_DBGMCU_FREEZE_TIM4();
  <#break>

  <#case "IHM16M1">
  <#-- This comes from USER CODE sections in function HAL_TIM_Base_MspInit in stm32xxx_hal_msp.c file -->
  /* Timers initialization */
  __HAL_DBGMCU_FREEZE_TIM1();    
  __HAL_DBGMCU_FREEZE_TIM4();
  <#break>

  <#case "STSPIN3202">
  <#-- This comes from USER CODE sections in function HAL_TIM_Base_MspInit in stm32f0xx_hal_msp.c file -->
  /* STEVAL-SPIN3202, Timers initialization */
  __HAL_DBGMCU_FREEZE_TIM1();    
  __HAL_DBGMCU_FREEZE_TIM3();
  <#-- This comes from USER CODE sections in function HAL_TIM_OC_MspInit in stm32f0xx_hal_msp.c file -->
  __HAL_DBGMCU_FREEZE_TIM2();
  <#break>

  <#case "STSPIN3204">
  <#-- This comes from USER CODE sections in function HAL_TIM_Base_MspInit in stm32f0xx_hal_msp.c file -->
  /* STEVAL-SPIN3204, Timers initialization */
  __HAL_DBGMCU_FREEZE_TIM1();    
  <#-- This comes from USER CODE sections in function HAL_TIM_OC_MspInit in stm32f0xx_hal_msp.c file -->
  __HAL_DBGMCU_FREEZE_TIM2();
  <#break>

  <#default>
  #error "This platform is not supported for 6-Steps"
  <#break>
</#switch>

<#-- Manage the Power board usage -->
<#-- This comes from USER CODE section 2 in main() -->
<#switch MC.SIX_STEP_POWER_BOARD>
  <#case "IHM07M1">
  MC_Core_AssignTimers( pMCIList[0], (uint32_t *)&htim1, (uint32_t *)&htim4, (uint32_t *)&htim3 );
<#if MC.SIX_STEP_SENSING == "SENSORS_LESS"><#-- Sensorless usage -->
  MC_Core_ConfigureBemfAdc( pMCIList[0], (uint32_t *)&hadc1, ${pTrigTim}, ${TrigTimChannel} );
  MC_Core_ConfigureBemfAdcChannel( pMCIList[0], IHM07M1_ADC_BEMF_CH1, IHM07M1_ADC_BEMF_ST, MC_BEMF_PHASE_1 );
  MC_Core_ConfigureBemfAdcChannel( pMCIList[0], IHM07M1_ADC_BEMF_CH2, IHM07M1_ADC_BEMF_ST, MC_BEMF_PHASE_2 );
  MC_Core_ConfigureBemfAdcChannel( pMCIList[0], IHM07M1_ADC_BEMF_CH3, IHM07M1_ADC_BEMF_ST, MC_BEMF_PHASE_3 );
</#if>

  MC_Core_ConfigureUserAdc( pMCIList[0], ${pTrigTim}, ${TrigTimChannel} ); 
  MC_Core_ConfigureUserAdcChannel( pMCIList[0], (uint32_t *)&hadc1, IHM07M1_ADC_SPEED, IHM07M1_ADC_SPEED_ST, MC_USER_MEAS_1 );
  MC_Core_ConfigureUserAdcChannel( pMCIList[0], (uint32_t *)&hadc1, IHM07M1_ADC_CURRENT, IHM07M1_ADC_CURRENT_ST, MC_USER_MEAS_2 );
  MC_Core_ConfigureUserAdcChannel( pMCIList[0], (uint32_t *)&hadc1, IHM07M1_ADC_VBUS, IHM07M1_ADC_VBUS_ST, MC_USER_MEAS_3 );
  MC_Core_ConfigureUserAdcChannel( pMCIList[0], (uint32_t *)&hadc1, IHM07M1_ADC_TEMP, IHM07M1_ADC_TEMP_ST, MC_USER_MEAS_4 );
  MC_Core_ConfigureUserAdcChannel( pMCIList[0], (uint32_t *)&hadc1, IHM07M1_ADC_VREF, IHM07M1_ADC_VREF_ST, MC_USER_MEAS_5 );

  MC_Core_ConfigureUserButton(pMCIList[0], (uint16_t) B1_Pin, (uint16_t) 500 );
  <#break>

  <#case "IHM08M1">
  MC_Core_AssignTimers( pMCIList[0], (uint32_t *)&htim1, (uint32_t *)&htim4, (uint32_t *)&htim3 );
<#if MC.SIX_STEP_SENSING == "SENSORS_LESS"><#-- Sensorless usage -->
  MC_Core_ConfigureBemfAdc( pMCIList[0], (uint32_t *)&hadc1, ${pTrigTim}, ${TrigTimChannel} );
  MC_Core_ConfigureBemfAdcChannel( pMCIList[0], IHM08M1_ADC_BEMF_CH1, IHM08M1_ADC_BEMF_ST, MC_BEMF_PHASE_1 );
  MC_Core_ConfigureBemfAdcChannel( pMCIList[0], IHM08M1_ADC_BEMF_CH2, IHM08M1_ADC_BEMF_ST, MC_BEMF_PHASE_2 );
  MC_Core_ConfigureBemfAdcChannel( pMCIList[0], IHM08M1_ADC_BEMF_CH3, IHM08M1_ADC_BEMF_ST, MC_BEMF_PHASE_3 );
</#if>

  MC_Core_ConfigureUserAdc( pMCIList[0], ${pTrigTim}, ${TrigTimChannel} ); 
  MC_Core_ConfigureUserAdcChannel( pMCIList[0], (uint32_t *)&hadc2, IHM08M1_ADC_SPEED, IHM08M1_ADC_SPEED_ST, MC_USER_MEAS_1 );
  MC_Core_ConfigureUserAdcChannel( pMCIList[0], (uint32_t *)&hadc1, IHM08M1_ADC_CURRENT, IHM08M1_ADC_CURRENT_ST, MC_USER_MEAS_2 );
  MC_Core_ConfigureUserAdcChannel( pMCIList[0], (uint32_t *)&hadc1, IHM08M1_ADC_VBUS, IHM08M1_ADC_VBUS_ST, MC_USER_MEAS_3 );
  MC_Core_ConfigureUserAdcChannel( pMCIList[0], (uint32_t *)&hadc1, IHM08M1_ADC_TEMP, IHM08M1_ADC_TEMP_ST, MC_USER_MEAS_4 );
  MC_Core_ConfigureUserAdcChannel( pMCIList[0], (uint32_t *)&hadc1, IHM08M1_ADC_VREF, IHM08M1_ADC_VREF_ST, MC_USER_MEAS_5 );

  MC_Core_ConfigureUserButton(pMCIList[0], (uint16_t) B1_Pin, (uint16_t) 500 );
  <#break>

  <#case "IHM16M1">
  IHM16M1_MOTOR_DRIVER_Init();
  IHM16M1_MOTOR_DRIVER_SetPwrStage(STSPIN830_PWR_ENABLE);
  IHM16M1_MOTOR_DRIVER_SetStby(STSPIN830_STBY_DISABLE);

  MC_Core_AssignTimers( pMCIList[0], (uint32_t *)&htim1, (uint32_t *)&htim4, (uint32_t *)&htim3 );
<#if MC.SIX_STEP_SENSING == "SENSORS_LESS"><#-- Sensorless usage -->
  MC_Core_ConfigureBemfAdc( pMCIList[0], (uint32_t *)&hadc1, ${pTrigTim}, ${TrigTimChannel} );
  MC_Core_ConfigureBemfAdcChannel( pMCIList[0], IHM16M1_ADC_BEMF_CH1, IHM16M1_ADC_BEMF_ST, MC_BEMF_PHASE_1 );
  MC_Core_ConfigureBemfAdcChannel( pMCIList[0], IHM16M1_ADC_BEMF_CH2, IHM16M1_ADC_BEMF_ST, MC_BEMF_PHASE_2 );
  MC_Core_ConfigureBemfAdcChannel( pMCIList[0], IHM16M1_ADC_BEMF_CH3, IHM16M1_ADC_BEMF_ST, MC_BEMF_PHASE_3 );
</#if>

  MC_Core_ConfigureUserAdc( pMCIList[0], ${pTrigTim}, ${TrigTimChannel} ); 
  MC_Core_ConfigureUserAdcChannel( pMCIList[0], (uint32_t *)&hadc2, IHM16M1_ADC_SPEED, IHM16M1_ADC_SPEED_ST, MC_USER_MEAS_1 );
  MC_Core_ConfigureUserAdcChannel( pMCIList[0], (uint32_t *)&hadc2, IHM16M1_ADC_CURRENT, IHM16M1_ADC_CURRENT_ST, MC_USER_MEAS_2 );
  MC_Core_ConfigureUserAdcChannel( pMCIList[0], (uint32_t *)&hadc2, IHM16M1_ADC_VBUS, IHM16M1_ADC_VBUS_ST, MC_USER_MEAS_3 );
  MC_Core_ConfigureUserAdcChannel( pMCIList[0], (uint32_t *)&hadc2, IHM16M1_ADC_TEMP, IHM16M1_ADC_TEMP_ST, MC_USER_MEAS_4 );
  MC_Core_ConfigureUserAdcChannel( pMCIList[0], (uint32_t *)&hadc1, IHM16M1_ADC_VREF, IHM16M1_ADC_VREF_ST, MC_USER_MEAS_5 );

  MC_Core_ConfigureUserButton( pMCIList[0], (uint16_t) B1_Pin, (uint16_t) 500 );
  <#break>

  <#case "STSPIN3202">
  STEVAL_SPIN3202_MOTOR_DRIVER_Init();
  STEVAL_SPIN3202_MOTOR_DRIVER_SetOcVis(STSPIN32F0A_OC_VIS_FROM_MCU_AND_GATE_LOGIC);
  STEVAL_SPIN3202_MOTOR_DRIVER_SetOcTh(STSPIN32F0A_OC_TH_500mV);

  MC_Core_AssignTimers( pMCIList[0], (uint32_t *)&htim1, (uint32_t *)&htim2, (uint32_t *)&htim3 );
<#if MC.SIX_STEP_SENSING == "SENSORS_LESS"><#-- Sensorless usage -->
  MC_Core_ConfigureBemfAdc( pMCIList[0], (uint32_t *)&hadc, ${pTrigTim}, ${TrigTimChannel} );
  MC_Core_ConfigureBemfAdcChannel( pMCIList[0], STEVAL_SPIN3202_ADC_BEMF_CH1, STEVAL_SPIN3202_ADC_BEMF_ST, MC_BEMF_PHASE_1 );
  MC_Core_ConfigureBemfAdcChannel( pMCIList[0], STEVAL_SPIN3202_ADC_BEMF_CH2, STEVAL_SPIN3202_ADC_BEMF_ST, MC_BEMF_PHASE_2 );
  MC_Core_ConfigureBemfAdcChannel( pMCIList[0], STEVAL_SPIN3202_ADC_BEMF_CH3, STEVAL_SPIN3202_ADC_BEMF_ST, MC_BEMF_PHASE_3 );
</#if>

  MC_Core_ConfigureUserAdc( pMCIList[0], ${pTrigTim}, ${TrigTimChannel} );
  MC_Core_ConfigureUserAdcChannel( pMCIList[0], (uint32_t *)&hadc, STEVAL_SPIN3202_ADC_SPEED, STEVAL_SPIN3202_ADC_SPEED_ST, MC_USER_MEAS_1 );
  MC_Core_ConfigureUserAdcChannel( pMCIList[0], (uint32_t *)&hadc, STEVAL_SPIN3202_ADC_CURRENT, STEVAL_SPIN3202_ADC_CURRENT_ST, MC_USER_MEAS_2 );
  MC_Core_ConfigureUserAdcChannel( pMCIList[0], (uint32_t *)&hadc, STEVAL_SPIN3202_ADC_VBUS, STEVAL_SPIN3202_ADC_VBUS_ST, MC_USER_MEAS_3 );
  MC_Core_ConfigureUserAdcChannel( pMCIList[0], (uint32_t *)&hadc, STEVAL_SPIN3202_ADC_TEMP, STEVAL_SPIN3202_ADC_TEMP_ST, MC_USER_MEAS_4 );
  MC_Core_ConfigureUserAdcChannel( pMCIList[0], (uint32_t *)&hadc, STEVAL_SPIN3202_ADC_VREF, STEVAL_SPIN3202_ADC_VREF_ST, MC_USER_MEAS_5 );
  MC_Core_ConfigureUserButton( pMCIList[0], (uint16_t) USER1_LED_BUTTON_Pin, (uint16_t) 500 );
  <#break>

  <#case "STSPIN3204">
  STEVAL_SPIN3204_MOTOR_DRIVER_Init();
  STEVAL_SPIN3204_MOTOR_DRIVER_SetOcVis(STSPIN32F0A_OC_VIS_FROM_MCU);
  STEVAL_SPIN3204_MOTOR_DRIVER_SetOcTh(STSPIN32F0A_OC_TH_500mV);

  MC_Core_AssignTimers( pMCIList[0], (uint32_t *)&htim1, (uint32_t *)&htim2, (uint32_t *)&htim3 );
<#if MC.SIX_STEP_SENSING == "SENSORS_LESS"><#-- Sensorless usage -->
  MC_Core_ConfigureBemfAdc( pMCIList[0], (uint32_t *)&hadc, ${pTrigTim}, ${TrigTimChannel} );
  MC_Core_ConfigureBemfAdcChannel( pMCIList[0], STEVAL_SPIN3204_ADC_BEMF_CH1, STEVAL_SPIN3204_ADC_BEMF_ST, MC_BEMF_PHASE_1 );
  MC_Core_ConfigureBemfAdcChannel( pMCIList[0], STEVAL_SPIN3204_ADC_BEMF_CH2, STEVAL_SPIN3204_ADC_BEMF_ST, MC_BEMF_PHASE_2 );
  MC_Core_ConfigureBemfAdcChannel( pMCIList[0], STEVAL_SPIN3204_ADC_BEMF_CH3, STEVAL_SPIN3204_ADC_BEMF_ST, MC_BEMF_PHASE_3 );
</#if>

  MC_Core_ConfigureUserAdc( pMCIList[0], ${pTrigTim}, ${TrigTimChannel} );
  MC_Core_ConfigureUserAdcChannel( pMCIList[0], (uint32_t *)&hadc, STEVAL_SPIN3204_ADC_SPEED, STEVAL_SPIN3204_ADC_SPEED_ST, MC_USER_MEAS_1 );
  MC_Core_ConfigureUserAdcChannel( pMCIList[0], (uint32_t *)&hadc, STEVAL_SPIN3204_ADC_CURRENT, STEVAL_SPIN3204_ADC_CURRENT_ST, MC_USER_MEAS_2 );
  MC_Core_ConfigureUserAdcChannel( pMCIList[0], (uint32_t *)&hadc, STEVAL_SPIN3204_ADC_VBUS, STEVAL_SPIN3204_ADC_VBUS_ST, MC_USER_MEAS_3 );
  MC_Core_ConfigureUserAdcChannel( pMCIList[0], (uint32_t *)&hadc, STEVAL_SPIN3204_ADC_TEMP, STEVAL_SPIN3204_ADC_TEMP_ST, MC_USER_MEAS_4 );
  MC_Core_ConfigureUserAdcChannel( pMCIList[0], (uint32_t *)&hadc, STEVAL_SPIN3204_ADC_VREF, STEVAL_SPIN3204_ADC_VREF_ST, MC_USER_MEAS_5 );

  MC_Core_ConfigureUserButton( pMCIList[0], (uint16_t) USER1_LED_BUTTON_Pin, (uint16_t) 500 );
  <#break>

  <#default>
  #error "This platform is not supported for 6-Steps"
  <#break>
</#switch>

  if ( MC_Core_Init( pMCIList[0] ) != MC_FUNC_OK )
  {
    Error_Handler();
  }

<#-- Needed for the TERATERM usage, removed for the ST MCWB usage -->
<#if MC.SERIAL_COMMUNICATION == false>
	<#if (CondFamily_STM32G4 == true) || (CondMcu_STM32F401xxx == true)>
  if (MC_Com_Init((uint32_t *)&huart2) != MC_FUNC_OK)
  {
    Error_Handler();
  }
	<#elseif (CondFamily_STM32F0 == true)>
  if (MC_Com_Init((uint32_t *)&huart1) != MC_FUNC_OK)
  {
    Error_Handler();
  }
	<#else>
	  #error "This platform is not supported for 6-Steps"
	</#if>
</#if>
}

/**
  * @}  end MC_LIB_6STEP
  */

/**
  * @}  end MIDDLEWARES
  */

/******************* (C) COPYRIGHT 2019 STMicroelectronics *****END OF FILE****/
