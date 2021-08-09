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
  * @file    pfc_parameters.h
  * @author  Motor Control SDK Team, ST Microelectronics
  * @brief   This file contains the parameters needed for the Motor Control SDK
  *          in order to configure the Power Factor Correction feature.
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

/* Define to prevent recursive inclusion -------------------------------------*/
#ifndef __PFC_PARAMETERS_H
#define __PFC_PARAMETERS_H

/* Exported constants --------------------------------------------------------*/

/* USER CODE BEGIN HC_Params */
/* USER CODE END HC_Params */

<#-- TODO: Rename TIM_CLK into PFC_TIM_CLK (Impacts STMCWB) -->
#define TIM_CLK SYSCLK_FREQ
 
#define PFC_SWOVERCURRENTTH	   20000    /*!< Software OverCurrent threshold, expressed in s16A */
#define PFC_NOMINALCURRENTS16A 30000
#define PFC_MAINSFREQHYS 50.0

#define PFC_FAULTPOLARITY     ${MC.FAULTPOLARITY}
#define PFC_FAULTPORT         ${MC.FAULTPORT}
#define PFC_FAULTPIN          ${MC.FAULTPIN}

/*  PFC PWM frequency, in Hertz  */
#define PFC_PWMFREQ           ${MC.PWMFREQ}

#define PFC_CURRCTRLFREQUENCY ${MC.CURRCTRLFREQUENCY}
#define PFC_VOLTCTRLFREQUENCY ${MC.VOLTCTRLFREQUENCY}

#define PFC_MAINSFREQ ${MC.MAINSFREQ}
#define PFC_MAINSFREQHITHR ((PFC_MAINSFREQ) + PFC_MAINSFREQHYS)
#define PFC_MAINSFREQLOWTHR ((PFC_MAINSFREQ) - PFC_MAINSFREQHYS)

#define PFC_OUTPUTPOWERACTIVATION   ${MC.OUTPUTPOWERACTIVATION}
#define PFC_OUTPUTPOWERDEACTIVATION ${MC.OUTPUTPOWERDEACTIVATION}

#define ADV_TIM_CLK_Hz SYSCLK_FREQ

#define PFC_SWOVERVOLTAGETH ${MC.SWOVERVOLTAGETH}

#define PFC_TIMCK_NS ((1.0/ADV_TIM_CLK_Hz)*1000000000.0) /*!< duration of TIM clock period, ns*/
#define PFC_PROPDELAYON  ${MC.PROPDELAYON}
#define PFC_PROPDELAYOFF ${MC.PROPDELAYOFF}

#define PFC_ISAMPLINGTIMEREAL ${MC.ISAMPLINGTIMEREAL}

#define PFC_VMAINS_PARTITIONING_FACTOR ${MC.VMAINS_PARTITIONING_FACTOR}
#define PFC_SHUNTRESISTOR ${MC.PFCSHUNTRESISTOR}
#define PFC_AMPLGAIN ${MC.PFCAMPLGAIN}

/* Gains values for current and voltage control loops */
#define PFC_PID_CURR_KP_DEFAULT ${MC.PID_CURR_KP_DEFAULT}      
#define PFC_PID_CURR_KI_DEFAULT ${MC.PID_CURR_KI_DEFAULT}
#define PFC_PID_CURR_KD_DEFAULT 1 /* the derivative term is unused in the current implementation */
#define PFC_PID_VOLT_KP_DEFAULT ${MC.PID_VOLT_KP_DEFAULT}
#define PFC_PID_VOLT_KI_DEFAULT ${MC.PID_VOLT_KI_DEFAULT}
#define PFC_PID_VOLT_KD_DEFAULT 1 /* the derivative term is unused in the current implementation */

/* Current/Voltage control loop gains dividers*/
#define PFC_PID_CURR_KP_DIV ${MC.CURR_KPDIV}
#define PFC_PID_CURR_KI_DIV ${MC.CURR_KIDIV}
#define PFC_PID_CURR_KD_DIV 16384 /* the derivative term is unused in the current implementation */
#define PFC_PID_VOLT_KP_DIV ${MC.VOLT_KPDIV}
#define PFC_PID_VOLT_KI_DIV ${MC.VOLT_KIDIV}
#define PFC_PID_VOLT_KD_DIV 16384 /* the derivative term is unused in the current implementation */

#define PFC_VOLTAGEREFERENCE ${MC.VOLTAGEREFERENCE}
#define PFC_STARTUPDURATION ${MC.STARTUPDURATION}

#endif /* __PFC_PARAMETERS_H */
