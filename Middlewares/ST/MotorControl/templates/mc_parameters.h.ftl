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

<#-- Condition for STM32F302x8x MCU -->
<#assign CondMcu_STM32F302x8x = (McuName?? && McuName?matches("STM32F302.8.*"))>
<#-- Condition for STM32F072xxx MCU -->
<#assign CondMcu_STM32F072xxx = (McuName?? && McuName?matches("STM32F072.*"))>
<#-- Condition for STM32F446xCx or STM32F446xEx -->
<#assign CondMcu_STM32F446xCEx = (McuName?? && McuName?matches("STM32F446.(C|E).*"))>
<#-- Condition for Line STM32F1xx Value -->
<#assign CondLine_STM32F1_Value = (McuName?? && (McuName?matches("STM32F100.(4|6|8|B).*"))) >
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
<#assign CondFamily_STM32G0 = (FamilyName?? && FamilyName == "STM32G0") >

/**
  ******************************************************************************
  * @file    mc_parameters.h
  * @author  Motor Control SDK Team, ST Microelectronics
  * @brief   This file provides declarations of HW parameters specific to the 
  *          configuration of the subsystem.
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
#ifndef MC_PARAMETERS_H
#define MC_PARAMETERS_H

<#if CondFamily_STM32F4  > 
  <#if MC.THREE_SHUNT == true>
#include "r3_1_f4xx_pwm_curr_fdbk.h"
  </#if>
  <#if MC.THREE_SHUNT_INDEPENDENT_RESOURCES == true || MC.THREE_SHUNT_INDEPENDENT_RESOURCES2 == true >
#include "r3_2_f4xx_pwm_curr_fdbk.h"
  </#if>
  <#if MC.SINGLE_SHUNT2 == true || MC.SINGLE_SHUNT == true >
#include "r1_f4xx_pwm_curr_fdbk.h"
  </#if>
  <#if MC.ICS_SENSORS == true || MC.ICS_SENSORS2 == true >
#include "ics_f4xx_pwm_curr_fdbk.h"  
  </#if>
</#if>
<#if CondFamily_STM32F0 > 
  <#if MC.THREE_SHUNT == true >
#include "r3_f0xx_pwm_curr_fdbk.h"
  </#if>
  <#if MC.SINGLE_SHUNT == true >
#include "r1_f0xx_pwm_curr_fdbk.h"
  </#if>
</#if>
<#if CondFamily_STM32L4 > <#-- CondFamily_STM32L4 --->
  <#if MC.SINGLE_SHUNT >
#include "r1_l4xx_pwm_curr_fdbk.h"
  </#if>
  <#if MC.ICS_SENSORS >
#include "ics_l4xx_pwm_curr_fdbk.h"
  </#if>
  <#if  MC.THREE_SHUNT_INDEPENDENT_RESOURCES >
#include "r3_2_l4xx_pwm_curr_fdbk.h"
  </#if>
  <#if  MC.THREE_SHUNT  >
#include "r3_1_l4xx_pwm_curr_fdbk.h"
  </#if>
</#if> <#-- CondFamily_STM32L4 --->
<#if CondFamily_STM32F7 > <#-- CondFamily_STM32F7 --->
  <#if MC.SINGLE_SHUNT >
#include "r1_f7xx_pwm_curr_fdbk.h"
  </#if>
  <#if MC.ICS_SENSORS >
#include "ics_f7xx_pwm_curr_fdbk.h"
  </#if>
  <#if  MC.THREE_SHUNT_INDEPENDENT_RESOURCES >
#include "r3_2_f7xx_pwm_curr_fdbk.h"
  </#if>
  <#if  MC.THREE_SHUNT  >
#include "r3_1_f7xx_pwm_curr_fdbk.h"
  </#if>
</#if> <#-- CondFamily_STM32F7 --->
<#if CondFamily_STM32H7 > <#-- CondFamily_STM32H7 --->
  <#if MC.SINGLE_SHUNT >
#include "r1_h7xx_pwm_curr_fdbk.h"
  </#if>
  <#if MC.ICS_SENSORS >
#include "ics_h7xx_pwm_curr_fdbk.h"
  </#if>
  <#if  MC.THREE_SHUNT_INDEPENDENT_RESOURCES >
#include "r3_2_h7xx_pwm_curr_fdbk.h"
  </#if>
  <#if  MC.THREE_SHUNT  >
#include "r3_1_h7xx_pwm_curr_fdbk.h"
  </#if>
</#if> <#-- CondFamily_STM32F7 --->
<#if CondFamily_STM32F3 > <#-- CondFamily_STM32F3 --->
  <#if MC.SINGLE_SHUNT || MC.SINGLE_SHUNT2 >
#include "r1_f30x_pwm_curr_fdbk.h"
  </#if>
  <#if MC.ICS_SENSORS ||  MC.ICS_SENSORS2>
#include "ics_f30x_pwm_curr_fdbk.h"
  </#if>
  <#if  MC.THREE_SHUNT_INDEPENDENT_RESOURCES || MC.THREE_SHUNT_INDEPENDENT_RESOURCES2 ||
        MC.THREE_SHUNT_SHARED_RESOURCES  || MC.THREE_SHUNT_SHARED_RESOURCES2>
#include "r3_2_f30x_pwm_curr_fdbk.h"
  </#if>
  <#if  MC.THREE_SHUNT  >
#include "r3_1_f30x_pwm_curr_fdbk.h"
  </#if>
</#if> <#-- CondFamily_STM32F3 --->
<#if CondFamily_STM32F1 == true && MC.THREE_SHUNT == true > <#-- CondFamily_STM32F1 -->
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
</#if> <#-- CondFamily_STM32F1 --->
<#if CondFamily_STM32G4 > <#-- CondFamily_STM32G4 --->
 <#if MC.SINGLE_SHUNT || MC.SINGLE_SHUNT2 >
#include "r1_g4xx_pwm_curr_fdbk.h"
  </#if>
  <#if  MC.THREE_SHUNT_INDEPENDENT_RESOURCES || MC.THREE_SHUNT_INDEPENDENT_RESOURCES2 >
#include "r3_2_g4xx_pwm_curr_fdbk.h"
  </#if>
  <#if  MC.ICS_SENSORS || MC.ICS_SENSORS2  >
#include "ics_g4xx_pwm_curr_fdbk.h"
  </#if>  
</#if> <#-- CondFamily_STM32G4 --->
<#if MC.MOTOR_PROFILER == true>
#include "mp_self_com_ctrl.h"
#include "mp_one_touch_tuning.h"
</#if> 
<#if CondFamily_STM32G0 >
  <#if MC.THREE_SHUNT == true >
#include "r3_g0xx_pwm_curr_fdbk.h"
  <#elseif  MC.SINGLE_SHUNT == true >
#include "r1_g0xx_pwm_curr_fdbk.h"
  </#if>   
</#if> <#-- CondFamily_STM32G0 --->
/* USER CODE BEGIN Additional include */

