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

<#function _first_word text sep="_"><#return text?split(sep)?first></#function>
<#function _last_word text sep="_"><#return text?split(sep)?last></#function>
<#function _last_char text><#return text[text?length-1]></#function>

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

<#assign NVICParams = configs[0].peripheralNVICParams >
<#function IRQHandler_name component irq="IRQ">
  <#if NVICParams.containsKey(component) >
    <#assign IRQHandler = NVICParams.get(component)>
  <#else>  
    <#return "#error component ${component} not found at NVIC level (no IT activated) " >
  </#if>
  <#if IRQHandler.isEmpty() == true >
      <#return "IRQ ${irq} probably not activated at NVIC level" >
  </#if>
    <#list IRQHandler.keySet() as entry>
       <#if entry?contains(irq)>     
         <#return "void "+entry[0..entry.length()-2]+"Handler (void)">
       </#if>
    </#list>
  <#return "#error IRQ ${irq} not activated at NVIC level for component ${component}">
</#function>
<#-- 
Useful for debug
      <#list NVICParams.keySet() as nvicParam>
          ${nvicParam}
      </#list>    
-->
</#if>

/**
  ******************************************************************************
  * @file    stm32g0xx_mc_it.c 
  * @author  Motor Control SDK Team, ST Microelectronics
  * @brief   Main Interrupt Service Routines.
  *          This file provides exceptions handler and peripherals interrupt 
  *          service routine related to Motor Control
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
  * @ingroup STM32G0xx_IRQ_Handlers
  */ 

/* Includes ------------------------------------------------------------------*/
#include "mc_type.h"
#include "mc_tasks.h"
#include "ui_task.h"
#include "parameters_conversion.h"
#include "motorcontrol.h"
<#if MC.START_STOP_BTN == true>
#include "stm32g0xx_ll_exti.h"
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
#define SYSTICK_DIVIDER (SYS_TICK_FREQUENCY/1000)

/* Private macro -------------------------------------------------------------*/
/* Private variables ---------------------------------------------------------*/
/* Private function prototypes -----------------------------------------------*/
/* Private functions ---------------------------------------------------------*/

/* USER CODE END PRIVATE */

${IRQHandler_name("DMA", "Channel1")};
<#if MC.SINGLE_SHUNT==true>
${IRQHandler_name("DMA", "Ch4")};
</#if> <#-- MC.SINGLE_SHUNT -->
${IRQHandler_name(_last_word(MC.PWM_TIMER_SELECTION), "UP")};
<#if MC.ENCODER == true || MC.AUX_ENCODER == true || MC.HALL_SENSORS == true || MC.AUX_HALL_SENSORS == true>
${IRQHandler_name(_last_word(MC.HALL_TIMER_SELECTION))};
</#if>
<#if MC.SERIAL_COMMUNICATION == true>
${IRQHandler_name(_last_word(MC.USART_SELECTION))};
</#if>
void HardFault_Handler(void);
void SysTick_Handler(void);
<#if MC.START_STOP_BTN == true>
void ${EXT_IRQHandler(_last_word(MC.START_STOP_GPIO_PIN)?number)} (void);
</#if>

/**
  * @brief  This function handles current regulation interrupt request.
  * @param  None
  * @retval None
  */
