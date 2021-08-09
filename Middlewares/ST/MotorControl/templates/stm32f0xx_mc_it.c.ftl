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
  * @file    stm32f0xx_mc_it.c 
  * @author  Motor Control SDK Team, ST Microelectronics
  * @brief   Main Interrupt Service Routines.
  *          This file provides exceptions handler and peripherals interrupt 
  *          service routine related to Motor Control for the STM32F0 Family.
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
  * @ingroup STM32F0xx_IRQ_Handlers
  */ 

/* Includes ------------------------------------------------------------------*/
#include "mc_type.h"
#include "mc_config.h"
<#-- Specific to FOC algorithm usage -->
<#if MC.DRIVE_TYPE == "FOC">
#include "mc_tasks.h"
#include "ui_task.h"
#include "parameters_conversion.h"
#include "motorcontrol.h"
	<#if MC.START_STOP_BTN == true>
#include "stm32f0xx_ll_exti.h"
	</#if>
#include "stm32f0xx_hal.h"
</#if>
#include "stm32f0xx.h"
<#-- Specific to 6_STEP algorithm usage -->
<#if MC.DRIVE_TYPE == "SIX_STEP">
	<#-- TeraTerm usage management (used when MC.SERIAL_COMMUNICATION == false) -->
	<#if MC.SERIAL_COMMUNICATION == false>
#include "stm32f0xx_it.h"
#include "6step_com.h"
#include "6step_core.h"
	</#if>
</#if>

/* USER CODE BEGIN Includes */

/* USER CODE END Includes */

/** @addtogroup MCSDK
  * @{
  */

/** @addtogroup STM32F0xx_IRQ_Handlers STM32F0xx IRQ Handlers
  * @{
  */
  
/* USER CODE BEGIN PRIVATE */
  
/* Private typedef -----------------------------------------------------------*/
/* Private define ------------------------------------------------------------*/
<#-- Specific to FOC algorithm usage -->
<#if MC.DRIVE_TYPE == "FOC">
#define SYSTICK_DIVIDER (SYS_TICK_FREQUENCY/1000)
</#if>
/* Private macro -------------------------------------------------------------*/
/* Private variables ---------------------------------------------------------*/
/* Private function prototypes -----------------------------------------------*/
/* Private functions ---------------------------------------------------------*/

/* USER CODE END PRIVATE */
<#-- Specific to 6_STEP algorithm usage -->
<#if MC.DRIVE_TYPE == "SIX_STEP">
extern TIM_HandleTypeDef htim1;
extern MC_Handle_t Motor_Device1;

void SysTick_Handler(void);
void TIM1_BRK_UP_TRG_COM_IRQHandler(void);
void USART_IRQHandler(void);
</#if>

<#-- Specific to FOC algorithm usage -->
<#if MC.DRIVE_TYPE == "FOC">
/* Public prototypes of IRQ handlers called from assembly code ---------------*/
void CURRENT_REGULATION_IRQHandler(void);
void TIMx_UP_BRK_M1_IRQHandler(void);
void DMAx_R1_M1_IRQHandler(void);
void SPD_TIM_M1_IRQHandler(void);
void USART_IRQHandler(void);
void HardFault_Handler(void);
void SysTick_Handler(void);
void ${EXT_IRQHandler(_last_word(MC.START_STOP_GPIO_PIN)?number)} (void);


/**
  * @brief  This function handles current regulation interrupt request.
  * @param  None
  * @retval None
  */
void CURRENT_REGULATION_IRQHandler(void)
{
  /* USER CODE BEGIN CURRENT_REGULATION_IRQn 0 */

  /* USER CODE END CURRENT_REGULATION_IRQn 0 */
  
	<#if MC.SINGLE_SHUNT == true>
  /* Clear Flags */
  DMA1->IFCR = (LL_DMA_ISR_GIF2|LL_DMA_ISR_TCIF2|LL_DMA_ISR_HTIF2);
	<#elseif MC.THREE_SHUNT == true>
  /* Clear Flags */
  DMA1->IFCR = (LL_DMA_ISR_GIF1|LL_DMA_ISR_TCIF1|LL_DMA_ISR_HTIF1);
	</#if>
  /* USER CODE BEGIN CURRENT_REGULATION_IRQn 1 */

  /* USER CODE END CURRENT_REGULATION_IRQn 1 */   
  
	<#if MC.DAC_FUNCTIONALITY == true>
    UI_DACUpdate(TSK_HighFrequencyTask());  /*GUI, this section is present only if DAC is enabled*/
	<#else>
    TSK_HighFrequencyTask();          /*GUI, this section is present only if DAC is disabled*/
	</#if>
  /* USER CODE BEGIN CURRENT_REGULATION_IRQn 2 */

  /* USER CODE END CURRENT_REGULATION_IRQn 2 */   
}