/* USER CODE END Additional include */  
<#if CondFamily_STM32F4 >
  <#if MC.THREE_SHUNT == true>
extern R3_1_Params_t R3_1_ParamsM1;
  </#if>
  <#if MC.THREE_SHUNT_INDEPENDENT_RESOURCES == true>
extern const R3_2_Params_t R3_2_ParamsM1;
  </#if>
  <#if MC.THREE_SHUNT_INDEPENDENT_RESOURCES2 == true >
extern const R3_2_Params_t R3_2_ParamsM2;
  </#if>
  <#if MC.SINGLE_SHUNT == true>
extern const R1_F4_Params_t R1_F4_ParamsM1;
  </#if>  
  <#if MC.SINGLE_SHUNT2 == true >
extern const R1_F4_Params_t R1_F4_ParamsM2;
  </#if>
<#if MC.ICS_SENSORS == true>
extern const ICS_Params_t ICS_ParamsM1;
</#if>
<#if MC.ICS_SENSORS2 == true>
extern const ICS_Params_t ICS_ParamsM2;
</#if>  
</#if> <#-- CondFamily_STM32F4 --->
<#if CondFamily_STM32F0 >
  <#if MC.THREE_SHUNT == true>
extern const R3_1_Params_t R3_1_Params;
  </#if>
  <#if MC.SINGLE_SHUNT == true>
extern const R1_F0XX_Params_t R1_F0XX_Params;
  </#if>  
</#if> <#-- CondFamily_STM32F0 --->
<#if CondFamily_STM32F3 > <#-- CondFamily_STM32F3 --->
  <#if MC.SINGLE_SHUNT >
extern const R1_F30XParams_t R1_F30XParamsM1;
  <#elseif MC.ICS_SENSORS >
extern const ICS_Params_t ICS_ParamsM1;
  <#elseif  MC.THREE_SHUNT_INDEPENDENT_RESOURCES ||  MC.THREE_SHUNT_SHARED_RESOURCES>
     <#if MC.USE_INTERNAL_OPAMP>
extern const R3_2_OPAMPParams_t R3_2_OPAMPParamsM1;
     </#if>
extern const R3_2_Params_t R3_2_ParamsM1;
  <#elseif  MC.THREE_SHUNT>
extern const R3_1_Params_t R3_1_ParamsM1;
  </#if>
  <#if MC.SINGLE_SHUNT2 == true> 
extern const R1_F30XParams_t R1_F30XParamsM2;
  <#elseif MC.ICS_SENSORS2> 
extern const ICS_Params_t ICS_ParamsM2;
  <#elseif MC.THREE_SHUNT_INDEPENDENT_RESOURCES2 || MC.THREE_SHUNT_SHARED_RESOURCES2 >
     <#if MC.USE_INTERNAL_OPAMP2>
extern const R3_2_OPAMPParams_t R3_2_OPAMPParamsM2;
     </#if>
extern const R3_2_Params_t R3_2_ParamsM2;
  <#elseif MC.THREE_SHUNT2> 
  <#-- provision for future 
const extern R3_1_F30XParams_t R3_1_F30XParamsM2;
  -->
  </#if>
