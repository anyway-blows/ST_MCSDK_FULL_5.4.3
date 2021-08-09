/**
  ******************************************************************************
  * @file    r1_g0xx_pwm_curr_fdbk.c
  * @author  Motor Control SDK Team, ST Microelectronics
  * @brief   This file provides firmware functions that implement current sensor
  *          class to be stantiated when the single shunt current sensing
  *          topology is used. It is specifically designed for STM32F0XX
  *          microcontrollers and implements the successive sampling of two motor
  *          current using only one ADC.
  *           + MCU peripheral and handle initialization fucntion
  *           + three shunt current sesnsing
  *           + space vector modulation function
  *           + ADC sampling function
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
#include "r1_g0xx_pwm_curr_fdbk.h"
#include "pwm_common.h"
#include "mc_type.h"

/** @addtogroup MCSDK
  * @{
  */

/** @defgroup r1_g0XX_pwm_curr_fdbk
  * @brief PWM F0XX single shunt component of the Motor Control SDK
  *
  * @{
  */

/* Private Defines -----------------------------------------------------------*/
#define REGULAR         ((uint8_t)0u)
#define BOUNDARY_1      ((uint8_t)1u)  /* Two small, one big */
#define BOUNDARY_2      ((uint8_t)2u)  /* Two big, one small */
#define BOUNDARY_3      ((uint8_t)3u)  /* Three equal        */

#define INVERT_NONE 0u
#define INVERT_A 1u
#define INVERT_B 2u
#define INVERT_C 3u

#define SAMP_NO 0u
#define SAMP_IA 1u
#define SAMP_IB 2u
#define SAMP_IC 3u
#define SAMP_NIA 4u
#define SAMP_NIB 5u
#define SAMP_NIC 6u
#define SAMP_OLDA 7u
#define SAMP_OLDB 8u
#define SAMP_OLDC 9u

#define TIMxCCER_MASK_CH123              (TIM_CCER_CC1E|TIM_CCER_CC2E|TIM_CCER_CC3E|\
                                          TIM_CCER_CC1NE|TIM_CCER_CC2NE|TIM_CCER_CC3NE)

/* Constant values -----------------------------------------------------------*/
static const uint8_t REGULAR_SAMP_CUR1[6] = {SAMP_NIC,SAMP_NIC,SAMP_NIA,SAMP_NIA,SAMP_NIB,SAMP_NIB};
static const uint8_t REGULAR_SAMP_CUR2[6] = {SAMP_IA,SAMP_IB,SAMP_IB,SAMP_IC,SAMP_IC,SAMP_IA};
static const uint8_t BOUNDR1_SAMP_CUR2[6] = {SAMP_IB,SAMP_IB,SAMP_IC,SAMP_IC,SAMP_IA,SAMP_IA};
static const uint8_t BOUNDR2_SAMP_CUR1[6] = {SAMP_IA,SAMP_IB,SAMP_IB,SAMP_IC,SAMP_IC,SAMP_IA};
static const uint8_t BOUNDR2_SAMP_CUR2[6] = {SAMP_IC,SAMP_IA,SAMP_IA,SAMP_IB,SAMP_IB,SAMP_IC};

/* Private function prototypes -----------------------------------------------*/
void R1G0XX_1ShuntMotorVarsRestart(PWMC_Handle_t *pHdl);
void R1G0XX_TIMxInit(TIM_TypeDef* TIMx, PWMC_Handle_t *pHdl);

/* Private functions ---------------------------------------------------------*/

/**
  * @brief  It initializes TIM1, ADC, GPIO, DMA1 and NVIC for single shunt current
  *         reading configuration using STM32F0XX family.
  * @param  pHdl: handler of the current instance of the PWM component
  * @retval none
  */
