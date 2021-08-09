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
<#-- Condition for STM32F030xxx MCU -->
<#assign CondMcu_STM32F030xxx = (McuName?? && McuName?matches("STM32F030.*"))>
<#-- Condition for Line STM32F1xx Value -->
<#assign CondLine_STM32F1_LD = (McuName?? && (McuName?matches("STM32F103.(4|6).*")))>
<#-- Condition for Line STM32F1xx Performance -->
<#assign CondLine_STM32F1_MD = (McuName?? && McuName?matches("STM32F103.(8|B).*"))>
<#-- Condition for Line STM32F1xx High Density -->
<#assign CondLine_STM32F1_HD = (McuName?? && McuName?matches("STM32F103.(C|D|E|F|G).*")) >
<#-- Condition for STM32F0 Family -->
<#assign CondFamily_STM32F0 = (FamilyName?? && FamilyName=="STM32F0")>
<#-- Condition for STM32F1 Family -->
<#assign CondFamily_STM32F1 = (CondLine_STM32F1_LD || CondLine_STM32F1_MD || CondLine_STM32F1_HD)>
<#-- Condition for STM32F3 Family -->
<#assign CondFamily_STM32F3 = (FamilyName?? && FamilyName == "STM32F3") >
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

<#function _last_word text sep="_"><#return text?split(sep)?last></#function>

<#macro setScandir Ph1 Ph2>
<#if Ph1?number < Ph2?number>
   LL_ADC_REG_SEQ_SCAN_DIR_FORWARD>>ADC_CFGR1_SCANDIR_Pos,
<#else>
   LL_ADC_REG_SEQ_SCAN_DIR_BACKWARD>>ADC_CFGR1_SCANDIR_Pos,
</#if>
<#return>
</#macro>
/**
  ******************************************************************************
  * @file    mc_config.c 
  * @author  Motor Control SDK Team, ST Microelectronics
  * @brief   Motor Control Subsystem components configuration and handler structures.
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
#include "main.h"
#include "mc_type.h"
<#if MC.DRIVE_TYPE == "FOC">
#include "parameters_conversion.h"
#include "mc_parameters.h"
</#if>
#include "mc_config.h"

/* USER CODE BEGIN Additional include */

/* USER CODE END Additional include */ 
<#if MC.DRIVE_TYPE == "FOC">


	<#if MC.SINGLEDRIVE == true>
#define FREQ_RATIO 1                /* Dummy value for single drive */
#define FREQ_RELATION HIGHEST_FREQ  /* Dummy value for single drive */
	</#if>
</#if><#-- MC.DRIVE_TYPE == "FOC" -->

<#if MC.DRIVE_TYPE == "FOC">
#define OFFCALIBRWAIT_MS     0
#define OFFCALIBRWAIT_MS2    0     
#include "pqd_motor_power_measurement.h"
</#if><#-- MC.DRIVE_TYPE == "FOC" -->
/* USER CODE BEGIN Additional define */

/* USER CODE END Additional define */ 

<#if MC.DRIVE_TYPE == "FOC">
PQD_MotorPowMeas_Handle_t PQD_MotorPowMeasM1 =
{
  .wConvFact = PQD_CONVERSION_FACTOR
};
PQD_MotorPowMeas_Handle_t *pPQD_MotorPowMeasM1 = &PQD_MotorPowMeasM1; 
</#if><#-- MC.DRIVE_TYPE == "FOC" -->

<#if MC.DRIVE_TYPE == "FOC">
	<#if  MC.DUALDRIVE == true>
PQD_MotorPowMeas_Handle_t PQD_MotorPowMeasM2=
{
  .wConvFact = PQD_CONVERSION_FACTOR2
};
PQD_MotorPowMeas_Handle_t *pPQD_MotorPowMeasM2 = &PQD_MotorPowMeasM2; 
  
	</#if> 
</#if><#-- MC.DRIVE_TYPE == "FOC" -->
<#if MC.DRIVE_TYPE == "FOC">
/**
  * @brief  PI / PID Speed loop parameters Motor 1
  */
PID_Handle_t PIDSpeedHandle_M1 =
{
  .hDefKpGain          = (int16_t)PID_SPEED_KP_DEFAULT,
  .hDefKiGain          = (int16_t)PID_SPEED_KI_DEFAULT, 
  .wUpperIntegralLimit = (int32_t)IQMAX * (int32_t)SP_KIDIV,
  .wLowerIntegralLimit = -(int32_t)IQMAX * (int32_t)SP_KIDIV,
  .hUpperOutputLimit       = (int16_t)IQMAX, 
  .hLowerOutputLimit       = -(int16_t)IQMAX,
  .hKpDivisor          = (uint16_t)SP_KPDIV,
  .hKiDivisor          = (uint16_t)SP_KIDIV,
  .hKpDivisorPOW2      = (uint16_t)SP_KPDIV_LOG,
  .hKiDivisorPOW2      = (uint16_t)SP_KIDIV_LOG,
  .hDefKdGain           = 0x0000U,
  .hKdDivisor           = 0x0000U,
  .hKdDivisorPOW2       = 0x0000U,
};

/**
  * @brief  PI / PID Iq loop parameters Motor 1
  */
PID_Handle_t PIDIqHandle_M1 =
{
  .hDefKpGain          = (int16_t)PID_TORQUE_KP_DEFAULT,
  .hDefKiGain          = (int16_t)PID_TORQUE_KI_DEFAULT,
  .wUpperIntegralLimit = (int32_t)INT16_MAX * TF_KIDIV,
  .wLowerIntegralLimit = (int32_t)-INT16_MAX * TF_KIDIV,   
  .hUpperOutputLimit       = INT16_MAX,     
  .hLowerOutputLimit       = -INT16_MAX,           
  .hKpDivisor          = (uint16_t)TF_KPDIV,       
  .hKiDivisor          = (uint16_t)TF_KIDIV,       
  .hKpDivisorPOW2      = (uint16_t)TF_KPDIV_LOG,       
  .hKiDivisorPOW2      = (uint16_t)TF_KIDIV_LOG,        
  .hDefKdGain           = 0x0000U,
  .hKdDivisor           = 0x0000U,
  .hKdDivisorPOW2       = 0x0000U,
};

/**
  * @brief  PI / PID Id loop parameters Motor 1
  */
PID_Handle_t PIDIdHandle_M1 =
{
  .hDefKpGain          = (int16_t)PID_FLUX_KP_DEFAULT, 
  .hDefKiGain          = (int16_t)PID_FLUX_KI_DEFAULT, 
  .wUpperIntegralLimit = (int32_t)INT16_MAX * TF_KIDIV, 
  .wLowerIntegralLimit = (int32_t)-INT16_MAX * TF_KIDIV,
  .hUpperOutputLimit       = INT16_MAX,                 
  .hLowerOutputLimit       = -INT16_MAX,                
  .hKpDivisor          = (uint16_t)TF_KPDIV,          
  .hKiDivisor          = (uint16_t)TF_KIDIV,          
  .hKpDivisorPOW2      = (uint16_t)TF_KPDIV_LOG,       
  .hKiDivisorPOW2      = (uint16_t)TF_KIDIV_LOG,       
  .hDefKdGain           = 0x0000U,
  .hKdDivisor           = 0x0000U,
  .hKdDivisorPOW2       = 0x0000U,
};
</#if><#-- MC.DRIVE_TYPE == "FOC" -->

<#if  MC.FLUX_WEAKENING_ENABLING == true>
/**
  * @brief  FluxWeakeningCtrl component parameters Motor 1
  */
FW_Handle_t FW_M1 =
{
  .hMaxModule             = MAX_MODULE, 
  .hDefaultFW_V_Ref       = (int16_t)FW_VOLTAGE_REF,  
  .hDemagCurrent          = ID_DEMAG, 
  .wNominalSqCurr         = ((int32_t)NOMINAL_CURRENT*(int32_t)NOMINAL_CURRENT),
  .hVqdLowPassFilterBW    = M1_VQD_SW_FILTER_BW_FACTOR,   
  .hVqdLowPassFilterBWLOG = M1_VQD_SW_FILTER_BW_FACTOR_LOG  
};


/**
  * @brief  PI Flux Weakening control parameters Motor 1
  */
PID_Handle_t PIDFluxWeakeningHandle_M1 =
{
  .hDefKpGain          = (int16_t)FW_KP_GAIN,          
  .hDefKiGain          = (int16_t)FW_KI_GAIN,           
  .wUpperIntegralLimit = 0,          
  .wLowerIntegralLimit = (int32_t)(-NOMINAL_CURRENT) * (int32_t)FW_KIDIV, 
  .hUpperOutputLimit       = 0,                          
  .hLowerOutputLimit       = -INT16_MAX,                     
  .hKpDivisor          = (uint16_t)FW_KPDIV,              
  .hKiDivisor          = (uint16_t)FW_KIDIV,   
  .hKpDivisorPOW2      = (uint16_t)FW_KPDIV_LOG,
  .hKiDivisorPOW2      = (uint16_t)FW_KIDIV_LOG, 
  .hDefKdGain           = 0x0000U,
  .hKdDivisor           = 0x0000U,
  .hKdDivisorPOW2       = 0x0000U,
};

</#if>
<#if  MC.FLUX_WEAKENING_ENABLING2 == true>
/**
  * @brief  FluxWeakeningCtrl component parameters Motor 2
  */
FW_Handle_t FW_M2 =
{
  .hMaxModule             = MAX_MODULE2,                
  .hDefaultFW_V_Ref       = (int16_t)FW_VOLTAGE_REF2,    
  .hDemagCurrent          = ID_DEMAG2,                   
  .wNominalSqCurr         = ((int32_t)NOMINAL_CURRENT2*(int32_t)NOMINAL_CURRENT2),
  .hVqdLowPassFilterBW    = M2_VQD_SW_FILTER_BW_FACTOR,    
  .hVqdLowPassFilterBWLOG = M2_VQD_SW_FILTER_BW_FACTOR_LOG 
};

/**
  * @brief  PI Flux Weakening control parameters Motor 2
  */
PID_Handle_t PIDFluxWeakeningHandle_M2 =
{
  .hDefKpGain          = (int16_t)FW_KP_GAIN2,           
  .hDefKiGain          = (int16_t)FW_KI_GAIN2,           
  .wUpperIntegralLimit = 0,                             
  .wLowerIntegralLimit = (int32_t)(-NOMINAL_CURRENT2) * (int32_t)FW_KIDIV2,
  .hUpperOutputLimit       = 0,                 
  .hLowerOutputLimit       = -INT16_MAX,           
  .hKpDivisor          = (uint16_t)FW_KPDIV2,             
  .hKiDivisor          = (uint16_t)FW_KIDIV2,        
  .hKpDivisorPOW2      = (uint16_t)FW_KPDIV_LOG2,         
  .hKiDivisorPOW2      = (uint16_t)FW_KIDIV_LOG2,         
  .hDefKdGain           = 0x0000U,
  .hKdDivisor           = 0x0000U,
  .hKdDivisorPOW2       = 0x0000U,
};

</#if>
<#if  MC.FEED_FORWARD_CURRENT_REG_ENABLING == true>
/**
  * @brief  FeedForwardCtrl parameters Motor 1
  */
FF_Handle_t FF_M1 =
{
  .hVqdLowPassFilterBW    = M1_VQD_SW_FILTER_BW_FACTOR,  
  .wDefConstant_1D        = (int32_t)CONSTANT1_D,         
  .wDefConstant_1Q        = (int32_t)CONSTANT1_Q,          
  .wDefConstant_2         = (int32_t)CONSTANT2_QD,        
  .hVqdLowPassFilterBWLOG = M1_VQD_SW_FILTER_BW_FACTOR_LOG 
};

</#if>
<#if  MC.FEED_FORWARD_CURRENT_REG_ENABLING2 == true>
/**
  * @brief  FeedForwardCtrl parameters Motor 2
  */
FF_Handle_t FF_M2 =
{
  .hVqdLowPassFilterBW    = M2_VQD_SW_FILTER_BW_FACTOR,                                                        
  .wDefConstant_1D        = (int32_t)CONSTANT1_D2,        
  .wDefConstant_1Q        = (int32_t)CONSTANT1_Q2,        
  .wDefConstant_2         = (int32_t)CONSTANT2_QD2,       
  .hVqdLowPassFilterBWLOG = M2_VQD_SW_FILTER_BW_FACTOR_LOG                                                          
};

</#if>

<#if  MC.POSITION_CTRL_ENABLING == true>
PID_Handle_t PID_PosParamsM1 =
{
  .hDefKpGain          = (int16_t)PID_POSITION_KP_GAIN,
  .hDefKiGain          = (int16_t)PID_POSITION_KI_GAIN,
  .hDefKdGain          = (int16_t)PID_POSITION_KD_GAIN,
  .wUpperIntegralLimit = (int32_t)NOMINAL_CURRENT * (int32_t)PID_POSITION_KIDIV,
  .wLowerIntegralLimit = (int32_t)(-NOMINAL_CURRENT) * (int32_t)PID_POSITION_KIDIV,
  .hUpperOutputLimit   = (int16_t)NOMINAL_CURRENT,                          
  .hLowerOutputLimit   = -(int16_t)NOMINAL_CURRENT,                     
  .hKpDivisor          = (uint16_t)PID_POSITION_KPDIV,
  .hKiDivisor          = (uint16_t)PID_POSITION_KIDIV,
  .hKdDivisor          = (uint16_t)PID_POSITION_KDDIV,
  .hKpDivisorPOW2      = (uint16_t)PID_POSITION_KPDIV_LOG,
  .hKiDivisorPOW2      = (uint16_t)PID_POSITION_KIDIV_LOG,
  .hKdDivisorPOW2      = (uint16_t)PID_POSITION_KDDIV_LOG,
};

PosCtrl_Handle_t pPosCtrlM1 =
{
  .SamplingTime  = 1.0f/MEDIUM_FREQUENCY_TASK_RATE,
  .SysTickPeriod = 1.0f/SYS_TICK_FREQUENCY,  
<#if  MC.ENC_USE_CH3 == true >
  .AlignmentCfg  = TC_ABSOLUTE_ALIGNMENT_SUPPORTED,
<#else>
  .AlignmentCfg  = TC_ABSOLUTE_ALIGNMENT_NOT_SUPPORTED,  
</#if>
};

</#if>

<#if  MC.POSITION_CTRL_ENABLING2 == true>
PID_Handle_t PID_PosParamsM2 =
{
  .hDefKpGain          = (int16_t)PID_POSITION_KP_GAIN2,
  .hDefKiGain          = (int16_t)PID_POSITION_KI_GAIN2,
  .hDefKdGain          = (int16_t)PID_POSITION_KD_GAIN2,
  .wUpperIntegralLimit = (int32_t)NOMINAL_CURRENT2 * (int32_t)PID_POSITION_KIDIV2,
  .wLowerIntegralLimit = (int32_t)(-NOMINAL_CURRENT2) * (int32_t)PID_POSITION_KIDIV2,
  .hUpperOutputLimit   = (int16_t)NOMINAL_CURRENT2,                          
  .hLowerOutputLimit   = -(int16_t)NOMINAL_CURRENT2,                     
  .hKpDivisor          = (uint16_t)PID_POSITION_KPDIV2,
  .hKiDivisor          = (uint16_t)PID_POSITION_KIDIV2,
  .hKdDivisor          = (uint16_t)PID_POSITION_KDDIV2,
  .hKpDivisorPOW2      = (uint16_t)PID_POSITION_KPDIV_LOG2,
  .hKiDivisorPOW2      = (uint16_t)PID_POSITION_KIDIV_LOG2,
  .hKdDivisorPOW2      = (uint16_t)PID_POSITION_KDDIV_LOG2,
};

PosCtrl_Handle_t pPosCtrlM2 =
{
  .SamplingTime  = 1.0f/MEDIUM_FREQUENCY_TASK_RATE2,
  .SysTickPeriod = 1.0f/SYS_TICK_FREQUENCY,  
<#if  MC.ENC_USE_CH32 == true >
  .AlignmentCfg  = TC_ABSOLUTE_ALIGNMENT_SUPPORTED,
<#else>
  .AlignmentCfg  = TC_ABSOLUTE_ALIGNMENT_NOT_SUPPORTED,  
</#if>
};

</#if>

<#if MC.DRIVE_TYPE == "FOC" >
/**
  * @brief  SpeednTorque Controller parameters Motor 1
  */
SpeednTorqCtrl_Handle_t SpeednTorqCtrlM1 =
{
  .STCFrequencyHz =           		MEDIUM_FREQUENCY_TASK_RATE, 	 
  .MaxAppPositiveMecSpeedUnit =	(uint16_t)(MAX_APPLICATION_SPEED_UNIT), 
  .MinAppPositiveMecSpeedUnit =	(uint16_t)(MIN_APPLICATION_SPEED_UNIT), 
  .MaxAppNegativeMecSpeedUnit =	(int16_t)(-MIN_APPLICATION_SPEED_UNIT), 
  .MinAppNegativeMecSpeedUnit =	(int16_t)(-MAX_APPLICATION_SPEED_UNIT),
  .MaxPositiveTorque =				(int16_t)NOMINAL_CURRENT,		 
  .MinNegativeTorque =				-(int16_t)NOMINAL_CURRENT,       
  .ModeDefault =					DEFAULT_CONTROL_MODE,            
  .MecSpeedRefUnitDefault =		(int16_t)(DEFAULT_TARGET_SPEED_UNIT),
  .TorqueRefDefault =				(int16_t)DEFAULT_TORQUE_COMPONENT,
  .IdrefDefault =					(int16_t)DEFAULT_FLUX_COMPONENT,                                                                     
};
</#if><#-- MC.DRIVE_TYPE == "FOC" -->
<#if MC.DRIVE_TYPE == "FOC" >
	<#if MC.STATE_OBSERVER_PLL == true || MC.STATE_OBSERVER_CORDIC == true>
RevUpCtrl_Handle_t RevUpControlM1 =
{
  .hRUCFrequencyHz         = MEDIUM_FREQUENCY_TASK_RATE,   
  .hStartingMecAngle       = (int16_t)((int32_t)(STARTING_ANGLE_DEG)* 65536/360),
  .bFirstAccelerationStage = (ENABLE_SL_ALGO_FROM_PHASE-1u),   
  .hMinStartUpValidSpeed   = OBS_MINIMUM_SPEED_UNIT, 
  .hMinStartUpFlySpeed     = (int16_t)(OBS_MINIMUM_SPEED_UNIT/2),  
  .OTFStartupEnabled       = ${MC.OTF_STARTUP?string("true","false")},  
  .OTFPhaseParams         = {(uint16_t)500,                 
                                         0,                 
                             (int16_t)PHASE5_FINAL_CURRENT,
                             (void*)MC_NULL},
  .ParamsData             = {{(uint16_t)PHASE1_DURATION,(int16_t)(PHASE1_FINAL_SPEED_UNIT),(int16_t)PHASE1_FINAL_CURRENT,&RevUpControlM1.ParamsData[1]},
                             {(uint16_t)PHASE2_DURATION,(int16_t)(PHASE2_FINAL_SPEED_UNIT),(int16_t)PHASE2_FINAL_CURRENT,&RevUpControlM1.ParamsData[2]},
                             {(uint16_t)PHASE3_DURATION,(int16_t)(PHASE3_FINAL_SPEED_UNIT),(int16_t)PHASE3_FINAL_CURRENT,&RevUpControlM1.ParamsData[3]},
                             {(uint16_t)PHASE4_DURATION,(int16_t)(PHASE4_FINAL_SPEED_UNIT),(int16_t)PHASE4_FINAL_CURRENT,&RevUpControlM1.ParamsData[4]},
                             {(uint16_t)PHASE5_DURATION,(int16_t)(PHASE5_FINAL_SPEED_UNIT),(int16_t)PHASE5_FINAL_CURRENT,(void*)MC_NULL},
                            },
};
	</#if>
</#if><#-- MC.DRIVE_TYPE == "FOC" -->
<#if MC.DRIVE_TYPE == "FOC" >
	<#if CondFamily_STM32F3 &&  MC.THREE_SHUNT == true> 
PWMC_R3_1_Handle_t PWM_Handle_M1 =
{
  {
    .pFctGetPhaseCurrents              = &R3_1_GetPhaseCurrents,    
    .pFctSwitchOffPwm                  = &R3_1_SwitchOffPWM,             
    .pFctSwitchOnPwm                   = &R3_1_SwitchOnPWM,              
    .pFctCurrReadingCalib              = &R3_1_CurrentReadingPolarization,
    .pFctTurnOnLowSides                = &R3_1_TurnOnLowSides,         
    .pFctIsOverCurrentOccurred         = &R3_1_IsOverCurrentOccurred,    
    .pFctOCPSetReferenceVoltage        = MC_NULL,
    .pFctRLDetectionModeEnable         = &R3_1_RLDetectionModeEnable,    
    .pFctRLDetectionModeDisable        = &R3_1_RLDetectionModeDisable,   
    .pFctRLDetectionModeSetDuty        = &R3_1_RLDetectionModeSetDuty,    
    .hT_Sqrt3 = (PWM_PERIOD_CYCLES*SQRT3FACTOR)/16384u,   
    .Sector = 0,    
    .CntPhA = 0,
    .CntPhB = 0,
    .CntPhC = 0,
    .SWerror = 0,
    .TurnOnLowSidesAction = false, 
    .OffCalibrWaitTimeCounter = 0, 
    .Motor = M1,     
    .RLDetectionMode = false, 
    .Ia = 0, 
    .Ib = 0, 
    .Ic = 0, 
    .DTTest = 0,   
    .DTCompCnt = DTCOMPCNT, 
    .PWMperiod          = PWM_PERIOD_CYCLES,
    .OffCalibrWaitTicks = (uint16_t)((SYS_TICK_FREQUENCY * OFFCALIBRWAIT_MS)/ 1000),
    .Ton                 = TON,                              
    .Toff                = TOFF
  },
  .PhaseAOffset = 0,   
  .PhaseBOffset = 0,   
  .PhaseCOffset = 0,   
  .Half_PWMPeriod = PWM_PERIOD_CYCLES/2u, 
  .OverCurrentFlag = false,    
  .OverVoltageFlag = false,    
  .BrakeActionLock = false,                               
  .pParams_str = &R3_1_ParamsM1
};

	<#elseif CondFamily_STM32F3 &&  MC.SINGLE_SHUNT == true> 
PWMC_R1_F3_Handle_t PWM_Handle_M1 =
{  
  {
    .pFctGetPhaseCurrents              = &R1F30X_GetPhaseCurrents,    
    .pFctSwitchOffPwm                  = &R1F30X_SwitchOffPWM,             
    .pFctSwitchOnPwm                   = &R1F30X_SwitchOnPWM,              
    .pFctCurrReadingCalib              = &R1F30X_CurrentReadingCalibration,
    .pFctTurnOnLowSides                = &R1F30X_TurnOnLowSides,         
    .pFctSetADCSampPointSectX          = &R1F30X_CalcDutyCycles,             
    .pFctIsOverCurrentOccurred         = &R1F30X_IsOverCurrentOccurred,    
    .pFctOCPSetReferenceVoltage        = MC_NULL,
    .pFctRLDetectionModeEnable         = MC_NULL,    
    .pFctRLDetectionModeDisable        = MC_NULL,   
    .pFctRLDetectionModeSetDuty        = MC_NULL,   
    .hT_Sqrt3 = (PWM_PERIOD_CYCLES*SQRT3FACTOR)/16384u,  
    .Sector = 0,    
    .CntPhA = 0,
    .CntPhB = 0,
    .CntPhC = 0,
    .SWerror = 0,
    .TurnOnLowSidesAction = false, 
    .OffCalibrWaitTimeCounter = 0,
    .Motor = M1,
    .RLDetectionMode = false,
    .Ia = 0, 
    .Ib = 0, 
    .Ic = 0, 
    .DTTest = 0,    
    .DTCompCnt = 0, 
    .PWMperiod          = PWM_PERIOD_CYCLES,     
    .OffCalibrWaitTicks = (uint16_t)((SYS_TICK_FREQUENCY * OFFCALIBRWAIT_MS)/ 1000), 
  
  },
  .DmaBuff = {0,0},  
  .CntSmp1 = 0,                    
  .CntSmp2 = 0,                    
  .sampCur1 = 0,                    
  .sampCur2 = 0,                    
  .CurrAOld = 0,                  
  .CurrBOld = 0,                   
  .Inverted_pwm_new = 0,                                 
  .Flags = 0,                     
  .PhaseOffset = 0,                
  .Index = 0,                      
  .Half_PWMPeriod = PWM_PERIOD_CYCLES/2u,              
  .ADC_JSQR = 0,                                                
  .PreloadDisableActing = 0,      
  .PreloadDisableCC1 = 0,                                     
  .PreloadDisableCC2 = 0,                                        
  .PreloadDisableCC3 = 0,                                       
  .PreloadDMAy_Chx = 0,            
  .DistortionDMAy_Chx = 0,         
  .OverCurrentFlag = false,        
  .OverVoltageFlag = false,        
  .BrakeActionLock = false,        

  .pParams_str =  &R1_F30XParamsM1,
};

	<#elseif CondFamily_STM32F4 &&  MC.SINGLE_SHUNT == true>  
