/**
  ******************************************************************************
  * @file    r1_f0xx_pwm_curr_fdbk.c
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
#include "pwm_curr_fdbk.h"
#include "pwm_common.h"
#include "r1_f0xx_pwm_curr_fdbk.h"

#include "mc_type.h"

/** @addtogroup MCSDK
  * @{
  */

/** @addtogroup pwm_curr_fdbk
  * @{
  */

/**
 * @defgroup r1_f0XX_pwm_curr_fdbk R1 F0xx PWM & Current Feedback
 *
 * @brief STM32F0, 1-Shunt PWM & Current Feedback implementation
 *
 * This component is used in applications based on an STM32F0 MCU
 * and using a single shunt resistor current sensing topology.
 *
 * @todo: TODO: complete documentation.
 * @{
 */

/* Private Defines -----------------------------------------------------------*/

/* Direct address of the registers used by DMA */
#define CCR1_OFFSET 0x34u
#define CCR2_OFFSET 0x38u
#define CCR3_OFFSET 0x3Cu
#define CCR4_OFFSET 0x40u
#define TIM1_CCR1_Address   TIM1_BASE + CCR1_OFFSET
#define TIM1_CCR2_Address   TIM1_BASE + CCR2_OFFSET
#define TIM1_CCR3_Address   TIM1_BASE + CCR3_OFFSET
#define TIM3_CCR4_Address   TIM3_BASE + CCR4_OFFSET
#define TIM15_CCR1_Address  TIM15_BASE + CCR1_OFFSET

#define DR_OFFSET 0x40u
#define ADC1_DR_Address     ADC1_BASE + DR_OFFSET

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

#define CH1NORMAL           0x0060u
#define CH2NORMAL           0x6000u
#define CH3NORMAL           0x0060u
#define CH4NORMAL           0x7000u

#define CCMR1_PRELOAD_DISABLE_MASK 0xF7F7u
#define CCMR2_PRELOAD_DISABLE_MASK 0xFFF7u

#define CCMR1_PRELOAD_ENABLE_MASK 0x0808u
#define CCMR2_PRELOAD_ENABLE_MASK 0x0008u

/* DMA ENABLE mask */
#define CCR_ENABLE_Set          ((uint32_t)0x00000001u)
#define CCR_ENABLE_Reset        ((uint32_t)0xFFFFFFFEu)

#define CR2_JEXTSEL_Reset       ((uint32_t)0xFFFF8FFFu)
#define CR2_JEXTTRIG_Set        ((uint32_t)0x00008000u)
#define CR2_JEXTTRIG_Reset      ((uint32_t)0xFFFF7FFFu)

#define TIM_DMA_ENABLED_CC1 0x0200u
#define TIM_DMA_ENABLED_CC2 0x0400u
#define TIM_DMA_ENABLED_CC3 0x0800u

#define CR2_ADON_Set                ((uint32_t)0x00000001u)

/* ADC SMPx mask */
#define SMPR1_SMP_Set              ((uint32_t) (0x00000007u))
#define SMPR2_SMP_Set              ((uint32_t) (0x00000007u))
#define CR2_EXTTRIG_SWSTART_Set    ((uint32_t)0x00500000)

#define ADC1_CR2_EXTTRIG_SWSTART_BB 0x42248158u

#define ADCx_IRQn     ADC1_COMP_IRQn
#define TIMx_UP_IRQn  TIM1_BRK_UP_TRG_COM_IRQn

/* Constant values -----------------------------------------------------------*/
static const uint8_t REGULAR_SAMP_CUR1[6] = {SAMP_NIC, SAMP_NIC, SAMP_NIA, SAMP_NIA, SAMP_NIB, SAMP_NIB};
static const uint8_t REGULAR_SAMP_CUR2[6] = {SAMP_IA, SAMP_IB, SAMP_IB, SAMP_IC, SAMP_IC, SAMP_IA};
static const uint8_t BOUNDR1_SAMP_CUR2[6] = {SAMP_IB, SAMP_IB, SAMP_IC, SAMP_IC, SAMP_IA, SAMP_IA};
static const uint8_t BOUNDR2_SAMP_CUR1[6] = {SAMP_IA, SAMP_IB, SAMP_IB, SAMP_IC, SAMP_IC, SAMP_IA};
static const uint8_t BOUNDR2_SAMP_CUR2[6] = {SAMP_IC, SAMP_IA, SAMP_IA, SAMP_IB, SAMP_IB, SAMP_IC};

/* Private function prototypes -----------------------------------------------*/
void R1F0XX_1ShuntMotorVarsInit( PWMC_Handle_t * pHdl );
void R1F0XX_1ShuntMotorVarsRestart( PWMC_Handle_t * pHdl );
void R1F0XX_TIMxInit( TIM_TypeDef * TIMx, TIM_TypeDef * TIMx_2, PWMC_Handle_t * pHdl );

/* Private functions ---------------------------------------------------------*/

/**
  * @brief  It initializes TIM1, ADC, GPIO, DMA1 and NVIC for single shunt current
  *         reading configuration using STM32F0XX family.
  * @param  pHdl: handler of the current instance of the PWM component
  * @retval none
  */
