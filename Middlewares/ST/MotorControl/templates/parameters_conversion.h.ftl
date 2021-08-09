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
<#if configs[0].peripheralParams.get("RCC")??>
<#assign RCC = configs[0].peripheralParams.get("RCC")>
</#if>
<#if !RCC??>
<#stop "No RCC found">
</#if>
</#if>
<#function _remove_last_char text><#return text[0..text?length-2]></#function>
<#function _last_char text><#return text[text?length-1]></#function>
<#function _last_word text sep="_"><#return text?split(sep)?last></#function>

<#-- Condition for STM32F302x8x MCU -->
<#assign CondMcu_STM32F302x8x = (McuName?? && McuName?matches("STM32F302.8.*"))>
<#-- Condition for STM32F072xxx MCU -->
<#assign CondMcu_STM32F072xxx = (McuName?? && McuName?matches("STM32F072.*"))>
<#-- Condition for STM32F446xCx or STM32F446xEx -->
<#assign CondMcu_STM32F446xCEx = (McuName?? && McuName?matches("STM32F446.(C|E).*"))>
<#-- Condition for Line STM32F1xx Value -->
<#assign CondLine_STM32F1_Value = (McuName?? && (McuName?matches("STM32F100.(4|6|8|B).*")))>
<#-- Condition for Line STM32F1xx Value, Medium Density -->
<#assign CondLine_STM32F1_Value_MD = (McuName?? && (McuName?matches("STM32F100.(8|B).*")))>
<#-- Condition for Line STM32F1xx Performance -->
<#assign CondLine_STM32F1_Performance = (McuName?? && McuName?matches("STM32F103.(4|6|8|B).*"))>
<#-- Condition for Line STM32F1xx Performance, Medium Density -->
<#assign CondLine_STM32F1_Performance_MD = (McuName?? && McuName?matches("STM32F103.(8|B).*"))>
<#-- Condition for Line STM32F1xx High Density -->
<#assign CondLine_STM32F1_HD = (McuName?? && McuName?matches("STM32F103.(C|D|E|F|G).*"))>
<#-- Condition for STM32F0 Family -->
<#assign CondFamily_STM32F0 = (FamilyName?? && FamilyName=="STM32F0")>
<#-- Condition for STM32G0 Family -->
<#assign CondFamily_STM32G0 = (FamilyName?? && FamilyName=="STM32G0") >
<#-- Condition for STM32F1 Family -->
<#assign CondFamily_STM32F1 = (CondLine_STM32F1_Value || CondLine_STM32F1_Performance || CondLine_STM32F1_HD)>
<#-- Condition for STM32F3 Family -->
<#assign CondFamily_STM32F3 = (FamilyName?? && FamilyName == "STM32F3")>
<#-- Condition for STM32F4 Family -->
<#assign CondFamily_STM32F4 = (FamilyName?? && FamilyName == "STM32F4")>
<#-- Condition for STM32G4 Family -->
<#assign CondFamily_STM32G4 = (FamilyName?? && FamilyName == "STM32G4") >
<#-- Condition for STM32L4 Family -->
<#assign CondFamily_STM32L4 = (FamilyName?? && FamilyName == "STM32L4") >
<#-- Condition for STM32F7 Family -->
<#assign CondFamily_STM32F7 = (FamilyName?? && FamilyName == "STM32F7") >
<#-- Condition for STM32H7 Family -->
<#assign CondFamily_STM32H7 = (FamilyName?? && FamilyName == "STM32H7") >

/**
  ******************************************************************************
  * @file    parameters_conversion.h
  * @author  Motor Control SDK Team, ST Microelectronics
  * @brief   This file includes the proper Parameter conversion on the base
  *          of stdlib for the first drive
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
#ifndef __PARAMETERS_CONVERSION_H
#define __PARAMETERS_CONVERSION_H

#include "mc_math.h"
<#if CondFamily_STM32F0>
#include "parameters_conversion_f0xx.h"
<#elseif CondFamily_STM32F1>
#include "parameters_conversion_f10x.h"
<#elseif CondFamily_STM32F3>
#include "parameters_conversion_f30x.h"
<#elseif CondFamily_STM32F4>
#include "parameters_conversion_f4xx.h"
<#elseif CondFamily_STM32L4>
#include "parameters_conversion_l4xx.h"
<#elseif CondFamily_STM32F7>
#include "parameters_conversion_f7xx.h"
<#elseif CondFamily_STM32H7>
#include "parameters_conversion_h7xx.h"
<#elseif CondFamily_STM32G4>
#include "parameters_conversion_g4xx.h"
<#elseif CondFamily_STM32G0>
#include "parameters_conversion_g0xx.h"
</#if>
#include "pmsm_motor_parameters.h"
#include "drive_parameters.h"
#include "power_stage_parameters.h"

#define ADC_REFERENCE_VOLTAGE  ${MC.ADC_REFERENCE_VOLTAGE}

/************************* CONTROL FREQUENCIES & DELAIES **********************/
#define TF_REGULATION_RATE 	(uint32_t) ((uint32_t)(PWM_FREQUENCY)/(REGULATION_EXECUTION_RATE))

/* TF_REGULATION_RATE_SCALED is TF_REGULATION_RATE divided by PWM_FREQ_SCALING to allow more dynamic */ 
#define TF_REGULATION_RATE_SCALED (uint16_t) ((uint32_t)(PWM_FREQUENCY)/(REGULATION_EXECUTION_RATE*PWM_FREQ_SCALING))

/* DPP_CONV_FACTOR is introduce to compute the right DPP with TF_REGULATOR_SCALED  */
#define DPP_CONV_FACTOR (65536/PWM_FREQ_SCALING) 

#define REP_COUNTER 			(uint16_t) ((REGULATION_EXECUTION_RATE *2u)-1u)

#define SYS_TICK_FREQUENCY          2000
#define UI_TASK_FREQUENCY_HZ        10
#define SERIAL_COM_TIMEOUT_INVERSE  25
#define SERIAL_COM_ATR_TIME_MS 20

<#if MC.POSITION_CTRL_ENABLING == true >
#define MEDIUM_FREQUENCY_TASK_RATE	(uint16_t)POSITION_LOOP_FREQUENCY_HZ

#define INRUSH_CURRLIMIT_DELAY_COUNTS  (uint16_t)(INRUSH_CURRLIMIT_DELAY_MS * \
                                  ((uint16_t)POSITION_LOOP_FREQUENCY_HZ)/1000u -1u)

#define MF_TASK_OCCURENCE_TICKS  (SYS_TICK_FREQUENCY/POSITION_LOOP_FREQUENCY_HZ)-1u
<#else>
#define MEDIUM_FREQUENCY_TASK_RATE	(uint16_t)SPEED_LOOP_FREQUENCY_HZ

#define INRUSH_CURRLIMIT_DELAY_COUNTS  (uint16_t)(INRUSH_CURRLIMIT_DELAY_MS * \
                                  ((uint16_t)SPEED_LOOP_FREQUENCY_HZ)/1000u -1u)

#define MF_TASK_OCCURENCE_TICKS  (SYS_TICK_FREQUENCY/SPEED_LOOP_FREQUENCY_HZ)-1u
</#if>

#define UI_TASK_OCCURENCE_TICKS  (SYS_TICK_FREQUENCY/UI_TASK_FREQUENCY_HZ)-1u
#define SERIALCOM_TIMEOUT_OCCURENCE_TICKS (SYS_TICK_FREQUENCY/SERIAL_COM_TIMEOUT_INVERSE)-1u
#define SERIALCOM_ATR_TIME_TICKS (uint16_t)(((SYS_TICK_FREQUENCY * SERIAL_COM_ATR_TIME_MS) / 1000u) - 1u)

<#if MC.DUALDRIVE == true>
#define TF_REGULATION_RATE2 	(uint32_t) ((uint32_t)(PWM_FREQUENCY2)/REGULATION_EXECUTION_RATE2)

/* TF_REGULATION_RATE_SCALED2 is TF_REGULATION_RATE2 divided by PWM_FREQ_SCALING2 to allow more dynamic */ 
#define TF_REGULATION_RATE_SCALED2 (uint16_t) ((uint32_t)(PWM_FREQUENCY2)/(REGULATION_EXECUTION_RATE2*PWM_FREQ_SCALING2))

/* DPP_CONV_FACTOR2 is introduce to compute the right DPP with TF_REGULATOR_SCALED2  */
#define DPP_CONV_FACTOR2 (65536/PWM_FREQ_SCALING2) 