PWMC_R1_F4_Handle_t PWM_Handle_M1=
{
  ._Super ={
    .pFctGetPhaseCurrents              = &R1F4XX_GetPhaseCurrents,    
    .pFctSwitchOffPwm                  = &R1F4XX_SwitchOffPWM,             
    .pFctSwitchOnPwm                   = &R1F4XX_SwitchOnPWM,              
    .pFctCurrReadingCalib              = &R1F4XX_CurrentReadingCalibration,
    .pFctTurnOnLowSides                = &R1F4XX_TurnOnLowSides,         
    .pFctSetADCSampPointSectX          = &R1F4XX_CalcDutyCycles,         
    .pFctIsOverCurrentOccurred         = &R1F4XX_IsOverCurrentOccurred,    
    .pFctOCPSetReferenceVoltage        = MC_NULL,
    .pFctRLDetectionModeEnable         = MC_NULL,
    .pFctRLDetectionModeDisable        = MC_NULL,   
    .pFctRLDetectionModeSetDuty        = MC_NULL,   
    .hT_Sqrt3 = (PWM_PERIOD_CYCLES*SQRT3FACTOR)/16384u,   
    .Sector = 0,   
    .CntPhA = 0,
    .CntPhB = 0,
    .CntPhC = 0,
    .SWerror = 0,
    .TurnOnLowSidesAction = false, 
    .OffCalibrWaitTimeCounter = 0, 
    .Motor = M1,     
    .RLDetectionMode = false, 
    .Ia = 0, 
    .Ib = 0, 
    .Ic = 0, 
    .DTTest = 0,    
    .DTCompCnt = DTCOMPCNT,
    .PWMperiod          = PWM_PERIOD_CYCLES,    
    .OffCalibrWaitTicks = (uint16_t)((SYS_TICK_FREQUENCY * OFFCALIBRWAIT_MS)/ 1000),                        
    .Ton                 = TON,                             
    .Toff                = TOFF                              
  },      
  .Half_PWMPeriod = PWM_PERIOD_CYCLES/2u,   
  .hDmaBuff = {0,0},  
  .hCCDmaBuffCh4 = {0,0,0,0},
  .hCntSmp1 = 0,       
  .hCntSmp2 = 0,       
  .sampCur1 = 0,       
  .sampCur2 = 0,       
  .hCurrAOld = 0,      
  .hCurrBOld = 0,      
  .hCurrCOld = 0,      
  .bInverted_pwm = 0,  
  .bInverted_pwm_new = 0,                        
  .hPreloadCCMR2Set = 0,        
  .bDMATot = 0,                                 
  .bDMACur = 0,           
  .hFlags = 0,                                    
  .pDrive = MC_NULL,                             
  .wPhaseOffset = 0,      
 .bIndex = 0,                   
 .pTIMx_2_CCR = 0,
 .pParams_str = &R1_F4_ParamsM1,
};

	<#elseif CondFamily_STM32F4 &&  MC.THREE_SHUNT == true>
PWMC_R3_1_Handle_t PWM_Handle_M1 =
{
  {
        .pFctGetPhaseCurrents       = &R3_1_GetPhaseCurrents,
        .pFctSwitchOffPwm           = &R3_1_SwitchOffPWM,
        .pFctSwitchOnPwm            = &R3_1_SwitchOnPWM,
        .pFctCurrReadingCalib       = &R3_1_CurrentReadingCalibration,
        .pFctTurnOnLowSides         = &R3_1_TurnOnLowSides,
        .pFctSetADCSampPointSectX   = &R3_1_SetADCSampPointSectX,
        .pFctIsOverCurrentOccurred  = &R3_1_IsOverCurrentOccurred,
        .pFctOCPSetReferenceVoltage = MC_NULL,
        .pFctRLDetectionModeEnable  = &R3_1_RLDetectionModeEnable,
        .pFctRLDetectionModeDisable = &R3_1_RLDetectionModeDisable,
        .pFctRLDetectionModeSetDuty = &R3_1_RLDetectionModeSetDuty,
        .hT_Sqrt3 = (PWM_PERIOD_CYCLES*SQRT3FACTOR)/16384u,
        .Sector = 0,
        .CntPhA = 0,
        .CntPhB = 0,
        .CntPhC = 0,
        .SWerror = 0,
        .TurnOnLowSidesAction = false,
        .OffCalibrWaitTimeCounter = 0,
        .Motor = M1,
        .RLDetectionMode = false,
        .Ia = 0,
        .Ib = 0,
        .Ic = 0,
        .DTTest = 0,
        .DTCompCnt = DTCOMPCNT,
        .PWMperiod          = PWM_PERIOD_CYCLES,
        .OffCalibrWaitTicks = (uint16_t)((SYS_TICK_FREQUENCY * OFFCALIBRWAIT_MS)/ 1000),
        .Ton                 = TON,
        .Toff                = TOFF
  },      
  .PhaseAOffset = 0,
  .PhaseBOffset = 0,
  .PhaseCOffset = 0,
  .Half_PWMPeriod = PWM_PERIOD_CYCLES/2u,
  .PolarizationCounter = 0,     
  .ADC_ExternalTriggerInjected = 0,
  .ADCTriggerEdge = 0,
  .OverCurrentFlag = false,   
  .OverVoltageFlag = false,   
  .BrakeActionLock = false,   

  .pParams_str = &R3_1_ParamsM1,

};

	<#elseif CondFamily_STM32F4 &&  MC.THREE_SHUNT_INDEPENDENT_RESOURCES == true> 
PWMC_R3_2_Handle_t PWM_Handle_M1=
{
  {
    .pFctGetPhaseCurrents              = &R3_2_GetPhaseCurrents,    
    .pFctSwitchOffPwm                  = &R3_2_SwitchOffPWM,             
    .pFctSwitchOnPwm                   = &R3_2_SwitchOnPWM,              
    .pFctCurrReadingCalib              = &R3_2_CurrentReadingCalibration,
    .pFctTurnOnLowSides                = &R3_2_TurnOnLowSides,           
    .pFctSetADCSampPointSectX          = &R3_2_SetADCSampPointSectX,
    .pFctIsOverCurrentOccurred         = &R3_2_IsOverCurrentOccurred,    
    .pFctOCPSetReferenceVoltage        = MC_NULL,
    .pFctRLDetectionModeEnable         = &R3_2_RLDetectionModeEnable,    
    .pFctRLDetectionModeDisable        = &R3_2_RLDetectionModeDisable,   
    .pFctRLDetectionModeSetDuty        = &R3_2_RLDetectionModeSetDuty,   
    .hT_Sqrt3 = (PWM_PERIOD_CYCLES*SQRT3FACTOR)/16384u,   
    .Sector = 0,   
    .CntPhA = 0,
    .CntPhB = 0,
    .CntPhC = 0,
    .SWerror = 0,
    .TurnOnLowSidesAction = false, 
    .OffCalibrWaitTimeCounter = 0, 
    .Motor = M1,     
    .RLDetectionMode = false, 
    .Ia = 0, 
    .Ib = 0, 
    .Ic = 0, 
    .DTTest = 0,   
    .DTCompCnt = DTCOMPCNT, 
    .PWMperiod          = PWM_PERIOD_CYCLES,
    .OffCalibrWaitTicks = (uint16_t)((SYS_TICK_FREQUENCY * OFFCALIBRWAIT_MS)/ 1000),
    .Ton                 = TON,                              
    .Toff                = TOFF
 },
  .Half_PWMPeriod = PWM_PERIOD_CYCLES/2u,                               
  .PhaseAOffset = 0,   
  .PhaseBOffset = 0,   
  .PhaseCOffset = 0,   
   
  .pParams_str = &R3_2_ParamsM1
};

	<#elseif CondFamily_STM32F0 &&  MC.SINGLE_SHUNT == true>
PWMC_R1_F0_Handle_t PWM_Handle_M1 =
{
  {
    .pFctGetPhaseCurrents              = &R1F0XX_GetPhaseCurrents,    
    .pFctSwitchOffPwm                  = &R1F0XX_SwitchOffPWM,             
    .pFctSwitchOnPwm                   = &R1F0XX_SwitchOnPWM,              
    .pFctCurrReadingCalib              = &R1F0XX_CurrentReadingCalibration,
    .pFctTurnOnLowSides                = &R1F0XX_TurnOnLowSides,         
    .pFctSetADCSampPointSectX          = &R1F0XX_CalcDutyCycles,         
    .pFctIsOverCurrentOccurred         = &R1F0XX_IsOverCurrentOccurred,    
    .pFctOCPSetReferenceVoltage        = MC_NULL,
    .pFctRLDetectionModeEnable         = MC_NULL,    
    .pFctRLDetectionModeDisable        = MC_NULL,   
    .pFctRLDetectionModeSetDuty        = MC_NULL,   
    .hT_Sqrt3 = (PWM_PERIOD_CYCLES*SQRT3FACTOR)/16384u,   
    .Sector = 0,   
    .CntPhA = 0,
    .CntPhB = 0,
    .CntPhC = 0,
    .SWerror = 0,
    .TurnOnLowSidesAction = false, 
    .OffCalibrWaitTimeCounter = 0, 
    .Motor = 0,     
    .RLDetectionMode = false, 
    .Ia = 0, 
    .Ib = 0, 
    .Ic = 0, 
    .DTTest = 0,    
    .DTCompCnt = DTCOMPCNT, 
    .PWMperiod = PWM_PERIOD_CYCLES,    
    .OffCalibrWaitTicks = (uint16_t)((SYS_TICK_FREQUENCY * OFFCALIBRWAIT_MS)/ 1000),
    .Ton                 = TON,
    .Toff                = TOFF
  },
  .Half_PWMPeriod = PWM_PERIOD_CYCLES/2u,
  .PhaseOffset = 0,      
  .DmaBuff = {0,0},  
  .CCDmaBuffCh4 = {0,0,0,0},
  .CntSmp1 = 0,         
  .CntSmp2 = 0,         
  .sampCur1 = 0,          
  .sampCur2 = 0,          
  .CurrAOld = 0,         
  .CurrBOld = 0,         
  .CurrCOld = 0,         
  .Inverted_pwm = 0,                               
  .Inverted_pwm_new = 0,                                                      
  .DMATot = 0,                                      
  .DMACur = 0,           
  .Flags = 0,                                    
  .CurConv = {0,0},
  .ADC_ExtTrigConv = 0,                                
  .OverCurrentFlag = false,       
  .pParams_str = &R1_F0XX_Params,
};

	<#elseif CondFamily_STM32F0 &&  MC.THREE_SHUNT == true>
PWMC_R3_1_Handle_t PWM_Handle_M1 =
{
  {
    .pFctGetPhaseCurrents              = &R3_1_GetPhaseCurrents,    
    .pFctSwitchOffPwm                  = &R3_1_SwitchOffPWM,             
    .pFctSwitchOnPwm                   = &R3_1_SwitchOnPWM,              
    .pFctCurrReadingCalib              = &R3_1_CurrentReadingCalibration,
    .pFctTurnOnLowSides                = &R3_1_TurnOnLowSides,             
    .pFctSetADCSampPointSectX          = &R3_1_SetADCSampPointSectX,     
    .pFctIsOverCurrentOccurred         = &R3_1_IsOverCurrentOccurred,    
    .pFctOCPSetReferenceVoltage        = MC_NULL,
    .pFctRLDetectionModeEnable         = MC_NULL,    
    .pFctRLDetectionModeDisable        = MC_NULL,   
    .pFctRLDetectionModeSetDuty        = MC_NULL,   
    .hT_Sqrt3 = (PWM_PERIOD_CYCLES*SQRT3FACTOR)/16384u,     
    .Sector = 0,    
    .CntPhA = 0,
    .CntPhB = 0,
    .CntPhC = 0,
    .SWerror = 0,
    .TurnOnLowSidesAction = false, 
    .OffCalibrWaitTimeCounter = 0, 
    .Motor = 0,     
    .RLDetectionMode = false,
    .Ia = 0, 
    .Ib = 0, 
    .Ic = 0, 
    .DTTest = 0,    
    .DTCompCnt = DTCOMPCNT,
    .PWMperiod = PWM_PERIOD_CYCLES,
    .OffCalibrWaitTicks = (uint16_t)((SYS_TICK_FREQUENCY * OFFCALIBRWAIT_MS)/ 1000),
    .Ton                 = TON,
    .Toff                = TOFF
  },
  .PhaseAOffset = 0,  
  .PhaseBOffset = 0,  
  .PhaseCOffset = 0,  
  .Half_PWMPeriod = PWM_PERIOD_CYCLES/2u, 
  .OverCurrentFlag = false,  
  .OverVoltageFlag = false,  
  .BrakeActionLock = false,  
  .PolarizationCounter = 0,
  .ADC1_DMA_converted = {0,0}, 
  .pParams_str = &R3_1_Params
};

	<#elseif CondFamily_STM32F3 &&  (MC.THREE_SHUNT_SHARED_RESOURCES || MC.THREE_SHUNT_INDEPENDENT_RESOURCES)>

PWMC_R3_2_Handle_t PWM_Handle_M1 =
{
  {
    .pFctGetPhaseCurrents              = &R3_2_GetPhaseCurrents,    
    .pFctSwitchOffPwm                  = &R3_2_SwitchOffPWM,             
    .pFctSwitchOnPwm                   = &R3_2_SwitchOnPWM,              
    .pFctCurrReadingCalib              = &R3_2_CurrentReadingPolarization,
    .pFctTurnOnLowSides                = &R3_2_TurnOnLowSides,         
    .pFctIsOverCurrentOccurred         = &R3_2_IsOverCurrentOccurred,    
    .pFctOCPSetReferenceVoltage        = MC_NULL,
    .pFctRLDetectionModeEnable         = &R3_2_RLDetectionModeEnable,    
    .pFctRLDetectionModeDisable        = &R3_2_RLDetectionModeDisable,   
    .pFctRLDetectionModeSetDuty        = &R3_2_RLDetectionModeSetDuty,    
    .hT_Sqrt3 = (PWM_PERIOD_CYCLES*SQRT3FACTOR)/16384u,   
    .Sector = 0,    
    .CntPhA = 0,
    .CntPhB = 0,
    .CntPhC = 0,
    .SWerror = 0,
    .TurnOnLowSidesAction = false, 
    .OffCalibrWaitTimeCounter = 0, 
    .Motor = M1,     
    .RLDetectionMode = false, 
    .Ia = 0, 
    .Ib = 0, 
    .Ic = 0, 
    .DTTest = 0,   
    .DTCompCnt = DTCOMPCNT, 
    .PWMperiod          = PWM_PERIOD_CYCLES,
    .OffCalibrWaitTicks = (uint16_t)((SYS_TICK_FREQUENCY * OFFCALIBRWAIT_MS)/ 1000),
    .Ton                 = TON,                              
    .Toff                = TOFF
  },
  .PhaseAOffset = 0,   
  .PhaseBOffset = 0,   
  .PhaseCOffset = 0,   
  .Half_PWMPeriod = PWM_PERIOD_CYCLES/2u, 
  .OverCurrentFlag = false,    
  .OverVoltageFlag = false,    
  .BrakeActionLock = false,                               
  .pParams_str = &R3_2_ParamsM1
};


	<#elseif CondFamily_STM32L4 &&  MC.SINGLE_SHUNT == true> 
PWMC_R1_L4_Handle_t PWM_Handle_M1 =
{  
  {
    .pFctGetPhaseCurrents              = &R1L4XX_GetPhaseCurrents,    
    .pFctSwitchOffPwm                  = &R1L4XX_SwitchOffPWM,             
    .pFctSwitchOnPwm                   = &R1L4XX_SwitchOnPWM,              
    .pFctCurrReadingCalib              = &R1L4XX_CurrentReadingCalibration,
    .pFctTurnOnLowSides                = &R1L4XX_TurnOnLowSides,         
    .pFctSetADCSampPointSectX          = &R1L4XX_CalcDutyCycles,             
    .pFctIsOverCurrentOccurred         = &R1L4XX_IsOverCurrentOccurred,    
    .pFctOCPSetReferenceVoltage        = MC_NULL,
    .pFctRLDetectionModeEnable         = MC_NULL,    
    .pFctRLDetectionModeDisable        = MC_NULL,   
    .pFctRLDetectionModeSetDuty        = MC_NULL,   
    .hT_Sqrt3 = (PWM_PERIOD_CYCLES*SQRT3FACTOR)/16384u,  
    .Sector = 0,    
    .CntPhA = 0,
    .CntPhB = 0,
    .CntPhC = 0,
    .SWerror = 0,
    .TurnOnLowSidesAction = false, 
    .OffCalibrWaitTimeCounter = 0,
    .Motor = M1,
    .RLDetectionMode = false,
    .Ia = 0, 
    .Ib = 0, 
    .Ic = 0, 
    .DTTest = 0,    
    .DTCompCnt = 0, 
    .PWMperiod          = PWM_PERIOD_CYCLES,     
    .OffCalibrWaitTicks = (uint16_t)((SYS_TICK_FREQUENCY * OFFCALIBRWAIT_MS)/ 1000), 
  
  },
  .DmaBuff = {0,0},  
  .CntSmp1 = 0,                    
  .CntSmp2 = 0,                    
  .sampCur1 = 0,                    
  .sampCur2 = 0,                    
  .CurrAOld = 0,                  
  .CurrBOld = 0,                   
  .Inverted_pwm_new = 0,                                 
  .Flags = 0,                     
  .PhaseOffset = 0,                
  .Index = 0,                      
  .Half_PWMPeriod = PWM_PERIOD_CYCLES/2u,              
  .ADC_JSQR = 0,                                                
  .PreloadDisableActing = 0,      
  .PreloadDisableCC1 = 0,                                     
  .PreloadDisableCC2 = 0,                                        
  .PreloadDisableCC3 = 0,                                       
  .PreloadDMAy_Chx = 0,            
  .DistortionDMAy_Chx = 0,         
  .OverCurrentFlag = false,        
  .OverVoltageFlag = false,        
  .BrakeActionLock = false,        
  .pParams_str =  &R1_L4XXParamsM1,
};

	<#elseif CondFamily_STM32L4 &&  MC.THREE_SHUNT == true>
PWMC_R3_1_Handle_t PWM_Handle_M1 =
{
  {
    .pFctGetPhaseCurrents       = &R3_1_GetPhaseCurrents,    
    .pFctSwitchOffPwm           = &R3_1_SwitchOffPWM,                       
    .pFctSwitchOnPwm            = &R3_1_SwitchOnPWM,                         
    .pFctCurrReadingCalib       = &R3_1_CurrentReadingCalibration,    
    .pFctTurnOnLowSides         = &R3_1_TurnOnLowSides,          
    .pFctSetADCSampPointSectX   = &R3_1_SetADCSampPointSectX,                        
    .pFctIsOverCurrentOccurred  = &R3_1_IsOverCurrentOccurred,      
    .pFctOCPSetReferenceVoltage = MC_NULL,
    .pFctRLDetectionModeEnable  = &R3_1_RLDetectionModeEnable,     
    .pFctRLDetectionModeDisable = &R3_1_RLDetectionModeDisable,    
    .pFctRLDetectionModeSetDuty = &R3_1_RLDetectionModeSetDuty,                              
    .hT_Sqrt3 = (PWM_PERIOD_CYCLES*SQRT3FACTOR)/16384u,   
    .Sector = 0,   
    .CntPhA = 0,
    .CntPhB = 0,
    .CntPhC = 0,
    .SWerror = 0,
    .TurnOnLowSidesAction = false, 
    .OffCalibrWaitTimeCounter = 0, 
    .Motor = M1,     
    .RLDetectionMode = false, 
    .Ia = 0, 
    .Ib = 0, 
    .Ic = 0, 
    .DTTest = 0,    
    .DTCompCnt = DTCOMPCNT, 
    .PWMperiod          = PWM_PERIOD_CYCLES,
    .OffCalibrWaitTicks = (uint16_t)((SYS_TICK_FREQUENCY * OFFCALIBRWAIT_MS)/ 1000),                       
    .Ton                 = TON,                              
    .Toff                = TOFF                            
  
  },
  .PhaseAOffset = 0,   
  .PhaseBOffset = 0,   
  .PhaseCOffset = 0,   
  .Half_PWMPeriod = PWM_PERIOD_CYCLES/2u,  
  .PolarizationCounter = 0,     
  .ADC_ExternalTriggerInjected = 0,
  .OverCurrentFlag = false,   
  .OverVoltageFlag = false,   
  .BrakeActionLock = false,   
  .pParams_str = &R3_1_ParamsM1,

};

	<#elseif CondFamily_STM32L4 &&  MC.THREE_SHUNT_INDEPENDENT_RESOURCES == true>
/**
  * @brief  Current sensor parameters Motor 1 - three shunt - F30x - Independent Resources
  */
PWMC_R3_2_Handle_t PWM_Handle_M1 =
{
 {
    .pFctGetPhaseCurrents              = &R3_2_GetPhaseCurrents,    
    .pFctSwitchOffPwm                  = &R3_2_SwitchOffPWM,             
    .pFctSwitchOnPwm                   = &R3_2_SwitchOnPWM,              
    .pFctCurrReadingCalib              = &R3_2_CurrentReadingCalibration,
    .pFctTurnOnLowSides                = &R3_2_TurnOnLowSides,         
    .pFctSetADCSampPointSectX          = &R3_2_SetADCSampPointSectX,            
    .pFctIsOverCurrentOccurred         = &R3_2_IsOverCurrentOccurred,    
    .pFctOCPSetReferenceVoltage        = MC_NULL,
    .pFctRLDetectionModeEnable         = &R3_2_RLDetectionModeEnable,    
    .pFctRLDetectionModeDisable        = &R3_2_RLDetectionModeDisable,   
    .pFctRLDetectionModeSetDuty        = &R3_2_RLDetectionModeSetDuty,   
    .hT_Sqrt3 = (PWM_PERIOD_CYCLES*SQRT3FACTOR)/16384u,   
    .Sector = 0,    
    .CntPhA = 0,
    .CntPhB = 0,
    .CntPhC = 0,
    .SWerror = 0,
    .TurnOnLowSidesAction = false, 
    .OffCalibrWaitTimeCounter = 0, 
    .Motor = M1,     
    .RLDetectionMode = false, 
    .Ia = 0, 
    .Ib = 0, 
    .Ic = 0, 
    .DTTest = 0,   
    .DTCompCnt = DTCOMPCNT, 
    .PWMperiod          = PWM_PERIOD_CYCLES,
    .OffCalibrWaitTicks = (uint16_t)((SYS_TICK_FREQUENCY * OFFCALIBRWAIT_MS)/ 1000),
    .Ton                 = TON,                              
    .Toff                = TOFF
 },
  .PhaseAOffset = 0,                                
  .PhaseBOffset = 0,                                
  .PhaseCOffset = 0,                                                                  
  .Half_PWMPeriod = PWM_PERIOD_CYCLES/2u,                               
  .PolarizationCounter = 0,                                                                             
  .ADC_ExternalTriggerInjected = 0,                  
  .OverCurrentFlag = false,                          
  .OverVoltageFlag = false,                          
  .BrakeActionLock = false, 
  .pParams_str = &R3_2_ParamsM1,
};

	<#elseif CondFamily_STM32L4 &&  MC.ICS_SENSORS == true>
