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
/**
 ******************************************************************************
 * @file    6step_com.c
 * @author  IPC Rennes & Motor Control SDK, ST Microelectronics
 * @brief   This file provides all the 6-step library com functions
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

/* Includes ------------------------------------------------------------------*/
#include "6step_com.h"

/** @addtogroup MIDDLEWARES
  * @brief  Middlewares Layer
  * @{ 
  */

/** @addtogroup MC_LIB_6STEP
  * @{
  */

/** @defgroup MC_6STEP_COM 
  * @brief 6step core module
  * @{
  */ 

/** @defgroup MC_6STEP_COM_Private_TypesDefinitions
  * @{
  */ 
typedef struct {
  char name[10];
  MC_FuncStatus_t (*pCmdFunc)(void);
} MC_COM_Command_t;

typedef struct {
  MC_Status_t status;
  char status_string[35];
} MC_COM_Status_t;

/**
  * @} end MC_6STEP_COM_Private_TypesDefinitions
  */ 

/** @defgroup MC_6STEP_COM_Private_Defines
  * @{
  */
#define MC_COM_RX_BUFFER_MAX  10
#define MC_COM_TOKEN          "\r"

/* Command numbering shall be consecutive */
#define STARTM_CMD  ((uint8_t) 0)     /*!<  Start Motor command received */
#define STOPMT_CMD  ((uint8_t) 1)     /*!<  Stop Motor command received */
#define SETSPD_CMD  ((uint8_t) 2)     /*!<  Set the new speed value command received */
#define GETSPD_CMD  ((uint8_t) 3)     /*!<  Get Mechanical Motor Speed command received */
#define INIDCY_CMD  ((uint8_t) 4)     /*!<  Set the new STARTUP_DUTY_CYCLE value command received */
#define POLESP_CMD  ((uint8_t) 5)     /*!<  Set the Pole Pairs value command received */
#define ACCELE_CMD  ((uint8_t) 6)     /*!<  Set the Accelleration for Start-up of the motor command received */
#define DMGCTR_CMD  ((uint8_t) 7)     /*!<  Enable the DEMAG dynamic control command received */
#define MAXDMG_CMD  ((uint8_t) 8)     /*!<  Set the BEMF Demagn MAX command received */
#define MINDMG_CMD  ((uint8_t) 9)     /*!<  Set the BEMF Demagn MIN command received */
#define KP_PRM_CMD  ((uint8_t) 10)    /*!<  Set the KP PI param command received */
#define KI_PRM_CMD  ((uint8_t) 11)    /*!<  Set the KI PI param command received */
#define MEASEL_CMD  ((uint8_t) 12)    /*!<  Set the continuous measurement to be performed */
#define HELP_CMD    ((uint8_t) 13)    /*!<  Help command received */
#define STATUS_CMD  ((uint8_t) 14)    /*!<  Get the Status of the system command received */
#define SETDIR_CMD  ((uint8_t) 15)    /*!<  Set the motor direction */
#define SETDCY_CMD  ((uint8_t) 16)    /*!<  Set the HF PWM duty cycle */
#define SELMOT_CMD  ((uint8_t) 17)    /*!<  Select the motor device on which to apply to apply the subsequent commands */
#define SETABT_CMD  ((uint8_t) 18)    /*!<  Set the trig time in the timer period for the ADC used for the BEMF sensing */
#define SETFRQ_CMD  ((uint8_t) 19)    /*!<  Set the HF PWM frequency */
#define SETAUT_CMD  ((uint8_t) 20)    /*!<  Set the trig time in the timer period for the ADC used for the USER measurements */

#define CMD_NUM     ((uint8_t) 20)    /*!<  Number of defined commands */

/**
  * @} end MC_6STEP_COM_Private_Defines
  */ 

/** @defgroup MC_6STEP_COM_Private_Macros
  * @{
  */
#define COUNTOF(__BUFFER__)   (sizeof(__BUFFER__) / sizeof(*(__BUFFER__)))

/**
  * @} end MC_6STEP_COM_Private_Macros
  */ 

