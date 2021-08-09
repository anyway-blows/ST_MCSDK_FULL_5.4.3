<#ftl strip_whitespace = true>
<#-- Mode containing the Drive Type for early 6-step integration phase. 
     Contains either MC_Init or MC_SixStep -->
<#assign DriveTypeRoot = IPdatas[0].configModelList[0].configs[0].name>
/**
  ******************************************************************************
  * @file    motorcontrol.c 
  * @author  Motor Control SDK Team, ST Microelectronics
  * @brief   Motor Control Subsystem initialization functions.
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
#include "main.h"
<#if DriveTypeRoot == "MC_FOC"><#-- Specific to FOC algorithm usage -->
#include "mc_tuning.h"
#include "mc_interface.h"
#include "mc_tasks.h"
<#elseif DriveTypeRoot == "MC_SixStep"><#-- Specific to 6_STEP algorithm usage -->
#include "6step_init.h"
	<#if false>
<#-- TODO : PBo, This is probably not needed anymore here -->
#include "adc.h"
#include "tim.h"
#include "usart.h"
	</#if>
#include "6step_conf.h"
</#if>
#include "ui_task.h"
#include "motorcontrol.h"

/** @addtogroup MCSDK
  * @{
  */

/** @addtogroup MCAPI
  * @{
  */

#define FIRMWARE_VERS "ST MC SDK\tVer.5.4.3"
const char s_fwVer[32] = FIRMWARE_VERS;

<#if DriveTypeRoot == "MC_FOC"><#-- Specific to FOC algorithm usage -->
MCI_Handle_t* pMCI[NBR_OF_MOTORS];
MCT_Handle_t* pMCT[NBR_OF_MOTORS];
uint32_t wConfig[NBR_OF_MOTORS] = {UI_CONFIG_M1,UI_CONFIG_M2};
<#elseif DriveTypeRoot == "MC_SixStep"><#-- Specific to 6_STEP algorithm usage -->
MC_Handle_t * pMCI[NUMBER_OF_DEVICES];
extern MC_Handle_t Motor_Device1;
</#if>


/**
 * @brief Initializes and configures the Motor Control Subsystem
 *
 *  This function initializes and configures all the structures and components needed
 * for the Motor Control subsystem required by the Application. It expects that
 * all the peripherals needed for Motor Control purposes are already configured but
 * that their interrupts are not enabled yet. 
 *
 * CubeMX calls this function after all peripherals initializations and 
 * before the NVIC is configured
 */
__weak void MX_MotorControl_Init(void) 
{
<#if DriveTypeRoot == "MC_FOC"><#-- Specific to FOC algorithm usage -->
	<#if !FREERTOS??>
		<#if isHALUsed??>
  /* Reconfigure the SysTick interrupt to fire every 500 us. */
  HAL_SYSTICK_Config(HAL_RCC_GetHCLKFreq()/SYS_TICK_FREQUENCY);
		<#else>
  LL_RCC_ClocksTypeDef RCC_Clocks;
  
  /* Reconfigure the SysTick interrupt to fire every 500 us. */
  LL_RCC_GetSystemClocksFreq(&RCC_Clocks);
  SysTick_Config(RCC_Clocks.HCLK_Frequency/SYS_TICK_FREQUENCY);

		</#if>  
	</#if>
  /* Initialize the Motor Control Subsystem */
  MCboot(pMCI,pMCT);
  mc_lock_pins();
  
  /* Initialize the MC User Interface */
  UI_TaskInit(wConfig,NBR_OF_MOTORS,pMCI,pMCT,s_fwVer);
<#elseif DriveTypeRoot == "MC_SixStep"><#-- Specific to 6_STEP algorithm usage -->
  pMCI[0] = &Motor_Device1;

  /* Initialize the Motor Control Subsystem */
  MCboot( pMCI );
  
  /* Initialize the MC User Interface */
  UI_TaskInit( 0, NUMBER_OF_DEVICES, pMCI, s_fwVer );
</#if>
}

<#if FREERTOS??>
void vPortSetupTimerInterrupt( void )
{
	<#if isHALUsed??>
  /* Reconfigure the SysTick interrupt to fire every 500 us. */
  HAL_SYSTICK_Config(HAL_RCC_GetHCLKFreq()/SYS_TICK_FREQUENCY);
	<#else>
  LL_RCC_ClocksTypeDef RCC_Clocks;
  
  /* Reconfigure the SysTick interrupt to fire every 500 us. */
  LL_RCC_GetSystemClocksFreq(&RCC_Clocks);
  SysTick_Config(RCC_Clocks.HCLK_Frequency/SYS_TICK_FREQUENCY);

	</#if> 
}
</#if>
/**
  * @}
  */

/**
  * @}
  */

/******************* (C) COPYRIGHT 2019 STMicroelectronics *****END OF FILE****/
