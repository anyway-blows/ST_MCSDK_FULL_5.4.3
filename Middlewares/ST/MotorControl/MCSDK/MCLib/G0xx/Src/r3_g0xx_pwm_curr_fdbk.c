/**
  ******************************************************************************
  * @file    r3_g0xx_pwm_curr_fdbk.c
  * @author  Motor Control SDK Team, ST Microelectronics
  * @brief   This file provides firmware functions that implement current sensor
  *          class to be stantiated when the three shunts current sensing
  *          topology is used. It is specifically designed for STM32G0XX
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
#include "r3_g0xx_pwm_curr_fdbk.h"
#include "pwm_common.h"
#include "mc_type.h"

/** @addtogroup MCSDK
  * @{
  */

/** @defgroup r3_G0XX_pwm_curr_fdbk
  * @brief PWM G0XX three shunts component of the Motor Control SDK
  *
  * @{
  */

/* Private defines -----------------------------------------------------------*/
#define TIMxCCER_MASK_CH123       (LL_TIM_CHANNEL_CH1 | LL_TIM_CHANNEL_CH1N | LL_TIM_CHANNEL_CH2|LL_TIM_CHANNEL_CH2N |\
                                   LL_TIM_CHANNEL_CH3 | LL_TIM_CHANNEL_CH3N)
/* Private function prototypes -----------------------------------------------*/
void R3_1_HFCurrentsCalibrationAB(PWMC_Handle_t *pHdl,ab_t* pStator_Currents);
void R3_1_HFCurrentsCalibrationC(PWMC_Handle_t *pHdl,ab_t* pStator_Currents);
uint16_t R3_1_WriteTIMRegisters(PWMC_Handle_t *pHdl, uint16_t hCCR4Reg);

/* Private functions ---------------------------------------------------------*/

/* Local redefinition of both LL_TIM_OC_EnablePreload & LL_TIM_OC_DisablePreload */
__STATIC_INLINE void __LL_TIM_OC_EnablePreload(TIM_TypeDef *TIMx, uint32_t Channel)
{
  register uint8_t iChannel = TIM_GET_CHANNEL_INDEX(Channel);
  register __IO uint32_t *pReg = (__IO uint32_t *)((uint32_t)((uint32_t)(&TIMx->CCMR1) + OFFSET_TAB_CCMRx[iChannel]));
  SET_BIT(*pReg, (TIM_CCMR1_OC1PE << SHIFT_TAB_OCxx[iChannel]));
}

__STATIC_INLINE void __LL_TIM_OC_DisablePreload(TIM_TypeDef *TIMx, uint32_t Channel)
{
  register uint8_t iChannel = TIM_GET_CHANNEL_INDEX(LL_TIM_CHANNEL_CH4);
  register __IO uint32_t *pReg = (__IO uint32_t *)((uint32_t)((uint32_t)(&TIM1->CCMR1) + OFFSET_TAB_CCMRx[iChannel]));
  CLEAR_BIT(*pReg, (TIM_CCMR1_OC1PE << SHIFT_TAB_OCxx[iChannel]));
}

/**
  * @brief  It initializes TIM1, ADC1, GPIO, DMA1 and NVIC for three shunt current
  *         reading configuration using STM32G0x.
  * @param  pHdl: handler of the current instance of the PWM component
  * @retval none
  */