#define REP_COUNTER2 			(uint16_t) ((REGULATION_EXECUTION_RATE2 *2u)-1u)

<#if MC.POSITION_CTRL_ENABLING2 == true >
#define MEDIUM_FREQUENCY_TASK_RATE2	(uint16_t)POSITION_LOOP_FREQUENCY_HZ2

#define INRUSH_CURRLIMIT_DELAY_COUNTS2  (uint16_t)(INRUSH_CURRLIMIT_DELAY_MS2 * \
                                  ((uint16_t)POSITION_LOOP_FREQUENCY_HZ2)/1000u -1u)

<#else>
#define MEDIUM_FREQUENCY_TASK_RATE2	(uint16_t)SPEED_LOOP_FREQUENCY_HZ2

#define INRUSH_CURRLIMIT_DELAY_COUNTS2  (uint16_t)(INRUSH_CURRLIMIT_DELAY_MS2 * \
                                  ((uint16_t)SPEED_LOOP_FREQUENCY_HZ2)/1000u -1u)
</#if>

#define MF_TASK_OCCURENCE_TICKS2  (SYS_TICK_FREQUENCY/MEDIUM_FREQUENCY_TASK_RATE2)-1u
</#if>

<#if MC.STATE_OBSERVER_PLL ||  MC.AUX_STATE_OBSERVER_PLL || MC.STATE_OBSERVER_CORDIC || MC.AUX_STATE_OBSERVER_CORDIC >
/************************* COMMON OBSERVER PARAMETERS **************************/
#define MAX_BEMF_VOLTAGE  (uint16_t)((MAX_APPLICATION_SPEED_RPM * 1.2 *\
                           MOTOR_VOLTAGE_CONSTANT*SQRT_2)/(1000u*SQRT_3))
  <#if MC.BUS_VOLTAGE_READING>
/*max phase voltage, 0-peak Volts*/
#define MAX_VOLTAGE (int16_t)((ADC_REFERENCE_VOLTAGE/SQRT_3)/VBUS_PARTITIONING_FACTOR) 
  <#else>
#define MAX_VOLTAGE (int16_t)(500/2) /* Virtual sensor conversion factor */
  </#if>

  <#if MC.ICS_SENSORS> 
#define MAX_CURRENT (ADC_REFERENCE_VOLTAGE/(2*AMPLIFICATION_GAIN))
  <#else>
#define MAX_CURRENT (ADC_REFERENCE_VOLTAGE/(2*RSHUNT*AMPLIFICATION_GAIN))
  </#if>
#define OBS_MINIMUM_SPEED_UNIT    (uint16_t) ((OBS_MINIMUM_SPEED_RPM*SPEED_UNIT)/_RPM)  
</#if>

#define MAX_APPLICATION_SPEED_UNIT ((MAX_APPLICATION_SPEED_RPM*SPEED_UNIT)/_RPM)
#define MIN_APPLICATION_SPEED_UNIT ((MIN_APPLICATION_SPEED_RPM*SPEED_UNIT)/_RPM)

<#if MC.STATE_OBSERVER_PLL ||  MC.AUX_STATE_OBSERVER_PLL >
/************************* PLL PARAMETERS **************************/
#define C1 (int32_t)((((int16_t)F1)*RS)/(LS*TF_REGULATION_RATE))
#define C2 (int32_t) GAIN1
#define C3 (int32_t)((((int16_t)F1)*MAX_BEMF_VOLTAGE)/(LS*MAX_CURRENT*TF_REGULATION_RATE))
#define C4 (int32_t) GAIN2
#define C5 (int32_t)((((int16_t)F1)*MAX_VOLTAGE)/(LS*MAX_CURRENT*TF_REGULATION_RATE))

#define PERCENTAGE_FACTOR    (uint16_t)(VARIANCE_THRESHOLD*128u)      
#define HFI_MINIMUM_SPEED    (uint16_t) (HFI_MINIMUM_SPEED_RPM/6u)
</#if>
<#if MC.STATE_OBSERVER_CORDIC || MC.AUX_STATE_OBSERVER_CORDIC >  
/*********************** OBSERVER + CORDIC PARAMETERS *************************/
#define CORD_C1 (int32_t)((((int16_t)CORD_F1)*RS)/(LS*TF_REGULATION_RATE))
#define CORD_C2 (int32_t) CORD_GAIN1
#define CORD_C3 (int32_t)((((int16_t)CORD_F1)*MAX_BEMF_VOLTAGE)/(LS*MAX_CURRENT\
                                                           *TF_REGULATION_RATE))
#define CORD_C4 (int32_t) CORD_GAIN2
#define CORD_C5 (int32_t)((((int16_t)CORD_F1)*MAX_VOLTAGE)/(LS*MAX_CURRENT*\
                                                          TF_REGULATION_RATE))
#define CORD_PERCENTAGE_FACTOR    (uint16_t)(CORD_VARIANCE_THRESHOLD*128u)      
</#if>

<#if MC.STATE_OBSERVER_PLL2 ||  MC.AUX_STATE_OBSERVER_PLL2 || MC.STATE_OBSERVER_CORDIC2 || MC.AUX_STATE_OBSERVER_CORDIC2 >
/************************* COMMON OBSERVER PARAMETERS Motor 2 **************************/
#define MAX_BEMF_VOLTAGE2  (uint16_t)((MAX_APPLICATION_SPEED_RPM2 * 1.2 *\
                           MOTOR_VOLTAGE_CONSTANT2*SQRT_2)/(1000u*SQRT_3))

  <#if MC.BUS_VOLTAGE_READING2>
/*max phase voltage, 0-peak Volts*/
#define MAX_VOLTAGE2 (int16_t)((ADC_REFERENCE_VOLTAGE/SQRT_3)/VBUS_PARTITIONING_FACTOR2) 
  <#else>
#define MAX_VOLTAGE2 (int16_t)(500/2) /* Virtual sensor conversion factor */
  </#if>

  <#if MC.ICS_SENSORS2> 
#define MAX_CURRENT2 (ADC_REFERENCE_VOLTAGE/(2*AMPLIFICATION_GAIN2))
  <#else>
#define MAX_CURRENT2 (ADC_REFERENCE_VOLTAGE/(2*RSHUNT*AMPLIFICATION_GAIN2))
  </#if>
#define OBS_MINIMUM_SPEED_UNIT2        (uint16_t) ((OBS_MINIMUM_SPEED_RPM2*SPEED_UNIT)/_RPM)  
</#if>

#define MAX_APPLICATION_SPEED_UNIT2 ((MAX_APPLICATION_SPEED_RPM2*SPEED_UNIT)/_RPM)
#define MIN_APPLICATION_SPEED_UNIT2 ((MIN_APPLICATION_SPEED_RPM2*SPEED_UNIT)/_RPM)

<#if MC.STATE_OBSERVER_PLL2 ||  MC.AUX_STATE_OBSERVER_PLL2 >
/************************* PLL PARAMETERS **************************/
#define C12 (int32_t)((((int16_t)F12)*RS2)/(LS2*TF_REGULATION_RATE2))
#define C22 (int32_t) GAIN12
#define C32 (int32_t)((((int16_t)F12)*MAX_BEMF_VOLTAGE2)/(LS2*MAX_CURRENT2*TF_REGULATION_RATE2))
#define C42 (int32_t) GAIN22
#define C52 (int32_t)((((int16_t)F12)*MAX_VOLTAGE2)/(LS2*MAX_CURRENT2*TF_REGULATION_RATE2))

#define PERCENTAGE_FACTOR2    (uint16_t)(VARIANCE_THRESHOLD2*128u)      

#define HFI_MINIMUM_SPEED2        (uint16_t) (HFI_MINIMUM_SPEED_RPM2/6u)
</#if>

<#if MC.STATE_OBSERVER_CORDIC2 || MC.AUX_STATE_OBSERVER_CORDIC2 >  
#define CORD_C12 (int32_t)((((int16_t)CORD_F12)*RS2)/(LS2*TF_REGULATION_RATE2))
#define CORD_C22 (int32_t) CORD_GAIN12
#define CORD_C32 (int32_t)((((int16_t)CORD_F12)*MAX_BEMF_VOLTAGE2)/(LS2*MAX_CURRENT2\
                                                           *TF_REGULATION_RATE2))
