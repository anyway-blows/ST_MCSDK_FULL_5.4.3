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
/**
  ******************************************************************************
  * @file    stm32f10x_mc_it.c 
  * @author  Motor Control SDK Team, ST Microelectronics
  * @brief   Main Interrupt Service Routines.
  *          This file provides exceptions handler and peripherals interrupt 
  *          service routine related to Motor Control for the STM32F1 Family.
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
  * @ingroup STM32F10x_IRQ_Handlers
  */ 

/* Includes ------------------------------------------------------------------*/
#include "mc_type.h"
#include "mc_tasks.h"
#include "ui_task.h"
#include "parameters_conversion.h"
#include "motorcontrol.h"
<#if MC.START_STOP_BTN == true>
#include "stm32f1xx_ll_exti.h"
</#if>
/* USER CODE BEGIN Includes */

/* USER CODE END Includes */

/** @addtogroup MCSDK
  * @{
  */

/** @addtogroup STM32F10x_IRQ_Handlers STM32F10x IRQ Handlers
  * @{
  */
/* USER CODE BEGIN PRIVATE */
  
/* Private typedef -----------------------------------------------------------*/
/* Private define ------------------------------------------------------------*/
#define SYSTICK_DIVIDER (SYS_TICK_FREQUENCY/1000)

/* Private macro -------------------------------------------------------------*/
/* Private variables ---------------------------------------------------------*/
/* Private function prototypes -----------------------------------------------*/
/* Private functions ---------------------------------------------------------*/

/* USER CODE END PRIVATE */

/* Public prototypes of IRQ handlers called from assembly code ---------------*/
<#if MC.STM32F103x_HD == true && MC.SINGLE_SHUNT == true >
void ADC3_IRQHandler(void);
<#else>
void ADC1_2_IRQHandler(void);
</#if>
void TIMx_UP_M1_IRQHandler(void);
void DMAx_R1_M1_IRQHandler(void);
void TIMx_BRK_M1_IRQHandler(void);
void SPD_TIM_M1_IRQHandler(void);
void USART_IRQHandler(void);
void HardFault_Handler(void);
void SysTick_Handler(void);
void PFC_TIM_IRQHandler(void);
void ${EXT_IRQHandler(_last_word(MC.START_STOP_GPIO_PIN)?number)} (void);


<#if MC.ADC_PERIPH == "ADC3" >
/**
  * @brief  This function handles ADC3 interrupt request.
  * @param  None
  * @retval None
  */
void ADC3_IRQHandler(void)
{
 /* USER CODE BEGIN ADC3_IRQn 0 */

 /* USER CODE END  ADC3_IRQn 0 */   

  // Clear Flags
  LL_ADC_ClearFlag_JEOS( ADC3 );

<#if MC.DAC_FUNCTIONALITY == true>
  /* Highfrequency task ADC3 */
  UI_DACUpdate(TSK_HighFrequencyTask());
<#else>
  /* Highfrequency task ADC3 */
  TSK_HighFrequencyTask();
</#if>
 /* USER CODE BEGIN ADC3_IRQn 1 */

 /* USER CODE END  ADC3_IRQn 1 */  
}
</#if>

<#if MC.ADC_PERIPH == "ADC1" || MC.ADC_PERIPH == "ADC2">
/**
  * @brief  This function handles ADC1/ADC2 interrupt request.
  * @param  None
  * @retval None
  */
void ADC1_2_IRQHandler(void)
{
  /* USER CODE BEGIN ADC1_2_IRQn 0 */

  /* USER CODE END ADC1_2_IRQn 0 */
  
  ${MC.ADC_PERIPH}->SR &= ~(uint32_t)(ADC_FLAG_JEOC | ADC_FLAG_JSTRT);

<#if MC.DAC_FUNCTIONALITY == true>
  UI_DACUpdate(TSK_HighFrequencyTask());  /*GUI, this section is present only if DAC is enabled*/
<#else>
  TSK_HighFrequencyTask();          /*GUI, this section is present only if DAC is disabled*/
</#if> 

  /* USER CODE BEGIN ADC1_2_IRQn 1 */

  /* USER CODE END ADC1_2_IRQn 1 */

}
</#if>


/**
  * @brief  This function handles first motor TIMx Update interrupt request.
  * @param  None
  * @retval None
  */
