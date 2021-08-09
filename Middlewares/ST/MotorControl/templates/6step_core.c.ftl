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
 * @file    6step_core.c
 * @author  IPC Rennes & Motor Control SDK, ST Microelectronics
 * @brief   This file provides all the 6-step library core functions
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

/* Includes ------------------------------------------------------------------*/
#include "6step_core.h"

/** @addtogroup MIDDLEWARES
  * @brief  Middlewares Layer
  * @{ 
  */

/** @addtogroup MC_LIB_6STEP
  * @{
  */

/** @defgroup MC_6STEP_CORE 
  * @brief 6step core module
  * @{
  */ 

/** @defgroup MC_6STEP_CORE_Private_TypesDefinitions
  * @{
  */

/**
  * @}
  */ 

/** @defgroup MC_6STEP_CORE_Private_Defines
  * @{
  */
<#if MC.SIX_STEP_SENSING == "SENSORS_LESS"><#-- SensorLess usage -->
#define MC_BEMF_DEMAGN_COUNTER_INIT_VALUE ((uint16_t) 1)
</#if>
#define MC_NUMBER_OF_STEPS_IN_6STEP_ALGO  ((uint8_t)  6)
<#if MC.SIX_STEP_SPEED_LOOP == true><#-- Speed Loop usage -->
#define MC_REGULATOR_MIN_MAX_SCALING_DIV  ((uint16_t) 1000)
</#if>
#define MC_SECONDS_PER_MINUTE             ((uint8_t)  60)
/**
  * @}
  */ 

/** @defgroup MC_6STEP_CORE_Private_Macros
* @{
*/

/**
  * @}
  */ 

/** @defgroup MC_6STEP_CORE_Private_Functions_Prototypes
  * @{
  */

/**
  * @}
  */ 

/** @defgroup MC_6STEP_CORE_Private_Variables
  * @{
  */
uint8_t NumberOfDevices = 0;
uint32_t SysClockFrequency = 0;
MC_Handle_t *pMcCoreArray[NUMBER_OF_DEVICES];

/**
  * @} end MC_6STEP_SL_VM_SPDLP_Exported_Variables
  */

/** @defgroup MC_6STEP_CORE_Private_Functions
  * @{
  */
/* Declaration */
/* PWM ON sensing BEGIN 1 */
<#if MC.SIX_STEP_CONTROL_MODE == "VOLTAGE"><#-- Voltage Control mode usage -->
uint16_t MC_Core_ComputePulseValue(MC_Handle_t *pMc, uint16_t Period, uint16_t PulseValueIn1024th);
</#if>
/* PWM ON sensing END 1 */
<#if MC.SIX_STEP_SENSING == "SENSORS_LESS"><#-- SensorLess usage -->
MC_FuncStatus_t MC_Core_Alignment(MC_Handle_t *pMc);
</#if>
<#if MC.SIX_STEP_SENSING == "HALL_SENSORS"><#-- Hall Sensors usage -->
MC_FuncStatus_t MC_Core_AlignmentToCurrentStep(MC_Handle_t *pMc);
MC_FuncStatus_t MC_Core_HallStatusToStep(MC_Handle_t *pMc);
</#if>
uint16_t MC_Core_LfTimerPeriodFilter(MC_Handle_t *pMc);
<#if MC.SIX_STEP_SET_POINT_RAMPING == true><#-- Ramp usage -->
uint32_t MC_Core_SetPointRamping(MC_Handle_t *pMc, uint32_t CurrentValue, uint32_t FinalValue, uint32_t Multiplier);
</#if>
MC_FuncStatus_t MC_Core_SixStepTable(MC_Handle_t *pMc, uint16_t PulseValue, uint8_t StepNumber);
uint32_t MC_Core_SpeedCompute(MC_Handle_t *pMc);
<#if MC.SIX_STEP_SPEED_LOOP == true><#-- Speed Loop usage -->
uint16_t MC_Core_SpeedControl(MC_Handle_t *pMc);
</#if>
MC_FuncStatus_t MC_Core_SpeedRegulatorReset(MC_Handle_t *pMc);

/* Implementation */
<#if MC.SIX_STEP_CONTROL_MODE == "VOLTAGE"><#-- Voltage Control mode usage -->
/* PWM ON sensing BEGIN 2 */
/**
  * @brief  MC_Core_ComputePulseValue
  * @param[in] pMc motor control handle
  * @param[in] Period period of the timer which to compute the pulse value for
  * @param[in] PulseValueIn1024th pulse value in 1/1024 of a period
  * @retval Pulse value
  */
uint16_t MC_Core_ComputePulseValue(MC_Handle_t *pMc, uint16_t Period, uint16_t PulseValueIn1024th)
{
  return (uint16_t)((Period*PulseValueIn1024th) >> MC_DUTY_CYCLE_SCALING_SHIFT);
}
/* PWM ON sensing END 2 */
</#if>

<#if MC.SIX_STEP_SENSING == "SENSORS_LESS"><#-- SensorLess usage -->
/**
  * @brief  MC_Core_Alignment
  * @param[in] pMc motor control handle
  * @retval  Function Status
  */
MC_FuncStatus_t MC_Core_Alignment(MC_Handle_t *pMc)
{
  if ((pMc->align_index) == 0)
  {
    MC_Core_LL_DisableIrq();
    if (STARTUP_DIRECTION == 0)
    {
      (pMc->step_pos_next)--;
    }
    else
    {
      (pMc->step_pos_next)++;
    }
    MC_Core_NextStep(pMc, 0);
    MC_Core_LL_StartHfPwms(pMc->phf_timer);    
	<#if MC.SIX_STEP_THREE_PWM == true><#-- Only the 3 High Side are driven by timer -->
    MC_Core_LL_GenerateComEvent(pMc->phf_timer);
	</#if>
    MC_Core_LL_EnableIrq();
  }
  (pMc->align_index)++;
  if((pMc->align_index) >= ALIGNMENT_TIME)
  {
    pMc->status = MC_STARTUP;
    MC_Core_RampCalc(pMc);
    MC_Core_LL_StartTimerIt(pMc->plf_timer);
  }
  return MC_FUNC_OK;
}
</#if>

<#if MC.SIX_STEP_SENSING == "HALL_SENSORS"><#-- Hall Sensors usage -->
/**
  * @brief  MC_Core_AlignmentToCurrentStep
  * @param[in] pMc motor control handle
  * @retval  Function Status
  */
MC_FuncStatus_t MC_Core_AlignmentToCurrentStep(MC_Handle_t *pMc)
{
  MC_Core_LL_GetHallStatus(pMc);
  if (MC_Core_HallStatusToStep(pMc) != MC_FUNC_OK)
  {
    pMc->status = MC_VALIDATION_HALL_FAILURE;
    MC_Core_LL_Error(pMc);  
    return MC_FUNC_FAIL;
  }
  
  if (pMc->align_index != 0)
  {
    pMc->step_pos_next = pMc->step_position;
  }
  
  if ((pMc->align_index == 0) || (pMc->align_index >= (pMc->alignment_time)))
  {
    pMc->align_index=0;
    if(pMc->direction == 0)
    {
      if(pMc->step_pos_next == 6)
      {
        pMc->step_pos_next = 1;
      }
      else
      {
        pMc->step_pos_next++;
      }
    }
    else
    {
      if(pMc->step_pos_next <= 1)
      {
        pMc->step_pos_next = 6;
      }
      else
      {
        pMc->step_pos_next--;
      }
    }
  }
  (pMc->align_index)++;
  MC_Core_LL_SetDutyCycleRefPwm(pMc->pref_timer, pMc->startup_reference);
  pMc->reference_to_be_updated = 1;
  MC_Core_SixStepTable(pMc, pMc->hf_timer_pulse_value_max, pMc->step_pos_next);
  pMc->step_prepared = pMc->step_pos_next;
  MC_Core_LL_StartHfPwms(pMc->phf_timer);
  MC_Core_LL_GenerateComEvent(pMc->phf_timer);
  return MC_FUNC_OK;
}
  
/**
  * @brief  MC_Core_HallStatusToStep
  *         Find the current step according to the hall status
  * @param[in] pMc motor control handle
  * @retval Function Status
  */
MC_FuncStatus_t MC_Core_HallStatusToStep(MC_Handle_t *pMc)
{
  pMc->step_position = pMc->step_pos_next;
  if (pMc->direction == 0)    
  {
    switch (pMc->hall.status)
    {
      case VALIDATION_HALL_STATUS_DIRECT0_STEP1:
      {
        pMc->step_pos_next = 1;
      }
      break;
      case VALIDATION_HALL_STATUS_DIRECT0_STEP2:
      {
        pMc->step_pos_next = 2;
      }
      break;
      case VALIDATION_HALL_STATUS_DIRECT0_STEP3:
      {
        pMc->step_pos_next = 3;
      }
      break;
      case VALIDATION_HALL_STATUS_DIRECT0_STEP4:
      {
        pMc->step_pos_next = 4;
      }
      break;
      case VALIDATION_HALL_STATUS_DIRECT0_STEP5:
      {
        pMc->step_pos_next = 5;
      }
      break;
      case VALIDATION_HALL_STATUS_DIRECT0_STEP6:
      {
        pMc->step_pos_next = 6;
      }
      break;
      default:
      {
        return MC_FUNC_FAIL;
      }
      break;
    }
  }
  else
  {
    switch (pMc->hall.status)
    {
      case VALIDATION_HALL_STATUS_DIRECT1_STEP1:
      {
        pMc->step_pos_next = 1;
      }
      break;
      case VALIDATION_HALL_STATUS_DIRECT1_STEP2:
      {
        pMc->step_pos_next = 2;
      }
      break;
      case VALIDATION_HALL_STATUS_DIRECT1_STEP3:
      {
        pMc->step_pos_next = 3;
      }
      break;
      case VALIDATION_HALL_STATUS_DIRECT1_STEP4:
      {
        pMc->step_pos_next = 4;
      }
      break;
      case VALIDATION_HALL_STATUS_DIRECT1_STEP5:
      {
        pMc->step_pos_next = 5;
      }
      break;
      case VALIDATION_HALL_STATUS_DIRECT1_STEP6:
      {
        pMc->step_pos_next = 6;
      }
      break;
      default:
      {
        return MC_FUNC_FAIL;
      }
      break;
    }
  }
  return MC_FUNC_OK; 
}
</#if>