__weak void R1G0XX_Init(PWMC_R1_G0_Handle_t *pHandle)
{
  
  if ((uint32_t)pHandle == (uint32_t)&pHandle->_Super)
  {
    /* disable IT and flags in case of LL driver usage
     * workaround for unwanted interrupt enabling done by LL driver */
    LL_ADC_DisableIT_EOC( ADC1 );
    LL_ADC_ClearFlag_EOC( ADC1 );
    LL_ADC_DisableIT_EOS( ADC1 );
    LL_ADC_ClearFlag_EOS( ADC1 );
    /* DMA Event related to TIM1 Channel 4 */
    /* DMA1 Channel4 configuration ----------------------------------------------*/
    LL_DMA_SetMemoryAddress(DMA1, LL_DMA_CHANNEL_4, (uint32_t)pHandle->DmaBuff);
    LL_DMA_SetPeriphAddress(DMA1, LL_DMA_CHANNEL_4, (uint32_t)&(TIM1->CCR1));
    LL_DMA_SetDataLength( DMA1, LL_DMA_CHANNEL_4, 2u );

    /* ensable DMA1 Channel4 */
    LL_DMA_EnableChannel(DMA1, LL_DMA_CHANNEL_4);
    
    /* Debug feature, we froze the timer if the MCU is halted by the debugger*/
    LL_APB1_GRP1_EnableClock(LL_APB1_GRP1_PERIPH_DBGMCU);
    LL_DBGMCU_APB2_GRP1_FreezePeriph(LL_DBGMCU_APB2_GRP1_TIM1_STOP);
    /* End of debug feature */
    
     R1G0XX_TIMxInit(TIM1, &pHandle->_Super);


    /* DMA Event related to ADC conversion*/
    /* DMA channel configuration ----------------------------------------------*/
    LL_DMA_SetMemoryAddress(DMA1, LL_DMA_CHANNEL_1, (uint32_t)pHandle->CurConv);
    LL_DMA_SetPeriphAddress(DMA1, LL_DMA_CHANNEL_1, (uint32_t)&ADC1->DR);
    LL_DMA_SetDataLength(DMA1, LL_DMA_CHANNEL_1, 2u);

    /* DMA1 channel 1 will be enabled after the CurrentReadingCalibration */

    if ( LL_ADC_IsInternalRegulatorEnabled(ADC1) == 0u)
    {
      /* Enable ADC internal voltage regulator */
      LL_ADC_EnableInternalRegulator(ADC1);

      /* Wait for Regulator Startup time, once for both */
      /* Note: Variable divided by 2 to compensate partially              */
      /*       CPU processing cycles, scaling in us split to not          */
      /*       exceed 32 bits register capacity and handle low frequency. */
      volatile uint32_t wait_loop_index = ((LL_ADC_DELAY_INTERNAL_REGUL_STAB_US / 10UL) * (SystemCoreClock / (100000UL * 2UL)));
      while(wait_loop_index != 0UL)
      {
        wait_loop_index--;
      }
    }
    /* Start calibration of ADC1 */
    LL_ADC_StartCalibration(ADC1);
    while(LL_ADC_IsCalibrationOnGoing(ADC1) == 1)
    {}

    /* Enable ADC */
    LL_ADC_REG_SetSequencerConfigurable (ADC1, LL_ADC_REG_SEQ_FIXED);
    LL_ADC_REG_SetTriggerSource (ADC1, LL_ADC_REG_TRIG_SOFTWARE);
    LL_ADC_REG_SetDMATransfer(ADC1, LL_ADC_REG_DMA_TRANSFER_NONE);
    LL_ADC_Enable(ADC1);
    

    /* Wait ADC Ready */
    while (LL_ADC_IsActiveFlag_ADRDY(ADC1)==RESET)
    {}
    
    R1G0XX_1ShuntMotorVarsRestart(&pHandle->_Super);

    LL_DMA_EnableIT_TC(DMA1, LL_DMA_CHANNEL_1);
    
    /* enable active window DMA TC when repetion counter > 1 */
    if (pHandle->pParams_str->RepetitionCounter > 1)
    {
      LL_DMA_EnableIT_TC(DMA1, LL_DMA_CHANNEL_4);
    }

    LL_TIM_EnableCounter(TIM1);

    pHandle->ADCRegularLocked=false; /* We allow ADC usage for regular conversion on Systick*/
    pHandle->_Super.DTTest = 0u;

  }
}

/**
  * @brief  It initializes TIMx for PWM generation,
  *          active vector insertion and adc triggering.
  * @param  TIMx Timer to be initialized
  * @param  pHdl: handler of the current instance of the PWM component
  * @retval none
  */
__weak void R1G0XX_TIMxInit(TIM_TypeDef* TIMx, PWMC_Handle_t *pHdl)
{

  PWMC_R1_G0_Handle_t *pHandle = (PWMC_R1_G0_Handle_t *)pHdl;

  LL_TIM_CC_EnableChannel(TIMx, LL_TIM_CHANNEL_CH1);
  LL_TIM_CC_EnableChannel(TIMx, LL_TIM_CHANNEL_CH2);
  LL_TIM_CC_EnableChannel(TIMx, LL_TIM_CHANNEL_CH3);

  if ((pHandle->pParams_str->LowSideOutputs)== LS_PWM_TIMER)
  {
     LL_TIM_CC_EnableChannel(TIMx, LL_TIM_CHANNEL_CH1N);
     LL_TIM_CC_EnableChannel(TIMx, LL_TIM_CHANNEL_CH2N);
     LL_TIM_CC_EnableChannel(TIMx, LL_TIM_CHANNEL_CH3N);
  }

  LL_TIM_OC_EnablePreload(TIMx, LL_TIM_CHANNEL_CH1);
  LL_TIM_OC_EnablePreload(TIMx, LL_TIM_CHANNEL_CH2);
  LL_TIM_OC_EnablePreload(TIMx, LL_TIM_CHANNEL_CH3);
  LL_TIM_OC_EnablePreload(TIMx, LL_TIM_CHANNEL_CH4);
  LL_TIM_OC_EnablePreload(TIMx, LL_TIM_CHANNEL_CH5);
  LL_TIM_OC_EnablePreload(TIMx, LL_TIM_CHANNEL_CH6);

  LL_TIM_OC_SetDeadTime(TIMx, (pHandle->pParams_str->DeadTime)/2u);
}

/**
  * @brief  It stores into handler the voltage present on the
  *         current feedback analog channel when no current is flowin into the
  *         motor
  * @param  pHdl: handler of the current instance of the PWM component
  * @retval none
  */
__weak void R1G0XX_CurrentReadingCalibration(PWMC_Handle_t *pHdl)
{
  uint8_t bIndex = 0u;
  uint32_t wPhaseOffset = 0u;

  PWMC_R1_G0_Handle_t *pHandle = (PWMC_R1_G0_Handle_t *)pHdl;

  /* Reset the buffered version of update flag to indicate the start of FOC algorithm*/
  pHandle->UpdateFlagBuffer = false; 

  /* We forbid ADC usage for regular conversion on Systick*/
  pHandle->ADCRegularLocked=true; 
  /* ADC Channel config for current reading */
  LL_ADC_REG_SetSequencerChannels ( ADC1, __LL_ADC_DECIMAL_NB_TO_CHANNEL ( pHandle->pParams_str->IChannel ));
  
  /* Disable DMA1 Channel1 */
  LL_DMA_DisableChannel(DMA1, LL_DMA_CHANNEL_1);
  
  /* ADC Channel used for current reading are read 
  in order to get zero currents ADC values*/   
  while (bIndex< NB_CONVERSIONS)
  {     
    /* Software start of conversion */
    LL_ADC_REG_StartConversion(ADC1);
    
    /* Wait until end of regular conversion */
    while (LL_ADC_IsActiveFlag_EOC(ADC1)==RESET)
    {}    
    
    wPhaseOffset += LL_ADC_REG_ReadConversionData12(ADC1);
    bIndex++;
  }
  
  pHandle->PhaseOffset = (uint16_t)(wPhaseOffset/NB_CONVERSIONS);
  
 
}