#define CORD_C42 (int32_t) CORD_GAIN22
#define CORD_C52 (int32_t)((((int16_t)CORD_F12)*MAX_VOLTAGE2)/(LS2*MAX_CURRENT2*\
                                                          TF_REGULATION_RATE2))
#define CORD_PERCENTAGE_FACTOR2    (uint16_t)(CORD_VARIANCE_THRESHOLD2*128u)      
</#if>

/**************************   VOLTAGE CONVERSIONS  Motor 1 *************************/
#define OVERVOLTAGE_THRESHOLD_d   (uint16_t)(OV_VOLTAGE_THRESHOLD_V*65535/\
                                  (ADC_REFERENCE_VOLTAGE/VBUS_PARTITIONING_FACTOR))
#define UNDERVOLTAGE_THRESHOLD_d  (uint16_t)((UD_VOLTAGE_THRESHOLD_V*65535)/\
                                  ((uint16_t)(ADC_REFERENCE_VOLTAGE/\
                                                           VBUS_PARTITIONING_FACTOR)))
#define INT_SUPPLY_VOLTAGE          (uint16_t)(65536/ADC_REFERENCE_VOLTAGE)

#define DELTA_TEMP_THRESHOLD        (OV_TEMPERATURE_THRESHOLD_C- T0_C)
#define DELTA_V_THRESHOLD           (dV_dT * DELTA_TEMP_THRESHOLD)
#define OV_TEMPERATURE_THRESHOLD_d  ((V0_V + DELTA_V_THRESHOLD)*INT_SUPPLY_VOLTAGE)

#define DELTA_TEMP_HYSTERESIS        (OV_TEMPERATURE_HYSTERESIS_C)
#define DELTA_V_HYSTERESIS           (dV_dT * DELTA_TEMP_HYSTERESIS)
#define OV_TEMPERATURE_HYSTERESIS_d  (DELTA_V_HYSTERESIS*INT_SUPPLY_VOLTAGE)
<#if MC.DUALDRIVE == true>
/**************************   VOLTAGE CONVERSIONS  Motor 2 *************************/
#define OVERVOLTAGE_THRESHOLD_d2   (uint16_t)(OV_VOLTAGE_THRESHOLD_V2*65535/\
                                  (ADC_REFERENCE_VOLTAGE/VBUS_PARTITIONING_FACTOR2))
#define UNDERVOLTAGE_THRESHOLD_d2  (uint16_t)((UD_VOLTAGE_THRESHOLD_V2*65535)/\
                                  ((uint16_t)(ADC_REFERENCE_VOLTAGE/\
                                                           VBUS_PARTITIONING_FACTOR2)))
#define INT_SUPPLY_VOLTAGE2          (uint16_t)(65536/ADC_REFERENCE_VOLTAGE)

#define DELTA_TEMP_THRESHOLD2        (OV_TEMPERATURE_THRESHOLD_C2- T0_C2)
#define DELTA_V_THRESHOLD2           (dV_dT2 * DELTA_TEMP_THRESHOLD2)
#define OV_TEMPERATURE_THRESHOLD_d2  ((V0_V2 + DELTA_V_THRESHOLD2)*INT_SUPPLY_VOLTAGE2)

#define DELTA_TEMP_HYSTERESIS2        (OV_TEMPERATURE_HYSTERESIS_C2)
#define DELTA_V_HYSTERESIS2           (dV_dT2 * DELTA_TEMP_HYSTERESIS2)
#define OV_TEMPERATURE_HYSTERESIS_d2  (DELTA_V_HYSTERESIS2*INT_SUPPLY_VOLTAGE2)
</#if>

<#if ( MC.ENCODER2 == true ||  MC.AUX_ENCODER2 == true)>
/*************** Encoder Alignemnt ************************/    
#define ALIGNMENT_ANGLE_S162      (int16_t)  (ALIGNMENT_ANGLE_DEG2*65536u/360u)
</#if>

<#if ( MC.ENCODER == true ||  MC.AUX_ENCODER == true)>
#define ALIGNMENT_ANGLE_S16      (int16_t)  (ALIGNMENT_ANGLE_DEG*65536u/360u)
</#if>

<#if MC.MOTOR_PROFILER == true>
#undef MAX_APPLICATION_SPEED_RPM
#define MAX_APPLICATION_SPEED_RPM 50000
#undef F1
#define F1 0
#undef CORD_F1
#define CORD_F1 0

#define SPEED_REGULATOR_BANDWIDTH 0 // Dummy value

#define LDLQ_RATIO              1.000 /*!< Ld vs Lq ratio.*/

<#-- X-NUCLEO-IHM07M1 -->
<#if MC.PWBDID == "2"> 
#define CALIBRATION_FACTOR            1.50
#define BUS_VOLTAGE_CONVERSION_FACTOR 63.2
#define CURRENT_REGULATOR_BANDWIDTH     6000
#define MP_KP 10.00f
#define MP_KI 0.1f
#define DC_CURRENT_RS_MEAS      2.10 /*!< Maxium level of DC current used */
#define I_THRESHOLD                   0.05
</#if>
<#-- X-NUCLEO-IHM16M1 -->
<#if MC.PWBDID == "3" || MC.PWBDID == "53"> 
#define CALIBRATION_FACTOR            1.50
#define BUS_VOLTAGE_CONVERSION_FACTOR 63.2
#define CURRENT_REGULATOR_BANDWIDTH     6000
#define MP_KP 10.00f
#define MP_KI 0.1f
#define DC_CURRENT_RS_MEAS      2.10 /*!< Maxium level of DC current used */
#define I_THRESHOLD                   0.05
</#if>
<#-- X-NUCLEO-IHM08M1 -->
<#if MC.PWBDID == "4"> 
#define CALIBRATION_FACTOR            0.02
#define BUS_VOLTAGE_CONVERSION_FACTOR 63.2
#define CURRENT_REGULATOR_BANDWIDTH      6000
#define MP_KP 1.00f
#define MP_KI 0.01f
#define DC_CURRENT_RS_MEAS      2.10 /*!< Maxium level of DC current used */
#define I_THRESHOLD                   0.5
</#if>
<#-- B-G431B-ESC1 -->
<#if MC.PWBDID == "10015"> 
#define CALIBRATION_FACTOR           0.181
#define BUS_VOLTAGE_CONVERSION_FACTOR 34.29
#define CURRENT_REGULATOR_BANDWIDTH   6000
#define MP_KP 1.00f
#define MP_KI 0.01f
#define DC_CURRENT_RS_MEAS      2.10 /*!< Maxium level of DC current used */
#define I_THRESHOLD                   0.5
</#if>
<#-- STEVAL-IHM023V3 LV -->
<#if MC.PWBDID == "6"> 
#define CALIBRATION_FACTOR            	 0.67            
#define BUS_VOLTAGE_CONVERSION_FACTOR 	 447.903
#define CURRENT_REGULATOR_BANDWIDTH      6000
#define MP_KP 5.00f
#define MP_KI 0.05f
#define DC_CURRENT_RS_MEAS      2.10 /*!< Maxium level of DC current used */
#define I_THRESHOLD                   0.5
</#if>
<#-- STEVAL-IHM028V2 3Sh -->
<#if MC.PWBDID == "8"> 
#define CALIBRATION_FACTOR            	 0.3            
#define BUS_VOLTAGE_CONVERSION_FACTOR 	 415.800
#define CURRENT_REGULATOR_BANDWIDTH      2000
#define MP_KP 5.00f
#define MP_KI 0.05f
#define DC_CURRENT_RS_MEAS      2.10 /*!< Maxium level of DC current used */
#define I_THRESHOLD                   0.5
</#if>
<#-- STEVAL-IPM05F 3 Sh -->
<#if MC.PWBDID == "10"> 
#define CALIBRATION_FACTOR            	 0.5            
#define BUS_VOLTAGE_CONVERSION_FACTOR 	 415.800
#define CURRENT_REGULATOR_BANDWIDTH      3000
#define MP_KP 5.00f
#define MP_KI 0.05f
#define DC_CURRENT_RS_MEAS      2.10 /*!< Maxium level of DC current used */
#define I_THRESHOLD                   0.05
</#if>
<#-- STEVAL-IPM10B 3 Sh -->
<#if MC.PWBDID == "16"> 
#define CALIBRATION_FACTOR            	 0.5            
#define BUS_VOLTAGE_CONVERSION_FACTOR 	 415.800
#define CURRENT_REGULATOR_BANDWIDTH      2000
#define MP_KP 5.00f
#define MP_KI 0.05f
#define DC_CURRENT_RS_MEAS      2.10 /*!< Maxium level of DC current used */
#define I_THRESHOLD                   0.05
</#if>
<#-- STEVAL-IPM15B 3 Sh -->
<#if MC.PWBDID == "18"> 
#define CALIBRATION_FACTOR            	 0.5           
#define BUS_VOLTAGE_CONVERSION_FACTOR 	 415.800
#define CURRENT_REGULATOR_BANDWIDTH      2000
#define MP_KP 1.66f
#define MP_KI 0.01f
#define DC_CURRENT_RS_MEAS      2.10 /*!< Maxium level of DC current used */
#define I_THRESHOLD                   0.05
</#if>
<#-- STEVAL-IHM025V1 3Sh -->
<#if MC.PWBDID == "24"> 
#define CALIBRATION_FACTOR            	 0.90            
#define BUS_VOLTAGE_CONVERSION_FACTOR 	 415.800
#define CURRENT_REGULATOR_BANDWIDTH      2000
#define MP_KP 5.00f
#define MP_KI 0.05f
#define DC_CURRENT_RS_MEAS      2.10 /*!< Maxium level of DC current used */
#define I_THRESHOLD                   0.5
</#if>
<#-- STEVAL-IHM023V3 3Sh HV -->
<#if MC.PWBDID == "30"> 
#define CALIBRATION_FACTOR            	 0.67            
#define BUS_VOLTAGE_CONVERSION_FACTOR 	 447.903
#define CURRENT_REGULATOR_BANDWIDTH      2000
#define MP_KP 5.00f
#define MP_KI 0.05f
#define DC_CURRENT_RS_MEAS      2.95 /*!< Maxium level of DC current used */
#define I_THRESHOLD                   0.5
</#if>
<#-- STEVAL-IPMN3GQ 3Sh  -->
<#if MC.PWBDID == "38" > 
#define CALIBRATION_FACTOR            	 1.03            
#define BUS_VOLTAGE_CONVERSION_FACTOR 	 416.9
#define CURRENT_REGULATOR_BANDWIDTH      3000
#define MP_KP 5.00f
#define MP_KI 0.05f
#define DC_CURRENT_RS_MEAS      2.95 /*!< Maxium level of DC current used */
#define I_THRESHOLD                   0.05
</#if>
<#-- STEVAL-IPMNM1N 3Sh  -->
<#if MC.PWBDID == "44" > 
#define CALIBRATION_FACTOR            	 1.03           
#define BUS_VOLTAGE_CONVERSION_FACTOR 	 416.9
#define CURRENT_REGULATOR_BANDWIDTH      3000
#define MP_KP 5.00f
#define MP_KI 0.05f
#define DC_CURRENT_RS_MEAS      1.00 /*!< Maxium level of DC current used */
#define I_THRESHOLD                   0.05
</#if>


