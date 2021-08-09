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

/**
  ******************************************************************************
  * @file    stm32f30x_mc_it.c 
  * @author  Motor Control SDK Team, ST Microelectronics
  * @brief   Main Interrupt Service Routines.
  *          This file provides exceptions handler and peripherals interrupt 
  *          service routine related to Motor Control for the STM32F3 Family.
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
  * @ingroup STM32F30x_IRQ_Handlers
  */ 

/* Includes ------------------------------------------------------------------*/
#include "mc_type.h"
#include "mc_tasks.h"
#include "ui_task.h"
#include "parameters_conversion.h"
#include "motorcontrol.h"
<#if MC.RTOS == "FREERTOS">
#include "cmsis_os.h"
</#if>
<#if MC.PFC_ENABLED == true>
  #include "PFCApplication.h"
</#if>
<#if MC.START_STOP_BTN == true>
#include "stm32f3xx_ll_exti.h"
</#if>
#include "stm32f3xx_it.h"

/* USER CODE BEGIN Includes */

/* USER CODE END Includes */

/** @addtogroup MCSDK
  * @{
  */

/** @addtogroup STM32F30x_IRQ_Handlers STM32F30x IRQ Handlers
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
<#if MC.ADC_PERIPH == "ADC1" || MC.ADC_PERIPH == "ADC2" || MC.ADC_PERIPH2 == "ADC1" || MC.ADC_PERIPH2 == "ADC2">
void ADC1_2_IRQHandler(void);
</#if>
<#if MC.ADC_PERIPH == "ADC3" || MC.ADC_PERIPH2 == "ADC3" >
void ADC3_IRQHandler(void);
</#if>
<#if MC.ADC_PERIPH == "ADC4" || MC.ADC_PERIPH2 == "ADC4" >
void ADC4_IRQHandler(void);
</#if>
void TIMx_UP_M1_IRQHandler(void);
void TIMx_BRK_M1_IRQHandler(void);
<#if MC.ENCODER == true || MC.AUX_ENCODER == true || MC.HALL_SENSORS == true || MC.AUX_HALL_SENSORS == true>
void SPD_TIM_M1_IRQHandler(void);
</#if>
<#if MC.DUALDRIVE == true>
void TIMx_UP_M2_IRQHandler(void);
void TIMx_BRK_M2_IRQHandler(void);
  <#if MC.ENCODER2 == true || MC.AUX_ENCODER2 == true || MC.HALL_SENSORS2 == true || MC.AUX_HALL_SENSORS2 == true>
void SPD_TIM_M2_IRQHandler(void);
  </#if>
</#if>
<#if MC.PFC_ENABLED == true && MC.PWM_TIMER_SELECTION == 'PWM_TIM8' && MC.SINGLEDRIVE == true>
void TIM1_UP_TIM16_IRQHandler(void);
</#if>
<#if MC.SERIAL_COMMUNICATION == true>
void USART_IRQHandler(void);
</#if>
void HardFault_Handler(void);
void SysTick_Handler(void);
<#if MC.START_STOP_BTN == true || MC.ENC_USE_CH3 == true>
void ${EXT_IRQHandler(_last_word(MC.START_STOP_GPIO_PIN)?number)} (void);
</#if>

<#if MC.ADC_PERIPH == "ADC1" || MC.ADC_PERIPH == "ADC2" || MC.ADC_PERIPH2 == "ADC1" || MC.ADC_PERIPH2 == "ADC2">
#if defined (CCMRAM)
#if defined (__ICCARM__)
#pragma location = ".ccmram"
#elif defined (__CC_ARM) || defined(__GNUC__)
__attribute__((section (".ccmram")))
#endif
#endif
/**
  * @brief  This function handles ADC1/ADC2 interrupt request.
  * @param  None
  * @retval None
  */