void TIMx_UP_M1_IRQHandler(void)
{
  /* USER CODE BEGIN TIMx_UP_M1_IRQn 0 */

  /* USER CODE END TIMx_UP_M1_IRQn 0 */  
    LL_TIM_ClearFlag_UPDATE(${_last_word(MC.PWM_TIMER_SELECTION)});
<#if MC.THREE_SHUNT == true>
    R3_2_TIMx_UP_IRQHandler(&PWM_Handle_M1);
<#elseif MC.SINGLE_SHUNT == true>          
  <#if CondLine_STM32F1_HD >
    <#if MC.PWM_TIMER_SELECTION == 'PWM_TIM1' || MC.PWM_TIMER_SELECTION == 'TIM1'>
    R1HD2_TIM1_UP_IRQHandler(&PWM_Handle_M1);
    <#elseif MC.PWM_TIMER_SELECTION == 'PWM_TIM8' || MC.PWM_TIMER_SELECTION == 'TIM8'>  
    R1HD2_TIM8_UP_IRQHandler(&PWM_Handle_M1);
    </#if>
  <#else>
    R1VL1_TIM1_UP_IRQHandler(&PWM_Handle_M1);
  </#if>
<#elseif MC.ICS_SENSORS == true>      
    ICS_TIMx_IRQHandler(&PWM_Handle_M1);
</#if>

   /* USER CODE BEGIN TIMx_UP_M1_IRQn 1 */

   /* USER CODE END TIMx_UP_M1_IRQn 1 */   
}

<#if MC.SINGLE_SHUNT == true>
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
  
<#if MC.PWM_TIMER_SELECTION == 'PWM_TIM1' || MC.PWM_TIMER_SELECTION == 'TIM1'>
  if (LL_DMA_IsActiveFlag_TC4(DMA1) == SET)
  {
    LL_DMA_ClearFlag_TC4(DMA1);
    <#if CondLine_STM32F1_HD>
    R1HD2_DMA_TC_IRQHandler(&PWM_Handle_M1);
    <#else>
    R1VL1_DMA_TC_IRQHandler(&PWM_Handle_M1);
    </#if>
    /* USER CODE BEGIN DMAx_R1_M1_TC4 */

    /* USER CODE END DMAx_R1_M1_TC4 */ 
  }
<#elseif MC.PWM_TIMER_SELECTION == 'PWM_TIM8' || MC.PWM_TIMER_SELECTION == 'TIM8'> 
  if (LL_DMA_IsActiveFlag_TC2(DMA2) == SET)
  {
    LL_DMA_ClearFlag_TC2(DMA2);
    <#if CondLine_STM32F1_HD>
    R1HD2_DMA_TC_IRQHandler(&PWM_Handle_M1);
    <#else>
    R1VL1_DMA_TC_IRQHandler(&PWM_Handle_M1);
    </#if>
    
    /* USER CODE BEGIN DMAx_R1_M1_TC2 */

    /* USER CODE END DMAx_R1_M1_TC2 */ 
  }
</#if>
  /* USER CODE BEGIN DMAx_R1_M1_IRQn 1 */

  /* USER CODE END DMAx_R1_M1_IRQn 1 */ 
}

</#if>

/**
  * @brief  This function handles first motor BRK interrupt.
  * @param  None
  * @retval None
  */
void TIMx_BRK_M1_IRQHandler(void)
{
  /* USER CODE BEGIN TIMx_BRK_M1_IRQn 0 */

  /* USER CODE END TIMx_BRK_M1_IRQn 0 */ 
  if (LL_TIM_IsActiveFlag_BRK(PWM_Handle_M1.pParams_str->TIMx))
  {
    LL_TIM_ClearFlag_BRK(PWM_Handle_M1.pParams_str->TIMx);

<#if MC.THREE_SHUNT == true>  
    R3_2_BRK_IRQHandler(&PWM_Handle_M1);
<#elseif MC.SINGLE_SHUNT == true>
  <#if CondLine_STM32F1_HD>
    R1HD2_BRK_IRQHandler(&PWM_Handle_M1);
  <#else>
    R1VL1_BRK_IRQHandler(&PWM_Handle_M1);
  </#if>
<#elseif MC.ICS_SENSORS == true> 
  <#if CondLine_STM32F1_HD>
    ICS_BRK_IRQHandler(&PWM_Handle_M1);
  <#else>
    ICS_BRK_IRQHandler(&PWM_Handle_M1);
  </#if>
</#if>

  }
  /* Systick is not executed due low priority so is necessary to call MC_Scheduler here.*/
  MC_Scheduler();
  
  /* USER CODE BEGIN TIMx_BRK_M1_IRQn 1 */

  /* USER CODE END TIMx_BRK_M1_IRQn 1 */ 
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
  if (LL_TIM_IsActiveFlag_UPDATE(HALL_M1.TIMx))
  {
    LL_TIM_ClearFlag_UPDATE(HALL_M1.TIMx);
    HALL_TIMx_UP_IRQHandler(&HALL_M1);
    /* USER CODE BEGIN M1 HALL_Update */

    /* USER CODE END M1 HALL_Update   */ 
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
    /* USER CODE BEGIN M1 HALL_CC1 */

    /* USER CODE END M1 HALL_CC1 */ 
  }
  else
  {
  /* Nothing to do */
  }
<#else>
 /* Encoder Timer UPDATE IT is dynamicaly enabled/disabled, checking enable state is required */
  if (LL_TIM_IsEnabledIT_UPDATE (ENCODER_M1.TIMx) && LL_TIM_IsActiveFlag_UPDATE (ENCODER_M1.TIMx))
  { 
    LL_TIM_ClearFlag_UPDATE(ENCODER_M1.TIMx);
    ENC_IRQHandler(&ENCODER_M1);
    /* USER CODE BEGIN M1 ENCODER_Update */

    /* USER CODE END M1 ENCODER_Update   */ 
  }
  else
  {
  /* No other IT to manage for encoder config */
  }
</#if>
  /* USER CODE BEGIN SPD_TIM_M1_IRQn 1 */

  /* USER CODE END SPD_TIM_M1_IRQn 1 */ 
}
</#if>