/**
  * @brief  Initialization of class members after each motor start
  * @param  pHdl: handler of the current instance of the PWM component
  * @retval none
  */
__weak void R1G0XX_1ShuntMotorVarsRestart(PWMC_Handle_t *pHdl)
{
  PWMC_R1_G0_Handle_t *pHandle = (PWMC_R1_G0_Handle_t *)pHdl;
  
  /* Default value of DutyValues */
  pHandle->CntSmp1 = (pHandle->Half_PWMPeriod >> 1) - pHandle->pParams_str->Tbefore;
  pHandle->CntSmp2 = (pHandle->Half_PWMPeriod >> 1) + pHandle->pParams_str->Tafter;
  
  pHandle->Inverted_pwm_new=INVERT_NONE;
  pHandle->Flags &= (~STBD3); /*STBD3 cleared*/
  

  /* After start value of dvDutyValues */
  pHandle->_Super.CntPhA = pHandle->Half_PWMPeriod >> 1;
  pHandle->_Super.CntPhB = pHandle->Half_PWMPeriod >> 1;
  pHandle->_Super.CntPhC = pHandle->Half_PWMPeriod >> 1;
  
  /* Set the default previous value of Phase A,B,C current */
  pHandle->CurrAOld=0;
  pHandle->CurrBOld=0;

   /* After reset, value of DMA buffers for distortion*/
  pHandle->DmaBuff[0] =  pHandle->Half_PWMPeriod + 1u;
  pHandle->DmaBuff[1] =  pHandle->Half_PWMPeriod >> 1; /*dummy*/
  
  pHandle->BrakeActionLock = false;

   }

/**
  * @brief  It computes and return latest converted motor phase currents motor
  * @param  pHdl: handler of the current instance of the PWM component
  * @retval Curr_Components Ia and Ib current in Curr_Components format
  */
__weak void R1G0XX_GetPhaseCurrents(PWMC_Handle_t *pHdl, ab_t* pStator_Currents)
{  
  int32_t wAux;
  int16_t hCurrA = 0;
  int16_t hCurrB = 0;
  int16_t hCurrC = 0;
  uint8_t bCurrASamp = 0u;
  uint8_t bCurrBSamp = 0u;
  uint8_t bCurrCSamp = 0u;
  
  PWMC_R1_G0_Handle_t *pHandle = (PWMC_R1_G0_Handle_t *)pHdl;
  
  /* Enabling the preload to prevent a seecond assertion in case of 
     repetition counter > 1 */
  LL_TIM_OC_EnablePreload(TIM1, LL_TIM_CHANNEL_CH1);
  LL_TIM_OC_EnablePreload(TIM1, LL_TIM_CHANNEL_CH2);
  LL_TIM_OC_EnablePreload(TIM1, LL_TIM_CHANNEL_CH3);
  
  /* Disabling the External triggering for ADCx*/
  LL_ADC_REG_SetTriggerSource (ADC1, LL_ADC_REG_TRIG_SOFTWARE);
  
  /* Reset the update flag to indicate the start of FOC algorithm*/
  pHandle->UpdateFlagBuffer = false;
  
  /* First sampling point */
  wAux = (int32_t)(pHandle->CurConv[0]) - (int32_t)(pHandle->PhaseOffset);
  
  /* Check saturation */
  wAux = (wAux > -INT16_MAX) ? ((wAux < INT16_MAX) ? wAux : INT16_MAX) : -INT16_MAX;
  
  switch (pHandle->sampCur1)
  {
  case SAMP_IA:
    hCurrA = (int16_t)(wAux);
    bCurrASamp = 1u;
    break;
  case SAMP_IB:
    hCurrB = (int16_t)(wAux);
    bCurrBSamp = 1u;
    break;
  case SAMP_IC:
    hCurrC = (int16_t)(wAux);
    bCurrCSamp = 1u;
    break;
  case SAMP_NIA:
    wAux = -wAux;
    hCurrA = (int16_t)(wAux);
    bCurrASamp = 1u;
    break;
  case SAMP_NIB:
    wAux = -wAux;
    hCurrB = (int16_t)(wAux);
    bCurrBSamp = 1u;
    break;
  case SAMP_NIC:
    wAux = -wAux;
    hCurrC = (int16_t)(wAux);
    bCurrCSamp = 1u;
    break;
  case SAMP_OLDA:
    hCurrA = pHandle->CurrAOld;
    bCurrASamp = 1u;
    break;
  case SAMP_OLDB:
    hCurrB = pHandle->CurrBOld;
    bCurrBSamp = 1u;
    break;
  default:
    break;
  }
  
  /* Second sampling point */
  wAux = (int32_t)(pHandle->CurConv[1]) - (int32_t)(pHandle->PhaseOffset);
  
  wAux = (wAux > -INT16_MAX) ? ((wAux < INT16_MAX) ? wAux : INT16_MAX) : -INT16_MAX;

  
  switch (pHandle->sampCur2)
  {
  case SAMP_IA:
    hCurrA = (int16_t)(wAux);
    bCurrASamp = 1u;
    break;
  case SAMP_IB:
    hCurrB = (int16_t)(wAux);
    bCurrBSamp = 1u;
    break;
  case SAMP_IC:
    hCurrC = (int16_t)(wAux);
    bCurrCSamp = 1u;
    break;
  case SAMP_NIA:
    wAux = -wAux; 
    hCurrA = (int16_t)(wAux);
    bCurrASamp = 1u;
    break;
  case SAMP_NIB:
    wAux = -wAux; 
    hCurrB = (int16_t)(wAux);
    bCurrBSamp = 1u;
    break;
  case SAMP_NIC:
    wAux = -wAux; 
    hCurrC = (int16_t)(wAux);
    bCurrCSamp = 1u;
    break;
  default:
    break;
  }
    
  /* Computation of the third value */
  if (bCurrASamp == 0u)
  {
    wAux = -((int32_t)(hCurrB)) -((int32_t)(hCurrC));
    
    /* Check saturation */
	wAux = (wAux > -INT16_MAX) ? ((wAux < INT16_MAX) ? wAux : INT16_MAX) : -INT16_MAX;
    
    hCurrA = (int16_t)wAux; 
  }
  if (bCurrBSamp == 0u)
  {
    wAux = -((int32_t)(hCurrA)) -((int32_t)(hCurrC));
    
    /* Check saturation */
	wAux = (wAux > -INT16_MAX) ? ((wAux < INT16_MAX) ? wAux : INT16_MAX) : -INT16_MAX;
    
    hCurrB = (int16_t)wAux;
  }
  if (bCurrCSamp == 0u)
  {
    wAux = -((int32_t)(hCurrA)) -((int32_t)(hCurrB));
    
    /* Check saturation */
    wAux = (wAux > -INT16_MAX) ? ((wAux < INT16_MAX) ? wAux : INT16_MAX) : -INT16_MAX;
    
    hCurrC = (int16_t)wAux;
  }
  
  /* hCurrA, hCurrB, hCurrC values are the sampled values */
    
  pHandle->CurrAOld = hCurrA;
  pHandle->CurrBOld = hCurrB;

  pStator_Currents->a = hCurrA;
  pStator_Currents->b = hCurrB;
  
  pHandle->_Super.Ia = pStator_Currents->a;
  pHandle->_Super.Ib = pStator_Currents->b;
  pHandle->_Super.Ic = -pStator_Currents->a - pStator_Currents->b;

}