__weak void R1F0XX_Init( PWMC_R1_F0_Handle_t * pHandle )
{
  uint16_t hAux;
  uint16_t hTIM1_CR1;
  uint16_t hAuxTIM_CR1;
  TIM_TypeDef * AuxTIM;

  if ( ( uint32_t )pHandle == ( uint32_t )&pHandle->_Super )
  {

    /* disable IT and flags in case of LL driver usage
     * workaround for unwanted interrupt enabling done by LL driver */
    LL_ADC_DisableIT_EOC( ADC1 );
    LL_ADC_ClearFlag_EOC( ADC1 );
    LL_ADC_DisableIT_EOS( ADC1 );
    LL_ADC_ClearFlag_EOS( ADC1 );

    AuxTIM = pHandle->pParams_str->AuxTIM;

    R1F0XX_1ShuntMotorVarsInit( &pHandle->_Super );

    R1F0XX_TIMxInit( TIM1, AuxTIM, &pHandle->_Super );

    /* DMA Event related to R1 - Active Vector insertion (TIM1 Channel 4) */
    /* DMA Channel configuration ----------------------------------------------*/
    LL_DMA_SetMemoryAddress( DMA1, LL_DMA_CHANNEL_4, ( uint32_t )pHandle->DmaBuff );
    LL_DMA_SetPeriphAddress( DMA1, LL_DMA_CHANNEL_4, ( uint32_t ) & ( TIM1->CCR1 ) );
    LL_DMA_SetDataLength( DMA1, LL_DMA_CHANNEL_4, 2u );

    /* Enable DMA Channel */
    LL_DMA_EnableChannel( DMA1, LL_DMA_CHANNEL_4 );

    /* Settings related to AuxTIM used */
    if ( AuxTIM == TIM3 )
    {
      LL_DBGMCU_APB1_GRP1_FreezePeriph( LL_DBGMCU_APB1_GRP1_TIM3_STOP );

      /* DMA Event related to AUX_TIM - dual triggering */
      /* DMA channel configuration ----------------------------------------------*/
      LL_DMA_SetMemoryAddress( DMA1, LL_DMA_CHANNEL_3, ( uint32_t )pHandle->CCDmaBuffCh4 );
      LL_DMA_SetPeriphAddress( DMA1, LL_DMA_CHANNEL_3, ( uint32_t )TIM3_CCR4_Address );
      LL_DMA_SetDataLength( DMA1, LL_DMA_CHANNEL_3, 3u );
      /* Enable DMA Channel */
      LL_DMA_EnableChannel( DMA1, LL_DMA_CHANNEL_3 );

      pHandle->ADC_ExtTrigConv = LL_ADC_REG_TRIG_EXT_TIM3_TRGO;
    }
#ifdef TIM15
    else /* TIM15 */
    {
      LL_DBGMCU_APB1_GRP2_FreezePeriph( LL_DBGMCU_APB1_GRP2_TIM15_STOP );
      /* DMA Event related to AUX_TIM - dual triggering */
      /* DMA channel configuration ----------------------------------------------*/
      LL_DMA_SetMemoryAddress( DMA1, LL_DMA_CHANNEL_5, ( uint32_t )pHandle->CCDmaBuffCh4 );
      LL_DMA_SetPeriphAddress( DMA1, LL_DMA_CHANNEL_5, ( uint32_t )TIM15_CCR1_Address );
      LL_DMA_SetDataLength( DMA1, LL_DMA_CHANNEL_5, 3u );
      LL_DMA_EnableChannel( DMA1, LL_DMA_CHANNEL_5 );

      pHandle->ADC_ExtTrigConv = LL_ADC_REG_TRIG_EXT_TIM15_TRGO;
    }
#endif
    /* DMA Event related to ADC conversion*/
    /* DMA channel configuration ----------------------------------------------*/
    LL_DMA_SetMemoryAddress( DMA1, LL_DMA_CHANNEL_2, ( uint32_t )pHandle->CurConv );
    LL_DMA_SetPeriphAddress( DMA1, LL_DMA_CHANNEL_2, ( uint32_t )ADC1_DR_Address );
    LL_DMA_SetDataLength( DMA1, LL_DMA_CHANNEL_2, 2u );

    /* DMA1 channel 2 will be enabled after the CurrentReadingCalibration */

    if ( pHandle->pParams_str->RepetitionCounter > 1u )
    {
      /* Only if REP RATE > 1 - Active Vector insertion (TIM1 Channel 4)*/
      /* enable the DMA1_CH4 TC interrupt */
      /* Enable DMA1 CH4 TC IRQ */
      LL_DMA_EnableIT_TC( DMA1, LL_DMA_CHANNEL_4 );

      pHandle->DMATot = ( pHandle->pParams_str->RepetitionCounter + 1u ) / 2u;
    }
    else
    {
      /* REP RATE = 1 */
      LL_DMA_DisableIT_TC( DMA1, LL_DMA_CHANNEL_4 );
      pHandle->DMATot = 0u;
    }

    /* Start calibration of ADC1 */
    LL_ADC_StartCalibration( ADC1 );
    while ((LL_ADC_IsCalibrationOnGoing(ADC1) == SET) ||
           (LL_ADC_REG_IsConversionOngoing(ADC1) == SET) ||
           (LL_ADC_REG_IsStopConversionOngoing(ADC1) == SET) ||
           (LL_ADC_IsDisableOngoing(ADC1) == SET))
    {
      /* wait */
    }

    /* Enable ADC */
    LL_ADC_Enable( ADC1 );
    /* Enable ADC DMA request*/
    LL_ADC_REG_SetDMATransfer( ADC1 , LL_ADC_REG_DMA_TRANSFER_LIMITED );

    /* Wait ADC Ready */
    while ( LL_ADC_IsActiveFlag_ADRDY( ADC1 ) == RESET )
    {}


    R1F0XX_1ShuntMotorVarsRestart( &pHandle->_Super );

    /* Set AUX TIM channel first trigger (dummy) - DMA enabling */
    hAux = ( pHandle->Half_PWMPeriod >> 1 ) - pHandle->pParams_str->Tbefore;
    if ( AuxTIM == TIM3 )
    {
      TIM3->CCR4 = hAux;
      LL_TIM_EnableDMAReq_CC4( TIM3 );
    }
#ifdef TIM15
    else /* TIM15 */
    {
      TIM15->CCR1 = hAux;
      LL_TIM_EnableDMAReq_CC1( TIM15 );
    }
#endif
    LL_DMA_EnableIT_TC( DMA1, LL_DMA_CHANNEL_2 );

    LL_TIM_EnableCounter( TIM1 );
    LL_TIM_EnableCounter( AuxTIM );

    hTIM1_CR1 = TIM1->CR1;
    hTIM1_CR1 |= TIM_CR1_CEN;
    hAuxTIM_CR1 = AuxTIM->CR1;
    hAuxTIM_CR1 |= TIM_CR1_CEN;

    AuxTIM->CNT += 3u;

    __disable_irq();
    TIM1->CR1 = hTIM1_CR1;
    AuxTIM->CR1 = hAuxTIM_CR1;
    __enable_irq();

    pHandle->ADCRegularLocked=false; /* We allow ADC usage for regular conversion on Systick*/
    pHandle->_Super.DTTest = 0u;

  }
}