/** @defgroup MC_6STEP_COM_Private_Functions_Prototypes
  * @{
  */
MC_FuncStatus_t MC_Com_CommandParser(char* pCommandString);
MC_FuncStatus_t MC_Com_GetSpeed(void);
MC_FuncStatus_t MC_Com_MessageDirection(void);
MC_FuncStatus_t MC_Com_MessageInsert(void);
MC_FuncStatus_t MC_Com_Prompt(void);
MC_FuncStatus_t MC_Com_SelectMotor(void);
MC_FuncStatus_t MC_Com_SetAdcBemfTrigTime(void);
MC_FuncStatus_t MC_Com_SetAdcUserTrigTime(void);
MC_FuncStatus_t MC_Com_SetSpeed(void);
MC_FuncStatus_t MC_Com_SetDutyCycle(void);
MC_FuncStatus_t MC_Com_SetStartupDutyCycle(void);
MC_FuncStatus_t MC_Com_SetDirection(void);
MC_FuncStatus_t MC_Com_SetGateDriverPwmFreq(void);
MC_FuncStatus_t MC_Com_Start(void);
MC_FuncStatus_t MC_Com_Stop(void);
MC_FuncStatus_t MC_ComVar_SetAdcBemfTrigTime(MC_Handle_t* pMcComMotorSelected, uint32_t McComValueToSet);

<#-- Specific to STM32F0 usage -->
<#if (CondFamily_STM32F0 == true)>
HAL_StatusTypeDef UART_EndTransmit_IT(UART_HandleTypeDef *huart);
HAL_StatusTypeDef UART_Receive_IT(UART_HandleTypeDef *huart);
</#if>

/**
  * @} end MC_6STEP_COM_Private_Functions_Prototypes
  */

/** @defgroup MC_6STEP_COM_Private_Constants
* @{
*/
const MC_COM_Command_t MC_ComCommandTable[] = {
  {"GETSPD", MC_Com_GetSpeed},
  {"GETSTA", MC_Com_GetStatus},
  {"INIDCY", MC_Com_SetStartupDutyCycle},
  {"SELMOT", MC_Com_SelectMotor},
  {"SETABT", MC_Com_SetAdcBemfTrigTime}, 
  {"SETAUT", MC_Com_SetAdcUserTrigTime},  
  {"SETDIR", MC_Com_SetDirection},
  {"SETDCY", MC_Com_SetDutyCycle},
  {"SETFRQ", MC_Com_SetGateDriverPwmFreq},  
  {"SETSPD", MC_Com_SetSpeed},
  {"STARTM", MC_Com_Start},
  {"STOPMT", MC_Com_Stop},
  {"\r\n", MC_Com_Prompt},
  {"", NULL}
};

const MC_COM_Status_t MC_ComStatusTable[] = {
  {MC_IDLE,">>Status: IDLE\r\n >"},
  {MC_STOP,">>Status: STOP\r\n >"},
  {MC_ALIGNMENT,">>Status: ALIGNMENT\r\n >"},
  {MC_STARTUP,">>Status: STARTUP\r\n >"},
  {MC_VALIDATION,">>Status: VALIDATION\r\n >"},  
  {MC_RUN,">>Status: RUN\r\n >"},
  {MC_SPEEDFBKERROR,">>Status: SPEEDFBKERROR\r\n >"},
  {MC_OVERCURRENT,">>Status: OVERCURRENT\r\n >"},
  {MC_VALIDATION_FAILURE,">>Status: VALIDATION_FAIL\r\n >"},
  {MC_VALIDATION_BEMF_FAILURE,">>Status: VALIDATION_BEMF_FAIL\r\n >"},
  {MC_VALIDATION_HALL_FAILURE,">>Status: VALIDATION_HALL_FAIL\r\n >"},  
  {MC_LF_TIMER_FAILURE,">>Status: LF_TIMER_FAILURE\r\n >"},
  {MC_ADC_CALLBACK_FAILURE,">>Status: ADC_CALLBACK_FAILURE\r\n >"}
};