void ADC1_2_IRQHandler(void)
{
  /* USER CODE BEGIN ADC1_2_IRQn 0 */

  /* USER CODE END ADC1_2_IRQn 0 */
  
<#if MC.DUALDRIVE == true >
<#if (MC.ADC_PERIPH == "ADC1" && MC.ADC_PERIPH2 == "ADC2") || 
     (MC.ADC_PERIPH == "ADC2" && MC.ADC_PERIPH2 == "ADC1") >
  // Shared IRQ management - begin
  if ( LL_ADC_IsActiveFlag_JEOS( ${MC.ADC_PERIPH}) )
  {
</#if>
</#if> 
  <#if MC.ADC_PERIPH == "ADC1" || MC.ADC_PERIPH == "ADC2" >
  // Clear Flags M1
  LL_ADC_ClearFlag_JEOS( ${MC.ADC_PERIPH} );
  </#if>

<#if MC.DUALDRIVE == true>
<#if (MC.ADC_PERIPH == "ADC1" && MC.ADC_PERIPH2 == "ADC2") || 
     (MC.ADC_PERIPH == "ADC2" && MC.ADC_PERIPH2 == "ADC1") >
  }
  else if ( LL_ADC_IsActiveFlag_JEOS( ${MC.ADC_PERIPH2} ) )
  {
</#if> 
<#-- In case of same ADC for both motors, we must not clear the interrupt twice -->
<#if MC.ADC_PERIPH2 == "ADC1" || MC.ADC_PERIPH2 == "ADC2" >
  <#if MC.ADC_PERIPH != MC.ADC_PERIPH2 >
  // Clear Flags M2
  LL_ADC_ClearFlag_JEOS( ${MC.ADC_PERIPH2} );
  </#if>
</#if>
<#if ( MC.ADC_PERIPH == "ADC1" && MC.ADC_PERIPH2 == "ADC2" ) || 
     (MC.ADC_PERIPH == "ADC2" && MC.ADC_PERIPH2 == "ADC1") >
  }
</#if>
</#if>
<#if MC.DAC_FUNCTIONALITY == true>
  // Highfrequency task 
  UI_DACUpdate(TSK_HighFrequencyTask());
<#else>
  // Highfrequency task 
  TSK_HighFrequencyTask();
</#if>
 /* USER CODE BEGIN HighFreq */

 /* USER CODE END HighFreq  */  
 
 /* USER CODE BEGIN ADC1_2_IRQn 1 */

 /* USER CODE END ADC1_2_IRQn 1 */
}
</#if>

<#if MC.ADC_PERIPH == "ADC3" || MC.ADC_PERIPH2 == "ADC3" >
#if defined (CCMRAM)
#if defined (__ICCARM__)
#pragma location = ".ccmram"
#elif defined (__CC_ARM) || defined(__GNUC__)
__attribute__((section (".ccmram")))
#endif
#endif
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

<#if MC.ADC_PERIPH == "ADC4" || MC.ADC_PERIPH2 == "ADC4" >
#if defined (CCMRAM)
#if defined (__ICCARM__)
#pragma location = ".ccmram"
#elif defined (__CC_ARM) || defined(__GNUC__)
__attribute__((section (".ccmram")))
#endif
#endif
/**
  * @brief  This function handles ADC4 interrupt request.
  * @param  None
  * @retval None
  */
void ADC4_IRQHandler(void)
{
 /* USER CODE BEGIN ADC4_IRQn 0 */

 /* USER CODE END  ADC4_IRQn 0 */  
 
  // Clear Flags
  LL_ADC_ClearFlag_JEOS( ADC4 );
<#if MC.DAC_FUNCTIONALITY == true>
  
  // Highfrequency task ADC4
  UI_DACUpdate(TSK_HighFrequencyTask());
<#else>
  
  // Highfrequency task ADC4
  TSK_HighFrequencyTask();
</#if>

 /* USER CODE BEGIN ADC4_IRQn 1 */

 /* USER CODE END  ADC4_IRQn 1 */ 
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

 /* USER CODE END  TIMx_UP_M1_IRQn 0 */ 
 
<#if MC.PFC_ENABLED == true>
  if(LL_TIM_IsActiveFlag_BRK(TIM16))
  {
    LL_TIM_ClearFlag_BRK(TIM16);
    PFC_OCP_Processing();
  } 
  else
  {
</#if>
    LL_TIM_ClearFlag_UPDATE(${_last_word(MC.PWM_TIMER_SELECTION)});
 <#if MC.SINGLE_SHUNT == true>  
    R1F30X_TIMx_UP_IRQHandler(&PWM_Handle_M1);
 <#elseif MC.ICS_SENSORS == true>     
    ICS_TIMx_UP_IRQHandler(&PWM_Handle_M1);
 <#elseif MC.THREE_SHUNT == true>
    R3_1_TIMx_UP_IRQHandler(&PWM_Handle_M1);    
 <#else>
    R3_2_TIMx_UP_IRQHandler(&PWM_Handle_M1);
 </#if>
 <#if MC.DUALDRIVE == true>    
    TSK_DualDriveFIFOUpdate(M1);
</#if>

<#if MC.PFC_ENABLED == true>
  }
</#if>
 /* USER CODE BEGIN TIMx_UP_M1_IRQn 1 */

 /* USER CODE END  TIMx_UP_M1_IRQn 1 */ 
}