/**
  * @brief  It initializes TIMx and TIMx_2 peripheral for PWM generation,
  *          active vector insertion and adc triggering.
  * @param  TIMx Timer to be initialized
  * @param  TIMx_2 Auxiliary timer to be initialized used for adc triggering
  * @param  pHdl: handler of the current instance of the PWM component
  * @retval none
  */
__weak void R1F0XX_TIMxInit( TIM_TypeDef * TIMx, TIM_TypeDef * TIMx_2, PWMC_Handle_t * pHdl )
{

  PWMC_R1_F0_Handle_t * pHandle = ( PWMC_R1_F0_Handle_t * )pHdl;

  LL_TIM_CC_EnableChannel( TIMx, LL_TIM_CHANNEL_CH1 );
  LL_TIM_CC_EnableChannel( TIMx, LL_TIM_CHANNEL_CH2 );
  LL_TIM_CC_EnableChannel( TIMx, LL_TIM_CHANNEL_CH3 );

  if ( ( pHandle->pParams_str->LowSideOutputs ) == LS_PWM_TIMER )
  {
    LL_TIM_CC_EnableChannel( TIMx, LL_TIM_CHANNEL_CH1N );
    LL_TIM_CC_EnableChannel( TIMx, LL_TIM_CHANNEL_CH2N );
    LL_TIM_CC_EnableChannel( TIMx, LL_TIM_CHANNEL_CH3N );
  }

  LL_TIM_OC_DisablePreload( TIMx, LL_TIM_CHANNEL_CH1 );
  LL_TIM_OC_DisablePreload( TIMx, LL_TIM_CHANNEL_CH2 );
  LL_TIM_OC_DisablePreload( TIMx, LL_TIM_CHANNEL_CH3 );
  LL_TIM_OC_DisablePreload( TIMx, LL_TIM_CHANNEL_CH4 );

  LL_TIM_OC_SetDeadTime( TIMx, ( pHandle->pParams_str->DeadTime ) / 2u );

  if ( TIMx_2 == TIM3 )
  {
    LL_TIM_OC_SetMode( TIMx_2, LL_TIM_CHANNEL_CH4, LL_TIM_OCMODE_PWM2 );
    LL_TIM_CC_EnableChannel( TIMx_2, LL_TIM_CHANNEL_CH4 );
  }
  else /* TIM15 */
  {
    LL_TIM_OC_SetMode( TIMx_2, LL_TIM_CHANNEL_CH1, LL_TIM_OCMODE_PWM2 );
    LL_TIM_CC_EnableChannel( TIMx_2, LL_TIM_CHANNEL_CH1 );
  }

}

/**
  * @brief  It stores into handler the voltage present on the
  *         current feedback analog channel when no current is flowin into the
  *         motor
  * @param  pHdl: handler of the current instance of the PWM component
  * @retval none
  */
__weak void R1F0XX_CurrentReadingCalibration( PWMC_Handle_t * pHdl )
{
  uint8_t bIndex = 0u;
  uint32_t wPhaseOffset = 0u;

  PWMC_R1_F0_Handle_t * pHandle = ( PWMC_R1_F0_Handle_t * )pHdl;

  /* Set the CALIB flags to indicate the ADC calibartion phase*/
  pHandle->Flags |= CALIB;

  /* We forbid ADC usage for regular conversion on Systick*/
  pHandle->ADCRegularLocked=true; 
  /* ADC Channel and sampling time config for current reading */
  LL_ADC_REG_SetSequencerChannels ( ADC1, __LL_ADC_DECIMAL_NB_TO_CHANNEL ( pHandle->pParams_str->IChannel ));
  LL_ADC_SetSamplingTimeCommonChannels ( ADC1, pHandle->pParams_str->ISamplingTime );

  /* Disable DMA1 Channel2 */
  LL_DMA_DisableChannel( DMA1, LL_DMA_CHANNEL_2 );

  /* ADC Channel used for current reading are read
  in order to get zero currents ADC values*/
  while ( bIndex < NB_CONVERSIONS )
  {
    /* Software start of conversion */
    LL_ADC_REG_StartConversion( ADC1 );

    /* Wait until end of regular conversion */
    while ( LL_ADC_IsActiveFlag_EOC( ADC1 ) == RESET )
    {}

    wPhaseOffset += LL_ADC_REG_ReadConversionData12( ADC1 );
    bIndex++;
  }

  pHandle->PhaseOffset = ( uint16_t )( wPhaseOffset / NB_CONVERSIONS );

  /* Reset the CALIB flags to indicate the end of ADC calibartion phase*/
  pHandle->Flags &= ( ~CALIB );

  /* Enable DMA1 Channel2 */
  LL_DMA_EnableChannel( DMA1, LL_DMA_CHANNEL_2 );
}

/**
  * @brief  First initialization of class members
  * @param  pHdl: handler of the current instance of the PWM component
  * @retval none
  */
__weak void R1F0XX_1ShuntMotorVarsInit( PWMC_Handle_t * pHdl )
{
  PWMC_R1_F0_Handle_t * pHandle = ( PWMC_R1_F0_Handle_t * )pHdl;

  /* Init motor vars */
  pHandle->PhaseOffset = 0u;
  pHandle->Inverted_pwm = INVERT_NONE;
  pHandle->Inverted_pwm_new = INVERT_NONE;
  pHandle->Flags &= ( ~STBD3 );
  pHandle->Flags &= ( ~DSTEN );

  /* After reset value of DMA buffers */
  pHandle->DmaBuff[0] = pHandle->Half_PWMPeriod + 1u;
  pHandle->DmaBuff[1] = pHandle->Half_PWMPeriod >> 1;

  /* After reset value of dvDutyValues */
  pHandle->_Super.CntPhA = pHandle->Half_PWMPeriod >> 1;
  pHandle->_Super.CntPhB = pHandle->Half_PWMPeriod >> 1;
  pHandle->_Super.CntPhC = pHandle->Half_PWMPeriod >> 1;

  /* Default value of DutyValues */
  pHandle->CntSmp1 = ( pHandle->Half_PWMPeriod >> 1 ) - pHandle->pParams_str->Tbefore;
  pHandle->CntSmp2 = ( pHandle->Half_PWMPeriod >> 1 ) + pHandle->pParams_str->Tafter;

  /* Default value of sampling point */
  pHandle->CCDmaBuffCh4[0] = pHandle->CntSmp2; /* Second point */
  pHandle->CCDmaBuffCh4[1] = ( pHandle->Half_PWMPeriod * 2u ) - 1u;       /* Update */
  pHandle->CCDmaBuffCh4[2] = pHandle->CntSmp1; /* First point */

  LL_TIM_DisableDMAReq_CC4( TIM1 );
}