/**
  * @brief  Current sensor parameters Dual Drive Motor 1 - ICS, STM32L4x
  */
PWMC_ICS_Handle_t PWM_Handle_M1 = {
  {
    .pFctGetPhaseCurrents              = &ICS_GetPhaseCurrents,    
    .pFctSwitchOffPwm                  = &ICS_SwitchOffPWM,             
    .pFctSwitchOnPwm                   = &ICS_SwitchOnPWM,              
    .pFctCurrReadingCalib              = &ICS_CurrentReadingCalibration,
    .pFctTurnOnLowSides                = &ICS_TurnOnLowSides,         
    .pFctSetADCSampPointSectX          = &ICS_WriteTIMRegisters,                
    .pFctIsOverCurrentOccurred         = &ICS_IsOverCurrentOccurred,    
    .pFctOCPSetReferenceVoltage        = MC_NULL,
    .pFctRLDetectionModeEnable         = MC_NULL,    
    .pFctRLDetectionModeDisable        = MC_NULL,   
    .pFctRLDetectionModeSetDuty        = MC_NULL,   
    .hT_Sqrt3 = (PWM_PERIOD_CYCLES*SQRT3FACTOR)/16384u,  
    .Sector = 0,   
    .CntPhA = 0,
    .CntPhB = 0,
    .CntPhC = 0,
    .SWerror = 0,
    .TurnOnLowSidesAction = false, 
    .OffCalibrWaitTimeCounter = 0, 
    .Motor = M1,     
    .RLDetectionMode = false, 
    .Ia = 0,
    .Ib = 0,
    .Ic = 0,
    .DTTest = 0,   
    .DTCompCnt = DTCOMPCNT,
    .PWMperiod          = PWM_PERIOD_CYCLES,                                                  
    .OffCalibrWaitTicks = (uint16_t)((SYS_TICK_FREQUENCY * OFFCALIBRWAIT_MS)/ 1000),                                                                                                                                                       
    .Ton                 = TON,                             
    .Toff                = TOFF                             
  
  },
  .PhaseAOffset = 0,   
  .PhaseBOffset = 0,  
  .Half_PWMPeriod = PWM_PERIOD_CYCLES/2u,  
  .PolarizationCounter = 0,
		<#if MC.PWM_TIMER_SELECTION == "PWM_TIM1">
  .ADCConfig1 =   MC_${MC.PHASE_U_CURR_CHANNEL} << 8 | LL_ADC_INJ_TRIG_EXT_RISING | LL_ADC_INJ_TRIG_EXT_TIM1_CH4,  
  .ADCConfig2 =   MC_${MC.PHASE_V_CURR_CHANNEL} << 8 | LL_ADC_INJ_TRIG_EXT_RISING | LL_ADC_INJ_TRIG_EXT_TIM1_CH4,     
		<#elseif MC.PWM_TIMER_SELECTION == "PWM_TIM8">
  .ADCConfig1 =   MC_${MC.PHASE_U_CURR_CHANNEL} << 8 | LL_ADC_INJ_TRIG_EXT_RISING | LL_ADC_INJ_TRIG_EXT_TIM8_CH4,  
  .ADCConfig2 =   MC_${MC.PHASE_V_CURR_CHANNEL} << 8 | LL_ADC_INJ_TRIG_EXT_RISING | LL_ADC_INJ_TRIG_EXT_TIM8_CH4,
		</#if>                        
  .OverCurrentFlag = false,    
  .OverVoltageFlag = false,    
  .BrakeActionLock = false,    
                                                            
  .pParams_str = &ICS_ParamsM1                               
};

	<#elseif CondFamily_STM32F7 &&  MC.SINGLE_SHUNT == true> 
PWMC_R1_F7_Handle_t PWM_Handle_M1 =
{  
  {
    .pFctGetPhaseCurrents              = &R1F7XX_GetPhaseCurrents,    
    .pFctSwitchOffPwm                  = &R1F7XX_SwitchOffPWM,             
    .pFctSwitchOnPwm                   = &R1F7XX_SwitchOnPWM,              
    .pFctCurrReadingCalib              = &R1F7XX_CurrentReadingCalibration,
    .pFctTurnOnLowSides                = &R1F7XX_TurnOnLowSides,         
    .pFctSetADCSampPointSectX          = &R1F7XX_CalcDutyCycles,                  
    .pFctIsOverCurrentOccurred         = &R1F7XX_IsOverCurrentOccurred,    
    .pFctOCPSetReferenceVoltage        = MC_NULL,
    .pFctRLDetectionModeEnable         = MC_NULL,    
    .pFctRLDetectionModeDisable        = MC_NULL,   
    .pFctRLDetectionModeSetDuty        = MC_NULL,   
    .hT_Sqrt3 = (PWM_PERIOD_CYCLES*SQRT3FACTOR)/16384u,  
    .Sector = 0,    
    .CntPhA = 0,
    .CntPhB = 0,
    .CntPhC = 0,
    .SWerror = 0,
    .TurnOnLowSidesAction = false, 
    .OffCalibrWaitTimeCounter = 0,
    .Motor = M1,
    .RLDetectionMode = false,
    .Ia = 0, 
    .Ib = 0, 
    .Ic = 0, 
    .DTTest = 0,    
    .DTCompCnt = 0, 
    .PWMperiod          = PWM_PERIOD_CYCLES,     
    .OffCalibrWaitTicks = (uint16_t)((SYS_TICK_FREQUENCY * OFFCALIBRWAIT_MS)/ 1000), 
  
  },
  .DmaBuff = {0,0},  
  .CntSmp1 = 0,                    
  .CntSmp2 = 0,                    
  .sampCur1 = 0,                    
  .sampCur2 = 0,                    
  .CurrAOld = 0,                  
  .CurrBOld = 0,                   
  .Inverted_pwm_new = 0,                                 
  .Flags = 0,                                     
  .PhaseOffset = 0,                
  .PolarizationCounter = 0,                      
  .Half_PWMPeriod = PWM_PERIOD_CYCLES/2u,              
  .ADC_JSQR = 0,                                                         
  .DistortionDMAy_Chx = 0,         
  .OverCurrentFlag = false,        
  .OverVoltageFlag = false,        
  .BrakeActionLock = false,        

  .pParams_str =  &R1_F7_ParamsM1,
};

	<#elseif CondFamily_STM32F7 &&  MC.THREE_SHUNT == true> 
PWMC_R3_1_Handle_t PWM_Handle_M1 =
{
  {
    .pFctGetPhaseCurrents       = &R3_1_GetPhaseCurrents,    
    .pFctSwitchOffPwm           = &R3_1_SwitchOffPWM,                       
    .pFctSwitchOnPwm            = &R3_1_SwitchOnPWM,                         
    .pFctCurrReadingCalib       = &R3_1_CurrentReadingCalibration,    
    .pFctTurnOnLowSides         = &R3_1_TurnOnLowSides,          
    .pFctSetADCSampPointSectX   = &R3_1_SetADCSampPointSectX,                      
    .pFctIsOverCurrentOccurred  = &R3_1_IsOverCurrentOccurred,      
    .pFctOCPSetReferenceVoltage = MC_NULL,
    .pFctRLDetectionModeEnable  = MC_NULL,     
    .pFctRLDetectionModeDisable = MC_NULL,    
    .pFctRLDetectionModeSetDuty = MC_NULL,                              
    .hT_Sqrt3 = (PWM_PERIOD_CYCLES*SQRT3FACTOR)/16384u,   
    .Sector = 0,   
    .CntPhA = 0,
    .CntPhB = 0,
    .CntPhC = 0,
    .SWerror = 0,
    .TurnOnLowSidesAction = false, 
    .OffCalibrWaitTimeCounter = 0, 
    .Motor = M1,     
    .RLDetectionMode = false, 
    .Ia = 0, 
    .Ib = 0, 
    .Ic = 0, 
    .DTTest = 0,    
    .DTCompCnt = DTCOMPCNT, 
    .PWMperiod          = PWM_PERIOD_CYCLES,
    .OffCalibrWaitTicks = (uint16_t)((SYS_TICK_FREQUENCY * OFFCALIBRWAIT_MS)/ 1000),                      
    .Ton                 = TON,                              
    .Toff                = TOFF                            
  
  },
  .PhaseAOffset = 0,   
  .PhaseBOffset = 0,   
  .PhaseCOffset = 0,   
  .Half_PWMPeriod = PWM_PERIOD_CYCLES/2u,  
  .PolarizationCounter = 0,     
  .ADC_ExternalTriggerInjected = 0,
  .ADCTriggerEdge = 0,
  .OverCurrentFlag = false,   
  .OverVoltageFlag = false,   
  .BrakeActionLock = false,                                
  .pParams_str = &R3_1_ParamsM1,

};

	<#elseif CondFamily_STM32F7 &&  MC.THREE_SHUNT_INDEPENDENT_RESOURCES == true> 
PWMC_R3_2_Handle_t PWM_Handle_M1=
{
  {
    .pFctGetPhaseCurrents              = &R3_2_GetPhaseCurrents,    
    .pFctSwitchOffPwm                  = &R3_2_SwitchOffPWM,             
    .pFctSwitchOnPwm                   = &R3_2_SwitchOnPWM,              
    .pFctCurrReadingCalib              = &R3_2_CurrentReadingCalibration,
    .pFctTurnOnLowSides                = &R3_2_TurnOnLowSides,         
    .pFctSetADCSampPointSectX          = &R3_2_SetADCSampPointSectX,     
    .pFctIsOverCurrentOccurred         = &R3_2_IsOverCurrentOccurred,    
    .pFctOCPSetReferenceVoltage        = MC_NULL,
    .pFctRLDetectionModeEnable         = &R3_2_RLDetectionModeEnable,    
    .pFctRLDetectionModeDisable        = &R3_2_RLDetectionModeDisable,   
    .pFctRLDetectionModeSetDuty        = &R3_2_RLDetectionModeSetDuty,   
    .hT_Sqrt3 = (PWM_PERIOD_CYCLES*SQRT3FACTOR)/16384u,  
    .Sector = 0,   
    .CntPhA = 0,
    .CntPhB = 0,
    .CntPhC = 0,
    .SWerror = 0,
    .TurnOnLowSidesAction = false, 
    .OffCalibrWaitTimeCounter = 0, 
    .Motor = 0,    
    .RLDetectionMode = false, 
    .Ia = 0, 
    .Ib = 0, 
    .Ic = 0, 
    .DTTest = 0,    
    .DTCompCnt = DTCOMPCNT, 
    .PWMperiod          = PWM_PERIOD_CYCLES,    
    .OffCalibrWaitTicks = (uint16_t)((SYS_TICK_FREQUENCY * OFFCALIBRWAIT_MS)/ 1000),                   
    .Ton                 = TON,                            
    .Toff                = TOFF                           
  },
  .PhaseAOffset = 0,   
  .PhaseBOffset = 0,  
  .PhaseCOffset = 0,  
  .Half_PWMPeriod = PWM_PERIOD_CYCLES/2u, 
  .PolarizationCounter = 0,
  .ADCTriggerEdge = 0,  
  .pParams_str = &R3_2_ParamsM1,

};

	<#elseif CondFamily_STM32F7 &&  MC.ICS_SENSORS == true> 
PWMC_ICS_Handle_t PWM_Handle_M1 = 
{
  {
    .pFctGetPhaseCurrents              = &ICS_GetPhaseCurrents,    
    .pFctSwitchOffPwm                  = &ICS_SwitchOffPWM,             
    .pFctSwitchOnPwm                   = &ICS_SwitchOnPWM,              
    .pFctCurrReadingCalib              = &ICS_CurrentReadingCalibration,
    .pFctTurnOnLowSides                = &ICS_TurnOnLowSides,         
    .pFctSetADCSampPointSectX          = &ICS_WriteTIMRegisters,      
    .pFctIsOverCurrentOccurred         = &ICS_IsOverCurrentOccurred,    
    .pFctOCPSetReferenceVoltage        = MC_NULL,
    .pFctRLDetectionModeEnable         = MC_NULL,    
    .pFctRLDetectionModeDisable        = MC_NULL,   
    .pFctRLDetectionModeSetDuty        = MC_NULL,   
    .hT_Sqrt3 = (PWM_PERIOD_CYCLES*SQRT3FACTOR)/16384u,   
    .Sector = 0,    
    .CntPhA = 0,
    .CntPhB = 0,
    .CntPhC = 0,
    .SWerror = 0,
    .TurnOnLowSidesAction = false,
    .OffCalibrWaitTimeCounter = 0,
    .Motor = M1,
    .RLDetectionMode = false, 
    .Ia = 0, 
    .Ib = 0, 
    .Ic = 0, 
    .DTTest = 0,   
    .DTCompCnt = DTCOMPCNT,
    .PWMperiod          = PWM_PERIOD_CYCLES,
    .OffCalibrWaitTicks = (uint16_t)((SYS_TICK_FREQUENCY * OFFCALIBRWAIT_MS)/ 1000),
    .Ton                 = TON,                            
    .Toff                = TOFF                             
  
  },
  .PhaseAOffset = (uint32_t) 0,  
  .PhaseBOffset = (uint32_t) 0,   
  .Half_PWMPeriod = PWM_PERIOD_CYCLES/2,
  .PolarizationCounter = (uint8_t) 0, 
  .pParams_str = &ICS_ParamsM1
};

<#elseif CondFamily_STM32H7 && MC.THREE_SHUNT_INDEPENDENT_RESOURCES >

PWMC_R3_2_Handle_t PWM_Handle_M1 =
{
  {
    .pFctGetPhaseCurrents              = &R3_2_GetPhaseCurrents,    
    .pFctSwitchOffPwm                  = &R3_2_SwitchOffPWM,             
    .pFctSwitchOnPwm                   = &R3_2_SwitchOnPWM,              
    .pFctCurrReadingCalib              = &R3_2_CurrentReadingPolarization,
    .pFctTurnOnLowSides                = &R3_2_TurnOnLowSides,         
    .pFctIsOverCurrentOccurred         = &R3_2_IsOverCurrentOccurred,    
    .pFctOCPSetReferenceVoltage        = MC_NULL,
    .pFctRLDetectionModeEnable         = &R3_2_RLDetectionModeEnable,    
    .pFctRLDetectionModeDisable        = &R3_2_RLDetectionModeDisable,   
    .pFctRLDetectionModeSetDuty        = &R3_2_RLDetectionModeSetDuty,    
    .hT_Sqrt3 = (PWM_PERIOD_CYCLES*SQRT3FACTOR)/16384u,   
    .Sector = 0,    
    .CntPhA = 0,
    .CntPhB = 0,
    .CntPhC = 0,
    .SWerror = 0,
    .TurnOnLowSidesAction = false, 
    .OffCalibrWaitTimeCounter = 0, 
    .Motor = M1,     
    .RLDetectionMode = false, 
    .Ia = 0, 
    .Ib = 0, 
    .Ic = 0, 
    .DTTest = 0,   
    .DTCompCnt = DTCOMPCNT, 
    .PWMperiod          = PWM_PERIOD_CYCLES,
    .OffCalibrWaitTicks = (uint16_t)((SYS_TICK_FREQUENCY * OFFCALIBRWAIT_MS)/ 1000),
    .Ton                 = TON,                              
    .Toff                = TOFF
  },
  .PhaseAOffset = 0,   
  .PhaseBOffset = 0,   
  .PhaseCOffset = 0,   
  .Half_PWMPeriod = PWM_PERIOD_CYCLES/2u, 
  .OverCurrentFlag = false,    
  .OverVoltageFlag = false,    
  .BrakeActionLock = false,                               
  .pParams_str = &R3_2_ParamsM1
};

	<#elseif (CondFamily_STM32F1 &&  MC.THREE_SHUNT) == true >
PWMC_R3_2_Handle_t PWM_Handle_M1 =
{
  {
    .pFctGetPhaseCurrents              = &R3_2_GetPhaseCurrents,
    .pFctSwitchOffPwm                  = &R3_2_SwitchOffPWM,
    .pFctSwitchOnPwm                   = &R3_2_SwitchOnPWM,
    .pFctCurrReadingCalib              = &R3_2_CurrentReadingPolarization,
    .pFctTurnOnLowSides                = &R3_2_TurnOnLowSides,
    .pFctSetADCSampPointSectX          = &R3_2_SetADCSampPointSectX,
    .pFctIsOverCurrentOccurred         = &R3_2_IsOverCurrentOccurred,
    .pFctOCPSetReferenceVoltage        = MC_NULL,
    .pFctRLDetectionModeEnable         = MC_NULL,    
    .pFctRLDetectionModeDisable        = MC_NULL,   
    .pFctRLDetectionModeSetDuty        = MC_NULL,   
    .hT_Sqrt3 = (PWM_PERIOD_CYCLES*SQRT3FACTOR)/16384u,
    .Sector = 0,    
    .CntPhA = 0,
    .CntPhB = 0,
    .CntPhC = 0,
    .SWerror = 0,
    .TurnOnLowSidesAction = false, 
    .OffCalibrWaitTimeCounter = 0, 
    .Motor = M1,     
    .RLDetectionMode = false, 
    .Ia = 0, 
    .Ib = 0, 
    .Ic = 0, 
    .DTTest = 0,   
    .DTCompCnt = DTCOMPCNT,
    .PWMperiod          = PWM_PERIOD_CYCLES,  
    .OffCalibrWaitTicks = (uint16_t)((SYS_TICK_FREQUENCY * OFFCALIBRWAIT_MS)/ 1000),                         
    .Ton                 = TON,                              
    .Toff                = TOFF                             
  },
  .Half_PWMPeriod = PWM_PERIOD_CYCLES/2u,                               
  .PhaseAOffset = 0,   
  .PhaseBOffset = 0,   
  .PhaseCOffset = 0,      

  .pParams_str = &R3_2_ParamsM1
};

	<#elseif CondLine_STM32F1_HD &&  MC.SINGLE_SHUNT == true>
PWMC_R1_HD2_Handle_t PWM_Handle_M1 = 
{
  {
    .pFctGetPhaseCurrents              = &R1HD2_GetPhaseCurrents,    
    .pFctSwitchOffPwm                  = &R1HD2_SwitchOffPWM,             
    .pFctSwitchOnPwm                   = &R1HD2_SwitchOnPWM,              
    .pFctCurrReadingCalib              = &R1HD2_CurrentReadingCalibration,
    .pFctTurnOnLowSides                = &R1HD2_TurnOnLowSides,         
    .pFctSetADCSampPointSectX          = &R1HD2_CalcDutyCycles,         
    .pFctIsOverCurrentOccurred         = &R1HD2_IsOverCurrentOccurred,    
    .pFctOCPSetReferenceVoltage        = MC_NULL,
    .pFctRLDetectionModeEnable         = MC_NULL,    
    .pFctRLDetectionModeDisable        = MC_NULL,   
    .pFctRLDetectionModeSetDuty        = MC_NULL,   
    .hT_Sqrt3 = (PWM_PERIOD_CYCLES*SQRT3FACTOR)/16384u,
    .Sector = 0,    
    .CntPhA = 0,
    .CntPhB = 0,
    .CntPhC = 0,
    .SWerror = 0,
    .TurnOnLowSidesAction = false, 
    .OffCalibrWaitTimeCounter = 0, 
    .Motor = M1,     
    .RLDetectionMode = false, 
    .Ia = 0, 
    .Ib = 0, 
    .Ic = 0, 
    .DTTest = 0,    
    .DTCompCnt = DTCOMPCNT, 
    .PWMperiod          = PWM_PERIOD_CYCLES,                                                                                                           
    .OffCalibrWaitTicks = (uint16_t)((SYS_TICK_FREQUENCY * OFFCALIBRWAIT_MS)/ 1000),                         
    .Ton                 = TON,                             
    .Toff                = TOFF                             
  
  },
  .Half_PWMPeriod = PWM_PERIOD_CYCLES/2u,      
  .sampCur1 = 0,           
  .sampCur2 = 0,         
  .DMACur = 0,      

  .pParams_str = & R1_DDParamsM1
};

	<#elseif ( CondLine_STM32F1_LD || CondLine_STM32F1_MD ) &&  MC.SINGLE_SHUNT == true>
PWMC_R1_VL1_Handle_t PWM_Handle_M1 = 
{
  {
    .pFctGetPhaseCurrents              = &R1VL1_GetPhaseCurrents,    
    .pFctSwitchOffPwm                  = &R1VL1_SwitchOffPWM,             
    .pFctSwitchOnPwm                   = &R1VL1_SwitchOnPWM,              
    .pFctCurrReadingCalib              = &R1VL1_CurrentReadingCalibration,
    .pFctTurnOnLowSides                = &R1VL1_TurnOnLowSides,          
    .pFctSetADCSampPointSectX          = &R1VL1_CalcDutyCycles,              
    .pFctIsOverCurrentOccurred         = &R1VL1_IsOverCurrentOccurred,    
    .pFctOCPSetReferenceVoltage        = MC_NULL,
    .pFctRLDetectionModeEnable         = (PWMC_Generic_Cb_t) 0,    
    .pFctRLDetectionModeDisable        = (PWMC_Generic_Cb_t) 0,   
    .pFctRLDetectionModeSetDuty        = (PWMC_RLDetectSetDuty_Cb_t) 0,   
    .hT_Sqrt3 = (PWM_PERIOD_CYCLES*SQRT3FACTOR)/16384u,
    .Sector = 0,    
    .CntPhA = 0,
    .CntPhB = 0,
    .CntPhC = 0,
    .SWerror = 0,
    .TurnOnLowSidesAction = false, 
    .OffCalibrWaitTimeCounter = 0,
    .Motor = M1,    
    .RLDetectionMode = false,
    .Ia = 0, 
    .Ib = 0,
    .Ic = 0, 
    .DTTest = 0,    
    .DTCompCnt = DTCOMPCNT, 
    .PWMperiod          = PWM_PERIOD_CYCLES,     
    .OffCalibrWaitTicks = (uint16_t)((SYS_TICK_FREQUENCY * OFFCALIBRWAIT_MS)/ 1000),                            
    .Ton                 = TON,                             
    .Toff                = TOFF                             
  
  },
  .Half_PWMPeriod = PWM_PERIOD_CYCLES/2u,  /* Half PWM Period in timer clock counts */
  .sampCur1 = 0,     
  .sampCur2 = 0, 
  .bDMACur = 0,
  .pParams_str = & R1_VL1ParamsSD
};

	</#if>
</#if><#-- MC.DRIVE_TYPE == "FOC" -->
<#if MC.DRIVE_TYPE == "FOC" >
	<#if ((CondLine_STM32F1_LD || CondLine_STM32F1_MD) && MC.ICS_SENSORS) == true && MC.SINGLEDRIVE == true> 
/**
  * @brief  Current sensor parameters Single Drive - ICS, STM32F103 LOW/MEDIUM DENSITY
  */
