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
<#-- Condition for STM32F302x8x MCU -->
<#assign CondMcu_STM32F302x8x = (McuName?? && McuName?matches("STM32F302.8.*"))>
<#-- Condition for STM32F072xxx MCU -->
<#assign CondMcu_STM32F072xxx = (McuName?? && McuName?matches("STM32F072.*"))>
<#-- Condition for STM32F446xCx or STM32F446xEx -->
<#assign CondMcu_STM32F446xCEx = (McuName?? && McuName?matches("STM32F446.(C|E).*"))>
<#-- Condition for Line STM32F1xx Value -->
<#assign CondLine_STM32F1_Value = McuName?? && ((McuName?matches("STM32F100.(4|6|8|B).*")))>
<#-- Condition for Line STM32F1xx Value, Medium Density -->
<#assign CondLine_STM32F1_Value_MD = McuName?? && ((McuName?matches("STM32F100.(8|B).*")))>
<#-- Condition for Line STM32F1xx Performance -->
<#assign CondLine_STM32F1_Performance = (McuName?? && McuName?matches("STM32F103.(4|6|8|B).*"))>
<#-- Condition for Line STM32F1xx Performance, Medium Density -->
<#assign CondLine_STM32F1_Performance_MD = (McuName?? && McuName?matches("STM32F103.(8|B).*"))>
<#-- Condition for Line STM32F1xx High Density -->
<#assign CondLine_STM32F1_HD = (McuName?? && McuName?matches("STM32F103.(C|D|E|F|G).*"))>
<#-- Condition for STM32F0 Family -->
<#assign CondFamily_STM32F0 = (FamilyName?? && FamilyName=="STM32F0")>
<#-- Condition for STM32F1 Family -->
<#assign CondFamily_STM32F1 = (CondLine_STM32F1_Value || CondLine_STM32F1_Performance || CondLine_STM32F1_HD)>
<#-- Condition for STM32F3 Family -->
<#assign CondFamily_STM32F3 = (FamilyName?? && FamilyName == "STM32F3")>
<#-- Condition for STM32F4 Family -->
<#assign CondFamily_STM32F4 = (FamilyName?? && FamilyName == "STM32F4") >
<#-- Condition for STM32G4 Family -->
<#assign CondFamily_STM32G4 = (FamilyName?? && FamilyName == "STM32G4") >
<#-- Condition for STM32L4 Family -->
<#assign CondFamily_STM32L4 = (FamilyName?? && FamilyName == "STM32L4") >
<#-- Condition for STM32F7 Family -->
<#assign CondFamily_STM32F7 = (FamilyName?? && FamilyName == "STM32F7") >
<#-- Condition for STM32H7 Family -->
<#assign CondFamily_STM32H7 = (FamilyName?? && FamilyName == "STM32H7") >
<#-- Condition for STM32G0 Family -->
<#assign CondFamily_STM32G0 = (FamilyName?? && FamilyName=="STM32G0") >
/**
  ******************************************************************************
  * @file    mc_config.h 
  * @author  Motor Control SDK Team, ST Microelectronics
  * @brief   Motor Control Subsystem components configuration and handler 
  *          structures declarations.
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
  
#ifndef __MC_CONFIG_H
#define __MC_CONFIG_H

<#-- Specific to FOC algorithm usage -->
<#if MC.DRIVE_TYPE == "FOC">
#include "pid_regulator.h"
#include "revup_ctrl.h"
#include "speed_torq_ctrl.h"
#include "virtual_speed_sensor.h"
#include "ntc_temperature_sensor.h"
#include "pwm_curr_fdbk.h"
	<#if  MC.BUS_VOLTAGE_READING == true || MC.BUS_VOLTAGE_READING2 == true>
#include "r_divider_bus_voltage_sensor.h"
	</#if>
	<#if  MC.BUS_VOLTAGE_READING == false || MC.BUS_VOLTAGE_READING2 == false>
#include "virtual_bus_voltage_sensor.h"
	</#if>
	<#if MC.FEED_FORWARD_CURRENT_REG_ENABLING == true || MC.FEED_FORWARD_CURRENT_REG_ENABLING2 == true>
#include "feed_forward_ctrl.h"
	</#if> 
	<#if MC.FLUX_WEAKENING_ENABLING == true || MC.FLUX_WEAKENING_ENABLING2 == true>
#include "flux_weakening_ctrl.h"
	</#if> 
<#if MC.POSITION_CTRL_ENABLING == true || MC.POSITION_CTRL_ENABLING2 == true>
#include "trajectory_ctrl.h"
</#if>
#include "pqd_motor_power_measurement.h"
<#if MC.USE_STGAP1S >
#include "gap_gate_driver_ctrl.h"
</#if>
</#if> <#-- MC.DRIVE_TYPE == "FOC" -->

<#-- Shared between FOC and 6_STEP algorithms usage -->
#include "user_interface.h"

<#-- ST MCWB monitoring usage management (used when MC.SERIAL_COMMUNICATION == true) -->

<#switch MC.DRIVE_TYPE>
  <#case "FOC">
    <#if MC.SERIAL_COMMUNICATION == true>
#include "motor_control_protocol.h"
      <#-- Communication Direction with the FOC algorithm -->
      <#if MC.SERIAL_COM_MODE == "COM_BIDIRECTIONAL">
#include "usart_frame_communication_protocol.h"
      <#elseif MC.SERIAL_COM_MODE == "COM_UNIDIRECTIONAL">
#include "unidirectional_fast_com.h"
			</#if>
    </#if>  
    <#break>
		
<#-- Communication is bi-directional for the 6_STEP algorithm -->
  <#case "SIX_STEP">
    <#if MC.SERIAL_COMMUNICATION == true>
#include "motor_control_protocol.h"    
#include "usart_frame_communication_protocol.h"
    <#else>
      <#-- TERATERM usage for the 6_STEP algorithm -->
#include "usart.h"
    </#if>
    <#break>		
  <#default>
#error "This other algorithm is not supported"
  <#break>
	</#switch>

<#-- DAC usage for monitoring -->
<#if   MC.DAC_FUNCTIONALITY == true>
#include "dac_common_ui.h"
	<#if MC.DAC_EMULATED == true>
#include "dac_rctimer_ui.h"
	<#else>
#include "dac_ui.h"
	</#if>
</#if>

<#-- Specific to FOC algorithm usage -->
<#if MC.DRIVE_TYPE == "FOC">
	<#-- Specific to F3 family usage -->
	<#if CondFamily_STM32F3 && MC.THREE_SHUNT == true> 
#include "r3_1_f30x_pwm_curr_fdbk.h"
	</#if>
	<#if CondFamily_STM32F3 && (MC.SINGLE_SHUNT == true || MC.SINGLE_SHUNT2 == true)>
#include "r1_f30x_pwm_curr_fdbk.h"
	</#if>
	<#if CondFamily_STM32F3 && (MC.THREE_SHUNT_SHARED_RESOURCES == true || MC.THREE_SHUNT_SHARED_RESOURCES2 == true ||
                            MC.THREE_SHUNT_INDEPENDENT_RESOURCES == true || MC.THREE_SHUNT_INDEPENDENT_RESOURCES2 == true)>  
#include "r3_2_f30x_pwm_curr_fdbk.h"
	</#if>
	<#if CondFamily_STM32F3 && (MC.ICS_SENSORS == true || MC.ICS_SENSORS2 == true)>
#include "ics_f30x_pwm_curr_fdbk.h"
	</#if>
	<#-- Specific to F4 family usage -->
	<#if CondFamily_STM32F4 > 
		<#if MC.SINGLE_SHUNT == true || MC.SINGLE_SHUNT2 == true  >
#include "r1_f4xx_pwm_curr_fdbk.h"
		</#if>
		<#if MC.THREE_SHUNT == true >
#include "r3_1_f4xx_pwm_curr_fdbk.h"
		</#if>
		<#if MC.THREE_SHUNT_INDEPENDENT_RESOURCES == true || MC.THREE_SHUNT_INDEPENDENT_RESOURCES2 == true>
#include "r3_2_f4xx_pwm_curr_fdbk.h"    
		</#if>
		<#if MC.ICS_SENSORS || MC.ICS_SENSORS2 == true > 
#include "ics_f4xx_pwm_curr_fdbk.h"  	
		</#if>	
	</#if>
	<#-- Specific to G0 family usage -->
	<#if CondFamily_STM32G0 > 
		<#if MC.SINGLE_SHUNT>
#include "r1_g0xx_pwm_curr_fdbk.h"
		</#if>
		<#if MC.THREE_SHUNT == true >
#include "r3_g0xx_pwm_curr_fdbk.h"
		</#if>
		<#if MC.ICS_SENSORS == true > 
#include "ics_g0xx_pwm_curr_fdbk.h"  	
		</#if>	
	</#if>
	<#-- Specific to L4 family usage -->
	<#if CondFamily_STM32L4 && MC.THREE_SHUNT == true> 
#include "r3_1_l4xx_pwm_curr_fdbk.h"
	</#if>
	<#if CondFamily_STM32L4 && MC.THREE_SHUNT_INDEPENDENT_RESOURCES == true> 
#include "r3_2_l4xx_pwm_curr_fdbk.h"
	</#if>
	<#if CondFamily_STM32L4 && MC.SINGLE_SHUNT == true> 
#include "r1_l4xx_pwm_curr_fdbk.h"
	</#if>
	<#if CondFamily_STM32L4 && MC.ICS_SENSORS == true> 
#include "ics_l4xx_pwm_curr_fdbk.h"
	</#if>
	<#-- Specific to F7 family usage -->
	<#if CondFamily_STM32F7 && MC.THREE_SHUNT == true> 
#include "r3_1_f7xx_pwm_curr_fdbk.h"
	</#if>
	<#if CondFamily_STM32F7 && MC.THREE_SHUNT_INDEPENDENT_RESOURCES == true> 
#include "r3_2_f7xx_pwm_curr_fdbk.h"
	</#if>
	<#if CondFamily_STM32F7 && MC.SINGLE_SHUNT == true> 
#include "r1_f7xx_pwm_curr_fdbk.h"
	</#if>
	<#if CondFamily_STM32F7 && MC.ICS_SENSORS == true> 
#include "ics_f7xx_pwm_curr_fdbk.h"
	</#if>
	<#-- Specific to H7 family usage -->
	<#if CondFamily_STM32H7 && MC.THREE_SHUNT == true> 
#include "r3_1_h7xx_pwm_curr_fdbk.h"
	</#if>
	<#if CondFamily_STM32H7 && MC.THREE_SHUNT_INDEPENDENT_RESOURCES == true> 
#include "r3_2_h7xx_pwm_curr_fdbk.h"
	</#if>
	<#if CondFamily_STM32H7 && MC.SINGLE_SHUNT == true> 
#include "r1_h7xx_pwm_curr_fdbk.h"
	</#if>
	<#if CondFamily_STM32H7 && MC.ICS_SENSORS == true> 
#include "ics_h7xx_pwm_curr_fdbk.h"
	</#if>
	<#-- Specific to F0 family usage -->
	<#if CondFamily_STM32F0 && MC.SINGLE_SHUNT == true> 
#include "r1_f0xx_pwm_curr_fdbk.h"
	</#if>
	<#if CondFamily_STM32F0 && MC.THREE_SHUNT == true>
#include "r3_f0xx_pwm_curr_fdbk.h"
	</#if>
	<#-- Specific to F1 family usage -->
	<#if CondFamily_STM32F1 == true && MC.THREE_SHUNT == true ><#-- CondFamily_STM32F1 --->
#include "r3_2_f1xx_pwm_curr_fdbk.h"
	</#if> 
	<#if CondLine_STM32F1_HD && MC.SINGLE_SHUNT == true >
#include "r1_hd2_pwm_curr_fdbk.h"
	</#if>
	<#if CondLine_STM32F1_Performance && MC.SINGLE_SHUNT == true >
#include "r1_vl1_pwm_curr_fdbk.h"
	</#if>   
	<#if CondLine_STM32F1_HD && MC.ICS_SENSORS == true >
#include "ics_hd2_pwm_curr_fdbk.h"  
	</#if>
	<#if CondLine_STM32F1_Performance && MC.ICS_SENSORS == true >
#include "ics_lm1_pwm_curr_fdbk.h"
	</#if>
	<#-- Specific to G4 family usage -->
	<#if CondFamily_STM32G4 >
		<#if MC.SINGLE_SHUNT || MC.SINGLE_SHUNT2 >
#include "r1_g4xx_pwm_curr_fdbk.h"
		</#if>
		<#if  MC.THREE_SHUNT_INDEPENDENT_RESOURCES || MC.THREE_SHUNT_INDEPENDENT_RESOURCES2  >
#include "r3_2_g4xx_pwm_curr_fdbk.h"
		</#if>
		<#if  MC.ICS_SENSORS || MC.ICS_SENSORS2  >
#include "ics_g4xx_pwm_curr_fdbk.h"
		</#if>
	</#if>

	<#-- MTPA feature usage -->
	<#if MC.MTPA_ENABLING == true || MC.MTPA_ENABLING2 == true>
#include "max_torque_per_ampere.h"
	</#if>
	<#-- ICL feature usage -->
	<#if  MC.INRUSH_CURRLIMIT_ENABLING == true || MC.INRUSH_CURRLIMIT_ENABLING2 == true>
#include "inrush_current_limiter.h"
	</#if>
	<#-- Open Loop feature usage -->
	<#if MC.OPEN_LOOP_FOC == true || MC.OPEN_LOOP_FOC2 == true>
#include "open_loop.h"
	</#if> 
	<#if MC.STATE_OBSERVER_PLL == true || MC.STATE_OBSERVER_CORDIC == true>
extern RevUpCtrl_Handle_t RevUpControlM1;
	</#if>
	<#-- Position sensors feature usage -->
	<#if MC.ENCODER == true || MC.ENCODER2 == true || MC.AUX_ENCODER == true || MC.AUX_ENCODER2 == true>
#include "encoder_speed_pos_fdbk.h"
#include "enc_align_ctrl.h"
	</#if>
	<#if MC.HALL_SENSORS ==true || MC.AUX_HALL_SENSORS == true || MC.HALL_SENSORS2==true || MC.AUX_HALL_SENSORS2 == true>
#include "hall_speed_pos_fdbk.h"
	</#if>
#include "ramp_ext_mngr.h"
#include "circle_limitation.h"
	<#-- High Frequency Injection feature usage -->
	<#if  MC.HFINJECTION == true || MC.HFINJECTION2 == true>
#include "hifreqinj_fpu_ctrl.h"
#include "hifreqinj_fpu_speednposfdbk.h"
	</#if>

	<#if  MC.STATE_OBSERVER_PLL == true ||  MC.AUX_STATE_OBSERVER_PLL == true || 
      MC.STATE_OBSERVER_CORDIC == true ||  MC.AUX_STATE_OBSERVER_CORDIC == true>
#include "sto_speed_pos_fdbk.h"
	</#if>
	<#if MC.AUX_STATE_OBSERVER_PLL == true || MC.AUX_STATE_OBSERVER_PLL2== true ||
		MC.STATE_OBSERVER_PLL== true || MC.STATE_OBSERVER_PLL2== true >
#include "sto_pll_speed_pos_fdbk.h"
	</#if>
	<#if MC.AUX_STATE_OBSERVER_CORDIC == true || MC.AUX_STATE_OBSERVER_CORDIC2== true ||
		MC.STATE_OBSERVER_CORDIC== true || MC.STATE_OBSERVER_CORDIC2== true >
#include "sto_cordic_speed_pos_fdbk.h"
	</#if>
	<#-- PFC feature usage -->
	<#if MC.PFC_ENABLED == true>
#include "pfc.h"
	</#if>
/* USER CODE BEGIN Additional include */