</#if> <#-- MC.MOTOR_PROFILER -->

/*************** Timer for PWM generation & currenst sensing parameters  ******/
#define PWM_PERIOD_CYCLES (uint16_t)(ADV_TIM_CLK_MHz*\
                                      (unsigned long long)1000000u/((uint16_t)(PWM_FREQUENCY)))
<#if MC.DUALDRIVE == true>
#define PWM_PERIOD_CYCLES2 (uint16_t)(ADV_TIM_CLK_MHz2*\
                                      (unsigned long long)1000000u/((uint16_t)(PWM_FREQUENCY2)))
</#if>

<#if MC.LOW_SIDE_SIGNALS_ENABLING == 'LS_PWM_TIMER'>
#define DEADTIME_NS  SW_DEADTIME_NS
<#else>
#define DEADTIME_NS  HW_DEAD_TIME_NS
</#if>
<#if MC.DUALDRIVE == true>
<#if MC.LOW_SIDE_SIGNALS_ENABLING2 == 'LS_PWM_TIMER'>
#define DEADTIME_NS2  SW_DEADTIME_NS2
<#else>
#define DEADTIME_NS2  HW_DEAD_TIME_NS2
</#if>
</#if>

#define DEAD_TIME_ADV_TIM_CLK_MHz (ADV_TIM_CLK_MHz * TIM_CLOCK_DIVIDER)
#define DEAD_TIME_COUNTS_1  (DEAD_TIME_ADV_TIM_CLK_MHz * DEADTIME_NS/1000uL)

#if (DEAD_TIME_COUNTS_1 <= 255)
#define DEAD_TIME_COUNTS (uint16_t) DEAD_TIME_COUNTS_1
#elif (DEAD_TIME_COUNTS_1 <= 508)
#define DEAD_TIME_COUNTS (uint16_t)(((DEAD_TIME_ADV_TIM_CLK_MHz * DEADTIME_NS/2) /1000uL) + 128)
#elif (DEAD_TIME_COUNTS_1 <= 1008)
#define DEAD_TIME_COUNTS (uint16_t)(((DEAD_TIME_ADV_TIM_CLK_MHz * DEADTIME_NS/8) /1000uL) + 320)
#elif (DEAD_TIME_COUNTS_1 <= 2015)
#define DEAD_TIME_COUNTS (uint16_t)(((DEAD_TIME_ADV_TIM_CLK_MHz * DEADTIME_NS/16) /1000uL) + 384)
#else
#define DEAD_TIME_COUNTS 510
#endif
<#if MC.DUALDRIVE == true>
#define DEAD_TIME_ADV_TIM_CLK_MHz2 (ADV_TIM_CLK_MHz2 * TIM_CLOCK_DIVIDER2)
#define DEAD_TIME_COUNTS2_1  (DEAD_TIME_ADV_TIM_CLK_MHz2 * DEADTIME_NS2/1000uL)

#if (DEAD_TIME_COUNTS2_1 <= 255)
#define DEAD_TIME_COUNTS2 (uint16_t) DEAD_TIME_COUNTS2_1
#elif (DEAD_TIME_COUNTS2_1 <= 508)
#define DEAD_TIME_COUNTS2 (uint16_t)(((DEAD_TIME_ADV_TIM_CLK_MHz2 * DEADTIME_NS2/2) /1000uL) + 128)
#elif (DEAD_TIME_COUNTS2_1 <= 1008)
#define DEAD_TIME_COUNTS2 (uint16_t)(((DEAD_TIME_ADV_TIM_CLK_MHz2 * DEADTIME_NS2/8) /1000uL) + 320)
#elif (DEAD_TIME_COUNTS2_1 <= 2015)
#define DEAD_TIME_COUNTS2 (uint16_t)(((DEAD_TIME_ADV_TIM_CLK_MHz2 * DEADTIME_NS2/16) /1000uL) + 384)
#else
#define DEAD_TIME_COUNTS2 510
#endif
</#if>

#define DTCOMPCNT (uint16_t)((DEADTIME_NS * ADV_TIM_CLK_MHz) / 2000)
#define TON_NS  500
#define TOFF_NS 500
#define TON  (uint16_t)((TON_NS * ADV_TIM_CLK_MHz)  / 2000)
#define TOFF (uint16_t)((TOFF_NS * ADV_TIM_CLK_MHz) / 2000)
<#if MC.DUALDRIVE == true>
#define DTCOMPCNT2 (uint16_t)((DEADTIME_NS2 * ADV_TIM_CLK_MHz2) / 2000)
#define TON_NS2  500
#define TOFF_NS2 500
#define TON2  (uint16_t)((TON_NS2 * ADV_TIM_CLK_MHz2)  / 2000)
#define TOFF2 (uint16_t)((TOFF_NS2 * ADV_TIM_CLK_MHz2) / 2000)
</#if>
/**********************/
/* MOTOR 1 ADC Timing */
/**********************/
#define SAMPLING_TIME ((ADC_SAMPLING_CYCLES * ADV_TIM_CLK_MHz) / ADC_CLK_MHz) /* In ADV_TIMER CLK cycles*/
<#if MC.SINGLE_SHUNT >
#define TRISE ((TRISE_NS * ADV_TIM_CLK_MHz)/1000uL)
#define TDEAD ((uint16_t)((DEADTIME_NS * ADV_TIM_CLK_MHz)/1000uL))
#define TAFTER ((uint16_t)(TDEAD + TRISE))
#define TBEFORE ((uint16_t)((ADC_TRIG_CONV_LATENCY_CYCLES + ADC_SAMPLING_CYCLES) * ADV_TIM_CLK_MHz) / ADC_CLK_MHz  + 1u)
#define TMIN ((uint16_t)( TAFTER + TBEFORE ))
#define HTMIN ((uint16_t)(TMIN >> 1))
#define CHTMIN ((uint16_t)(TMIN/(REGULATION_EXECUTION_RATE*2)))
#if (TRISE > SAMPLING_TIME)
#define MAX_TRTS (2 * TRISE)
#else
#define MAX_TRTS (2 * SAMPLING_TIME)
#endif
<#else>
#define HTMIN 1 /* Required for main.c compilation only, CCR4 is overwritten at runtime */
#define TW_BEFORE ((uint16_t)((ADC_TRIG_CONV_LATENCY_CYCLES + ADC_SAMPLING_CYCLES) * ADV_TIM_CLK_MHz) / ADC_CLK_MHz  + 1u)
#define TW_BEFORE_R3_1 ((uint16_t)((ADC_TRIG_CONV_LATENCY_CYCLES + ADC_SAMPLING_CYCLES*2 + ADC_SAR_CYCLES) * ADV_TIM_CLK_MHz) / ADC_CLK_MHz  + 1u)
#define TW_AFTER ((uint16_t)(((DEADTIME_NS+MAX_TNTR_NS)*ADV_TIM_CLK_MHz)/1000ul))
#define MAX_TWAIT ((uint16_t)((TW_AFTER - SAMPLING_TIME)/2))
</#if>