/**
  * @brief  MC_Core_LfTimerPeriodFilter
  *         Call this function only during MC_RUN state
  * @retval  output pulse value to set
  */
uint16_t MC_Core_LfTimerPeriodFilter(MC_Handle_t *pMc)
{
  uint32_t period_sum = 0;
  uint16_t period = 0;

  pMc->lf_timer_period_array[pMc->lf_timer_period_array_index] = pMc->lf_timer_period;

  if (pMc->lf_timer_period_array_completed == FALSE)
  {
    for(int16_t i = pMc->lf_timer_period_array_index; i >= 0; i--)
    {
      period_sum = period_sum + pMc->lf_timer_period_array[i];
    }
    (pMc->lf_timer_period_array_index)++;
    period = (uint16_t) (period_sum / pMc->lf_timer_period_array_index);
    if(pMc->lf_timer_period_array_index >= MC_SPEED_ARRAY_SIZE)
    {
      pMc->lf_timer_period_array_index = 0;
      pMc->lf_timer_period_array_completed = TRUE;
    }
  }
  else
  {
    for(int16_t i = (MC_SPEED_ARRAY_SIZE - 1); i >= 0; i--)
    {
      period_sum = period_sum + pMc->lf_timer_period_array[i];
    }
    (pMc->lf_timer_period_array_index)++;
    if(pMc->lf_timer_period_array_index >= MC_SPEED_ARRAY_SIZE)
    {
      pMc->lf_timer_period_array_index = 0;
    }
    period = period_sum >> RUN_SPEED_ARRAY_SHIFT;
  }

  return period;
}

<#if MC.SIX_STEP_SET_POINT_RAMPING == true><#-- Ramp usage -->
/**
  * @brief  Compute the current value in a ramp
  * @param(in]  CurrentValue
  * @param(in]  FinalValue
  * @param(in]  Multiplier
  * @retval  Value to set 
  */
uint32_t MC_Core_SetPointRamping(MC_Handle_t *pMc, uint32_t CurrentValue, uint32_t FinalValue, uint32_t Multiplier)
{
  if (pMc->reference_to_be_updated != 0)
  {
    if (CurrentValue < FinalValue)
    {
      CurrentValue += ((Multiplier*pMc->acceleration) >> 10);
      if (CurrentValue > FinalValue)
      {
        CurrentValue = FinalValue;
      }
    }
    else if (CurrentValue > FinalValue)
    {
      CurrentValue -= ((Multiplier*pMc->acceleration) >> 10);
      if (CurrentValue < FinalValue)
      {
        CurrentValue = FinalValue;
      }
    }
    else
    {
      pMc->reference_to_be_updated = 0;
    }
  }
  return CurrentValue;
}
</#if>

/**
  * @brief  Set the HF pwm duty cycles for each step
  * @param(in]  StepNumber
  * @retval  Function Status
  */
MC_FuncStatus_t MC_Core_SixStepTable(MC_Handle_t *pMc, uint16_t PulseValue, uint8_t StepNumber)
{
  switch (StepNumber)
  {
<#if MC.SIX_STEP_THREE_PWM == true><#-- Only the 3 High Side are driven by timer -->
    case 1:
    {
      MC_Core_LL_SetDutyCycleHfPwms(pMc->phf_timer, PulseValue, 0, 0);
      MC_Core_LL_EnableInputsHfPwmsStep14(pMc->id);
      pMc->bemf.current_adc_channel = pMc->bemf.adc_channel[2];
    }
    break;
    case 2:      
    {
      MC_Core_LL_SetDutyCycleHfPwms(pMc->phf_timer, PulseValue, 0, 0);
      MC_Core_LL_EnableInputsHfPwmsStep25(pMc->id);
      pMc->bemf.current_adc_channel = pMc->bemf.adc_channel[1];
    }
    break;
    case 3:
    {
      MC_Core_LL_SetDutyCycleHfPwms(pMc->phf_timer, 0, PulseValue, 0);
      MC_Core_LL_EnableInputsHfPwmsStep36(pMc->id);
      pMc->bemf.current_adc_channel = pMc->bemf.adc_channel[0];
    }
    break;
    case 4:
    {
      MC_Core_LL_SetDutyCycleHfPwms(pMc->phf_timer, 0, PulseValue, 0);
      MC_Core_LL_EnableInputsHfPwmsStep14(pMc->id);
      pMc->bemf.current_adc_channel = pMc->bemf.adc_channel[2];
    }
    break;
    case 5:
    {
      MC_Core_LL_SetDutyCycleHfPwms(pMc->phf_timer, 0, 0 ,PulseValue);
      MC_Core_LL_EnableInputsHfPwmsStep25(pMc->id);
      pMc->bemf.current_adc_channel = pMc->bemf.adc_channel[1];      
    }
    break;
    case 6:      
    {
      MC_Core_LL_SetDutyCycleHfPwms(pMc->phf_timer, 0, 0 ,PulseValue);
      MC_Core_LL_EnableInputsHfPwmsStep36(pMc->id);
      pMc->bemf.current_adc_channel = pMc->bemf.adc_channel[0];
    }
    break;
<#else>
    case 1:
    {
      MC_Core_LL_SetDutyCycleHfPwmU(pMc->phf_timer, PulseValue);
      MC_Core_LL_SetDutyCycleHfPwmV(pMc->phf_timer, 0);
      MC_Core_LL_EnableChannelsHfPwmsStep14(pMc->phf_timer);
    }
    break;
    case 2:
    {
      MC_Core_LL_SetDutyCycleHfPwmW(pMc->phf_timer, 0);
      MC_Core_LL_SetDutyCycleHfPwmU(pMc->phf_timer, PulseValue);
      MC_Core_LL_EnableChannelsHfPwmsStep25(pMc->phf_timer);
    }
    break;
    case 3:
    {
      MC_Core_LL_SetDutyCycleHfPwmV(pMc->phf_timer, PulseValue);
      MC_Core_LL_SetDutyCycleHfPwmW(pMc->phf_timer, 0);
      MC_Core_LL_EnableChannelsHfPwmsStep36(pMc->phf_timer);
    }
    break;
    case 4:
    {
      MC_Core_LL_SetDutyCycleHfPwmU(pMc->phf_timer, 0);
      MC_Core_LL_SetDutyCycleHfPwmV(pMc->phf_timer, PulseValue);
      MC_Core_LL_EnableChannelsHfPwmsStep14(pMc->phf_timer);
    }
    break;
    case 5:
    {
       MC_Core_LL_SetDutyCycleHfPwmW(pMc->phf_timer, PulseValue);
       MC_Core_LL_SetDutyCycleHfPwmU(pMc->phf_timer, 0);
       MC_Core_LL_EnableChannelsHfPwmsStep25(pMc->phf_timer);
    }
    break;
    case 6:
    {
      MC_Core_LL_SetDutyCycleHfPwmV(pMc->phf_timer, 0);
      MC_Core_LL_SetDutyCycleHfPwmW(pMc->phf_timer, PulseValue);
      MC_Core_LL_EnableChannelsHfPwmsStep36(pMc->phf_timer);
    }
    break;
</#if>
  }
  return MC_FUNC_OK;
}

/**
  * @brief  MC_Core_SpeedCompute
  *         Call this function only during MC_RUN state
  * @retval  output pulse value to set
  */
uint32_t MC_Core_SpeedCompute(MC_Handle_t *pMc)
{
  uint16_t prescaler = MC_Core_LL_GetTimerPrescaler(pMc->plf_timer);
  uint16_t period = MC_Core_LfTimerPeriodFilter(pMc);
  return ((SysClockFrequency * 10) / ((++period) * (++prescaler) * (pMc->motor_charac.pole_pairs)));
}

<#if MC.SIX_STEP_SPEED_LOOP == true><#-- Speed Loop usage -->
/**
  * @brief  MC_Core_SpeedControl
  * @retval  output pulse value to set
  */
