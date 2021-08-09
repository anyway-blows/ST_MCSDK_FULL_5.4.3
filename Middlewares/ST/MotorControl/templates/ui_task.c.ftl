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
<#-- Condition for STM32F302x8x MCU -->
<#assign CondMcu_STM32F302x8x = (McuName?? && McuName?matches("STM32F302.8.*"))>
<#-- Condition for STM32F072xxx MCU -->
<#assign CondMcu_STM32F072xxx = (McuName?? && McuName?matches("STM32F072.*"))>
<#-- Condition for STM32F446xCx or STM32F446xEx -->
<#assign CondMcu_STM32F446xCEx = (McuName?? && McuName?matches("STM32F446.(C|E).*"))>
<#-- Condition for Line STM32F1xx Value -->
<#assign CondLine_STM32F1_Value = (McuName?? && (McuName?matches("STM32F100.(4|6|8|B).*")))>
<#-- Condition for Line STM32F1xx Value, Medium Density -->
<#assign CondLine_STM32F1_Value_MD = (McuName?? && (McuName?matches("STM32F100.(8|B).*")))>
<#-- Condition for Line STM32F1xx Performance -->
<#assign CondLine_STM32F1_Performance = (McuName?? && McuName?matches("STM32F103.(4|6|8|B).*"))>
<#-- Condition for Line STM32F1xx Performance, Medium Density -->
<#assign CondLine_STM32F1_Performance_MD = (McuName?? && McuName?matches("STM32F103.(8|B).*"))>
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
/**
  ******************************************************************************
  * @file    ui_task.c
  * @author  Motor Control SDK Team, ST Microelectronics
  * @brief   This file implementes user interface tasks definition
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

/* Includes ------------------------------------------------------------------*/
/* Pre-compiler coherency check */

#include "ui_task.h"
#include "mc_config.h"
<#-- Specific to FOC algorithm usage -->
<#if MC.DRIVE_TYPE == "FOC">
#include "parameters_conversion.h"
	<#-- Communication Direction with the FOC algorithm -->
	<#if MC.SERIAL_COMMUNICATION == true && MC.SERIAL_COM_MODE == "COM_UNIDIRECTIONAL">
#include "unidirectional_fast_com.h"
	</#if>
	<#if MC.START_STOP_BTN == true>
#include "mc_api.h"
	</#if>

#define OPT_DACX  0x20 /*!<Bit field indicating that the UI uses SPI AD7303 DAC.*/
</#if>

<#-- DAC usage for monitoring -->
<#if MC.DAC_FUNCTIONALITY == true> 
DAC_UI_Handle_t * pDAC = MC_NULL;
extern DAC_UI_Handle_t DAC_UI_Params;
</#if>

<#-- ST MCWB monitoring usage management (used when MC.SERIAL_COMMUNICATION == true) -->
<#if MC.SERIAL_COMMUNICATION == true>
MCP_Handle_t * pMCP = MC_NULL;
MCP_Handle_t MCP_UI_Params; 

	<#-- Communication Direction with the FOC algorithm -->
	<#if MC.SERIAL_COM_MODE == "COM_UNIDIRECTIONAL">
UDFastCom_Handle_t *pUFC = MC_NULL;
UDFastCom_Handle_t UFC;
	</#if>
</#if>

<#-- Specific to FOC algorithm usage -->
<#if MC.DRIVE_TYPE == "FOC">
static volatile uint16_t  bUITaskCounter;
static volatile uint16_t  bCOMTimeoutCounter;
static volatile uint16_t  bCOMATRTimeCounter = SERIALCOM_ATR_TIME_TICKS;
</#if>

<#if MC.DRIVE_TYPE == "FOC"><#-- Specific to FOC algorithm usage -->
void UI_TaskInit( uint32_t* pUICfg, uint8_t bMCNum, MCI_Handle_t* pMCIList[],
                  MCT_Handle_t* pMCTList[],const char* s_fwVer )