/**
  * @} end MC_6STEP_COM_Private_Constants
  */ 

/** @defgroup MC_6STEP_COM_Private_Variables
  * @{
  */
UART_HandleTypeDef *pMcComConf;
uint8_t McComConfTxReply;                         /*!< Transmission on-going */
uint8_t McComConfTxDifferedReply;                 /*!< Transmission differed */ 
uint8_t McComConfTxContinousSpeedMode;            /*!< Speed measurement reporting is selected when not equal to 0 */ 
uint8_t McComConfTxContinousSpeedAllowed;         /*!< Speed measurement is reported when not equal to 0 */
uint8_t McComConfTxContinousBemfMode;             /*!< Bemf measurement reporting is selected when not equal to 0 */ 
uint8_t McComConfTxContinousBemfAllowed;          /*!< Bemf measurement is reported when not equal to 0 */
uint8_t aMcComConfTxBuffer[MC_COM_TX_BUFFER_MAX]; /*!< Buffer used for transmission */

MC_Handle_t * pMcComMotorSelected;
uint32_t McComValueToSet;
uint32_t McComCommandToSet;
static uint16_t McComCommandFlag;
uint8_t McComReceiveFlag;                       /*!< Commmunication flag */
uint8_t aMcComRxBuffer[MC_COM_RX_BUFFER_MAX];   /*!< Buffer used for reception */
uint8_t aMcComTxBuffer[MC_COM_TX_BUFFER_MAX];   /*!< Buffer used for transmission */
uint8_t aMcComTxBufferPrompt[] = " >";
uint8_t aMcComTxBufferNewLine[] = "\n\r";
uint8_t aMcComTxBufferStarLine[] = "*******************\n\r";
uint8_t aMcComTxBufferLibTitle[] = "* 6 STEP LIB *\n\r";
uint8_t aMcComTxBufferList[] = "List of commands:\n\r\n\r";
uint8_t aMcComTxBufferStart[] = " <STARTM> Start Motor\n\r";
uint8_t aMcComTxBufferStop[] = " <STOPMT> Stop Motor\n\r";
uint8_t aMcComTxBufferSelMot[] = " <SELMOT> Select Motor\n\r";
uint8_t aMcComTxBufferSetDir[] = " <SETDIR> Set Motor Direction\n\r";
uint8_t aMcComTxBufferSetSpeed[] = " <SETSPD> Set Motor Speed\n\r";
uint8_t aMcComTxBufferSetDcy[] = " <SETDCY> Set Motor Pwm Duty Cycle\n\r";
uint8_t aMcComTxBufferSetFrq[] = " <SETFRQ> Set Motor Pwm Frequency\n\r";
uint8_t aMcComTxBufferGetSpeed[] = " <GETSPD> Get Motor Speed\n\r";
uint8_t aMcComTxBufferGetStatus[] = " <GETSTA> Get Motor Status\n\r";
uint8_t aMcComTxBufferInsert[] = ">> Insert the value:\n\r";
uint8_t aMcComTxBufferDirection[] = ">> CW <0> CCW <1>:\n\r";
uint8_t aMcComTxBufferOk[] = ">> OK <<\n\r >";
uint8_t aMcComTxBufferError[] = ">> ERROR - PLEASE TYPE AGAIN ! <<\n\r >";

/**
  * @} end MC_6STEP_COM_Private_Variables
  */ 

/** @defgroup MC_6STEP_COM_Private_Functions
  * @{
  */
MC_FuncStatus_t MC_Com_CommandParser(char* pCommandString)
{
  static uint8_t index;
  char a_command[16];
    
  /* Command extraction */
  if (strncmp(pCommandString,"\r\n",2)==0)
  {
    strcpy(a_command,"\r\n");
  }
  else
  {
    strcpy(a_command, pCommandString);
  }
  strtok(a_command, MC_COM_TOKEN);
  
  /* Command callback identification */
  for(index = 0;MC_ComCommandTable[index].pCmdFunc != NULL; index++)
  {
    if (strcmp(MC_ComCommandTable[index].name, a_command) == 0)
    {
      break;
    }
  }
  if (index <= CMD_NUM)
  {
    // CMD OK --> extract parameters
    /* Check for valid callback */
    if(MC_ComCommandTable[index].pCmdFunc!=NULL)
    {
      MC_ComCommandTable[index].pCmdFunc();
    }
  }
  else
  {
    MC_Com_LL_Reply(aMcComTxBufferError, (COUNTOF(aMcComTxBufferError) - 1));
    McComCommandFlag = 0;
  }

  return MC_FUNC_OK;
}