/**
  * @brief  This function handles first motor TIMx Update, Break-in interrupt request.
  * @param  None
  * @retval None
  */
void TIMx_UP_BRK_M1_IRQHandler(void)
{
  /* USER CODE BEGIN TIMx_UP_BRK_M1_IRQn 0 */

  /* USER CODE END TIMx_UP_BRK_M1_IRQn 0 */   

  if(LL_TIM_IsActiveFlag_UPDATE(PWM_Handle_M1.pParams_str->TIMx) && LL_TIM_IsEnabledIT_UPDATE(PWM_Handle_M1.pParams_str->TIMx))
  {
    LL_TIM_ClearFlag_UPDATE(PWM_Handle_M1.pParams_str->TIMx);
	<#if MC.SINGLE_SHUNT == true>  
    R1F0XX_TIMx_UP_IRQHandler(&PWM_Handle_M1);
	<#elseif MC.THREE_SHUNT == true>
    R3_1_TIMx_UP_IRQHandler( &PWM_Handle_M1 );
	</#if>
    /* USER CODE BEGIN PWM_Update */

    /* USER CODE END PWM_Update */  
  }
  if(LL_TIM_IsActiveFlag_BRK(PWM_Handle_M1.pParams_str->TIMx) && LL_TIM_IsEnabledIT_BRK(PWM_Handle_M1.pParams_str->TIMx)) 
  {
    LL_TIM_ClearFlag_BRK(PWM_Handle_M1.pParams_str->TIMx);      
    F0XX_BRK_IRQHandler(&PWM_Handle_M1);
    /* USER CODE BEGIN Break */

    /* USER CODE END Break */ 
  }
  else 
  {
   /* No other interrupts are routed to this handler */
  }
  /* USER CODE BEGIN TIMx_UP_BRK_M1_IRQn 1 */

  /* USER CODE END TIMx_UP_BRK_M1_IRQn 1 */   
}

/**
  * @brief  This function handles first motor DMAx TC interrupt request. 
  *         Required only for R1 with rep rate > 1
  * @param  None
  * @retval None
  */
void DMAx_R1_M1_IRQHandler(void)
{
  /* USER CODE BEGIN DMAx_R1_M1_IRQn 0 */

  /* USER CODE END DMAx_R1_M1_IRQn 0 */ 
  
  if (LL_DMA_IsActiveFlag_TC4(DMA1))
  {
    LL_DMA_ClearFlag_TC4(DMA1);
	<#if MC.SINGLE_SHUNT == true>     
    R1F0XX_DMA_TC_IRQHandler(&PWM_Handle_M1);
	<#elseif MC.THREE_SHUNT == true>
	</#if>
    /* USER CODE BEGIN DMAx_R1_M1_TC4 */

    /* USER CODE END DMAx_R1_M1_TC4 */     
  } 
  /* USER CODE BEGIN DMAx_R1_M1_IRQn 1 */

  /* USER CODE END DMAx_R1_M1_IRQn 1 */ 
}

	<#if MC.ENCODER==true || MC.AUX_ENCODER==true || MC.HALL_SENSORS==true || MC.AUX_HALL_SENSORS==true>
/**
  * @brief  This function handles TIMx global interrupt request for M1 Speed Sensor.
  * @param  None
  * @retval None
  */