<#if MC.DUALDRIVE == true>
/**********************/
/* MOTOR 2 ADC Timing */
/**********************/
#define SAMPLING_TIME2 ((ADC_SAMPLING_CYCLES2 * ADV_TIM_CLK_MHz2) / ADC_CLK_MHz2) /* In ADV_TIMER2 CLK cycles*/ 
<#if MC.SINGLE_SHUNT2 >
#define TRISE2 (((TRISE_NS2) * ADV_TIM_CLK_MHz2)/1000uL)
#define TDEAD2 ((uint16_t)((DEADTIME_NS2 * ADV_TIM_CLK_MHz2)/1000uL))
#define TAFTER2 ((uint16_t)( TDEAD2 + TRISE2 ))
#define TBEFORE2 ((uint16_t)((ADC_TRIG_CONV_LATENCY_CYCLES + ADC_SAMPLING_CYCLES2 ) * ADV_TIM_CLK_MHz2) / ADC_CLK_MHz2  + 1u)
#define TMIN2  (TAFTER2 + TBEFORE2)
#define HTMIN2 (uint16_t)(TMIN2 >> 1)
#define CHTMIN2 (uint16_t)(TMIN2/(REGULATION_EXECUTION_RATE2*2))
#if (TRISE2 > SAMPLING_TIME2)
#define MAX_TRTS2 (2 * TRISE2)
#else
#define MAX_TRTS2 (2 * SAMPLING_TIME2)
#endif
<#else>
#define HTMIN2 0 /* Required for main.c compilation only, CCR4 is overwritten at runtime */
#define TW_BEFORE2 ((uint16_t)((ADC_TRIG_CONV_LATENCY_CYCLES + ADC_SAMPLING_CYCLES2) * ADV_TIM_CLK_MHz2) / ADC_CLK_MHz2  + 1u)
#define TW_AFTER2 ((uint16_t)(((DEADTIME_NS2+MAX_TNTR_NS2)*ADV_TIM_CLK_MHz2)/1000ul))
#define MAX_TWAIT2 ((uint16_t)((TW_AFTER2 - SAMPLING_TIME2)/2))
</#if>
</#if> <#-- MC.DUALDRIVE -->

/* USER CODE BEGIN temperature */

#define M1_VIRTUAL_HEAT_SINK_TEMPERATURE_VALUE   25u
#define M1_TEMP_SW_FILTER_BW_FACTOR      250u

/* USER CODE END temperature */

<#if  MC.FLUX_WEAKENING_ENABLING || MC.FEED_FORWARD_CURRENT_REG_ENABLING >
/* Flux Weakening - Feed forward */
#define M1_VQD_SW_FILTER_BW_FACTOR       128u
#define M1_VQD_SW_FILTER_BW_FACTOR_LOG LOG2(M1_VQD_SW_FILTER_BW_FACTOR)
</#if>

<#if MC.DUALDRIVE == true>
/* USER CODE BEGIN temperature M2*/

#define M2_VIRTUAL_HEAT_SINK_TEMPERATURE_VALUE   25u
#define M2_TEMP_SW_FILTER_BW_FACTOR     250u

/* USER CODE END temperature M2*/
<#if  MC.FLUX_WEAKENING_ENABLING2 || MC.FEED_FORWARD_CURRENT_REG_ENABLING2 >
/* Flux Weakening - Feed forward Motor 2*/
#define M2_VQD_SW_FILTER_BW_FACTOR      128u
#define M2_VQD_SW_FILTER_BW_FACTOR_LOG LOG2(M2_VQD_SW_FILTER_BW_FACTOR)
</#if>
</#if>

<#if MC.ICS_SENSORS>
#define PQD_CONVERSION_FACTOR (int32_t)(( 1000 * 3 * ADC_REFERENCE_VOLTAGE ) /\
             ( 1.732 * AMPLIFICATION_GAIN ))
<#else>
#define PQD_CONVERSION_FACTOR (int32_t)(( 1000 * 3 * ADC_REFERENCE_VOLTAGE ) /\
             ( 1.732 * RSHUNT * AMPLIFICATION_GAIN ))
</#if>
<#if MC.DUALDRIVE == true>
<#if MC.ICS_SENSORS2>
#define PQD_CONVERSION_FACTOR2 (int32_t)(( 1000 * 3 * ADC_REFERENCE_VOLTAGE ) /\
             ( 1.732 * AMPLIFICATION_GAIN2 ))
<#else>
#define PQD_CONVERSION_FACTOR2 (int32_t)(( 1000 * 3 * ADC_REFERENCE_VOLTAGE ) /\
             ( 1.732 * RSHUNT2 * AMPLIFICATION_GAIN2 ))
</#if>
</#if>
<#if MC.DUALDRIVE == true>
<#-- If this check really needed? -->
<#if MC.FREQ_RELATION ==  'HIGHEST_FREQ'> 
<#-- First instance has higher frequency --> 
#define PWM_FREQUENCY_CHECK_RATIO   (PWM_FREQUENCY*10000u/PWM_FREQUENCY2)
<#else> 
<#-- Second instance has higher frequency -->
#define PWM_FREQUENCY_CHECK_RATIO   (PWM_FREQUENCY2*10000u/PWM_FREQUENCY)
</#if>

#define MAGN_FREQ_RATIO   (${MC.FREQ_RATIO}*10000u)

#if (PWM_FREQUENCY_CHECK_RATIO != MAGN_FREQ_RATIO)
#error "The two motor PWM frequencies should be integer multiple"  
#endif

</#if>
<#-- Workaround not true for all series, need to be removed once WB will use real name UART or USART-->
<#function UartHandler uart>
<#if (uart?number < 4) || (uart?number > 5) >
  <#return "USART${uart}_IRQHandler">
<#else>
  <#return "UART${uart}_IRQHandler">
</#if>   
</#function>

#define USART_IRQHandler ${UartHandler (_last_char(MC.USART_SELECTION))}

/****** Prepares the UI configurations according the MCconfxx settings ********/
<#if MC.SERIAL_COMMUNICATION>
#define COM_ENABLE | OPT_COM
<#else>
#define COM_ENABLE
</#if>

<#if MC.DAC_FUNCTIONALITY == true>
#define DAC_ENABLE | OPT_DAC
#define DAC_OP_ENABLE | UI_CFGOPT_DAC
<#else>
#define DAC_ENABLE
#define DAC_OP_ENABLE
</#if>

/* Motor 1 settings */
<#if MC.FLUX_WEAKENING_ENABLING>
#define FW_ENABLE | UI_CFGOPT_FW
<#else>
#define FW_ENABLE
</#if>

<#if MC.DIFFERENTIAL_TERM_ENABLED>
#define DIFFTERM_ENABLE | UI_CFGOPT_SPEED_KD | UI_CFGOPT_Iq_KD | UI_CFGOPT_Id_KD
<#else>
#define DIFFTERM_ENABLE
</#if>
<#if MC.DUALDRIVE == true>
/* Motor 2 settings */
<#if MC.FLUX_WEAKENING_ENABLING2>
#define FW_ENABLE2 | UI_CFGOPT_FW
<#else>
#define FW_ENABLE2
</#if>