${IRQHandler_name("DMA", "Channel1")}    
{
  /* USER CODE BEGIN CURRENT_REGULATION_IRQn 0 */
    /* Debug High frequency task duration
     * LL_GPIO_SetOutputPin (GPIOB, LL_GPIO_PIN_3); 
     */
  /* USER CODE END CURRENT_REGULATION_IRQn 0 */
  
  /* Clear Flags */
  DMA1->IFCR = (LL_DMA_ISR_GIF1|LL_DMA_ISR_TCIF1|LL_DMA_ISR_HTIF1);
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
${IRQHandler_name(_last_word(MC.PWM_TIMER_SELECTION), "UP")}  
{
  /* USER CODE BEGIN TIMx_UP_BRK_M1_IRQn 0 */

  /* USER CODE END TIMx_UP_BRK_M1_IRQn 0 */   

  if(LL_TIM_IsActiveFlag_UPDATE(PWM_Handle_M1.pParams_str->TIMx) && LL_TIM_IsEnabledIT_UPDATE(PWM_Handle_M1.pParams_str->TIMx))
  {
    LL_TIM_ClearFlag_UPDATE(PWM_Handle_M1.pParams_str->TIMx);
<#if MC.SINGLE_SHUNT == true>  
    R1G0XX_TIMx_UP_IRQHandler(&PWM_Handle_M1);
<#elseif MC.THREE_SHUNT == true>
    R3_1_TIMx_UP_IRQHandler(&PWM_Handle_M1);
</#if> 
    /* USER CODE BEGIN PWM_Update */

    /* USER CODE END PWM_Update */  
  }  
  if(LL_TIM_IsActiveFlag_BRK(PWM_Handle_M1.pParams_str->TIMx) && LL_TIM_IsEnabledIT_BRK(PWM_Handle_M1.pParams_str->TIMx)) 
  {
    LL_TIM_ClearFlag_BRK(PWM_Handle_M1.pParams_str->TIMx);
<#if MC.SINGLE_SHUNT == true>  
    R1G0XX_OVERCURRENT_IRQHandler(&PWM_Handle_M1);
<#elseif MC.THREE_SHUNT == true>
    R3_1_OVERCURRENT_IRQHandler(&PWM_Handle_M1);
</#if>     
    /* USER CODE BEGIN Break */

    /* USER CODE END Break */ 
  }
  if (LL_TIM_IsActiveFlag_BRK2(PWM_Handle_M1.pParams_str->TIMx) && LL_TIM_IsEnabledIT_BRK(PWM_Handle_M1.pParams_str->TIMx)) 
  {
    LL_TIM_ClearFlag_BRK2(PWM_Handle_M1.pParams_str->TIMx);
<#if MC.SINGLE_SHUNT == true>  
    R1G0XX_OVERVOLTAGE_IRQHandler(&PWM_Handle_M1);
<#elseif MC.THREE_SHUNT == true>
    R3_1_OVERVOLTAGE_IRQHandler(&PWM_Handle_M1);
</#if>     
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


<#if MC.SINGLE_SHUNT == true>     
/**
  * @brief  This function handles first motor DMAx TC interrupt request. 
  *         Required only for R1 with rep rate > 1
  * @param  None
  * @retval None
  */
${IRQHandler_name("DMA", "Ch4")}
{
  /* USER CODE BEGIN DMAx_R1_M1_IRQn 0 */

  /* USER CODE END DMAx_R1_M1_IRQn 0 */ 
  
  if (LL_DMA_IsActiveFlag_TC4(DMA1))
  {
    LL_DMA_ClearFlag_TC4(DMA1);
    LL_TIM_DisableDMAReq_CC4(TIM1);
    /* USER CODE BEGIN DMAx_R1_M1_TC4 */

    /* USER CODE END DMAx_R1_M1_TC4 */     
  } 
  /* USER CODE BEGIN DMAx_R1_M1_IRQn 1 */

  /* USER CODE END DMAx_R1_M1_IRQn 1 */ 
}
</#if>

<#if MC.ENCODER==true || MC.AUX_ENCODER==true || MC.HALL_SENSORS==true || MC.AUX_HALL_SENSORS==true>
/**
  * @brief  This function handles TIMx global interrupt request for M1 Speed Sensor.
  * @param  None
  * @retval None
  */
${IRQHandler_name(_last_word(MC.HALL_TIMER_SELECTION))}  
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
<#else>
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
</#if>
  /* USER CODE BEGIN SPD_TIM_M1_IRQn 1 */

  /* USER CODE END SPD_TIM_M1_IRQn 1 */ 
}
</#if>
<#if MC.SERIAL_COMMUNICATION==true>

/*Start here***********************************************************/
/*GUI, this section is present only if serial communication is enabled*/
/**
  * @brief  This function handles USART interrupt request.
  * @param  None
  * @retval None
  */
${IRQHandler_name(_last_word(MC.USART_SELECTION))}
{
  /* USER CODE BEGIN USART_IRQn 0 */

  /* USER CODE END USART_IRQn 0 */ 
<#if MC.SERIAL_COM_MODE == "COM_UNIDIRECTIONAL">
  if (LL_USART_IsActiveFlag_TXE(pUFC->Hw.USARTx))
  {
    UFC_TX_IRQ_Handler(pUFC);
  }
<#else>  
  if (LL_USART_IsActiveFlag_RXNE(pUSART.USARTx))
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
  /* USER CODE BEGIN USART_RXNE */

  /* USER CODE END USART_RXNE   */ 	
	
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
    UI_SerialCommunicationTimeOutStop();
    /* USER CODE BEGIN USART_ORE */

    /* USER CODE END USART_ORE   */   
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
  if ( LL_EXTI_ReadRisingFlag_0_31(LL_EXTI_LINE_${_last_word(MC.START_STOP_GPIO_PIN)}) ||
       LL_EXTI_ReadFallingFlag_0_31(LL_EXTI_LINE_${_last_word(MC.START_STOP_GPIO_PIN)}) ) 
  {                                                                                
    LL_EXTI_ClearRisingFlag_0_31(LL_EXTI_LINE_${_last_word(MC.START_STOP_GPIO_PIN)});  
    LL_EXTI_ClearFallingFlag_0_31(LL_EXTI_LINE_${_last_word(MC.START_STOP_GPIO_PIN)});
    UI_HandleStartStopButton_cb ();                                               
  }'> 
    <#else>
      <#assign Template_StartStop = '/* USER CODE BEGIN START_STOP_BTN */
  if ( LL_EXTI_ReadRisingFlag_32_63(LL_EXTI_LINE_${_last_word(MC.START_STOP_GPIO_PIN)}) ||
       LL_EXTI_ReadFallingFlag_32_63(LL_EXTI_LINE_${_last_word(MC.START_STOP_GPIO_PIN)}) )   
  {                                                                                
    LL_EXTI_ClearRisingFlag_32_63(LL_EXTI_LINE_${_last_word(MC.START_STOP_GPIO_PIN)});  
    LL_EXTI_ClearFallingFlag_32_63(LL_EXTI_LINE_${_last_word(MC.START_STOP_GPIO_PIN)});
    UI_HandleStartStopButton_cb ();                                               
  }'> 
    </#if>
  </#if>

  <#if MC.ENC_USE_CH3 == true>
    <#assign EXT_IRQHandler_ENC_Z_M1_Name = "${EXT_IRQHandler(_last_word(MC.ENC_Z_GPIO_PIN)?number)}" >
    <#if _last_word(MC.ENC_Z_GPIO_PIN)?number < 32 >
      <#assign Template_Encoder_Z_M1 = '/* USER CODE BEGIN ENCODER Z INDEX M1 */
  if ( LL_EXTI_ReadRisingFlag_0_31(LL_EXTI_LINE_${_last_word(MC.ENC_Z_GPIO_PIN)}) ||
       LL_EXTI_ReadFallingFlag_0_31(LL_EXTI_LINE_${_last_word(MC.ENC_Z_GPIO_PIN)}) ) 
  {                                                                                
    LL_EXTI_ClearRisingFlag_0_31(LL_EXTI_LINE_${_last_word(MC.ENC_Z_GPIO_PIN)});  
    LL_EXTI_ClearFallingFlag_0_31(LL_EXTI_LINE_${_last_word(MC.ENC_Z_GPIO_PIN)});
    TC_EncoderReset(&pPosCtrlM1); 
  }'> 
  <#else>
  <#assign Template_StartStop = '/* USER CODE BEGIN ENCODER Z INDEX M1 */
  if ( LL_EXTI_ReadRisingFlag_32_63(LL_EXTI_LINE_${_last_word(MC.ENC_Z_GPIO_PIN)}) ||
       LL_EXTI_ReadFallingFlag_32_63(LL_EXTI_LINE_${_last_word(MC.ENC_Z_GPIO_PIN)}) )   
  {                                                                                
    LL_EXTI_ClearRisingFlag_32_63(LL_EXTI_LINE_${_last_word(MC.ENC_Z_GPIO_PIN)});  
    LL_EXTI_ClearFallingFlag_32_63(LL_EXTI_LINE_${_last_word(MC.ENC_Z_GPIO_PIN)});
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