uint16_t MC_Core_SpeedControl(MC_Handle_t *pMc)
{
  int32_t proportional_term = 0, derivative_term = 0, output = 0;
  int32_t speed_error;
  
  /* Error computation */
  speed_error = (pMc->speed_target_value) - (pMc->speed_fdbk_filtered);
  
  /* Proportional term computation */
  proportional_term = speed_error * (pMc->pid_parameters.kp);
    
  /* Integral term computation */
  pMc->pid_parameters.integral_term_sum += speed_error * (pMc->pid_parameters.ki);
  if (pMc->pid_parameters.integral_term_sum > (int32_t)((pMc->pid_parameters.maximum_output) << (pMc->pid_parameters.scaling_shift)))
  {
    pMc->pid_parameters.integral_term_sum = ((pMc->pid_parameters.maximum_output) << (pMc->pid_parameters.scaling_shift));
  } 
  else if (pMc->pid_parameters.integral_term_sum < (int32_t)((pMc->pid_parameters.minimum_output) << (pMc->pid_parameters.scaling_shift)))
  {
    pMc->pid_parameters.integral_term_sum = ((pMc->pid_parameters.minimum_output) << (pMc->pid_parameters.scaling_shift));
  }
  
  /* Derivative computation */
  derivative_term = ((pMc->pid_parameters.previous_speed) - (pMc->speed_fdbk_filtered)) * (pMc->pid_parameters.kd);
  pMc->pid_parameters.previous_speed = pMc->speed_fdbk_filtered;

  output =
    ((proportional_term + (pMc->pid_parameters.integral_term_sum) + derivative_term) >> (pMc->pid_parameters.scaling_shift));
  
  if (output > (pMc->pid_parameters.maximum_output))
  {
    output = (pMc->pid_parameters.maximum_output);
  }
  else if (output < (pMc->pid_parameters.minimum_output))
  {
    output = (pMc->pid_parameters.minimum_output);
  }
  
  return (uint16_t) output;
}
</#if>

/**
  * @brief  MC_Core_SpeedRegulatorReset
  * @retval  Function Status
  */
MC_FuncStatus_t MC_Core_SpeedRegulatorReset(MC_Handle_t *pMc)
{
<#if MC.SIX_STEP_SENSING == "SENSORS_LESS"><#-- SensorLess usage -->
  pMc->speed_target_command = 0;
  MC_Core_SetSpeed(pMc, STARTUP_SPEED_TARGET);
</#if>
<#if MC.SIX_STEP_SENSING == "HALL_SENSORS"><#-- Hall Sensors usage -->
  pMc->speed_target_value = STARTUP_SPEED_TARGET;
  pMc->speed_target_command = RUN_SPEED_TARGET;
</#if>
<#if MC.SIX_STEP_SPEED_LOOP == true><#-- Speed Loop usage -->
  pMc->pid_parameters.kp = PID_KP;
  pMc->pid_parameters.ki = ((PID_KI)*(pMc->control_loop_time));
  pMc->pid_parameters.kd = ((PID_KD)/(pMc->control_loop_time));
  pMc->pid_parameters.scaling_shift = PID_SCALING_SHIFT;  
  pMc->pid_parameters.minimum_output = ((PID_OUTPUT_MIN)*(pMc->hf_timer_period)) / MC_REGULATOR_MIN_MAX_SCALING_DIV;
  pMc->pid_parameters.maximum_output = ((PID_OUTPUT_MAX)*(pMc->hf_timer_period)) / MC_REGULATOR_MIN_MAX_SCALING_DIV;
</#if>
  return MC_FUNC_OK;
}
/**
  * @} end MC_6STEP_CORE_Private_Functions
  */ 

/** @defgroup MC_6STEP_CORE_Exported_Functions
  * @{
  */

MC_FuncStatus_t MC_Core_AssignTimers(MC_Handle_t *pMc, uint32_t *pHfTimer, uint32_t *pLfTimer, uint32_t *pRefTimer)
{
  if ((pMc == NULL) || (pHfTimer == NULL) || (pLfTimer == NULL))
  {
    return MC_FUNC_FAIL;
  }
  pMc->phf_timer = pHfTimer;
  pMc->hf_timer_period = MC_Core_LL_GetTimerPeriod(pHfTimer);
  pMc->plf_timer = pLfTimer;
  pMc->pref_timer = pRefTimer;
  if (pRefTimer != NULL)
  {
    pMc->ref_timer_period = pMc->hf_timer_period;
  }
  return MC_FUNC_OK;
}

/**
  * @brief  MC_Core_ConfigureUserAdc
  * @param[in] pMc motor control handle
  * @param[in] pTrigTimer pointer on the handle of the timer used to trig the ADC
  * @param[in] TrigTimerChannel Channel of the timer used to trig the ADC
  * @retval  Function Status
  */
MC_FuncStatus_t MC_Core_ConfigureUserAdc(MC_Handle_t* pMc, uint32_t *pTrigTimer, uint16_t TrigTimerChannel)
{
  if (pTrigTimer == NULL)
  {
    return MC_FUNC_FAIL;
  }
  pMc->adc_user.ptrig_timer = pTrigTimer;
  pMc->adc_user.trig_timer_period = pMc->hf_timer_period;
  pMc->adc_user.trig_timer_channel = TrigTimerChannel;
  return MC_FUNC_OK;
}

/**
  * @brief  MC_Core_ConfigureUserAdcChannel
  * @param[in] pMc motor control handle
  * @param[in] pAdc pointer on the ADC to be selected
  * @param[in] AdcChannel ADC channel to be selected
  * @param[in] SamplingTime ADC sampling time to be selected
  * @param[in] UserMeasurement User measurement to map to ADC channel
  * @retval None
  */
MC_FuncStatus_t MC_Core_ConfigureUserAdcChannel(MC_Handle_t* pMc, uint32_t* pAdc, uint32_t AdcChannel, uint32_t SamplingTime, MC_UserMeasurements_t UserMeasurement)
{
  if ((UserMeasurement == MC_USER_MEAS_1) || (UserMeasurement == MC_USER_MEAS_2) || (UserMeasurement == MC_USER_MEAS_3) || (UserMeasurement == MC_USER_MEAS_4) || (UserMeasurement == MC_USER_MEAS_5))
  {
    pMc->adc_user.padc[UserMeasurement] = pAdc;
    pMc->adc_user.channel[UserMeasurement] = AdcChannel;
    pMc->adc_user.sampling_time[UserMeasurement] = SamplingTime;
    MC_Core_LL_SetAdcSamplingTime(pAdc, AdcChannel, SamplingTime);
    return MC_FUNC_OK;
  }
  else
  {
    return MC_FUNC_FAIL;
  }
}

MC_FuncStatus_t MC_Core_ConfigureUserButton(MC_Handle_t* pMc, uint16_t ButtonPin, uint16_t ButtonDebounceTimeMs)
{
  pMc->button_user.gpio_pin = ButtonPin;
  pMc->button_user.debounce_time_ms = ButtonDebounceTimeMs;
  return MC_FUNC_OK;
}

/**
  * @brief  MC_Core_GetGateDriverPwmFreq
  * @param[in] pMc motor control handle
  * @retval pMc->gate_driver_frequency
  */
uint32_t MC_Core_GetGateDriverPwmFreq(MC_Handle_t* pMc)
{
  return pMc->gate_driver_frequency; 
}

/**
  * @brief  MC_Core_GetMotorControlHandle
  *         Initializes the motor control
  * @param[in] MotorDeviceId
  * @retval motor control handle
  */
MC_Handle_t* MC_Core_GetMotorControlHandle(uint8_t MotorDeviceId)
{
  if (NumberOfDevices != 0)
  {
    if (MotorDeviceId < NUMBER_OF_DEVICES)
    {
      return pMcCoreArray[MotorDeviceId];
    }
    else
    {
      return NULL;
    }
  }
  else
  {
    return NULL;
  }
}

/**
  * @brief  MC_Core_GetSpeed
  * @param[in] pMc motor control handle
  * @retval pMc->speed_fdbk_filtered
  */
uint32_t MC_Core_GetSpeed(MC_Handle_t* pMc)
{
  return pMc->speed_fdbk_filtered;
}

/**
  * @brief  MC_Core_GetStatus
  * @param[in] pMc motor control handle
  * @retval pMc->status
  */
MC_Status_t MC_Core_GetStatus(MC_Handle_t* pMc)
{
  return pMc->status; 
}

/**
  * @brief  MC_Core_Init
  *         Initializes the motor control
  * @param[in] pMc motor control handle
  * @retval Function Status
  */
MC_FuncStatus_t MC_Core_Init(MC_Handle_t *pMc)
{
  /* Check the motor control handle and the mandatory timers */
  if ((pMc == NULL) || (pMc->plf_timer == NULL) || (pMc->phf_timer == NULL))
  {
    return MC_FUNC_FAIL;
  }
  else
  {
    if (NumberOfDevices < NUMBER_OF_DEVICES)
    {
      pMc->id = NumberOfDevices;
      pMcCoreArray[NumberOfDevices] = pMc;
      NumberOfDevices++;
    }
    else
    {
      return MC_FUNC_FAIL;
    }
  }
  
  /* Set Device initial State */
  pMc->status = MC_IDLE;
  
  /* Get temperature calibration data */
  MC_Core_LL_GetTemperatureCalibrationData(pMc);
    
  /* Motor characteristics initialisation */
  pMc->motor_charac.pole_pairs = MOTOR_NUM_POLE_PAIRS;  

  /* Motor parameters and private variable initialisation */
  if (MC_Core_Reset(pMc) != MC_FUNC_OK)
  {
    return MC_FUNC_FAIL;
  }
  SysClockFrequency = MC_Core_LL_GetSysClockFrequency();
  MC_Core_SetGateDriverPwmFreq(pMc, MC_Core_LL_GetGateDrivingPwmFrequency(pMc->phf_timer));
  
  /* Set Device State at the end of initialization */
  pMc->status = MC_STOP;

  return MC_FUNC_OK; 
}

/**
  * @brief  MC_Core_SetAdcUserTrigTime
  * @param[in] DutyCycleToSet Duty cycle in 1/1024 of PWM period
  * @retval Function Status
  */
MC_FuncStatus_t MC_Core_SetAdcUserTrigTime(MC_Handle_t* pMc, uint32_t DutyCycleToSet)
{
  pMc->adc_user.trig_time = (uint16_t)((pMc->adc_user.trig_timer_period*DutyCycleToSet) >> MC_DUTY_CYCLE_SCALING_SHIFT);
  return MC_FUNC_OK; 
}