<#if MC.DIFFERENTIAL_TERM_ENABLED2>
#define DIFFTERM_ENABLE2 | UI_CFGOPT_SPEED_KD | UI_CFGOPT_Iq_KD | UI_CFGOPT_Id_KD
<#else>
#define DIFFTERM_ENABLE2
</#if>
</#if>

/* Sensors setting */
<#-- All this could be simpler... -->
<#if MC.STATE_OBSERVER_PLL>
#define MAIN_SCFG UI_SCODE_STO_PLL
</#if>

<#if MC.STATE_OBSERVER_CORDIC>
#define MAIN_SCFG UI_SCODE_STO_CR
</#if>

<#if MC.AUX_STATE_OBSERVER_PLL>
#define AUX_SCFG UI_SCODE_STO_PLL
</#if>

<#if MC.AUX_STATE_OBSERVER_CORDIC>
#define AUX_SCFG UI_SCODE_STO_CR
</#if>

<#if MC.ENCODER>
#define MAIN_SCFG UI_SCODE_ENC
</#if>

<#if MC.HFINJECTION>
#define MAIN_SCFG UI_SCODE_HFINJ
</#if>

<#if MC.AUX_ENCODER>
#define AUX_SCFG UI_SCODE_ENC
</#if>

<#if MC.HALL_SENSORS>
#define MAIN_SCFG UI_SCODE_HALL
</#if>

<#if MC.AUX_HALL_SENSORS>
#define AUX_SCFG UI_SCODE_HALL
</#if>

<#if MC.AUX_STATE_OBSERVER_CORDIC == false && MC.AUX_STATE_OBSERVER_PLL==false && MC.AUX_ENCODER == false && MC.AUX_HALL_SENSORS==false>
#define AUX_SCFG 0x0
</#if>
<#if MC.DUALDRIVE == true>
<#if MC.STATE_OBSERVER_PLL2>
#define MAIN_SCFG2 UI_SCODE_STO_PLL
</#if>

<#if MC.STATE_OBSERVER_CORDIC2>
#define MAIN_SCFG2 UI_SCODE_STO_CR
</#if>

<#if MC.AUX_STATE_OBSERVER_PLL2>
#define AUX_SCFG2 UI_SCODE_STO_PLL
</#if>

<#if MC.AUX_STATE_OBSERVER_CORDIC2>
#define AUX_SCFG2 UI_SCODE_STO_CR
</#if>

<#if MC.ENCODER2>
#define MAIN_SCFG2 UI_SCODE_ENC
</#if>

<#if MC.HFINJECTION2>
#define MAIN_SCFG2 UI_SCODE_HFINJ
</#if>

<#if MC.AUX_ENCODER2>
#define AUX_SCFG2 UI_SCODE_ENC
</#if>

<#if MC.HALL_SENSORS2>
#define MAIN_SCFG2 UI_SCODE_HALL
</#if>

<#if MC.AUX_HALL_SENSORS2>
#define AUX_SCFG2 UI_SCODE_HALL
</#if>

<#if MC.AUX_STATE_OBSERVER_CORDIC2 == false && MC.AUX_STATE_OBSERVER_PLL2==false && MC.AUX_ENCODER2 == false && MC.AUX_HALL_SENSORS2==false>
#define AUX_SCFG2 0x0
</#if>
</#if>

<#-- Seems Useless -->
<#if MC.PLLTUNING?? && MC.PLLTUNING==true>
#define PLLTUNING_ENABLE | UI_CFGOPT_PLLTUNING
<#else>
#define PLLTUNING_ENABLE
</#if>
<#if MC.DUALDRIVE == true>
<#if MC.PLLTUNING?? && MC.PLLTUNING==true>
#define PLLTUNING_ENABLE2 | UI_CFGOPT_PLLTUNING
<#else>
#define PLLTUNING_ENABLE2
</#if>
</#if>

<#if MC.PFC_ENABLED>
#define UI_CFGOPT_PFC_ENABLE | UI_CFGOPT_PFC
<#else>
#define UI_CFGOPT_PFC_ENABLE
</#if>

/******************************************************************************* 
  * UI configurations settings. It can be manually overwritten if special 
  * configuartion is required. 
*******************************************************************************/

/* Specific options of UI */
#define UI_CONFIG_M1 ( UI_CFGOPT_NONE DAC_OP_ENABLE FW_ENABLE DIFFTERM_ENABLE \
  | (MAIN_SCFG << MAIN_SCFG_POS) | (AUX_SCFG << AUX_SCFG_POS) | UI_CFGOPT_SETIDINSPDMODE PLLTUNING_ENABLE UI_CFGOPT_PFC_ENABLE | UI_CFGOPT_PLLTUNING)

<#if MC.SINGLEDRIVE>
#define UI_CONFIG_M2
<#else>
/* Specific options of UI, Motor 2 */
#define UI_CONFIG_M2 ( UI_CFGOPT_NONE DAC_OP_ENABLE FW_ENABLE DIFFTERM_ENABLE2 \
  | (MAIN_SCFG2 << MAIN_SCFG_POS) | (AUX_SCFG2 << AUX_SCFG_POS) | UI_CFGOPT_SETIDINSPDMODE PLLTUNING_ENABLE2 )

</#if>

<#-- Can't this be removed? Seems only used in START_STOP_POLARITY which comes from WB... -->
#define DIN_ACTIVE_LOW Bit_RESET
#define DIN_ACTIVE_HIGH Bit_SET

<#-- Only left because of the FreeRTOS project that we will need to adapt sooner or later... 
#define USE_EVAL (defined(USE_STM32446E_EVAL) || defined(USE_STM324xG_EVAL) || defined(USE_STM32F4XX_DUAL))
 -->

#define DOUT_ACTIVE_HIGH   DOutputActiveHigh
#define DOUT_ACTIVE_LOW    DOutputActiveLow

<#-- This table is an implementation of the Bits 7:4 IC1F register definition -->
<#function Fx_ic_filter icx>
    <#local coefficients =
        [ {"divider":  1, "N": 1} <#--   1 -->
        , {"divider":  1, "N": 2} <#--   2 -->
        , {"divider":  1, "N": 4} <#--   4 -->
        , {"divider":  1, "N": 8} <#--   8 -->

        , {"divider":  2, "N": 6} <#--  12 -->
        , {"divider":  2, "N": 8} <#--  16 -->

        , {"divider":  4, "N": 6} <#--  24 -->
        , {"divider":  4, "N": 8} <#--  32 -->

        , {"divider":  8, "N": 6} <#--  48 -->
        , {"divider":  8, "N": 8} <#--  64 -->

        , {"divider": 16, "N": 5} <#--  80 -->
        , {"divider": 16, "N": 6} <#--  96 -->
        , {"divider": 16, "N": 8} <#-- 128 -->

        , {"divider": 32, "N": 5} <#-- 160 -->
        , {"divider": 32, "N": 6} <#-- 192 -->
        , {"divider": 32, "N": 8} <#-- 256 -->
        ] >

    <#list coefficients as coeff >
        <#if icx <= (coeff.divider * coeff.N) >
            <#return  coeff_index >
        </#if>
    </#list>
    <#return 15 >
</#function>

<#macro define_IC_FILTER  motor sensor icx_filter>
#define M${ motor }_${ sensor }_IC_FILTER  ${ Fx_ic_filter(icx_filter)  }
</#macro>

<#function TimerHandler timer>
  <#return "${timer}_IRQHandler">
</#function>

<#if MC.HALL_SENSORS ==true || MC.AUX_HALL_SENSORS == true>
/**********  AUXILIARY HALL TIMER MOTOR 1 *************/
#define M1_HALL_TIM_PERIOD 65535
<@define_IC_FILTER motor=1 sensor='HALL' icx_filter=MC.HALL_ICx_FILTER?number />
#define SPD_TIM_M1_IRQHandler ${TimerHandler(_last_word(MC.HALL_TIMER_SELECTION))}
</#if>

<#if MC.HALL_SENSORS2==true || MC.AUX_HALL_SENSORS2 == true>
/**********  AUXILIARY HALL TIMER MOTOR 2 *************/
#define M2_HALL_TIM_PERIOD 65535
<@define_IC_FILTER motor=2 sensor='HALL' icx_filter=MC.HALL_ICx_FILTER2?number />
#define SPD_TIM_M2_IRQHandler ${TimerHandler(_last_word(MC.HALL_TIMER_SELECTION2))}
</#if>