__weak void R3_1_Init(PWMC_R3_1_Handle_t *pHandle)
{
  
  if ((uint32_t)pHandle == (uint32_t)&pHandle->_Super)
  {

    /* Peripheral clocks enabling END ----------------------------------------*/

    /* Clear TIMx break flag. */
    LL_TIM_ClearFlag_BRK( TIM1 );
    LL_TIM_EnableIT_BRK( TIM1 );
    LL_TIM_SetCounter( TIM1, ( uint32_t )( pHandle->Half_PWMPeriod ) - 1u );
  
    /* TIM1 Counter Clock stopped when the core is halted */
    LL_APB1_GRP1_EnableClock (LL_APB1_GRP1_PERIPH_DBGMCU);
    LL_DBGMCU_APB2_GRP1_FreezePeriph(LL_DBGMCU_APB2_GRP1_TIM1_STOP);

    if ( LL_ADC_IsInternalRegulatorEnabled(ADC1) == 0u)
    {
      /* Enable ADC internal voltage regulator */
      LL_ADC_EnableInternalRegulator(ADC1);

      /* Wait for Regulator Startup time */
      /* Note: Variable divided by 2 to compensate partially              */
      /*       CPU processing cycles, scaling in us split to not          */
      /*       exceed 32 bits register capacity and handle low frequency. */
      volatile uint32_t wait_loop_index = ((LL_ADC_DELAY_INTERNAL_REGUL_STAB_US / 10UL) * (SystemCoreClock / (100000UL * 2UL)));
      while(wait_loop_index != 0UL)
      {
        wait_loop_index--;
      }
    }
    /* ADC Calibration */
    LL_ADC_StartCalibration(ADC1);
    while (LL_ADC_IsCalibrationOnGoing(ADC1))
    {
    }

    /* Enables the ADC peripheral */
    LL_ADC_Enable(ADC1);

    /* Wait ADC Ready */
    while ( LL_ADC_IsActiveFlag_ADRDY( ADC1 ) == RESET )
    {
      /* wait */
    }

    /* DMA1 Channel1 Config */
    LL_DMA_SetMemoryAddress(DMA1, LL_DMA_CHANNEL_1, (uint32_t)pHandle->ADC1_DMA_converted);
    LL_DMA_SetPeriphAddress( DMA1, LL_DMA_CHANNEL_1, ( uint32_t )&ADC1->DR );
    LL_DMA_SetDataLength(DMA1, LL_DMA_CHANNEL_1, 3);
    
    /* Enables the DMA1 Channel1 peripheral */
    LL_DMA_EnableChannel(DMA1, LL_DMA_CHANNEL_1);

    /* set default triggering edge */
    pHandle->ADCTriggerEdge = LL_ADC_REG_TRIG_EXT_RISING;
    
	/* Clear the flags */
    pHandle->OverVoltageFlag = false;
    pHandle->OverCurrentFlag = false;

    /* We allow ADC usage for regular conversion on Systick*/
    pHandle->ADCRegularLocked=false; 

    pHandle->_Super.DTTest = 0u;

    LL_TIM_EnableCounter( TIM1 );
  }
}



/**
  * @brief  It stores into the handler the voltage present on the
  *         current feedback analog channel when no current is flowin into the
  *         motor
  * @param  pHdl: handler of the current instance of the PWM component
  * @retval none
  */
__weak void R3_1_CurrentReadingCalibration(PWMC_Handle_t *pHdl)
{
#if defined (__ICCARM__)
#pragma cstat_disable = "MISRAC2012-Rule-11.3"
#endif
  PWMC_R3_1_Handle_t * pHandle = ( PWMC_R3_1_Handle_t * )pHdl;
#if defined (__ICCARM__)
#pragma cstat_restore = "MISRAC2012-Rule-11.3"
#endif
  TIM_TypeDef*  TIMx = TIM1;

  pHandle->PhaseAOffset = 0u;
  pHandle->PhaseBOffset = 0u;
  pHandle->PhaseCOffset = 0u;
  
  pHandle->PolarizationCounter = 0u;
    
  /* It forces inactive level on TIMx CHy and CHyN */
  LL_TIM_CC_DisableChannel( TIMx, TIMxCCER_MASK_CH123 );

  /* Offset calibration for A B c phases */
  /* Change function to be executed in ADCx_ISR */ 
  pHandle->_Super.pFctGetPhaseCurrents     = &R3_1_HFCurrentsCalibrationAB;
  pHandle->_Super.pFctSetADCSampPointSectX = &R3_1_SetADCSampPointCalibration;

  pHandle->CalibSector = SECTOR_5;
  pHandle->_Super.Sector = SECTOR_5;
  
  R3_1_SwitchOnPWM(&pHandle->_Super);
  
  /* Wait for NB_CONVERSIONS to be executed */
  waitForPolarizationEnd( TIMx,
  		                  &pHandle->_Super.SWerror,
  						  pHandle->pParams_str->RepetitionCounter,
  						  &pHandle->PolarizationCounter );

  R3_1_SwitchOffPWM(&pHandle->_Super);

  pHandle->_Super.pFctGetPhaseCurrents = &R3_1_HFCurrentsCalibrationC;
  pHandle->CalibSector = SECTOR_1;
  pHandle->_Super.Sector = SECTOR_1;
  pHandle->PolarizationCounter = 0;
  R3_1_SwitchOnPWM(&pHandle->_Super);

  /* Wait for NB_CONVERSIONS to be executed */
  waitForPolarizationEnd( TIMx,
  		                  &pHandle->_Super.SWerror,
  						  pHandle->pParams_str->RepetitionCounter,
  						  &pHandle->PolarizationCounter );
  
  R3_1_SwitchOffPWM(&pHandle->_Super);
  pHandle->_Super.Sector = SECTOR_5;
  pHandle->PhaseAOffset = pHandle->PhaseAOffset / NB_CONVERSIONS;
  pHandle->PhaseBOffset = pHandle->PhaseBOffset / NB_CONVERSIONS;
  pHandle->PhaseCOffset = pHandle->PhaseCOffset / NB_CONVERSIONS;
  
  /* Change back function to be executed in ADCx_ISR */ 
  pHandle->_Super.pFctGetPhaseCurrents     = &R3_1_GetPhaseCurrents;
  pHandle->_Super.pFctSetADCSampPointSectX = &R3_1_SetADCSampPointSectX;

  /* It over write TIMx CCRy wrongly written by FOC during calibration so as to 
     force 50% duty cycle on the three inverer legs */
  /* Disable TIMx preload */  
  __LL_TIM_OC_DisablePreload(TIMx,LL_TIM_CHANNEL_CH1);
  __LL_TIM_OC_DisablePreload(TIMx,LL_TIM_CHANNEL_CH2);
  __LL_TIM_OC_DisablePreload(TIMx,LL_TIM_CHANNEL_CH3);
  
  LL_TIM_OC_SetCompareCH1( TIMx, (uint32_t)pHandle->Half_PWMPeriod );
  LL_TIM_OC_SetCompareCH2( TIMx, (uint32_t)pHandle->Half_PWMPeriod );
  LL_TIM_OC_SetCompareCH3( TIMx, (uint32_t)pHandle->Half_PWMPeriod );
  
  /* Enable TIMx preload */
  __LL_TIM_OC_EnablePreload(TIMx,LL_TIM_CHANNEL_CH1);
  __LL_TIM_OC_EnablePreload(TIMx,LL_TIM_CHANNEL_CH2);
  __LL_TIM_OC_EnablePreload(TIMx,LL_TIM_CHANNEL_CH3);
  
  /* It re-enable drive of TIMx CHy and CHyN by TIMx CHyRef*/
  LL_TIM_CC_EnableChannel( TIMx, TIMxCCER_MASK_CH123 );

  pHandle->BrakeActionLock = false;

}

