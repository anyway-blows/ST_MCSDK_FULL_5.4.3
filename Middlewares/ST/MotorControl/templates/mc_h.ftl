<#ftl>
<#-- Mode containing the Drive Type for early 6-step integration phase. 
     Contains either MC_Init or MC_SixStep -->
<#assign DriveTypeRoot = IPdatas[0].configModelList[0].configs[0].name>
/**
  ******************************************************************************
  * @file    motorcontrol.h
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
  * @ingroup MCAPI
  */

/* Define to prevent recursive inclusion -------------------------------------*/
#ifndef __MOTORCONTROL_H
#define __MOTORCONTROL_H
<#if DriveTypeRoot == "MC_FOC">
#include "mc_config.h"
#include "parameters_conversion.h"
#include "mc_api.h"

#ifdef __cplusplus
 extern "C" {
#endif /* __cplusplus */

/** @addtogroup MCSDK
  * @{
  */

/** @addtogroup MCAPI
  * @{
  */

/* Initializes the Motor Control Subsystem */
void MX_MotorControl_Init(void);

<#-- If HAL is used to initialize any of the IPs in the system (including the MotorControl "Middleware"),
     we need to make sure that we handle HAL's SysTick well: calling HAL_IncTick() and 
     HAL_SYSTICK_IRQHandler() when needed according to the SYSTICK_DIVIDER parameter. This is done in the 
     stm32f*_mc_it.c.ftl files.
     
     On the contrary, when only the LL are used (including by the MotorControl "Middleware" ), we must 
     not call neither HAL_IncTick() nor HAL_SYSTICK_IRQHandler() as they are not defined in such a case.
     
     Whether the initialization of an IP is done with the HAL or the LL is decided by the user in CubeMx 
     (Project->Project Settings menu item, Advanced Settings tab, Driver Selector section) and the information 
     is passed to mc_c.ftl and mc_h.ftl templates only, thanks to the isHALUsed variable. 
     
     However, variable isHALUsed is not present in the datamodel of the stm32f*_mc_it.c.ftl templates. To
     work around this issue, an MC_HAL_IS_USED symbol is defined if isHALUsed exists. This symbol is used 
     in stm32f*_mc_it.c.ftl files to introduce the relevant code.
     
     This is an ugly hack.    
 -->
<#if isHALUsed??>
/* Do not remove the definition of this symbol. */
#define MC_HAL_IS_USED
</#if>
/**
  * @}
  */

/**
  * @}
  */

#ifdef __cplusplus
}
#endif /* __cpluplus */
<#elseif DriveTypeRoot == "MC_SixStep">

/* Initializes the Motor Control Subsystem */
<#-- This is not the right place to include this file. It would be better to include it in 6step_conf.h -->
#include "6step_core.h"

#ifdef __cplusplus
 extern "C" {
#endif /* __cplusplus */


void MX_MotorControl_Init(void);

#ifdef __cplusplus
}
#endif /* __cpluplus */
</#if> <#-- DriveTypeRoot -->

#endif /* __MOTORCONTROL_H */
/******************* (C) COPYRIGHT 2019 STMicroelectronics *****END OF FILE****/