PWMC_ICS_Handle_t PWM_Handle_M1 = 
{
  {
    .pFctGetPhaseCurrents              = &ICS_GetPhaseCurrents,    
    .pFctSwitchOffPwm                  = &ICS_SwitchOffPWM,             
    .pFctSwitchOnPwm                   = &ICS_SwitchOnPWM,              
    .pFctCurrReadingCalib              = &ICS_CurrentReadingCalibration,
    .pFctTurnOnLowSides                = &ICS_TurnOnLowSides,          
    .pFctSetADCSampPointSectX          = &ICS_WriteTIMRegisters,
    .pFctIsOverCurrentOccurred         = &ICS_IsOverCurrentOccurred,    
    .pFctOCPSetReferenceVoltage        = MC_NULL,
    .pFctRLDetectionModeEnable         = MC_NULL,    
    .pFctRLDetectionModeDisable        = MC_NULL,   
    .pFctRLDetectionModeSetDuty        = MC_NULL,   
    .hT_Sqrt3 = (PWM_PERIOD_CYCLES*SQRT3FACTOR)/16384u,
    .Sector = 0,   
    .CntPhA = 0,
    .CntPhB = 0,
    .CntPhC = 0,
    .SWerror = 0,
    .TurnOnLowSidesAction = false, 
    .OffCalibrWaitTimeCounter = 0, 
    .Motor = M1,    
    .RLDetectionMode = false,
    .Ia = 0, 
    .Ib = 0, 
    .Ic = 0,
    .DTTest = 0,   
    .DTCompCnt = DTCOMPCNT, 
    .PWMperiod          = PWM_PERIOD_CYCLES, 
    .OffCalibrWaitTicks = (uint16_t)((SYS_TICK_FREQUENCY * OFFCALIBRWAIT_MS)/ 1000),
    .Ton                 = TON,                             
    .Toff                = TOFF                              
  },
  .Half_PWMPeriod = PWM_PERIOD_CYCLES/2u,  
  .PhaseAOffset = (uint32_t) 0,
  .PhaseBOffset = (uint32_t) 0, 
  .pParams_str = & ICS_ParamsM1

};

	<#elseif (CondFamily_STM32F4 || CondLine_STM32F1_HD ) && MC.ICS_SENSORS == true>
		<#if CondLine_STM32F1_HD >
PWMC_ICS_Handle_t PWM_Handle_M1 = 
{
  {
    .pFctGetPhaseCurrents              = &ICS_GetPhaseCurrents,    
    .pFctSwitchOffPwm                  = &ICS_SwitchOffPWM,             
    .pFctSwitchOnPwm                   = &ICS_SwitchOnPWM,              
    .pFctCurrReadingCalib              = &ICS_CurrentReadingCalibration,
    .pFctTurnOnLowSides                = &ICS_TurnOnLowSides,          
    .pFctSetADCSampPointSectX          = &ICS_WriteTIMRegisters,
    .pFctIsOverCurrentOccurred         = &ICS_IsOverCurrentOccurred,    
    .pFctOCPSetReferenceVoltage        = MC_NULL,
    .pFctRLDetectionModeEnable         = MC_NULL,    
    .pFctRLDetectionModeDisable        = MC_NULL,   
    .pFctRLDetectionModeSetDuty        = MC_NULL,   
    .hT_Sqrt3 = (PWM_PERIOD_CYCLES*SQRT3FACTOR)/16384u,
    .Sector = 0,    
    .CntPhA = 0,
    .CntPhB = 0,
    .CntPhC = 0,
    .SWerror = 0,
    .TurnOnLowSidesAction = false, 
    .OffCalibrWaitTimeCounter = 0, 
    .Motor = M1,     
    .RLDetectionMode = false, 
    .Ia = 0, 
    .Ib = 0, 
    .Ic = 0, 
    .DTTest = 0,    
    .DTCompCnt = DTCOMPCNT, 
    .PWMperiod          = PWM_PERIOD_CYCLES,    
    .OffCalibrWaitTicks = (uint16_t)((SYS_TICK_FREQUENCY * OFFCALIBRWAIT_MS)/ 1000),                     
    .Ton                 = TON,                             
    .Toff                = TOFF                             
  },
  .PhaseAOffset = (uint32_t) 0,   
  .PhaseBOffset = (uint32_t) 0,   
  .Half_PWMPeriod = PWM_PERIOD_CYCLES/2u,
  .PolarizationCounter = (uint8_t) 0, 
  .pParams_str = & ICS_ParamsM1
};

		<#elseif CondFamily_STM32F4 >
PWMC_ICS_Handle_t PWM_Handle_M1 = 
{
  {
    .pFctGetPhaseCurrents              = &ICS_GetPhaseCurrents,    
    .pFctSwitchOffPwm                  = &ICS_SwitchOffPWM,             
    .pFctSwitchOnPwm                   = &ICS_SwitchOnPWM,              
    .pFctCurrReadingCalib              = &ICS_CurrentReadingCalibration,
    .pFctTurnOnLowSides                = &ICS_TurnOnLowSides,             
    .pFctSetADCSampPointSectX          = &ICS_WriteTIMRegisters,              
    .pFctIsOverCurrentOccurred         = &ICS_IsOverCurrentOccurred,    
    .pFctOCPSetReferenceVoltage        = MC_NULL,
    .pFctRLDetectionModeEnable         = MC_NULL,    
    .pFctRLDetectionModeDisable        = MC_NULL,   
    .pFctRLDetectionModeSetDuty        = MC_NULL,   
    .hT_Sqrt3 = (PWM_PERIOD_CYCLES*SQRT3FACTOR)/16384u,   
    .Sector = 0,    
    .CntPhA = 0,
    .CntPhB = 0,
    .CntPhC = 0,
    .SWerror = 0,
    .TurnOnLowSidesAction = false,
    .OffCalibrWaitTimeCounter = 0,
    .Motor = M1,
    .RLDetectionMode = false, 
    .Ia = 0, 
    .Ib = 0, 
    .Ic = 0, 
    .DTTest = 0,   
    .DTCompCnt = DTCOMPCNT,
    .PWMperiod          = PWM_PERIOD_CYCLES,
    .OffCalibrWaitTicks = (uint16_t)((SYS_TICK_FREQUENCY * OFFCALIBRWAIT_MS)/ 1000),
    .Ton                 = TON,                            
    .Toff                = TOFF                             
  
  },
  .PhaseAOffset = (uint32_t) 0,
  .PhaseBOffset = (uint32_t) 0,  
  .Half_PWMPeriod = PWM_PERIOD_CYCLES/2,  
  .PolarizationCounter = (uint8_t) 0,
  .ADCTriggerSet = (LL_ADC_INJ_TRIG_EXT_${_last_word(MC.PWM_TIMER_SELECTION)}_CH4 & ~ADC_INJ_TRIG_EXT_EDGE_DEFAULT),
  .pParams_str = &ICS_ParamsM1
};

		</#if> 
	<#elseif CondFamily_STM32F3 && MC.ICS_SENSORS == true>
/**
  * @brief  Current sensor parameters Dual Drive Motor 1 - ICS, STM32F30x
  */
PWMC_ICS_Handle_t PWM_Handle_M1 = {
  {
    .pFctGetPhaseCurrents              = &ICS_GetPhaseCurrents,    
    .pFctSwitchOffPwm                  = &ICS_SwitchOffPWM,             
    .pFctSwitchOnPwm                   = &ICS_SwitchOnPWM,              
    .pFctCurrReadingCalib              = &ICS_CurrentReadingCalibration,
    .pFctTurnOnLowSides                = &ICS_TurnOnLowSides,         
    .pFctSetADCSampPointSectX          = &ICS_WriteTIMRegisters,            
    .pFctIsOverCurrentOccurred         = &ICS_IsOverCurrentOccurred,    
    .pFctOCPSetReferenceVoltage        = MC_NULL,
    .pFctRLDetectionModeEnable         = MC_NULL,    
    .pFctRLDetectionModeDisable        = MC_NULL,   
    .pFctRLDetectionModeSetDuty        = MC_NULL,   
    .hT_Sqrt3 = (PWM_PERIOD_CYCLES*SQRT3FACTOR)/16384u,  
    .Sector = 0,   
    .CntPhA = 0,
    .CntPhB = 0,
    .CntPhC = 0,
    .SWerror = 0,
    .TurnOnLowSidesAction = false, 
    .OffCalibrWaitTimeCounter = 0, 
    .Motor = M1,     
    .RLDetectionMode = false, 
    .Ia = 0,
    .Ib = 0,
    .Ic = 0,
    .DTTest = 0,   
    .DTCompCnt = DTCOMPCNT,
    .PWMperiod          = PWM_PERIOD_CYCLES,                                                  
    .OffCalibrWaitTicks = (uint16_t)((SYS_TICK_FREQUENCY * OFFCALIBRWAIT_MS)/ 1000),                                                                                                                                                       
    .Ton                 = TON,                             
    .Toff                = TOFF                             
  
  },
  .PhaseAOffset = 0,   
  .PhaseBOffset = 0,  
  .Half_PWMPeriod = PWM_PERIOD_CYCLES/2u,
  .PolarizationCounter = 0,
		<#if MC.PWM_TIMER_SELECTION == "PWM_TIM1">
  .ADCConfig1 =   MC_${MC.PHASE_U_CURR_CHANNEL} << 8 | LL_ADC_INJ_TRIG_EXT_RISING | LL_ADC_INJ_TRIG_EXT_TIM1_CH4,  
  .ADCConfig2 =   MC_${MC.PHASE_V_CURR_CHANNEL} << 8 | LL_ADC_INJ_TRIG_EXT_RISING | LL_ADC_INJ_TRIG_EXT_TIM1_CH4,     
		<#elseif MC.PWM_TIMER_SELECTION == "PWM_TIM8">
			<#if MC.PHASE_CURRENTS_ADC == "ADC1_2">
  .ADCConfig1 =   MC_${MC.PHASE_U_CURR_CHANNEL} << 8 | LL_ADC_INJ_TRIG_EXT_RISING | LL_ADC_INJ_TRIG_EXT_TIM8_CH4_ADC12,  
  .ADCConfig2 =   MC_${MC.PHASE_V_CURR_CHANNEL} << 8 | LL_ADC_INJ_TRIG_EXT_RISING | LL_ADC_INJ_TRIG_EXT_TIM8_CH4_ADC12,
			<#elseif  MC.PHASE_CURRENTS_ADC == "ADC3">
  .ADCConfig1 =   MC_${MC.PHASE_U_CURR_CHANNEL} << 8 | LL_ADC_INJ_TRIG_EXT_RISING | LL_ADC_INJ_TRIG_EXT_TIM8_CH4__ADC34,  
  .ADCConfig2 =   MC_${MC.PHASE_V_CURR_CHANNEL} << 8 | LL_ADC_INJ_TRIG_EXT_RISING | LL_ADC_INJ_TRIG_EXT_TIM8_CH4__ADC34,
			</#if>    
		</#if>      
  .OverCurrentFlag = false,    
  .OverVoltageFlag = false,    
  .BrakeActionLock = false,    
                                                            
  .pParams_str = &ICS_ParamsM1                               
};

	</#if>
</#if><#-- MC.DRIVE_TYPE == "FOC" -->
<#if MC.DRIVE_TYPE == "FOC" >
	<#if CondFamily_STM32G4 >
		<#if MC.THREE_SHUNT_INDEPENDENT_RESOURCES || MC.THREE_SHUNT_SHARED_RESOURCES ><#-- THREE_SHUNT inside CondFamily_STM32G4 -->
PWMC_R3_2_Handle_t PWM_Handle_M1 =
{
  {
    .pFctGetPhaseCurrents              = &R3_2_GetPhaseCurrents,    
    .pFctSwitchOffPwm                  = &R3_2_SwitchOffPWM,             
    .pFctSwitchOnPwm                   = &R3_2_SwitchOnPWM,              
    .pFctCurrReadingCalib              = &R3_2_CurrentReadingPolarization,
    .pFctTurnOnLowSides                = &R3_2_TurnOnLowSides,         
    .pFctIsOverCurrentOccurred         = &R3_2_IsOverCurrentOccurred,    
    .pFctOCPSetReferenceVoltage        = MC_NULL,
    .pFctRLDetectionModeEnable         = &R3_2_RLDetectionModeEnable,    
    .pFctRLDetectionModeDisable        = &R3_2_RLDetectionModeDisable,   
    .pFctRLDetectionModeSetDuty        = &R3_2_RLDetectionModeSetDuty,    
    
    .hT_Sqrt3 = (PWM_PERIOD_CYCLES*SQRT3FACTOR)/16384u,   
    .Sector = 0,    
    .CntPhA = 0,
    .CntPhB = 0,
    .CntPhC = 0,
    .SWerror = 0,
    .TurnOnLowSidesAction = false, 
    .OffCalibrWaitTimeCounter = 0, 
    .Motor = M1,     
    .RLDetectionMode = false, 
    .Ia = 0, 
    .Ib = 0, 
    .Ic = 0, 
    .DTTest = 0,   
    .DTCompCnt = 0, 
    .PWMperiod          = PWM_PERIOD_CYCLES,
    .OffCalibrWaitTicks = (uint16_t)((SYS_TICK_FREQUENCY * OFFCALIBRWAIT_MS)/ 1000),
    .DTCompCnt          = DTCOMPCNT,
    .Ton                 = TON,                              
    .Toff                = TOFF
  },
  .PhaseAOffset = 0,   
  .PhaseBOffset = 0,   
  .PhaseCOffset = 0,                               
  .Half_PWMPeriod = PWM_PERIOD_CYCLES/2u, 
  .OverCurrentFlag = false,    
  .OverVoltageFlag = false,    
  .BrakeActionLock = false,                               
  .pParams_str = &R3_2_ParamsM1
};
		</#if>
		<#if MC.SINGLE_SHUNT == true> 
PWMC_R1_Handle_t PWM_Handle_M1 =
{  
  {
    .pFctGetPhaseCurrents              = &R1_GetPhaseCurrents,    
    .pFctSwitchOffPwm                  = &R1_SwitchOffPWM,             
    .pFctSwitchOnPwm                   = &R1_SwitchOnPWM,              
    .pFctCurrReadingCalib              = &R1_CurrentReadingPolarization,
    .pFctTurnOnLowSides                = &R1_TurnOnLowSides,         
    .pFctSetADCSampPointSectX          = &R1_CalcDutyCycles,     
    .pFctIsOverCurrentOccurred         = &R1_IsOverCurrentOccurred,    
    .pFctOCPSetReferenceVoltage        = MC_NULL,
    .hT_Sqrt3 = (PWM_PERIOD_CYCLES*SQRT3FACTOR)/16384u,  
    .Sector = 0,    
    .CntPhA = 0,
    .CntPhB = 0,
    .CntPhC = 0,
    .SWerror = 0,
    .TurnOnLowSidesAction = false, 
    .OffCalibrWaitTimeCounter = 0,
    .Motor = M1,
    .RLDetectionMode = false,
    .Ia = 0, 
    .Ib = 0, 
    .Ic = 0, 
    .DTTest = 0,    
    .DTCompCnt = 0, 
    .PWMperiod          = PWM_PERIOD_CYCLES,     
    .OffCalibrWaitTicks = (uint16_t)((SYS_TICK_FREQUENCY * OFFCALIBRWAIT_MS)/ 1000), 
  
  },
  .DmaBuff = {0,0},  
  .CntSmp1 = 0,                    
  .CntSmp2 = 0,                    
  .sampCur1 = 0,                    
  .sampCur2 = 0,                    
  .CurrAOld = 0,                  
  .CurrBOld = 0,                   
  .Inverted_pwm_new = 0,                                 
  .Flags = 0,                     
  .PhaseOffset = 0,                                 
  .Half_PWMPeriod = PWM_PERIOD_CYCLES/2u,                    
  .OverCurrentFlag = false,        
  .OverVoltageFlag = false,        
  .BrakeActionLock = false,        
  .pParams_str =  &R1_ParamsM1,
};
		</#if>
<#if MC.ICS_SENSORS == true> 

/**
  * @brief  Current sensor parameters Dual Drive Motor 1 - ICS, STM32G4xx
  */
PWMC_ICS_Handle_t PWM_Handle_M1 = {
  {
    .pFctGetPhaseCurrents              = &ICS_GetPhaseCurrents,    
    .pFctSwitchOffPwm                  = &ICS_SwitchOffPWM,             
    .pFctSwitchOnPwm                   = &ICS_SwitchOnPWM,              
    .pFctCurrReadingCalib              = &ICS_CurrentReadingPolarization,
    .pFctTurnOnLowSides                = &ICS_TurnOnLowSides,         
    .pFctSetADCSampPointSectX          = &ICS_WriteTIMRegisters,            
    .pFctIsOverCurrentOccurred         = &ICS_IsOverCurrentOccurred,    
    .pFctOCPSetReferenceVoltage        = MC_NULL,
    .pFctRLDetectionModeEnable         = MC_NULL,    
    .pFctRLDetectionModeDisable        = MC_NULL,   
    .pFctRLDetectionModeSetDuty        = MC_NULL,   
    .hT_Sqrt3 = (PWM_PERIOD_CYCLES*SQRT3FACTOR)/16384u,  
    .Sector = 0,   
    .CntPhA = 0,
    .CntPhB = 0,
    .CntPhC = 0,
    .SWerror = 0,
    .TurnOnLowSidesAction = false, 
    .OffCalibrWaitTimeCounter = 0, 
    .Motor = M1,     
    .RLDetectionMode = false, 
    .Ia = 0,
    .Ib = 0,
    .Ic = 0,
    .DTTest = 0,   
    .DTCompCnt = DTCOMPCNT,
    .PWMperiod          = PWM_PERIOD_CYCLES,                                                  
    .OffCalibrWaitTicks = (uint16_t)((SYS_TICK_FREQUENCY * OFFCALIBRWAIT_MS)/ 1000),                                                                                                                                                       
    .Ton                 = TON,                             
    .Toff                = TOFF                             
  
  },
  .PhaseAOffset = 0,   
  .PhaseBOffset = 0,  
  .Half_PWMPeriod = PWM_PERIOD_CYCLES/2u,
  .PolarizationCounter = 0, 
  .OverCurrentFlag = false,    
  .OverVoltageFlag = false,    
  .BrakeActionLock = false,    
                                                            
  .pParams_str = &ICS_ParamsM1                               
};
</#if>  
  
<#if MC.ICS_SENSORS2 == true> 
/**
  * @brief  Current sensor parameters Dual Drive Motor 2 - ICS, STM32G4xx
  */
PWMC_ICS_Handle_t PWM_Handle_M2 = {
  {
    .pFctGetPhaseCurrents              = &ICS_GetPhaseCurrents,    
    .pFctSwitchOffPwm                  = &ICS_SwitchOffPWM,             
    .pFctSwitchOnPwm                   = &ICS_SwitchOnPWM,              
    .pFctCurrReadingCalib              = &ICS_CurrentReadingPolarization,
    .pFctTurnOnLowSides                = &ICS_TurnOnLowSides,         
    .pFctSetADCSampPointSectX          = &ICS_WriteTIMRegisters,            
    .pFctIsOverCurrentOccurred         = &ICS_IsOverCurrentOccurred,    
    .pFctOCPSetReferenceVoltage        = MC_NULL,
    .pFctRLDetectionModeEnable         = MC_NULL,    
    .pFctRLDetectionModeDisable        = MC_NULL,   
    .pFctRLDetectionModeSetDuty        = MC_NULL,   
    .hT_Sqrt3 = (PWM_PERIOD_CYCLES2*SQRT3FACTOR)/16384u,   
    .Sector = 0,    
    .CntPhA = 0,
    .CntPhB = 0,
    .CntPhC = 0,
    .SWerror = 0,
    .TurnOnLowSidesAction = false,                               
    .OffCalibrWaitTimeCounter = 0,                                
    .Motor = M2,   
    .RLDetectionMode = false, 
    .Ia = 0, 
    .Ib = 0, 
    .Ic = 0, 
    .DTTest = 0,    
    .DTCompCnt = DTCOMPCNT2, 
    .PWMperiod          = PWM_PERIOD_CYCLES2,                                                
    .OffCalibrWaitTicks = (uint16_t)((SYS_TICK_FREQUENCY * OFFCALIBRWAIT_MS2)/ 1000),                                                                                                                                                 
    .Ton                 = TON2,                            
    .Toff                = TOFF2                            
  
  },
  .PhaseAOffset = 0,   
  .PhaseBOffset = 0,   
  .Half_PWMPeriod = PWM_PERIOD_CYCLES2/2u, 
  .PolarizationCounter = 0,
  .OverCurrentFlag = false,     
  .OverVoltageFlag = false,     
  .BrakeActionLock = false,
  .pParams_str = &ICS_ParamsM2   
                                
};
</#if>
  
  
		<#if MC.THREE_SHUNT_INDEPENDENT_RESOURCES2 || MC.THREE_SHUNT_SHARED_RESOURCES2 ><#-- THREE_SHUNT inside CondFamily_STM32G4 -->
PWMC_R3_2_Handle_t PWM_Handle_M2 =
{
  {
    .pFctGetPhaseCurrents              = &R3_2_GetPhaseCurrents,    
    .pFctSwitchOffPwm                  = &R3_2_SwitchOffPWM,             
    .pFctSwitchOnPwm                   = &R3_2_SwitchOnPWM,              
    .pFctCurrReadingCalib              = &R3_2_CurrentReadingPolarization,
    .pFctTurnOnLowSides                = &R3_2_TurnOnLowSides,         
    .pFctIsOverCurrentOccurred         = &R3_2_IsOverCurrentOccurred,    
    .pFctOCPSetReferenceVoltage        = MC_NULL,
    .pFctRLDetectionModeEnable         = &R3_2_RLDetectionModeEnable,    
    .pFctRLDetectionModeDisable        = &R3_2_RLDetectionModeDisable,   
    .pFctRLDetectionModeSetDuty        = &R3_2_RLDetectionModeSetDuty,    
    
    .hT_Sqrt3 = (PWM_PERIOD_CYCLES2*SQRT3FACTOR)/16384u,   
    .Sector = 0,    
    .CntPhA = 0,
    .CntPhB = 0,
    .CntPhC = 0,
    .SWerror = 0,
    .TurnOnLowSidesAction = false, 
    .OffCalibrWaitTimeCounter = 0, 
    .Motor = M2,     
    .RLDetectionMode = false, 
    .Ia = 0, 
    .Ib = 0, 
    .Ic = 0, 
    .DTTest = 0,   
    .DTCompCnt = 0, 
    .PWMperiod          = PWM_PERIOD_CYCLES2,
    .OffCalibrWaitTicks = (uint16_t)((SYS_TICK_FREQUENCY * OFFCALIBRWAIT_MS2)/ 1000),
    .DTCompCnt          = DTCOMPCNT2,
    .Ton                 = TON2,                              
    .Toff                = TOFF2
  },
  .PhaseAOffset = 0,   
  .PhaseBOffset = 0,   
  .PhaseCOffset = 0,                               
  .Half_PWMPeriod = PWM_PERIOD_CYCLES2/2u, 
  .OverCurrentFlag = false,    
  .OverVoltageFlag = false,    
  .BrakeActionLock = false,                               
  .pParams_str = &R3_2_ParamsM2
};  
		</#if><#-- THREE_SHUNT_INDEPENDENT_RESOURCES2 inside CondFamily_STM32G4 -->
		<#if MC.SINGLE_SHUNT2 == true> 