/* USER CODE END Additional include */  
	<#-- Motor Profiler feature usage -->
	<#if MC.MOTOR_PROFILER == true>
extern FOCVars_t FOCVars[];
extern STM_Handle_t STM[];
extern CircleLimitation_Handle_t *pCLM[];
extern PID_Handle_t *pPIDIq[];
extern PID_Handle_t *pPIDId[];
extern SpeednTorqCtrl_Handle_t *pSTC[];
	</#if>
extern PID_Handle_t PIDSpeedHandle_M1;
extern PID_Handle_t PIDIqHandle_M1;
extern PID_Handle_t PIDIdHandle_M1;
extern NTC_Handle_t TempSensorParamsM1;
	<#-- Flux Weakening feature usage -->
	<#if MC.FLUX_WEAKENING_ENABLING == true>
extern PID_Handle_t PIDFluxWeakeningHandle_M1;
extern FW_Handle_t FW_M1;
</#if> 
<#if  MC.POSITION_CTRL_ENABLING == true >
extern PID_Handle_t PID_PosParamsM1;
extern PosCtrl_Handle_t pPosCtrlM1;
</#if>
<#if  MC.POSITION_CTRL_ENABLING2 == true >
extern PID_Handle_t PID_PosParamsM2;
extern PosCtrl_Handle_t pPosCtrlM2;
	</#if> 
	<#-- Specific to F3 family usage -->
	<#if CondFamily_STM32F3 && MC.SINGLE_SHUNT == true>
