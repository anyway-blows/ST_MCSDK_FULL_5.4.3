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
  * @file    power_stage_parameters.h
  * @author  Motor Control SDK Team, ST Microelectronics
  * @brief   This file contains the parameters needed for the Motor Control SDK
  *          in order to configure a power stage.
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
#ifndef __POWER_STAGE_PARAMETERS_H
#define __POWER_STAGE_PARAMETERS_H
<#if MC.USE_STGAP1S>  
#include "gap_gate_driver_ctrl.h"
</#if>

<#if MC.DUALDRIVE == true>
/**************************
 *** Motor 1 Parameters ***
 **************************/
<#else>
/************************
 *** Motor Parameters ***
 ************************/
</#if>


/************* PWM Driving signals section **************/

#define HW_DEAD_TIME_NS               ${MC.HW_DEAD_TIME_NS} /*!< Dead-time inserted 
                                                         by HW if low side signals 
                                                         are not used */
														 
/*********** Bus voltage sensing section ****************/
#define VBUS_PARTITIONING_FACTOR      ${MC.VBUS_PARTITIONING_FACTOR} /*!< It expresses how 
                                                       much the Vbus is attenuated  
                                                       before being converted into 
                                                       digital value */
#define NOMINAL_BUS_VOLTAGE_V         ${MC.NOMINAL_BUS_VOLTAGE_V} 
/******** Current reading parameters section ******/
/*** Topology ***/
#define ${MC.CURRENT_READING_TOPOLOGY}

#define RSHUNT                        ${MC.RSHUNT} 

/*  ICSs gains in case of isolated current sensors,
        amplification gain for shunts based sensing */
<#-- abs is not present in our FTL version -->
#define AMPLIFICATION_GAIN            ${MC.AMPLIFICATION_GAIN?replace("-","")} 

/*** Noise parameters ***/
#define TNOISE_NS                     ${MC.TNOISE_NS}
<#-- Keep this one for now. Used in parameters_conversion_f*_h.htl --> 
#define TRISE_NS                      ${MC.TRISE_NS} 
<#if (MC.TNOISE_NS?number > MC.TRISE_NS?number)>
#define MAX_TNTR_NS TNOISE_NS
<#else>
#define MAX_TNTR_NS TRISE_NS
</#if>
   
/************ Temperature sensing section ***************/
/* V[V]=V0+dV/dT[V/Celsius]*(T-T0)[Celsius]*/
#define V0_V                          ${MC.V0_V} /*!< in Volts */
#define T0_C                          ${MC.T0_C} /*!< in Celsius degrees */
#define dV_dT                         ${MC.dV_dT} /*!< V/Celsius degrees */
#define T_MAX                         ${MC.T_MAX} /*!< Sensor measured 
                                                       temperature at maximum 
                                                       power stage working 
                                                       temperature, Celsius degrees */
<#if MC.USE_STGAP1S>                                                       
/************ STGAP1AS section ***************/
/* These configuration value will come from the Workbench in the future */
#define M1_STAGAP1AS_NUM 7
#define GAP_CFG1   GAP_CFG1_SD_FLAG | GAP_CFG1_DIAG_EN   |GAP_CFG1_DT_DISABLE
#define GAP_CFG2   GAP_CFG2_DESATTH_3V | GAP_CFG2_DESATCURR_500UA
#define GAP_CFG3   GAP_CFG3_2LTOTH_7_0V | GAP_CFG3_2LTOTIME_3_00_US
#define GAP_CFG4   GAP_CFG4_UVLOTH_VH_DISABLE | GAP_CFG4_UVLOTH_VL_DISABLE
#define GAP_CFG5   GAP_CFG5_CLAMP_EN | GAP_CFG5_SENSE_EN | GAP_CFG5_DESAT_EN | GAP_CFG5_2LTO_ON_FAULT
#define GAP_DIAG1  GAP_DIAG_SPI_REGERR | GAP_DIAG_DESAT_SENSE //|GAP_DIAG_UVLOD_OVLOD | GAP_DIAG_OVLOH_OVLOL | 
#define GAP_DIAG2  GAP_DIAG_NONE

