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
 * @file    Motor_Configuration.h
 * @author  IPC Rennes & Motor Control SDK, ST Microelectronics
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
#ifndef __MOTOR_CONF_H
#define __MOTOR_CONF_H

#ifdef __cplusplus
extern "C" {
#endif

/* Includes ------------------------------------------------------------------*/

/** @addtogroup MIDDLEWARES
  * @brief  Middlewares Layer
  * @{ 
  */
  
/** @addtogroup MC_LIB_6STEP
  * @{
  */
 
/** @defgroup MC_6STEP_CONF
  * @{
  */ 

/** @defgroup MC_6STEP_CONF_Exported_Defines
  * @{
  */
/*!< Manage the Motor and its related configuration */
<#if MC.MOTOR_REF == "GBM2804H-100T"><#-- GIMBAL motor-->
/*!< Gimball (GBM2804H-100T) Motor characteristics */
#define MOTOR_NUM_POLE_PAIRS         ((uint8_t)  7)      /*!< Number of Motor Pole pairs */

/*!< Motor control alignment parameters */
#define ALIGNMENT_TIME               ((uint16_t) 500)    /*!< Time for alignment (msec) */
	<#if MC.SIX_STEP_SENSING == "SENSORS_LESS"><#-- Sensorless usage -->
#define ALIGNMENT_STEP               ((uint8_t)  1)      /*!< Alignment is done to this step */
	</#if>
    
/*!< Motor control startup parameters */
	<#if MC.SIX_STEP_SENSING == "SENSORS_LESS" || MC.SIX_STEP_SPEED_LOOP == true ><#-- Sensorless usage -->
#define STARTUP_SPEED_TARGET         ((uint16_t) 150)    /*!< Target speed during startup (open loop) [usually 7% of nominal speed] */
	</#if>
	<#if MC.SIX_STEP_SENSING == "SENSORS_LESS"><#-- Sensorless usage -->
#define STARTUP_ACCELERATION         ((uint32_t) 1000)   /*!< Acceleration during startup in RPM/s */
#define STARTUP_SPEED_MINIMUM        ((uint16_t) 60)     /*!< Minimum speed in RPM for the first step */
	</#if>
	<#if MC.SIX_STEP_CONTROL_MODE == "VOLTAGE"><#-- Voltage Control mode usage -->
#define STARTUP_DUTY_CYCLE           ((uint16_t) 150)    /*!< PWM on time 1/1024 of PWM period - HF timer in VOLTAGE_MODE, REF timer in CURRENT_MODE */
	</#if>
	<#if MC.SIX_STEP_CONTROL_MODE == "CURRENT"><#-- Current Control mode usage -->
#define STARTUP_PEAK_CURRENT         ((uint16_t) 100)    /*!< Peak current in mA */
#define STARTUP_SENSE_RESISTOR       ((uint16_t) 10)     /*!< mOhms, (RS) */
#define STARTUP_SENSE_RES_VOLTAGE    ((uint16_t) ((STARTUP_PEAK_CURRENT*STARTUP_SENSE_RESISTOR)/1000)) /*!< mV */
#define STARTUP_SENSE_GAIN           ((uint16_t) 5600)   /*!< Thousandths, (RF/RB) */
#define STARTUP_SENSE_AMP_VOLTAGE    ((uint16_t) ((STARTUP_SENSE_RES_VOLTAGE*STARTUP_SENSE_GAIN)/1000)) /*!< mV */
#define STARTUP_REF_PWM_HIGH_VOLTAGE ((uint16_t) 3300)   /*!< mV, (VDD) */
#define STARTUP_REF_PWM_DIV_RATIO    ((uint16_t) 3200)   /*!< Thousandths, ((RD+RLP)/RD) */
#define STARTUP_OC_THRESHOLD         ((uint16_t) 500)    /*!< mV */
#define STARTUP_REF_PWM_VOLTAGE      ((uint16_t) (((2*STARTUP_OC_THRESHOLD-STARTUP_SENSE_AMP_VOLTAGE)*STARTUP_REF_PWM_DIV_RATIO)/1000)) /*!< mV */
#define STARTUP_DUTY_CYCLE           ((uint16_t) (1000-((STARTUP_REF_PWM_VOLTAGE*1000)/STARTUP_REF_PWM_HIGH_VOLTAGE))) /*!< PWM on time in 1/1024 of PWM period - HF timer in VOLTAGE_MODE, REF timer in CURRENT_MODE */
	</#if>
#define STARTUP_DIRECTION            ((uint8_t)  0)      /*!< Rotation direction in the motor, 0 for ClockWise, 1 for CounterClockWise */
    
/*!< Motor control validation parameters */
	<#if MC.SIX_STEP_SENSING == "SENSORS_LESS"><#-- Sensorless usage -->
#define VALIDATION_DEMAGN_DELAY      ((uint8_t)  4)      /*!< Demagnetization delay in number of HF timer periods elapsed before a first BEMF ADC measurement is processed in an attempt to detect the BEMF zero crossing */
#define VALIDATION_ZERO_CROSS_NUMBER ((uint8_t)  12)     /*!< Number of zero crossing event during the startup for closed loop control begin */
#define VALIDATION_BEMF_EVENTS_MAX   ((uint8_t)  100)    /*!< In open loop, maximum number of events where BEMF is over RUN_BEMF_THRESHOLD_DOWN during expected BEMF decrease */
#define VALIDATION_STEPS_MAX         ((uint16_t) 1000)   /*!< In open loop, maximum number of steps since MC_STARTUP beginning */
	</#if>
	<#if MC.SIX_STEP_SENSING == "HALL_SENSORS"><#-- Hall Sensors usage -->
#define VALIDATION_HALL_STATUS_DIRECT0_STEP1 ((uint8_t)  2) 
#define VALIDATION_HALL_STATUS_DIRECT0_STEP2 ((uint8_t)  3)
#define VALIDATION_HALL_STATUS_DIRECT0_STEP3 ((uint8_t)  1)
#define VALIDATION_HALL_STATUS_DIRECT0_STEP4 ((uint8_t)  5)
#define VALIDATION_HALL_STATUS_DIRECT0_STEP5 ((uint8_t)  4)
#define VALIDATION_HALL_STATUS_DIRECT0_STEP6 ((uint8_t)  6)
#define VALIDATION_HALL_STATUS_DIRECT1_STEP1 ((uint8_t)  5)
#define VALIDATION_HALL_STATUS_DIRECT1_STEP2 ((uint8_t)  4)
#define VALIDATION_HALL_STATUS_DIRECT1_STEP3 ((uint8_t)  6)
#define VALIDATION_HALL_STATUS_DIRECT1_STEP4 ((uint8_t)  2)
#define VALIDATION_HALL_STATUS_DIRECT1_STEP5 ((uint8_t)  3)
#define VALIDATION_HALL_STATUS_DIRECT1_STEP6 ((uint8_t)  1)
	</#if>
    
    
/*!< Motor control run parameters */
	<#if MC.SIX_STEP_SENSING == "HALL_SENSORS"><#-- Hall Sensors usage -->
#define RUN_HALL_INPUTS_FILTER       ((uint8_t) 8)
#define RUN_COMMUTATION_DELAY        ((uint16_t) 2)     /*!< delay between a hall sensors status change and a step commutation with an LF timer counter resolution */
	</#if>
	<#if MC.SIX_STEP_SENSING == "SENSORS_LESS"><#-- SensorLess usage -->
#define RUN_LF_TIMER_PRESCALER       ((uint8_t)  21)     /*!< LF timer prescaler value used in validation and run states */
#define RUN_BEMF_THRESHOLD_DOWN      ((uint16_t) 200)    /*!< BEMF voltage threshold for zero crossing detection when BEMF is expected to decrease */
#define RUN_BEMF_THRESHOLD_UP        ((uint16_t) 200)    /*!< BEMF voltage threshold for zero crossing detection when BEMF is expected to increase */
		<#if MC.SIX_STEP_CONTROL_MODE == "VOLTAGE"><#-- Voltage Control mode usage -->
/* PWM ON sensing BEGIN 1 */
#define RUN_BEMF_THRESHOLD_DOWN_ON   ((uint16_t) 1600)   /*!< BEMF voltage threshold during PWM ON time for zero crossing detection when BEMF is expected to decrease */
			<#if MC.SIX_STEP_SPEED_LOOP == true><#-- Speed Loop usage -->
#define RUN_BEMF_THRESHOLD_UP_ON     ((uint16_t) 1200)   /*!< BEMF voltage threshold during PWM ON time for zero crossing detection when BEMF is expected to increase */
			<#else>
#define RUN_BEMF_THRESHOLD_UP_ON     ((uint16_t) 600)    /*!< BEMF voltage threshold during PWM ON time for zero crossing detection when BEMF is expected to increase */
			</#if>
/* PWM ON sensing END 1 */
		</#if>
#define RUN_CONSEC_BEMF_DOWN_MAX     ((uint8_t)  10)     /*!< Maximum number of consecutive zero crossing detections during BEMF decrease */
#define RUN_ZCD_TO_COMM              ((uint16_t) 200)    /*!< Zero Crossing detection to commutation delay in 15/128 degrees */
	</#if>
	<#if MC.SIX_STEP_SPEED_LOOP == true><#-- Speed Loop usage -->
#define RUN_CONTROL_LOOP_TIME        ((uint8_t)  4)      /*!< Periodicity in ms of the loop controlling the HF timer PWMs or the REF timer PWM */
	<#else>
#define RUN_CONTROL_LOOP_TIME        ((uint8_t)  20)     /*!< Periodicity in ms of the loop controlling the HF timer PWMs or the REF timer PWM */
	</#if>
	<#if MC.SIX_STEP_CONTROL_MODE == "VOLTAGE"><#-- Voltage Control mode usage -->
#define RUN_SPEED_TARGET             ((uint32_t) ${MC.DEFAULT_TARGET_SPEED_RPM})   /*!< Target speed during run state */
#define RUN_DUTY_CYCLE               ((uint16_t) 150)    /*!< PWM on time in 1/1024 of PWM period - HF timer in VOLTAGE_MODE, REF timer in CURRENT_MODE */
	</#if>
	<#if MC.SIX_STEP_CONTROL_MODE == "CURRENT"><#-- Current Control mode usage -->
		<#if MC.SIX_STEP_SPEED_LOOP == true><#-- Speed Loop usage -->
#define RUN_SPEED_TARGET             ((uint32_t) 6000)   /*!< Target speed during run state */
		</#if>
#define RUN_DUTY_CYCLE               ((uint16_t) 50)     /*!< PWM on time in 1/1024 of PWM period - HF timer in VOLTAGE_MODE, REF timer in CURRENT_MODE */
	</#if>
	<#if MC.SIX_STEP_SPEED_LOOP == true><#-- Speed Loop usage -->
#define RUN_ACCELERATION             ((uint32_t) 1000)   /*!< Acceleration during startup in 1000/1024 RPM/s or in 1/1024 of PWM period per control loop time */
	<#else>
#define RUN_ACCELERATION             ((uint32_t) 20)     /*!< Acceleration during startup in 1000/1024 RPM/s or in 1/1024 of PWM period per control loop time */
	</#if>
#define RUN_SPEED_ARRAY_SHIFT        ((uint8_t)  5)      /*!< The size of the speed array is 2^RUN_SPEED_ARRAY_SHIFT */
	<#if MC.SIX_STEP_SENSING == "SENSORS_LESS"><#-- SensorLess usage -->
#define RUN_DEMAGN_DELAY_MIN         ((uint8_t)  0)      /*!< Demagnetization delay in number of HF timer periods elapsed before a first BEMF ADC measurement is processed in an attempt to detect the BEMF zero crossing */
#define RUN_SPEED_THRESHOLD_DEMAG    ((uint32_t) 1050)   /*!< Speed threshold above which the RUN_DEMAGN_DELAY_MIN is applied */
#define RUN_DEMAG_TIME_STEP_RATIO    ((uint16_t) 270)    /*!< Tenths of percentage of step time allowed for demagnetization */
	</#if>
	<#if MC.SIX_STEP_CONTROL_MODE == "CURRENT"><#-- Current Control mode usage -->
#define RUN_HF_TIMER_DUTY_CYCLE      ((uint16_t) 960)    /*!< PWM on time in 1/1024 of PWM period elapsed */

/*!< Motor control sensors less parameters */
#define BEMF_ADC_TRIG_TIME           ((uint16_t) 1003)   /*!< 1/1024 of PWM period elapsed */
	</#if>
	<#if MC.SIX_STEP_CONTROL_MODE == "VOLTAGE"><#-- Voltage Control mode usage -->
/*!< Motor control sensors less parameters */
#define BEMF_ADC_TRIG_TIME           ((uint16_t) 800)    /*!< 1/1024 of PWM period elapsed */

/* PWM ON sensing BEGIN 2 */
#define BEMF_ADC_TRIG_TIME_PWM_ON    ((uint16_t) 200)    /*!< 1/1024 of PWM period elapsed */
#define BEMF_PWM_ON_ENABLE_THRES     ((uint16_t) 640)    /*!< 1/1024 of PWM period elapsed */
#define BEMF_PWM_ON_DISABLE_THRES    ((uint16_t) 430)    /*!< 1/1024 of PWM period elapsed */
/* PWM ON sensing END 2 */
	</#if>

/*!< User misceallenous parameters */
#define USER_ADC_TRIG_TIME           BEMF_ADC_TRIG_TIME  /*!< 1/1024 of PWM period elapsed */
    
	<#if MC.SIX_STEP_SPEED_LOOP == true><#-- Speed Loop usage -->
/*!< Motor control speed PID regulator parameter */
		<#if MC.SIX_STEP_CONTROL_MODE == "VOLTAGE"><#-- Voltage Control mode usage -->
#define PID_OUTPUT_MIN               ((uint16_t) 130)    /*!< Minimum output value of the PID regulator in tenths of percentage of the HF or REF timer period */
#define PID_OUTPUT_MAX               ((uint16_t) 1000)   /*!< Maximum output value of the PID regulator in tenths of percentage of the HF or REF timer period */
#define PID_KP                       ((uint16_t) ${MC.PID_SPEED_KP_DEFAULT})   /*!< Kp parameter for the PID regulator */
		</#if>
		<#if MC.SIX_STEP_CONTROL_MODE == "CURRENT"><#-- Current Control mode usage -->
#define PID_OUTPUT_MIN               ((uint16_t) 2)      /*!< Minimum output value of the PID regulator in tenths of percentage of the HF or REF timer period */
#define PID_OUTPUT_MAX               ((uint16_t) 350)    /*!< Maximum output value of the PID regulator in tenths of percentage of the HF or REF timer period */
#define PID_KP                       ((uint16_t) ${MC.PID_SPEED_KP_DEFAULT})    /*!< Kp parameter for the PID regulator */
		</#if>
#define PID_KI                       ((uint16_t) ${MC.PID_SPEED_KI_DEFAULT})      /*!< Ki parameter for the PID regulator */
#define PID_KD                       ((uint16_t) ${MC.PID_SPEED_KD_DEFAULT})      /*!< Kd parameter for the PID regulator */
#define PID_SCALING_SHIFT            ((uint16_t) ${MC.SP_KPDIV})     /*!< Kp, Ki, Kd scaling for the PID regulator, from 0 to 15 */
	</#if>
<#else>
  #error "This motor is not supported for 6-Steps"
</#if>


/**
  * @} end MC_6STEP_CONF_Exported_Defines
  */

/**
  * @}  end MC_6STEP_CONF
  */ 

/**
  * @}  end MC_LIB_6STEP
  */

/**
  * @}  end MIDDLEWARES
  */

#ifdef __cplusplus
}
#endif

#endif /* __MOTOR_CONF_H */

/************************ (C) COPYRIGHT STMicroelectronics *****END OF FILE****/