extern PWMC_R1_F3_Handle_t PWM_Handle_M1;
	</#if>
	<#if CondFamily_STM32F3 && MC.ICS_SENSORS == true> 
extern PWMC_ICS_Handle_t PWM_Handle_M1;
	</#if>
	<#-- Specific to F4 family usage -->
	<#if CondFamily_STM32F4 >
		<#if MC.SINGLE_SHUNT == true> 
extern PWMC_R1_F4_Handle_t PWM_Handle_M1;
		<#elseif MC.ICS_SENSORS == true>
extern PWMC_ICS_Handle_t PWM_Handle_M1; 
		</#if>
		<#if MC.SINGLE_SHUNT2 == true> 
extern PWMC_R1_F4_Handle_t PWM_Handle_M2;
		<#elseif MC.ICS_SENSORS2 == true> 
extern PWMC_ICS_Handle_t PWM_Handle_M2;
		</#if>
	</#if>
	<#-- Specific to G0 family usage -->
	<#if CondFamily_STM32G0 >
		<#if MC.SINGLE_SHUNT == true> 
extern PWMC_R1_G0_Handle_t PWM_Handle_M1;
		</#if>
	</#if>
	<#-- Specific to F0 family usage -->
	<#if CondFamily_STM32F0 && MC.SINGLE_SHUNT == true> 
