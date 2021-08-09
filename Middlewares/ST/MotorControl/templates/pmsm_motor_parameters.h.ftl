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
  * @file    pmsm_motor_parameters.h
  * @author  Motor Control SDK Team, ST Microelectronics
  * @brief   This file contains the parameters needed for the Motor Control SDK
  *          in order to configure the motor to drive.
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
#ifndef __PMSM_MOTOR_PARAMETERS_H
#define __PMSM_MOTOR_PARAMETERS_H

<#if MC.DUALDRIVE == true>
/**************************
 *** Motor 1 Parameters ***
 **************************/
<#else>
/************************
 *** Motor Parameters ***
 ************************/
</#if>

/***************** MOTOR ELECTRICAL PARAMETERS  ******************************/
#define POLE_PAIR_NUM          ${MC.POLE_PAIR_NUM} /* Number of motor pole pairs */
#define RS                     ${MC.RS} /* Stator resistance , ohm*/
#define LS                     ${MC.LS} /* Stator inductance, H
                                                 For I-PMSM it is equal to Lq */

/* When using Id = 0, NOMINAL_CURRENT is utilized to saturate the output of the
   PID for speed regulation (i.e. reference torque).
   Transformation of real currents (A) into int16_t format must be done accordingly with
   formula:
   Phase current (int16_t 0-to-peak) = (Phase current (A 0-to-peak)* 32767 * Rshunt *
                                   *Amplifying network gain)/(MCU supply voltage/2)
*/

#define NOMINAL_CURRENT         ${MC.NOMINAL_CURRENT}
#define MOTOR_MAX_SPEED_RPM     ${MC.MOTOR_MAX_SPEED_RPM} /*!< Maximum rated speed  */
#define MOTOR_VOLTAGE_CONSTANT  ${MC.MOTOR_VOLTAGE_CONSTANT} /*!< Volts RMS ph-ph /kRPM */
#define ID_DEMAG                ${MC.ID_DEMAG} /*!< Demagnetization current */

/***************** MOTOR SENSORS PARAMETERS  ******************************/
/* Motor sensors parameters are always generated but really meaningful only
   if the corresponding sensor is actually present in the motor         */

/*** Hall sensors ***/
#define HALL_SENSORS_PLACEMENT  ${MC.HALL_SENSORS_PLACEMENT} /*!<Define here the
                                                 mechanical position of the sensors
                                                 withreference to an electrical cycle.
                                                 It can be either DEGREES_120 or
                                                 DEGREES_60 */

#define HALL_PHASE_SHIFT        ${MC.HALL_PHASE_SHIFT} /*!< Define here in degrees
                                                 the electrical phase shift between
                                                 the low to high transition of
                                                 signal H1 and the maximum of
                                                 the Bemf induced on phase A */
/*** Quadrature encoder ***/
#define M1_ENCODER_PPR             ${MC.ENCODER_PPR}  /*!< Number of pulses per
                                            revolution */

<#if MC.DUALDRIVE == true>
/***************** MOTOR ELECTRICAL PARAMETERS  ******************************/
#define POLE_PAIR_NUM2          ${MC.POLE_PAIR_NUM2} /* Number of motor pole pairs */
#define RS2                     ${MC.RS2} /* Stator resistance , ohm*/
#define LS2                     ${MC.LS2} /* Stator inductance, H
                                                 For I-PMSM it is equal to Lq */

/* When using Id = 0, NOMINAL_CURRENT is utilized to saturate the output of the
   PID for speed regulation (i.e. reference torque).
   Transformation of real currents (A) into int16_t format must be done accordingly with
   formula:
   Phase current (int16_t 0-to-peak) = (Phase current (A 0-to-peak)* 32767 * Rshunt *
                                   *Amplifying network gain)/(MCU supply voltage/2)
*/

#define NOMINAL_CURRENT2         ${MC.NOMINAL_CURRENT2}
#define MOTOR_MAX_SPEED_RPM2     ${MC.MOTOR_MAX_SPEED_RPM2} /*!< Maximum rated speed  */
#define MOTOR_VOLTAGE_CONSTANT2  ${MC.MOTOR_VOLTAGE_CONSTANT2} /*!< Volts RMS ph-ph /kRPM */
#define ID_DEMAG2                ${MC.ID_DEMAG2} /*!< Demagnetization current */

/***************** MOTOR SENSORS PARAMETERS  ******************************/
/* Motor sensors parameters are always generated but really meaningful only
   if the corresponding sensor is actually present in the motor         */

/*** Hall sensors ***/
#define HALL_SENSORS_PLACEMENT2  ${MC.HALL_SENSORS_PLACEMENT2} /*!<Define here the
                                                 mechanical position of the sensors
                                                 withreference to an electrical cycle.
                                                 It can be either DEGREES_120 or
                                                 DEGREES_60 */

#define HALL_PHASE_SHIFT2        ${MC.HALL_PHASE_SHIFT2} /*!< Define here in degrees
                                                 the electrical phase shift between
                                                 the low to high transition of
                                                 signal H1 and the maximum of
                                                 the Bemf induced on phase A */
/*** Quadrature encoder ***/
#define M2_ENCODER_PPR             ${MC.ENCODER_PPR2}  /*!< Number of pulses per
                                            revolution */
</#if>

#endif /*__PMSM_MOTOR_PARAMETERS_H*/
/******************* (C) COPYRIGHT 2019 STMicroelectronics *****END OF FILE****/