/**
 * @brief  It computes and return latest converted motor phase currents
 * @param  pHdl: handler of the current instance of the PWM component
 * @retval ab_t Ia and Ib current in ab_t format
 */
__weak void R3_1_GetPhaseCurrents(PWMC_Handle_t *pHdl,ab_t* pStator_Currents)
{ 
#if defined (__ICCARM__)
#pragma cstat_disable = "MISRAC2012-Rule-11.3"
#endif
  PWMC_R3_1_Handle_t * pHandle = ( PWMC_R3_1_Handle_t * )pHdl;
#if defined (__ICCARM__)
#pragma cstat_restore = "MISRAC2012-Rule-11.3"
#endif
  int32_t wAux;
  uint16_t hReg1;
  uint16_t hReg2;
  uint8_t bSector;
  
  LL_TIM_CC_DisableChannel( TIM1, LL_TIM_CHANNEL_CH4 );
  bSector = (uint8_t) pHandle->_Super.Sector;

  LL_ADC_REG_SetSequencerScanDirection(ADC1, LL_ADC_REG_SEQ_SCAN_DIR_FORWARD);
  hReg1 = *pHandle->pParams_str->ADCDataReg1[bSector];
  hReg2 = *pHandle->pParams_str->ADCDataReg2[bSector];
  
  switch (bSector)
  {
  case SECTOR_4:
  case SECTOR_5: 
    /* Current on Phase C is not accessible     */
    /* Ia = PhaseAOffset - ADC converted value) ------------------------------*/
        
    wAux = (int32_t)(pHandle->PhaseAOffset)-(int32_t)(hReg1);
    
    /* Saturation of Ia */
      if ( wAux < -INT16_MAX )
    {
        pStator_Currents->a = -INT16_MAX;
    }  
      else  if ( wAux > INT16_MAX )
    { 
        pStator_Currents->a = INT16_MAX;
    }
    else
    {
      pStator_Currents->a= (int16_t)wAux;
    }
    
    /* Ib = PhaseBOffset - ADC converted value) ------------------------------*/
    
    wAux = (int32_t)(pHandle->PhaseBOffset)-(int32_t)(hReg2);
      
    /* Saturation of Ib */
      if ( wAux < -INT16_MAX )
    {
        pStator_Currents->b = -INT16_MAX;
    }  
      else  if ( wAux > INT16_MAX )
    { 
        pStator_Currents->b = INT16_MAX;
    }
    else
    {
      pStator_Currents->b= (int16_t)wAux;
    }
    break;
 
  case SECTOR_6:
  case SECTOR_1:  
    /* Current on Phase A is not accessible     */
    /* Ib = (PhaseBOffset - ADC converted value) ------------------------------*/ 
    wAux = (int32_t)(pHandle->PhaseBOffset)-(int32_t)(hReg1);
    
   /* Saturation of Ib */
      if ( wAux < -INT16_MAX )
    {
        pStator_Currents->b = -INT16_MAX;
    }  
      else  if ( wAux > INT16_MAX )
    { 
        pStator_Currents->b = INT16_MAX;
    }
    else
    {
      pStator_Currents->b= (int16_t)wAux;
    }
    
    wAux = (int32_t)(pHandle->PhaseCOffset)-(int32_t)(hReg2);
    /* Ia = -Ic -Ib ----------------------------------------------------------*/
    wAux =-wAux - (int32_t)pStator_Currents->b;           /* Ia  */

    /* Saturation of Ia */
      if ( wAux > INT16_MAX )
    {
        pStator_Currents->a = INT16_MAX;
    }
      else  if ( wAux < -INT16_MAX )
    {
        pStator_Currents->a = -INT16_MAX;
    }
    else
    {  
      pStator_Currents->a = (int16_t)wAux;
    }
    break;
 
  case SECTOR_2:
  case SECTOR_3:
   /* Current on Phase B is not accessible     */
    /* Ia = PhaseAOffset - ADC converted value) ------------------------------*/    
    wAux = (int32_t)(pHandle->PhaseAOffset)-(int32_t)(hReg1);
    
   /* Saturation of Ia */
      if ( wAux < -INT16_MAX )
    {
        pStator_Currents->a = -INT16_MAX;
    }  
      else  if ( wAux > INT16_MAX )
    { 
        pStator_Currents->a = INT16_MAX;
    }
    else
    {
      pStator_Currents->a= (int16_t)wAux;
    }

    /* Ic = PhaseCOffset - ADC converted value) ------------------------------*/    
    wAux = (int32_t)(pHandle->PhaseCOffset)-(int32_t)(hReg2);

    /* Ib = -Ic -Ia */
    wAux = -wAux -  (int32_t)pStator_Currents->a;           /* Ib  */

    /* Saturation of Ib */
      if ( wAux > INT16_MAX )
    {
        pStator_Currents->b = INT16_MAX;
    }
      else  if ( wAux < -INT16_MAX )
    {  
        pStator_Currents->b = -INT16_MAX;
    }
    else  
    {
      pStator_Currents->b = (int16_t)wAux;
    }                     
    break;
    
  default:
    break;
  }  

  pHandle->_Super.Ia = pStator_Currents->a;
  pHandle->_Super.Ib = pStator_Currents->b;
  pHandle->_Super.Ic = -pStator_Currents->a - pStator_Currents->b;
}