PWMC_R1_Handle_t PWM_Handle_M2 =
{  
  {
    .pFctGetPhaseCurrents              = &R1_GetPhaseCurrents,    
    .pFctSwitchOffPwm                  = &R1_SwitchOffPWM,             
    .pFctSwitchOnPwm                   = &R1_SwitchOnPWM,              
    .pFctCurrReadingCalib              = &R1_CurrentReadingPolarization,
    .pFctTurnOnLowSides                = &R1_TurnOnLowSides,         
    .pFctSetADCSampPointSectX          = &R1_CalcDutyCycles,     
    .pFctIsOverCurrentOccurred         = &R1_IsOverCurrentOccurred,    
    .pFctOCPSetReferenceVoltage        = MC_NULL,
    .hT_Sqrt3 = (PWM_PERIOD_CYCLES2*SQRT3FACTOR)/16384u,  
    .Sector = 0,    
    .CntPhA = 0,
    .CntPhB = 0,
    .CntPhC = 0,
    .SWerror = 0,
    .TurnOnLowSidesAction = false, 
    .OffCalibrWaitTimeCounter = 0,
    .Motor = M2,
    .RLDetectionMode = false,
    .Ia = 0, 
    .Ib = 0, 
    .Ic = 0, 
    .DTTest = 0,    
    .DTCompCnt = 0, 
    .PWMperiod          = PWM_PERIOD_CYCLES2,     
    .OffCalibrWaitTicks = (uint16_t)((SYS_TICK_FREQUENCY * OFFCALIBRWAIT_MS2)/ 1000), 
  
  },
  .DmaBuff = {0,0},  
  .CntSmp1 = 0,                    
  .CntSmp2 = 0,                    
  .sampCur1 = 0,                    
  .sampCur2 = 0,                    
  .CurrAOld = 0,                  
  .CurrBOld = 0,                   
  .Inverted_pwm_new = 0,                                 
  .Flags = 0,                     
  .PhaseOffset = 0,                                 
  .Half_PWMPeriod = PWM_PERIOD_CYCLES2/2u,                    
  .OverCurrentFlag = false,        
  .OverVoltageFlag = false,        
  .BrakeActionLock = false,        
  .pParams_str =  &R1_ParamsM2,
};
		</#if><#-- SINGLE_SHUNT2 inside CondFamily_STM32G4 -->
	</#if><#-- CondFamily_STM32G4 -->
</#if><#-- MC.DRIVE_TYPE == "FOC" -->
<#if MC.DRIVE_TYPE == "FOC" >
	<#if CondFamily_STM32G0 >
		<#if MC.SINGLE_SHUNT == true >
PWMC_R1_G0_Handle_t PWM_Handle_M1 =
{
  {
    .pFctGetPhaseCurrents              = &R1G0XX_GetPhaseCurrents,    
    .pFctSwitchOffPwm                  = &R1G0XX_SwitchOffPWM,             
    .pFctSwitchOnPwm                   = &R1G0XX_SwitchOnPWM,              
    .pFctCurrReadingCalib              = &R1G0XX_CurrentReadingCalibration,
    .pFctTurnOnLowSides                = &R1G0XX_TurnOnLowSides,         
    .pFctSetADCSampPointSectX          = &R1G0XX_CalcDutyCycles,                
    .pFctIsOverCurrentOccurred         = &R1G0XX_IsOverCurrentOccurred,    
    .pFctOCPSetReferenceVoltage        = MC_NULL,
    .pFctRLDetectionModeEnable         = MC_NULL,    
    .pFctRLDetectionModeDisable        = MC_NULL,   
    .pFctRLDetectionModeSetDuty        = MC_NULL,   
    .hT_Sqrt3 = (PWM_PERIOD_CYCLES*SQRT3FACTOR)/16384u,    
    .Sector = 0,   
    .CntPhA = 0,
    .CntPhB = 0,
    .CntPhC = 0,
    .SWerror = 0,
    .TurnOnLowSidesAction = false, 
    .OffCalibrWaitTimeCounter = 0, 
    .Motor = 0,     
    .RLDetectionMode = false, 
    .Ia = 0, 
    .Ib = 0, 
    .Ic = 0, 
    .DTTest = 0,    
    .DTCompCnt = DTCOMPCNT, 
    .PWMperiod = PWM_PERIOD_CYCLES,    
    .OffCalibrWaitTicks = (uint16_t)((SYS_TICK_FREQUENCY * OFFCALIBRWAIT_MS)/ 1000),
    .Ton                 = TON,
    .Toff                = TOFF
  },
  .Half_PWMPeriod = PWM_PERIOD_CYCLES/2u,
  .PhaseOffset = 0,      
  .DmaBuff = {0,0},  
  .CntSmp1 = 0,         
  .CntSmp2 = 0,         
  .sampCur1 = 0,          
  .sampCur2 = 0,          
  .CurrAOld = 0,         
  .CurrBOld = 0,         
  .CurrCOld = 0,         
  .Inverted_pwm_new = 0,                                                      
  .Flags = 0,                                    
  .CurConv = {0,0},                                        
  .OverCurrentFlag = false,       
  .pParams_str = &R1_G0XX_Params,
};

		<#elseif MC.THREE_SHUNT == true><#-- Inside G0 family condition-->
PWMC_R3_1_Handle_t PWM_Handle_M1 =
{
  {
    .pFctGetPhaseCurrents              = &R3_1_GetPhaseCurrents,    
    .pFctSwitchOffPwm                  = &R3_1_SwitchOffPWM,             
    .pFctSwitchOnPwm                   = &R3_1_SwitchOnPWM,              
    .pFctCurrReadingCalib              = &R3_1_CurrentReadingCalibration,
    .pFctTurnOnLowSides                = &R3_1_TurnOnLowSides,             
    .pFctSetADCSampPointSectX          = &R3_1_SetADCSampPointSectX,
    .pFctIsOverCurrentOccurred         = &R3_1_IsOverCurrentOccurred,    
    .pFctOCPSetReferenceVoltage        = MC_NULL,
    .pFctRLDetectionModeEnable         = MC_NULL,    
    .pFctRLDetectionModeDisable        = MC_NULL,   
    .pFctRLDetectionModeSetDuty        = MC_NULL,   
    .hT_Sqrt3 = (PWM_PERIOD_CYCLES*SQRT3FACTOR)/16384u,     
    .Sector = 0,    
    .CntPhA = 0,
    .CntPhB = 0,
    .CntPhC = 0,
    .SWerror = 0,
    .TurnOnLowSidesAction = false, 
    .OffCalibrWaitTimeCounter = 0, 
    .Motor = 0,     
    .RLDetectionMode = false,
    .Ia = 0, 
    .Ib = 0, 
    .Ic = 0, 
    .DTTest = 0,    
    .DTCompCnt = DTCOMPCNT,
    .PWMperiod = PWM_PERIOD_CYCLES,
    .OffCalibrWaitTicks = (uint16_t)((SYS_TICK_FREQUENCY * OFFCALIBRWAIT_MS)/ 1000),
    .Ton                 = TON,
    .Toff                = TOFF
  },
  .PhaseAOffset = 0,  
  .PhaseBOffset = 0,  
  .PhaseCOffset = 0,  
  .Half_PWMPeriod = PWM_PERIOD_CYCLES/2u, 
  .OverCurrentFlag = false,  
  .OverVoltageFlag = false,  
  .BrakeActionLock = false,  
  .PolarizationCounter = 0,
  .ADC1_DMA_converted[0] = 0, 
  .ADC1_DMA_converted[1] = 0,
  .pParams_str = &R3_1_Params
};

		</#if>
	</#if><#-- Family G0 condition-->
</#if><#-- MC.DRIVE_TYPE == "FOC" -->
<#if MC.DRIVE_TYPE == "FOC" >
	<#if MC.DUALDRIVE == true>
		<#if CondFamily_STM32F3 && MC.ICS_SENSORS2 == true> 
/**
  * @brief  Current sensor parameters Dual Drive Motor 2 - ICS, STM32F30x
  */
PWMC_ICS_Handle_t PWM_Handle_M2 = {
  {
    .pFctGetPhaseCurrents              = &ICS_GetPhaseCurrents,    
    .pFctSwitchOffPwm                  = &ICS_SwitchOffPWM,             
    .pFctSwitchOnPwm                   = &ICS_SwitchOnPWM,              
    .pFctCurrReadingCalib              = &ICS_CurrentReadingCalibration,
    .pFctTurnOnLowSides                = &ICS_TurnOnLowSides,         
    .pFctSetADCSampPointSectX          = &ICS_WriteTIMRegisters,            
    .pFctIsOverCurrentOccurred         = &ICS_IsOverCurrentOccurred,    
    .pFctOCPSetReferenceVoltage        = MC_NULL,
    .pFctRLDetectionModeEnable         = MC_NULL,    
    .pFctRLDetectionModeDisable        = MC_NULL,   
    .pFctRLDetectionModeSetDuty        = MC_NULL,   
    .hT_Sqrt3 = (PWM_PERIOD_CYCLES2*SQRT3FACTOR)/16384u,   
    .Sector = 0,    
    .CntPhA = 0,
    .CntPhB = 0,
    .CntPhC = 0,
    .SWerror = 0,
    .TurnOnLowSidesAction = false,                               
    .OffCalibrWaitTimeCounter = 0,                                
    .Motor = M2,   
    .RLDetectionMode = false, 
    .Ia = 0, 
    .Ib = 0, 
    .Ic = 0, 
    .DTTest = 0,    
    .DTCompCnt = DTCOMPCNT2, 
    .PWMperiod          = PWM_PERIOD_CYCLES2,                                                
    .OffCalibrWaitTicks = (uint16_t)((SYS_TICK_FREQUENCY * OFFCALIBRWAIT_MS2)/ 1000),                                                                                                                                                 
    .Ton                 = TON2,                            
    .Toff                = TOFF2                            
  
  },
  .PhaseAOffset = 0,   
  .PhaseBOffset = 0,   
  .Half_PWMPeriod = PWM_PERIOD_CYCLES2/2u, 
  .PolarizationCounter = 0,
			<#if MC.PWM_TIMER_SELECTION2 == "PWM_TIM1">
  .ADCConfig1 =   MC_${MC.PHASE_U_CURR_CHANNEL2} << 8 | LL_ADC_INJ_TRIG_EXT_RISING | LL_ADC_INJ_TRIG_EXT_TIM1_CH4,  
  .ADCConfig2 =   MC_${MC.PHASE_V_CURR_CHANNEL2} << 8 | LL_ADC_INJ_TRIG_EXT_RISING | LL_ADC_INJ_TRIG_EXT_TIM1_CH4,     
			<#elseif MC.PWM_TIMER_SELECTION2 == "PWM_TIM8">
				<#if MC.PHASE_CURRENTS_ADC2 == "ADC1_2">
  .ADCConfig1 =   MC_${MC.PHASE_U_CURR_CHANNEL2} << 8 | LL_ADC_INJ_TRIG_EXT_RISING | LL_ADC_INJ_TRIG_EXT_TIM8_CH4_ADC12,  
  .ADCConfig2 =   MC_${MC.PHASE_V_CURR_CHANNEL2} << 8 | LL_ADC_INJ_TRIG_EXT_RISING | LL_ADC_INJ_TRIG_EXT_TIM8_CH4_ADC12,
				<#elseif  MC.PHASE_CURRENTS_ADC2 == "ADC3">
  .ADCConfig1 =   MC_${MC.PHASE_U_CURR_CHANNEL2} << 8 | LL_ADC_INJ_TRIG_EXT_RISING | LL_ADC_INJ_TRIG_EXT_TIM8_CH4__ADC34,  
  .ADCConfig2 =   MC_${MC.PHASE_V_CURR_CHANNEL2} << 8 | LL_ADC_INJ_TRIG_EXT_RISING | LL_ADC_INJ_TRIG_EXT_TIM8_CH4__ADC34,
				</#if>    
			</#if>  
  .OverCurrentFlag = false,     
  .OverVoltageFlag = false,     
  .BrakeActionLock = false,
  .pParams_str = &ICS_ParamsM2   
                                
};

		<#elseif (CondFamily_STM32F4 || CondLine_STM32F1_HD ) && MC.ICS_SENSORS2 == true> 
			<#if CondLine_STM32F1_HD >
PWMC_ICS_Handle_t PWM_Handle_M2 = 
{
  {
    .pFctGetPhaseCurrents              = &ICS_GetPhaseCurrents,    
    .pFctSwitchOffPwm                  = &ICS_SwitchOffPWM,             
    .pFctSwitchOnPwm                   = &ICS_SwitchOnPWM,              
    .pFctCurrReadingCalib              = &ICS_CurrentReadingCalibration,
    .pFctTurnOnLowSides                = &ICS_TurnOnLowSides,         
    .pFctSetADCSampPointSectX          = &ICS_WriteTIMRegisters,       
    .pFctIsOverCurrentOccurred         = &ICS_IsOverCurrentOccurred,    
    .pFctOCPSetReferenceVoltage        = MC_NULL,
    .pFctRLDetectionModeEnable         = MC_NULL,    
    .pFctRLDetectionModeDisable        = MC_NULL,   
    .pFctRLDetectionModeSetDuty        = MC_NULL,   
    .hT_Sqrt3 = (PWM_PERIOD_CYCLES2*SQRT3FACTOR)/16384u,
    .Sector = 0, 
    .CntPhA = 0,
    .CntPhB = 0,
    .CntPhC = 0,
    .SWerror = 0,
    .TurnOnLowSidesAction = false, 
    .OffCalibrWaitTimeCounter = 0,
    .Motor = M2,    
    .RLDetectionMode = false, 
    .Ia = 0, 
    .Ib = 0,
    .Ic = 0, 
    .DTTest = 0,    
    .DTCompCnt = DTCOMPCNT2, 
    .PWMperiod          = PWM_PERIOD_CYCLES2,    
    .OffCalibrWaitTicks = (uint16_t)((SYS_TICK_FREQUENCY * OFFCALIBRWAIT_MS2)/ 1000),                        
    .Ton                 = TON2,                            
    .Toff                = TOFF2                             
  
  },
  .pParams_str = ICS_ParamsM2
};

			<#elseif CondFamily_STM32F4 >
PWMC_ICS_Handle_t PWM_Handle_M2 = 
{
  {
    .pFctGetPhaseCurrents              = &ICS_GetPhaseCurrents,    
    .pFctSwitchOffPwm                  = &ICS_SwitchOffPWM,             
    .pFctSwitchOnPwm                   = &ICS_SwitchOnPWM,              
    .pFctCurrReadingCalib              = &ICS_CurrentReadingCalibration,
    .pFctTurnOnLowSides                = &ICS_TurnOnLowSides,         
    .pFctSetADCSampPointSectX          = &ICS_WriteTIMRegisters,             
    .pFctIsOverCurrentOccurred         = &ICS_IsOverCurrentOccurred,    
    .pFctOCPSetReferenceVoltage        = MC_NULL,
    .pFctRLDetectionModeEnable         = MC_NULL,    
    .pFctRLDetectionModeDisable        = MC_NULL,   
    .pFctRLDetectionModeSetDuty        = MC_NULL,   
    .hT_Sqrt3 = (PWM_PERIOD_CYCLES2*SQRT3FACTOR)/16384u,  
    .Sector = 0,    
    .CntPhA = 0,
    .CntPhB = 0,
    .CntPhC = 0,
    .SWerror = 0,
    .TurnOnLowSidesAction = false,
    .OffCalibrWaitTimeCounter = 0, 
    .Motor = M2,              
    .RLDetectionMode = false, 
    .Ia = 0,      
    .Ib = 0,      
    .Ic = 0,      
    .DTTest = 0,   
    .DTCompCnt = DTCOMPCNT2,
    .PWMperiod          = PWM_PERIOD_CYCLES2,                                          
    .OffCalibrWaitTicks = (uint16_t)((SYS_TICK_FREQUENCY * OFFCALIBRWAIT_MS2)/ 1000),                       
    .Ton                 = TON2,                             
    .Toff                = TOFF2                             
  
  },
  .PhaseAOffset = (uint32_t) 0,   
  .PhaseBOffset = (uint32_t) 0,   
  .Half_PWMPeriod = PWM_PERIOD_CYCLES2/2,
  .ADCTriggerSet = (LL_ADC_INJ_TRIG_EXT_${_last_word(MC.PWM_TIMER_SELECTION2)}_CH4 & ~ADC_INJ_TRIG_EXT_EDGE_DEFAULT),
                 
  .pParams_str = &ICS_ParamsM2
};

			</#if> 
		</#if>
	</#if>
</#if><#-- MC.DRIVE_TYPE == "FOC" -->
<#if MC.DRIVE_TYPE == "FOC" >
	<#if  MC.DUALDRIVE == true>
/**
  * @brief  PI / PID Speed loop parameters Motor 2
  */
PID_Handle_t PIDSpeedHandle_M2 =
{
  .hDefKpGain          = (int16_t)PID_SPEED_KP_DEFAULT2,     
  .hDefKiGain          = (int16_t)PID_SPEED_KI_DEFAULT2,      
  .wUpperIntegralLimit = (int32_t)IQMAX2 * (int32_t)SP_KIDIV2,  
  .wLowerIntegralLimit = -(int32_t)IQMAX2 * (int32_t)SP_KIDIV2, 
  .hUpperOutputLimit       = (int16_t)IQMAX2,                     
  .hLowerOutputLimit       = -(int16_t)IQMAX2,                
  .hKpDivisor          = (uint16_t)SP_KPDIV2,                 
  .hKiDivisor          = (uint16_t)SP_KIDIV2,                 
  .hKpDivisorPOW2      = (uint16_t)SP_KPDIV_LOG2,             
  .hKiDivisorPOW2      = (uint16_t)SP_KIDIV_LOG2,             
  .hDefKdGain           = 0x0000U,
  .hKdDivisor           = 0x0000U,
  .hKdDivisorPOW2       = 0x0000U,
};

/**
  * @brief  PI / PID Iq loop parameters Motor 2
  */
PID_Handle_t PIDIqHandle_M2 =
{
  .hDefKpGain          = (int16_t)PID_TORQUE_KP_DEFAULT2,  
  .hDefKiGain          = (int16_t)PID_TORQUE_KI_DEFAULT2,  
  .wUpperIntegralLimit = (int32_t)INT16_MAX * TF_KIDIV2,   
  .wLowerIntegralLimit = (int32_t)-INT16_MAX * TF_KIDIV2,  
  .hUpperOutputLimit       = INT16_MAX,                    
  .hLowerOutputLimit       = -INT16_MAX,                   
  .hKpDivisor          = (uint16_t)TF_KPDIV2,              
  .hKiDivisor          = (uint16_t)TF_KIDIV2,              
  .hKpDivisorPOW2      = (uint16_t)TF_KPDIV_LOG2,          
  .hKiDivisorPOW2      = (uint16_t)TF_KIDIV_LOG2,          
  .hDefKdGain           = 0x0000U,
  .hKdDivisor           = 0x0000U,
  .hKdDivisorPOW2       = 0x0000U,
};

/**
  * @brief  PI / PID Id loop parameters Motor 2
  */
PID_Handle_t PIDIdHandle_M2 =
{
  .hDefKpGain          = (int16_t)PID_FLUX_KP_DEFAULT2,    
  .hDefKiGain          = (int16_t)PID_FLUX_KI_DEFAULT2,    
  .wUpperIntegralLimit = (int32_t)INT16_MAX * TF_KIDIV2,   
  .wLowerIntegralLimit = (int32_t)-INT16_MAX * TF_KIDIV2,  
  .hUpperOutputLimit       = INT16_MAX,                    
  .hLowerOutputLimit       = -INT16_MAX,                   
  .hKpDivisor          = (uint16_t)TF_KPDIV2,              
  .hKiDivisor          = (uint16_t)TF_KIDIV2,              
  .hKpDivisorPOW2      = (uint16_t)TF_KPDIV_LOG2,          
  .hKiDivisorPOW2      = (uint16_t)TF_KIDIV_LOG2,          
  .hDefKdGain           = 0x0000U,
  .hKdDivisor           = 0x0000U,
  .hKdDivisorPOW2       = 0x0000U,
};

		<#if MC.STATE_OBSERVER_PLL2 == true || MC.STATE_OBSERVER_CORDIC2 == true  || MC.ENCODER2 == true || MC.AUX_ENCODER2 == true> 
/**
  * @brief  SpeedNPosition sensor parameters Motor 2
  */
VirtualSpeedSensor_Handle_t VirtualSpeedSensorM2 =
{
  ._Super = {
    .bElToMecRatio                     =	POLE_PAIR_NUM2,
    .hMaxReliableMecSpeedUnit          =	(uint16_t)(1.15*MAX_APPLICATION_SPEED_UNIT2),
    .hMinReliableMecSpeedUnit          =	(uint16_t)(MIN_APPLICATION_SPEED_UNIT2),
    .bMaximumSpeedErrorsNumber         =	MEAS_ERRORS_BEFORE_FAULTS2,   
    .hMaxReliableMecAccelUnitP         =	65535,                        
    .hMeasurementFrequency             =	TF_REGULATION_RATE_SCALED2,
    .DPPConvFactor                     =  DPP_CONV_FACTOR2,       
    },
  .hSpeedSamplingFreqHz =	MEDIUM_FREQUENCY_TASK_RATE2, 
  .hTransitionSteps     =	(int16_t)(TF_REGULATION_RATE2 * TRANSITION_DURATION2/ 1000.0),                            
};

		</#if>
		<#if MC.STATE_OBSERVER_PLL2 == true || MC.AUX_STATE_OBSERVER_PLL2 == true >
/**
  * @brief  SpeedNPosition sensor parameters Motor 1 - State Observer + PLL
  */
STO_PLL_Handle_t STO_PLL_M2 =
{
  ._Super = {
	.bElToMecRatio                     =	POLE_PAIR_NUM2,
    .SpeedUnit                         = SPEED_UNIT,  
    .hMaxReliableMecSpeedUnit          =	(uint16_t)(1.15*MAX_APPLICATION_SPEED_UNIT2),
    .hMinReliableMecSpeedUnit          =	(uint16_t)(MIN_APPLICATION_SPEED_UNIT2),
    .bMaximumSpeedErrorsNumber         =	MEAS_ERRORS_BEFORE_FAULTS2,           
    .hMaxReliableMecAccelUnitP         =	65535,                                
    .hMeasurementFrequency             =	TF_REGULATION_RATE_SCALED2,
    .DPPConvFactor                     =  DPP_CONV_FACTOR2,       
  },
 .hC1                         =	C12,                            
 .hC2                         =	C22,                            
 .hC3                         =	C32,                            
 .hC4                         =	C42,                            
 .hC5                         =	C52,                            
 .hF1                         =	F12,                            
 .hF2                         =	F22,                            
 .PIRegulator = {
     .hDefKpGain = PLL_KP_GAIN2,  
     .hDefKiGain = PLL_KI_GAIN2,  
	 .hDefKdGain = 0x0000U,       
     .hKpDivisor = PLL_KPDIV2,    
     .hKiDivisor = PLL_KIDIV2,    
	 .hKdDivisor = 0x0000U,			 
     .wUpperIntegralLimit = INT32_MAX,                
     .wLowerIntegralLimit = -INT32_MAX,                 
     .hUpperOutputLimit = INT16_MAX,                   
     .hLowerOutputLimit = -INT16_MAX,             
     .hKpDivisorPOW2 = PLL_KPDIV_LOG2,           
     .hKiDivisorPOW2 = PLL_KIDIV_LOG2,             
     .hKdDivisorPOW2       = 0x0000U,  
   },      			
 .SpeedBufferSizeUnit                =	STO_FIFO_DEPTH_UNIT2,              
 .SpeedBufferSizeDpp                 =	STO_FIFO_DEPTH_DPP2,               
 .VariancePercentage                 =	PERCENTAGE_FACTOR2,                
 .SpeedValidationBand_H              =	SPEED_BAND_UPPER_LIMIT2,           
 .SpeedValidationBand_L              =	SPEED_BAND_LOWER_LIMIT2,           
 .MinStartUpValidSpeed               =	OBS_MINIMUM_SPEED_UNIT2,                
 .StartUpConsistThreshold            =	NB_CONSECUTIVE_TESTS2,  	       
 .Reliability_hysteresys             =	OBS_MEAS_ERRORS_BEFORE_FAULTS2,    
 .BemfConsistencyCheck               =	BEMF_CONSISTENCY_TOL2,             
 .BemfConsistencyGain                =	BEMF_CONSISTENCY_GAIN2,            
 .MaxAppPositiveMecSpeedUnit         =	(uint16_t)(MAX_APPLICATION_SPEED_UNIT2*1.15), 
 .F1LOG                              =	F1_LOG2,                           
 .F2LOG                              =	F2_LOG2,                           
 .SpeedBufferSizeDppLOG              =	STO_FIFO_DEPTH_DPP_LOG2            
};
 
		</#if>
		<#if  MC.STATE_OBSERVER_PLL2 == true>