<#if MC.SERIAL_COMMUNICATION == true>
/*Start here***********************************************************/
/*GUI, this section is present only if serial communication is enabled*/
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
<#else>  
  uint16_t hUSART_SR = pUSART.USARTx->SR;

  if (hUSART_SR & USART_SR_ORE) /* Overrun error occurs before SR access */
  {
    /* Send Overrun message */
    UFCP_OVR_IRQ_Handler(&pUSART);
    LL_USART_ClearFlag_ORE(pUSART.USARTx); /* Clear overrun flag */
    UI_SerialCommunicationTimeOutStop();
    /* USER CODE BEGIN USART_ORE */

    /* USER CODE END USART_ORE   */
  }
    
  if (hUSART_SR & USART_SR_RXNE) /* Valid data received */
  {
    uint16_t retVal;
    retVal = *(uint16_t*)UFCP_RX_IRQ_Handler(&pUSART,LL_USART_ReceiveData8(pUSART.USARTx)); /* Flag 0 = RX */
    if (retVal == 1)
    {
      UI_SerialCommunicationTimeOutStart();
    }
    if (retVal == 2)
    {
      UI_SerialCommunicationTimeOutStop();
    }
  /* USER CODE BEGIN USART_RXNE */

  /* USER CODE END USART_RXNE   */ 
  }

  if(LL_USART_IsActiveFlag_TXE(pUSART.USARTx))
  {
    UFCP_TX_IRQ_Handler(&pUSART); /* Flag 1 = TX */
    /* USER CODE BEGIN USART_TXE */

    /* USER CODE END USART_TXE   */
  }
</#if>
  /* USER CODE BEGIN USART_IRQn 1 */
  
  /* USER CODE END USART_IRQn 1 */
}
</#if>

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
<#else>    
  if (LL_USART_IsActiveFlag_TXE(pUFC->Hw.USARTx))
  {
    UFC_TX_IRQ_Handler(pUFC);
  }
</#if>    
<#else>    
</#if>
  }
 /* USER CODE BEGIN HardFault_IRQn 1 */

 /* USER CODE END HardFault_IRQn 1 */

}
<#if MC.RTOS == "NONE">

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

<#if  MC.POSITION_CTRL_ENABLING2 == true >
    TC_IncTick(&pPosCtrlM2);
</#if>	

  /* USER CODE BEGIN SysTick_IRQn 2 */
  /* USER CODE END SysTick_IRQn 2 */
}
</#if>
<#if MC.PFC_ENABLED == true>