/**
  * @brief  Configure the ADC for the current sampling during calibration.
  *         It means set the sampling point via TIMx_Ch4 value and polarity
  *         ADC sequence length and channels.
  *         And call the WriteTIMRegisters method.
  * @param  pHdl: handler of the current instance of the PWM component
  * @retval none
  */
__weak uint16_t R3_1_SetADCSampPointCalibration( PWMC_Handle_t * pHdl )
{
#if defined (__ICCARM__)
#pragma cstat_disable = "MISRAC2012-Rule-11.3"
#endif
  PWMC_R3_1_Handle_t * pHandle = ( PWMC_R3_1_Handle_t * )pHdl;
#if defined (__ICCARM__)
#pragma cstat_restore = "MISRAC2012-Rule-11.3"
#endif

  pHandle->ADCTriggerEdge = LL_ADC_REG_TRIG_EXT_RISING;
  pHandle->_Super.Sector = pHandle->CalibSector;
  
  return R3_1_WriteTIMRegisters( pHdl,  ( uint16_t )( pHandle->Half_PWMPeriod ) - 1u);
}

/**
  * @brief  Configure the ADC for the current sampling related to sector 1.
  *         It means set the sampling point via TIM1_Ch4 value, the ADC sequence
  *         and channels.
  * @param  pHdl: handler of the current instance of the PWM component
  * @retval none
  */