extern PWMC_R1_F0_Handle_t PWM_Handle_M1;
	</#if>
	<#if CondFamily_STM32F0 && MC.THREE_SHUNT == true>
extern PWMC_R3_1_Handle_t PWM_Handle_M1;
	</#if>
	<#-- Specific to F1 family usage -->
	<#if MC.THREE_SHUNT == true && ! CondFamily_STM32F1> 
extern PWMC_R3_1_Handle_t PWM_Handle_M1;
	</#if>
	<#if (MC.THREE_SHUNT_SHARED_RESOURCES || MC.THREE_SHUNT_INDEPENDENT_RESOURCES )  && ! CondFamily_STM32F1>
extern PWMC_R3_2_Handle_t PWM_Handle_M1;
	</#if>
	<#if CondLine_STM32F1_HD && MC.SINGLE_SHUNT == true>
extern PWMC_R1_HD2_Handle_t PWM_Handle_M1;
	</#if>
	<#if (CondFamily_STM32F1) && MC.THREE_SHUNT == true > 
extern PWMC_R3_2_Handle_t PWM_Handle_M1;
	</#if>
	<#if (CondLine_STM32F1_Value || CondLine_STM32F1_Performance) && MC.SINGLE_SHUNT == true>
extern PWMC_R1_VL1_Handle_t PWM_Handle_M1;
	<#elseif CondLine_STM32F1_Performance && MC.ICS_SENSORS == true> 