<#if MC.PFC_ENABLED == true && MC.PWM_TIMER_SELECTION == 'PWM_TIM8' && MC.SINGLEDRIVE == true>
/**
  * @brief  This function handles PFC function if motor 1 use TIM8.
  * @param  None
  * @retval None 
  */
void TIM1_UP_TIM16_IRQHandler(void)
{
 /* USER CODE BEGIN TIM1_UP_TIM16_IRQn 0 */

 /* USER CODE END  TIM1_UP_TIM16_IRQn 0 */ 
 
  if(LL_TIM_IsActiveFlag_BRK(TIM16))
  {
    LL_TIM_ClearFlag_BRK(TIM16);
    PFC_OCP_Processing();
    /* USER CODE BEGIN PFCM1 OCP */

    /* USER CODE END  PFCM1 OCP */
  } 
 /* USER CODE BEGIN TIM1_UP_TIM16_IRQn 1 */

 /* USER CODE END  TIM1_UP_TIM16_IRQn 1 */  
}
</#if>

void TIMx_BRK_M1_IRQHandler(void)
{
  /* USER CODE BEGIN TIMx_BRK_M1_IRQn 0 */

  /* USER CODE END TIMx_BRK_M1_IRQn 0 */ 
  if (LL_TIM_IsActiveFlag_BRK(${_last_word(MC.PWM_TIMER_SELECTION)}))
  {
    LL_TIM_ClearFlag_BRK(${_last_word(MC.PWM_TIMER_SELECTION)});
<#if  MC.SINGLE_SHUNT == true>  
    R1F30X_BRK_IRQHandler(&PWM_Handle_M1);
<#elseif  MC.ICS_SENSORS == true> 
    ICS_BRK_IRQHandler(&PWM_Handle_M1);
<#elseif  MC.THREE_SHUNT == true> 
    R3_1_BRK_IRQHandler(&PWM_Handle_M1);    
<#else>
    R3_2_BRK_IRQHandler(&PWM_Handle_M1);
</#if>
  }
  if (LL_TIM_IsActiveFlag_BRK2(${_last_word(MC.PWM_TIMER_SELECTION)}))
  {
    LL_TIM_ClearFlag_BRK2(${_last_word(MC.PWM_TIMER_SELECTION)});  
<#if MC.SINGLE_SHUNT == true>  
    R1F30X_BRK2_IRQHandler(&PWM_Handle_M1);
<#elseif MC.ICS_SENSORS == true> 
    ICS_BRK2_IRQHandler(&PWM_Handle_M1);
<#elseif MC.THREE_SHUNT == true> 
    R3_1_BRK2_IRQHandler(&PWM_Handle_M1);    
<#else>
    R3_2_BRK2_IRQHandler(&PWM_Handle_M1); 
</#if>
  }
  /* Systick is not executed due low priority so is necessary to call MC_Scheduler here.*/
  MC_Scheduler();
  
  /* USER CODE BEGIN TIMx_BRK_M1_IRQn 1 */

  /* USER CODE END TIMx_BRK_M1_IRQn 1 */ 
}

<#if MC.DUALDRIVE == true>
/**
  * @brief  This function handles second motor TIMx Update interrupt request.
  * @param  None
  * @retval None 
  */
