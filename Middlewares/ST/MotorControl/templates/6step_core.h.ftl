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
 * @file    6step_core.h
 * @author  IPC Rennes & Motor Control SDK, ST Microelectronics
 * @brief   Header file for 6step_core.c file
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
#ifndef __6STEP_CORE_H
#define __6STEP_CORE_H

#ifdef __cplusplus
extern "C" {
#endif

/* Includes ------------------------------------------------------------------*/
#include "6step_conf.h"
#include "6step_def.h"
#include "6step_com.h"

/** @addtogroup MIDDLEWARES
  * @brief  Middlewares Layer
  * @{ 
  */
  
/** @addtogroup MC_LIB_6STEP
  * @{
  */

/** @addtogroup MC_6STEP_CORE
  * @{
  */ 

/** @defgroup MC_6STEP_CORE_Exported_Defines
  * @{
  */
#define MC_DUTY_CYCLE_SCALING_SHIFT       ((uint8_t)  10)
#define MC_LF_TIMER_MAX_PERIOD            ((uint16_t) 0xFFFF)
#define MC_SPEED_ARRAY_SIZE               ((uint8_t) (1<<RUN_SPEED_ARRAY_SHIFT))
#define NUMBER_OF_USER_ADC_CHANNELS       ((uint8_t)  5)
  
/**
  * @}
  */
  
/** @defgroup MC_6STEP_CORE_Exported_Types
  * @{
  */

/*!< Motor Control status */
typedef enum {
  MC_IDLE = ((uint8_t) 0),
  MC_STOP,
  MC_ALIGNMENT,
  MC_STARTUP,
  MC_VALIDATION,
  MC_RUN,
  MC_SPEEDFBKERROR,
  MC_OVERCURRENT,
  MC_VALIDATION_FAILURE,
  MC_VALIDATION_BEMF_FAILURE,
  MC_VALIDATION_HALL_FAILURE,
  MC_LF_TIMER_FAILURE,
  MC_ADC_CALLBACK_FAILURE
}MC_Status_t;

/*!< Bemf channels */
typedef enum {
  MC_BEMF_PHASE_1   = ((uint8_t) 0),
  MC_BEMF_PHASE_2   = ((uint8_t) 1),
  MC_BEMF_PHASE_3   = ((uint8_t) 2)
}MC_BemfPhases_t;

/*!< User measurements */
typedef enum {
  MC_USER_MEAS_1    = ((uint8_t) 0),
  MC_USER_MEAS_2    = ((uint8_t) 1),
  MC_USER_MEAS_3    = ((uint8_t) 2),
  MC_USER_MEAS_4    = ((uint8_t) 3),
  MC_USER_MEAS_5    = ((uint8_t) 4)
}MC_UserMeasurements_t;

/*!< Structure for USER ADC measurements */
typedef struct
{
  uint8_t channel_index;                               /*!< Index of the array of ADC regular channels for USER measurements */
  int8_t ts_cal_1_temp_deg_c;
  int8_t ts_cal_2_temp_deg_c;
  uint16_t measurement[NUMBER_OF_USER_ADC_CHANNELS];   /*!< Array of ADC USER measurements: potentiometer, current, vbus, temperature */
  uint16_t trig_time;                                  /*!< Pulse value of the timer channel used to trig the ADC */
  uint16_t trig_timer_period;                          /*!< Period value of the timer used to trig the ADC */
  uint16_t ts_cal_1;
  uint16_t ts_cal_2;
  uint16_t vrefint_cal;
  uint32_t channel[NUMBER_OF_USER_ADC_CHANNELS];       /*!< Array of ADC regular channels used for USER measurements: potentiometer, current, vbus, temperature */  
  uint32_t sampling_time[NUMBER_OF_USER_ADC_CHANNELS]; /*!< Array of ADC USER measurements sampling rates */
  uint32_t trig_timer_channel;                         /*!< Channel of the timer used to trig the ADCs > */
  uint32_t* padc[NUMBER_OF_USER_ADC_CHANNELS];         /*!< Array of pointer to the ADC used for a USER measurement */
  uint32_t* ptrig_timer;                               /*!< Pointer to the timer used to trig the ADCs > */  
} MC_AdcUser_t;

/*!< Structure for USER BUTTON */
typedef struct
{
  uint8_t enabled;
  uint16_t gpio_pin;
  uint16_t debounce_time_ms;
} MC_ButtonUser_t;

<#if MC.SIX_STEP_SENSING == "SENSORS_LESS"><#-- Sensorless usage -->
/*!< Structure for BEMF ADC measurements */
typedef struct
{
  uint8_t over_threshold_events;
  /* PWM ON sensing BEGIN 1 */
  uint8_t pwm_on_sensing_enabled;    /*!< Value where 0 means BEMF is sensed during PWM OFF time and 1 or greater means BEMF is sensed during PWM ON time >*/  
  /* PWM ON sensing END 1 */
  uint8_t zero_crossing_events;
  uint16_t adc_threshold_down;        /*!< BEMF voltage threshold for zero crossing detection when BEMF is decreasing */
  uint16_t adc_threshold_up;          /*!< BEMF voltage threshold for zero crossing detection when BEMF is increasing */  
  uint16_t consecutive_down_counter;  /*!< Consecutive zero crossing detections during BEMF decrease */
  uint16_t demagn_counter;            /*!< Demagnetization counter */
  uint16_t demagn_value;              /*!< Demagnetization value */
  /* PWM ON sensing BEGIN 2 */
  uint16_t pwm_off_sensing_trig_time; /*!< Pulse value of the timer channel used to trig the ADC when sensing occurs during PWM OFF time */
  uint16_t pwm_on_sensing_en_thres;   /*!< Pulse value of HF timer above which the PWM ON sensing is enabled */
  uint16_t pwm_on_sensing_dis_thres;  /*!< Pulse value of HF timer below which the PWM ON sensing is disabled */
  uint16_t pwm_on_sensing_trig_time;  /*!< Pulse value of the timer channel used to trig the ADC when sensing occurs during PWM ON time */
  /* PWM ON sensing END 2 */
  uint16_t trig_time;                 /*!< Current pulse value of the timer channel used to trig the ADC */
  uint16_t trig_timer_period;         /*!< Period value of the timer used to trig the ADC */
  uint16_t zcd_to_comm;               /*!< Zero Crossing detection to commutation delay in 15/128 degrees */
  uint32_t* ptrig_timer;              /*!< Pointer to the timer used to trig the ADC */
  uint32_t adc_channel[3];            /*!< Array of ADC regular channels used for BEMF sensing */
  uint32_t current_adc_channel;       /*!< ADC regular channel to select for BEMF sensing */
  uint32_t demagn_coefficient;        /*!< Proportional parameter to compute the number of HF TIMER periods before checking BEMF threshold */
  uint32_t run_speed_thres_demag;     /*!< Speed threshold above which the RUN_DEMAGN_DELAY_MIN is applied */
  uint32_t sampling_time;             /*!< Sampling time value */
  uint32_t trig_timer_channel;        /*!< Channel of the HF timer used to trig the ADC */  
  uint32_t* padc;                     /*!< Pointer to the ADC */
} MC_Bemf_t;
</#if>

<#if MC.SIX_STEP_SENSING == "HALL_SENSORS"><#-- Hall sensors usage -->
/*!< Structure for HALL sensors */
typedef struct
{
  uint8_t ok;                         /*!< This value is interpreted as a boolean used to check that an input capture occured */
  uint8_t status;                     /*!< Agregate value of the digital hall sensors where one hall output is set as MSB, another one is set as middle bit and the last as LSB */
  uint16_t commutation_delay;         /*!< Delay between hall capture and step commutation */
} MC_Hall_t;
</#if>

<#if MC.SIX_STEP_SPEED_LOOP == true><#-- Speed Loop usage -->
/*!< Motor Control PID regulator structure */
typedef struct
{
  uint16_t kp;                    /*!< Proportional gain for PID regulator */
  uint16_t ki;                    /*!< Integral gain for PID regulator */
  uint32_t kd;                    /*!< Derivative gain for PID regulator */
  uint16_t scaling_shift;         /*!< Scaling of the gains of the PID regulator */
  int32_t integral_term_sum;      /*!< Integral term sum of the PID regulator */
  uint32_t previous_speed;        /*!< Previous speed fed into the PID regulator */
  int16_t minimum_output;         /*!< Min output value for PID regulator */ 
  uint16_t maximum_output;        /*!< Max output value for PID regulator */
} MC_Pid_t;
</#if>

/*!< Motor Characteristics structure */
typedef struct
{
  uint8_t pole_pairs;             /*!< Number of motor pole pairs  */
} MC_MotorCharacteristics_t;
    
/*!< Motor Control handle structure */
typedef struct
{
  uint8_t id;                               /*!< Motor Control device id */
  MC_Status_t status;                       /*!< Motor Control device status */
  uint8_t control_loop_time;                /*!< Periodicity in ms of the loop controlling the HF timer PWMs */
  uint8_t direction;                        /*!< Motor direction CW:0 CCW:1 */
  uint8_t lf_timer_period_array_completed;  /*!< Completion of LF timer period array Completed: 1 Not completed: 0 */
  uint8_t lf_timer_period_array_index;      /*!< Index of LF timer period array */
  uint8_t reference_to_be_updated;          /*!< Different from 0 if the reference has to be updated */
<#if MC.SIX_STEP_SENSING == "SENSORS_LESS"><#-- Sensorless usage -->
  uint8_t step_change;                      /*!< SL : Step has been changed and ADC callback has not been called yet when not 0 */
</#if>
  uint8_t step_pos_next;                    /*!< Next step number for the 6-step algorithm */
  uint8_t step_position;                    /*!< Current step number for the 6-step algorithm */   
  uint8_t step_prepared;                    /*!< Step configuration for the 6-step algorithm Prepared: 1 Not prepared: 0 */
  uint8_t tick_cnt;                         /*!< Counter value to be check against the control loop time to control the speed or the duty cycle */
  uint16_t align_index;                     /*!< Index indicating the time elapsed in ms in MC_ALIGNMENT state */
  uint16_t alignment_time;                  /*!< Time for alignment (msec) */  
  uint16_t hf_timer_period;                 /*!< Period of the HF timer in clock cycles */
<#if MC.SIX_STEP_CONTROL_MODE == "CURRENT"><#-- Current Control mode usage -->
  uint16_t hf_timer_pulse_value_max;        /*!< CM : Maximum HF timer pulse value in clock cycles */
</#if>
  uint16_t lf_timer_period;                 /*!< Period of the LF timer in clock cycles */
  uint16_t lf_timer_period_array[MC_SPEED_ARRAY_SIZE]; /*!< LF timer period array */  
  uint16_t lf_timer_prescaler;              /*!< Prescaler of the LF timer in clock cycles */
  uint16_t pulse_command;                   /*!< To be set HF or REF timer pulse value in clock cycles */
  uint16_t pulse_value;                     /*!< Current HF or REF timer pulse value in clock cycles */
  uint16_t ref_timer_period;                /*!< Period of the REF timer in clock cycles */    
  uint16_t startup_reference;               /*!< Startup value for pulse value or current reference */
  uint32_t* phf_timer;                      /*!< Pointer to the HF timer > */
  uint32_t* plf_timer;                      /*!< Pointer to the LF timer > */
  uint32_t* pref_timer;                     /*!< Pointer to the REF timer > */
  uint32_t acceleration;                    /*!< Motor acceleration in rpm/s or update rate of the pulse value of HF or REF timer */
  uint32_t gate_driver_frequency;           /*!< Frequency in Hz of the HF timer pwm used to drive the transistor gates on each motor phases */
  uint32_t speed_target_value;              /*!< In rpm, speed target value updated periodically to reach the speed target command */
  uint32_t speed_fdbk_filtered;             /*!< Motor filtered speed variable in rpm */
  uint32_t speed_target_command;            /*!< In rpm, speed target command */
  uint32_t steps;                           /*!< Number of steps since MC_STARTUP until MC_RUN */
  uint32_t uw_tick_cnt;
  MC_MotorCharacteristics_t motor_charac;   /*!< Motor characteristics */
<#if MC.SIX_STEP_SENSING == "SENSORS_LESS"><#-- Sensorless usage -->
  MC_Bemf_t bemf;                           /*!< SL */
</#if>
<#if MC.SIX_STEP_SENSING == "HALL_SENSORS"><#-- Hall Sensors usage -->
  MC_Hall_t hall;                           /*!< HS */
</#if>
<#if MC.SIX_STEP_SPEED_LOOP == true><#-- Speed Loop usage -->
  MC_Pid_t pid_parameters;                  /*!< SPDLP */
</#if>
  MC_AdcUser_t adc_user;
  MC_ButtonUser_t button_user;
} MC_Handle_t;
/**
  * @} end MC_6STEP_CORE_Exported_Types
  */

/** @defgroup MC_6STEP_CORE_Exported_Functions_Prototypes
  * @{
  */
MC_FuncStatus_t MC_Core_AssignTimers(MC_Handle_t *pMc, uint32_t *pHfTimer, uint32_t *pLfTimer, uint32_t *pRefTimer);
<#if MC.SIX_STEP_SENSING == "SENSORS_LESS"><#-- Sensorless usage -->
MC_FuncStatus_t MC_Core_ConfigureBemfAdc(MC_Handle_t* pMc, uint32_t * pAdc, uint32_t *pTrigTimer, uint16_t TrigTimerChannel);
MC_FuncStatus_t MC_Core_ConfigureBemfAdcChannel(MC_Handle_t* pMc, uint32_t AdcChannel, uint32_t SamplingTime, MC_BemfPhases_t BemfPhase);
</#if>
<#if MC.SIX_STEP_SENSING == "HALL_SENSORS"><#-- Hall Sensors usage -->
MC_FuncStatus_t MC_Core_HallStatusToStep(MC_Handle_t *pMc);
</#if>
MC_FuncStatus_t MC_Core_ConfigureUserAdc(MC_Handle_t* pMc, uint32_t *pTrigTimer, uint16_t TrigTimerChannel);
MC_FuncStatus_t MC_Core_ConfigureUserAdcChannel(MC_Handle_t* pMc, uint32_t* pAdc, uint32_t AdcChannel, uint32_t SamplingTime, MC_UserMeasurements_t UserMeasurement);
MC_FuncStatus_t MC_Core_ConfigureUserButton(MC_Handle_t* pMc, uint16_t ButtonPin, uint16_t ButtonDebounceTimeMs);
MC_FuncStatus_t MC_Core_Init(MC_Handle_t *pMc);
MC_FuncStatus_t MC_Core_LfTimerPeriodCompute(MC_Handle_t* pMc, uint16_t CounterSnaphot, uint8_t BemfIsIncreasing);
MC_FuncStatus_t MC_Core_MediumFrequencyTask(MC_Handle_t *pMc);
MC_FuncStatus_t MC_Core_PrepareNextStep(MC_Handle_t* pMc);
MC_FuncStatus_t MC_Core_RampCalc(MC_Handle_t* pMc);
<#if MC.SIX_STEP_SENSING == "SENSORS_LESS"><#-- Sensorless usage -->
MC_FuncStatus_t MC_Core_SetAdcBemfTrigTime(MC_Handle_t* pMc, uint32_t DutyCycleToSet);
</#if>
MC_FuncStatus_t MC_Core_SetAdcUserTrigTime(MC_Handle_t* pMc, uint32_t DutyCycleToSet);
MC_FuncStatus_t MC_Core_SetDirection(MC_Handle_t* pMc, uint32_t DirectionToSet);
MC_FuncStatus_t MC_Core_SetDutyCycle(MC_Handle_t* pMc, uint32_t DutyCycleToSet);
MC_FuncStatus_t MC_Core_SetGateDriverPwmFreq(MC_Handle_t* pMc, uint32_t FrequencyHzToSet);
MC_FuncStatus_t MC_Core_SetStartupDutyCycle(MC_Handle_t* pMc, uint32_t DutyCycleToSet);
MC_FuncStatus_t MC_Core_SetSpeed(MC_Handle_t *pMc, uint32_t SpeedToSet);
uint32_t MC_Core_GetGateDriverPwmFreq(MC_Handle_t* pMc);
MC_Handle_t* MC_Core_GetMotorControlHandle(uint8_t MotorDeviceId);
uint32_t MC_Core_GetSpeed(MC_Handle_t* pMc);
MC_Status_t MC_Core_GetStatus(MC_Handle_t* pMc);
MC_FuncStatus_t  MC_Core_ProcessAdcMeasurement(MC_Handle_t* pMc, uint32_t* pAdc, uint16_t LfTimerCounterSnapshot, uint16_t AdcMeasurement);
MC_FuncStatus_t MC_Core_Reset(MC_Handle_t *pMc);
MC_FuncStatus_t MC_Core_SpeedFeedbackReset(MC_Handle_t *pMc);
MC_FuncStatus_t MC_Core_Start(MC_Handle_t *pMc);
MC_FuncStatus_t MC_Core_Stop(MC_Handle_t *pMc);
<#if MC.SIX_STEP_SENSING == "SENSORS_LESS"><#-- Sensorless usage -->
MC_FuncStatus_t MC_Core_NextStep(MC_Handle_t *pMc, uint16_t HfTimerCounterSnapshot);
</#if>
<#if MC.SIX_STEP_SENSING == "HALL_SENSORS"><#-- Hall Sensors usage -->
MC_FuncStatus_t MC_Core_NextStepScheduling(MC_Handle_t *pMc);
</#if>
/**
  * @} end MC_6STEP_CORE_Exported_Functions_Prototypes
  */ 

/** @defgroup MC_6STEP_CORE_Exported_LL_Functions_Prototypes
  * @{
  */
void MC_Core_LL_EnableChannelsHfPwmsStep14(uint32_t *pHfTimer);
void MC_Core_LL_EnableChannelsHfPwmsStep25(uint32_t *pHfTimer);
void MC_Core_LL_EnableChannelsHfPwmsStep36(uint32_t *pHfTimer);
void MC_Core_LL_CalibrateAdc(uint32_t *pAdc);
void MC_Core_LL_ConfigureCommutationEvent(uint32_t *pHfTimer, uint32_t *pLfTimer);
void MC_Core_LL_DisableIrq(void);
void MC_Core_LL_DisableUpdateEvent(uint32_t *pHfTimer);
void MC_Core_LL_EnableInputsHfPwmsStep14(uint8_t MotorDeviceId);
void MC_Core_LL_EnableInputsHfPwmsStep25(uint8_t MotorDeviceId);
void MC_Core_LL_EnableInputsHfPwmsStep36(uint8_t MotorDeviceId);
void MC_Core_LL_EnableIrq(void);
void MC_Core_LL_EnableUpdateEvent(uint32_t *pHfTimer);
void MC_Core_LL_Error(MC_Handle_t *pMc);
void MC_Core_LL_GenerateComEvent(uint32_t *pHfTimer);
void MC_Core_LL_GenerateUpdateEvent(uint32_t *pTimer);
uint32_t MC_Core_LL_GetGateDrivingPwmFrequency(uint32_t *pHfTimer);
<#if MC.SIX_STEP_SENSING == "HALL_SENSORS"><#-- Hall sensors usage -->
void MC_Core_LL_GetHallStatus(MC_Handle_t *pMc);
uint16_t MC_Core_LL_GetTimerCaptureCompare(uint32_t *pTimer);
uint16_t MC_Core_LL_GetTimerCounter(uint32_t *pTimer);
</#if>
uint16_t MC_Core_LL_GetTimerPeriod(uint32_t *pTimer);
uint16_t MC_Core_LL_GetTimerPrescaler(uint32_t *pTimer);
uint32_t MC_Core_LL_GetSysClockFrequency(void);
void MC_Core_LL_GetTemperatureCalibrationData(MC_Handle_t *pMc);
<#if MC.SIX_STEP_CONTROL_MODE == "VOLTAGE"><#-- Voltage Control mode usage -->
void MC_Core_LL_ResetBemfGpio(uint8_t MotorDeviceId);
void MC_Core_LL_SetBemfGpio(uint8_t MotorDeviceId);
</#if>
void MC_Core_LL_SelectAdcChannel(uint32_t *pAdcItToBeDisabled, uint32_t *pAdcItToBeEnabled, uint32_t AdcChannel, uint32_t SamplingTime);
void MC_Core_LL_SelectAdcChannelDuringCallback(uint32_t *pAdcItToBeDisabled, uint32_t *pAdcItToBeEnabled, uint32_t AdcChannel, uint32_t SamplingTime);
void MC_Core_LL_SetAdcSamplingTime(uint32_t *pAdc, uint32_t AdcChannel, uint32_t SamplingTime);
<#if MC.SIX_STEP_SENSING == "HALL_SENSORS"><#-- Hall sensors usage -->
void MC_Core_LL_SetCompareHallTimer(uint32_t *pHallTimer, uint16_t CommutationDelay);
</#if>
void MC_Core_LL_SetDutyCyclePwmForAdcTrig(uint32_t *pTimer, uint32_t Channel, uint16_t PulseValue);
void MC_Core_LL_SetDutyCycleHfPwmForStepN(uint32_t *pHfTimer, uint16_t PulseValue, uint8_t StepNumber);
void MC_Core_LL_SetDutyCycleHfPwms(uint32_t *pHfTimer, uint16_t PulseValue1, uint16_t PulseValue2, uint16_t PulseValue3);
void MC_Core_LL_SetDutyCycleHfPwmU(uint32_t *pHfTimer, uint16_t PulseValue);
void MC_Core_LL_SetDutyCycleHfPwmV(uint32_t *pHfTimer, uint16_t PulseValue);
void MC_Core_LL_SetDutyCycleHfPwmW(uint32_t *pHfTimer, uint16_t PulseValue);
void MC_Core_LL_SetDutyCycleRefPwm(uint32_t *pRefTimer, uint16_t PulseValue);
void MC_Core_LL_SetPeriodTimer(uint32_t *pTimer, uint16_t PeriodValue);
void MC_Core_LL_SetPrescalerTimer(uint32_t *pTimer, uint16_t PrescalerValue);
void MC_Core_LL_StartAdcIt(uint32_t *pAdc);
void MC_Core_LL_StartHfPwms(uint32_t *pHfTimer);
void MC_Core_LL_StartRefPwm(uint32_t *pRefTimer);
void MC_Core_LL_StartTimerIt(uint32_t *pTimer);
void MC_Core_LL_StopAdcIt(uint32_t *pAdc);
void MC_Core_LL_StopHfPwms(uint32_t *pHfTimer);
void MC_Core_LL_StopRefPwm(uint32_t *pRefTimer);
void MC_Core_LL_StopTimerIt(uint32_t *pTimer);
void MC_Core_LL_ToggleCommGpio(uint8_t MotorDeviceId);
void MC_Core_LL_ToggleZeroCrossingGpio(uint8_t MotorDeviceId);
/**
  * @} end MC_6STEP_CORE_Exported_LL_Functions_Prototypes
  */

/**
  * @}  end MC_6STEP_CORE
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

#endif /* __6STEP_CORE_H */

/************************ (C) COPYRIGHT STMicroelectronics *****END OF FILE****/