extern PWMC_ICS_Handle_t PWM_Handle_M1;
	<#elseif CondLine_STM32F1_HD && MC.ICS_SENSORS == true> 
extern PWMC_ICS_Handle_t PWM_Handle_M1;
	</#if>
	<#-- Specific to G4 family usage -->
	<#if CondFamily_STM32G4 >
		<#if MC.SINGLE_SHUNT>
extern PWMC_R1_Handle_t PWM_Handle_M1;
		</#if>
		<#if MC.SINGLE_SHUNT2>
extern PWMC_R1_Handle_t PWM_Handle_M2;
		</#if> 
 <#if MC.ICS_SENSORS>
extern PWMC_ICS_Handle_t PWM_Handle_M1;
  </#if>
  <#if MC.ICS_SENSORS2>
extern PWMC_ICS_Handle_t PWM_Handle_M2;
  </#if>  
	</#if>
	<#-- Specific to L4 family usage -->
	<#if CondFamily_STM32L4 && MC.SINGLE_SHUNT == true> 
extern PWMC_R1_L4_Handle_t PWM_Handle_M1;
	</#if>
	<#if CondFamily_STM32L4 && MC.THREE_SHUNT == true> 
extern PWMC_R3_1_Handle_t PWM_Handle_M1;
	</#if>
	<#if CondFamily_STM32L4 && MC.THREE_SHUNT_INDEPENDENT_RESOURCES == true> 