/**
  * @brief  It turns on low sides switches. This function is intended to be
  *         used for charging boot capacitors of driving section. It has to be
  *         called each motor start-up when using high voltage drivers
  * @param  pHdl: handler of the current instance of the PWM component
  * @retval none
  */
__weak void R1G0XX_TurnOnLowSides(PWMC_Handle_t *pHdl)
{
  PWMC_R1_G0_Handle_t *pHandle = (PWMC_R1_G0_Handle_t *)pHdl;

  pHandle->_Super.TurnOnLowSidesAction = true;

  TIM1->CCR1 = 0u;
  TIM1->CCR2 = 0u;
  TIM1->CCR3 = 0u;
  
  LL_TIM_ClearFlag_UPDATE(TIM1);
  while (LL_TIM_IsActiveFlag_UPDATE(TIM1) == RESET)
  {}
  
  /* Main PWM Output Enable */
  LL_TIM_EnableAllOutputs(TIM1);
  if ((pHandle->pParams_str->LowSideOutputs)== ES_GPIO)
  {
    LL_GPIO_SetOutputPin( pHandle->pParams_str->pwm_en_u_port, pHandle->pParams_str->pwm_en_u_pin );
    LL_GPIO_SetOutputPin( pHandle->pParams_str->pwm_en_v_port, pHandle->pParams_str->pwm_en_v_pin );
    LL_GPIO_SetOutputPin( pHandle->pParams_str->pwm_en_w_port, pHandle->pParams_str->pwm_en_w_pin );
  }
  return; 
}

/**
  * @brief  It enables PWM generation on the proper Timer peripheral acting on
  *         MOE bit, enaables the single shunt distortion and reset the TIM status
  * @param  pHdl: handler of the current instance of the PWM component
  * @retval none
  */