void SPD_TIM_M1_IRQHandler(void)
{
  /* USER CODE BEGIN SPD_TIM_M1_IRQn 0 */

  /* USER CODE END SPD_TIM_M1_IRQn 0 */ 
  
		<#if MC.HALL_SENSORS==true || MC.AUX_HALL_SENSORS==true>
  /* HALL Timer Update IT always enabled, no need to check enable UPDATE state */
  if (LL_TIM_IsActiveFlag_UPDATE(HALL_M1.TIMx) != 0)
  {
    LL_TIM_ClearFlag_UPDATE(HALL_M1.TIMx);
    HALL_TIMx_UP_IRQHandler(&HALL_M1);
    /* USER CODE BEGIN HALL_Update */

    /* USER CODE END HALL_Update   */ 
  }
  else
  {
    /* Nothing to do */
  }
  /* HALL Timer CC1 IT always enabled, no need to check enable CC1 state */
  if (LL_TIM_IsActiveFlag_CC1 (HALL_M1.TIMx)) 
  {
    LL_TIM_ClearFlag_CC1(HALL_M1.TIMx);
    HALL_TIMx_CC_IRQHandler(&HALL_M1);
    /* USER CODE BEGIN HALL_CC1 */

    /* USER CODE END HALL_CC1 */ 
  }
  else
  {
  /* Nothing to do */
  }
		<#else><#-- MC.HALL_SENSORS==true || MC.AUX_HALL_SENSORS==true -->
 /* Encoder Timer UPDATE IT is dynamicaly enabled/disabled, checking enable state is required */
  if (LL_TIM_IsEnabledIT_UPDATE (ENCODER_M1.TIMx) && LL_TIM_IsActiveFlag_UPDATE (ENCODER_M1.TIMx))
  { 
    LL_TIM_ClearFlag_UPDATE(ENCODER_M1.TIMx);
    ENC_IRQHandler(&ENCODER_M1);
    /* USER CODE BEGIN ENCODER_Update */

    /* USER CODE END ENCODER_Update   */ 
  }
  else
  {
  /* No other IT to manage for encoder config */
  }
		</#if><#-- end of else if MC.HALL_SENSORS==true || MC.AUX_HALL_SENSORS==true -->
  /* USER CODE BEGIN SPD_TIM_M1_IRQn 1 */

  /* USER CODE END SPD_TIM_M1_IRQn 1 */ 
}
	</#if><#-- MC.ENCODER==true || MC.AUX_ENCODER==true || MC.HALL_SENSORS==true || MC.AUX_HALL_SENSORS==true -->
</#if><#-- MC.DRIVE_TYPE == "FOC" -->

<#-- Specific to 6_STEP algorithm usage -->
<#if MC.DRIVE_TYPE == "SIX_STEP">
<#-- 6-STEP Example: This is temporary.  -->
<#function _last_char text><#return text[text?length-1]></#function>
<#-- Workaround not true for all series, need to be removed once WB will use real name UART or USART-->
<#function UartHandler uart>
	<#if (uart?number < 4) || (uart?number > 5) >
	  <#return "USART${uart}_IRQHandler">
	<#else>
	  <#return "UART${uart}_IRQHandler">
	</#if>   
</#function>

#define USART_IRQHandler ${UartHandler (_last_char(MC.USART_SELECTION))}
</#if>

<#-- ST MCWB monitoring usage management (used when MC.SERIAL_COMMUNICATION == true) -->
<#if MC.SERIAL_COMMUNICATION==true>

/* This section is present only when serial communication is used */
/**
  * @brief  This function handles USART interrupt request.
  * @param  None
  * @retval None
  */
void USART_IRQHandler(void)
{
  /* USER CODE BEGIN USART_IRQn 0 */

  /* USER CODE END USART_IRQn 0 */
	<#if MC.SERIAL_COM_MODE == "COM_UNIDIRECTIONAL">
  if (LL_USART_IsActiveFlag_TXE(pUFC->Hw.USARTx))
  {
    UFC_TX_IRQ_Handler(pUFC);
  }
	<#else><#-- Communication is bi-directional -->
  if (LL_USART_IsActiveFlag_RXNE(pUSART.USARTx)) /* Valid data have been received */
  {
		<#-- Specific to FOC algorithm usage -->
		<#if MC.DRIVE_TYPE == "FOC">
    uint16_t retVal;
    retVal = *(uint16_t*)(UFCP_RX_IRQ_Handler(&pUSART,LL_USART_ReceiveData8(pUSART.USARTx)));
    if (retVal == 1)
    {
      UI_SerialCommunicationTimeOutStart();
    }
    if (retVal == 2)
    {
      UI_SerialCommunicationTimeOutStop();
    }
		<#-- Specific to 6_STEP algorithm usage -->
		<#elseif MC.DRIVE_TYPE == "SIX_STEP">
    (void) UFCP_RX_IRQ_Handler( &pUSART, LL_USART_ReceiveData8(pUSART.USARTx) );
		</#if>
  /* USER CODE BEGIN USART_RXNE */

  /* USER CODE END USART_RXNE  */ 
  }

  if (LL_USART_IsActiveFlag_TXE(pUSART.USARTx))
  {
    UFCP_TX_IRQ_Handler(&pUSART);
    /* USER CODE BEGIN USART_TXE */

    /* USER CODE END USART_TXE   */
  }
  
  if (LL_USART_IsActiveFlag_ORE(pUSART.USARTx)) /* Overrun error occurs */
  {
    /* Send Overrun message */
    UFCP_OVR_IRQ_Handler(&pUSART);
    LL_USART_ClearFlag_ORE(pUSART.USARTx); /* Clear overrun flag */
		<#-- Specific to FOC algorithm usage -->
		<#if MC.DRIVE_TYPE == "FOC">
    UI_SerialCommunicationTimeOutStop();
		</#if>
    /* USER CODE BEGIN USART_ORE */

    /* USER CODE END USART_ORE   */   
  }
	</#if><#-- else MC.SERIAL_COM_MODE == "COM_UNIDIRECTIONAL" -->
  /* USER CODE BEGIN USART_IRQn 1 */
  
  /* USER CODE END USART_IRQn 1 */
}
</#if>