extern PWMC_R3_2_Handle_t PWM_Handle_M1;
	</#if>
	<#if CondFamily_STM32L4 && MC.ICS_SENSORS == true> 
extern PWMC_ICS_Handle_t PWM_Handle_M1;
	</#if>
	<#-- Specific to F7 family usage -->
	<#if CondFamily_STM32F7 && MC.SINGLE_SHUNT == true> 
extern PWMC_R1_F7_Handle_t PWM_Handle_M1;
	</#if>
	<#if CondFamily_STM32F7 && MC.THREE_SHUNT == true> 
extern PWMC_R3_1_Handle_t PWM_Handle_M1;
	</#if>
	<#if CondFamily_STM32F7 && MC.THREE_SHUNT_INDEPENDENT_RESOURCES == true> 
extern PWMC_R3_2_Handle_t PWM_Handle_M1;
	</#if>
	<#if CondFamily_STM32F7 && MC.ICS_SENSORS == true> 
extern PWMC_ICS_Handle_t PWM_Handle_M1;
	</#if>
	<#-- Specific to H7 family usage -->
	<#if CondFamily_STM32H7 && MC.THREE_SHUNT_INDEPENDENT_RESOURCES == true> 
extern PWMC_R3_2_Handle_t PWM_Handle_M1;
extern PWMC_R3_2_Handle_t PWM_Handle_M1;
	</#if>
	<#-- Specific to Dual Drive feature usage -->
	<#if MC.DUALDRIVE == true>
extern SpeednTorqCtrl_Handle_t SpeednTorqCtrlM2;
extern PID_Handle_t PIDSpeedHandle_M2;
extern PID_Handle_t PIDIqHandle_M2;
extern PID_Handle_t PIDIdHandle_M2;
extern NTC_Handle_t TempSensorParamsM2;
		<#if MC.FLUX_WEAKENING_ENABLING2 == true>
extern PID_Handle_t PIDFluxWeakeningHandle_M2;
extern FW_Handle_t FW_M2;
		</#if>
		<#if MC.FEED_FORWARD_CURRENT_REG_ENABLING2 == true>
extern FF_Handle_t FF_M2;
		</#if> 
<#if  MC.POSITION_CTRL_ENABLING2 == true >
extern PID_Handle_t PID_PosParamsM2;
extern PosCtrl_Handle_t pPosCtrlM2;
</#if>
		<#if CondFamily_STM32F3 && MC.SINGLE_SHUNT2 == true>
extern PWMC_R1_F3_Handle_t PWM_Handle_M2;
		</#if>
		<#if (MC.THREE_SHUNT_SHARED_RESOURCES2 || MC.THREE_SHUNT_INDEPENDENT_RESOURCES2 )>
extern PWMC_R3_2_Handle_t PWM_Handle_M2;
		</#if>
		<#if CondFamily_STM32F3 && MC.ICS_SENSORS2 == true> 
extern PWMC_ICS_Handle_t PWM_Handle_M2;
		</#if>
	</#if> 
extern SpeednTorqCtrl_Handle_t SpeednTorqCtrlM1;
extern PQD_MotorPowMeas_Handle_t PQD_MotorPowMeasM1;
extern PQD_MotorPowMeas_Handle_t *pPQD_MotorPowMeasM1; 
<#if MC.USE_STGAP1S >
extern GAP_Handle_t STGAP_M1;
</#if>
	<#if MC.DUALDRIVE == true>
extern PQD_MotorPowMeas_Handle_t PQD_MotorPowMeasM2;
extern PQD_MotorPowMeas_Handle_t *pPQD_MotorPowMeasM2; 
	</#if> 
	<#if MC.STATE_OBSERVER_PLL == true || MC.STATE_OBSERVER_CORDIC == true || MC.ENCODER == true || MC.VIEW_ENCODER_FEEDBACK == true> 
extern VirtualSpeedSensor_Handle_t VirtualSpeedSensorM1;
	</#if> 
	<#if MC.STATE_OBSERVER_PLL2 == true || MC.STATE_OBSERVER_CORDIC2 == true || MC.ENCODER2 == true || MC.VIEW_ENCODER_FEEDBACK2 == true> 