__weak void R1G0XX_SwitchOnPWM(PWMC_Handle_t *pHdl)
{
  PWMC_R1_G0_Handle_t *pHandle = (PWMC_R1_G0_Handle_t *)pHdl;
  
  pHandle->_Super.TurnOnLowSidesAction = false;
  
  /* enable break Interrupt */
  LL_TIM_ClearFlag_BRK(TIM1);
  LL_TIM_EnableIT_BRK(TIM1);

  LL_TIM_DisableDMAReq_CC4(TIM1);
  LL_TIM_DisableDMAReq_UPDATE(TIM1);
  LL_DMA_DisableChannel (DMA1, LL_DMA_CHANNEL_4);
  LL_DMA_SetDataLength (DMA1, LL_DMA_CHANNEL_4, 2);

  /* Enables the TIMx Preload on CC1 Register */
  LL_TIM_OC_EnablePreload(TIM1, LL_TIM_CHANNEL_CH1);
  /* Enables the TIMx Preload on CC2 Register */
  LL_TIM_OC_EnablePreload(TIM1, LL_TIM_CHANNEL_CH2);
  /* Enables the TIMx Preload on CC3 Register */
  LL_TIM_OC_EnablePreload(TIM1, LL_TIM_CHANNEL_CH3);

  /* TIM output trigger 2 for ADC */
  LL_TIM_SetTriggerOutput2(TIM1, LL_TIM_TRGO2_OC5_RISING_OC6_RISING);

  LL_TIM_ClearFlag_UPDATE(TIM1);
  while (LL_TIM_IsActiveFlag_UPDATE(TIM1)==RESET)
  {}
  LL_TIM_ClearFlag_UPDATE(TIM1);
 /* Set all duty to 50% */
  /* Set ch5 ch6 for triggering */
  /* Clear Update Flag */

  LL_TIM_OC_SetCompareCH1(TIM1,(uint32_t)(pHandle->Half_PWMPeriod >> 1));
  LL_TIM_OC_SetCompareCH2(TIM1,(uint32_t)(pHandle->Half_PWMPeriod >> 1));
  LL_TIM_OC_SetCompareCH3(TIM1,(uint32_t)(pHandle->Half_PWMPeriod >> 1));

  while (LL_TIM_IsActiveFlag_UPDATE(TIM1)==RESET)
  {}
  /* trick because the DMA is fired as soon as channel is enabled ...*/
  LL_DMA_DisableChannel(DMA1, LL_DMA_CHANNEL_1);
  LL_DMA_SetDataLength(DMA1, LL_DMA_CHANNEL_1, 2u);
  LL_DMA_EnableChannel(DMA1, LL_DMA_CHANNEL_1);

  
  /* Main PWM Output Enable */  
  LL_TIM_EnableAllOutputs(TIM1);
  
  /* TIM output trigger 2 for ADC */


  LL_TIM_OC_SetCompareCH5(TIM1,(((uint32_t)(pHandle->Half_PWMPeriod >> 1)) + (uint32_t)pHandle->pParams_str->Tafter));
  LL_TIM_OC_SetCompareCH6(TIM1,(uint32_t)(pHandle->Half_PWMPeriod - 1u));

  /* Main PWM Output Enable */
  LL_TIM_ClearFlag_UPDATE(TIM1);
  LL_TIM_EnableIT_UPDATE(TIM1);
  LL_TIM_EnableDMAReq_CC4(TIM1);
  LL_DMA_EnableChannel (DMA1, LL_DMA_CHANNEL_4); 
  
  if ((pHandle->pParams_str->LowSideOutputs)== ES_GPIO)
  {
    if ((TIM1->CCER & TIMxCCER_MASK_CH123) != 0u)
    {
      LL_GPIO_SetOutputPin( pHandle->pParams_str->pwm_en_u_port, pHandle->pParams_str->pwm_en_u_pin );
      LL_GPIO_SetOutputPin( pHandle->pParams_str->pwm_en_v_port, pHandle->pParams_str->pwm_en_v_pin );
      LL_GPIO_SetOutputPin( pHandle->pParams_str->pwm_en_w_port, pHandle->pParams_str->pwm_en_w_pin );
    }
    else
    {
      /* It is executed during calibration phase the EN signal shall stay off */
      LL_GPIO_ResetOutputPin( pHandle->pParams_str->pwm_en_u_port, pHandle->pParams_str->pwm_en_u_pin );
      LL_GPIO_ResetOutputPin( pHandle->pParams_str->pwm_en_v_port, pHandle->pParams_str->pwm_en_v_pin );
      LL_GPIO_ResetOutputPin( pHandle->pParams_str->pwm_en_w_port, pHandle->pParams_str->pwm_en_w_pin );
    }
  }
  
  /* Enabling distortion for single shunt */
  pHandle->Flags |= DSTEN;
  /* We forbid ADC usage for regular conversion on Systick*/
  pHandle->ADCRegularLocked=true; 
  return;
}

/**
  * @brief  It disables PWM generation on the proper Timer peripheral acting on
  *         MOE bit, disables the single shunt distortion and reset the TIM status
  * @param  pHdl: handler of the current instance of the PWM component
  * @retval none
  */
__weak void R1G0XX_SwitchOffPWM(PWMC_Handle_t *pHdl)
{
  uint16_t hAux;

  PWMC_R1_G0_Handle_t *pHandle = (PWMC_R1_G0_Handle_t *)pHdl;

  pHandle->_Super.TurnOnLowSidesAction = false;

  /* Disable UPDATE ISR */
  LL_TIM_DisableIT_UPDATE(TIM1);

  /* Main PWM Output Disable */
  LL_TIM_DisableAllOutputs(TIM1);
  if ((pHandle->pParams_str->LowSideOutputs)== ES_GPIO)
  {
    LL_GPIO_ResetOutputPin( pHandle->pParams_str->pwm_en_u_port, pHandle->pParams_str->pwm_en_u_pin );
    LL_GPIO_ResetOutputPin( pHandle->pParams_str->pwm_en_v_port, pHandle->pParams_str->pwm_en_v_pin );
    LL_GPIO_ResetOutputPin( pHandle->pParams_str->pwm_en_w_port, pHandle->pParams_str->pwm_en_w_pin );
  }
  
  /* Switch off the DMA from this point High frequency task is shut down*/
  LL_DMA_DisableChannel(DMA1, LL_DMA_CHANNEL_1);
  
  /* channel 5 and 6 Preload Disable */
  LL_TIM_OC_DisablePreload(TIM1, LL_TIM_CHANNEL_CH5);
  LL_TIM_OC_DisablePreload(TIM1, LL_TIM_CHANNEL_CH6);
  
  LL_TIM_OC_SetCompareCH5(TIM1,(uint32_t)(pHandle->Half_PWMPeriod + 1u));
  LL_TIM_OC_SetCompareCH6(TIM1,(uint32_t)(pHandle->Half_PWMPeriod + 1u));
  
    /* channel 5 and 6 Preload enable */
  LL_TIM_OC_EnablePreload(TIM1, LL_TIM_CHANNEL_CH5);
  LL_TIM_OC_EnablePreload(TIM1, LL_TIM_CHANNEL_CH6);
  
  /* Disable TIMx DMA requests enable */
  LL_TIM_DisableDMAReq_CC4(TIM1);
  LL_TIM_DisableDMAReq_UPDATE(TIM1);


  /* Disable break interrupt */
  LL_TIM_DisableIT_BRK(TIM1);
  
  /*Clear potential ADC Ongoing conversion*/
  if (LL_ADC_REG_IsConversionOngoing (ADC1))
  {
    LL_ADC_REG_StopConversion (ADC1);
    while ( LL_ADC_REG_IsConversionOngoing(ADC1))
    {
    }
  }
  LL_ADC_REG_SetTriggerSource (ADC1, LL_ADC_REG_TRIG_SOFTWARE);

  
  /* We allow ADC usage for regular conversion on Systick*/
  pHandle->ADCRegularLocked=false; 

  /* Set all duty to 50% */
  hAux = pHandle->Half_PWMPeriod >> 1;
  TIM1->CCR1 = hAux;
  TIM1->CCR2 = hAux;
  TIM1->CCR3 = hAux;    

  /* wait for a new PWM period to flush last HF task */
  LL_TIM_ClearFlag_UPDATE(TIM1);
  while (LL_TIM_IsActiveFlag_UPDATE(TIM1)==RESET)
  {}
  LL_TIM_ClearFlag_UPDATE(TIM1);

  return; 
}