<#-- Specific to 6_STEP algorithm usage -->
<#if MC.DRIVE_TYPE == "SIX_STEP">
	<#-- TeraTerm usage management (used when MC.SERIAL_COMMUNICATION == false) -->
	<#if MC.SERIAL_COMMUNICATION == false>
/* This section is present only when TeraTerm is used for 6-steps */
/**
  * @brief  This function handles USART interrupt request.
  * @param  None
  * @retval None
  */
void USART_IRQHandler(void)
{
  /* USER CODE BEGIN USART1_IRQn 0 */
  MC_Com_Irq_Handler();
  /* USER CODE END USART1_IRQn 0 */

  /* USER CODE BEGIN USART1_IRQn 1 */

  /* USER CODE END USART1_IRQn 1 */
}

	</#if>

/**
  * @brief This function handles System tick timer.
  * @param  None
  * @retval None
  */
void SysTick_Handler(void)
{
  /* USER CODE BEGIN SysTick_IRQn 0 */

  /* USER CODE END SysTick_IRQn 0 */
  HAL_IncTick();
  /* USER CODE BEGIN SysTick_IRQn 1 */
  HAL_SYSTICK_IRQHandler();
  /* USER CODE END SysTick_IRQn 1 */
}

/**
  * @brief This function handles TIM1 break, update, trigger and commutation interrupts.
  * @param  None
  * @retval None
  */
void TIM1_BRK_UP_TRG_COM_IRQHandler(void)
{
  /* USER CODE BEGIN TIM1_BRK_TIM15_IRQn 0 */
  Motor_Device1.status = MC_OVERCURRENT;
  MC_Core_LL_Error(&Motor_Device1);
  /* USER CODE END TIM1_BRK_TIM15_IRQn 0 */
  HAL_TIM_IRQHandler(&htim1);
  /* USER CODE BEGIN TIM1_BRK_TIM15_IRQn 1 */

  /* USER CODE END TIM1_BRK_TIM15_IRQn 1 */
}
</#if><#-- MC.SERIAL_COMMUNICATION==true -->

<#-- Specific to FOC algorithm usage -->
<#if MC.DRIVE_TYPE == "FOC">
/**
  * @brief  This function handles Hard Fault exception.
  * @param  None
  * @retval None
  */