__weak uint16_t R3_1_SetADCSampPointSectX( PWMC_Handle_t * pHdl )
{
#if defined (__ICCARM__)
#pragma cstat_disable = "MISRAC2012-Rule-11.3"
#endif
  PWMC_R3_1_Handle_t * pHandle = ( PWMC_R3_1_Handle_t * )pHdl;
#if defined (__ICCARM__)
#pragma cstat_restore = "MISRAC2012-Rule-11.3"
#endif
  uint16_t hCntSmp;
  uint16_t hDeltaDuty;
  register uint16_t lowDuty = pHdl->lowDuty;
  register uint16_t midDuty = pHdl->midDuty;

  /* Check if sampling AB in the middle of PWM is possible */
  if ( ( uint16_t )( pHandle->Half_PWMPeriod - lowDuty ) > pHandle->pParams_str->hTafter )
  {
    /* When it is possible to sample in the middle of the PWM period, always sample the same phases
     * (AB are chosen) for all sectors in order to not induce current discontinuities when there are differences
     * between offsets */

    /* sector number needed by GetPhaseCurrent, phase A and B are sampled which corresponds
     * to sector 4 (could be also sector 5) */
    pHandle->_Super.Sector = SECTOR_5;

    /* set sampling  point trigger in the middle of PWM period */
    hCntSmp = ( uint32_t )( pHandle->Half_PWMPeriod ) - 1u;
  }
  else
  {
    /* In this case it is necessary to convert phases with Maximum and variable complementary duty cycle.*/

    /* ADC Injected sequence configuration. The stator phase with minimum value of complementary
        duty cycle is set as first. In every sector there is always one phase with maximum complementary duty,
        one with minimum complementary duty and one with variable complementary duty. In this case, phases
        with variable complementary duty and with maximum duty are converted and the first will be always
        the phase with variable complementary duty cycle */

    /* Crossing Point Searching */
    hDeltaDuty = ( uint16_t )( lowDuty - midDuty );

    /* Definition of crossing point */
    if ( hDeltaDuty > ( uint16_t )( pHandle->Half_PWMPeriod - lowDuty ) * 2u )
    {
      hCntSmp = lowDuty - pHandle->pParams_str->hTbefore;
    }
    else
    {
      hCntSmp = lowDuty + pHandle->pParams_str->hTafter;

      if ( hCntSmp >= pHandle->Half_PWMPeriod )
      {
        pHandle->ADCTriggerEdge = LL_ADC_REG_TRIG_EXT_FALLING;

        hCntSmp = ( 2u * pHandle->Half_PWMPeriod ) - hCntSmp - 1u;
      }
    }
  }
  
  return R3_1_WriteTIMRegisters( &pHandle->_Super, hCntSmp );
}

/**
* @brief  Write the dutycycle into timer regiters and check for FOC duration.
* @param  pHandle Pointer on the target component instance.
* @param  hCCR4Reg capture/compare register value.
* @retval none
*/
__weak uint16_t R3_1_WriteTIMRegisters(PWMC_Handle_t *pHdl, uint16_t hCCR4Reg)
{ 
#if defined (__ICCARM__)
#pragma cstat_disable = "MISRAC2012-Rule-11.3"
#endif
  PWMC_R3_1_Handle_t * pHandle = ( PWMC_R3_1_Handle_t * )pHdl;
#if defined (__ICCARM__)
#pragma cstat_restore = "MISRAC2012-Rule-11.3"
#endif
  TIM_TypeDef*  TIMx = TIM1;
  uint16_t hAux;

  LL_TIM_OC_SetCompareCH1 ( TIMx, (uint32_t)pHandle->_Super.CntPhA );
  LL_TIM_OC_SetCompareCH2 ( TIMx, (uint32_t)pHandle->_Super.CntPhB );
  LL_TIM_OC_SetCompareCH3 ( TIMx, (uint32_t)pHandle->_Super.CntPhC );
  LL_TIM_OC_SetCompareCH4 ( TIMx, (uint32_t)hCCR4Reg );
  
 /* Re-configuration of CCR4 must be done before the timer update to be taken
    into account at the next PWM cycle. Otherwise we are too late, we flag a
    FOC_DURATION error */
  if ( LL_TIM_CC_IsEnabledChannel(TIMx, LL_TIM_CHANNEL_CH4))
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
  
  return hAux;
}