MC_FuncStatus_t MC_Com_GetSpeed(void)
{
  /* Get Mechanical Motor Speed command received */  
  sprintf((char *)aMcComTxBuffer, ">>Motor Speed: %d RPM\r\n >", (int) MC_Core_GetSpeed(pMcComMotorSelected));
  MC_Com_LL_Reply((uint8_t*)aMcComTxBuffer, sizeof(aMcComTxBuffer));
  return MC_FUNC_OK;
}

MC_FuncStatus_t MC_Com_GetStatus(void)
{ 
  MC_Status_t status = MC_Core_GetStatus(pMcComMotorSelected);
  MC_Com_LL_Reply((uint8_t*) MC_ComStatusTable[status].status_string, sizeof(MC_ComStatusTable[status].status_string));
  return MC_FUNC_OK;
}

MC_FuncStatus_t MC_Com_MessageDirection(void)
{
  MC_Com_LL_Reply(aMcComTxBufferDirection, (COUNTOF(aMcComTxBufferDirection) - 1));
  McComCommandFlag = 1;
  return MC_FUNC_OK;
}

MC_FuncStatus_t MC_Com_MessageInsert(void)
{
  MC_Com_LL_Reply(aMcComTxBufferInsert, (COUNTOF(aMcComTxBufferInsert) - 1));
  McComCommandFlag = 1;
  return MC_FUNC_OK;
}

MC_FuncStatus_t MC_Com_Prompt(void)
{    
  MC_Com_LL_Reply(aMcComTxBufferPrompt, (COUNTOF(aMcComTxBufferPrompt) - 1));
  return MC_FUNC_OK;
}

MC_FuncStatus_t MC_Com_SelectMotor(void)
{    
  MC_Com_MessageInsert();
  McComCommandToSet = SELMOT_CMD;
  return MC_FUNC_OK;
}

MC_FuncStatus_t MC_Com_SetAdcBemfTrigTime(void)
{    
  MC_Com_MessageInsert();
  McComCommandToSet = SETABT_CMD;
  return MC_FUNC_OK;
}

MC_FuncStatus_t MC_Com_SetAdcUserTrigTime(void)
{    
  MC_Com_MessageInsert();
  McComCommandToSet = SETAUT_CMD;
  return MC_FUNC_OK;
}

MC_FuncStatus_t MC_Com_SetDirection(void)
{    
  MC_Com_MessageDirection();
  McComCommandToSet = SETDIR_CMD;
  return MC_FUNC_OK;
}

MC_FuncStatus_t MC_Com_SetDutyCycle(void)
{    
  MC_Com_MessageInsert();
  McComCommandToSet = SETDCY_CMD;
  return MC_FUNC_OK;
}

MC_FuncStatus_t MC_Com_SetGateDriverPwmFreq(void)
{    
  MC_Com_MessageInsert();
  McComCommandToSet = SETFRQ_CMD;
  return MC_FUNC_OK;
}

MC_FuncStatus_t MC_Com_SetStartupDutyCycle(void)
{    
  MC_Com_MessageInsert();
  McComCommandToSet = INIDCY_CMD;
  return MC_FUNC_OK;
}

MC_FuncStatus_t MC_Com_SetSpeed(void)
{    
  MC_Com_MessageInsert();
  McComCommandToSet = SETSPD_CMD;
  return MC_FUNC_OK;
}

MC_FuncStatus_t MC_Com_Start(void)
{
  MC_Core_Start(pMcComMotorSelected);
  MC_Com_LL_Reply(aMcComTxBufferOk, (COUNTOF(aMcComTxBufferOk) - 1));
  return MC_FUNC_OK;
}

