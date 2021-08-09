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
  * @file    mc_api.h
  * @author  Motor Control SDK Team, ST Microelectronics
  * @brief   This file defines the high level interface of the Motor Control SDK.
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
  * @ingroup MCIAPI
  */

/* Define to prevent recursive inclusion -------------------------------------*/
#ifndef __MC_API_H
#define __MC_API_H

#include "mc_type.h"
#include "mc_interface.h"
#include "state_machine.h"

#ifdef __cplusplus
 extern "C" {
#endif /* __cplusplus */

/** @addtogroup MCSDK
  * @{
  */

/** @addtogroup MCIAPI
  * @{
  */

/* Starts Motor 1 */
bool MC_StartMotor1(void);

/* Stops Motor 1 */
bool MC_StopMotor1(void);

/* Programs a Speed ramp for Motor 1 */
void MC_ProgramSpeedRampMotor1( int16_t hFinalSpeed, uint16_t hDurationms );

/* Programs a Torque ramp for Motor 1 */
void MC_ProgramTorqueRampMotor1( int16_t hFinalTorque, uint16_t hDurationms );

<#if MC.POSITION_CTRL_ENABLING == true>
/* Programs a target position for Motor 1 */
void MC_ProgramPositionCommandMotor1( float fTargetPosition, float fDuration );
</#if>

/* Programs a current reference for Motor 1 */
void MC_SetCurrentReferenceMotor1( qd_t Iqdref );

/* Returns the state of the last submited command for Motor 1 */
MCI_CommandState_t  MC_GetCommandStateMotor1( void);

/* Stops the execution of the current speed ramp for Motor 1 if any */
bool MC_StopSpeedRampMotor1(void);

/* Stops the execution of the on going ramp for Motor 1 if any */
void MC_StopRampMotor1(void);

/* Returns true if the last submited ramp for Motor 1 has completed, false otherwise */
bool MC_HasRampCompletedMotor1(void);

/* Returns the current mechanical rotor speed reference set for Motor 1, expressed in the unit defined by #SPEED_UNIT */
int16_t MC_GetMecSpeedReferenceMotor1(void);

/* Returns the last computed average mechanical rotor speed for Motor 1, expressed in the unit defined by #SPEED_UNIT */
int16_t MC_GetMecSpeedAverageMotor1(void);

/* Returns the final speed of the last ramp programmed for Motor 1, if this ramp was a speed ramp */
int16_t MC_GetLastRampFinalSpeedMotor1(void);

/* Returns the current Control Mode for Motor 1 (either Speed or Torque) */
STC_Modality_t MC_GetControlModeMotor1(void);

/* Returns the direction imposed by the last command on Motor 1 */
int16_t MC_GetImposedDirectionMotor1(void);

/* Returns the current reliability of the speed sensor used for Motor 1 */
bool MC_GetSpeedSensorReliabilityMotor1(void);

/* returns the amplitude of the phase current injected in Motor 1 */
int16_t MC_GetPhaseCurrentAmplitudeMotor1(void);

/* returns the amplitude of the phase voltage applied to Motor 1 */
int16_t MC_GetPhaseVoltageAmplitudeMotor1(void);

/* returns current Ia and Ib values for Motor 1 */
ab_t MC_GetIabMotor1(void);

/* returns current Ialpha and Ibeta values for Motor 1 */
alphabeta_t MC_GetIalphabetaMotor1(void);

/* returns current Iq and Id values for Motor 1 */
qd_t MC_GetIqdMotor1(void);

<#if MC.HFINJECTION == true>
/* returns current Iq and Id values in High Frequency Injection context for Motor 1 */
qd_t MC_GetIqdHFMotor1(void);
</#if>

/* returns Iq and Id reference values for Motor 1 */
qd_t MC_GetIqdrefMotor1(void);

/* returns current Vq and Vd values for Motor 1 */
qd_t MC_GetVqdMotor1(void);

/* returns current Valpha and Vbeta values for Motor 1 */
alphabeta_t MC_GetValphabetaMotor1(void);

/* returns the electrical angle of the rotor of Motor 1, in DDP format */
int16_t MC_GetElAngledppMotor1(void);

/* returns the current electrical torque reference for Motor 1 */
int16_t MC_GetTerefMotor1(void);

/* Sets the reference value for Id */
void MC_SetIdrefMotor1( int16_t hNewIdref );

/* re-initializes Iq and Id references to their default values */
void MC_Clear_IqdrefMotor1(void);


<#if (( MC.ENCODER  == true)||( MC.AUX_ENCODER == true))> /*  only for encoder*/
/* Start the Encoder Alignment procedure if possible. Returns false if not possible, true otherwise */
bool MC_AlignEncoderMotor1(void);
</#if>

/* Acknowledge a Motor Control fault on Motor 1 */
bool MC_AcknowledgeFaultMotor1( void );

/* Returns a bitfiled showing faults that occured since the State Machine of Motor 1 was moved to FAULT_NOW state */
uint16_t MC_GetOccurredFaultsMotor1(void);

/* Returns a bitfield showing all current faults on Motor 1 */
uint16_t MC_GetCurrentFaultsMotor1(void);

/* returns the current state of Motor 1 state machine */
State_t  MC_GetSTMStateMotor1(void);

<#if MC.POSITION_CTRL_ENABLING == true>
/* returns the current control position state of Motor 1 */
PosCtrlStatus_t  MC_GetControlPositionStatusMotor1( void );

/* returns the alignment state of Motor 1 */
AlignStatus_t  MC_GetAlignmentStatusMotor1( void );

/* returns the current position of Motor 1. */
float MC_GetCurrentPosition1( void );

/* returns the target position of Motor 1. */
float MC_GetTargetPosition1( void );

/* returns the total movement duration to reach the target position of Motor 1. */
float MC_GetMoveDuration1( void );
</#if>

<#if MC.DUALDRIVE == true>
/* Starts Motor 2 */
bool MC_StartMotor2(void);

/* Stops Motor 2 */
bool MC_StopMotor2(void);

/* Programs a Speed ramp for Motor 2 */
void MC_ProgramSpeedRampMotor2( int16_t hFinalSpeed, uint16_t hDurationms );

/* Programs a Torque ramp for Motor 2 */
void MC_ProgramTorqueRampMotor2( int16_t hFinalTorque, uint16_t hDurationms );


<#if MC.POSITION_CTRL_ENABLING2 == true>
/* Programs a target position for Motor 2 */
void MC_ProgramPositionCommandMotor2( float fTargetPosition, float fDuration );
</#if>

/* Programs a current reference for Motor 2 */
void MC_SetCurrentReferenceMotor2( qd_t Iqdref );

/* Returns the state of the last submited command for Motor 2 */
MCI_CommandState_t  MC_GetCommandStateMotor2( void);

/* Stops the execution of the current speed ramp for Motor 2 if any */
bool MC_StopSpeedRampMotor2(void);

/* Stops the execution of the on going ramp for Motor 2 if any */
void MC_StopRampMotor2(void);

/* Returns true if the last submited ramp for Motor 2 has completed, false otherwise */
bool MC_HasRampCompletedMotor2(void);

/* Returns the current mechanical rotor speed reference set for Motor 2, expressed in the unit defined by SPEED_UNIT */
int16_t MC_GetMecSpeedReferenceMotor2(void);

/* Returns the last computed average mechanical rotor speed for Motor 2, expressed in the unit defined by SPEED_UNIT */
int16_t MC_GetMecSpeedAverageMotor2(void);

/* Returns the final speed of the last ramp programmed for Motor 2, if this ramp was a speed ramp */
int16_t MC_GetLastRampFinalSpeedMotor2(void);

/* Returns the current Control Mode for Motor 2 (either Speed or Torque) */
STC_Modality_t MC_GetControlModeMotor2(void);

/* Returns the direction imposed by the last command on Motor 2 */
int16_t MC_GetImposedDirectionMotor2(void);

/* Returns the current reliability of the speed sensor used for Motor 2 */
bool MC_GetSpeedSensorReliabilityMotor2(void);

/* returns the amplitude of the phase current injected in Motor 2 */
int16_t MC_GetPhaseCurrentAmplitudeMotor2(void);

/* returns the amplitude of the phase voltage applied to Motor 2 */
int16_t MC_GetPhaseVoltageAmplitudeMotor2(void);

/* returns current Ia and Ib values for Motor 2 */
ab_t MC_GetIabMotor2(void);

/* returns current Ialpha and Ibeta values for Motor 2 */
alphabeta_t MC_GetIalphabetaMotor2(void);

/* returns current Iq and Id values for Motor 2 */
qd_t MC_GetIqdMotor2(void);

<#if MC.HFINJECTION2 == true>
/* returns current Iq and Id values in High Frequency Injection context for Motor 2 */
qd_t MC_GetIqdHFMotor2(void);
</#if>

/* returns Iq and Id reference values for Motor 2 */
qd_t MC_GetIqdrefMotor2(void);

/* returns current Vq and Vd values for Motor 2 */
qd_t MC_GetVqdMotor2(void);

/* returns current Valpha and Vbeta values for Motor 2 */
alphabeta_t MC_GetValphabetaMotor2(void);

/* returns the electrical angle of the rotor of Motor 2, in DDP format */
int16_t MC_GetElAngledppMotor2(void);

/* returns the current electrical torque reference for Motor 2 */
int16_t MC_GetTerefMotor2(void);

/* Sets the reference value for Id */
void MC_SetIdrefMotor2( int16_t hNewIdref );

/* re-initializes Iq and Id references their default values */
void MC_Clear_IqdrefMotor2(void);


<#if (( MC.ENCODER2  == true)||( MC.AUX_ENCODER2 == true))> /*  only for encoder*/
/* Start the Encoder Alignment procedure if possible. Returns false if not possible, true otherwise */
bool MC_AlignEncoderMotor2(void);
</#if>

/* Acknowledge a Motor Control fault on Motor 2 */
bool MC_AcknowledgeFaultMotor2( void );

/* Returns a bitfiled showing faults that occured since the State Machine of Motor 2 was moved to FAULT_NOW state */
uint16_t MC_GetOccurredFaultsMotor2(void);

/* Returns a bitfield showing all current faults on Motor 2 */
uint16_t MC_GetCurrentFaultsMotor2(void);

/* returns the current state of Motor 2 state machine */
State_t  MC_GetSTMStateMotor2(void);


<#if MC.POSITION_CTRL_ENABLING2 == true>
/* returns the current control position state of Motor 1 */
PosCtrlStatus_t  MC_GetControlPositionStatusMotor2( void );

/* returns the alignment state of Motor 2 */
AlignStatus_t  MC_GetAlignmentStatusMotor2( void );

/* returns the current position of Motor 2. */
float MC_GetCurrentPosition2( void );

/* returns the target position of Motor 2. */
float MC_GetTargetPosition2( void );

/* returns the total movement duration to reach the target position of Motor 2. */
float MC_GetMoveDuration2( void );

</#if>

</#if>

/**
  * @}
  */

/**
  * @}
  */

#ifdef __cplusplus
}
#endif /* __cpluplus */

#endif /* __MC_API_H */
/******************* (C) COPYRIGHT 2019 STMicroelectronics *****END OF FILE****/