void PFC_TIM_IRQHandler(void)
{
  /* USER CODE BEGIN PFC_TIM Entry */
  
  /* USER CODE END PFC_TIM Entry */
  
  if ( LL_TIM_IsActiveFlag_CC3( PFC.pParams->TIMx ) )
  {
    /* Handling Capture Compare Interrupt for PFC - High freq task. */
    LL_TIM_ClearFlag_CC3( PFC.pParams->TIMx );
	PFC_TIM_CC_IRQHandler( &PFC );
  }
  
  if ( LL_TIM_IsActiveFlag_TRIG( PFC.pParams->TIMx ) )
  {
  	/* Handling over current error for PFC */
    LL_TIM_ClearFlag_TRIG( PFC.pParams->TIMx );
    PFC_TIM_TRIG_IRQHandler( &PFC );
    
    /* USER CODE BEGIN PFC_TIM ETR */
    
    /* USER CODE END PFC_TIM ETR */
  }

  /* USER CODE BEGIN PFC_TIM Exit */
  
  /* USER CODE END PFC_TIM Exit */
	
}
</#if>
<#function EXT_IRQHandler line>
    <#local EXTI_IRQ =
        [ {"name": "EXTI0_IRQHandler", "line": 0} 
        , {"name": "EXTI1_IRQHandler", "line": 1} 
        , {"name": "EXTI2_IRQHandler", "line": 2}
        , {"name": "EXTI3_IRQHandler", "line": 3} 
        , {"name": "EXTI4_IRQHandler", "line": 4} 
        , {"name": "EXTI9_5_IRQHandler", "line": 9}
        , {"name": "EXTI15_10_IRQHandler", "line": 15}
        ] >
    <#list EXTI_IRQ as handler >
        <#if line <= (handler.line ) >
           <#return  handler.name >
         </#if>
    </#list>
     <#return "EXTI15_10_IRQHandler" >
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
    <#else>
      <#assign Template_StartStop = '/* USER CODE BEGIN START_STOP_BTN */
  if ( LL_EXTI_ReadFlag_32_63(LL_EXTI_LINE_${_last_word(MC.START_STOP_GPIO_PIN)}) )
  {
    LL_EXTI_ClearFlag_32_63 (LL_EXTI_LINE_${_last_word(MC.START_STOP_GPIO_PIN)});
    UI_HandleStartStopButton_cb ();
  }'> 
    </#if>
  </#if>

  <#if MC.ENC_USE_CH3 == true>
    <#assign EXT_IRQHandler_ENC_Z_M1_Name = "${EXT_IRQHandler(_last_word(MC.ENC_Z_GPIO_PIN)?number)}" >
    <#if _last_word(MC.ENC_Z_GPIO_PIN)?number < 32 >
      <#assign Template_Encoder_Z_M1 = '/* USER CODE BEGIN ENCODER Z INDEX M1 */
  if (LL_EXTI_ReadFlag_0_31(LL_EXTI_LINE_${_last_word(MC.ENC_Z_GPIO_PIN)}))  
  {                                                                          
    LL_EXTI_ClearFlag_0_31 (LL_EXTI_LINE_${_last_word(MC.ENC_Z_GPIO_PIN)});  
    TC_EncoderReset(&pPosCtrlM1);                                            
  }'> 
    <#else>
        <#assign Template_Encoder_Z_M1 = '/* USER CODE BEGIN ENCODER Z INDEX M1 */
  if (LL_EXTI_ReadFlag_32_63(LL_EXTI_LINE_${_last_word(MC.ENC_Z_GPIO_PIN)})) 
  {                                                                          
    LL_EXTI_ClearFlag_32_63 (LL_EXTI_LINE_${_last_word(MC.ENC_Z_GPIO_PIN)});  
    TC_EncoderReset(&pPosCtrlM1);                                            
  }'> 
    </#if> 	
  </#if> <#-- MC.ENC_USE_CH3 == true -->
  
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
  </#if> <#-- MC.START_STOP_BTN == true -->

  <#if MC.ENC_USE_CH3 == true>
    <#if "${EXT_IRQHandler_StartStopName}" != "${EXT_IRQHandler_ENC_Z_M1_Name}" >
/**
  * @brief  This function handles M1 Encoder Index IRQ on PIN P${ _last_char(MC.ENC_Z_GPIO_PORT)}${_last_word(MC.ENC_Z_GPIO_PIN)}.
  */
void ${EXT_IRQHandler_ENC_Z_M1_Name} (void)
{
	${Template_Encoder_Z_M1}
	
}	
    </#if> <#-- "${EXT_IRQHandler_StartStopName}" != "${EXT_IRQHandler_ENC_Z_M1_Name}" -->
  </#if> <#-- MC.ENC_USE_CH3 == true --> 
</#if> <#-- MC.START_STOP_BTN == true || MC.ENC_USE_CH3 == true -->

/* USER CODE BEGIN 1 */

/* USER CODE END 1 */

/**
  * @}
  */

/**
  * @}
  */

/******************* (C) COPYRIGHT 2019 STMicroelectronics *****END OF FILE****/
