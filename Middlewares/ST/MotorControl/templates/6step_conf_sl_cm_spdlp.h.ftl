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
 * @file    6step_conf_sl_cm_spdlp.h
 * @author  IPC Rennes
 * @brief   Header file for the 6step_conf.c file
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

/* Define to prevent recursive inclusion -------------------------------------*/
#ifndef __6STEP_CONF_SL_CM_SPDLP_H
#define __6STEP_CONF_SL_CM_SPDLP_H

#ifdef __cplusplus
extern "C" {
#endif

//#if ((SENSORS_LESS != 0) && (CURRENT_MODE != 0) && (SPEED_LOOP != 0))
/* Includes ------------------------------------------------------------------*/

/** @addtogroup MIDDLEWARES
  * @brief  Middlewares Layer
  * @{ 
  */
  
/** @addtogroup MC_6STEP_LIB
  * @{
  */
 
/** @defgroup MC_6STEP_CONF_SL_CM
  * @{
  */ 

/** @defgroup MC_6STEP_CONF_SL_CM_Exported_Defines
  * @{
  */

/* USER CODE BEGIN Config */

/*!< Motor characteristics */
#define MOTOR_NUM_POLE_PAIRS         ((uint8_t)  7)      /*!< Number of Motor Pole pairs */

/*!< Motor control alignment parameters */
#define ALIGNMENT_TIME               ((uint16_t) 500)    /*!< Time for alignment (msec) */
#define ALIGNMENT_STEP               ((uint8_t)  1)      /*!< Alignment is done to this step */
    
/*!< Motor control startup parameters */
#define STARTUP_SPEED_TARGET         ((uint16_t) 1200)   /*!< Target speed during startup (open loop) */
#define STARTUP_ACCELERATION         ((uint32_t) 1000)   /*!< Acceleration during startup in RPM/s */
#define STARTUP_SPEED_MINIMUM        ((uint16_t) 60)     /*!< Minimum speed in RPM for the first step */
#define STARTUP_PEAK_CURRENT         ((uint16_t) 1000)   /*!< Peak current in mA */
#define STARTUP_SENSE_RESISTOR       ((uint16_t) 10)     /*!< mOhms, (RS) */
#define STARTUP_SENSE_RES_VOLTAGE    ((uint16_t) ((STARTUP_PEAK_CURRENT*STARTUP_SENSE_RESISTOR)/1000)) /*!< mV */
#define STARTUP_SENSE_GAIN           ((uint16_t) 5600)   /*!< Thousandths, (RF/RB) */
#define STARTUP_SENSE_AMP_VOLTAGE    ((uint16_t) ((STARTUP_SENSE_RES_VOLTAGE*STARTUP_SENSE_GAIN)/1000)) /*!< mV */
#define STARTUP_REF_PWM_HIGH_VOLTAGE ((uint16_t) 3300)   /*!< mV, (VDD) */
#define STARTUP_REF_PWM_DIV_RATIO    ((uint16_t) 3200)   /*!< Thousandths, ((RD+RLP)/RD) */
#define STARTUP_OC_THRESHOLD         ((uint16_t) 500)    /*!< mV */
#define STARTUP_REF_PWM_VOLTAGE      ((uint16_t) (((2*STARTUP_OC_THRESHOLD-STARTUP_SENSE_AMP_VOLTAGE)*STARTUP_REF_PWM_DIV_RATIO)/1000)) /*!< mV */
#define STARTUP_DUTY_CYCLE           ((uint16_t) (1000-((STARTUP_REF_PWM_VOLTAGE*1000)/STARTUP_REF_PWM_HIGH_VOLTAGE))) /*!< PWM on time in thousandths of PWM period - HF timer in VOLTAGE_MODE, REF timer in CURRENT_MODE */
#define STARTUP_DIRECTION            ((uint8_t)  0)      /*!< Rotation direction in the motor, 0 for ClowkWise, 1 for CounterClockWise */
    
/*!< Motor control validation parameters */
#define VALIDATION_DEMAGN_DELAY      ((uint8_t)  4)      /*!< Demagnetization delay in number of HF timer periods elapsed before a first BEMF ADC measurement is processed in an attempt to detect the BEMF zero crossing */
#define VALIDATION_ZERO_CROSS_NUMBER ((uint8_t)  12)     /*!< Number of zero crossing event during the startup for closed loop control begin */
#define VALIDATION_BEMF_EVENTS_MAX   ((uint8_t)  100)    /*!< In open loop, maximum number of events where BEMF is over RUN_BEMF_THRESHOLD_DOWN during expected BEMF decrease */
#define VALIDATION_STEPS_MAX         ((uint16_t) 1000)   /*!< In open loop, maximum number of steps since MC_STARTUP beginning */
    
/*!< Motor control run parameters */
#define RUN_LF_TIMER_PRESCALER       ((uint8_t)  21)     /*!< LF timer prescaler value used in validation and run states */
#define RUN_BEMF_THRESHOLD_DOWN      ((uint8_t)  200)    /*!< BEMF voltage threshold for zero crossing detection when BEMF is expected to decrease */
#define RUN_BEMF_THRESHOLD_UP        ((uint8_t)  200)    /*!< BEMF voltage threshold for zero crossing detection when BEMF is expected to increase */
#define RUN_CONSEC_BEMF_DOWN_MAX     ((uint8_t)  10)     /*!< Maximum number of consecutive zero crossing detections during BEMF decrease */
#define RUN_ZCD_TO_COMM              ((uint16_t) 200)    /*!< Zero Crossing detection to commutation delay in 15/128 degrees */
#define RUN_CONTROL_LOOP_TIME        ((uint8_t)  4)      /*!< Periodicity in ms of the loop controlling the HF timer PWMs or the REF timer PWM */
#define RUN_SPEED_TARGET             ((uint32_t) 3000)   /*!< Target speed during run state */
#define RUN_DUTY_CYCLE               ((uint16_t) 100)    /*!< PWM on time in 1/1024 of PWM period - HF timer in VOLTAGE_MODE, REF timer in CURRENT_MODE */
#define RUN_ACCELERATION             ((uint32_t) 30000)  /*!< Acceleration during startup in 1000/1024 RPM/s or in 1/1024 of PWM period per control loop time */
#define RUN_SPEED_ARRAY_SHIFT        ((uint8_t)  5)      /*!< The size of the speed array is 2^RUN_SPEED_ARRAY_SHIFT */
#define RUN_DEMAGN_DELAY_MIN         ((uint8_t)  0)      /*!< Demagnetization delay in number of HF timer periods elapsed before a first BEMF ADC measurement is processed in an attempt to detect the BEMF zero crossing */
#define RUN_SPEED_THRESHOLD_DEMAG    ((uint32_t) 10500)  /*!< Speed threshold above which the RUN_DEMAGN_DELAY_MIN is applied */
#define RUN_DEMAG_TIME_STEP_RATIO    ((uint16_t) 270)    /*!< Tenths of percentage of step time allowed for demagnetization */
#define RUN_HF_TIMER_DUTY_CYCLE      ((uint16_t) 960)    /*!< PWM on time in thousandths of PWM period */
    
/*!< Motor control sensors less parameters */
#define ADC_BEMF_TRIG_TIME           ((uint16_t) 980)    /*!< Tenths of percentage of PWM period elapsed */
    
/*!< Motor control speed PID regulator parameter */
#define PID_KP                       ((uint16_t) 3000)   /*!< Kp parameter for the PID regulator */
#define PID_KI                       ((uint16_t) 8)      /*!< Ki parameter for the PID regulator */
#define PID_KD                       ((uint16_t) 0)      /*!< Kd parameter for the PID regulator */
#define PID_SCALING_SHIFT            ((uint16_t) 15)     /*!< Kp, Ki, Kd scaling for the PID regulator, from 0 to 15 */
#define PID_OUTPUT_MIN               ((uint16_t) 73)     /*!< Minimum output value of the PID regulator in tenths of percentage of the HF or REF timer period */
#define PID_OUTPUT_MAX               ((uint16_t) 722)    /*!< Maximum output value of the PID regulator in tenths of percentage of the HF or REF timer period */

/* USER CODE END Config */

/**
  * @} end MC_6STEP_CONF_SL_CM_Exported_Defines
  */ 

/**
  * @}  end MC_6STEP_CONF_SL_CM
  */ 

/**
  * @}  end MC_6STEP_LIB
  */

/**
  * @}  end MIDDLEWARES
  */
//#endif

#ifdef __cplusplus
}
#endif

#endif /* __6STEP_CONF_SL_CM_SPDLP_H */

/************************ (C) COPYRIGHT STMicroelectronics *****END OF FILE****/