STO_Handle_t STO_M2 = 
{
  ._Super                        = (SpeednPosFdbk_Handle_t*)&STO_PLL_M2, 
  .pFctForceConvergency1         = &STO_PLL_ForceConvergency1,
  .pFctForceConvergency2         = &STO_PLL_ForceConvergency2,
  .pFctStoOtfResetPLL            = &STO_OTF_ResetPLL,
  .pFctSTO_SpeedReliabilityCheck = &STO_PLL_IsVarianceTight
                              
};

		</#if>
/**
  * @brief  SpeednTorque Controller parameters Motor 2
  */
SpeednTorqCtrl_Handle_t SpeednTorqCtrlM2 =
{
  .STCFrequencyHz =           		MEDIUM_FREQUENCY_TASK_RATE2, 	         
  .MaxAppPositiveMecSpeedUnit =	(uint16_t)(MAX_APPLICATION_SPEED_UNIT2),  
  .MinAppPositiveMecSpeedUnit =	(uint16_t)(MIN_APPLICATION_SPEED_UNIT2),     
  .MaxAppNegativeMecSpeedUnit =	(int16_t)(-MIN_APPLICATION_SPEED_UNIT2),  
  .MinAppNegativeMecSpeedUnit =	(int16_t)(-MAX_APPLICATION_SPEED_UNIT2),
  .MaxPositiveTorque =				(int16_t)NOMINAL_CURRENT2,		   
  .MinNegativeTorque =				-(int16_t)NOMINAL_CURRENT2,              
  .ModeDefault =					DEFAULT_CONTROL_MODE2,                  
  .MecSpeedRefUnitDefault =		(int16_t)(DEFAULT_TARGET_SPEED_UNIT2),   
  .TorqueRefDefault =				(int16_t)DEFAULT_TORQUE_COMPONENT2,      
  .IdrefDefault =					(int16_t)DEFAULT_FLUX_COMPONENT2,     
};
		<#if MC.STATE_OBSERVER_PLL2 == true || MC.STATE_OBSERVER_CORDIC2 == true>
RevUpCtrl_Handle_t RevUpControlM2 =
{
  .hRUCFrequencyHz         = MEDIUM_FREQUENCY_TASK_RATE2,   
  .hStartingMecAngle       = (int16_t)((int32_t)(STARTING_ANGLE_DEG2)* 65536/360), 
  .bFirstAccelerationStage = (ENABLE_SL_ALGO_FROM_PHASE2-1u),       
  .hMinStartUpValidSpeed   = OBS_MINIMUM_SPEED_UNIT2,            
  .hMinStartUpFlySpeed     = (int16_t)((OBS_MINIMUM_SPEED_UNIT2)/2),   
  .OTFStartupEnabled       = ${MC.OTF_STARTUP2?string("true","false")}, 
  .OTFPhaseParams         = {(uint16_t)500,                
                                         0,                
                             (int16_t)PHASE5_FINAL_CURRENT2, 
                             (void*)MC_NULL},
  .ParamsData             = {{(uint16_t)PHASE1_DURATION2,(int16_t)(PHASE1_FINAL_SPEED_UNIT2),(int16_t)PHASE1_FINAL_CURRENT2,&RevUpControlM2.ParamsData[1]},
                             {(uint16_t)PHASE2_DURATION2,(int16_t)(PHASE2_FINAL_SPEED_UNIT2),(int16_t)PHASE2_FINAL_CURRENT2,&RevUpControlM2.ParamsData[2]},
                             {(uint16_t)PHASE3_DURATION2,(int16_t)(PHASE3_FINAL_SPEED_UNIT2),(int16_t)PHASE3_FINAL_CURRENT2,&RevUpControlM2.ParamsData[3]},
                             {(uint16_t)PHASE4_DURATION2,(int16_t)(PHASE4_FINAL_SPEED_UNIT2),(int16_t)PHASE4_FINAL_CURRENT2,&RevUpControlM2.ParamsData[4]},
                             {(uint16_t)PHASE5_DURATION2,(int16_t)(PHASE5_FINAL_SPEED_UNIT2),(int16_t)PHASE5_FINAL_CURRENT2,(void*)MC_NULL},
                            },
  
};
		</#if>
	</#if> 
</#if><#-- MC.DRIVE_TYPE == "FOC" -->
<#if MC.DRIVE_TYPE == "FOC" >
	<#if  MC.STATE_OBSERVER_PLL == true || MC.STATE_OBSERVER_CORDIC == true ||  MC.ENCODER == true ||  MC.AUX_ENCODER == true> 
/**
  * @brief  SpeedNPosition sensor parameters Motor 1 - Base Class
  */
VirtualSpeedSensor_Handle_t VirtualSpeedSensorM1 =
{
  
  ._Super = {
    .bElToMecRatio                     =	POLE_PAIR_NUM, 
    .hMaxReliableMecSpeedUnit          =	(uint16_t)(1.15*MAX_APPLICATION_SPEED_UNIT),
    .hMinReliableMecSpeedUnit          =	(uint16_t)(MIN_APPLICATION_SPEED_UNIT),
    .bMaximumSpeedErrorsNumber         =	MEAS_ERRORS_BEFORE_FAULTS,      
    .hMaxReliableMecAccelUnitP         =	65535,                             
    .hMeasurementFrequency             =	TF_REGULATION_RATE_SCALED,
    .DPPConvFactor                     =  DPP_CONV_FACTOR,       
    },
  .hSpeedSamplingFreqHz =	MEDIUM_FREQUENCY_TASK_RATE, 
  .hTransitionSteps     =	(int16_t)(TF_REGULATION_RATE * TRANSITION_DURATION/ 1000.0),
                           
};

	</#if>
</#if><#-- MC.DRIVE_TYPE == "FOC" -->
<#if MC.DRIVE_TYPE == "FOC" >
	<#if   MC.HFINJECTION == true>
/**
  * @brief  SpeedNPosition sensor parameters Motor 1 - HFI
  */
HFI_FP_SPD_Handle_t HfiFpSpeedM1 =
{
  ._Super ={
    .bElToMecRatio                     =	POLE_PAIR_NUM,               
    .hMaxReliableMecSpeedUnit          =	(uint16_t)(1.15*MAX_APPLICATION_SPEED_UNIT),
    .hMinReliableMecSpeedUnit          =	(uint16_t)(MIN_APPLICATION_SPEED_UNIT),
    .bMaximumSpeedErrorsNumber         =	MEAS_ERRORS_BEFORE_FAULTS,           
    .hMaxReliableMecAccelUnitP         =	65535,                                
    .hMeasurementFrequency             =	TF_REGULATION_RATE_SCALED,
    .DPPConvFactor                     =  DPP_CONV_FACTOR,       
  },
  .SpeedBufferSize01Hz =	HFI_SPD_BUFFER_DEPTH_01HZ,
  .SwapMecSpeed01Hz    =	RPM2MEC01HZ(HFI_MINIMUM_SPEED_RPM),
  .STOHFI01Hz          =	RPM2MEC01HZ(STO_HFI_RPM_TH),
  .HFISTO01Hz          =	RPM2MEC01HZ(HFI_STO_RPM_TH),
  .HFIRestart01Hz      =	RPM2MEC01HZ(HFI_RESTART_RPM_TH)
};

/**
  * @brief  IMHiFreqInj_FPU class parameters Motor 1 - Derived Class - HFI
  */
HFI_FP_Ctrl_Handle_t HfiFpCtrlM1 =
{
  .aNotchDIIcoefficients = {HFI_NOTCH_0_COEFF,HFI_NOTCH_1_COEFF,HFI_NOTCH_2_COEFF,
   HFI_NOTCH_3_COEFF,HFI_NOTCH_4_COEFF},
  .aLPIDIIcoefficients = {HFI_LP_0_COEFF,HFI_LP_1_COEFF,HFI_LP_2_COEFF,
   HFI_LP_3_COEFF,HFI_LP_4_COEFF},
  .aHPIDIIcoefficients = {HFI_HP_0_COEFF,HFI_HP_1_COEFF,HFI_HP_2_COEFF,
   HFI_HP_3_COEFF,HFI_HP_4_COEFF},
  .aPLLDIIcoefficients = {HFI_DC_0_COEFF,HFI_DC_1_COEFF,HFI_DC_2_COEFF,
   HFI_DC_3_COEFF,HFI_DC_4_COEFF},
  .HiFrFreq = HFI_FREQUENCY,          
  .HiFrAmplVolts = HFI_AMPLITUDE,         
  .PWMFr = TF_REGULATION_RATE_SCALED,    
  .IdhPhase = HFI_IDH_DELAY,         
  .PIDHandle = {
    .hDefKpGain = (int16_t)HFI_PID_KP_DEFAULT,
    .hDefKiGain = (int16_t)HFI_PID_KI_DEFAULT,
    .hKpDivisor = (uint16_t)HFI_PID_KPDIV,
    .hKiDivisor = (uint16_t)HFI_PID_KIDIV,
    .wUpperIntegralLimit = INT32_MAX,           
    .wLowerIntegralLimit = -INT32_MAX,            
    .hUpperOutputLimit = INT16_MAX,           
    .hLowerOutputLimit = -INT16_MAX,           
    .hKpDivisorPOW2 = (uint16_t)HFI_PID_KPDIV_LOG,
    .hKiDivisorPOW2 = (uint16_t)HFI_PID_KIDIV_LOG
  },      	        
  .DefPLLKP = HFI_PLL_KP_DEFAULT,    
  .DefPLLKI = HFI_PLL_KI_DEFAULT,   
  .LockFreq = HFI_LOCKFREQ,        
  .ScanRotationsNo = HFI_SCANROTATIONSNO,  
  .HiFrAmplScanVolts = HFI_HIFRAMPLSCAN,       
  .WaitBeforeNS = HFI_WAITBEFORESN,      
  .WaitAfterNS = HFI_WAITAFTERNS,     
  .NSMaxDetPoints = HFI_NSMAXDETPOINTS,    
  .NSDetPointsSkip = HFI_NSDETPOINTSSKIP,   
  .DefMinSaturationDifference = HFI_NS_MIN_SAT_DIFF,  
  .debugmode = HFI_DEBUG_MODE,        
  .RevertDirection = HFI_REVERT_DIRECTION,   
  .WaitTrack = HFI_WAITTRACK,          
  .WaitSynch = HFI_WAITSYNCH,          
  .StepAngle = HFI_STEPANGLE,          
  .MaxangleDiff = HFI_MAXANGLEDIFF,       
  .RestartTime = HFI_RESTARTTIMESEC     
};

		<#if  MC.DUALDRIVE == true &&  MC.HFINJECTION2 == true>
/**
  * @brief  SpeedNPosition sensor parameters Motor 2 - HFI
  */
HFI_FP_SPD_Handle_t HfiFpSpeedM2 =
{
  ._Super = {
    .bElToMecRatio             = POLE_PAIR_NUM2,                           
    .hMaxReliableMecSpeed01Hz  = (uint16_t)(1.15*MAX_APPLICATION_SPEED2/6), 
    .hMinReliableMecSpeed01Hz  = (uint16_t)(MIN_APPLICATION_SPEED2/6),      
    .bMaximumSpeedErrorsNumber = MEAS_ERRORS_BEFORE_FAULTS2,                
    .hMaxReliableMecAccel01HzP = 65535,                                    
    .hMeasurementFrequency     = TF_REGULATION_RATE_SCALED2,
    .DPPConvFactor             =  DPP_CONV_FACTOR2,       
  },
  .SpeedBufferSize01Hz = HFI_SPD_BUFFER_DEPTH_01HZ2,
  .SwapMecSpeed01Hz    = RPM2MEC01HZ(HFI_MINIMUM_SPEED_RPM2),
  .STOHFI01Hz          = RPM2MEC01HZ(STO_HFI_RPM_TH2),
  .HFISTO01Hz          = RPM2MEC01HZ(HFI_STO_RPM_TH2),
  .HFIRestart01Hz      = RPM2MEC01HZ(HFI_RESTART_RPM_TH2)
};

/**
  * @brief  HiFreqInj_FPU parameters Motor 2 - HFI
  */
HFI_FP_Ctrl_Handle_t HfiFpCtrlM2 =
{
  .aNotchDIIcoefficients = {HFI_NOTCH_0_COEFF2,HFI_NOTCH_1_COEFF2,HFI_NOTCH_2_COEFF2,
   HFI_NOTCH_3_COEFF2,HFI_NOTCH_4_COEFF2},
  .aLPIDIIcoefficients = {HFI_LP_0_COEFF2,HFI_LP_1_COEFF2,HFI_LP_2_COEFF2,
   HFI_LP_3_COEFF2,HFI_LP_4_COEFF2},
  .aHPIDIIcoefficients = {HFI_HP_0_COEFF2,HFI_HP_1_COEFF2,HFI_HP_2_COEFF2,
   HFI_HP_3_COEFF2,HFI_HP_4_COEFF2},
  .aPLLDIIcoefficients = {HFI_DC_0_COEFF2,HFI_DC_1_COEFF2,HFI_DC_2_COEFF2,
   HFI_DC_3_COEFF2,HFI_DC_4_COEFF2},
  .HiFrFreq      =HFI_FREQUENCY2,         
  .HiFrAmplVolts =HFI_AMPLITUDE2,        
  .PWMFr         =TF_REGULATION_RATE_SCALED2,    
  .IdhPhase      =HFI_IDH_DELAY2,         
  .PIDHandle = {
    .hDefKpGain = (int16_t)HFI_PID_KP_DEFAULT2,
    .hDefKiGain = (int16_t)HFI_PID_KI_DEFAULT2,
    .hKpDivisor = (uint16_t)HFI_PID_KPDIV2,
    .hKiDivisor = (uint16_t)HFI_PID_KIDIV2,
    .wUpperIntegralLimit = INT32_MAX,            
    .wLowerIntegralLimit = -INT32_MAX,            
    .hUpperOutputLimit = INT16_MAX,             
    .hLowerOutputLimit = -INT16_MAX,             
    .hKpDivisorPOW2 = (uint16_t)HFI_PID_KPDIV_LOG2,
    .hKiDivisorPOW2 = (uint16_t)HFI_PID_KIDIV_LOG2
                         
  },                     
  .DefPLL_KP                  = HFI_PLL_KP_DEFAULT2,    
  .DefPLL_KI                  = HFI_PLL_KI_DEFAULT2,    
  .LockFreq                   = HFI_LOCKFREQ2,          
  .ScanRotationsNo            = HFI_SCANROTATIONSNO2,   
  .HiFrAmplScanVolts          = HFI_HIFRAMPLSCAN2,      
  .WaitBeforeNS               = HFI_WAITBEFORESN2,      
  .WaitAfterNS                = HFI_WAITAFTERNS2,       
  .NSMaxDetPoints             = HFI_NSMAXDETPOINTS2,    
  .NSDetPointsSkip            = HFI_NSDETPOINTSSKIP2,   
  .DefMinSaturationDifference = HFI_NS_MIN_SAT_DIFF2,   
  .debugmode                   = HFI_DEBUG_MODE2,       
  .RevertDirection             = HFI_REVERT_DIRECTION2, 
  .WaitTrack                  = HFI_WAITTRACK2,         
  .WaitSynch                  = HFI_WAITSYNCH2,         
  .StepAngle                  = HFI_STEPANGLE2,         
  .MaxangleDiff               = HFI_MAXANGLEDIFF2,      
  .RestartTime                = HFI_RESTARTTIMESEC2     
};

		</#if>
	</#if>
</#if><#-- MC.DRIVE_TYPE == "FOC" -->
<#if MC.DRIVE_TYPE == "FOC" >
	<#if  MC.STATE_OBSERVER_PLL == true ||  MC.AUX_STATE_OBSERVER_PLL == true>
/**
  * @brief  SpeedNPosition sensor parameters Motor 1 - State Observer + PLL
  */
STO_PLL_Handle_t STO_PLL_M1 =
{
  ._Super = {
	.bElToMecRatio                     =	POLE_PAIR_NUM,
    .SpeedUnit                         = SPEED_UNIT,
    .hMaxReliableMecSpeedUnit          =	(uint16_t)(1.15*MAX_APPLICATION_SPEED_UNIT),
    .hMinReliableMecSpeedUnit          =	(uint16_t)(MIN_APPLICATION_SPEED_UNIT),
    .bMaximumSpeedErrorsNumber         =	MEAS_ERRORS_BEFORE_FAULTS,           
    .hMaxReliableMecAccelUnitP         =	65535,                               
    .hMeasurementFrequency             =	TF_REGULATION_RATE_SCALED,
    .DPPConvFactor                     =  DPP_CONV_FACTOR,    
  },
 .hC1                         =	C1,                             
 .hC2                         =	C2,                             
 .hC3                         =	C3,                             
 .hC4                         =	C4,                             
 .hC5                         =	C5,                             
 .hF1                         =	F1,                             
 .hF2                         =	F2,                             
 .PIRegulator = {
     .hDefKpGain = PLL_KP_GAIN, 
     .hDefKiGain = PLL_KI_GAIN, 
	 .hDefKdGain = 0x0000U,     
     .hKpDivisor = PLL_KPDIV,   
     .hKiDivisor = PLL_KIDIV,   
	 .hKdDivisor = 0x0000U,			 
     .wUpperIntegralLimit = INT32_MAX, 
     .wLowerIntegralLimit = -INT32_MAX,
     .hUpperOutputLimit = INT16_MAX, 
     .hLowerOutputLimit = -INT16_MAX, 
     .hKpDivisorPOW2 = PLL_KPDIV_LOG,  
     .hKiDivisorPOW2 = PLL_KIDIV_LOG, 
     .hKdDivisorPOW2       = 0x0000U, 
   },      			
 .SpeedBufferSizeUnit                =	STO_FIFO_DEPTH_UNIT,           
 .SpeedBufferSizeDpp                 =	STO_FIFO_DEPTH_DPP,            
 .VariancePercentage                 =	PERCENTAGE_FACTOR,             
 .SpeedValidationBand_H              =	SPEED_BAND_UPPER_LIMIT,        
 .SpeedValidationBand_L              =	SPEED_BAND_LOWER_LIMIT,        
 .MinStartUpValidSpeed               =	OBS_MINIMUM_SPEED_UNIT,             
 .StartUpConsistThreshold            =	NB_CONSECUTIVE_TESTS,  	       
 .Reliability_hysteresys             =	OBS_MEAS_ERRORS_BEFORE_FAULTS, 
 .BemfConsistencyCheck               =	BEMF_CONSISTENCY_TOL,          
 .BemfConsistencyGain                =	BEMF_CONSISTENCY_GAIN,         
 .MaxAppPositiveMecSpeedUnit         =	(uint16_t)(MAX_APPLICATION_SPEED_UNIT*1.15), 
 .F1LOG                              =	F1_LOG,                            
 .F2LOG                              =	F2_LOG,                            
 .SpeedBufferSizeDppLOG              =	STO_FIFO_DEPTH_DPP_LOG             
};
STO_PLL_Handle_t *pSTO_PLL_M1 = &STO_PLL_M1; 

	</#if>
	<#if  MC.STATE_OBSERVER_PLL == true>
STO_Handle_t STO_M1 = 
{
  ._Super                        = (SpeednPosFdbk_Handle_t*)&STO_PLL_M1,
  .pFctForceConvergency1         = &STO_PLL_ForceConvergency1,
  .pFctForceConvergency2         = &STO_PLL_ForceConvergency2,
  .pFctStoOtfResetPLL            = &STO_OTF_ResetPLL,
  .pFctSTO_SpeedReliabilityCheck = &STO_PLL_IsVarianceTight                              
};

	</#if>
	<#if  MC.STATE_OBSERVER_CORDIC2 == true ||  MC.AUX_STATE_OBSERVER_CORDIC2 == true>
/**
  * @brief  SpeedNPosition sensor parameters Motor 2 - State Observer + CORDIC
  */
STO_CR_Handle_t STO_CR_M2 =
{ 
  ._Super = {
    .bElToMecRatio                     =	POLE_PAIR_NUM2,
    .SpeedUnit                         =  SPEED_UNIT,      
    .hMaxReliableMecSpeedUnit          =	(uint16_t)(1.15*MAX_APPLICATION_SPEED_UNIT2),
    .hMinReliableMecSpeedUnit          =	(uint16_t)(MIN_APPLICATION_SPEED_UNIT2),
    .bMaximumSpeedErrorsNumber         =	MEAS_ERRORS_BEFORE_FAULTS2,           
    .hMaxReliableMecAccelUnitP         =	65535,                                
    .hMeasurementFrequency             =	TF_REGULATION_RATE_SCALED2,
    .DPPConvFactor                     =  DPP_CONV_FACTOR2,       
    },
  .hC1                                 =	CORD_C12,                             
  .hC2                                 =	CORD_C22,                        
  .hC3                                 =	CORD_C32,                        
  .hC4                                 =	CORD_C42,                        
  .hC5                                 =	CORD_C52,                        
  .hF1                                 =	CORD_F12,                     
  .hF2                                 =	CORD_F22,                     
  .SpeedBufferSizeUnit                =	CORD_FIFO_DEPTH_UNIT2,            
  .SpeedBufferSizedpp                 =	CORD_FIFO_DEPTH_DPP2,             
  .VariancePercentage                 =	CORD_PERCENTAGE_FACTOR2,          
  .SpeedValidationBand_H              =	SPEED_BAND_UPPER_LIMIT2,          
  .SpeedValidationBand_L              =	SPEED_BAND_LOWER_LIMIT2,          
  .MinStartUpValidSpeed               =	OBS_MINIMUM_SPEED_UNIT2,                 
  .StartUpConsistThreshold            =	NB_CONSECUTIVE_TESTS2,  		    
  .Reliability_hysteresys             =	CORD_MEAS_ERRORS_BEFORE_FAULTS2,    
  .MaxInstantElAcceleration           =	CORD_MAX_ACCEL_DPPP2,               
  .BemfConsistencyCheck               =	CORD_BEMF_CONSISTENCY_TOL2,         
  .BemfConsistencyGain                =	CORD_BEMF_CONSISTENCY_GAIN2,              
  .MaxAppPositiveMecSpeedUnit         =	(uint16_t)(MAX_APPLICATION_SPEED_UNIT2*1.15),  
  .F1LOG                              =	CORD_F1_LOG2 ,                         
  .F2LOG                              =	CORD_F2_LOG2 ,                         
  .SpeedBufferSizedppLOG              =	CORD_FIFO_DEPTH_DPP_LOG2         
};

	</#if>
	<#if  MC.STATE_OBSERVER_CORDIC2 == true>
STO_Handle_t STO_M2 = 
{
  ._Super                        = (SpeednPosFdbk_Handle_t*)&STO_CR_M2, 
  .pFctForceConvergency1         = &STO_CR_ForceConvergency1,
  .pFctForceConvergency2         = &STO_CR_ForceConvergency2,
  .pFctStoOtfResetPLL            = MC_NULL,
  .pFctSTO_SpeedReliabilityCheck = &STO_CR_IsSpeedReliable
                              
};

	</#if>
	<#if  MC.STATE_OBSERVER_CORDIC == true ||  MC.AUX_STATE_OBSERVER_CORDIC == true>
/**
  * @brief  SpeedNPosition sensor parameters Motor 1 - State Observer + CORDIC
  */