/**
  * @brief  MC_Core_SetDirection
  * @param[in] pMc motor control handle
  * @param[in] DirectionToSet
  * @retval Function Status
  */
MC_FuncStatus_t MC_Core_SetDirection(MC_Handle_t* pMc, uint32_t DirectionToSet)
{
  pMc->direction = DirectionToSet;
  return MC_FUNC_OK; 
}

/**
  * @brief  MC_Core_SetGateDriverPwmFreq
  * @param[in] pMc motor control handle
  * @param[in] FrequencyHzToSet frequency in Hz to be set
  * @retval Function Status
  */
MC_FuncStatus_t MC_Core_SetGateDriverPwmFreq(MC_Handle_t* pMc, uint32_t FrequencyHzToSet)
{
  if (pMc->status != MC_STOP)
  {
    MC_Core_Stop(pMc);
  }
  pMc->hf_timer_period = (SysClockFrequency/(FrequencyHzToSet*(MC_Core_LL_GetTimerPrescaler(pMc->phf_timer)+1))-1);
  if (pMc->hf_timer_period != 0)
  {
    pMc->gate_driver_frequency = FrequencyHzToSet;
    MC_Core_LL_SetPeriodTimer(pMc->phf_timer, pMc->hf_timer_period);
    if (pMc->pref_timer != NULL)
    {
      pMc->ref_timer_period = pMc->hf_timer_period;
      MC_Core_LL_SetPeriodTimer(pMc->pref_timer, pMc->hf_timer_period);
    }
<#if MC.SIX_STEP_SENSING == "SENSORS_LESS"><#-- SensorLess usage -->
    if (pMc->bemf.ptrig_timer != NULL)
    {
      pMc->bemf.trig_timer_period = pMc->hf_timer_period;
      MC_Core_LL_SetPeriodTimer(pMc->bemf.ptrig_timer, pMc->hf_timer_period);
    }
</#if>
    pMc->adc_user.trig_timer_period = pMc->hf_timer_period;
    MC_Core_LL_SetPeriodTimer(pMc->adc_user.ptrig_timer, pMc->hf_timer_period);
    MC_Core_Reset(pMc);
    return MC_FUNC_OK;
  }
  else
  {
    return MC_FUNC_FAIL;
  }
}

/**
  * @brief  MC_Core_SpeedFeedbackReset
  * @param[in] pMc motor control handle
  * @retval  Function Status
  */
MC_FuncStatus_t MC_Core_SpeedFeedbackReset(MC_Handle_t *pMc)
{
  pMc->speed_fdbk_filtered = 0;
  pMc->lf_timer_period_array_completed = FALSE;
  pMc->lf_timer_period_array_index = 0;
  for (int16_t i = MC_SPEED_ARRAY_SIZE-1; i >= 0; i--)
  {
    pMc->lf_timer_period_array[i] = MC_LF_TIMER_MAX_PERIOD;
  }
  return MC_FUNC_OK;
}

<#if MC.SIX_STEP_SENSING == "SENSORS_LESS"><#-- SensorLess usage -->
/**
  * @brief  MC_Core_ConfigureBemfAdc
  * @param[in] pMc motor control handle
  * @param[in] pAdc pointer on the ADC used for Bemf
  * @param[in] pTrigTimer pointer on the handle of the timer used to trig the ADC
  * @param[in] TrigTimerChannel channel of the timer used to trig the ADC
  * @retval  Function Status
  */
MC_FuncStatus_t MC_Core_ConfigureBemfAdc(MC_Handle_t* pMc, uint32_t * pAdc, uint32_t *pTrigTimer, uint16_t TrigTimerChannel)
{
  if ((pAdc == NULL) || (pTrigTimer == NULL))
  {
    return MC_FUNC_FAIL;
  }
  pMc->bemf.padc = pAdc;
  pMc->bemf.ptrig_timer = pTrigTimer;
  pMc->bemf.trig_timer_period = pMc->hf_timer_period;
  pMc->bemf.trig_timer_channel = TrigTimerChannel;
  return MC_FUNC_OK;
}

/**
  * @brief  MC_Core_ConfigureBemfAdcChannel
  * @param[in] pMc motor control handle
  * @param[in] AdcChannel ADC channel to be selected
  * @param[in] SamplingTime ADC sampling time to be selected
  * @param[in] BemfPhases Bemf phase to map to ADC channel
  * @retval  Function Status
  */
MC_FuncStatus_t MC_Core_ConfigureBemfAdcChannel(MC_Handle_t* pMc, uint32_t AdcChannel, uint32_t SamplingTime, MC_BemfPhases_t BemfPhase)
{
  if ((BemfPhase == MC_BEMF_PHASE_1) || (BemfPhase == MC_BEMF_PHASE_2) || (BemfPhase == MC_BEMF_PHASE_3))
  {
    pMc->bemf.adc_channel[BemfPhase] = AdcChannel;
    pMc->bemf.sampling_time = SamplingTime;
    MC_Core_LL_SetAdcSamplingTime(pMc->bemf.padc, AdcChannel, SamplingTime);
    return MC_FUNC_OK;
  }
  else
  {
    return MC_FUNC_FAIL;
  }
}
  
/**
  * @brief  MC_Core_LfTimerPeriodCompute
  *         Check events and compute time for the commutation to next step
  * @param[in]  pMc
  * @param[in]  CounterSnaphot
  * @param[in]  BemfIsIncreasing
  * @retval Function Status
  */
MC_FuncStatus_t MC_Core_LfTimerPeriodCompute(MC_Handle_t* pMc, uint16_t CounterSnaphot, uint8_t BemfIsIncreasing)
{
  {
    MC_Core_LL_ToggleZeroCrossingGpio(pMc->id);    
    if (pMc->status == MC_VALIDATION)
    {
      if (pMc->bemf.over_threshold_events > VALIDATION_BEMF_EVENTS_MAX)
      {
        pMc->status = MC_VALIDATION_BEMF_FAILURE;
        MC_Core_LL_Error(pMc);
      }
      if (BemfIsIncreasing != 0)
      {
        pMc->bemf.zero_crossing_events++;
        pMc->bemf.over_threshold_events = 0;      
      }
      else
      {
        pMc->bemf.over_threshold_events++;
      }  
      if (pMc->bemf.zero_crossing_events >= VALIDATION_ZERO_CROSS_NUMBER)
      {
        pMc->status = MC_RUN;
	<#if MC.SIX_STEP_SPEED_LOOP == true><#-- Speed Loop usage -->
        pMc->pid_parameters.integral_term_sum = ((pMc->pulse_value) << (pMc->pid_parameters.scaling_shift));
        pMc->pid_parameters.previous_speed = pMc->speed_fdbk_filtered;
        MC_Core_SetSpeed(pMc, RUN_SPEED_TARGET);
	</#if>
        pMc->bemf.zero_crossing_events = 0;
	<#if MC.SIX_STEP_SET_POINT_RAMPING == true><#-- Ramp usage -->
        pMc->acceleration = RUN_ACCELERATION;
	</#if>
      }
    }
    else
    {
	<#-- TODO: Can't we unified this code ? -->
	<#if MC.SIX_STEP_THREE_PWM == true><#-- Only the 3 High Side are driven by timer -->
      MC_Core_LL_SetPeriodTimer(pMc->plf_timer, CounterSnaphot + (uint16_t)(((uint32_t)(RUN_ZCD_TO_COMM * (pMc->lf_timer_period))) >> 9));
	<#else>
      MC_Core_LL_SetPeriodTimer(pMc->plf_timer, CounterSnaphot + (uint16_t)(((uint32_t)((pMc->bemf.zcd_to_comm) * (pMc->lf_timer_period))) >> 9));
	</#if>
    }
  }
  return MC_FUNC_OK; 
}
</#if>

/**
  * @brief  MC_Core_MediumFrequencyTask
  *         Systick Callback - Call the Speed loop
  * @param[in] pMc Pointer on a Motor Control handle
  * @retval Function Status
  */