MC_FuncStatus_t MC_Com_Stop(void)
{
  MC_Core_Stop(pMcComMotorSelected);
  MC_Com_LL_Reply(aMcComTxBufferOk, (COUNTOF(aMcComTxBufferOk) - 1));
  return MC_FUNC_OK;
}

MC_FuncStatus_t MC_ComVar_SetAdcBemfTrigTime(MC_Handle_t* pMcComMotorSelected, uint32_t McComValueToSet)
{
<#if MC.SIX_STEP_SENSING == "SENSORS_LESS"><#-- SensorLess usage -->
  return MC_Core_SetAdcBemfTrigTime(pMcComMotorSelected, McComValueToSet);
<#else>
  return MC_FUNC_FAIL;
</#if>
}

/**
  * @} end MC_6STEP_COM_Private_Functions
  */

/** @defgroup MC_6STEP_COM_Exported_Functions
  * @{
  */
/**
  * @brief     UART transmit complete callback
  * @param[in] huart UART handle pointer
  * @retval    None
  */
void HAL_UART_TxCpltCallback(UART_HandleTypeDef *huart)
{
  if (McComConfTxReply != FALSE)
  {
    McComConfTxReply = FALSE;
  }
  else if (McComConfTxDifferedReply != FALSE)
  {
    McComConfTxDifferedReply = FALSE;
    McComConfTxReply = TRUE;
    HAL_UART_Transmit_DMA(huart, (uint8_t*)aMcComConfTxBuffer, sizeof(aMcComConfTxBuffer));
  }
  if (McComConfTxContinousSpeedMode != FALSE)
  {
    McComConfTxContinousSpeedAllowed = TRUE;
  }
  else if (McComConfTxContinousBemfMode != FALSE)
  {
    McComConfTxContinousBemfAllowed = TRUE;
  }
}

MC_FuncStatus_t MC_Com_Init(uint32_t *pMcCom)
{
  if (pMcCom == NULL)
  {
    return MC_FUNC_FAIL;
  }
  else
  {
    MC_Com_LL_Init(pMcCom);
  }

  MC_Com_LL_Send(aMcComTxBufferNewLine, (COUNTOF(aMcComTxBufferNewLine) - 1)); 
  MC_Com_LL_Send(aMcComTxBufferStarLine, (COUNTOF(aMcComTxBufferStarLine) - 1));
  MC_Com_LL_Send(aMcComTxBufferLibTitle, (COUNTOF(aMcComTxBufferLibTitle) - 1));
  MC_Com_LL_Send(aMcComTxBufferStarLine, (COUNTOF(aMcComTxBufferStarLine) - 1));
  MC_Com_LL_Send(aMcComTxBufferList, (COUNTOF(aMcComTxBufferList) - 1));
  MC_Com_LL_Send(aMcComTxBufferGetSpeed, (COUNTOF(aMcComTxBufferGetSpeed) - 1));
  MC_Com_LL_Send(aMcComTxBufferGetStatus, (COUNTOF(aMcComTxBufferGetStatus) - 1));
  MC_Com_LL_Send(aMcComTxBufferSelMot, (COUNTOF(aMcComTxBufferSelMot) - 1));  
  MC_Com_LL_Send(aMcComTxBufferSetDir, (COUNTOF(aMcComTxBufferSetDir) - 1));
  MC_Com_LL_Send(aMcComTxBufferSetSpeed, (COUNTOF(aMcComTxBufferSetSpeed) - 1));
  MC_Com_LL_Send(aMcComTxBufferSetDcy, (COUNTOF(aMcComTxBufferSetDcy) - 1));
  MC_Com_LL_Send(aMcComTxBufferSetFrq, (COUNTOF(aMcComTxBufferSetFrq) - 1));  
  MC_Com_LL_Send(aMcComTxBufferStart, (COUNTOF(aMcComTxBufferStart) - 1));
  MC_Com_LL_Send(aMcComTxBufferStop, (COUNTOF(aMcComTxBufferStop) - 1));
  
  /* Initialisation of private variables */
  McComCommandFlag = 0;  
  McComReceiveFlag = TRUE;
  aMcComRxBuffer[0] = '0';
  
  /* Default selection of the first motor */
  pMcComMotorSelected = MC_Core_GetMotorControlHandle(0);
  if (pMcComMotorSelected == NULL)
  {
    return MC_FUNC_FAIL;
  }
  
  /* First call to communication task to initiate the process */
  MC_Com_Task();
  
  return MC_FUNC_OK;
}