/**
  * @brief  Implementation of the single shunt algorithm to setup the
  *         TIM1 register and DMA buffers values for the next PWM period.
  * @param  pHdl: handler of the current instance of the PWM component
  * @retval uint16_t It returns MC_FOC_DURATION if the TIMx update occurs
  *          before the end of FOC algorithm else returns MC_NO_ERROR
  */
__weak uint16_t R1G0XX_CalcDutyCycles(PWMC_Handle_t *pHdl)
{
  PWMC_R1_G0_Handle_t *pHandle = (PWMC_R1_G0_Handle_t *)pHdl;
  int16_t hDeltaDuty_0;
  int16_t hDeltaDuty_1;
  register uint16_t lowDuty = pHandle->_Super.lowDuty;
  register uint16_t midDuty = pHandle->_Super.midDuty;
  register uint16_t highDuty = pHandle->_Super.highDuty;
  uint8_t bSector;
  uint8_t bStatorFluxPos;
  uint16_t hAux;

  bSector = (uint8_t)pHandle->_Super.Sector;

  /* Compute delta duty */
  hDeltaDuty_0 = (int16_t)(midDuty) - (int16_t)(highDuty);
  hDeltaDuty_1 = (int16_t)(lowDuty) - (int16_t)(midDuty);

  /* Check region */
  if ((uint16_t)hDeltaDuty_0<=pHandle->pParams_str->TMin)
  {
    if ((uint16_t)hDeltaDuty_1<=pHandle->pParams_str->TMin)
    {
      bStatorFluxPos = BOUNDARY_3;
    }
    else
    {
      bStatorFluxPos = BOUNDARY_2;
    }
  } 
  else 
  {
    if ((uint16_t)hDeltaDuty_1>pHandle->pParams_str->TMin)
    {
      bStatorFluxPos = REGULAR;
    }
    else
    {
      bStatorFluxPos = BOUNDARY_1;
    }
  }

  if (bStatorFluxPos == REGULAR)
  {
    pHandle->Inverted_pwm_new = INVERT_NONE;
  }
  else if (bStatorFluxPos == BOUNDARY_1) /* Adjust the lower */
  {
    switch (bSector)
    {
      case SECTOR_5:
      case SECTOR_6:
        if (pHandle->_Super.CntPhA - pHandle->pParams_str->CHTMin - highDuty > pHandle->pParams_str->TMin)
        {
          pHandle->Inverted_pwm_new = INVERT_A;
          pHandle->_Super.CntPhA -=pHandle->pParams_str->CHTMin;
          if (pHandle->_Super.CntPhA < midDuty)
          {
            midDuty = pHandle->_Super.CntPhA;
          }
        }
        else
        {
          bStatorFluxPos = BOUNDARY_3;
          if ((pHandle->Flags & STBD3) == 0u)
          {
            pHandle->Inverted_pwm_new = INVERT_A;
            pHandle->_Super.CntPhA -=pHandle->pParams_str->CHTMin;
            pHandle->Flags |= STBD3;
          }
          else
          {
            pHandle->Inverted_pwm_new = INVERT_B;
            pHandle->_Super.CntPhB -=pHandle->pParams_str->CHTMin;
            pHandle->Flags &= (~STBD3);
          }
        }
        break;
      case SECTOR_2:
      case SECTOR_1:
        if (pHandle->_Super.CntPhB - pHandle->pParams_str->CHTMin - highDuty > pHandle->pParams_str->TMin)
        {
          pHandle->Inverted_pwm_new = INVERT_B;
          pHandle->_Super.CntPhB -=pHandle->pParams_str->CHTMin;
          if (pHandle->_Super.CntPhB < midDuty)
          {
            midDuty = pHandle->_Super.CntPhB;
          }
        }
        else
        {
          bStatorFluxPos = BOUNDARY_3;
          if ((pHandle->Flags & STBD3) == 0u)
          {
            pHandle->Inverted_pwm_new = INVERT_A;
            pHandle->_Super.CntPhA -=pHandle->pParams_str->CHTMin;
            pHandle->Flags |= STBD3;
          }
          else
          {
            pHandle->Inverted_pwm_new = INVERT_B;
            pHandle->_Super.CntPhB -=pHandle->pParams_str->CHTMin;
            pHandle->Flags &= (~STBD3);
          }
        }
        break;
      case SECTOR_4:
      case SECTOR_3:
        if (pHandle->_Super.CntPhC - pHandle->pParams_str->CHTMin - highDuty > pHandle->pParams_str->TMin)
        {
          pHandle->Inverted_pwm_new = INVERT_C;
          pHandle->_Super.CntPhC -=pHandle->pParams_str->CHTMin;
          if (pHandle->_Super.CntPhC < midDuty)
          {
            midDuty = pHandle->_Super.CntPhC;
          }
        }
        else
        {
          bStatorFluxPos = BOUNDARY_3;
          if ((pHandle->Flags & STBD3) == 0u)
          {
            pHandle->Inverted_pwm_new = INVERT_A;
            pHandle->_Super.CntPhA -=pHandle->pParams_str->CHTMin;
            pHandle->Flags |= STBD3;
          }
          else
          {
            pHandle->Inverted_pwm_new = INVERT_B;
            pHandle->_Super.CntPhB -=pHandle->pParams_str->CHTMin;
            pHandle->Flags &= (~STBD3);
          }
        }
        break;
      default:
        break;
    }
  }
  else if (bStatorFluxPos == BOUNDARY_2) /* Adjust the middler */
  {
    switch (bSector)
    {
      case SECTOR_4:
      case SECTOR_5: /* Invert B */
        pHandle->Inverted_pwm_new = INVERT_B;
        pHandle->_Super.CntPhB -=pHandle->pParams_str->CHTMin;
        if (pHandle->_Super.CntPhB > 0xEFFFu)
        {
          pHandle->_Super.CntPhB = 0u;
        }
        break;
      case SECTOR_2:
      case SECTOR_3: /* Invert A */
        pHandle->Inverted_pwm_new = INVERT_A;
        pHandle->_Super.CntPhA -=pHandle->pParams_str->CHTMin;
        if (pHandle->_Super.CntPhA > 0xEFFFu)
        {
          pHandle->_Super.CntPhA = 0u;
        }
        break;
      case SECTOR_6:
      case SECTOR_1: /* Invert C */
        pHandle->Inverted_pwm_new = INVERT_C;
        pHandle->_Super.CntPhC -=pHandle->pParams_str->CHTMin;
        if (pHandle->_Super.CntPhC > 0xEFFFu)
        {
          pHandle->_Super.CntPhC = 0u;
        }
        break;
      default:
        break;
    }
  }
  else if ( bStatorFluxPos == BOUNDARY_3 )
  {
    if ((pHandle->Flags & STBD3) == 0u)
    {
      pHandle->Inverted_pwm_new = INVERT_A;
      pHandle->_Super.CntPhA -=pHandle->pParams_str->CHTMin;
      pHandle->Flags |= STBD3;
    } 
    else
    {
      pHandle->Inverted_pwm_new = INVERT_B;
      pHandle->_Super.CntPhB -=pHandle->pParams_str->CHTMin;
      pHandle->Flags &= (~STBD3);
    }
  }
  else
  {
  }

  if ( bStatorFluxPos == REGULAR ) /* Regular zone */
  {
    /* First point */
    pHandle->CntSmp1 = midDuty - pHandle->pParams_str->Tbefore;
    /* Second point */
    pHandle->CntSmp2 = lowDuty - pHandle->pParams_str->Tbefore;
  }

  if (bStatorFluxPos == BOUNDARY_1) /* Two small, one big */
  {      
    /* First point */
    pHandle->CntSmp1 = midDuty - pHandle->pParams_str->Tbefore;
    /* Second point */
    pHandle->CntSmp2 = pHandle->Half_PWMPeriod - pHandle->pParams_str->HTMin + pHandle->pParams_str->TSample;
  }

  if (bStatorFluxPos == BOUNDARY_2) /* Two big, one small */
  {
    /* First point */
    pHandle->CntSmp1 = lowDuty - pHandle->pParams_str->Tbefore;
    /* Second point */
    pHandle->CntSmp2 = pHandle->Half_PWMPeriod - pHandle->pParams_str->HTMin + pHandle->pParams_str->TSample;
  }

  if (bStatorFluxPos == BOUNDARY_3)  
  {
    /* First point */
    pHandle->CntSmp1 = highDuty-pHandle->pParams_str->Tbefore; /* Dummy trigger */
    /* Second point */
    pHandle->CntSmp2 = pHandle->Half_PWMPeriod - pHandle->pParams_str->HTMin + pHandle->pParams_str->TSample;
  }

  TIM1->CCR5 = pHandle->CntSmp1;
  TIM1->CCR6 = pHandle->CntSmp2;

  if (bStatorFluxPos == REGULAR)
  {
    LL_TIM_SetTriggerOutput2(TIM1, LL_TIM_TRGO2_OC5_RISING_OC6_RISING);
  }
  else {
    LL_TIM_SetTriggerOutput2(TIM1, LL_TIM_TRGO2_OC5_RISING_OC6_FALLING);
  }

  /* Update Timer Ch 1,2,3 (These value are required before update event) */
  TIM1->CCR1 = pHandle->_Super.CntPhA;
  TIM1->CCR2 = pHandle->_Super.CntPhB;
  TIM1->CCR3 = pHandle->_Super.CntPhC;

  /* Debug High frequency task duration
   * LL_GPIO_ResetOutputPin (GPIOB, LL_GPIO_PIN_3);
   */
  /*check whether UpdateFlagBuffer is already set */
  /* If it is the case, Timer update has already occured, we are to late ...*/
  if (pHandle->UpdateFlagBuffer)
  {
    hAux = MC_FOC_DURATION;

  }
  else
  {
    hAux = MC_NO_ERROR;
  }
  if (pHandle->_Super.SWerror == 1u)
  {
    hAux = MC_FOC_DURATION;
    pHandle->_Super.SWerror = 0u;
  }  

  /* The following instruction can be executed after Update handler 
     before the get phase current (Second EOC) */

  /* Set the current sampled */
  if (bStatorFluxPos == REGULAR) /* Regual zone */
  {
    pHandle->sampCur1 = REGULAR_SAMP_CUR1[bSector];
    pHandle->sampCur2 = REGULAR_SAMP_CUR2[bSector];
  }

  if (bStatorFluxPos == BOUNDARY_1) /* Two small, one big */
  {
    pHandle->sampCur1 = REGULAR_SAMP_CUR1[bSector];
    pHandle->sampCur2 = BOUNDR1_SAMP_CUR2[bSector];
  }

  if (bStatorFluxPos == BOUNDARY_2) /* Two big, one small */
  {
    pHandle->sampCur1 = BOUNDR2_SAMP_CUR1[bSector];
    pHandle->sampCur2 = BOUNDR2_SAMP_CUR2[bSector];
  }

  if (bStatorFluxPos == BOUNDARY_3)  
  {
    if (pHandle->Inverted_pwm_new == INVERT_A)
    {
      pHandle->sampCur1 = SAMP_OLDB;
      pHandle->sampCur2 = SAMP_IA;
    }
    if (pHandle->Inverted_pwm_new == INVERT_B)
    {
      pHandle->sampCur1 = SAMP_OLDA;
      pHandle->sampCur2 = SAMP_IB;
    }
  }
  return (hAux);
}