MC_FuncStatus_t MC_Core_MediumFrequencyTask(MC_Handle_t *pMc)
{
<#-- Needed for the TERATERM usage, removed for the ST MCWB usage -->
<#if MC.SERIAL_COMMUNICATION == false>
  MC_Com_Task();
</#if>

  if (pMc->uw_tick_cnt == pMc->button_user.debounce_time_ms)
  {
    pMc->button_user.enabled++;
  }
  if (pMc->status == MC_RUN)
  {
    if(pMc->tick_cnt >= pMc->control_loop_time)
    {
<#if MC.SIX_STEP_SPEED_LOOP == true><#-- Speed Loop usage -->
	<#if MC.SIX_STEP_SET_POINT_RAMPING == true><#-- Ramp usage -->
      pMc->speed_target_value = MC_Core_SetPointRamping(pMc, pMc->speed_target_value, pMc->speed_target_command, pMc->control_loop_time);
	<#else>
      pMc->speed_target_value = pMc->speed_target_command;
	</#if>
      MC_Core_LL_DisableIrq();
      pMc->pulse_value = MC_Core_SpeedControl(pMc);
<#else>
	<#if MC.SIX_STEP_SET_POINT_RAMPING == true><#-- Ramp usage -->
		<#if MC.SIX_STEP_CONTROL_MODE == "VOLTAGE"><#-- Voltage Control mode usage -->
      pMc->pulse_value = MC_Core_SetPointRamping(pMc, pMc->pulse_value, pMc->pulse_command, pMc->hf_timer_period);
		</#if>
		<#if MC.SIX_STEP_CONTROL_MODE == "CURRENT"><#-- Current Control mode usage -->
      pMc->pulse_value = MC_Core_SetPointRamping(pMc, pMc->pulse_value, pMc->pulse_command, pMc->ref_timer_period);
		</#if>
	<#else>
      pMc->pulse_value = pMc->pulse_command;
	</#if>
      MC_Core_LL_DisableIrq();
</#if>
<#if MC.SIX_STEP_CONTROL_MODE == "VOLTAGE"><#-- Voltage Control mode usage -->
      /* PWM ON sensing BEGIN 3 */
      if ((pMc->bemf.pwm_on_sensing_enabled == 0) && (pMc->pulse_value > pMc->bemf.pwm_on_sensing_en_thres))
      {
        (pMc->bemf.pwm_on_sensing_enabled)++;
        pMc->bemf.trig_time = pMc->bemf.pwm_on_sensing_trig_time;
        pMc->bemf.adc_threshold_up = RUN_BEMF_THRESHOLD_UP_ON;
        pMc->bemf.adc_threshold_down = RUN_BEMF_THRESHOLD_DOWN_ON;
        MC_Core_LL_ResetBemfGpio(pMc->id);
      }
      else if ((pMc->bemf.pwm_on_sensing_enabled == 1) && (pMc->pulse_value < pMc->bemf.pwm_on_sensing_dis_thres))
      {
        pMc->bemf.pwm_on_sensing_enabled = 0;
        pMc->bemf.trig_time = pMc->bemf.pwm_off_sensing_trig_time;
        pMc->bemf.adc_threshold_up = RUN_BEMF_THRESHOLD_UP;
        pMc->bemf.adc_threshold_down = RUN_BEMF_THRESHOLD_DOWN;
        MC_Core_LL_SetBemfGpio(pMc->id);
      }
      /* PWM ON sensing END 3 */
      MC_Core_LL_SetDutyCycleHfPwmForStepN(pMc->phf_timer, pMc->pulse_value, pMc->step_position);
      MC_Core_LL_EnableIrq();
      /* PWM ON sensing BEGIN 4 */
      if (pMc->step_prepared == 0)
      {
        MC_Core_LL_SetDutyCyclePwmForAdcTrig(pMc->bemf.ptrig_timer, pMc->bemf.trig_timer_channel, pMc->bemf.trig_time);
      }
      else
      {  
        MC_Core_LL_SetDutyCyclePwmForAdcTrig(pMc->adc_user.ptrig_timer, pMc->adc_user.trig_timer_channel, pMc->adc_user.trig_time);
      }
      /* PWM ON sensing END 4 */
</#if>
<#if MC.SIX_STEP_CONTROL_MODE == "CURRENT"><#-- Current Control mode usage -->
      MC_Core_LL_SetDutyCycleRefPwm(pMc->pref_timer, pMc->pulse_value);
      MC_Core_LL_EnableIrq();
      MC_Core_LL_SetDutyCyclePwmForAdcTrig(pMc->adc_user.ptrig_timer, pMc->adc_user.trig_timer_channel, pMc->adc_user.trig_time);
</#if>
      pMc->tick_cnt = 1;
    }
    else
    {
      (pMc->tick_cnt)++;
    }
<#if MC.SIX_STEP_SENSING == "SENSORS_LESS"><#-- SensorLess usage -->
	<#-- TODO: Can't we unified this code ? -->
	<#if MC.SIX_STEP_THREE_PWM == true><#-- Only the 3 High Side are driven by timer -->
    if (pMc->speed_fdbk_filtered > RUN_SPEED_THRESHOLD_DEMAG)
	<#else>
    if (pMc->speed_fdbk_filtered > (pMc->bemf.run_speed_thres_demag))
	</#if>
    {
      pMc->bemf.demagn_value = RUN_DEMAGN_DELAY_MIN;
    }
    else if (pMc->speed_fdbk_filtered > STARTUP_SPEED_TARGET)
    {
      pMc->bemf.demagn_value = (pMc->bemf.demagn_coefficient) / (pMc->speed_fdbk_filtered);
    }
    else
    {
      pMc->bemf.demagn_value = VALIDATION_DEMAGN_DELAY;
    }
</#if>
  }
  else if (pMc->status == MC_ALIGNMENT)
  {
<#if MC.SIX_STEP_SENSING == "SENSORS_LESS"><#-- SensorLess usage -->
    MC_Core_Alignment(pMc);
</#if>
<#if MC.SIX_STEP_SENSING == "HALL_SENSORS"><#-- Hall Sensors usage -->
    MC_Core_AlignmentToCurrentStep(pMc);
</#if>
  }
  return MC_FUNC_OK;
}

/**
  * @brief  MC_Core_PrepareNextStep
  * @retval  Function Status
  */
MC_FuncStatus_t MC_Core_PrepareNextStep(MC_Handle_t* pMc)
{
<#if MC.SIX_STEP_SENSING == "SENSORS_LESS"><#-- SensorLess usage -->
  (pMc->step_prepared)++;
  pMc->bemf.demagn_counter = MC_BEMF_DEMAGN_COUNTER_INIT_VALUE;
  if(pMc->direction == 0)
  {
    if(pMc->step_pos_next == 6)
    {
      pMc->step_pos_next = 1;
    }
    else
    {
      pMc->step_pos_next++;
    }
  }
  else
  {
    if(pMc->step_pos_next <= 1)
    {
      pMc->step_pos_next = 6;
    }
    else
    {
      pMc->step_pos_next--;
    }
  }
</#if>
<#if MC.SIX_STEP_SENSING == "HALL_SENSORS"><#-- Hall Sensors usage -->
  if (pMc->step_prepared != 0)
  {
    pMc->status = MC_ALIGNMENT;
  }
  else if (pMc->status != MC_ALIGNMENT)
  {
    if (MC_Core_HallStatusToStep(pMc) != MC_FUNC_OK)
    {
      pMc->status = MC_VALIDATION_HALL_FAILURE;
      MC_Core_LL_Error(pMc);  
      return MC_FUNC_FAIL;
    }
    if (pMc->step_pos_next == pMc->step_position)
    {
      if(pMc->direction == 0)
      {
        if(pMc->step_pos_next == 6)
        {
          pMc->step_pos_next = 1;
        }
        else
        {
          pMc->step_pos_next++;
        }
      }
      else
      {
        if(pMc->step_pos_next <= 1)
        {
          pMc->step_pos_next = 6;
        }
        else
        {
          pMc->step_pos_next--;
        }
      }
    }
    else
    {
      if(pMc->direction != 0)
      {
        if(pMc->step_pos_next == 6)
        {
          pMc->step_pos_next = 1;
        }
        else
        {
          pMc->step_pos_next++;
        }
      }
      else
      {
        if(pMc->step_pos_next <= 1)
        {
          pMc->step_pos_next = 6;
        }
        else
        {
          pMc->step_pos_next--;
        }
      }
    }
</#if>
<#if MC.SIX_STEP_CONTROL_MODE == "VOLTAGE"><#-- Voltage Control mode usage -->
	<#if MC.SIX_STEP_THREE_PWM == false><#-- All the 6 High Side are driven by timer -->
  MC_Core_SixStepTable(pMc, pMc->pulse_value, pMc->step_pos_next);
	</#if>
</#if>
<#if MC.SIX_STEP_CONTROL_MODE == "CURRENT"><#-- Current Control mode usage -->
  MC_Core_SixStepTable(pMc, pMc->hf_timer_pulse_value_max, pMc->step_pos_next);
</#if>
<#if MC.SIX_STEP_SENSING == "SENSORS_LESS"><#-- SensorLess usage -->
  (pMc->adc_user.channel_index)++;
  if (pMc->adc_user.channel_index == NUMBER_OF_USER_ADC_CHANNELS)
  {
    pMc->adc_user.channel_index = 0;
  }
</#if>
<#if MC.SIX_STEP_SENSING == "HALL_SENSORS"><#-- Hall Sensors usage -->
    pMc->speed_fdbk_filtered = MC_Core_SpeedCompute(pMc);
    (pMc->step_prepared)++;
  }
</#if>
  return MC_FUNC_OK;
}

/**
  * @brief  Process the ADC measurement to detect the BEMF zero crossing
  * @param[in] pMc motor control handle
  * @param[in] pAdc pointer to the ADC
  * @param[in] LfTimerCounterSnapshot value of the LF timer counter at the beginning of the ADC callback
  * @param[in] AdcMeasurement the ADC conversion result, aka the ADC measurement
  * @retval  Function Status
  */