extern VirtualSpeedSensor_Handle_t VirtualSpeedSensorM2;
	</#if> 
	<#if  MC.HFINJECTION == true>
extern HFI_FP_SPD_Handle_t	HfiFpSpeedM1;
extern HFI_FP_Ctrl_Handle_t	HfiFpCtrlM1;
	</#if>
	<#if MC.DUALDRIVE == true && MC.HFINJECTION2 == true>
extern HFI_FP_SPD_Handle_t	HfiFpSpeedM2;
extern HFI_FP_Ctrl_Handle_t	HfiFpCtrlM2;
	</#if> 
	<#if  MC.STATE_OBSERVER_PLL == true || MC.STATE_OBSERVER_CORDIC == true>
extern STO_Handle_t STO_M1;
	</#if> 
	<#if  MC.STATE_OBSERVER_PLL2 == true || MC.STATE_OBSERVER_CORDIC2 == true>
extern RevUpCtrl_Handle_t RevUpControlM2;
extern STO_Handle_t STO_M2;
	</#if> 
	<#if MC.STATE_OBSERVER_PLL == true || MC.AUX_STATE_OBSERVER_PLL == true>
extern STO_PLL_Handle_t STO_PLL_M1;
	</#if>  
	<#if MC.STATE_OBSERVER_PLL2 == true || MC.AUX_STATE_OBSERVER_PLL2 == true  >
  extern STO_PLL_Handle_t STO_PLL_M2;
	</#if>
	<#if MC.STATE_OBSERVER_CORDIC2 == true || MC.AUX_STATE_OBSERVER_CORDIC2 == true>
extern STO_CR_Handle_t STO_CR_M2;
	</#if>  
	<#if MC.STATE_OBSERVER_CORDIC == true || MC.AUX_STATE_OBSERVER_CORDIC == true>
extern STO_CR_Handle_t STO_CR_M1;
	</#if>  
	<#if MC.ENCODER == true|| MC.AUX_ENCODER == true >
extern ENCODER_Handle_t ENCODER_M1;
extern EncAlign_Handle_t EncAlignCtrlM1;
	</#if>  
	<#if MC.ENCODER2 == true|| MC.AUX_ENCODER2 == true >
extern ENCODER_Handle_t ENCODER_M2;
extern EncAlign_Handle_t EncAlignCtrlM2;
	</#if>  
	<#if MC.HALL_SENSORS2 == true || MC.AUX_HALL_SENSORS2 == true >
extern HALL_Handle_t HALL_M2;
	</#if>
	<#if MC.HALL_SENSORS == true || MC.AUX_HALL_SENSORS == true >
extern HALL_Handle_t HALL_M1;
	</#if>  
	<#if  MC.INRUSH_CURRLIMIT_ENABLING == true>
extern ICL_Handle_t ICL_M1;
	</#if>
	<#if MC.INRUSH_CURRLIMIT_ENABLING2 == true && MC.DUALDRIVE == true>
extern ICL_Handle_t ICL_M2;
	</#if>
	<#if  MC.BUS_VOLTAGE_READING == true>
extern RDivider_Handle_t RealBusVoltageSensorParamsM1;
	<#else>
extern VirtualBusVoltageSensor_Handle_t VirtualBusVoltageSensorParamsM1;
	</#if>
	<#if  MC.DUALDRIVE == true>
		<#if  MC.BUS_VOLTAGE_READING2 == true>
extern RDivider_Handle_t RealBusVoltageSensorParamsM2;
		<#else>
extern VirtualBusVoltageSensor_Handle_t VirtualBusVoltageSensorParamsM2;
		</#if>
	</#if>
extern CircleLimitation_Handle_t CircleLimitationM1;
	<#if MC.DUALDRIVE == true>
extern CircleLimitation_Handle_t CircleLimitationM2;
	</#if>
extern RampExtMngr_Handle_t RampExtMngrHFParamsM1;
	<#if MC.DUALDRIVE == true >
extern RampExtMngr_Handle_t RampExtMngrHFParamsM2;
	</#if>
	<#if MC.FEED_FORWARD_CURRENT_REG_ENABLING == true>