/**
  * @brief  R1_G0XX implement MC IRQ function TIMER Update
  * @param  this related object
  * @retval void* It returns always MC_NULL
  */
__weak void R1G0XX_TIMx_UP_IRQHandler(PWMC_R1_G0_Handle_t *pHdl)
{ 
  PWMC_R1_G0_Handle_t *pHandle = (PWMC_R1_G0_Handle_t *)pHdl;
  /* We need to insert the active window, meaning dynamically 
     change the CCR register, so Preload of this CCR must be disable*/
  pHandle->UpdateFlagBuffer = true;   

  switch (pHandle->Inverted_pwm_new)
  {
    case INVERT_A:
      LL_TIM_EnableDMAReq_CC4 (TIM1);
      LL_TIM_OC_DisablePreload(TIM1, LL_TIM_CHANNEL_CH1);
      LL_DMA_SetPeriphAddress(DMA1, LL_DMA_CHANNEL_4, (uint32_t) &(TIM1->CCR1));
      pHandle->DmaBuff[1] = pHandle->_Super.CntPhA;
      break;

    case INVERT_B:
      LL_TIM_EnableDMAReq_CC4 (TIM1);
      LL_DMA_SetPeriphAddress(DMA1, LL_DMA_CHANNEL_4, (uint32_t) &(TIM1->CCR2));
      pHandle->DmaBuff[1] = pHandle->_Super.CntPhB;
      LL_TIM_OC_DisablePreload(TIM1, LL_TIM_CHANNEL_CH2);
      break;

    case INVERT_C:
      LL_TIM_EnableDMAReq_CC4 (TIM1);
      LL_DMA_SetPeriphAddress(DMA1, LL_DMA_CHANNEL_4, (uint32_t) &(TIM1->CCR3));
      pHandle->DmaBuff[1] = pHandle->_Super.CntPhC;
      LL_TIM_OC_DisablePreload(TIM1, LL_TIM_CHANNEL_CH3);
      break;

    default:
      LL_TIM_DisableDMAReq_CC4 (TIM1);
      break;
  } 
  LL_ADC_REG_SetSequencerChannels ( ADC1, __LL_ADC_DECIMAL_NB_TO_CHANNEL ( pHandle->pParams_str->IChannel ));
  LL_ADC_REG_SetTriggerSource (ADC1, LL_ADC_REG_TRIG_EXT_TIM1_TRGO2);
  LL_ADC_REG_StartConversion (ADC1);

}