MC_FuncStatus_t  MC_Core_ProcessAdcMeasurement(MC_Handle_t* pMc, uint32_t* pAdc, uint16_t LfTimerCounterSnapshot, uint16_t AdcMeasurement)
{
<#if MC.SIX_STEP_SENSING == "HALL_SENSORS"><#-- Hall Sensors usage -->
  uint8_t tmp = pMc->adc_user.channel_index;
</#if>

<#if MC.SIX_STEP_SENSING == "SENSORS_LESS"><#-- SensorLess usage -->
  if(pMc->step_prepared == 0)
  {
	<#if MC.SIX_STEP_CONTROL_MODE == "VOLTAGE"><#-- Voltage Control mode usage -->
    pMc->step_change = 0;
	</#if>
    if(pMc->bemf.demagn_counter > pMc->bemf.demagn_value)
    {
      if(pMc->direction == 0)
      {
        if (((pMc->step_position&0x1) == 0) && (AdcMeasurement > pMc->bemf.adc_threshold_up))
        {
          {
            MC_Core_LfTimerPeriodCompute(pMc, LfTimerCounterSnapshot, 1);
            MC_Core_PrepareNextStep(pMc);
            MC_Core_LL_SelectAdcChannelDuringCallback(pMc->bemf.padc, pMc->adc_user.padc[pMc->adc_user.channel_index], pMc->adc_user.channel[pMc->adc_user.channel_index], pMc->adc_user.sampling_time[pMc->adc_user.channel_index]);
            MC_Core_LL_SetDutyCyclePwmForAdcTrig(pMc->adc_user.ptrig_timer, pMc->adc_user.trig_timer_channel, pMc->adc_user.trig_time);
          }
          pMc->bemf.consecutive_down_counter = 0;
        }
        if (((pMc->step_position&0x1) != 0) && (AdcMeasurement < pMc->bemf.adc_threshold_down))
        {
          {
            MC_Core_LfTimerPeriodCompute(pMc, LfTimerCounterSnapshot, 0);
            MC_Core_PrepareNextStep(pMc);
            MC_Core_LL_SelectAdcChannelDuringCallback(pMc->bemf.padc, pMc->adc_user.padc[pMc->adc_user.channel_index], pMc->adc_user.channel[pMc->adc_user.channel_index], pMc->adc_user.sampling_time[pMc->adc_user.channel_index]);
            MC_Core_LL_SetDutyCyclePwmForAdcTrig(pMc->adc_user.ptrig_timer, pMc->adc_user.trig_timer_channel, pMc->adc_user.trig_time);
          }
        }
      }
      else
      {
        if (((pMc->step_position&0x1) != 0) && (AdcMeasurement > pMc->bemf.adc_threshold_up))
        {
          {
            MC_Core_LfTimerPeriodCompute(pMc, LfTimerCounterSnapshot, 1);
            MC_Core_PrepareNextStep(pMc);
            MC_Core_LL_SelectAdcChannelDuringCallback(pMc->bemf.padc, pMc->adc_user.padc[pMc->adc_user.channel_index], pMc->adc_user.channel[pMc->adc_user.channel_index], pMc->adc_user.sampling_time[pMc->adc_user.channel_index]);
            MC_Core_LL_SetDutyCyclePwmForAdcTrig(pMc->adc_user.ptrig_timer, pMc->adc_user.trig_timer_channel, pMc->adc_user.trig_time);
          }
          pMc->bemf.consecutive_down_counter = 0;
        }
        if (((pMc->step_position&0x1) == 0) && (AdcMeasurement < pMc->bemf.adc_threshold_down))
        {
          {
            MC_Core_LfTimerPeriodCompute(pMc, LfTimerCounterSnapshot, 0);
            MC_Core_PrepareNextStep(pMc);
            MC_Core_LL_SelectAdcChannelDuringCallback(pMc->bemf.padc, pMc->adc_user.padc[pMc->adc_user.channel_index], pMc->adc_user.channel[pMc->adc_user.channel_index], pMc->adc_user.sampling_time[pMc->adc_user.channel_index]);
            MC_Core_LL_SetDutyCyclePwmForAdcTrig(pMc->adc_user.ptrig_timer, pMc->adc_user.trig_timer_channel, pMc->adc_user.trig_time);
          }
        }
      }
    }
    else
    {
      pMc->bemf.demagn_counter++;
    }
  }
  else if (pAdc == pMc->adc_user.padc[pMc->adc_user.channel_index])
</#if>
<#if MC.SIX_STEP_SENSING == "HALL_SENSORS"><#-- Hall Sensors usage -->
  if (pAdc == pMc->adc_user.padc[pMc->adc_user.channel_index])
</#if>
  {
    /* Process user measurement */
<#if MC.SIX_STEP_CONTROL_MODE == "VOLTAGE"><#-- Voltage Control mode usage -->
    if (pMc->step_change!=0)
    {
      pMc->step_change = 0;
    }
    else
    {
      pMc->adc_user.measurement[pMc->adc_user.channel_index] = AdcMeasurement;
    }
</#if>
<#if MC.SIX_STEP_CONTROL_MODE == "CURRENT"><#-- Current Control mode usage -->
    pMc->adc_user.measurement[pMc->adc_user.channel_index] = AdcMeasurement;
</#if>
  }
<#if MC.SIX_STEP_SENSING == "SENSORS_LESS"><#-- SensorLess usage -->
  else
  {
    pMc->status = MC_ADC_CALLBACK_FAILURE;
    MC_Core_LL_Error(pMc);
    return MC_FUNC_FAIL;
  }
</#if>
<#if MC.SIX_STEP_SENSING == "HALL_SENSORS"><#-- Hall Sensors usage -->
  (pMc->adc_user.channel_index)++;
  if (pMc->adc_user.channel_index == NUMBER_OF_USER_ADC_CHANNELS)
  {
    pMc->adc_user.channel_index = 0;
  }
  MC_Core_LL_SelectAdcChannel(pMc->adc_user.padc[tmp], pMc->adc_user.padc[pMc->adc_user.channel_index], \
                              pMc->adc_user.channel[pMc->adc_user.channel_index],pMc->adc_user.sampling_time[pMc->adc_user.channel_index]);
</#if>
  return MC_FUNC_OK; 
}

<#if MC.SIX_STEP_SENSING == "SENSORS_LESS"><#-- SensorLess usage -->
/**
  * @brief  MC_Core_NextStep
  * @param[in] pMc motor control handle
  * @param[in] HfTimerCounterSnapshot value of the HF timer counter at the beginning of the LF timer callback
  * @retval  Function Status
  */
MC_FuncStatus_t MC_Core_NextStep(MC_Handle_t *pMc, uint16_t HfTimerCounterSnapshot)
{
  pMc->lf_timer_period = MC_Core_LL_GetTimerPeriod(pMc->plf_timer);
	<#if MC.SIX_STEP_CONTROL_MODE == "VOLTAGE"><#-- Voltage Control mode usage -->
  (pMc->step_change)++;
	</#if>
  if (pMc->status == MC_RUN)
  {
    if (pMc->lf_timer_period == MC_LF_TIMER_MAX_PERIOD)
    {
      pMc->status = MC_LF_TIMER_FAILURE;
      MC_Core_LL_Error(pMc);
      return MC_FUNC_FAIL;
    }
    else if (pMc->bemf.consecutive_down_counter > RUN_CONSEC_BEMF_DOWN_MAX)
    {
      pMc->status = MC_SPEEDFBKERROR;
      MC_Core_LL_Error(pMc);
      return MC_FUNC_FAIL;
    }
    else
    {
      pMc->speed_fdbk_filtered = MC_Core_SpeedCompute(pMc);
      MC_Core_LL_SetPeriodTimer(pMc->plf_timer, MC_LF_TIMER_MAX_PERIOD);
    }
  }
  else if ((pMc->status == MC_STARTUP) || (pMc->status == MC_VALIDATION))
  {
    if (pMc->status == MC_STARTUP)
    {
      MC_Core_RampCalc(pMc);
    }    
    if (pMc->steps < VALIDATION_STEPS_MAX)
    {
      (pMc->steps)++;
    }
    else
    {
      pMc->status = MC_VALIDATION_FAILURE;
      MC_Core_LL_Error(pMc);
      return MC_FUNC_FAIL;
    }
  }
  if (pMc->step_prepared == 0)
  {
    pMc->bemf.zero_crossing_events = 0;
    MC_Core_PrepareNextStep(pMc);
  }
  MC_Core_LL_ToggleCommGpio(pMc->id);
	<#if MC.SIX_STEP_THREE_PWM == true><#-- Only the 3 High Side are driven by timer -->
  MC_Core_SixStepTable(pMc, pMc->pulse_value, pMc->step_pos_next);
	</#if>
  MC_Core_LL_GenerateComEvent(pMc->phf_timer);
  pMc->step_position = pMc->step_pos_next;
	<#if MC.SIX_STEP_THREE_PWM == false><#-- All the 6 High Side are driven by timer -->
  switch (pMc->step_position)
  {
    case 1:
    case 4:
    {
      pMc->bemf.current_adc_channel = pMc->bemf.adc_channel[2];
    }
    break;
    case 2:
    case 5:
    {
      pMc->bemf.current_adc_channel = pMc->bemf.adc_channel[1];
    }
    break;
    case 3:
    case 6:
    {
      pMc->bemf.current_adc_channel = pMc->bemf.adc_channel[0];
    }
    break;
  }
	</#if>
  if (pMc->status >= MC_VALIDATION)
  {
    MC_Core_LL_SelectAdcChannel(pMc->adc_user.padc[pMc->adc_user.channel_index], pMc->bemf.padc, pMc->bemf.current_adc_channel, pMc->bemf.sampling_time);
	<#if MC.SIX_STEP_CONTROL_MODE == "VOLTAGE"><#-- Voltage Control mode usage -->
    /* PWM ON sensing BEGIN 5 */
    if ((pMc->bemf.pwm_on_sensing_enabled == 0) && (pMc->pulse_value > pMc->bemf.pwm_on_sensing_en_thres))
    {
      (pMc->bemf.pwm_on_sensing_enabled)++;
      pMc->bemf.trig_time = pMc->bemf.pwm_on_sensing_trig_time;
      pMc->bemf.adc_threshold_up = RUN_BEMF_THRESHOLD_UP_ON;
      pMc->bemf.adc_threshold_down = RUN_BEMF_THRESHOLD_DOWN_ON;
      MC_Core_LL_ResetBemfGpio(pMc->id);
    }
    else if ((pMc->bemf.pwm_on_sensing_enabled == 1) && (pMc->pulse_value < pMc->bemf.pwm_on_sensing_dis_thres))
    {
      pMc->bemf.pwm_on_sensing_enabled = 0;
      pMc->bemf.trig_time = pMc->bemf.pwm_off_sensing_trig_time;
      pMc->bemf.adc_threshold_up = RUN_BEMF_THRESHOLD_UP;
      pMc->bemf.adc_threshold_down = RUN_BEMF_THRESHOLD_DOWN;
      MC_Core_LL_SetBemfGpio(pMc->id);
    }
    /* PWM ON sensing END 5 */
	</#if>
    MC_Core_LL_SetDutyCyclePwmForAdcTrig(pMc->bemf.ptrig_timer, pMc->bemf.trig_timer_channel, pMc->bemf.trig_time);
  }
  pMc->step_prepared = 0;
  return MC_FUNC_OK;
}