<#if MC.ENCODER == true || MC.AUX_ENCODER == true >
/**********  AUXILIARY ENCODER TIMER MOTOR 1 *************/
#define M1_PULSE_NBR ( (4 * (M1_ENCODER_PPR)) - 1 )
<@define_IC_FILTER motor=1 sensor='ENC' icx_filter=MC.ENC_ICx_FILTER?number />
#define SPD_TIM_M1_IRQHandler ${TimerHandler(_last_word(MC.ENC_TIMER_SELECTION))}
</#if>
<#if MC.ENCODER2 == true || MC.AUX_ENCODER2 == true>
/**********  AUXILIARY ENCODER TIMER MOTOR 2 *************/
#define M2_PULSE_NBR ( (4 * (M2_ENCODER_PPR)) - 1 )
<@define_IC_FILTER motor=2 sensor='ENC' icx_filter=MC.ENC_ICx_FILTER2?number />
#define SPD_TIM_M2_IRQHandler ${TimerHandler(_last_word(MC.ENC_TIMER_SELECTION2))}
</#if>
<#if MC.PFC_ENABLED == true>
#define PFC_ETRFILTER_IC  ${ Fx_ic_filter(MC.ETRFILTER?number) }
#define PFC_SYNCFILTER_IC ${ Fx_ic_filter(MC.SYNCFILTER?number) }
</#if>

<#function MMIfunction Modulation>

<#local MMITABLE_81> 
{\
32508,32255,32008,31530,31299,30852,30636,30216,30012,29617,29426,29053,28872,\
28520,28349,28015,27853,27536,27382,27081,26934,26647,26507,26234,26101,25840,\
25712,25462,25340,25101,24984,24755,24643,24422,24315,24103,24000,23796,23696,\
23500,23404,23216,23123,22941,22851,22763,22589,22504,22336,22253,22091,22011,\
21854,21776,21624,21549,21401,21329,21186,21115,20976,20908,20773,20706,20575,\
20511,20383,20320,20196,20135,20015,19955,19838,19780,19666,19609,19498,19443,\
19334,19280,19175,19122,19019,18968,18867,18817,18719\
}
</#local>
<#local MMITABLE_83>  
{32291,32060,31613,31397,30977,30573,30377,29996,29811,29451,29276,28934,28768,\
28444,28286,27978,27827,27533,27390,27110,26973,26705,26574,26318,26069,25948,\
25709,25592,25363,25251,25031,24923,24711,24607,24404,24304,24107,24011,23821,\
23728,23545,23456,23279,23192,23021,22854,22772,22610,22530,22374,22297,22145,\
22070,21922,21850,21707,21636,21497,21429,21294,21227,21096,21032,20904,20778,\
20717,20595,20534,20416,20357,20241,20184,20071,20015,19905,19851,19743,19690,\
19585,19533,19431,19380,19280,19182\
}
</#local>
<#local MMITABLE_85>  
{\
32324,32109,31691,31489,31094,30715,30530,30170,29995,29654,29488,29163,29005,\
28696,28397,28250,27965,27825,27552,27418,27157,26903,26779,26535,26416,26182,\
26067,25842,25623,25515,25304,25201,24997,24897,24701,24605,24415,24230,24139,\
23960,23872,23699,23614,23446,23282,23201,23042,22964,22810,22734,22584,22437,\
22365,22223,22152,22014,21945,21811,21678,21613,21484,21421,21296,21234,21112,\
21051,20932,20815,20757,20643,20587,20476,20421,20312,20205,20152,20048,19996\
,19894,19844,19744,19645\
}
</#local>
<#local MMITABLE_87> 
{\
32559,32154,31764,31575,31205,31025,30674,30335,30170,29847,\
29689,29381,29083,28937,28652,28375,28239,27974,27844,27589,\
27342,27220,26983,26866,26637,26414,26305,26090,25984,25777,\
25575,25476,25280,25184,24996,24811,24720,24542,24367,24281,\
24112,24028,23864,23703,23624,23468,23391,23240,23091,23018,\
22874,22803,22662,22524,22456,22322,22191,22126,21997,21934,\
21809,21686,21625,21505,21446,21329,21214,21157,21045,20990,\
20880,20772,20719,20613,20561,20458,20356,20306,20207,20158,\
20109\
}
</#local>
<#local MMITABLE_89> 
{\
32574,32197,32014,31656,31309,31141,30811,30491,30335,30030,\
29734,29589,29306,29031,28896,28632,28375,28249,28002,27881,\
27644,27412,27299,27076,26858,26751,26541,26336,26235,26037,\
25844,25748,25561,25378,25288,25110,24936,24851,24682,24517,\
24435,24275,24118,24041,23888,23738,23664,23518,23447,23305,\
23166,23097,22962,22828,22763,22633,22505,22442,22318,22196,\
22135,22016,21898,21840,21726,21613,21557,21447,21338,21284,\
21178,21074,21022,20919,20819,20769,20670,20573\
}
</#local>
<#local MMITABLE_91> 
{\
32588,32411,32066,31732,31569,31250,30940,30789,30492,30205,\
29925,29788,29519,29258,29130,28879,28634,28395,28278,28048,\
27823,27713,27497,27285,27181,26977,26777,26581,26485,26296,\
26110,26019,25840,25664,25492,25407,25239,25076,24995,24835,\
24679,24602,24450,24301,24155,24082,23940,23800,23731,23594,\
23460,23328,23263,23135,23008,22946,22822,22701,22641,22522,\
22406,22291,22234,22122,22011,21956,21848,21741,21636,21584,\
21482,21380,21330,21231,21133,21037\
}
</#local>
<#local MMITABLE_92> 
{\
32424,32091,31929,31611,31302,31002,30855,30568,30289,30017,\
29884,29622,29368,29243,28998,28759,28526,28412,28187,27968,\
27753,27648,27441,27238,27040,26942,26750,26563,26470,26288,\
26110,25935,25849,25679,25513,25350,25269,25111,24955,24803,\
24727,24579,24433,24361,24219,24079,23942,23874,23740,23609,\
23479,23415,23289,23165,23042,22982,22863,22745,22629,22572,\
22459,22347,22292,22183,22075,21970,21917,21813,21711,21610,\
21561,21462,21365,21268\
}
</#local>
<#local MMITABLE_93> 
{\
32437,32275,31959,31651,31353,31207,30920,30642,30371,30107,\
29977,29723,29476,29234,29116,28883,28655,28433,28324,28110,\
27900,27695,27594,27395,27201,27011,26917,26733,26552,26375,\
26202,26116,25948,25783,25621,25541,25383,25228,25076,25001,\
24854,24708,24565,24495,24356,24219,24084,24018,23887,23758,\
23631,23506,23444,23322,23202,23083,23025,22909,22795,22683,\
22627,22517,22409,22302,22250,22145,22042,21941,21890,21791,\
21693,21596,21500\
}
</#local>
<#local MMITABLE_94> 
{\
32607,32293,31988,31691,31546,31261,30984,30714,30451,30322,\
30069,29822,29581,29346,29231,29004,28782,28565,28353,28249,\
28044,27843,27647,27455,27360,27174,26991,26812,26724,26550,\
26380,26213,26049,25968,25808,25652,25498,25347,25272,25125,\
24981,24839,24699,24630,24494,24360,24228,24098,24034,23908,\
23783,23660,23600,23480,23361,23245,23131,23074,22962,22851,\
22742,22635,22582,22477,22373,22271,22170,22120,22021,21924,\
21827,21732\
}
</#local>
<#local MMITABLE_95> 
{\
32613,32310,32016,31872,31589,31314,31046,30784,30529,30404,\
30158,29919,29684,29456,29343,29122,28906,28695,28488,28285,\
28186,27990,27798,27610,27425,27245,27155,26980,26808,26639,\
26473,26392,26230,26072,25917,25764,25614,25540,25394,25250,\
25109,24970,24901,24766,24633,24501,24372,24245,24182,24058,\
23936,23816,23697,23580,23522,23408,23295,23184,23075,23021,\
22913,22808,22703,22600,22499,22449,22349,22251,22154,22059,\
21964\
}
</#local>
<#local MMITABLE_96> 
{\
32619,32472,32184,31904,31631,31365,31106,30853,30728,30484,\
30246,30013,29785,29563,29345,29238,29028,28822,28620,28423,\
28229,28134,27946,27762,27582,27405,27231,27061,26977,26811,\
26649,26489,26332,26178,26027,25952,25804,25659,25517,25376,\
25238,25103,25035,24903,24772,24644,24518,24393,24270,24210,\
24090,23972,23855,23741,23627,23516,23461,23352,23244,23138,\
23033,22930,22828,22777,22677,22579,22481,22385,22290,22196\
}
</#local>
<#local MMITABLE_97> 
{\
32483,32206,31936,31672,31415,31289,31041,30799,30563,30331,\
30105,29884,29668,29456,29352,29147,28947,28750,28557,28369,\
28183,28002,27824,27736,27563,27393,27226,27062,26901,26743,\
26588,26435,26360,26211,26065,25921,25780,25641,25504,25369,\
25236,25171,25041,24913,24788,24664,24542,24422,24303,24186,\
24129,24015,23902,23791,23681,23573,23467,23362,23258,23206,\
23105,23004,22905,22808,22711,22616,22521,22429\
}
</#local>
<#local MMITABLE_98> 
{\
32494,32360,32096,31839,31587,31342,31102,30868,30639,30415,\
30196,29981,29771,29565,29464,29265,29069,28878,28690,28506,\
28325,28148,27974,27803,27635,27470,27309,27229,27071,26916,\
26764,26614,26467,26322,26180,26039,25901,25766,25632,25500,\
25435,25307,25180,25055,24932,24811,24692,24574,24458,24343,\
24230,24119,24009,23901,23848,23741,23637,23533,23431,23331,\
23231,23133,23036,22941,22846,22753,22661\
}
</#local>
<#local MMITABLE_99> 
{\
32635,32375,32121,31873,31631,31394,31162,30935,30714,30497,\
30284,30076,29872,29672,29574,29380,29190,29003,28820,28641,\
28464,28291,28122,27955,27791,27630,27471,27316,27163,27012,\
26864,26718,26575,26434,26295,26159,26024,25892,25761,25633,\
25569,25444,25320,25198,25078,24959,24842,24727,24613,24501,\
24391,24281,24174,24067,23963,23859,23757,23656,23556,23458,\
23361,23265,23170,23077,22984,22893\
}
</#local>
<#local MMITABLE_100> 
{\
32767,32390,32146,31907,31673,31444,31220,31001,30787,30577,30371,\
30169,29971,29777,29587,29400,29217,29037,28861,28687,28517,\
28350,28185,28024,27865,27709,27555,27404,27256,27110,26966,\
26824,26685,26548,26413,26280,26149,26019,25892,25767,25643,\
25521,25401,25283,25166,25051,24937,24825,24715,24606,24498,\
24392,24287,24183,24081,23980,23880,23782,23684,23588,23493,\
23400,23307,23215,23125\
}
</#local>
   <#local MMI =
        [ {"MAX_MODULATION":'MAX_MODULATION_81_PER_CENT', "START_INDEX":  41 , 
           "MAX_MODULE": 26541 ,
           "MMITABLE": MMITABLE_81
          } 
        , {"MAX_MODULATION":'MAX_MODULATION_83_PER_CENT', "START_INDEX":  44 , 
           "MAX_MODULE": 27196 ,
           "MMITABLE": MMITABLE_83
           }
        , {"MAX_MODULATION":'MAX_MODULATION_85_PER_CENT', "START_INDEX":  46 , 
           "MAX_MODULE": 27851 ,
           "MMITABLE": MMITABLE_85
           }
        , {"MAX_MODULATION":'MAX_MODULATION_87_PER_CENT', "START_INDEX":  48 , 
           "MAX_MODULE": 28507 ,
           "MMITABLE": MMITABLE_87
           }
        , {"MAX_MODULATION":'MAX_MODULATION_89_PER_CENT', "START_INDEX":  50 , 
           "MAX_MODULE": 29162 ,
           "MMITABLE": MMITABLE_89
           }
        , {"MAX_MODULATION":'MAX_MODULATION_91_PER_CENT', "START_INDEX":  52 , 
           "MAX_MODULE": 29817 ,
           "MMITABLE": MMITABLE_91
           }
        , {"MAX_MODULATION":'MAX_MODULATION_92_PER_CENT', "START_INDEX":  54 , 
           "MAX_MODULE": 30145 ,
           "MMITABLE": MMITABLE_92
           }
        , {"MAX_MODULATION":'MAX_MODULATION_93_PER_CENT', "START_INDEX":  55 , 
           "MAX_MODULE": 30473 ,
           "MMITABLE": MMITABLE_93
           }
        , {"MAX_MODULATION":'MAX_MODULATION_94_PER_CENT', "START_INDEX":  56 , 
           "MAX_MODULE": 30800 ,
           "MMITABLE": MMITABLE_94
           }
        , {"MAX_MODULATION":'MAX_MODULATION_95_PER_CENT', "START_INDEX":  57 , 
           "MAX_MODULE": 31128 ,
           "MMITABLE": MMITABLE_95
           }
        , {"MAX_MODULATION":'MAX_MODULATION_96_PER_CENT', "START_INDEX":  58 , 
           "MAX_MODULE": 31456 ,
           "MMITABLE": MMITABLE_96
           }
        , {"MAX_MODULATION":'MAX_MODULATION_97_PER_CENT', "START_INDEX":  60 , 
           "MAX_MODULE": 31783 ,
           "MMITABLE": MMITABLE_97
           }
        , {"MAX_MODULATION":'MAX_MODULATION_98_PER_CENT', "START_INDEX":  61 , 
           "MAX_MODULE": 32111 ,
           "MMITABLE": MMITABLE_98
           }
        , {"MAX_MODULATION":'MAX_MODULATION_99_PER_CENT', "START_INDEX":  62 , 
           "MAX_MODULE": 32439 ,
           "MMITABLE": MMITABLE_99
           }  
        , {"MAX_MODULATION":'MAX_MODULATION_100_PER_CENT', "START_INDEX":  63 , 
           "MAX_MODULE": 32767 ,
           "MMITABLE": MMITABLE_100
           }          
        ] > 
          
    <#list MMI as MMIitem >
      <#if Modulation == MMIitem.MAX_MODULATION >
         <#return  MMIitem >
      </#if>
    </#list>
    <#local Defaultitem = {"START_INDEX":'ERROR_MODULATION_START_INDEX_NOT_FOUND'
                      ,"MAX_MODULE":'ERROR_MAX_MODULE_NOT_FOUND'
                      ,"MMITABLE":'ERROR_MODULATION_INDEX_TABLE_NOT_FOUND'} >
    <#return Defaultitem>