/**
  * @brief  Initialization of class members after each motor start
  * @param  pHdl: handler of the current instance of the PWM component
  * @retval none
  */
__weak void R1F0XX_1ShuntMotorVarsRestart( PWMC_Handle_t * pHdl )
{
  PWMC_R1_F0_Handle_t * pHandle = ( PWMC_R1_F0_Handle_t * )pHdl;

  /* Default value of DutyValues */
  pHandle->CntSmp1 = ( pHandle->Half_PWMPeriod >> 1 ) - pHandle->pParams_str->Tbefore;
  pHandle->CntSmp2 = ( pHandle->Half_PWMPeriod >> 1 ) + pHandle->pParams_str->Tafter;

  /* Default value of sampling point */
  pHandle->CCDmaBuffCh4[0] = pHandle->CntSmp2; /* Second point */
  pHandle->CCDmaBuffCh4[2] = pHandle->CntSmp1; /* First point */

  /* After start value of DMA buffers */
  pHandle->DmaBuff[0] = pHandle->Half_PWMPeriod + 1u;
  pHandle->DmaBuff[1] = pHandle->Half_PWMPeriod >> 1;

  /* After start value of dvDutyValues */
  pHandle->_Super.CntPhA = pHandle->Half_PWMPeriod >> 1;
  pHandle->_Super.CntPhB = pHandle->Half_PWMPeriod >> 1;
  pHandle->_Super.CntPhC = pHandle->Half_PWMPeriod >> 1;

  /* Set the default previous value of Phase A,B,C current */
  pHandle->CurrAOld = 0;
  pHandle->CurrBOld = 0;
  pHandle->CurrCOld = 0;

  LL_TIM_DisableDMAReq_CC4( TIM1 );
}

/**
  * @brief  It computes and return latest converted motor phase currents motor
  * @param  pHdl: handler of the current instance of the PWM component
  * @retval ab_t Ia and Ib current in ab_t format
  */