/**
  * @brief  MC_Core_RampCalc
  * @retval  Function Status
  */
MC_FuncStatus_t MC_Core_RampCalc(MC_Handle_t* pMc)
{
  if (pMc->speed_fdbk_filtered == 0)
  {
    int16_t lf_prescaler_value;
    lf_prescaler_value = (SysClockFrequency/(pMc->motor_charac.pole_pairs*pMc->acceleration*(((MC_LF_TIMER_MAX_PERIOD+1)*MC_NUMBER_OF_STEPS_IN_6STEP_ALGO)/MC_SECONDS_PER_MINUTE)))-1;
    if (lf_prescaler_value < 0)
    {
      return MC_FUNC_FAIL;
    }
    else
    { 
      pMc->lf_timer_prescaler = lf_prescaler_value;
      MC_Core_LL_SetPrescalerTimer(pMc->plf_timer, lf_prescaler_value);
      pMc->speed_fdbk_filtered += pMc->acceleration;
      pMc->lf_timer_period = (10*SysClockFrequency)/((uint32_t) (pMc->motor_charac.pole_pairs*pMc->speed_fdbk_filtered*((pMc->lf_timer_prescaler)+1)));
      MC_Core_LL_SetPeriodTimer(pMc->plf_timer, pMc->lf_timer_period);
      pMc->acceleration = STARTUP_ACCELERATION;
    }
  }
  else
  {
    if (pMc->speed_fdbk_filtered < pMc->speed_target_command)
    {
      uint16_t speed_increase = (10*pMc->acceleration)/(pMc->motor_charac.pole_pairs*pMc->speed_fdbk_filtered);
      if (speed_increase != 0)
      {
        pMc->speed_fdbk_filtered += speed_increase;
      }
      else
      {
        return MC_FUNC_FAIL;
      }
    }
    else
    {
      pMc->status = MC_VALIDATION;
      pMc->lf_timer_prescaler = RUN_LF_TIMER_PRESCALER;
      MC_Core_LL_SetPrescalerTimer(pMc->plf_timer, pMc->lf_timer_prescaler);
      MC_Core_LL_StartAdcIt(pMc->bemf.padc);
      for (uint32_t i = 0; i < NUMBER_OF_USER_ADC_CHANNELS; i++)
      {
        MC_Core_LL_StartAdcIt(pMc->adc_user.padc[i]);
      }
    }
    pMc->lf_timer_period = (10*SysClockFrequency)/((uint32_t) (pMc->motor_charac.pole_pairs*pMc->speed_fdbk_filtered*((pMc->lf_timer_prescaler)+1)));
    MC_Core_LL_SetPeriodTimer(pMc->plf_timer, pMc->lf_timer_period);
  }
  return MC_FUNC_OK;
}
</#if>
<#if MC.SIX_STEP_SENSING == "HALL_SENSORS"><#-- Hall Sensors usage -->
/**
  * @brief  MC_Core_NextStepScheduling
  * @param[in] pMc motor control handle
  * @retval  Function Status
  */
MC_FuncStatus_t MC_Core_NextStepScheduling(MC_Handle_t *pMc)
{
  pMc->lf_timer_period = MC_Core_LL_GetTimerCaptureCompare(pMc->plf_timer);
  MC_Core_LL_GetHallStatus(pMc);
  pMc->status = MC_RUN;
  MC_Core_LL_ToggleCommGpio(pMc->id);
  if (pMc->lf_timer_period >= MC_LF_TIMER_MAX_PERIOD)
  {
    pMc->status = MC_LF_TIMER_FAILURE;
    MC_Core_LL_Error(pMc);
    return MC_FUNC_FAIL;
  }
  else
  {
    pMc->speed_fdbk_filtered = MC_Core_SpeedCompute(pMc);
    MC_Core_LL_SetCompareHallTimer(pMc->plf_timer, pMc->hall.commutation_delay);
  }
  pMc->step_prepared = 0;
  return MC_FUNC_OK;
}
</#if>

/**
  * @brief  MC_Core_Reset
  * @retval  Function Status
  */
MC_FuncStatus_t MC_Core_Reset(MC_Handle_t *pMc)
{
  /* Motor parameters reset */
<#if MC.SIX_STEP_SENSING == "SENSORS_LESS"><#-- SensorLess usage -->
  if (pMc->bemf.padc != NULL)
  {
    pMc->bemf.adc_threshold_up = RUN_BEMF_THRESHOLD_UP;
    pMc->bemf.adc_threshold_down = RUN_BEMF_THRESHOLD_DOWN;
    pMc->bemf.over_threshold_events = 0;
    pMc->bemf.consecutive_down_counter = 0;
    pMc->bemf.demagn_counter = MC_BEMF_DEMAGN_COUNTER_INIT_VALUE;
    pMc->bemf.demagn_value = VALIDATION_DEMAGN_DELAY;
    pMc->bemf.demagn_coefficient = ((uint32_t) ((RUN_DEMAG_TIME_STEP_RATIO * MC_Core_LL_GetGateDrivingPwmFrequency(pMc->phf_timer)) / (100 * MOTOR_NUM_POLE_PAIRS)));
	<#if MC.SIX_STEP_THREE_PWM == false><#-- All the 6 High Side are driven by timer -->
    pMc->bemf.run_speed_thres_demag = RUN_SPEED_THRESHOLD_DEMAG;
    pMc->bemf.zcd_to_comm = RUN_ZCD_TO_COMM;
	</#if>
    pMc->bemf.zero_crossing_events = 0;
	<#if MC.SIX_STEP_CONTROL_MODE == "VOLTAGE"><#-- Voltage Control mode usage -->
    /* PWM ON sensing BEGIN 6 */
    pMc->bemf.pwm_on_sensing_enabled = 0;
    pMc->bemf.pwm_off_sensing_trig_time = MC_Core_ComputePulseValue(pMc, pMc->bemf.trig_timer_period, BEMF_ADC_TRIG_TIME);
    pMc->bemf.pwm_on_sensing_trig_time = MC_Core_ComputePulseValue(pMc, pMc->bemf.trig_timer_period, BEMF_ADC_TRIG_TIME_PWM_ON);
    pMc->bemf.pwm_on_sensing_en_thres = MC_Core_ComputePulseValue(pMc, pMc->bemf.trig_timer_period, BEMF_PWM_ON_ENABLE_THRES);
    pMc->bemf.pwm_on_sensing_dis_thres = MC_Core_ComputePulseValue(pMc, pMc->bemf.trig_timer_period, BEMF_PWM_ON_DISABLE_THRES);
    /* PWM ON sensing END 6 */
	</#if>
  }
  else
  {
    return MC_FUNC_FAIL;
  }
  pMc->acceleration = STARTUP_SPEED_MINIMUM;
</#if>
<#if MC.SIX_STEP_SENSING == "HALL_SENSORS"><#-- Hall Sensors usage -->
  pMc->acceleration = RUN_ACCELERATION;
</#if>
<#-- TODO: Can't we unified this code ? -->
<#if MC.SIX_STEP_THREE_PWM == false><#-- All the 6 High Side are driven by timer -->
  pMc->alignment_time = ALIGNMENT_TIME;
</#if>
  pMc->control_loop_time = RUN_CONTROL_LOOP_TIME;
  pMc->direction = STARTUP_DIRECTION;
<#if MC.SIX_STEP_SENSING == "SENSORS_LESS"><#-- SensorLess usage -->
  pMc->step_pos_next = ALIGNMENT_STEP;
  pMc->steps = 0;
</#if>
    
  /* Private variables reset */
  pMc->uw_tick_cnt = 0;  
  pMc->align_index = 0;
  pMc->lf_timer_period = MC_LF_TIMER_MAX_PERIOD;
  pMc->step_position = 0;
<#if MC.SIX_STEP_CONTROL_MODE == "VOLTAGE"><#-- Voltage Control mode usage -->
  pMc->step_change = 0;
</#if>
  pMc->step_prepared = 0;
  pMc->tick_cnt = 0;
  pMc->adc_user.channel_index = 0;

  /* Compute the location of the ADC USER measurement trigger in the trig timer period */
  MC_Core_SetAdcUserTrigTime(pMc, USER_ADC_TRIG_TIME);
<#if MC.SIX_STEP_SENSING == "SENSORS_LESS"><#-- SensorLess usage -->
  MC_Core_SetAdcBemfTrigTime(pMc, BEMF_ADC_TRIG_TIME);
</#if>
  
  /* Store the duty cycle to be programmed in MC_ALIGNMENT state */
  MC_Core_SetStartupDutyCycle(pMc, STARTUP_DUTY_CYCLE);
<#if MC.SIX_STEP_SPEED_LOOP == false><#-- NO Speed Loop usage -->
  /* Store the duty cycle to be latched at the first entry in MC_RUN state */
  MC_Core_SetDutyCycle(pMc, RUN_DUTY_CYCLE);
</#if>
  
  /* Speed variables reset */
  MC_Core_SpeedFeedbackReset(pMc);
  
  /* Speed PID regulator parameters */
  MC_Core_SpeedRegulatorReset(pMc);
  
  return MC_FUNC_OK;
}

