/**
  ******************************************************************************
  * @file    r1_f7xx_pwm_curr_fdbk.h
  * @author  Motor Control SDK Team, ST Microelectronics
  * @brief   This file contains all definitions and functions prototypes for the
  *          r1_f7xx_pwm_curr_fdbk component of the Motor Control SDK.
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
  * @ingroup r1_f7xx_pwm_curr_fdbk
  */

/* Define to prevent recursive inclusion -------------------------------------*/
#ifndef __R1_F7XX_PWMCURRFDBK_H
#define __R1_F7XX_PWMCURRFDBK_H

#ifdef __cplusplus
extern "C" {
#endif /* __cplusplus */

/* Includes ------------------------------------------------------------------*/
#include "pwm_curr_fdbk.h"

/** @addtogroup MCSDK
  * @{
  */

/** @addtogroup pwm_curr_fdbk
  * @{
  */

/** @addtogroup r1_f7xx_pwm_curr_fdbk
  * @{
  */

/* Exported constants --------------------------------------------------------*/
#if (defined (STM32F756xx) || defined (STM32F746xx) || defined (STM32F745xx))
#define STM32F74XX_75XX 1
#endif
#define GPIO_NoRemap_TIM1 ((uint32_t)(0))
#define SHIFTED_TIMs      ((uint8_t) 1)
#define NO_SHIFTED_TIMs   ((uint8_t) 0)

#define NONE    ((uint8_t)(0x00))
#define EXT_MODE  ((uint8_t)(0x01))
#define INT_MODE  ((uint8_t)(0x02))
#define STBD3 0x0002u /*!< Flag to indicate which phase has been distorted
                           in boudary 3 zone (A or B)*/
#define DSTEN 0x0004u /*!< Flag to indicate if the distortion must be performed
                           or not (in case of charge of bootstrap capacitor phase
                           is not required)*/

/* Exported types ------------------------------------------------------------*/

/**
 * @brief  Paamters structure of the r1_f7xx_pwm_curr_fdbk Component.
 *
 */
typedef const struct
{
  ADC_TypeDef * regconvADCx;        /*!< ADC peripheral used for regular
                                         conversion.*/
  ADC_TypeDef * ADCx;               /*!< ADC peripheral to be used*/
  TIM_TypeDef * TIMx;               /*!< It contains the pointer to the timer
                                         used for PWM generation. It must
                                         equal to TIM1 if InstanceNbr is
                                         equal to 1, to TIM8 otherwise */
  GPIO_TypeDef * pwm_en_u_port;     /*!< Channel 1N (low side) GPIO output
                                         port (if used, after re-mapping).
                                         It must be GPIOx x= A, B, ...*/
  GPIO_TypeDef * pwm_en_v_port;     /*!< Channel 2N (low side) GPIO output
                                         port (if used, after re-mapping).
                                         It must be GPIOx x= A, B, ...*/
  GPIO_TypeDef * pwm_en_w_port;     /*!< Channel 3N (low side)  GPIO output
                                         port (if used, after re-mapping).
                                         It must be GPIOx x= A, B, ...*/
  uint16_t pwm_en_u_pin;            /*!< Channel 1N (low side) GPIO output pin
                                          (if used, after re-mapping). It must be
                                          GPIO_Pin_x x= 0, 1, ...*/
  uint16_t pwm_en_v_pin;            /*!< Channel 2N (low side) GPIO output pin
                                         (if used, after re-mapping). It must be
                                         GPIO_Pin_x x= 0, 1, ...*/
  uint16_t pwm_en_w_pin;            /*!< Channel 3N (low side)  GPIO output pin
                                        (if used, after re-mapping). It must be
                                        GPIO_Pin_x x= 0, 1, ...*/
  uint16_t Tafter;                  /*!< It is the sum of dead time plus rise time
                                            express in number of TIM clocks.*/
  uint16_t Tbefore;                 /*!< It is the value of sampling time
                                            expressed in numbers of TIM clocks.*/
  uint16_t TMin;                    /*!< It is the sum of dead time plus rise time
                                            plus sampling time express in numbers of
                                            TIM clocks.*/
  uint16_t HTMin;                   /*!< It is the half of TMin value*/
  uint16_t CHTMin;                  /*!< It is the half of TMin value, considering FOC rate*/
  uint16_t TSample;                 /*!< It is the sampling time express in
                                            numbers of TIM clocks.*/
  uint16_t MaxTrTs;                 /*!< It is the maximum between twice of rise
                                          time express in number of TIM clocks and
                                          twice of sampling time express in numbers
                                          of TIM clocks.*/
  /* Dual MC parameters --------------------------------------------------------*/
  uint8_t  FreqRatio;              /*!< It is used in case of dual MC to
                                        synchronize TIM1 and TIM8. It has
                                        effect only on the second instanced
                                        object and must be equal to the
                                        ratio between the two PWM frequencies
                                        (higher/lower). Supported values are
                                        1, 2 or 3 */
  uint8_t  IsHigherFreqTim;        /*!< When FreqRatio is greather than 1
                                        this param is used to indicate if this
                                        instance is the one with the highest
                                        frequency. Allowed value are: HIGHER_FREQ
                                        or LOWER_FREQ */
  uint8_t EmergencyStop;           /*!< It defines the modality of emergency
                                        input 2. It must be any of the
                                        the following:
                                        NONE - feature disabled.
                                        INT_MODE - Internal comparator used
                                        as source of emergency event.
                                        EXT_MODE - External comparator used
                                        as source of emergency event.*/
  uint8_t IChannel;                  /*!< ADC channel used for conversion of
                                          current. It must be equal to
                                          ADC_Channel_x x= 0, ..., 15*/
  uint8_t  RepetitionCounter;        /*!< It expresses the number of PWM
                                          periods to be elapsed before compare
                                          registers are updated again. In
                                          particular:
                                          RepetitionCounter= (2* PWM periods) -1*/
  LowSideOutputsFunction_t LowSideOutputs; /*!< Low side or enabling signals
                                                generation method are defined
                                                here.*/

} R1_F7_Params_t, *pR1_F7_Params_t;

/**
  * @brief  Handle structure of the r1_f7xx_pwm_curr_fdbk Component
  */
typedef struct
{
  PWMC_Handle_t _Super;                    /*!< Offset of current sensing network  */
  DMA_Stream_TypeDef * DistortionDMAy_Chx; /*!< DMA resource used for doing the distortion*/
  uint32_t ADC_JSQR;                       /*!< Stores the value for JSQR register to select
                                                phase A motor current.*/
  uint32_t ADC_ExternalTriggerInjected;
  uint32_t PhaseOffset;                    /*!< Offset of Phase current sensing network  */
  int16_t CurrAOld;                        /*!< Previous measured value of phase A current*/
  int16_t CurrBOld;                        /*!< Previous measured value of phase B current*/
  uint16_t DmaBuff[2];                     /*!< Buffer used for PWM distortion points*/
  uint16_t CntSmp1;                        /*!< First sampling point express in timer counts*/
  uint16_t CntSmp2;                        /*!< Second sampling point express in timer counts*/
  uint16_t Half_PWMPeriod;                 /* Half PWM Period in timer clock counts */
  uint16_t Flags;                          /*!< Flags
                                                 STBD3: Flag to indicate which phase has been distorted
                                                        in boudary 3 zone (A or B)
                                                 DSTEN: Flag to indicate if the distortion must be
                                                        performed or not (charge of bootstrap
                                                        capacitor phase) */
  uint8_t sampCur1;                        /*!< Current sampled in the first sampling point*/
  uint8_t sampCur2;                        /*!< Current sampled in the second sampling point*/
  uint8_t Inverted_pwm_new;                /*!< This value indicates the type of the current
                                                PWM period (Regular, Distort PHA, PHB or PHC)*/
  uint8_t  PolarizationCounter;   /*!< Number of conversions performed during the
                                                calibration phase*/
  bool OverCurrentFlag;                    /*!< This flag is set when an overcurrent occurs.*/
  bool OverVoltageFlag;                    /*!< This flag is set when an overvoltage occurs.*/
  bool BrakeActionLock;                    /*!< This flag is set to avoid that brake action is interrupted.*/
  bool soFOC;
  pR1_F7_Params_t pParams_str;

} PWMC_R1_F7_Handle_t;

/**
  * It performs the initialization of the MCU peripherals required for
  * the PWM generation and current sensing. this initialization is dedicated
  * to one shunt topology and F3 family
  */
void R1F7XX_Init( PWMC_R1_F7_Handle_t * pHandle );

/**
  * It disables PWM generation on the proper Timer peripheral acting on
  * MOE bit
  */
void R1F7XX_SwitchOffPWM( PWMC_Handle_t * pHdl );

/**
  * It enables PWM generation on the proper Timer peripheral acting on MOE
  * bit
  */
void R1F7XX_SwitchOnPWM( PWMC_Handle_t * pHdl );

/**
  * It turns on low sides switches. This function is intended to be
  * used for charging boot capacitors of driving section. It has to be
  * called each motor start-up when using high voltage drivers
  */
void R1F7XX_TurnOnLowSides( PWMC_Handle_t * pHdl );

/**
  * It computes and return latest converted motor phase currents motor
  */
void R1F7XX_GetPhaseCurrents( PWMC_Handle_t * pHdl, ab_t * pStator_Currents );

/**
  * It contains the TIMx Update event interrupt
  */
void * R1F7XX_TIMx_UP_IRQHandler( PWMC_R1_F7_Handle_t * pHdl );

/**
  * It contains the TIMx Break2 event interrupt
  */
void * R1F7XX_BRK2_IRQHandler( PWMC_R1_F7_Handle_t * pHdl );

/**
  * It contains the TIMx Break1 event interrupt
  */
void * R1F7XX_BRK_IRQHandler( PWMC_R1_F7_Handle_t * pHdl );

/**
  * It stores into pHandle the offset voltage read onchannels when no
  * current is flowing into the motor
  */
void R1F7XX_CurrentReadingCalibration( PWMC_Handle_t * pHdl );

/**
  * Implementation of the single shunt algorithm to setup the
  * TIM1 register and DMA buffers values for the next PWM period.
  */
uint16_t R1F7XX_CalcDutyCycles( PWMC_Handle_t * pHdl );

/**
  * It is used to check if an overcurrent occurred since last call.
  */
uint16_t R1F7XX_IsOverCurrentOccurred( PWMC_Handle_t * pHdl );

/**
  * It is used to set the PWM mode for R/L detection.
  */
void R1F7XX_RLDetectionModeEnable( PWMC_Handle_t * pHdl );

/**
  * @brief  It is used to disable the PWM mode for R/L detection.
  */
void R1F7XX_RLDetectionModeDisable( PWMC_Handle_t * pHdl );

/**
  * @brief  It is used to set the PWM dutycycle for R/L detection.
  */
uint16_t R1F7XX_RLDetectionModeSetDuty( PWMC_Handle_t * pHdl, uint16_t hDuty );

/**
  * @}
  */

/**
  * @}
  */

/**
  * @}
  */

#ifdef __cplusplus
}
#endif /* __cpluplus */

#endif /*__R1_F7XX_PWMCURRFDBK_H*/

/******************* (C) COPYRIGHT 2019 STMicroelectronics *****END OF FILE****/