void TIMx_UP_M2_IRQHandler(void)
{
 /* USER CODE BEGIN TIMx_UP_M2_IRQn 0 */

 /* USER CODE END  TIMx_UP_M2_IRQn 0 */ 
<#if MC.PFC_ENABLED == true>
  if(LL_TIM_IsActiveFlag_BRK(TIM16))
  {
    LL_TIM_ClearFlag_BRK(TIM16);
    PFC_OCP_Processing();
    /* USER CODE BEGIN PFCM2 OCP */

    /* USER CODE END  PFCM2 OCP */ 
  } 
  else
  {
</#if>
    LL_TIM_ClearFlag_UPDATE(${_last_word(MC.PWM_TIMER_SELECTION2)});
 <#if MC.SINGLE_SHUNT2 == true>  
    R1F30X_TIMx_UP_IRQHandler(&PWM_Handle_M2);
 <#elseif MC.ICS_SENSORS2 == true>     
    ICS_TIMx_UP_IRQHandler(&PWM_Handle_M2);
 <#else>
    R3_2_TIMx_UP_IRQHandler(&PWM_Handle_M2);
 </#if>
    TSK_DualDriveFIFOUpdate(M2);

<#if MC.PFC_ENABLED == true>
  }
</#if>
 /* USER CODE BEGIN TIMx_UP_M2_IRQn 1 */

 /* USER CODE END  TIMx_UP_M2_IRQn 1 */ 
}

void TIMx_BRK_M2_IRQHandler(void)
{
  /* USER CODE BEGIN TIMx_BRK_M2_IRQn 0 */

  /* USER CODE END TIMx_BRK_M2_IRQn 0 */
  
  if (LL_TIM_IsActiveFlag_BRK(${_last_word(MC.PWM_TIMER_SELECTION2)}))
  {
    LL_TIM_ClearFlag_BRK(${_last_word(MC.PWM_TIMER_SELECTION2)});
<#if  MC.SINGLE_SHUNT2 == true>  
    R1F30X_BRK_IRQHandler(&PWM_Handle_M2);
<#elseif  MC.ICS_SENSORS2 == true> 
    ICS_BRK_IRQHandler(&PWM_Handle_M2);
<#else>
    R3_2_BRK_IRQHandler(&PWM_Handle_M2);
</#if>    
  /* USER CODE BEGIN BRK */

  /* USER CODE END BRK */

  }
  if (LL_TIM_IsActiveFlag_BRK2(${_last_word(MC.PWM_TIMER_SELECTION2)}))
  {
    LL_TIM_ClearFlag_BRK2(${_last_word(MC.PWM_TIMER_SELECTION2)});
    
<#if  MC.SINGLE_SHUNT2 == true>  
    R1F30X_BRK2_IRQHandler(&PWM_Handle_M2);
<#elseif  MC.ICS_SENSORS2 == true> 
    ICS_BRK2_IRQHandler(&PWM_Handle_M2);
<#else>
    R3_2_BRK2_IRQHandler(&PWM_Handle_M2);
</#if>    
  /* USER CODE BEGIN BRK2 */

  /* USER CODE END BRK2 */
  }
  /* Systick is not executed due low priority so is necessary to call MC_Scheduler here.*/
  MC_Scheduler();
  /* USER CODE BEGIN TIMx_BRK_M2_IRQn 1 */

  /* USER CODE END TIMx_BRK_M2_IRQn 1 */
}
</#if>
<#if MC.ENCODER == true || MC.AUX_ENCODER == true || MC.HALL_SENSORS == true || MC.AUX_HALL_SENSORS == true>

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

<#if MC.DUALDRIVE == true>
<#if MC.ENCODER2 == true || MC.AUX_ENCODER2 == true || MC.HALL_SENSORS2 == true || MC.AUX_HALL_SENSORS2 == true>

/**
  * @brief  This function handles TIMx global interrupt request for M2 Speed Sensor.
  * @param  None
  * @retval None
  */