/**
* @brief  Implementaion of PWMC_GetPhaseCurrents to be performed during 
*         calibration. It sum up ADC conversion data into PhaseAOffset and
*         PhaseBOffset to compute the offset introduced in the current feedback
*         network. It is required to proper configure ADC inputs before to enable
*         the offset computation.
* @param  pHdl Pointer on the target component instance.
* @retval It always returns {0,0} in ab_t format
*/
__weak void R3_1_HFCurrentsCalibrationAB(PWMC_Handle_t *pHdl, ab_t* pStator_Currents)
{ 
#if defined (__ICCARM__)
#pragma cstat_disable = "MISRAC2012-Rule-11.3"
#endif
  PWMC_R3_1_Handle_t * pHandle = ( PWMC_R3_1_Handle_t * )pHdl;
#if defined (__ICCARM__)
#pragma cstat_restore = "MISRAC2012-Rule-11.3"
#endif
  TIM_TypeDef * TIMx = TIM1;
  uint8_t bSector = pHandle->CalibSector;

  /* disable ADC trigger */
  LL_TIM_CC_DisableChannel( TIMx, LL_TIM_CHANNEL_CH4 );

  if ( pHandle->PolarizationCounter < NB_CONVERSIONS )
  {
    pHandle->PhaseAOffset += *pHandle->pParams_str->ADCDataReg1[bSector];
    pHandle->PhaseBOffset += *pHandle->pParams_str->ADCDataReg2[bSector];
    pHandle->PolarizationCounter++;
  }

  /* during offset calibration no current is flowing in the phases */
  pStator_Currents->a = 0;
  pStator_Currents->b = 0;
}

/**
* @brief  Implementation of PWMC_GetPhaseCurrents to be performed during
*         calibration. It sum up ADC conversion data into PhaseCOffset
*         to compute the offset introduced in the current feedback
*         network. It is required to proper configure ADC inputs before to enable
*         the offset computation.
* @param  pHandle Pointer on the target component instance.
* @retval It always returns {0,0} in ab_t format
*/
void R3_1_HFCurrentsCalibrationC( PWMC_Handle_t * pHdl, ab_t * pStator_Currents )
{
#if defined (__ICCARM__)
#pragma cstat_disable = "MISRAC2012-Rule-11.3"
#endif
  PWMC_R3_1_Handle_t * pHandle = ( PWMC_R3_1_Handle_t * )pHdl;
#if defined (__ICCARM__)
#pragma cstat_restore = "MISRAC2012-Rule-11.3"
#endif
  TIM_TypeDef * TIMx = TIM1;
  uint8_t bSector = pHandle->CalibSector;

  /* disable ADC trigger */
  LL_TIM_CC_DisableChannel( TIMx, LL_TIM_CHANNEL_CH4 );
  
  pHandle->_Super.Sector = SECTOR_1;
  if ( pHandle->PolarizationCounter < NB_CONVERSIONS )
  {
    pHandle->PhaseCOffset += *pHandle->pParams_str->ADCDataReg2[bSector];
    pHandle->PolarizationCounter++;
  }

  /* during offset calibration no current is flowing in the phases */
  pStator_Currents->a = 0;
  pStator_Currents->b = 0;
}

/**
  * @brief  It turns on low sides switches. This function is intended to be
  *         used for charging boot capacitors of driving section. It has to be
  *         called each motor start-up when using high voltage drivers
  * @param  pHdl: handler of the current instance of the PWM component
  * @retval none
  */
__weak void R3_1_TurnOnLowSides(PWMC_Handle_t *pHdl)
{
#if defined (__ICCARM__)
#pragma cstat_disable = "MISRAC2012-Rule-11.3"
#endif
  PWMC_R3_1_Handle_t * pHandle = ( PWMC_R3_1_Handle_t * )pHdl;
#if defined (__ICCARM__)
#pragma cstat_restore = "MISRAC2012-Rule-11.3"
#endif
  TIM_TypeDef*  TIMx = TIM1;
  
  pHandle->_Super.TurnOnLowSidesAction = true;

  /* Clear Update Flag */
  LL_TIM_ClearFlag_UPDATE(TIMx);
  
  /*Turn on the three low side switches */
  LL_TIM_OC_SetCompareCH1(TIMx, 0u);
  LL_TIM_OC_SetCompareCH2(TIMx, 0u);
  LL_TIM_OC_SetCompareCH3(TIMx, 0u);
  
  /* Wait until next update */
  while (LL_TIM_IsActiveFlag_UPDATE(TIMx)==RESET)
  {}
  
  /* Main PWM Output Enable */
  LL_TIM_EnableAllOutputs(TIMx);

  if ((pHandle->pParams_str->LowSideOutputs)== ES_GPIO)
  {
    LL_GPIO_SetOutputPin( pHandle->pParams_str->pwm_en_u_port, pHandle->pParams_str->pwm_en_u_pin );
    LL_GPIO_SetOutputPin( pHandle->pParams_str->pwm_en_v_port, pHandle->pParams_str->pwm_en_v_pin );
    LL_GPIO_SetOutputPin( pHandle->pParams_str->pwm_en_w_port, pHandle->pParams_str->pwm_en_w_pin );

  }
  return;   
}