<#elseif MC.DRIVE_TYPE == "SIX_STEP"><#-- Specific to 6_STEP algorithm usage -->
void UI_TaskInit( uint32_t* pUICfg, uint8_t bMCNum, MC_Handle_t * pMCIList[], const char* s_fwVer )
</#if>
{
<#-- DAC usage for monitoring -->
<#if MC.DAC_FUNCTIONALITY == true>
      pDAC = &DAC_UI_Params;      
      pDAC->_Super = UI_Params;

	<#if MC.DRIVE_TYPE == "FOC"><#-- Specific to FOC algorithm usage -->
      UI_Init( &pDAC->_Super, bMCNum, pMCIList, pMCTList, pUICfg ); /* Init UI and link MC obj */
	<#elseif MC.DRIVE_TYPE == "SIX_STEP"><#-- Specific to 6_STEP algorithm usage -->
      UI_Init( &pDAC->_Super, bMCNum, pMCIList, pUICfg ); /* Init UI and link MC obj */
	</#if>
      UI_DACInit( &pDAC->_Super ); /* Init DAC */
      UI_SetDAC( &pDAC->_Super, DAC_CH0, ${MC.DEFAULT_DAC_CHANNEL_1} );
      UI_SetDAC( &pDAC->_Super, DAC_CH1, ${MC.DEFAULT_DAC_CHANNEL_2} );
</#if>

<#-- ST MCWB monitoring usage management (used when MC.SERIAL_COMMUNICATION == true) -->
<#if MC.SERIAL_COMMUNICATION == true>
	<#-- Communication Direction with the FOC algorithm -->
	<#-- Communication is bi-directional for the 6_STEP algorithm -->
	<#if MC.SERIAL_COM_MODE == "COM_BIDIRECTIONAL">
    pMCP = &MCP_UI_Params;
    pMCP->_Super = UI_Params;

    UFCP_Init( & pUSART );
		<#-- DAC usage for monitoring -->
		<#if MC.DAC_FUNCTIONALITY == true>
    MCP_Init(pMCP, (FCP_Handle_t *) & pUSART, & UFCP_Send, & UFCP_Receive, & UFCP_AbortReceive, pDAC, s_fwVer);
		<#else>
    MCP_Init(pMCP, (FCP_Handle_t *) & pUSART, & UFCP_Send, & UFCP_Receive, & UFCP_AbortReceive, s_fwVer);
		</#if>
		<#if MC.DRIVE_TYPE == "FOC"><#-- Specific to FOC algorithm usage -->
    UI_Init( &pMCP->_Super, bMCNum, pMCIList, pMCTList, pUICfg ); /* Initialize UI and link MC components */
		<#elseif MC.DRIVE_TYPE == "SIX_STEP"><#-- Specific to 6_STEP algorithm usage -->
    UI_Init( &pMCP->_Super, bMCNum, pMCIList, pUICfg ); /* Initialize UI and link MC components */
		</#if>
	</#if>

	<#if MC.SERIAL_COM_MODE == "COM_UNIDIRECTIONAL">
    pUFC = &UFC;
    UFC_Init(pUFC, &UFCParams_str);
		<#if MC.DRIVE_TYPE == "FOC"><#-- Specific to FOC algorithm usage -->
    UI_Init( &pUFC->_Super, bMCNum, pMCIList, pMCTList, pUICfg ); /* Init UI and link MC obj */
		<#elseif MC.DRIVE_TYPE == "SIX_STEP"><#-- TODO: PBo, Should be removed for 6 steps algorithm -->
    UI_Init( &pUFC->_Super, bMCNum, pMCIList, pUICfg ); /* Init UI and link MC obj */
		</#if>
    UFC_StartCom(pUFC); /* Start transmission */
	</#if> 
<#else>
	<#-- Communication is bi-directional for the 6_STEP algorithm -->
	<#if MC.DRIVE_TYPE == "SIX_STEP"> 
	<#-- Current integration of 6 Step algorithm always use the UART communication mechanism.
		If MC.SERIAL_COMMUNICATION == true, this is the Frame Control Protocol + Motor
		Control Protocol stack that is used.
		Otherwise, this is the terminal like interface delivered with the original 6-Step code.
    -->
  if (MC_Com_Init((uint32_t *)UI_Params.pUART) != MC_FUNC_OK)
  {
    Error_Handler();
  }
	</#if>
</#if><#-- MC.SERIAL_COMMUNICATION == true -->
}