void SPD_TIM_M2_IRQHandler(void)
{
  /* USER CODE BEGIN SPD_TIM_M2_IRQn 0 */

  /* USER CODE END SPD_TIM_M2_IRQn 0 */ 

<#if MC.HALL_SENSORS2 == true || MC.AUX_HALL_SENSORS2 == true>
  /* HALL Timer Update IT always enabled, no need to check enable UPDATE state */
  if (LL_TIM_IsActiveFlag_UPDATE(HALL_M2.TIMx) != 0)
  {
    LL_TIM_ClearFlag_UPDATE(HALL_M2.TIMx);
    HALL_TIMx_UP_IRQHandler(&HALL_M2);
    /* USER CODE BEGIN M2 HALL_Update */

    /* USER CODE END M2 HALL_Update   */ 
  }
  else
  {
    /* Nothing to do */
  }
  /* HALL Timer CC1 IT always enabled, no need to check enable CC1 state */
  if (LL_TIM_IsActiveFlag_CC1 (HALL_M2.TIMx)) 
  {
    LL_TIM_ClearFlag_CC1(HALL_M2.TIMx);
    HALL_TIMx_CC_IRQHandler(&HALL_M2);
    /* USER CODE BEGIN M2 HALL_CC1 */

    /* USER CODE END M2 HALL_CC1 */ 
  }
  else
  {
  /* Nothing to do */
  }
<#else>
  /* Encoder Timer UPDATE IT is dynamicaly enabled/disabled, checking enable state is required */
  if (LL_TIM_IsEnabledIT_UPDATE (ENCODER_M2.TIMx) && LL_TIM_IsActiveFlag_UPDATE (ENCODER_M2.TIMx))
  { 
    LL_TIM_ClearFlag_UPDATE(ENCODER_M2.TIMx);
    ENC_IRQHandler(&ENCODER_M2);
    /* USER CODE BEGIN M2 ENCODER_Update */

    /* USER CODE END M2 ENCODER_Update   */ 
  }
  else
  {
  /* No other IT to manage for encoder config */
  }
</#if>
  /* USER CODE BEGIN SPD_TIM_M2_IRQn 1 */

  /* USER CODE END SPD_TIM_M2_IRQn 1 */ 
}
</#if>
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
  if (LL_USART_IsActiveFlag_RXNE(pUSART.USARTx)) /* Valid data have been received */
  {
    uint16_t retVal;
    retVal = *(uint16_t*)UFCP_RX_IRQ_Handler(&pUSART,LL_USART_ReceiveData8(pUSART.USARTx));
    if (retVal == 1)
    {
      UI_SerialCommunicationTimeOutStart();
    }
    if (retVal == 2)
    {
      UI_SerialCommunicationTimeOutStop();
    }
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
    UI_SerialCommunicationTimeOutStop();
    /* USER CODE BEGIN USART_ORE */

    /* USER CODE END USART_ORE   */   
  }
</#if>    
  /* USER CODE BEGIN USART_IRQn 1 */
  
  /* USER CODE END USART_IRQn 1 */

}
/*End here***********************************************************/
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

