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
/**
  ******************************************************************************
  * @file    ui_task.h
  * @author  Motor Control SDK Team, ST Microelectronics
  * @brief   Interface of user interface tasks
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
#ifndef __UITASK_H
#define __UITASK_H

#include "user_interface.h"
<#-- DAC usage for monitoring -->
<#if MC.DAC_FUNCTIONALITY == true>
#include "dac_rctimer_ui.h"
#include "dac_ui.h"
</#if>

<#-- ST MCWB monitoring usage management (used when MC.SERIAL_COMMUNICATION == true) -->
<#if MC.DRIVE_TYPE == "FOC" || MC.SERIAL_COMMUNICATION == true><#-- TODO: PBo, Is this condition (MC.DRIVE_TYPE == "FOC") really needed ? -->
#include "motor_control_protocol.h"
#include "frame_communication_protocol.h"
#include "usart_frame_communication_protocol.h"
	<#if false> 
#if 0 /* Cubify it first */
#include "unidirectional_fast_com.h"
#endif /* 0 */
	</#if>
#include "ui_irq_handler.h"
</#if>

/* Exported functions --------------------------------------------------------*/
<#switch MC.DRIVE_TYPE>
	<#case "FOC">
void UI_TaskInit(uint32_t* pUICfg, uint8_t bMCNum, MCI_Handle_t * pMCIList[],
                 MCT_Handle_t* pMCTList[],const char* s_fwVer);
	<#break>
	
	<#case "SIX_STEP">
void UI_TaskInit( uint32_t* pUICfg, uint8_t bMCNum, MC_Handle_t * pMCIList[], const char* s_fwVer );
	<#break>
	
	<#default>
	#error "This other algorithm is not supported"
	<#break>
</#switch>

<#-- DAC usage for monitoring -->
<#if MC.DAC_FUNCTIONALITY == true>
void UI_DACUpdate(uint8_t bMotorNbr);
UI_Handle_t * GetDAC(void);
</#if>

<#-- Specific to FOC algorithm usage -->
<#if MC.DRIVE_TYPE == "FOC">
void UI_Scheduler(void);
MCP_Handle_t * GetMCP(void);

bool UI_IdleTimeHasElapsed(void);
void UI_SetIdleTime(uint16_t SysTickCount);
bool UI_SerialCommunicationTimeOutHasElapsed(void);
bool UI_SerialCommunicationATRTimeHasElapsed(void);
void UI_SerialCommunicationTimeOutStop(void);
void UI_SerialCommunicationTimeOutStart(void);

	<#if MC.START_STOP_BTN == true>
void UI_HandleStartStopButton_cb (void);
	</#if>
</#if>

#endif /* __UITASK_H */

/******************* (C) COPYRIGHT 2019 STMicroelectronics *****END OF FILE****/