/**
  * @brief  It contains the TIMx Break event interrupt connected to overcurrent.
  * @param  this related object
 * @retval none

  */
__weak void* R1G0XX_OVERCURRENT_IRQHandler(PWMC_R1_G0_Handle_t *pHandle)
{ 
  if ( pHandle->BrakeActionLock == false )
  {
    if ((pHandle->pParams_str->LowSideOutputs)== ES_GPIO)
    {
      LL_GPIO_ResetOutputPin( pHandle->pParams_str->pwm_en_u_port, pHandle->pParams_str->pwm_en_u_pin );
      LL_GPIO_ResetOutputPin( pHandle->pParams_str->pwm_en_v_port, pHandle->pParams_str->pwm_en_v_pin );
      LL_GPIO_ResetOutputPin( pHandle->pParams_str->pwm_en_w_port, pHandle->pParams_str->pwm_en_w_pin );
    }
  }
  pHandle->OverCurrentFlag = true;
  
  return MC_NULL;
}

/**
  * @brief  It contains the TIMx Break event interrupt connected to overvoltage.
  * @param pHandle: handler of the current instance of the PWM component
  * @retval none
  */
__weak void * R1G0XX_OVERVOLTAGE_IRQHandler( PWMC_R1_G0_Handle_t * pHandle )
{
  pHandle->pParams_str->TIMx->BDTR |= LL_TIM_OSSI_ENABLE;
  pHandle->OverVoltageFlag = true;
  pHandle->BrakeActionLock = true;

  return &( pHandle->_Super.Motor );
}

/**
  * @brief  It is used to check if an overcurrent occurred since last call.
  * @param  pHdl: handler of the current instance of the PWM component
  * @retval uint16_t It returns MC_BREAK_IN whether an overcurrent has been
  *                  detected since last method call, MC_NO_FAULTS otherwise.
  */
__weak uint16_t R1G0XX_IsOverCurrentOccurred(PWMC_Handle_t *pHdl)
{  
  PWMC_R1_G0_Handle_t *pHandle = (PWMC_R1_G0_Handle_t *)pHdl;
  uint16_t retVal = MC_NO_FAULTS;
  
  if ( pHandle->OverVoltageFlag == true )
  {
    retVal = MC_OVER_VOLT;
    pHandle->OverVoltageFlag = false;
  }
    
  if (pHandle->OverCurrentFlag == true)
  {
    retVal |= MC_BREAK_IN;
    pHandle->OverCurrentFlag = false;
  }
  return retVal;
}

/**
  * @}
  */
  
/**
  * @}
  */

/************************ (C) COPYRIGHT STMicroelectronics *****END OF FILE****/