</#if> <#-- CondFamily_STM32F3 --->
<#if CondFamily_STM32L4 > <#-- CondFamily_STM32L4 --->
  <#if MC.SINGLE_SHUNT >
extern R1_L4XXParams_t R1_L4XXParamsM1;
  <#elseif MC.ICS_SENSORS >
extern ICS_Params_t ICS_ParamsM1;
  <#elseif  MC.THREE_SHUNT>
extern R3_1_Params_t R3_1_ParamsM1;
  <#elseif  MC.THREE_SHUNT_INDEPENDENT_RESOURCES>
extern R3_2_Params_t R3_2_ParamsM1;
  </#if>
</#if> <#-- CondFamily_STM32L4 --->
<#if CondFamily_STM32F7 > <#-- CondFamily_STM32F7 --->
  <#if MC.SINGLE_SHUNT >
extern R1_F7_Params_t R1_F7_ParamsM1;
  <#elseif MC.ICS_SENSORS >
extern ICS_Params_t ICS_ParamsM1;
  <#elseif  MC.THREE_SHUNT>
extern R3_1_Params_t R3_1_ParamsM1;
  <#elseif  MC.THREE_SHUNT_INDEPENDENT_RESOURCES>
extern R3_2_Params_t R3_2_ParamsM1;
  </#if>
</#if> <#-- CondFamily_STM32F7 --->
<#if CondFamily_STM32H7 > <#-- CondFamily_STM32H7 --->
  <#if MC.SINGLE_SHUNT >
extern R1_Params_t R1_ParamsM1;
  <#elseif MC.ICS_SENSORS >
extern ICS_Params_t ICS_ParamsM1;
  <#elseif  MC.THREE_SHUNT>
extern R3_1_Params_t R3_1_ParamsM1;
  <#elseif  MC.THREE_SHUNT_INDEPENDENT_RESOURCES>
extern R3_2_Params_t R3_2_ParamsM1;
  </#if>
</#if> <#-- CondFamily_STM32H7 --->
<#if CondFamily_STM32G4 > <#-- CondFamily_STM32G4 --->
  <#if MC.SINGLE_SHUNT  >
extern R1_Params_t R1_ParamsM1; 
  <#elseif  MC.THREE_SHUNT_INDEPENDENT_RESOURCES  >
extern R3_2_Params_t R3_2_ParamsM1; 
<#elseif  MC.ICS_SENSORS  >
extern ICS_Params_t ICS_ParamsM1;
  </#if>
  <#if MC.SINGLE_SHUNT2  >
extern R1_Params_t R1_ParamsM2; 
  <#elseif  MC.THREE_SHUNT_INDEPENDENT_RESOURCES2  >
extern R3_2_Params_t R3_2_ParamsM2; 
  <#elseif  MC.ICS_SENSORS2  >
extern ICS_Params_t ICS_ParamsM2;
</#if>      
</#if> <#-- CondFamily_STM32G4 --->
<#if CondFamily_STM32G0 > <#-- CondFamily_STM32G0 --->
  <#if MC.SINGLE_SHUNT  >
extern const R1_G0XXParams_t R1_G0XX_Params;
  <#elseif  MC.THREE_SHUNT  >
extern const R3_1_Params_t R3_1_Params; 
  </#if>
</#if> <#-- CondFamily_STM32G4 --->
<#if MC.PFC_ENABLED == true>
#include "pfc.h"
</#if>
<#if CondFamily_STM32F1>
<#if MC.THREE_SHUNT == true >
extern const R3_2_Params_t R3_2_ParamsM1;
</#if> <#-- MC.THREE_SHUNT -->
<#if CondLine_STM32F1_HD >
  <#if MC.SINGLE_SHUNT == true>
const extern R1_DDParams_t R1_DDParamsM1;
  </#if>
  <#if MC.ICS_SENSORS == true>
extern const ICS_Params_t ICS_ParamsM1;
  </#if>
  <#if MC.ICS_SENSORS2 == true>
extern const ICS_Params_t ICS_ParamsM2;
  </#if>
</#if> <#-- CondLine_STM32F1_HD --->
<#if CondLine_STM32F1_Performance >
  <#if  MC.SINGLE_SHUNT == true >
extern const R1_VL1Params_t R1_VL1ParamsSD;
  </#if>   
  <#if MC.ICS_SENSORS == true>
extern const ICS_Params_t ICS_ParamsM1;
  </#if>  
</#if> <#-- CondLine_STM32F1_Performance --->
</#if> <#-- CondFamily_STM32F1 -->
<#if MC.PFC_ENABLED == true >
extern const PFC_Parameters_t PFC_Params;
</#if> 
<#if MC.MOTOR_PROFILER == true>
extern SCC_Params_t SCC_Params;
extern OTT_Params_t OTT_Params;
</#if> 
/* USER CODE BEGIN Additional extern */

/* USER CODE END Additional extern */  

#endif /* MC_PARAMETERS_H */
/******************* (C) COPYRIGHT 2019 STMicroelectronics *****END OF FILE****/