/**
  * @brief  This function enables the PWM outputs
  * @param  pHdl: handler of the current instance of the PWM component
  * @retval none
  */
__weak void R3_1_SwitchOnPWM(PWMC_Handle_t *pHdl)
{
#if defined (__ICCARM__)
#pragma cstat_disable = "MISRAC2012-Rule-11.3"
#endif
  PWMC_R3_1_Handle_t * pHandle = ( PWMC_R3_1_Handle_t * )pHdl;
#if defined (__ICCARM__)
#pragma cstat_restore = "MISRAC2012-Rule-11.3"
#endif
  TIM_TypeDef* TIMx = TIM1;

  pHandle->_Super.TurnOnLowSidesAction = false;

  /* We forbid ADC usage for regular conversion on Systick*/
  pHandle->ADCRegularLocked=true; 

  /* Set all duty to 50% */
  LL_TIM_OC_SetCompareCH1(TIMx, (uint32_t)(pHandle->Half_PWMPeriod >> 1));
  LL_TIM_OC_SetCompareCH2(TIMx, (uint32_t)(pHandle->Half_PWMPeriod >> 1));
  LL_TIM_OC_SetCompareCH3(TIMx, (uint32_t)(pHandle->Half_PWMPeriod >> 1));
  LL_TIM_OC_SetCompareCH4(TIMx, (uint32_t)(pHandle->Half_PWMPeriod - 5u));

  /* Wait for a new PWM period */
  LL_TIM_ClearFlag_UPDATE(TIMx);
  while (LL_TIM_IsActiveFlag_UPDATE(TIMx) == RESET)
  {}
  LL_TIM_ClearFlag_UPDATE(TIMx);

  /* Main PWM Output Enable */
  TIMx->BDTR |= LL_TIM_OSSI_ENABLE; 
  LL_TIM_EnableAllOutputs(TIMx);

  if ((pHandle->pParams_str->LowSideOutputs)== ES_GPIO)
  {
    if ((TIMx->CCER & TIMxCCER_MASK_CH123) != 0u)
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

  /* Setting of the DMA Buffer Size.*/
  /* NOTE. This register (CNDTRx) must not be written when the DMAy Channel x is ENABLED */
  LL_DMA_DisableChannel(DMA1, LL_DMA_CHANNEL_1);
  /* Write the Buffer size on CNDTR register */
  LL_DMA_SetDataLength( DMA1, LL_DMA_CHANNEL_1, 2u );

  /* DMA Enabling */
  LL_DMA_EnableChannel(DMA1, LL_DMA_CHANNEL_1);

  /* Clear EOC */
  LL_ADC_ClearFlag_EOC(ADC1);

  /* Enable ADC DMA request*/
  LL_ADC_REG_SetDMATransfer(ADC1, LL_ADC_REG_DMA_TRANSFER_LIMITED);

  /* Clear Pending Interrupt Bits */  
  LL_DMA_ClearFlag_HT1(DMA1);  // TBC: for TC1, GL1 (not cleared ...) 

  /* DMA Interrupt Event configuration */
  LL_DMA_EnableIT_TC(DMA1, LL_DMA_CHANNEL_1);

  /* Clear Update Flag */
  LL_TIM_ClearFlag_UPDATE( TIMx );
  /* Enable Update IRQ */
  LL_TIM_EnableIT_UPDATE( TIMx );

  return; 
}
 

/**
  * @brief  It disables PWM generation on the proper Timer peripheral acting on
  *         MOE bit and reset the TIM status
  * @param  pHdl: handler of the current instance of the PWM component
  * @retval none
  */
__weak void R3_1_SwitchOffPWM(PWMC_Handle_t *pHdl)
{
#if defined (__ICCARM__)
#pragma cstat_disable = "MISRAC2012-Rule-11.3"
#endif
  PWMC_R3_1_Handle_t * pHandle = ( PWMC_R3_1_Handle_t * )pHdl;
#if defined (__ICCARM__)
#pragma cstat_restore = "MISRAC2012-Rule-11.3"
#endif
  TIM_TypeDef* TIMx = TIM1;

  /* Enable Update IRQ */
  LL_TIM_DisableIT_UPDATE( TIMx );
  
  pHandle->_Super.TurnOnLowSidesAction = false;

  /* Main PWM Output Disable */
  LL_TIM_DisableAllOutputs(TIMx);
  if ( pHandle->BrakeActionLock == true )
  {
  }
  else
  {
    if ((pHandle->pParams_str->LowSideOutputs)== ES_GPIO)
    {
      LL_GPIO_ResetOutputPin( pHandle->pParams_str->pwm_en_u_port, pHandle->pParams_str->pwm_en_u_pin );
      LL_GPIO_ResetOutputPin( pHandle->pParams_str->pwm_en_v_port, pHandle->pParams_str->pwm_en_v_pin );
      LL_GPIO_ResetOutputPin( pHandle->pParams_str->pwm_en_w_port, pHandle->pParams_str->pwm_en_w_pin );
    }
  }

  
  /* Disabling of DMA Interrupt Event configured */
  LL_DMA_DisableIT_TC(DMA1, LL_DMA_CHANNEL_1);
  
  LL_ADC_REG_StopConversion(ADC1);
    
  /* Disable ADC DMA request*/
  ADC1->CFGR1 &= ~ADC_CFGR1_DMAEN; 
  
  /* Clear Transmission Complete Flag  of DMA1 Channel1 */
  LL_DMA_ClearFlag_TC1(DMA1);
  
  /* Clear EOC */
  LL_ADC_ClearFlag_EOC( ADC1 );

  /* The ADC is not triggered anymore by the PWM timer */
  LL_ADC_REG_SetTriggerSource (ADC1, LL_ADC_REG_TRIG_SOFTWARE);
  
 /* We allow ADC usage for regular conversion on Systick*/
  pHandle->ADCRegularLocked=false; 

  /* Wait for a new PWM period to flush last HF task */
  LL_TIM_ClearFlag_UPDATE(TIMx);
  while (LL_TIM_IsActiveFlag_UPDATE(TIMx) == RESET)
  {}
  LL_TIM_ClearFlag_UPDATE(TIMx);

  return;  
}

/**
  * @brief  It contains the TIMx Update event interrupt
  * @param  pHandle: handler of the current instance of the PWM component
  * @retval none
  */
void * R3_1_TIMx_UP_IRQHandler( PWMC_R3_1_Handle_t * pHandle )
{
  
  /* Set the trigger polarity as computed inside SetADCSampPointSectX*/
  LL_ADC_REG_SetTriggerEdge (ADC1, pHandle->ADCTriggerEdge);
  /* set ADC trigger source */
  LL_ADC_REG_SetTriggerSource(ADC1, LL_ADC_REG_TRIG_EXT_TIM1_CH4);
  /* Set scan direction according to the sector */  
  LL_ADC_REG_SetSequencerScanDirection(ADC1, pHandle->pParams_str->ADCScandir[pHandle->_Super.Sector]<<ADC_CFGR1_SCANDIR_Pos);
  /* Configure the ADC scheduler as selected inside SetADCSampPointSectX*/
  ADC1->CHSELR = pHandle->pParams_str->ADCConfig[pHandle->_Super.Sector];
  /* re-enable ADC trigger */
  LL_TIM_CC_EnableChannel( TIM1, LL_TIM_CHANNEL_CH4 );
  /* ADC needs to be restarted because DMA is configured as limited */
  LL_ADC_REG_StartConversion( ADC1 );

  /* Reset the ADC trigger edge for next conversion */
  pHandle->ADCTriggerEdge = LL_ADC_REG_TRIG_EXT_RISING;

  return &pHandle->_Super.Motor;
}

/**
  * @brief  It contains the TIMx Break event interrupt connected to overcurrent.
  * @param  this related object
 * @retval none

  */
__weak void* R3_1_OVERCURRENT_IRQHandler(PWMC_R3_1_Handle_t *pHandle)
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
  * @brief It contains the TIMx Break event interrupt connected to overvoltage.
  * @param pHandle: handler of the current instance of the PWM component
  * @retval none
  */
__weak void * R3_1_OVERVOLTAGE_IRQHandler( PWMC_R3_1_Handle_t * pHandle )
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
__weak uint16_t R3_1_IsOverCurrentOccurred(PWMC_Handle_t *pHdl)
{
#if defined (__ICCARM__)
#pragma cstat_disable = "MISRAC2012-Rule-11.3"
#endif
  PWMC_R3_1_Handle_t * pHandle = ( PWMC_R3_1_Handle_t * )pHdl;
#if defined (__ICCARM__)
#pragma cstat_restore = "MISRAC2012-Rule-11.3"
#endif
  uint16_t retVal = MC_NO_FAULTS;
  
  if ( pHandle->OverVoltageFlag == true )
  {
    retVal = MC_OVER_VOLT;
    pHandle->OverVoltageFlag = false;
  }
  
  if ( pHandle->OverCurrentFlag == true )
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

/**
  * @}
  */

/************************ (C) COPYRIGHT 2019 STMicroelectronics *****END OF FILE****/