__weak void R1F0XX_GetPhaseCurrents( PWMC_Handle_t * pHdl, ab_t * pStator_Currents )
{
  int32_t wAux;
  int16_t hCurrA = 0;
  int16_t hCurrB = 0;
  int16_t hCurrC = 0;
  uint8_t bCurrASamp = 0u;
  uint8_t bCurrBSamp = 0u;
  uint8_t bCurrCSamp = 0u;

  PWMC_R1_F0_Handle_t * pHandle = ( PWMC_R1_F0_Handle_t * )pHdl;

  /* Disabling the External triggering for ADCx*/
  ADC1->CFGR1 &= ~LL_ADC_REG_TRIG_EXT_RISINGFALLING;

  /* Reset the bSOFOC flags to indicate the start of FOC algorithm*/
  pHandle->Flags &= ( ~SOFOC );

  /* First sampling point */
  wAux = ( int32_t )( pHandle->CurConv[0] );
  wAux -= ( int32_t )( pHandle->PhaseOffset );

  /* Check saturation */
  if ( wAux > -INT16_MAX )
  {
    if ( wAux < INT16_MAX )
    {
    }
    else
    {
      wAux = INT16_MAX;
    }
  }
  else
  {
    wAux = -INT16_MAX;
  }

  switch ( pHandle->sampCur1 )
  {
    case SAMP_IA:
      hCurrA = ( int16_t )( wAux );
      bCurrASamp = 1u;
      break;
    case SAMP_IB:
      hCurrB = ( int16_t )( wAux );
      bCurrBSamp = 1u;
      break;
    case SAMP_IC:
      hCurrC = ( int16_t )( wAux );
      bCurrCSamp = 1u;
      break;
    case SAMP_NIA:
      wAux = -wAux;
      hCurrA = ( int16_t )( wAux );
      bCurrASamp = 1u;
      break;
    case SAMP_NIB:
      wAux = -wAux;
      hCurrB = ( int16_t )( wAux );
      bCurrBSamp = 1u;
      break;
    case SAMP_NIC:
      wAux = -wAux;
      hCurrC = ( int16_t )( wAux );
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
  wAux = ( int32_t )( pHandle->CurConv[1] );
  wAux -= ( int32_t )( pHandle->PhaseOffset );

  /* Check saturation */
  if ( wAux > -INT16_MAX )
  {
    if ( wAux < INT16_MAX )
    {
    }
    else
    {
      wAux = INT16_MAX;
    }
  }
  else
  {
    wAux = -INT16_MAX;
  }

  switch ( pHandle->sampCur2 )
  {
    case SAMP_IA:
      hCurrA = ( int16_t )( wAux );
      bCurrASamp = 1u;
      break;
    case SAMP_IB:
      hCurrB = ( int16_t )( wAux );
      bCurrBSamp = 1u;
      break;
    case SAMP_IC:
      hCurrC = ( int16_t )( wAux );
      bCurrCSamp = 1u;
      break;
    case SAMP_NIA:
      wAux = -wAux;
      hCurrA = ( int16_t )( wAux );
      bCurrASamp = 1u;
      break;
    case SAMP_NIB:
      wAux = -wAux;
      hCurrB = ( int16_t )( wAux );
      bCurrBSamp = 1u;
      break;
    case SAMP_NIC:
      wAux = -wAux;
      hCurrC = ( int16_t )( wAux );
      bCurrCSamp = 1u;
      break;
    default:
      break;
  }

  /* Computation of the third value */
  if ( bCurrASamp == 0u )
  {
    wAux = -( ( int32_t )( hCurrB ) ) - ( ( int32_t )( hCurrC ) );

    /* Check saturation */
    if ( wAux > -INT16_MAX )
    {
      if ( wAux < INT16_MAX )
      {
      }
      else
      {
        wAux = INT16_MAX;
      }
    }
    else
    {
      wAux = -INT16_MAX;
    }

    hCurrA = ( int16_t )wAux;
  }
  if ( bCurrBSamp == 0u )
  {
    wAux = -( ( int32_t )( hCurrA ) ) - ( ( int32_t )( hCurrC ) );

    /* Check saturation */
    if ( wAux > -INT16_MAX )
    {
      if ( wAux < INT16_MAX )
      {
      }
      else
      {
        wAux = INT16_MAX;
      }
    }
    else
    {
      wAux = -INT16_MAX;
    }

    hCurrB = ( int16_t )wAux;
  }
  if ( bCurrCSamp == 0u )
  {
    wAux = -( ( int32_t )( hCurrA ) ) - ( ( int32_t )( hCurrB ) );

    /* Check saturation */
    if ( wAux > -INT16_MAX )
    {
      if ( wAux < INT16_MAX )
      {
      }
      else
      {
        wAux = INT16_MAX;
      }
    }
    else
    {
      wAux = -INT16_MAX;
    }

    hCurrC = ( int16_t )wAux;
  }

  /* hCurrA, hCurrB, hCurrC values are the sampled values */

  pHandle->CurrAOld = hCurrA;
  pHandle->CurrBOld = hCurrB;
  pHandle->CurrCOld = hCurrC;

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
__weak void R1F0XX_TurnOnLowSides( PWMC_Handle_t * pHdl )
{
  PWMC_R1_F0_Handle_t * pHandle = ( PWMC_R1_F0_Handle_t * )pHdl;

  pHandle->_Super.TurnOnLowSidesAction = true;

  TIM1->CCR1 = 0u;
  TIM1->CCR2 = 0u;
  TIM1->CCR3 = 0u;

  LL_TIM_ClearFlag_UPDATE( TIM1 );
  while ( LL_TIM_IsActiveFlag_UPDATE( TIM1 ) == RESET )
  {}

  /* Main PWM Output Enable */
  LL_TIM_EnableAllOutputs( TIM1 );
  if ( ( pHandle->pParams_str->LowSideOutputs ) == ES_GPIO )
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
__weak void R1F0XX_SwitchOnPWM( PWMC_Handle_t * pHdl )
{
  PWMC_R1_F0_Handle_t * pHandle = ( PWMC_R1_F0_Handle_t * )pHdl;

  pHandle->_Super.TurnOnLowSidesAction = false;

  /* Main PWM Output Enable */
  LL_TIM_EnableAllOutputs( TIM1 );
  if ( ( pHandle->pParams_str->LowSideOutputs ) == ES_GPIO )
  {
    LL_GPIO_SetOutputPin( pHandle->pParams_str->pwm_en_u_port, pHandle->pParams_str->pwm_en_u_pin );
    LL_GPIO_SetOutputPin( pHandle->pParams_str->pwm_en_v_port, pHandle->pParams_str->pwm_en_v_pin );
    LL_GPIO_SetOutputPin( pHandle->pParams_str->pwm_en_w_port, pHandle->pParams_str->pwm_en_w_pin );
  }

  /* Enable UPDATE ISR */
  /* Clear Update Flag */
  LL_TIM_ClearFlag_UPDATE( TIM1 );
  LL_TIM_EnableIT_UPDATE( TIM1 );

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
__weak void R1F0XX_SwitchOffPWM( PWMC_Handle_t * pHdl )
{
  uint16_t hAux;

  PWMC_R1_F0_Handle_t * pHandle = ( PWMC_R1_F0_Handle_t * )pHdl;

  pHandle->_Super.TurnOnLowSidesAction = false;

  /* Main PWM Output Disable */
  LL_TIM_DisableAllOutputs( TIM1 );
  if ( ( pHandle->pParams_str->LowSideOutputs ) == ES_GPIO )
  {
    LL_GPIO_ResetOutputPin( pHandle->pParams_str->pwm_en_u_port, pHandle->pParams_str->pwm_en_u_pin );
    LL_GPIO_ResetOutputPin( pHandle->pParams_str->pwm_en_v_port, pHandle->pParams_str->pwm_en_v_pin );
    LL_GPIO_ResetOutputPin( pHandle->pParams_str->pwm_en_w_port, pHandle->pParams_str->pwm_en_w_pin );
  }

  /* Disable UPDATE ISR */
  LL_TIM_DisableIT_UPDATE( TIM1 );

  /* Disabling distortion for single */
  pHandle->Flags &= ( ~DSTEN );

  while ( LL_TIM_IsActiveFlag_UPDATE( TIM1 ) == RESET )
  {}
  /* Disabling all DMA previous setting */
  LL_TIM_DisableDMAReq_CC4( TIM1 );
  
  /* We allow ADC usage for regular conversion on Systick*/
  pHandle->ADCRegularLocked=false; 

  /* Set all duty to 50% */
  hAux = pHandle->Half_PWMPeriod >> 1;
  TIM1->CCR1 = hAux;
  TIM1->CCR2 = hAux;
  TIM1->CCR3 = hAux;

  return;
}

/**
  * @brief  Implementation of the single shunt algorithm to setup the
  *         TIM1 register and DMA buffers values for the next PWM period.
  * @param  pHdl: handler of the current instance of the PWM component
  * @retval uint16_t It returns MC_FOC_DURATION if the TIMx update occurs
  *          before the end of FOC algorithm else returns MC_NO_ERROR
  */
__weak uint16_t R1F0XX_CalcDutyCycles( PWMC_Handle_t * pHdl )
{
  PWMC_R1_F0_Handle_t * pHandle = ( PWMC_R1_F0_Handle_t * )pHdl;
  int16_t hDeltaDuty_0;
  int16_t hDeltaDuty_1;
  register uint16_t lowDuty = pHandle->_Super.lowDuty;
  register uint16_t midDuty = pHandle->_Super.midDuty;
  register uint16_t highDuty = pHandle->_Super.highDuty;  
  uint8_t bSector;
  uint8_t bStatorFluxPos;
  uint16_t hAux;

  bSector = ( uint8_t )pHandle->_Super.Sector;

  if ( ( pHandle->Flags & DSTEN ) != 0u )
  {
    /* Compute delta duty */
    hDeltaDuty_0 = ( int16_t )( midDuty ) - ( int16_t )( highDuty );
    hDeltaDuty_1 = ( int16_t )( lowDuty ) - ( int16_t )( midDuty );

    /* Check region */
    if ( ( uint16_t )hDeltaDuty_0 <= pHandle->pParams_str->TMin )
    {
      if ( ( uint16_t )hDeltaDuty_1 <= pHandle->pParams_str->TMin )
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
      if ( ( uint16_t )hDeltaDuty_1 > pHandle->pParams_str->TMin )
      {
        bStatorFluxPos = REGULAR;
      }
      else
      {
        bStatorFluxPos = BOUNDARY_1;
      }
    }

    if ( bStatorFluxPos == REGULAR )
    {
      pHandle->Inverted_pwm_new = INVERT_NONE;
    }
    else if ( bStatorFluxPos == BOUNDARY_1 ) /* Adjust the lower */
    {
      switch ( bSector )
      {
        case SECTOR_5:
        case SECTOR_6:
          if ( pHandle->_Super.CntPhA - pHandle->pParams_str->HTMin - highDuty > pHandle->pParams_str->TMin )
          {
            pHandle->Inverted_pwm_new = INVERT_A;
            pHandle->_Super.CntPhA -= pHandle->pParams_str->HTMin;
            if ( pHandle->_Super.CntPhA < midDuty )
            {
              midDuty = pHandle->_Super.CntPhA;
            }
          }
          else
          {
            bStatorFluxPos = BOUNDARY_3;
            if ( ( pHandle->Flags & STBD3 ) == 0u )
            {
              pHandle->Inverted_pwm_new = INVERT_A;
              pHandle->_Super.CntPhA -= pHandle->pParams_str->HTMin;
              pHandle->Flags |= STBD3;
            }
            else
            {
              pHandle->Inverted_pwm_new = INVERT_B;
              pHandle->_Super.CntPhB -= pHandle->pParams_str->HTMin;
              pHandle->Flags &= ( ~STBD3 );
            }
          }
          break;
        case SECTOR_2:
        case SECTOR_1:
          if ( pHandle->_Super.CntPhB - pHandle->pParams_str->HTMin - highDuty > pHandle->pParams_str->TMin )
          {
            pHandle->Inverted_pwm_new = INVERT_B;
            pHandle->_Super.CntPhB -= pHandle->pParams_str->HTMin;
            if ( pHandle->_Super.CntPhB < midDuty )
            {
              midDuty = pHandle->_Super.CntPhB;
            }
          }
          else
          {
            bStatorFluxPos = BOUNDARY_3;
            if ( ( pHandle->Flags & STBD3 ) == 0u )
            {
              pHandle->Inverted_pwm_new = INVERT_A;
              pHandle->_Super.CntPhA -= pHandle->pParams_str->HTMin;
              pHandle->Flags |= STBD3;
            }
            else
            {
              pHandle->Inverted_pwm_new = INVERT_B;
              pHandle->_Super.CntPhB -= pHandle->pParams_str->HTMin;
              pHandle->Flags &= ( ~STBD3 );
            }
          }
          break;
        case SECTOR_4:
        case SECTOR_3:
          if ( pHandle->_Super.CntPhC - pHandle->pParams_str->HTMin - highDuty > pHandle->pParams_str->TMin )
          {
            pHandle->Inverted_pwm_new = INVERT_C;
            pHandle->_Super.CntPhC -= pHandle->pParams_str->HTMin;
            if ( pHandle->_Super.CntPhC < midDuty )
            {
              midDuty = pHandle->_Super.CntPhC;
            }
          }
          else
          {
            bStatorFluxPos = BOUNDARY_3;
            if ( ( pHandle->Flags & STBD3 ) == 0u )
            {
              pHandle->Inverted_pwm_new = INVERT_A;
              pHandle->_Super.CntPhA -= pHandle->pParams_str->HTMin;
              pHandle->Flags |= STBD3;
            }
            else
            {
              pHandle->Inverted_pwm_new = INVERT_B;
              pHandle->_Super.CntPhB -= pHandle->pParams_str->HTMin;
              pHandle->Flags &= ( ~STBD3 );
            }
          }
          break;
        default:
          break;
      }
    }
    else if ( bStatorFluxPos == BOUNDARY_2 ) /* Adjust the middler */
    {
      switch ( bSector )
      {
        case SECTOR_4:
        case SECTOR_5: /* Invert B */
          pHandle->Inverted_pwm_new = INVERT_B;
          pHandle->_Super.CntPhB -= pHandle->pParams_str->HTMin;
          if ( pHandle->_Super.CntPhB > 0xEFFFu )
          {
            pHandle->_Super.CntPhB = 0u;
          }
          break;
        case SECTOR_2:
        case SECTOR_3: /* Invert A */
          pHandle->Inverted_pwm_new = INVERT_A;
          pHandle->_Super.CntPhA -= pHandle->pParams_str->HTMin;
          if ( pHandle->_Super.CntPhA > 0xEFFFu )
          {
            pHandle->_Super.CntPhA = 0u;
          }
          break;
        case SECTOR_6:
        case SECTOR_1: /* Invert C */
          pHandle->Inverted_pwm_new = INVERT_C;
          pHandle->_Super.CntPhC -= pHandle->pParams_str->HTMin;
          if ( pHandle->_Super.CntPhC > 0xEFFFu )
          {
            pHandle->_Super.CntPhC = 0u;
          }
          break;
        default:
          break;
      }
    }
    else
    {
      if ( ( pHandle->Flags & STBD3 ) == 0u )
      {
        pHandle->Inverted_pwm_new = INVERT_A;
        pHandle->_Super.CntPhA -= pHandle->pParams_str->HTMin;
        pHandle->Flags |= STBD3;
      }
      else
      {
        pHandle->Inverted_pwm_new = INVERT_B;
        pHandle->_Super.CntPhB -= pHandle->pParams_str->HTMin;
        pHandle->Flags &= ( ~STBD3 );
      }
    }

    if ( bStatorFluxPos == REGULAR ) /* Regular zone */
    {
      /* First point */
      if ( ( midDuty - highDuty - pHandle->pParams_str->DeadTime ) > pHandle->pParams_str->MaxTrTs )
      {
        pHandle->CntSmp1 = highDuty + midDuty + pHandle->pParams_str->DeadTime;
        pHandle->CntSmp1 >>= 1;
      }
      else
      {
        pHandle->CntSmp1 = midDuty - pHandle->pParams_str->Tbefore;
      }
      /* Second point */
      if ( ( lowDuty - midDuty - pHandle->pParams_str->DeadTime ) > pHandle->pParams_str->MaxTrTs )
      {
        pHandle->CntSmp2 = midDuty + lowDuty + pHandle->pParams_str->DeadTime;
        pHandle->CntSmp2 >>= 1;
      }
      else
      {
        pHandle->CntSmp2 = lowDuty - pHandle->pParams_str->Tbefore;
      }
    }

    if ( bStatorFluxPos == BOUNDARY_1 ) /* Two small, one big */
    {
      /* First point */
      if ( ( midDuty - highDuty - pHandle->pParams_str->DeadTime ) > pHandle->pParams_str->MaxTrTs )
      {
        pHandle->CntSmp1 = highDuty + midDuty + pHandle->pParams_str->DeadTime;
        pHandle->CntSmp1 >>= 1;
      }
      else
      {
        pHandle->CntSmp1 = midDuty - pHandle->pParams_str->Tbefore;
      }
      /* Second point */
      pHandle->CntSmp2 = pHandle->Half_PWMPeriod + pHandle->pParams_str->HTMin - pHandle->pParams_str->TSample;
    }

    if ( bStatorFluxPos == BOUNDARY_2 ) /* Two big, one small */
    {
      /* First point */
      if ( ( lowDuty - midDuty - pHandle->pParams_str->DeadTime ) >= pHandle->pParams_str->MaxTrTs )
      {
        pHandle->CntSmp1 = midDuty + lowDuty + pHandle->pParams_str->DeadTime;
        pHandle->CntSmp1 >>= 1;
      }
      else
      {
        pHandle->CntSmp1 = lowDuty - pHandle->pParams_str->Tbefore;
      }
      /* Second point */
      pHandle->CntSmp2 = pHandle->Half_PWMPeriod + pHandle->pParams_str->HTMin - pHandle->pParams_str->TSample;
    }

    if ( bStatorFluxPos == BOUNDARY_3 )
    {
      /* First point */
      pHandle->CntSmp1 = highDuty - pHandle->pParams_str->Tbefore; /* Dummy trigger */
      /* Second point */
      pHandle->CntSmp2 = pHandle->Half_PWMPeriod + pHandle->pParams_str->HTMin - pHandle->pParams_str->TSample;
    }
  }
  else
  {
    pHandle->Inverted_pwm_new = INVERT_NONE;
    bStatorFluxPos = REGULAR;
  }

  /* Update Timer Ch 1,2,3 (These value are required before update event) */

  pHandle->Flags |= EOFOC;
  /* Check if DMA transition has been completed */
  if ( pHandle->DMACur == 0u )
  {
    /* Preload Enable */
    TIM1->CCMR1 |= CCMR1_PRELOAD_ENABLE_MASK;
    TIM1->CCMR2 |= CCMR2_PRELOAD_ENABLE_MASK;

    TIM1->CCR1 = pHandle->_Super.CntPhA;
    TIM1->CCR2 = pHandle->_Super.CntPhB;
    TIM1->CCR3 = pHandle->_Super.CntPhC;

    /* Update ADC Trigger DMA buffer */
    pHandle->CCDmaBuffCh4[0] = pHandle->CntSmp2; /* Second point */
    pHandle->CCDmaBuffCh4[2] = pHandle->CntSmp1; /* First point */
  }

  LL_ADC_REG_SetSequencerChannels ( ADC1, __LL_ADC_DECIMAL_NB_TO_CHANNEL ( pHandle->pParams_str->IChannel ));
  LL_ADC_SetSamplingTimeCommonChannels ( ADC1, pHandle->pParams_str->ISamplingTime );
  
   /* Limit for update event */

  /* Check the status of bSOFOC flags if is set the next update event has been
  occurred so an error will be reported*/
  if ( ( pHandle->Flags & SOFOC ) != 0u )
  {
    hAux = MC_FOC_DURATION;
  }
  else
  {
    hAux = MC_NO_ERROR;
  }

  /* The following instruction can be executed after Update handler
     before the get phase current (Second EOC) */

  /* Set the current sampled */
  if ( bStatorFluxPos == REGULAR ) /* Regual zone */
  {
    pHandle->sampCur1 = REGULAR_SAMP_CUR1[bSector];
    pHandle->sampCur2 = REGULAR_SAMP_CUR2[bSector];
  }

  if ( bStatorFluxPos == BOUNDARY_1 ) /* Two small, one big */
  {
    pHandle->sampCur1 = REGULAR_SAMP_CUR1[bSector];
    pHandle->sampCur2 = BOUNDR1_SAMP_CUR2[bSector];
  }

  if ( bStatorFluxPos == BOUNDARY_2 ) /* Two big, one small */
  {
    pHandle->sampCur1 = BOUNDR2_SAMP_CUR1[bSector];
    pHandle->sampCur2 = BOUNDR2_SAMP_CUR2[bSector];
  }

  if ( bStatorFluxPos == BOUNDARY_3 )
  {
    if ( pHandle->Inverted_pwm_new == INVERT_A )
    {
      pHandle->sampCur1 = SAMP_OLDB;
      pHandle->sampCur2 = SAMP_IA;
    }
    if ( pHandle->Inverted_pwm_new == INVERT_B )
    {
      pHandle->sampCur1 = SAMP_OLDA;
      pHandle->sampCur2 = SAMP_IB;
    }
  }

  /* Limit for the Get Phase current (Second EOC Handler) */

  return ( hAux );
}

/**
 * @brief  It contains the TIMx Update event interrupt
 * @param  pHandle: handler of the current instance of the PWM component
 * @retval none
 */
__weak void * R1F0XX_TIMx_UP_IRQHandler( PWMC_R1_F0_Handle_t * pHandle )
{
  uint8_t Inverted_pwm_new;
  uint32_t wAux;

  /* Critical point start */
  /* Enabling the External triggering for ADCx*/
  wAux = ADC1->CFGR1;
  wAux &= ( ~( ADC_CFGR1_EXTEN | ADC_CFGR1_EXTSEL ) );
  wAux |= ( LL_ADC_REG_TRIG_EXT_RISING | pHandle->ADC_ExtTrigConv );
  ADC1->CFGR1 = wAux;

  /* Enable ADC triggering */
  ADC1->CR |= ( uint32_t )ADC_CR_ADSTART;

  /* Critical point stop */

  /* TMP var to speedup the execution */
  Inverted_pwm_new = pHandle->Inverted_pwm_new;

  if ( Inverted_pwm_new != pHandle->Inverted_pwm )
  {
    /* Set the DMA destination */
    switch ( Inverted_pwm_new )
    {
      case INVERT_A:
        LL_DMA_SetPeriphAddress( DMA1, LL_DMA_CHANNEL_4, TIM1_CCR1_Address );
        LL_TIM_EnableDMAReq_CC4( TIM1 );
        break;

      case INVERT_B:
        LL_DMA_SetPeriphAddress( DMA1, LL_DMA_CHANNEL_4, TIM1_CCR2_Address );
        LL_TIM_EnableDMAReq_CC4( TIM1 );
        break;

      case INVERT_C:
        LL_DMA_SetPeriphAddress( DMA1, LL_DMA_CHANNEL_4, TIM1_CCR3_Address );
        LL_TIM_EnableDMAReq_CC4( TIM1 );
        break;

      default:
        LL_TIM_DisableDMAReq_CC4( TIM1 );
        break;
    }
  }

  /* Clear of End of FOC Flags */
  pHandle->Flags &= ( ~EOFOC );

  /* Preload Disable */
  TIM1->CCMR1 &= CCMR1_PRELOAD_DISABLE_MASK;
  TIM1->CCMR2 &= CCMR2_PRELOAD_DISABLE_MASK;

  switch ( Inverted_pwm_new )
  {
    case INVERT_A:
      pHandle->DmaBuff[1] = pHandle->_Super.CntPhA;
      pHandle->DMACur = pHandle->DMATot;
      break;

    case INVERT_B:
      pHandle->DmaBuff[1] = pHandle->_Super.CntPhB;
      pHandle->DMACur = pHandle->DMATot;
      break;

    case INVERT_C:
      pHandle->DmaBuff[1] = pHandle->_Super.CntPhC;
      pHandle->DMACur = pHandle->DMATot;
      break;

    default:
      pHandle->DMACur = 0u;
      break;
  }

  pHandle->Inverted_pwm = Inverted_pwm_new;

  /* Set the bSOFOC flags to indicate the execution of Update IRQ*/
  pHandle->Flags |= SOFOC;

  return MC_NULL;

}

/**
 * @brief  It contains the Break event interrupt
 * @param  pHandle: handler of the current instance of the PWM component
 * @retval none
 */
__weak void * F0XX_BRK_IRQHandler( PWMC_R1_F0_Handle_t * pHandle )
{

  if ( ( pHandle->pParams_str->LowSideOutputs ) == ES_GPIO )
  {
    LL_GPIO_ResetOutputPin( pHandle->pParams_str->pwm_en_u_port, pHandle->pParams_str->pwm_en_u_pin );
    LL_GPIO_ResetOutputPin( pHandle->pParams_str->pwm_en_v_port, pHandle->pParams_str->pwm_en_v_pin );
    LL_GPIO_ResetOutputPin( pHandle->pParams_str->pwm_en_w_port, pHandle->pParams_str->pwm_en_w_pin );
  }
  pHandle->OverCurrentFlag = true;

  return MC_NULL;
}

/**
 * @brief  It contains the DMA transfer complete event interrupt
 * @param  pHandle: handler of the current instance of the PWM component
 * @retval none
 */
__weak void * R1F0XX_DMA_TC_IRQHandler( PWMC_R1_F0_Handle_t * pHandle )
{

  pHandle->DMACur--;
  if ( pHandle->DMACur == 0u )
  {
    if ( ( pHandle->Flags & EOFOC ) != 0u )
    {
      /* Preload Enable */
      TIM1->CCMR1 |= CCMR1_PRELOAD_ENABLE_MASK;
      TIM1->CCMR2 |= CCMR2_PRELOAD_ENABLE_MASK;

      /* Compare register update */
      TIM1->CCR1 = pHandle->_Super.CntPhA;
      TIM1->CCR2 = pHandle->_Super.CntPhB;
      TIM1->CCR3 = pHandle->_Super.CntPhC;

      /* Update ADC Trigger DMA buffer */
      pHandle->CCDmaBuffCh4[0] = pHandle->CntSmp2; /* Second point */
      pHandle->CCDmaBuffCh4[2] = pHandle->CntSmp1; /* First point */
    }
  }

  return MC_NULL;
}

/**
  * @brief  It is used to check if an overcurrent occurred since last call.
  * @param  pHdl: handler of the current instance of the PWM component
  * @retval uint16_t It returns MC_BREAK_IN whether an overcurrent has been
  *                  detected since last method call, MC_NO_FAULTS otherwise.
  */
__weak uint16_t R1F0XX_IsOverCurrentOccurred( PWMC_Handle_t * pHdl )
{
  uint16_t retVal = MC_NO_FAULTS;

  if ( LL_TIM_IsActiveFlag_BRK( TIM1 ) )
  {
    retVal = MC_BREAK_IN;
    LL_TIM_ClearFlag_BRK( TIM1 );
  }
  return retVal;
}

/**
  * @}
  */

/**
  * @}
  */

/** @} */

/************************ (C) COPYRIGHT 2019 STMicroelectronics *****END OF FILE****/