/* By default all STGAP1AS in the daisy chain are configured identicaly */ 

#define STGAP1AS_BRAKE {GAP_CFG1, GAP_CFG2, GAP_CFG3, GAP_CFG4, GAP_CFG5, GAP_DIAG1, GAP_DIAG2 }
#define STGAP1AS_UH {GAP_CFG1, GAP_CFG2, GAP_CFG3, GAP_CFG4, GAP_CFG5, GAP_DIAG1, GAP_DIAG2 }
#define STGAP1AS_UL {GAP_CFG1, GAP_CFG2, GAP_CFG3, GAP_CFG4, GAP_CFG5, GAP_DIAG1, GAP_DIAG2 }
#define STGAP1AS_VH {GAP_CFG1, GAP_CFG2, GAP_CFG3, GAP_CFG4, GAP_CFG5, GAP_DIAG1, GAP_DIAG2 }
#define STGAP1AS_VL {GAP_CFG1, GAP_CFG2, GAP_CFG3, GAP_CFG4, GAP_CFG5, GAP_DIAG1, GAP_DIAG2 }
#define STGAP1AS_WH {GAP_CFG1, GAP_CFG2, GAP_CFG3, GAP_CFG4, GAP_CFG5, GAP_DIAG1, GAP_DIAG2 }
#define STGAP1AS_WL {GAP_CFG1, GAP_CFG2, GAP_CFG3, GAP_CFG4, GAP_CFG5, GAP_DIAG1, GAP_DIAG2 }
</#if>                                                       
                                                       
<#if MC.DUALDRIVE == true>
/**************************
 *** Motor 2 Parameters ***
 **************************/

#define HW_DEAD_TIME_NS2               ${MC.HW_DEAD_TIME_NS2} /*!< Dead-time inserted 
                                                         by HW if low side signals 
                                                         are not used */

/*********** Bus voltage sensing section ****************/
#define VBUS_PARTITIONING_FACTOR2      ${MC.VBUS_PARTITIONING_FACTOR2} /*!< It expresses how 
                                                       much the Vbus is attenuated  
                                                       before being converted into 
                                                       digital value */
#define NOMINAL_BUS_VOLTAGE_V2         ${MC.NOMINAL_BUS_VOLTAGE_V2} 
/******** Current reading parameters section ******/
/*** Topology ***/
#define ${MC.CURRENT_READING_TOPOLOGY2}

#define RSHUNT2                        ${MC.RSHUNT2} 

/*  ICSs gains in case of isolated current sensors,
        amplification gain for shunts based sensing */
#define AMPLIFICATION_GAIN2            ${MC.AMPLIFICATION_GAIN2?replace("-","")} 

/*** Noise parameters ***/
#define TNOISE_NS2                     ${MC.TNOISE_NS2}
<#-- Keep this one for now. Used in parameters_conversion_f*_h.htl --> 
#define TRISE_NS2                      ${MC.TRISE_NS2} 
<#if (MC.TNOISE_NS2?number > MC.TRISE_NS2?number)>
#define MAX_TNTR_NS2 TNOISE_NS2
<#else>
#define MAX_TNTR_NS2 TRISE_NS2
</#if>
   
/************ Temperature sensing section ***************/
/* V[V]=V0+dV/dT[V/Celsius]*(T-T0)[Celsius]*/
#define V0_V2                          ${MC.V0_V2} /*!< in Volts */
#define T0_C2                          ${MC.T0_C2} /*!< in Celsius degrees */
#define dV_dT2                         ${MC.dV_dT2} /*!< V/Celsius degrees */
#define T_MAX2                         ${MC.T_MAX2} /*!< Sensor measured 
                                                       temperature at maximum 
                                                       power stage working 
                                                       temperature, Celsius degrees */
</#if>

#endif /*__POWER_STAGE_PARAMETERS_H*/
/******************* (C) COPYRIGHT 2019 STMicroelectronics *****END OF FILE****/