STO_CR_Handle_t STO_CR_M1 =
{ 
  ._Super = {
    .bElToMecRatio                     =	POLE_PAIR_NUM,
    .SpeedUnit                         =  SPEED_UNIT,      
    .hMaxReliableMecSpeedUnit          =	(uint16_t)(1.15*MAX_APPLICATION_SPEED_UNIT),
    .hMinReliableMecSpeedUnit          =	(uint16_t)(MIN_APPLICATION_SPEED_UNIT),
    .bMaximumSpeedErrorsNumber         =	MEAS_ERRORS_BEFORE_FAULTS,          
    .hMaxReliableMecAccelUnitP         =	65535,                              
    .hMeasurementFrequency             =	TF_REGULATION_RATE_SCALED,
    .DPPConvFactor                     =  DPP_CONV_FACTOR,       
    },
  .hC1                                 =	CORD_C1,                            
  .hC2                                 =	CORD_C2,                        
  .hC3                                 =	CORD_C3,                        
  .hC4                                 =	CORD_C4,                        
  .hC5                                 =	CORD_C5,                        
  .hF1                                 =	CORD_F1,                        
  .hF2                                 =	CORD_F2,                     
  .SpeedBufferSizeUnit                =	CORD_FIFO_DEPTH_UNIT,            
  .SpeedBufferSizedpp                 =	CORD_FIFO_DEPTH_DPP,             
  .VariancePercentage                 =	CORD_PERCENTAGE_FACTOR,          
  .SpeedValidationBand_H              =	SPEED_BAND_UPPER_LIMIT,          
  .SpeedValidationBand_L              =	SPEED_BAND_LOWER_LIMIT,          
  .MinStartUpValidSpeed               =	OBS_MINIMUM_SPEED_UNIT,               
  .StartUpConsistThreshold            =	NB_CONSECUTIVE_TESTS,  		      
  .Reliability_hysteresys             =	CORD_MEAS_ERRORS_BEFORE_FAULTS,   
  .MaxInstantElAcceleration           =	CORD_MAX_ACCEL_DPPP,              
  .BemfConsistencyCheck               =	CORD_BEMF_CONSISTENCY_TOL,        
  .BemfConsistencyGain                =	CORD_BEMF_CONSISTENCY_GAIN,       
  .MaxAppPositiveMecSpeedUnit         =	(uint16_t)(MAX_APPLICATION_SPEED_UNIT*1.15),  
  .F1LOG                              =	CORD_F1_LOG,                           
  .F2LOG                              =	CORD_F2_LOG,                           
  .SpeedBufferSizedppLOG              =	CORD_FIFO_DEPTH_DPP_LOG           
};

	</#if>
	<#if  MC.STATE_OBSERVER_CORDIC == true>
STO_Handle_t STO_M1 = 
{
  ._Super                        = (SpeednPosFdbk_Handle_t*)&STO_CR_M1, 
  .pFctForceConvergency1         = &STO_CR_ForceConvergency1,
  .pFctForceConvergency2         = &STO_CR_ForceConvergency2,
  .pFctStoOtfResetPLL            = MC_NULL,
  .pFctSTO_SpeedReliabilityCheck = &STO_CR_IsSpeedReliable
                              
};

	</#if>
	</#if><#-- MC.DRIVE_TYPE == "FOC" -->
		<#if MC.DRIVE_TYPE == "FOC" >
			<#if ( MC.ENCODER == true ||  MC.AUX_ENCODER == true)>
/**
  * @brief  SpeedNPosition sensor parameters Motor 1 - Encoder
  */
ENCODER_Handle_t ENCODER_M1 =
{
  ._Super = {
    .bElToMecRatio                     =	POLE_PAIR_NUM,              
    .hMaxReliableMecSpeedUnit          =	(uint16_t)(1.15*MAX_APPLICATION_SPEED_UNIT),
    .hMinReliableMecSpeedUnit          =	(uint16_t)(MIN_APPLICATION_SPEED_UNIT),
    .bMaximumSpeedErrorsNumber         =	MEAS_ERRORS_BEFORE_FAULTS,         
    .hMaxReliableMecAccelUnitP         =	65535,                               
    .hMeasurementFrequency             =	TF_REGULATION_RATE_SCALED,
    .DPPConvFactor                     =  DPP_CONV_FACTOR,       
  },  
  .PulseNumber           =	M1_ENCODER_PPR*4,		 
  .RevertSignal           =	(FunctionalState)ENC_INVERT_SPEED,
  .SpeedSamplingFreqHz   =	MEDIUM_FREQUENCY_TASK_RATE, 
  .SpeedBufferSize       =	ENC_AVERAGING_FIFO_DEPTH,  
  .TIMx                  =	${_last_word(MC.ENC_TIMER_SELECTION)},	    
  .ICx_Filter            =  M1_ENC_IC_FILTER,

};

/**
  * @brief  Encoder Alignment Controller parameters Motor 1
  */
EncAlign_Handle_t EncAlignCtrlM1 =
{
  .hEACFrequencyHz =	MEDIUM_FREQUENCY_TASK_RATE,
  .hFinalTorque    =	FINAL_I_ALIGNMENT,            
  .hElAngle        =	ALIGNMENT_ANGLE_S16,      
  .hDurationms     =	ALIGNMENT_DURATION,              
  .bElToMecRatio   =	POLE_PAIR_NUM,            
};

			</#if>
			<#if ( MC.ENCODER2 == true ||  MC.AUX_ENCODER2 == true)>
/**
  * @brief  SpeedNPosition sensor parameters Motor 2 - Encoder
  */
ENCODER_Handle_t ENCODER_M2 =
{
  ._Super = {
    .bElToMecRatio                     =	POLE_PAIR_NUM2,  
    .hMaxReliableMecSpeedUnit          =	(uint16_t)(1.15*MAX_APPLICATION_SPEED_UNIT2), 
    .hMinReliableMecSpeedUnit          =	(uint16_t)(MIN_APPLICATION_SPEED_UNIT2),
    .bMaximumSpeedErrorsNumber         =	MEAS_ERRORS_BEFORE_FAULTS2,            
    .hMaxReliableMecAccelUnitP         =	65535,    
    .hMeasurementFrequency             =	TF_REGULATION_RATE_SCALED2,
    .DPPConvFactor                     =  DPP_CONV_FACTOR,       
  },  
  .PulseNumber           =	M2_ENCODER_PPR*4,		 
  .RevertSignal           =	(FunctionalState)ENC_INVERT_SPEED2, 
  .SpeedSamplingFreqHz   =	 MEDIUM_FREQUENCY_TASK_RATE2, 
  .SpeedBufferSize       =	ENC_AVERAGING_FIFO_DEPTH2,
  .TIMx                  =	${_last_word(MC.ENC_TIMER_SELECTION2)},	   
  .ICx_Filter            =  M2_ENC_IC_FILTER,   
};

/**
  * @brief  Encoder Alignment Controller parameters Motor 2
  */
EncAlign_Handle_t EncAlignCtrlM2 =
{
  .hEACFrequencyHz =	MEDIUM_FREQUENCY_TASK_RATE2, 
  .hFinalTorque    =	FINAL_I_ALIGNMENT2,             
  .hElAngle        =	ALIGNMENT_ANGLE_S162,    
  .hDurationms     =	ALIGNMENT_DURATION2,           
  .bElToMecRatio   =	POLE_PAIR_NUM2,           
};

			</#if>
		</#if><#-- MC.DRIVE_TYPE == "FOC" -->
		<#if MC.DRIVE_TYPE == "FOC" >
			<#if  MC.OPEN_LOOP_FOC == true>
OpenLoop_Handle_t OpenLoop_ParamsM1 =
{
  .hDefaultVoltage  = OPEN_LOOP_VOLTAGE_d,
  .VFMode           = OPEN_LOOP_VF,       
  .hVFOffset        = OPEN_LOOP_OFF,      
  .hVFSlope         = OPEN_LOOP_K         
                                          
};

			</#if> 
		</#if><#-- MC.DRIVE_TYPE == "FOC" -->
		<#if MC.DRIVE_TYPE == "FOC" >
			<#if ( MC.DUALDRIVE == true &&  MC.OPEN_LOOP_FOC2 == true)>
OpenLoop_Handle_t OpenLoop_ParamsM2 =
{
  .hDefaultVoltage  = OPEN_LOOP_VOLTAGE_d2, 
  .VFMode           = OPEN_LOOP_VF2,        
  .hVFOffset        = OPEN_LOOP_OFF2,       
  .hVFSlope         = OPEN_LOOP_K2          
                                            
};

			</#if> 
		</#if><#-- MC.DRIVE_TYPE == "FOC" -->
		<#if MC.DRIVE_TYPE == "FOC" >
			<#if  CondFamily_STM32F3 &&  MC.SINGLE_SHUNT2 == true> 
/**
  * @brief  Current sensor parameters Motor 2 - single shunt - F30x
  */

PWMC_R1_F3_Handle_t PWM_Handle_M2 =
{  
  {
    .pFctGetPhaseCurrents               = &R1F30X_GetPhaseCurrents,    
    .pFctSwitchOffPwm                   = &R1F30X_SwitchOffPWM,             
    .pFctSwitchOnPwm                    = &R1F30X_SwitchOnPWM,              
    .pFctCurrReadingCalib               = &R1F30X_CurrentReadingCalibration,
    .pFctTurnOnLowSides                 = &R1F30X_TurnOnLowSides,         
    .pFctSetADCSampPointSectX           = &R1F30X_CalcDutyCycles,          
    .pFctIsOverCurrentOccurred          = &R1F30X_IsOverCurrentOccurred,    
    .pFctOCPSetReferenceVoltage         = MC_NULL,
    .pFctRLDetectionModeEnable          = MC_NULL,    
    .pFctRLDetectionModeDisable         = MC_NULL,   
    .pFctRLDetectionModeSetDuty         = MC_NULL,   
    .hT_Sqrt3 = (PWM_PERIOD_CYCLES2*SQRT3FACTOR)/16384u,   
    .Sector = 0,    
    .CntPhA = 0,
    .CntPhB = 0,
    .CntPhC = 0,
    .SWerror = 0,
    .TurnOnLowSidesAction = false,                               
    .OffCalibrWaitTimeCounter = 0,                                   
    .Motor = M2,     
    .RLDetectionMode = false, 
    .Ia = 0, 
    .Ib = 0, 
    .Ic = 0, 
    .DTTest = 0,    
    .DTCompCnt = DTCOMPCNT2, 
    .PWMperiod          = PWM_PERIOD_CYCLES2,                                         
    .OffCalibrWaitTicks = (uint16_t)((SYS_TICK_FREQUENCY * OFFCALIBRWAIT_MS2)/ 1000),                                                             
    .Ton                 = TON2,                              
    .Toff                = TOFF2                              
  },
  .DmaBuff = {0,0},  
  .CntSmp1 = 0,               
  .CntSmp2 = 0,               
  .sampCur1 = 0,               
  .sampCur2 = 0,               
  .CurrAOld = 0,              
  .CurrBOld = 0,              
  .Inverted_pwm_new = 0,                                           
  .Flags = 0,                                            
  .PhaseOffset = 0,           
  .Index = 0,                                           
  .Half_PWMPeriod = PWM_PERIOD_CYCLES2/2u,         
  .ADC_JSQR = 0,                                         
  .PreloadDisableActing = 0,  
  .PreloadDisableCC2 = 0,                               
  .PreloadDisableCC3 = 0,                              
  .PreloadDMAy_Chx = 0,        
  .DistortionDMAy_Chx = 0,     
  .OverCurrentFlag = false,    
  .OverVoltageFlag = false,    
  .BrakeActionLock = false,    
  .pParams_str =  &R1_F30XParamsM2,
};

			<#elseif CondFamily_STM32F4 &&  MC.SINGLE_SHUNT2 == true>  
PWMC_R1_F4_Handle_t PWM_Handle_M2=
{
  ._Super ={
    .pFctGetPhaseCurrents              = &R1F4XX_GetPhaseCurrents,    
    .pFctSwitchOffPwm                  = &R1F4XX_SwitchOffPWM,             
    .pFctSwitchOnPwm                   = &R1F4XX_SwitchOnPWM,              
    .pFctCurrReadingCalib              = &R1F4XX_CurrentReadingCalibration,
    .pFctTurnOnLowSides                = &R1F4XX_TurnOnLowSides,           
    .pFctSetADCSampPointSectX          = &R1F4XX_CalcDutyCycles,             
    .pFctIsOverCurrentOccurred         = &R1F4XX_IsOverCurrentOccurred,    
    .pFctOCPSetReferenceVoltage        = MC_NULL,
    .pFctRLDetectionModeEnable         = MC_NULL,    
    .pFctRLDetectionModeDisable        = MC_NULL,   
    .pFctRLDetectionModeSetDuty        = MC_NULL,   
    .hT_Sqrt3 = (PWM_PERIOD_CYCLES2*SQRT3FACTOR)/16384u,   
    .Sector = 0,   
    .CntPhA = 0,
    .CntPhB = 0,
    .CntPhC = 0,
    .SWerror = 0,
    .TurnOnLowSidesAction = false, 
    .OffCalibrWaitTimeCounter = 0,
    .Motor = M2,     
    .RLDetectionMode = false, 
    .Ia = 0, 
    .Ib = 0, 
    .Ic = 0, 
    .DTTest = 0,    
    .DTCompCnt = DTCOMPCNT2, 
    .PWMperiod          = PWM_PERIOD_CYCLES2,    
    .OffCalibrWaitTicks = (uint16_t)((SYS_TICK_FREQUENCY * OFFCALIBRWAIT_MS2)/ 1000),                         
    .Ton                 = TON2,                              
    .Toff                = TOFF2                             
  },      
  .Half_PWMPeriod = PWM_PERIOD_CYCLES2/2u,   
  .hDmaBuff = {0,0},  
  .hCCDmaBuffCh4 = {0,0,0,0},
  .hCntSmp1 = 0,        
  .hCntSmp2 = 0,        
  .sampCur1 = 0,      
  .sampCur2 = 0,        
  .hCurrAOld = 0,       
  .hCurrBOld = 0,       
  .hCurrCOld = 0,       
  .bInverted_pwm = 0,                
  .bInverted_pwm_new = 0,                         
  .hPreloadCCMR2Set = 0, 
  .bDMATot = 0,                                
  .bDMACur = 0,          
  .hFlags = 0,                                      
  .pDrive = MC_NULL,             
  .wPhaseOffset = 0,     
 .bIndex = 0,   
  .pTIMx_2_CCR = 0, 
  .pParams_str = &R1_F4_ParamsM2,
};

			<#elseif CondFamily_STM32F4 &&  MC.THREE_SHUNT_INDEPENDENT_RESOURCES2 == true> 
PWMC_R3_2_Handle_t PWM_Handle_M2=
{
  {
    .pFctGetPhaseCurrents              = &R3_2_GetPhaseCurrents,    
    .pFctSwitchOffPwm                  = &R3_2_SwitchOffPWM,             
    .pFctSwitchOnPwm                   = &R3_2_SwitchOnPWM,              
    .pFctCurrReadingCalib              = &R3_2_CurrentReadingCalibration,
    .pFctTurnOnLowSides                = &R3_2_TurnOnLowSides,           
    .pFctSetADCSampPointSectX          = &R3_2_SetADCSampPointSectX,
    .pFctIsOverCurrentOccurred         = &R3_2_IsOverCurrentOccurred,    
    .pFctOCPSetReferenceVoltage        = MC_NULL,
    .pFctRLDetectionModeEnable         = &R3_2_RLDetectionModeEnable,    
    .pFctRLDetectionModeDisable        = &R3_2_RLDetectionModeDisable,   
    .pFctRLDetectionModeSetDuty        = &R3_2_RLDetectionModeSetDuty,   
    .hT_Sqrt3 = (PWM_PERIOD_CYCLES2*SQRT3FACTOR)/16384u,  
    .Sector = 0,   
    .CntPhA = 0,
    .CntPhB = 0,
    .CntPhC = 0,
    .SWerror = 0,
    .TurnOnLowSidesAction = false, 
    .OffCalibrWaitTimeCounter = 0, 
    .Motor = M2,     
    .RLDetectionMode = false,
    .Ia = 0, 
    .Ib = 0,
    .Ic = 0, 
    .DTTest = 0,    
    .DTCompCnt = DTCOMPCNT2, 
    .PWMperiod          = PWM_PERIOD_CYCLES2,    
    .OffCalibrWaitTicks = (uint16_t)((SYS_TICK_FREQUENCY * OFFCALIBRWAIT_MS2)/ 1000),                            
    .Ton                 = TON2,                              
    .Toff                = TOFF2                             
  },
  .PhaseAOffset = 0,   
  .PhaseBOffset = 0,  
  .PhaseCOffset = 0,   
  .Half_PWMPeriod = PWM_PERIOD_CYCLES2/2u,
  .pParams_str = &R3_2_ParamsM2,

};

			<#elseif CondFamily_STM32F3 &&  (MC.THREE_SHUNT_SHARED_RESOURCES2 || MC.THREE_SHUNT_INDEPENDENT_RESOURCES2)>
PWMC_R3_2_Handle_t PWM_Handle_M2 =
{
  {
    .pFctGetPhaseCurrents              = &R3_2_GetPhaseCurrents,    
    .pFctSwitchOffPwm                  = &R3_2_SwitchOffPWM,             
    .pFctSwitchOnPwm                   = &R3_2_SwitchOnPWM,              
    .pFctCurrReadingCalib              = &R3_2_CurrentReadingPolarization,
    .pFctTurnOnLowSides                = &R3_2_TurnOnLowSides,                  
    .pFctIsOverCurrentOccurred         = &R3_2_IsOverCurrentOccurred,    
    .pFctOCPSetReferenceVoltage        = MC_NULL,
    .pFctRLDetectionModeEnable         = MC_NULL,    
    .pFctRLDetectionModeDisable        = MC_NULL,   
    .pFctRLDetectionModeSetDuty        = MC_NULL,   
    .hT_Sqrt3 = (PWM_PERIOD_CYCLES2*SQRT3FACTOR)/16384u,   
    .Sector = 0,    
    .CntPhA = 0,
    .CntPhB = 0,
    .CntPhC = 0,
    .SWerror = 0,
    .TurnOnLowSidesAction = false, 
    .OffCalibrWaitTimeCounter = 0, 
    .Motor = M2,     
    .RLDetectionMode = false, 
    .Ia = 0, 
    .Ib = 0, 
    .Ic = 0, 
    .DTTest = 0,   
    .DTCompCnt = DTCOMPCNT2, 
    .PWMperiod          = PWM_PERIOD_CYCLES2,
    .OffCalibrWaitTicks = (uint16_t)((SYS_TICK_FREQUENCY * OFFCALIBRWAIT_MS2)/ 1000),
    .Ton                 = TON2,                              
    .Toff                = TOFF2
  },
  .PhaseAOffset = 0,   
  .PhaseBOffset = 0,   
  .PhaseCOffset = 0,   
  .Half_PWMPeriod = PWM_PERIOD_CYCLES2/2u, 
  .OverCurrentFlag = false,    
  .OverVoltageFlag = false,    
  .BrakeActionLock = false,                               
  .pParams_str = &R3_2_ParamsM2
};

			</#if>
		</#if><#-- MC.DRIVE_TYPE == "FOC" -->
		<#if MC.DRIVE_TYPE == "FOC" >
			<#if MC.DUALDRIVE == true>
				<#if  MC.HALL_SENSORS2 == true ||  MC.AUX_HALL_SENSORS2 == true >
/**
  * @brief  SpeedNPosition sensor parameters Motor 2 - HALL
  */
HALL_Handle_t HALL_M2 =
{
  ._Super = {
    .bElToMecRatio                     =	POLE_PAIR_NUM2,            
    .hMaxReliableMecSpeedUnit          =	(uint16_t)(1.15*MAX_APPLICATION_SPEED_UNIT2),
    .hMinReliableMecSpeedUnit          =	(uint16_t)(MIN_APPLICATION_SPEED_UNIT2),
    .bMaximumSpeedErrorsNumber         =	MEAS_ERRORS_BEFORE_FAULTS2,           
    .hMaxReliableMecAccelUnitP         =	65535,                             
    .hMeasurementFrequency             =	TF_REGULATION_RATE_SCALED2,
    .DPPConvFactor                     =  DPP_CONV_FACTOR2,       
  }, 
  .SensorPlacement     = HALL_SENSORS_PLACEMENT2,
  .PhaseShift          = (int16_t)(HALL_PHASE_SHIFT2 * 65536/360),
  .SpeedSamplingFreqHz = MEDIUM_FREQUENCY_TASK_RATE2,
  .SpeedBufferSize     = HALL_AVERAGING_FIFO_DEPTH2,  
 .TIMClockFreq       = HALL_TIM_CLK2,         
 .TIMx                = ${_last_word(MC.HALL_TIMER_SELECTION2)},
 
 .ICx_Filter          = M2_HALL_IC_FILTER,
 
 .PWMFreqScaling      = PWM_FREQ_SCALING2,
 .HallMtpa            = HALL_MTPA2, 

				<#if CondFamily_STM32F1==true>
 <#-- ToDo: GPIO_PIN <<8 due to GPIO LL and HAL definition misalignment on F1  -->
 
 .H1Port             =  M2_HALL_H1_GPIO_Port, 
 .H1Pin              =  M2_HALL_H1_Pin<<8,       
 .H2Port             =  M2_HALL_H2_GPIO_Port, 
 .H2Pin              =  M2_HALL_H2_Pin<<8,    
 .H3Port             =  M2_HALL_H3_GPIO_Port, 
 .H3Pin              =  M2_HALL_H3_Pin<<8,    												 
				<#else>
 .H1Port             =  M2_HALL_H1_GPIO_Port, 
 .H1Pin              =  M2_HALL_H1_Pin,       
 .H2Port             =  M2_HALL_H2_GPIO_Port, 
 .H2Pin              =  M2_HALL_H2_Pin,       
 .H3Port             =  M2_HALL_H3_GPIO_Port, 
 .H3Pin              =  M2_HALL_H3_Pin,       													 
				</#if>
};

			</#if>
		</#if>
		<#if  MC.HALL_SENSORS == true ||  MC.AUX_HALL_SENSORS == true >
/**
  * @brief  SpeedNPosition sensor parameters Motor 1 - HALL
  */


HALL_Handle_t HALL_M1 =
{
  ._Super = {
    .bElToMecRatio                     =	POLE_PAIR_NUM,               
    .hMaxReliableMecSpeedUnit          =	(uint16_t)(1.15*MAX_APPLICATION_SPEED_UNIT),
    .hMinReliableMecSpeedUnit          =	(uint16_t)(MIN_APPLICATION_SPEED_UNIT),
    .bMaximumSpeedErrorsNumber         =	MEAS_ERRORS_BEFORE_FAULTS,            
    .hMaxReliableMecAccelUnitP         =	65535,                             
    .hMeasurementFrequency             =	TF_REGULATION_RATE_SCALED,
    .DPPConvFactor                     =  DPP_CONV_FACTOR,       
  }, 
  .SensorPlacement     = HALL_SENSORS_PLACEMENT,
  .PhaseShift          = (int16_t)(HALL_PHASE_SHIFT * 65536/360),
  .SpeedSamplingFreqHz = MEDIUM_FREQUENCY_TASK_RATE,
  .SpeedBufferSize     = HALL_AVERAGING_FIFO_DEPTH, 
 .TIMClockFreq       = HALL_TIM_CLK,         
 .TIMx                = ${_last_word(MC.HALL_TIMER_SELECTION)}, 
 
 .ICx_Filter          = M1_HALL_IC_FILTER,
 
 .PWMFreqScaling      = PWM_FREQ_SCALING,
 .HallMtpa            = HALL_MTPA,  

			<#if CondFamily_STM32F1==true>
 <#-- ToDo: GPIO_PIN <<8 due to GPIO LL and HAL definition misalignment on F1  -->
 
 .H1Port             =  M1_HALL_H1_GPIO_Port, 
 .H1Pin              =  M1_HALL_H1_Pin<<8,    
 .H2Port             =  M1_HALL_H2_GPIO_Port, 
 .H2Pin              =  M1_HALL_H2_Pin<<8,    
 .H3Port             =  M1_HALL_H3_GPIO_Port, 
 .H3Pin              =  M1_HALL_H3_Pin<<8,    										 
			<#else>
 .H1Port             =  M1_HALL_H1_GPIO_Port, 
 .H1Pin              =  M1_HALL_H1_Pin,       
 .H2Port             =  M1_HALL_H2_GPIO_Port, 
 .H2Pin              =  M1_HALL_H2_Pin,       
 .H3Port             =  M1_HALL_H3_GPIO_Port, 
 .H3Pin              =  M1_HALL_H3_Pin,       									 
			</#if>
};

		</#if>  
	</#if><#-- MC.DRIVE_TYPE == "FOC" -->
	<#if MC.DRIVE_TYPE == "FOC" >
		<#if MC.INRUSH_CURRLIMIT_ENABLING == true>