<#function EXT_IRQHandler line>
    <#local EXTI_IRQ =
        [ {"name": "EXTI0_IRQHandler", "line": 0} 
        , {"name": "EXTI1_IRQHandler", "line": 1} 
        , {"name": "EXTI2_TSC_IRQHandler", "line": 2}
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

<#if MC.START_STOP_BTN == true || MC.ENC_USE_CH3 == true || MC.ENC_USE_CH32 == true >
<#-- GUI, this section is present only if start/stop button and/or Position Control with Z channel is enabled -->
  
<#assign EXT_IRQHandler_StartStopName = "" >
<#assign EXT_IRQHandler_ENC_Z_M1_Name = "" >
<#assign EXT_IRQHandler_ENC_Z_M2_Name = "" >
<#assign Template_StartStop ="">
<#assign Template_Encoder_Z_M1 ="">
<#assign Template_Encoder_Z_M2 ="">

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
</#if> 

<#if MC.ENC_USE_CH32 == true>
  <#assign EXT_IRQHandler_ENC_Z_M2_Name = "${EXT_IRQHandler(_last_word(MC.ENC_Z_GPIO_PIN2)?number)}" >
  <#if _last_word(MC.ENC_Z_GPIO_PIN2)?number < 32 >
  <#assign Template_Encoder_Z_M2 = '/* USER CODE BEGIN ENCODER Z INDEX M2 */
  if (LL_EXTI_ReadFlag_0_31(LL_EXTI_LINE_${_last_word(MC.ENC_Z_GPIO_PIN2)}))  
  {                                                                           
    LL_EXTI_ClearFlag_0_31 (LL_EXTI_LINE_${_last_word(MC.ENC_Z_GPIO_PIN2)});  
    TC_EncoderReset(&pPosCtrlM2);                                             
  }'> 
  <#else>
  <#assign Template_Encoder_Z_M2 = '/* USER CODE BEGIN ENCODER Z INDEX M2 */
  if (LL_EXTI_ReadFlag_32_63(LL_EXTI_LINE_${_last_word(MC.ENC_Z_GPIO_PIN2)}))  
  {                                                                            
    LL_EXTI_ClearFlag_32_63 (LL_EXTI_LINE_${_last_word(MC.ENC_Z_GPIO_PIN2)});  
    TC_EncoderReset(&pPosCtrlM2);                                              
  }'> 
  </#if> 
</#if> 
  
<#if MC.START_STOP_BTN == true>
/**
  * @brief  This function handles Button IRQ on PIN P${ _last_char(MC.START_STOP_GPIO_PORT)}${_last_word(MC.START_STOP_GPIO_PIN)}.
<#if MC.ENC_USE_CH3 == true && "${EXT_IRQHandler_StartStopName}" == "${EXT_IRQHandler_ENC_Z_M1_Name}">
  *                 and M1 Encoder Index IRQ on PIN P${ _last_char(MC.ENC_Z_GPIO_PORT)}${_last_word(MC.ENC_Z_GPIO_PIN)}.
</#if>  
<#if MC.ENC_USE_CH32 == true && "${EXT_IRQHandler_StartStopName}" == "${EXT_IRQHandler_ENC_Z_M2_Name}">
  *                 and M2 Encoder Index IRQ on PIN P${ _last_char(MC.ENC_Z_GPIO_PORT2)}${_last_word(MC.ENC_Z_GPIO_PIN2)}.
</#if>  
  */
void ${EXT_IRQHandler_StartStopName} (void)
{
	${Template_StartStop}

	<#if "${EXT_IRQHandler_StartStopName}" == "${EXT_IRQHandler_ENC_Z_M1_Name}" >
	${Template_Encoder_Z_M1}
	</#if>
	
	<#if "${EXT_IRQHandler_StartStopName}" == "${EXT_IRQHandler_ENC_Z_M2_Name}" >
	${Template_Encoder_Z_M2}
	</#if>
}
</#if>

<#if MC.ENC_USE_CH3 == true>
	<#if "${EXT_IRQHandler_StartStopName}" != "${EXT_IRQHandler_ENC_Z_M1_Name}" >
/**
  * @brief  This function handles M1 Encoder Index IRQ on PIN P${ _last_char(MC.ENC_Z_GPIO_PORT)}${_last_word(MC.ENC_Z_GPIO_PIN)}.
<#if MC.ENC_USE_CH32 == true && "${EXT_IRQHandler_ENC_Z_M1_Name}" == "${EXT_IRQHandler_ENC_Z_M2_Name}" >
  *                 and M2 Encoder Index IRQ on PIN P${ _last_char(MC.ENC_Z_GPIO_PORT2)}${_last_word(MC.ENC_Z_GPIO_PIN2)}.
</#if>  
  */
void ${EXT_IRQHandler_ENC_Z_M1_Name} (void)
{
	${Template_Encoder_Z_M1}
	
	<#if "${EXT_IRQHandler_ENC_Z_M1_Name}" == "${EXT_IRQHandler_ENC_Z_M2_Name}" >
	${Template_Encoder_Z_M2}
	</#if>

}	
	</#if>
</#if> 

<#if MC.ENC_USE_CH32 == true>
	<#if "${EXT_IRQHandler_StartStopName}" != "${EXT_IRQHandler_ENC_Z_M2_Name}" && "${EXT_IRQHandler_ENC_Z_M1_Name}" != "${EXT_IRQHandler_ENC_Z_M2_Name}">
/**
  * @brief  This function handles M2 Encoder Index IRQ on PIN P${ _last_char(MC.ENC_Z_GPIO_PORT2)}${_last_word(MC.ENC_Z_GPIO_PIN2)}.
  */	
void ${EXT_IRQHandler_ENC_Z_M2_Name} (void)
{
	${Template_Encoder_Z_M2}
	
}	
	</#if>
</#if> 

</#if> 

/* USER CODE BEGIN 1 */

/* USER CODE END 1 */


/**
  * @}
  */

/**
  * @}
  */

/******************* (C) COPYRIGHT 2019 STMicroelectronics *****END OF FILE****/