void HardFault_Handler(void)
{
 /* USER CODE BEGIN HardFault_IRQn 0 */

 /* USER CODE END HardFault_IRQn 0 */
  TSK_HardwareFaultTask();
  
  /* Go to infinite loop when Hard Fault exception occurs */
  while (1)
  {
	<#-- ST MCWB monitoring usage management (used when MC.SERIAL_COMMUNICATION == true) -->
	<#if MC.SERIAL_COMMUNICATION == true>
		<#if MC.SERIAL_COM_MODE == "COM_BIDIRECTIONAL">
    {
      if (LL_USART_IsActiveFlag_ORE(pUSART.USARTx)) /* Overrun error occurs */
      {
        /* Send Overrun message */
        UFCP_OVR_IRQ_Handler(&pUSART);
        LL_USART_ClearFlag_ORE(pUSART.USARTx); /* Clear overrun flag */
        UI_SerialCommunicationTimeOutStop();
      }
      
      if (LL_USART_IsActiveFlag_TXE(pUSART.USARTx))
      {   
        UFCP_TX_IRQ_Handler(&pUSART);
      }  
      
      if (LL_USART_IsActiveFlag_RXNE(pUSART.USARTx)) /* Valid data have been received */
      {
        uint16_t retVal;
        retVal = *(uint16_t*)(UFCP_RX_IRQ_Handler(&pUSART,LL_USART_ReceiveData8(pUSART.USARTx)));
        if (retVal == 1)
        {
          UI_SerialCommunicationTimeOutStart();
        }
        if (retVal == 2)
        {
          UI_SerialCommunicationTimeOutStop();
        }
      }
      else
      {
      }
    }  
		<#else><#-- MC.SERIAL_COM_MODE == "COM_BIDIRECTIONAL" -->   
  if (LL_USART_IsActiveFlag_TXE(pUFC->Hw.USARTx))
  {
    UFC_TX_IRQ_Handler(pUFC);
  }
		</#if><#-- else MC.SERIAL_COM_MODE == "COM_BIDIRECTIONAL" -->
	<#else><#-- MC.SERIAL_COMMUNICATION == true -->   
	</#if><#-- MC.SERIAL_COMMUNICATION == true -->  
  }
 /* USER CODE BEGIN HardFault_IRQn 1 */

 /* USER CODE END HardFault_IRQn 1 */

}


void SysTick_Handler(void)
{
#ifdef MC_HAL_IS_USED
static uint8_t SystickDividerCounter = SYSTICK_DIVIDER;
  /* USER CODE BEGIN SysTick_IRQn 0 */

  /* USER CODE END SysTick_IRQn 0 */
  if (SystickDividerCounter == SYSTICK_DIVIDER)
  {
    HAL_IncTick();
    HAL_SYSTICK_IRQHandler();
    SystickDividerCounter = 0;
  }
  SystickDividerCounter ++;  
#endif /* MC_HAL_IS_USED */

  /* USER CODE BEGIN SysTick_IRQn 1 */
  /* USER CODE END SysTick_IRQn 1 */
    MC_RunMotorControlTasks();

<#if  MC.POSITION_CTRL_ENABLING == true >
    TC_IncTick(&pPosCtrlM1);
</#if>

  /* USER CODE BEGIN SysTick_IRQn 2 */
  /* USER CODE END SysTick_IRQn 2 */
}

	<#function EXT_IRQHandler line>
	<#local EXTI_IRQ =
        [ {"name": "EXTI0_1_IRQHandler", "line": 1} 
        , {"name": "EXTI2_3_IRQHandler", "line": 3} 
        , {"name": "EXTI4_15_IRQHandler", "line": 15}
        ] >
	<#list EXTI_IRQ as handler >
        <#if line <= (handler.line ) >
           <#return  handler.name >
         </#if>
	</#list>
	<#return "EXTI4_15_IRQHandler" >
	</#function>

	<#function _last_word text sep="_"><#return text?split(sep)?last></#function>
	<#function _last_char text><#return text[text?length-1]></#function>

<#if MC.START_STOP_BTN == true || MC.ENC_USE_CH3 == true>
<#-- GUI, this section is present only if start/stop button and/or Position Control with Z channel is enabled -->
  
<#assign EXT_IRQHandler_StartStopName = "" >
<#assign EXT_IRQHandler_ENC_Z_M1_Name = "" >
<#assign Template_StartStop ="">
<#assign Template_Encoder_Z_M1 ="">

	<#if MC.START_STOP_BTN == true>
  <#assign EXT_IRQHandler_StartStopName = "${EXT_IRQHandler(_last_word(MC.START_STOP_GPIO_PIN)?number)}" >
  <#if _last_word(MC.START_STOP_GPIO_PIN)?number < 32 >
    <#assign Template_StartStop = '/* USER CODE BEGIN START_STOP_BTN */
  if ( LL_EXTI_ReadFlag_0_31(LL_EXTI_LINE_${_last_word(MC.START_STOP_GPIO_PIN)}) ) 
  {                                                                                
    LL_EXTI_ClearFlag_0_31 (LL_EXTI_LINE_${_last_word(MC.START_STOP_GPIO_PIN)});  
    UI_HandleStartStopButton_cb ();                                               
  }'> 
  <#else><#-- _last_word(MC.START_STOP_GPIO_PIN)?number < 32 -->
    <#assign Template_StartStop = '/* USER CODE BEGIN START_STOP_BTN */
  if ( LL_EXTI_ReadFlag_32_63(LL_EXTI_LINE_${_last_word(MC.START_STOP_GPIO_PIN)}) )
  {
    LL_EXTI_ClearFlag_32_63 (LL_EXTI_LINE_${_last_word(MC.START_STOP_GPIO_PIN)});
    UI_HandleStartStopButton_cb ();
  }'> 
  </#if><#-- else _last_word(MC.START_STOP_GPIO_PIN)?number < 32 -->