ICL_Handle_t ICL_M1 =
{
  .ICLstate			=	ICL_INACTIVE,						
  .hICLTicksCounter	=	0u,    								
  .hICLTotalTicks	=	UINT16_MAX,							
  .hICLFrequencyHz 	=	SPEED_LOOP_FREQUENCY_HZ,			
  .hICLDurationms	=	INRUSH_CURRLIMIT_CHANGE_AFTER_MS,	
};

		</#if>
		<#if MC.INRUSH_CURRLIMIT_ENABLING2 == true && MC.DUALDRIVE == true>
ICL_Handle_t ICL_M2 =
{
  .ICLstate			=	ICL_INACTIVE,						
  .hICLTicksCounter	=	0u,    								
  .hICLTotalTicks	=	UINT16_MAX,							
  .hICLFrequencyHz 	=	SPEED_LOOP_FREQUENCY_HZ,			
  .hICLDurationms	=	INRUSH_CURRLIMIT_CHANGE_AFTER_MS2,	
};

		</#if>
	</#if><#-- MC.DRIVE_TYPE == "FOC" -->
	<#if MC.DRIVE_TYPE == "FOC" >
		<#if   (MC.TEMPERATURE_READING == true  && MC.OV_TEMPERATURE_PROT_ENABLING == true)> 
/**
  * temperature sensor parameters Motor 1
  */
NTC_Handle_t TempSensorParamsM1 =
{
  .bSensorType = REAL_SENSOR,
  .TempRegConv =
  {
    .regADC = ${MC.TEMP_FDBK_ADC},
    .channel = MC_${MC.TEMP_FDBK_CHANNEL},
    .samplingTime = M1_TEMP_SAMPLING_TIME,   
  },  
  .hLowPassFilterBW        = M1_TEMP_SW_FILTER_BW_FACTOR,
  .hOverTempThreshold      = (uint16_t)(OV_TEMPERATURE_THRESHOLD_d),
  .hOverTempDeactThreshold = (uint16_t)(OV_TEMPERATURE_THRESHOLD_d - OV_TEMPERATURE_HYSTERESIS_d),
  .hSensitivity            = (uint16_t)(ADC_REFERENCE_VOLTAGE/dV_dT),
  .wV0                     = (uint16_t)(V0_V *65536/ ADC_REFERENCE_VOLTAGE),
  .hT0                     = T0_C,											 
};

		<#else>
/**
  * Virtual temperature sensor parameters Motor 1
  */
NTC_Handle_t TempSensorParamsM1 =
{
  .bSensorType = VIRTUAL_SENSOR,
  .hExpectedTemp_d = 555, 
  .hExpectedTemp_C = M1_VIRTUAL_HEAT_SINK_TEMPERATURE_VALUE,
};

		</#if>
		<#if  MC.DUALDRIVE == true>
			<#if  (MC.TEMPERATURE_READING2 == true  && MC.OV_TEMPERATURE_PROT_ENABLING2 == true)>
/**
  * temperature sensor parameters Motor 2
  */
NTC_Handle_t TempSensorParamsM2 =
{
  .bSensorType = REAL_SENSOR,
  .TempRegConv =
  {
    .regADC = ${MC.TEMP_FDBK_ADC2},
    .channel = MC_${MC.TEMP_FDBK_CHANNEL2},
    .samplingTime = M2_TEMP_SAMPLING_TIME,   
  },
  .hLowPassFilterBW        = M2_TEMP_SW_FILTER_BW_FACTOR,
  .hOverTempThreshold      = (uint16_t)(OV_TEMPERATURE_THRESHOLD_d2),
  .hOverTempDeactThreshold = (uint16_t)(OV_TEMPERATURE_THRESHOLD_d2 - OV_TEMPERATURE_HYSTERESIS_d2),
  .hSensitivity            = (uint16_t)(ADC_REFERENCE_VOLTAGE/dV_dT2),
  .wV0                     = (uint16_t)(V0_V2 *65536/ ADC_REFERENCE_VOLTAGE),
  .hT0                     = T0_C2,
};

			<#else>
/**
  * Virtual temperature sensor parameters Motor 2
  */
NTC_Handle_t TempSensorParamsM2 =
{
  .bSensorType = VIRTUAL_SENSOR,
  .hExpectedTemp_d = 555,
  .hExpectedTemp_C = M2_VIRTUAL_HEAT_SINK_TEMPERATURE_VALUE,
};

			</#if>
		</#if>
	</#if><#-- MC.DRIVE_TYPE == "FOC" -->
	<#if MC.DRIVE_TYPE == "FOC" >
		<#if   MC.BUS_VOLTAGE_READING == true>
/* Bus voltage sensor value filter buffer */
uint16_t RealBusVoltageSensorFilterBufferM1[M1_VBUS_SW_FILTER_BW_FACTOR];

/**
  * Bus voltage sensor parameters Motor 1
  */
RDivider_Handle_t RealBusVoltageSensorParamsM1 =
{
  ._Super                =
  {
    .SensorType          = REAL_SENSOR,                 
    .ConversionFactor    = (uint16_t)(ADC_REFERENCE_VOLTAGE / VBUS_PARTITIONING_FACTOR),                                                   
  },
  
  .VbusRegConv =
  {
    .regADC = ${MC.VBUS_ADC},
    .channel = MC_${MC.VBUS_CHANNEL},
    .samplingTime = M1_VBUS_SAMPLING_TIME,   
  },
  .LowPassFilterBW       =  M1_VBUS_SW_FILTER_BW_FACTOR,  
  .OverVoltageThreshold  = OVERVOLTAGE_THRESHOLD_d,   
  .UnderVoltageThreshold =  UNDERVOLTAGE_THRESHOLD_d,  
  .aBuffer = RealBusVoltageSensorFilterBufferM1,
};

		<#else>
/**
  * Virtual bus voltage sensor parameters Motor 1
  */
VirtualBusVoltageSensor_Handle_t VirtualBusVoltageSensorParamsM1 =
{
  ._Super =
  {
    .SensorType       = VIRTUAL_SENSOR,                 
    .ConversionFactor = 500,                             
  },
  .ExpectedVbus_d = 1 + (NOMINAL_BUS_VOLTAGE_V * 65536) / 500,                                                      
};

		</#if>
		<#if   MC.DUALDRIVE == true>
			<#if   MC.BUS_VOLTAGE_READING2 == true>
/* Bus voltage sensor value filter buffer */
uint16_t RealBusVoltageSensorFilterBufferM2[M2_VBUS_SW_FILTER_BW_FACTOR];

/**
  * Bus voltage sensor parameters Motor 2
  */
RDivider_Handle_t RealBusVoltageSensorParamsM2 =
{
  ._Super                =
  {
    .SensorType          = REAL_SENSOR,                
    .ConversionFactor    = (uint16_t)(ADC_REFERENCE_VOLTAGE / VBUS_PARTITIONING_FACTOR2),                                                   
  },
  .VbusRegConv =
  {
    .regADC = ${MC.VBUS_ADC2},
    .channel = MC_${MC.VBUS_CHANNEL2},
    .samplingTime = M2_VBUS_SAMPLING_TIME,   
  },
  .LowPassFilterBW       =  M2_VBUS_SW_FILTER_BW_FACTOR,  
  .OverVoltageThreshold  = OVERVOLTAGE_THRESHOLD_d2,  
  .UnderVoltageThreshold =  UNDERVOLTAGE_THRESHOLD_d2,  
  .aBuffer = RealBusVoltageSensorFilterBufferM2,
   };

			<#else>
/**
  * Virtual bus voltage sensor parameters Motor 2
  */
VirtualBusVoltageSensor_Handle_t VirtualBusVoltageSensorParamsM2 =
{
  ._Super =
  {
    .SensorType       = VIRTUAL_SENSOR,                 
    .ConversionFactor = 500,                            
  },

  .ExpectedVbus_d = 1+(NOMINAL_BUS_VOLTAGE_V2 * 65536) / 500,
};

			</#if>
		</#if>
	</#if><#-- MC.DRIVE_TYPE == "FOC" -->
	<#if  (MC.DAC_FUNCTIONALITY == true) || (MC.SERIAL_COMMUNICATION == true && MC.SERIAL_COM_MODE == "COM_BIDIRECTIONAL") || (MC.SERIAL_COMMUNICATION == false && MC.DRIVE_TYPE == "SIX_STEP")>
UI_Handle_t UI_Params =
{
  .bDriveNum = 0,
		<#if  MC.DAC_FUNCTIONALITY == true>
			<#if  MC.DAC_EMULATED == true>
  .pFct_DACInit = &DACT_Init,
  .pFct_DACExec = &DACT_Exec,
			<#else>
  .pFct_DACInit = &DAC_Init,               
  .pFct_DACExec = &DAC_Exec,
			</#if>
  .pFctDACSetChannelConfig    = &DAC_SetChannelConfig,
  .pFctDACGetChannelConfig    = &DAC_GetChannelConfig,
  .pFctDACSetUserChannelValue = &DAC_SetUserChannelValue,
  .pFctDACGetUserChannelValue = &DAC_GetUserChannelValue,
 
		</#if>
		<#if (MC.SERIAL_COMMUNICATION == false && MC.DRIVE_TYPE == "SIX_STEP")>
			<#if CondFamily_STM32G4 || CondFamily_STM32F4>
  .pUART = &huart2,
			<#elseif CondFamily_STM32F0>
  .pUART = &huart1,
			<#else>
			#error "This UART is not defined for the selected board"
			</#if>
		</#if><#-- MC.SERIAL_COMMUNICATION == false && MC.DRIVE_TYPE == "SIX_STEP" -->
};

	</#if><#-- (MC.DAC_FUNCTIONALITY == true) || (MC.SERIAL_COMMUNICATION == true && MC.SERIAL_COM_MODE == "COM_BIDIRECTIONAL") || (MC.SERIAL_COMMUNICATION == false && MC.DRIVE_TYPE == "SIX_STEP") -->
	<#if  MC.DAC_FUNCTIONALITY == true>
<#-- <#if CondFamily_STM32F3> -->
DAC_UI_Handle_t DAC_UI_Params = 
{
  .hDAC_CH1_ENABLED = <#if MC.DEBUG_DAC_CH1>ENABLE<#else>DISABLE</#if>,  
  .hDAC_CH2_ENABLED = <#if MC.DEBUG_DAC_CH2>ENABLE<#else>DISABLE</#if>
};

<#-- </#if>  --> 
	</#if> 
	<#if MC.DRIVE_TYPE == "FOC" >
/** RAMP for Motor1.
  *
  */
RampExtMngr_Handle_t RampExtMngrHFParamsM1 =
{
  .FrequencyHz = TF_REGULATION_RATE 
};
	</#if><#-- MC.DRIVE_TYPE == "FOC" -->
	<#if MC.DRIVE_TYPE == "FOC" >

/**
  * @brief  CircleLimitation Component parameters Motor 1 - Base Component
  */
CircleLimitation_Handle_t CircleLimitationM1 =
{
  .MaxModule          = MAX_MODULE,
		<#if MC.FLUX_WEAKENING_ENABLING  == true>
  .MaxVd          	  = (uint16_t)(MAX_MODULE * FW_VOLTAGE_REF / 1000),
		<#else>
  .MaxVd          	  = (uint16_t)(MAX_MODULE * 950 / 1000),
		</#if>
  .Circle_limit_table = MMITABLE,        	
  .Start_index        = START_INDEX, 		
};
	</#if><#-- MC.DRIVE_TYPE == "FOC" -->
	<#if MC.DRIVE_TYPE == "FOC" >
		<#if  MC.DUALDRIVE == true>
/** RAMP for Motor2.
  *
  */
RampExtMngr_Handle_t RampExtMngrHFParamsM2 =
{
  .FrequencyHz = TF_REGULATION_RATE2 
};

/**
  * @brief  CircleLimitation Component parameters Motor 2 - Base Component
  */
CircleLimitation_Handle_t CircleLimitationM2 =
{
  .MaxModule          = MAX_MODULE2,     
		<#if MC.FLUX_WEAKENING_ENABLING2  == true>
  .MaxVd          	  = (uint16_t)(MAX_MODULE2 * FW_VOLTAGE_REF2 / 1000),
		<#else>
  .MaxVd          	  = (uint16_t)(MAX_MODULE2 * 950 / 1000),
		</#if>  
  .Circle_limit_table = MMITABLE2,       	
  .Start_index        = START_INDEX2,    	
};

	</#if>
</#if><#-- MC.DRIVE_TYPE == "FOC" -->
<#if MC.DRIVE_TYPE == "FOC" >
	<#if  MC.MTPA_ENABLING == true>
MTPA_Handle_t MTPARegM1 =
{
  .SegDiv   = (int16_t)SEGDIV,        
  .AngCoeff = ANGC,                   
  .Offset   = OFST,                   
};

	</#if> 
	<#if  MC.DUALDRIVE == true &&  MC.MTPA_ENABLING2 == true>
MTPA_Handle_t MTPARegM2 =
{
  .SegDiv   = (int16_t)SEGDIV2,        
  .AngCoeff = ANGC2,                   
  .Offset   = OFST2,                   
};

	</#if>
</#if><#-- MC.DRIVE_TYPE == "FOC" -->
<#if MC.DRIVE_TYPE == "FOC" >
	<#if  MC.DUALDRIVE == true>
		<#if  MC.ON_OVER_VOLTAGE2 == "TURN_ON_R_BRAKE">
DOUT_handle_t R_BrakeParamsM2 =
{
  .OutputState       = INACTIVE,                      
  .hDOutputPort      = M2_DISSIPATIVE_BRK_GPIO_Port,      
  .hDOutputPin       = M2_DISSIPATIVE_BRK_Pin,            
  .bDOutputPolarity  = ${MC.DISSIPATIVE_BRAKE_POLARITY2}  
};

		</#if>
		<#if MC.HW_OV_CURRENT_PROT_BYPASS2 == true && MC.ON_OVER_VOLTAGE2 == "TURN_ON_LOW_SIDES">
DOUT_handle_t DOUT_OCPDisablingParamsM2 =
{
  .OutputState       = INACTIVE,                    
  .hDOutputPort      = M2_OCP_DISABLE_GPIO_Port ,   
  .hDOutputPin       = M2_OCP_DISABLE_Pin,          
  .bDOutputPolarity  = ${MC.OVERCURR_PROTECTION_HW_DISABLING2}   
};

		</#if>
		<#if MC.INRUSH_CURRLIMIT_ENABLING2 == true>
DOUT_handle_t ICLDOUTParamsM2 =
{
  .OutputState       = INACTIVE,                     
  .hDOutputPort      = M2_ICL_SHUT_OUT_GPIO_Port,  
  .hDOutputPin       = M2_ICL_SHUT_OUT_Pin,    
  .bDOutputPolarity  = ${MC.INRUSH_CURR_LIMITER_POLARITY2}  
};

		</#if>
	</#if>
	<#if  MC.ON_OVER_VOLTAGE == "TURN_ON_R_BRAKE">
DOUT_handle_t R_BrakeParamsM1 =
{
  .OutputState       = INACTIVE,                
  .hDOutputPort      = M1_DISSIPATIVE_BRK_GPIO_Port, 
  .hDOutputPin       = M1_DISSIPATIVE_BRK_Pin,       
  .bDOutputPolarity  = ${MC.DISSIPATIVE_BRAKE_POLARITY} 
};

	</#if>
</#if><#-- MC.DRIVE_TYPE == "FOC" -->
<#if MC.DRIVE_TYPE == "FOC" >
	<#if MC.HW_OV_CURRENT_PROT_BYPASS == true && MC.ON_OVER_VOLTAGE == "TURN_ON_LOW_SIDES">
DOUT_handle_t DOUT_OCPDisablingParamsM1 =
{
  .OutputState       = INACTIVE,                  
  .hDOutputPort      = M1_OCP_DISABLE_GPIO_Port , 
  .hDOutputPin       = M1_OCP_DISABLE_Pin ,       
  .bDOutputPolarity  = ${MC.OVERCURR_PROTECTION_HW_DISABLING}    
};

	</#if>
</#if><#-- MC.DRIVE_TYPE == "FOC" -->
<#if MC.DRIVE_TYPE == "FOC" >
	<#if MC.INRUSH_CURRLIMIT_ENABLING == true>
DOUT_handle_t ICLDOUTParamsM1 =
{
  .OutputState       = INACTIVE,                   
  .hDOutputPort      = M1_ICL_SHUT_OUT_GPIO_Port,
  .hDOutputPin       = M1_ICL_SHUT_OUT_Pin,		
  .bDOutputPolarity  = ${MC.INRUSH_CURR_LIMITER_POLARITY}		
};
	</#if><#-- MC.INRUSH_CURRLIMIT_ENABLING == true -->
</#if><#-- DRIVE_TYPE == "FOC" -->
<#if MC.SERIAL_COMMUNICATION == true>
	<#if MC.SERIAL_COM_MODE == "COM_BIDIRECTIONAL">

UFCP_Handle_t pUSART =
{
  ._Super.RxTimeout = 0,
  .USARTx = ${_last_word(MC.USART_SELECTION)},
       
};
		<#if MC.DRIVE_TYPE == "FOC">
		<#elseif MC.SERIAL_COM_MODE == "COM_UNIDIRECTIONAL">

UDFastCom_Params_t UFCParams_str =
{
  .USARTx = ${_last_word(MC.USART_SELECTION)},
  .bDefChannel1 = ${MC.SERIAL_COM_CHANNEL1},
  .bDefChannel2 = ${MC.SERIAL_COM_CHANNEL2},
  .bDefMotor = ${MC.SERIAL_COM_MOTOR},
  .bCh1ByteNum = 1,
  .bCh2ByteNum = 1,
  .bChNum = 2
};
		</#if>
	</#if>
	<#if MC.PFC_ENABLED == true>
PFC_Handle_t PFC = 
{
	.pParams = & PFC_Params,
	.pMPW1   = (MotorPowMeas_Handle_t *) &PQD_MotorPowMeasM1,
	<#if  MC.DUALDRIVE == true>
	.pMPW2   = (MotorPowMeas_Handle_t *) &PQD_MotorPowMeasM2,
	<#else>
	.pMPW2   = MC_NULL,
	</#if>	 
	<#if MC.BUS_VOLTAGE_READING == true>
	.pVBS    = (BusVoltageSensor_Handle_t *) &RealBusVoltageSensorParamsM1,
	<#else>
	.pVBS    = (BusVoltageSensor_Handle_t *) &VirtualBusVoltageSensorParamsM1,
	</#if>
	.pBusVoltage = MC_NULL,
	.cPICurr = {
		.hDefKpGain           = (int16_t) PFC_PID_CURR_KP_DEFAULT,
		.hDefKiGain           = (int16_t) PFC_PID_CURR_KI_DEFAULT,
		.hKpGain              = (int16_t) PFC_PID_CURR_KP_DEFAULT,
		.hKiGain              = (int16_t) PFC_PID_CURR_KI_DEFAULT,
		.wIntegralTerm        = 0,
		.wUpperIntegralLimit  = (int32_t)INT16_MAX * PFC_PID_CURR_KI_DIV,
		.wLowerIntegralLimit  = (int32_t)(-INT16_MAX) * PFC_PID_CURR_KI_DIV,
		.hUpperOutputLimit    = INT16_MAX,
		.hLowerOutputLimit    = 0,
		.hKpDivisor           = (uint16_t) PFC_PID_CURR_KP_DIV,
		.hKiDivisor           = (uint16_t) PFC_PID_CURR_KI_DIV,
		.hKpDivisorPOW2       = (uint16_t)LOG2(PFC_PID_CURR_KP_DIV),
		.hKiDivisorPOW2       = (uint16_t)LOG2(PFC_PID_CURR_KI_DIV),
		.hDefKdGain           = 0,
		.hKdGain              = 0,
		.hKdDivisor           = 0,
		.hKdDivisorPOW2       = 0,
		.wPrevProcessVarError = 0
	},
	.cPIVolt = {
		.hDefKpGain           = (int16_t) PFC_PID_VOLT_KP_DEFAULT,
	    .hDefKiGain           = (int16_t) PFC_PID_VOLT_KI_DEFAULT,
	    .hKpGain              = (int16_t) PFC_PID_VOLT_KP_DEFAULT,
	    .hKiGain              = (int16_t) PFC_PID_VOLT_KI_DEFAULT,
	    .wIntegralTerm        = 0,
	    .wUpperIntegralLimit  = (int32_t) PFC_NOMINALCURRENTS16A * PFC_PID_VOLT_KI_DIV,
	    .wLowerIntegralLimit  = (int32_t) (-PFC_NOMINALCURRENTS16A) * PFC_PID_VOLT_KI_DIV,
	    .hUpperOutputLimit    = (int16_t) PFC_NOMINALCURRENTS16A,
	    .hLowerOutputLimit    = (int16_t) (-PFC_NOMINALCURRENTS16A),
	    .hKpDivisor           = (uint16_t) PFC_PID_VOLT_KP_DIV,
	    .hKiDivisor           = (uint16_t) PFC_PID_VOLT_KI_DIV,
	    .hKpDivisorPOW2       = (uint16_t) LOG2(PFC_PID_VOLT_KP_DIV),
	    .hKiDivisorPOW2       = (uint16_t) LOG2(PFC_PID_VOLT_KI_DIV),
	    .hDefKdGain           = 0,
	    .hKdGain              = 0,
	    .hKdDivisor           = 0,
	    .hKdDivisorPOW2       = 0,
	    .wPrevProcessVarError = 0
	},
	.bPFCen                   = false,
	.hTargetVoltageReference  = PFC_VOLTAGEREFERENCE,
	.hVoltageReference        = PFC_VOLTAGEREFERENCE,
	.hStartUpDuration         = (int16_t) ((PFC_STARTUPDURATION*0.001)*(PFC_VOLTCTRLFREQUENCY*1.0)),
	.hMainsSync               = 0,
	.hMainsPeriod             = 0,
	.bMainsPk                 = false,
};

</#if>
	<#if MC.MOTOR_PROFILER == true>
RampExtMngr_Handle_t RampExtMngrParamsSCC =
{
  .FrequencyHz = TF_REGULATION_RATE 
};

SCC_Handle_t SCC = 
{
 
  .pSCC_Params_str = &SCC_Params
};

RampExtMngr_Handle_t RampExtMngrParamsOTT =
{
  .FrequencyHz = MEDIUM_FREQUENCY_TASK_RATE 
};

OTT_Handle_t OTT = 
{
 
  .pOTT_Params_str = &OTT_Params
};

	</#if>
</#if><#-- DRIVE_TYPE == "FOC" -->
<#if MC.USE_STGAP1S >
GAP_Handle_t STGAP_M1 =
{
  .DeviceNum = M1_STAGAP1AS_NUM,
  .DeviceParams = { STGAP1AS_BRAKE,
                    STGAP1AS_UH,
                    STGAP1AS_UL, 
                    STGAP1AS_VH, 
                    STGAP1AS_VL, 
                    STGAP1AS_WH, 
                    STGAP1AS_WL, 
                   },
   .SPIx = SPI2,                   
   .NCSPort = M1_STGAP1S_SPI_NCS_GPIO_Port,
   .NCSPin  = M1_STGAP1S_SPI_NCS_Pin,
   .NSDPort = M1_STGAP1S_SPI_NSD_GPIO_Port,
   .NSDPin  = M1_STGAP1S_SPI_NSD_Pin,
};

</#if>

/* USER CODE BEGIN Additional configuration */


/* USER CODE END Additional configuration */ 

/******************* (C) COPYRIGHT 2019 STMicroelectronics *****END OF FILE****/