MC_FuncStatus_t MC_Com_Irq_Handler(void)
{
  MC_Com_LL_Irq_Handler();
  return MC_FUNC_OK;
}

MC_FuncStatus_t MC_Com_ProcessInput(void)
{
  if(strchr((char*)aMcComRxBuffer,'\n')!=NULL) /* UART parity bit must be set to none : PCE = 0 */
  {
    if(McComCommandFlag == 0)
    {     
      MC_Com_CommandParser((char*)aMcComRxBuffer);
    }
    else
    {
      MC_FuncStatus_t status;
      McComValueToSet = atoi((char*)aMcComRxBuffer);
      switch(McComCommandToSet)
      {
        case SETABT_CMD:  /*!<  Set the BEMF ADC trig time in the HF timer period */
          status = MC_ComVar_SetAdcBemfTrigTime(pMcComMotorSelected, (uint32_t)McComValueToSet);
        break;
        case SETAUT_CMD:  /*!<  Set the USER ADC trig time in the HF timer period */
          status = MC_Core_SetAdcUserTrigTime(pMcComMotorSelected, (uint32_t)McComValueToSet);
        break;
        case SELMOT_CMD:  /*!<  Select the motor device instance on which the subsequent commands will be applied */
          pMcComMotorSelected = MC_Core_GetMotorControlHandle(McComValueToSet);
          if (pMcComMotorSelected == NULL) status = MC_FUNC_FAIL;
          else status = MC_FUNC_OK;
        break;
        case SETFRQ_CMD:  /*!<  Set the HF PWM and REF PWM duty cycle */
          status = MC_Core_SetGateDriverPwmFreq(pMcComMotorSelected, (uint32_t)McComValueToSet);
        break;         
        case SETDCY_CMD:  /*!<  Set the HF PWM or the REF PWM duty cycle */
          status = MC_Core_SetDutyCycle(pMcComMotorSelected, (uint32_t)McComValueToSet);
        break;
        case SETDIR_CMD:  /*!<  Set the motor direction */
          status = MC_Core_SetDirection(pMcComMotorSelected, (uint32_t)McComValueToSet);        
        case SETSPD_CMD:  /*!<  Set the new speed value command received */
          status = MC_Core_SetSpeed(pMcComMotorSelected, (uint32_t)McComValueToSet);
        break;
        case INIDCY_CMD:  /*!<  Set the new STARTUP REFERENCE value command received */   
          status = MC_Core_SetStartupDutyCycle(pMcComMotorSelected, (uint32_t)McComValueToSet);
        break;
        case POLESP_CMD:  /*!<  Set the Pole Pairs value command received */
        break;
        case ACCELE_CMD:  /*!<  Set the Accelleration of the motor command received */
        break;
        break;
        case KP_PRM_CMD:  /*!<  Set the KP PI param command received */
        break;
        case KI_PRM_CMD:  /*!<  Set the KI PI param command received */
        break;
        case MEASEL_CMD:  /*!<  Set the continuous measurement to be performed */
        break;
      }  /* switch case */
      McComCommandFlag = 0;
      if (status == MC_FUNC_OK) MC_Com_LL_Reply(aMcComTxBufferOk, (COUNTOF(aMcComTxBufferOk) - 1));
      else MC_Com_LL_Reply(aMcComTxBufferError, (COUNTOF(aMcComTxBufferError) - 1));
    }
    McComReceiveFlag = TRUE; 
    for(uint8_t index = 0; index < MC_COM_RX_BUFFER_MAX; index++)
    {
      aMcComRxBuffer[index] = 0;
    }
    MC_Com_LL_Receive_Reset((uint8_t *)aMcComRxBuffer);
  }
  return MC_FUNC_OK;
}