</#if><#-- MC.START_STOP_BTN == true -->

<#if MC.ENC_USE_CH3 == true>
  <#assign EXT_IRQHandler_ENC_Z_M1_Name = "${EXT_IRQHandler(_last_word(MC.ENC_Z_GPIO_PIN)?number)}" >
  <#if _last_word(MC.ENC_Z_GPIO_PIN)?number < 32 >
  <#assign Template_Encoder_Z_M1 = '/* USER CODE BEGIN ENCODER Z INDEX M1 */
  if (LL_EXTI_ReadFlag_0_31(LL_EXTI_LINE_${_last_word(MC.ENC_Z_GPIO_PIN)}))  
  {                                                                          
    LL_EXTI_ClearFlag_0_31 (LL_EXTI_LINE_${_last_word(MC.ENC_Z_GPIO_PIN)});  
    TC_EncoderReset(&pPosCtrlM1);                                            
  }'> 
  <#else><#-- _last_word(MC.ENC_Z_GPIO_PIN)?number < 32 -->
  <#assign Template_Encoder_Z_M1 = '/* USER CODE BEGIN ENCODER Z INDEX M1 */
  if (LL_EXTI_ReadFlag_32_63(LL_EXTI_LINE_${_last_word(MC.ENC_Z_GPIO_PIN)})) 
  {                                                                          
    LL_EXTI_ClearFlag_32_63 (LL_EXTI_LINE_${_last_word(MC.ENC_Z_GPIO_PIN)});  
    TC_EncoderReset(&pPosCtrlM1);                                            
  }'> 
  </#if><#-- else _last_word(MC.ENC_Z_GPIO_PIN)?number < 32 -->
</#if><#-- MC.ENC_USE_CH3 == true -->
  
  <#if MC.START_STOP_BTN == true>
/**
  * @brief  This function handles Button IRQ on PIN P${ _last_char(MC.START_STOP_GPIO_PORT)}${_last_word(MC.START_STOP_GPIO_PIN)}.
    <#if MC.ENC_USE_CH3 == true && "${EXT_IRQHandler_StartStopName}" == "${EXT_IRQHandler_ENC_Z_M1_Name}">
  *                 and M1 Encoder Index IRQ on PIN P${ _last_char(MC.ENC_Z_GPIO_PORT)}${_last_word(MC.ENC_Z_GPIO_PIN)}.
    </#if>  
  */
void ${EXT_IRQHandler_StartStopName} (void)
{
	${Template_StartStop}

	  <#if "${EXT_IRQHandler_StartStopName}" == "${EXT_IRQHandler_ENC_Z_M1_Name}" >
	${Template_Encoder_Z_M1}
  </#if>
	
}
  </#if><#-- MC.START_STOP_BTN == true -->

  <#if MC.ENC_USE_CH3 == true>
	  <#if "${EXT_IRQHandler_StartStopName}" != "${EXT_IRQHandler_ENC_Z_M1_Name}" >
/**
  * @brief  This function handles M1 Encoder Index IRQ on PIN P${ _last_char(MC.ENC_Z_GPIO_PORT)}${_last_word(MC.ENC_Z_GPIO_PIN)}.
  */
void ${EXT_IRQHandler_ENC_Z_M1_Name} (void)
{
	${Template_Encoder_Z_M1}
	
}	
	  </#if><#-- "${EXT_IRQHandler_StartStopName}" != "${EXT_IRQHandler_ENC_Z_M1_Name}" -->
  </#if><#-- MC.ENC_USE_CH3 == true -->
</#if><#-- MC.START_STOP_BTN == true || MC.ENC_USE_CH3 == true -->
</#if><#-- MC.DRIVE_TYPE == "FOC" -->
/* USER CODE BEGIN 1 */

/* USER CODE END 1 */

/**
  * @}
  */

/**
  * @}
  */

/******************* (C) COPYRIGHT 2019 STMicroelectronics *****END OF FILE****/