extern FF_Handle_t FF_M1;
	</#if> 
	<#if MC.MTPA_ENABLING == true>
extern MTPA_Handle_t MTPARegM1;
	</#if>
	<#if MC.DUALDRIVE == true && MC.MTPA_ENABLING2 == true>
extern MTPA_Handle_t MTPARegM2;
	</#if>
	<#if MC.OPEN_LOOP_FOC == true>
extern OpenLoop_Handle_t OpenLoop_ParamsM1;
	</#if> 
	<#if MC.OPEN_LOOP_FOC2 == true>
extern OpenLoop_Handle_t OpenLoop_ParamsM2;
	</#if>
	<#if  MC.DUALDRIVE == true>
		<#if  MC.ON_OVER_VOLTAGE2 == "TURN_ON_R_BRAKE">
DigitalOutputParams_t R_BrakeParamsM2;
		</#if>
		<#if MC.HW_OV_CURRENT_PROT_BYPASS2 == true && MC.ON_OVER_VOLTAGE2 == "TURN_ON_LOW_SIDES">
extern DOUT_handle_t DOUT_OCPDisablingParamsM2;
		</#if>
		<#if MC.INRUSH_CURRLIMIT_ENABLING2 == true>
extern DOUT_handle_t ICLDOUTParamsM2;
		</#if>
	</#if>
	<#if  MC.ON_OVER_VOLTAGE == "TURN_ON_R_BRAKE">
extern DOUT_handle_t R_BrakeParamsM1;
	</#if>
	<#if MC.HW_OV_CURRENT_PROT_BYPASS == true && MC.ON_OVER_VOLTAGE == "TURN_ON_LOW_SIDES">
extern DOUT_handle_t DOUT_OCPDisablingParamsM1;
	</#if>
	<#if MC.INRUSH_CURRLIMIT_ENABLING == true>
extern DOUT_handle_t ICLDOUTParamsM1;
	</#if>
</#if><#-- DRIVE_TYPE == "FOC" -->

<#-- Shared between FOC and 6_STEP algorithms usage -->
extern UI_Handle_t UI_Params;

<#-- DAC usage for monitoring -->
<#if   MC.DAC_FUNCTIONALITY == true>
extern DAC_UI_Handle_t DAC_UI_Params;
</#if>

<#-- ST MCWB monitoring usage management (used when MC.SERIAL_COMMUNICATION == true) -->
<#if MC.SERIAL_COMMUNICATION == true>
	<#switch MC.DRIVE_TYPE>
		<#case "FOC">
			<#-- Communication Direction with the FOC algorithm -->
			<#if MC.SERIAL_COM_MODE == "COM_BIDIRECTIONAL">
extern UFCP_Handle_t pUSART;
			<#elseif MC.SERIAL_COM_MODE == "COM_UNIDIRECTIONAL">
extern UDFastCom_Handle_t *pUFC;
extern UDFastCom_Params_t UFCParams_str;
			</#if>
		<#break>
		
		<#-- Communication is bi-directional for the 6_STEP algorithm -->
		<#case "SIX_STEP">
extern UFCP_Handle_t pUSART;
		<#break>
		
		<#default>
		#error "This other algorithm is not supported"
		<#break>
	</#switch>
<#else>
<#-- Nothing needed with the TERATERM usage for the 6_STEP algorithm -->
</#if>

<#if MC.DRIVE_TYPE == "FOC">
	<#-- PFC feature usage -->
	<#if MC.PFC_ENABLED == true>
extern PFC_Handle_t PFC;
	</#if>
	<#-- Motor Profiler feature usage -->
	<#if MC.MOTOR_PROFILER == true>
extern RampExtMngr_Handle_t RampExtMngrParamsSCC;
extern RampExtMngr_Handle_t RampExtMngrParamsOTT;
extern SCC_Handle_t SCC;
extern OTT_Handle_t OTT;
	</#if>
/* USER CODE BEGIN Additional extern */

/* USER CODE END Additional extern */  
	<#if MC.SINGLEDRIVE == true >
#define NBR_OF_MOTORS 1
	<#else>
#define NBR_OF_MOTORS 2
	</#if>
</#if><#-- MC.DRIVE_TYPE == "FOC" -->
#endif /* __MC_CONFIG_H */
/******************* (C) COPYRIGHT 2019 STMicroelectronics *****END OF FILE****/