MC_FuncStatus_t MC_Com_Task()
{
  if (McComReceiveFlag != FALSE)
  {
    if (MC_Com_LL_Receive_It((uint8_t *)aMcComRxBuffer, MC_COM_RX_BUFFER_MAX) != MC_FUNC_OK)
    {     
      McComReceiveFlag = FALSE;
    }
  }
  return MC_FUNC_OK;  
}

/**
  * @} end MC_6STEP_COM_Exported_Functions
  */

/** @defgroup MC_6STEP_COM_Exported_LL_Functions_Prototypes
  * @{
  */
/**
  * @brief  MC_Com_LL_Init
  * @retval function status
  */
MC_FuncStatus_t MC_Com_LL_Init(uint32_t *pMcCom)
{
  pMcComConf = (UART_HandleTypeDef *) pMcCom;
  return MC_FUNC_OK;
}

/**
  * @brief  MC_Com_LL_Irq_Handler
  * @retval function status
  */
MC_FuncStatus_t MC_Com_LL_Irq_Handler(void)
{
<#-- Specific to STM32F0 usage -->
<#if (CondFamily_STM32F0 == true)>
  uint32_t isrflags   = (uint32_t)(READ_REG(pMcComConf->Instance->ISR));
  uint32_t cr1its     = (uint32_t)(READ_REG(pMcComConf->Instance->CR1));  
  /* UART in mode Receiver ---------------------------------------------------*/
  if(((isrflags & USART_ISR_RXNE) != RESET) && ((cr1its & USART_CR1_RXNEIE) != RESET))
  {
    if ((pMcComConf->gState != HAL_UART_STATE_TIMEOUT) && (pMcComConf->gState != HAL_UART_STATE_ERROR))
    {
      pMcComConf->gState = HAL_UART_STATE_READY;
      pMcComConf->RxState &= ~HAL_UART_STATE_READY;
      pMcComConf->RxState |= HAL_UART_STATE_BUSY_RX;
      if (UART_Receive_IT(pMcComConf)==HAL_OK)
      {
        MC_Com_ProcessInput();
      }
    }
    /* Clear RXNE interrupt flag */
    __HAL_UART_SEND_REQ(pMcComConf, UART_RXDATA_FLUSH_REQUEST);
  }
  /* UART in mode Transmitter (transmission end) -----------------------------*/
  if(((isrflags & USART_ISR_TC) != RESET) && ((cr1its & USART_CR1_TCIE) != RESET))
  {
    UART_EndTransmit_IT(pMcComConf);
  }
</#if>
  return MC_FUNC_OK;
}

/**
  * @brief  MC_Com_LL_Receive_It
  * @param[in]  pString
  * @param[in]  Size
  * @retval function status
  */
MC_FuncStatus_t MC_Com_LL_Receive_It(uint8_t* pString, uint8_t Size)
{
 
  if (HAL_UART_Receive_IT(pMcComConf, pString, Size) !=  HAL_OK)
  {
    pMcComConf->gState = HAL_UART_STATE_READY;
    return MC_FUNC_OK;
  }
  else
  {   
    return MC_FUNC_FAIL;
  }
}

/**
  * @brief  MC_Com_LL_Receive_Reset
  * @param[in]  pString
  * @retval function status
  */
MC_FuncStatus_t MC_Com_LL_Receive_Reset(uint8_t * pString)
{
  pMcComConf->RxXferCount = pMcComConf->RxXferSize;
  pMcComConf->pRxBuffPtr = pString;
  return MC_FUNC_OK;  
}

/**
  * @brief  MC_Com_LL_Send
  * @param[in]  pString
  * @param[in]  Size
  * @retval function status
  */