<#-- Specific to FOC algorithm usage -->
<#if MC.DRIVE_TYPE == "FOC">
__weak void UI_Scheduler(void)
{
  if(bUITaskCounter > 0u)
  {
    bUITaskCounter--;
  }

  if(bCOMTimeoutCounter > 1u)
  {
    bCOMTimeoutCounter--;
  }

  if(bCOMATRTimeCounter > 1u)
  {
    bCOMATRTimeCounter--;
  }
}

	<#-- DAC usage for monitoring -->
	<#if MC.DAC_FUNCTIONALITY == true>
__weak void UI_DACUpdate(uint8_t bMotorNbr)
{
  if (UI_GetSelectedMC(&pDAC->_Super) == bMotorNbr)
  {  
    UI_DACExec(&pDAC->_Super); /* Exec DAC update */
  }
}

__weak void MC_SetDAC(DAC_Channel_t bChannel, MC_Protocol_REG_t bVariable)
{
  UI_SetDAC(&pDAC->_Super, bChannel, bVariable);
}

__weak void MC_SetUserDAC(DAC_UserChannel_t bUserChNumber, int16_t hValue)
{
  UI_SetUserDAC(&pDAC->_Super, bUserChNumber, hValue);
}

__weak UI_Handle_t * GetDAC(void)
{
  return &pDAC->_Super;
}
	</#if> 

	<#-- ST MCWB monitoring usage management (used when MC.SERIAL_COMMUNICATION == true) -->
	<#if MC.SERIAL_COMMUNICATION == true>
__weak MCP_Handle_t * GetMCP(void)
{
  return pMCP;
}
	</#if>

__weak bool UI_IdleTimeHasElapsed(void)
{
  bool retVal = false;
  if (bUITaskCounter == 0u)
  {
    retVal = true;
  }
  return (retVal);
}

__weak void UI_SetIdleTime(uint16_t SysTickCount)
{
  bUITaskCounter = SysTickCount;
}

__weak bool UI_SerialCommunicationTimeOutHasElapsed(void)
{
  bool retVal = false;
  if (bCOMTimeoutCounter == 1u)
  {
    bCOMTimeoutCounter = 0u;
    retVal = true;
  }
  return (retVal);
}

__weak bool UI_SerialCommunicationATRTimeHasElapsed(void)
{
  bool retVal = false;
  if (bCOMATRTimeCounter == 1u)
  {
    bCOMATRTimeCounter = 0u;
    retVal = true;
  }
  return (retVal);
}

	<#if FREE_RTOS??>
	<#else>
__weak void UI_SerialCommunicationTimeOutStop(void)
{
  bCOMTimeoutCounter = 0u;
}

__weak void UI_SerialCommunicationTimeOutStart(void)
{
  bCOMTimeoutCounter = SERIALCOM_TIMEOUT_OCCURENCE_TICKS;
}
	</#if> 

	<#if MC.START_STOP_BTN == true>
__weak void UI_HandleStartStopButton_cb (void)
{
/* USER CODE BEGIN START_STOP_BTN */
  if (MC_GetSTMStateMotor1() == IDLE)
  {
    /* Ramp parameters should be tuned for the actual motor */
    MC_StartMotor1();
  }
  else
  {
    MC_StopMotor1();
  }
/* USER CODE END START_STOP_BTN */
}
	</#if>
</#if><#-- MC.DRIVE_TYPE == "FOC" -->

/******************* (C) COPYRIGHT 2019 STMicroelectronics *****END OF FILE****/