<#if MC.SIX_STEP_SENSING == "SENSORS_LESS"><#-- SensorLess usage -->
/**
  * @brief  MC_Core_SetAdcBemfTrigTime
  * @param[in] DutyCycleToSet Duty cycle in 1/1024 of PWM period
  * @retval Function Status
  */
MC_FuncStatus_t MC_Core_SetAdcBemfTrigTime(MC_Handle_t* pMc, uint32_t DutyCycleToSet)
{
  pMc->bemf.trig_time = (uint16_t)((pMc->bemf.trig_timer_period*DutyCycleToSet) >> MC_DUTY_CYCLE_SCALING_SHIFT);  
  return MC_FUNC_OK; 
}
</#if>

/**
  * @brief  MC_Core_SetDutyCycle
  * @param[in] DutyCycleToSet Duty cycle in tenths of percentage of PWM period
  * @retval Function Status
  */
MC_FuncStatus_t MC_Core_SetDutyCycle(MC_Handle_t* pMc, uint32_t DutyCycleToSet)
{
<#if MC.SIX_STEP_CONTROL_MODE == "VOLTAGE"><#-- Voltage Control mode usage -->
  pMc->pulse_command = (uint16_t)((pMc->hf_timer_period*DutyCycleToSet) >> MC_DUTY_CYCLE_SCALING_SHIFT);
</#if>
<#if MC.SIX_STEP_CONTROL_MODE == "CURRENT"><#-- Current Control mode usage -->
  pMc->pulse_command = (uint16_t)((pMc->ref_timer_period*DutyCycleToSet) >> MC_DUTY_CYCLE_SCALING_SHIFT);
</#if>
<#if MC.SIX_STEP_SET_POINT_RAMPING == true><#-- Ramp usage -->
  pMc->reference_to_be_updated++;
</#if>
  return MC_FUNC_OK; 
}

/**
  * @brief  MC_Core_SetSpeed
  * @param[in] SpeedToSet
  * @retval Function Status
  */
MC_FuncStatus_t MC_Core_SetSpeed(MC_Handle_t *pMc, uint32_t SpeedToSet)
{
  pMc->speed_target_value = pMc->speed_target_command;
  pMc->speed_target_command = SpeedToSet;
<#if MC.SIX_STEP_SET_POINT_RAMPING == true><#-- Ramp usage -->
  pMc->reference_to_be_updated++;
</#if>
  return MC_FUNC_OK;
}

/**
  * @brief  MC_Core_SetStartupDutyCycle
  * @param[in] DutyCycleToSet Duty cycle in 1/1024 of PWM period
  * @retval Function Status
  */
MC_FuncStatus_t MC_Core_SetStartupDutyCycle(MC_Handle_t* pMc, uint32_t DutyCycleToSet)
{
<#if MC.SIX_STEP_CONTROL_MODE == "VOLTAGE"><#-- Voltage Control mode usage -->
  pMc->startup_reference = (uint16_t)((DutyCycleToSet * (pMc->hf_timer_period)) >> MC_DUTY_CYCLE_SCALING_SHIFT);
</#if>
<#if MC.SIX_STEP_CONTROL_MODE == "CURRENT"><#-- Current Control mode usage -->
  pMc->startup_reference = (uint16_t)((DutyCycleToSet * (pMc->ref_timer_period)) >> MC_DUTY_CYCLE_SCALING_SHIFT);
</#if>
  return MC_FUNC_OK; 
}


/**
  * @brief  MC_Core_Start
  * @param  None
  * @retval Function Status
  */
MC_FuncStatus_t MC_Core_Start(MC_Handle_t *pMc)
{ 
  if (pMc->status == MC_STOP)
  {
    pMc->button_user.enabled = 0;
    pMc->uw_tick_cnt = 0;
<#if MC.SIX_STEP_CONTROL_MODE == "CURRENT"><#-- Current Control mode usage -->
    pMc->hf_timer_pulse_value_max = (RUN_HF_TIMER_DUTY_CYCLE * (pMc->hf_timer_period)) >> MC_DUTY_CYCLE_SCALING_SHIFT;
</#if>
    pMc->pulse_value = pMc->startup_reference;
<#if MC.SIX_STEP_SENSING == "SENSORS_LESS"><#-- SensorLess usage -->
    MC_Core_LL_CalibrateAdc(pMc->bemf.padc);
</#if>
    for (uint32_t i = 0; i < NUMBER_OF_USER_ADC_CHANNELS; i++)
    {
      MC_Core_LL_CalibrateAdc(pMc->adc_user.padc[i]);
    }
<#if MC.SIX_STEP_SENSING == "SENSORS_LESS"><#-- SensorLess usage -->
    MC_Core_LL_SetDutyCyclePwmForAdcTrig(pMc->bemf.ptrig_timer, pMc->bemf.trig_timer_channel, pMc->bemf.trig_time);
    MC_Core_LL_ConfigureCommutationEvent(pMc->phf_timer, NULL);
</#if>
<#if MC.SIX_STEP_SENSING == "HALL_SENSORS"><#-- Hall Sensors usage -->
    MC_Core_LL_SetDutyCyclePwmForAdcTrig(pMc->adc_user.ptrig_timer, pMc->adc_user.trig_timer_channel, pMc->adc_user.trig_time);
</#if>
<#if MC.SIX_STEP_CONTROL_MODE == "VOLTAGE"><#-- Voltage Control mode usage -->
    if (pMc->pref_timer != NULL)
    {
      MC_Core_LL_SetDutyCycleRefPwm(pMc->pref_timer, pMc->ref_timer_period);
      MC_Core_LL_StartRefPwm(pMc->pref_timer);
    }
</#if>
<#if MC.SIX_STEP_CONTROL_MODE == "CURRENT"><#-- Current Control mode usage -->
    MC_Core_LL_SetDutyCycleRefPwm(pMc->pref_timer, pMc->pulse_value);
    MC_Core_LL_StartRefPwm(pMc->pref_timer);
</#if>
    pMc->status = MC_ALIGNMENT;
<#if MC.SIX_STEP_SENSING == "HALL_SENSORS"><#-- Hall Sensors usage -->
    pMc->hall.commutation_delay = RUN_COMMUTATION_DELAY;
    MC_Core_LL_GetHallStatus(pMc);
    MC_Core_LL_ConfigureCommutationEvent(pMc->phf_timer, pMc->plf_timer);    
    MC_Core_LL_EnableUpdateEvent(pMc->phf_timer);
    for (uint32_t i = 0; i < NUMBER_OF_USER_ADC_CHANNELS; i++)
    {
      MC_Core_LL_StartAdcIt(pMc->adc_user.padc[i]);
    }
    MC_Core_LL_SelectAdcChannel(pMc->adc_user.padc[pMc->adc_user.channel_index], pMc->adc_user.padc[pMc->adc_user.channel_index], pMc->adc_user.channel[pMc->adc_user.channel_index], pMc->adc_user.sampling_time[pMc->adc_user.channel_index]);
</#if>
  }
  return MC_FUNC_OK; 
}

/**
  * @brief  MC_Core_Stop
  * @param  None
  * @retval Function Status
  */
MC_FuncStatus_t MC_Core_Stop(MC_Handle_t *pMc)
{
  MC_Core_LL_DisableIrq();
  MC_Core_LL_StopTimerIt(pMc->plf_timer);
  MC_Core_LL_StopHfPwms(pMc->phf_timer);
<#if MC.SIX_STEP_THREE_PWM == true><#-- Only the 3 High Side are driven by timer -->
  MC_Core_LL_SetDutyCycleHfPwms(pMc->phf_timer, 0, 0, 0);
<#else>
  MC_Core_LL_SetDutyCycleHfPwmForStepN(pMc->phf_timer, 0, pMc->step_position);
</#if>
<#if MC.SIX_STEP_SENSING == "SENSORS_LESS"><#-- SensorLess usage -->
  MC_Core_LL_StopAdcIt(pMc->bemf.padc);
</#if>
  for (uint32_t i = 0; i < NUMBER_OF_USER_ADC_CHANNELS; i++)
  {
    MC_Core_LL_StopAdcIt(pMc->adc_user.padc[i]);
  }
<#if MC.SIX_STEP_CONTROL_MODE == "VOLTAGE"><#-- Voltage Control mode usage -->
  if (pMc->pref_timer != NULL)
  {
    MC_Core_LL_StopRefPwm(pMc->pref_timer);
  }
</#if>
<#if MC.SIX_STEP_CONTROL_MODE == "CURRENT"><#-- Current Control mode usage -->
  MC_Core_LL_StopRefPwm(pMc->pref_timer);
</#if>
  pMc->status = MC_STOP;
  pMc->button_user.enabled = 0;
  MC_Core_LL_EnableIrq();
  
  /* Motor parameters and private variable initialisation */
  MC_Core_Reset(pMc);
  
  return MC_FUNC_OK; 
}

/**
  * @} end MC_6STEP_CORE_Exported_Functions
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

/************************ (C) COPYRIGHT STMicroelectronics *****END OF FILE****/

