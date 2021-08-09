/**
  ******************************************************************************
  * @file    r1_g0xx_pwm_curr_fdbk.h
  * @author  Motor Control SDK Team, ST Microelectronics
  * @brief   This file contains all definitions and functions prototypes for the
  *          r1_f0xx_pwm_curr_fdbk component of the Motor Control SDK.
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

/* Define to prevent recursive inclusion -------------------------------------*/
#ifndef __R1_F0XX_PWMNCURRFDBK_H
#define __R1_F0XX_PWMNCURRFDBK_H

#ifdef __cplusplus
 extern "C" {
#endif /* __cplusplus */

/* Includes ------------------------------------------------------------------*/
#include "pwm_curr_fdbk.h"

/** @addtogroup MCSDK
  * @{
  */

/** @defgroup r1_f0XX_pwm_curr_fdbk
  * @brief PWM F0XX single shunt component of the Motor Control SDK
  *
  * @{
  */

/* Exported constants --------------------------------------------------------*/

/** 
* @brief  Flags definition
*/
#define EOFOC 0x0001u /*!< Flag to indicate end of FOC duty available */
#define STBD3 0x0002u /*!< Flag to indicate which phase has been distorted
                           in boudary 3 zone (A or B)*/
#define DSTEN 0x0004u /*!< Flag to indicate if the distortion must be performed
                           or not (in case of charge of bootstrap capacitor phase
                           is not required)*/
#define SOFOC 0x0008u /*!< This flag will be reset to zero at the begin of FOC
                           and will be set in the UP IRQ. If at the end of
                           FOC it is set the software error must be generated*/
#define CALIB 0x0010u /*!< This flag is used to indicate the ADC calibration
                           phase in order to avoid concurrent regular conversions*/
/* Exported types ------------------------------------------------------------*/

/**
  * @brief  R1_F0XX parameters definition
  */
typedef struct
{
  TIM_TypeDef * TIMx;                   /*!< timer used for PWM generation.*/
  GPIO_TypeDef * pwm_en_u_port;
  GPIO_TypeDef * pwm_en_v_port;
  GPIO_TypeDef * pwm_en_w_port;

  uint32_t      pwm_en_u_pin;
  uint32_t      pwm_en_v_pin;
  uint32_t      pwm_en_w_pin;

  uint16_t DeadTime;             /*!< Dead time in number of TIM clock
                                       cycles. If CHxN are enabled, it must
                                       contain the dead time to be generated
                                       by the microcontroller, otherwise it
                                       expresses the maximum dead time
                                       generated by driving network*/
  uint16_t Tafter;               /*!< It is the sum of dead time plus rise time
                                       express in number of TIM clocks.*/
  uint16_t Tbefore;              /*!< It is the value of sampling time
                                       expressed in numbers of TIM clocks.*/
  uint16_t TMin;                 /*!< It is the sum of dead time plus rise time
                                       plus sampling time express in numbers of
                                       TIM clocks.*/
  uint16_t HTMin;                /*!< It is the half of TMin value.*/
  uint16_t CHTMin;                /*!< It is the compensated half of TMin value in case of rate >1.*/
  uint16_t TSample;              /*!< It is the sampling time express in
                                       numbers of TIM clocks.*/
  uint16_t MaxTrTs;              /*!< It is the maximum between twice of rise
                                       time express in number of TIM clocks and
                                       twice of sampling time express in numbers
                                       of TIM clocks.*/

  uint8_t IChannel;              /*!< ADC channel used for conversion of
                                       current. It must be equal to
                                       ADC_CHANNEL_x x= 0, ..., 15*/
  uint8_t  RepetitionCounter;    /*!< It expresses the number of PWM
                                       periods to be elapsed before compare
                                       registers are updated again. In
                                       particular:
                                       RepetitionCounter= (2* PWM periods) -1*/

  LowSideOutputsFunction_t LowSideOutputs; /*!< Low side or enabling signals
                                                generation method are defined
                                                here.*/

 


}R1_G0XXParams_t;

/**
  * @brief  Handle structure of the r1_f0xx_pwm_curr_fdbk Component
  */
typedef struct
{
  PWMC_Handle_t _Super;       /*!< Offset of current sensing network  */
  uint16_t Half_PWMPeriod;    /*!< Half PWM Period in timer clock counts  */
  uint16_t PhaseOffset;      /*!< Offset of current sensing network  */
  uint16_t DmaBuff[2];       /*!< Buffer used for PWM distortion points*/
  uint16_t CntSmp1;          /*!< First sampling point express in timer counts*/
  uint16_t CntSmp2;          /*!< Second sampling point express in timer counts*/
  int16_t CurrAOld;          /*!< Previous measured value of phase A current*/
  int16_t CurrBOld;          /*!< Previous measured value of phase B current*/
  int16_t CurrCOld;          /*!< Previous measured value of phase C current*/
  uint16_t CurConv[2];       /*!< Array used to store phase current conversions*/
  uint16_t Flags;            /*!< Flags
                                   EOFOC: Flag to indicate end of FOC duty available
                                   STBD3: Flag to indicate which phase has been distorted
                                          in boudary 3 zone (A or B)
                                   DSTEN: Flag to indicate if the distortion must be
                                          performed or not (charge of bootstrap
                                          capacitor phase)
                                   SOFOC: This flag will be reset to zero at the begin of FOC
                                          and will be set in the UP IRQ. If at the end of
                                          FOC it is set the software error must be generated
                                   CALIB: This flag is used to indicate the ADC calibration
                                          phase in order to avoid concurrent regular conversions */
  uint8_t sampCur1;           /*!< Current sampled in the first sampling point*/
  uint8_t sampCur2;           /*!< Current sampled in the second sampling point*/
  uint8_t Inverted_pwm_new;  /*!< This value indicates the type of the current
                                   PWM period (Regular, Distort PHA, PHB or PHC)*/
  bool UpdateFlagBuffer;  /*!< buffered version of Timer update IT flag */
  bool OverCurrentFlag;         /*!< This flag is set when an overcurrent occurs.*/
  bool OverVoltageFlag; 
  bool BrakeActionLock;
  bool ADCRegularLocked;        /*!< When it's true, we do not allow usage of ADC to do regular conversion on systick*/

  R1_G0XXParams_t const * pParams_str;

}PWMC_R1_G0_Handle_t;

/* Exported functions ------------------------------------------------------- */

/**
  * R1_G0XX implements MC IRQ function TIMER Break
  */
void * R1G0XX_OVERCURRENT_IRQHandler(PWMC_R1_G0_Handle_t *pHandle);

void * R1G0XX_OVERVOLTAGE_IRQHandler(PWMC_R1_G0_Handle_t *pHandle);

/**
  * R1_G0XX implements MC IRQ function TIMER Update
  */
void R1G0XX_TIMx_UP_IRQHandler(PWMC_R1_G0_Handle_t *pHdl);

/**
  * It initializes TIM1, ADC, GPIO, DMA1 and NVIC for single shunt current
  * reading configuration using STM32F0XX family.
  */
void R1G0XX_Init(PWMC_R1_G0_Handle_t *pHandle);

/**
  * It stores into the handler the voltage present on the
  * current feedback analog channel when no current is flowin into the
  * motor
  */
void R1G0XX_CurrentReadingCalibration(PWMC_Handle_t *pHdl);

/**
  * It computes and return latest converted motor phase currents motor
  */
void R1G0XX_GetPhaseCurrents(PWMC_Handle_t *pHdl, ab_t* pStator_Currents);

/**
  * It turns on low sides switches. This function is intended to be
  * used for charging boot capacitors of driving section. It has to be
  * called each motor start-up when using high voltage drivers
  */
void R1G0XX_TurnOnLowSides(PWMC_Handle_t *pHdl);

/**
  * It enables PWM generation on the proper Timer peripheral acting on
  * MOE bit, enaables the single shunt distortion and reset the TIM status
  */
void R1G0XX_SwitchOnPWM(PWMC_Handle_t *pHdl);

/**
  * It disables PWM generation on the proper Timer peripheral acting on
  * MOE bit, disables the single shunt distortion and reset the TIM status
  */
void R1G0XX_SwitchOffPWM(PWMC_Handle_t *pHdl);

/**
  * Implementation of the single shunt algorithm to setup the
  * TIM1 register and DMA buffers values for the next PWM period.
  */
uint16_t R1G0XX_CalcDutyCycles(PWMC_Handle_t *pHdl);

/**
  * Execute a regular conversion.
  * The function is not re-entrant (can't executed twice at the same time)
  * It returns 0xFFFF in case of conversion error.
  */
uint16_t R1G0XX_ExecRegularConv(PWMC_Handle_t *pHdl, uint8_t bChannel);

/**
  * It sets the specified sampling time for the specified ADC channel
  * on ADC1. It must be called once for each channel utilized by user
  */
void R1G0XX_ADC_SetSamplingTime(PWMC_Handle_t *pHdl, ADConv_t ADConv_struct);

/**
  * It sets the specified sampling time for the specified ADC channel
  * on ADC1. It must be called once for each channel utilized by user
  */
uint16_t R1G0XX_IsOverCurrentOccurred(PWMC_Handle_t *pHdl);

/**
  * @}
  */

/**
  * @}
  */

#ifdef __cplusplus
}
#endif /* __cpluplus */

#endif /*__R1_F0XX_PWMNCURRFDBK_H*/

/************************ (C) COPYRIGHT STMicroelectronics *****END OF FILE****/