</#function>

<#assign MMIvar = MMIfunction(MC.MAX_MODULATION_INDEX) >
/* MMI Table Motor 1 ${MC.MAX_MODULATION_INDEX} */
#define START_INDEX ${MMIvar.START_INDEX}
#define MAX_MODULE ${MMIvar.MAX_MODULE}
#define MMITABLE  ${MMIvar.MMITABLE}

<#if MC.DUALDRIVE == true>
<#assign MMIvar2 = MMIfunction(_remove_last_char(MC.MAX_MODULATION_INDEX2)) >
/* MMI Table Motor 2 ${_remove_last_char(MC.MAX_MODULATION_INDEX2)} */
#define START_INDEX2     ${MMIvar2.START_INDEX}
#define MAX_MODULE2      ${MMIvar2.MAX_MODULE}
#define MMITABLE2        ${MMIvar2.MMITABLE}
</#if> 
 
 <#if CondFamily_STM32F4 || CondFamily_STM32F7 >
  <#assign LL_ADC_CYCLE_SUFFIX = 'CYCLES'>
#define  SAMPLING_CYCLE_CORRECTION 0 /* ${McuName} ADC sampling time is an integer number */
<#else>
  <#assign LL_ADC_CYCLE_SUFFIX = 'CYCLES_5'>
  <#-- Addition of the Half cycle of ADC sampling time-->
#define SAMPLING_CYCLE_CORRECTION 0.5 /* Add half cycle required by ${McuName} ADC */
#define LL_ADC_SAMPLINGTIME_1CYCLES_5 LL_ADC_SAMPLINGTIME_1CYCLE_5
</#if>
#define LL_ADC_SAMPLING_CYCLE(CYCLE) LL_ADC_SAMPLINGTIME_ ## CYCLE ## ${LL_ADC_CYCLE_SUFFIX}

#endif /*__PARAMETERS_CONVERSION_H*/

/******************* (C) COPYRIGHT 2019 STMicroelectronics *****END OF FILE****/