MC_FuncStatus_t MC_Com_LL_Send(uint8_t* pString, uint8_t Size)
{
  HAL_UART_Transmit(pMcComConf, (uint8_t *)pString, Size, MC_COM_TX_TIMEOUT);
  while (pMcComConf->gState != HAL_UART_STATE_READY)
  {
  }  
  return MC_FUNC_OK;
}

/**
  * @brief  MC_Com_LL_Reply
  * @param[in]  pString
  * @param[in]  Size
  * @retval function status
  */
MC_FuncStatus_t MC_Com_LL_Reply(uint8_t* pString, uint8_t Size)
{
  if (pMcComConf->gState != HAL_UART_STATE_BUSY_TX) 
  {
    McComConfTxReply = TRUE;
    HAL_UART_Transmit_DMA(pMcComConf, (uint8_t *)pString, Size);
  }
  else
  {
    McComConfTxDifferedReply = TRUE;
    strcpy((char *)aMcComConfTxBuffer, (const char *)pString);
  }
  return MC_FUNC_OK;
}

<#-- Specific to STM32F0 usage -->
<#if (CondFamily_STM32F0 == true)>
/**
  * @brief  Receive an amount of data in interrupt mode.
  * @note   Function is called under interruption only, once
  *         interruptions have been enabled by HAL_UART_Receive_IT()
  * @param  huart UART handle.
  * @retval HAL status
  */
HAL_StatusTypeDef UART_Receive_IT(UART_HandleTypeDef *huart)
{
  uint16_t* tmp;
  uint16_t  uhMask = huart->Mask;
  uint16_t  uhdata;

  /* Check that a Rx process is ongoing */
  if(huart->RxState == HAL_UART_STATE_BUSY_RX)
  {
    uhdata = (uint16_t) READ_REG(huart->Instance->RDR);
    if ((huart->Init.WordLength == UART_WORDLENGTH_9B) && (huart->Init.Parity == UART_PARITY_NONE))
    {
      tmp = (uint16_t*) huart->pRxBuffPtr ;
      *tmp = (uint16_t)(uhdata & uhMask);
      huart->pRxBuffPtr +=2U;
    }
    else
    {
      *huart->pRxBuffPtr++ = (uint8_t)(uhdata & (uint8_t)uhMask);
    }

    if(--huart->RxXferCount == 0U)
    {
      /* Disable the UART Parity Error Interrupt and RXNE interrupt*/
      CLEAR_BIT(huart->Instance->CR1, (USART_CR1_RXNEIE | USART_CR1_PEIE));

      /* Disable the UART Error Interrupt: (Frame error, noise error, overrun error) */
      CLEAR_BIT(huart->Instance->CR3, USART_CR3_EIE);

      /* Rx process is completed, restore huart->RxState to Ready */
      huart->RxState = HAL_UART_STATE_READY;

      HAL_UART_RxCpltCallback(huart);

      return HAL_OK;
    }

    return HAL_OK;
  }
  else
  {
    /* Clear RXNE interrupt flag */
    __HAL_UART_SEND_REQ(huart, UART_RXDATA_FLUSH_REQUEST);

    return HAL_BUSY;
  }
}

/**
  * @brief  Wrap up transmission in non-blocking mode.
  * @param  huart pointer to a UART_HandleTypeDef structure that contains
  *               the configuration information for the specified UART module.
  * @retval HAL status
  */
HAL_StatusTypeDef UART_EndTransmit_IT(UART_HandleTypeDef *huart)
{
  /* Disable the UART Transmit Complete Interrupt */
  CLEAR_BIT(huart->Instance->CR1, USART_CR1_TCIE);

  /* Tx process is ended, restore huart->gState to Ready */
  huart->gState = HAL_UART_STATE_READY;

  HAL_UART_TxCpltCallback(huart);

  return HAL_OK;
}
</#if>
/**
  * @} end MC_6STEP_COM_Exported_LL_Functions_Prototypes
  */

/**
  * @}  end MC_6STEP_COM
  */ 

/**
  * @}  end MC_LIB_6STEP
  */

/**
  * @}  end MIDDLEWARES
  */ 

/************************ (C) COPYRIGHT STMicroelectronics *****END OF FILE****/

