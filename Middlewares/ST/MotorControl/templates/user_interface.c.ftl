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
  * @file    user_interface.c
  * @author  Motor Control SDK Team, ST Microelectronics
  * @brief   This file provides firmware functions that implement the following features
  *          of the user interface component of the Motor Control SDK.
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

/* Includes ------------------------------------------------------------------*/
/* Pre-compiler coherency check */
#include "mc_type.h"
<#-- Specific to FOC algorithm usage -->
<#if MC.DRIVE_TYPE == "FOC">
#include "mc_math.h"
	<#if MC.PFC_ENABLED==true ||  MC.HFINJECTION==true || (MC.DUALDRIVE==true && MC.HFINJECTION2==true)>
#include "pid_regulator.h"
	</#if>
</#if>
#include "mc_config.h"
#include "user_interface.h"
<#if MC.DRIVE_TYPE=="SIX_STEP">
<#-- TODO : PBo, to be removed when specific code is independant from Power Board but dependant to function -->
<#if MC.SIX_STEP_POWER_BOARD == "IHM07M1">
#include "ihm07m1_conf.h"
</#if>
<#if MC.SIX_STEP_POWER_BOARD == "IHM08M1">
#include "ihm08m1_conf.h"
</#if>
<#if MC.SIX_STEP_POWER_BOARD == "IHM16M1">
#include "ihm16m1_conf.h"
</#if>
</#if><#-- MC.DRIVE_TYPE=="SIX_STEP" -->

/** @addtogroup MCSDK
  * @{
  */

/** @defgroup MCUI Motor Control User Interface
  * @brief User Interface Components of the Motor Control SDK
  *
  * These components aim at connecting the Application with the outside. There are two categories
  * of UI Componentes:
  *
  * - Some connect the application with the Motor Conrol Monitor tool via a UART link. The Motor
  *   Control Monitor can control the motor(s) driven by the application and also read and write  
  *   internal variables of the Motor Control subsystem. 
  * - Others UI components allow for using the DAC(s) peripherals in 
  *   order to output internal variables of the Motor Control subsystem for debug purposes.
  *
  * @{
  */

<#-- Motor Profiler feature usage -->
<#if MC.MOTOR_PROFILER==true>
/* Buffer used to store MP info for serial communication */
#define MPINFODATABUFFERLEN 30 /* Length of the buffer */
uint8_t MPInfoData[MPINFODATABUFFERLEN];
uint8_t MPInfoDataIndex = 0;

/* Info about the availability of MP registers */
uint8_t MPInfoDataStepX[] = {0}; /* Any step without registers update */
uint8_t MPInfoDataStep2[] = {1, MC_PROTOCOL_REG_SC_MAX_CURRENT};
uint8_t MPInfoDataStep4[] = {3, MC_PROTOCOL_REG_SC_RS, MC_PROTOCOL_REG_SC_LS, MC_PROTOCOL_REG_SC_VBUS};
uint8_t MPInfoDataStep5[] = {1, MC_PROTOCOL_REG_SC_KE};
uint8_t MPInfoDataStep6[] = {1, MC_PROTOCOL_REG_SC_MEAS_NOMINALSPEED};
uint8_t MPInfoDataStep14[] = {2, MC_PROTOCOL_REG_SC_J, MC_PROTOCOL_REG_SC_F};

static void MPInfoStep(uint8_t step, pMPInfo_t pMPInfoStep);
static void CreateMPInfoBuffer(pMPInfo_t stepList, pMPInfo_t pMPInfo);
</#if>

/**
  * @brief  Initialize the user interface component. 
  *
  * Perform the link between the UI, MC interface and MC tuning components.

  * @param  pHandle: Pointer on Handle structure of UI component.
  * @param  bMCNum  Number of MC instance present in the list.
  * @param  pMCI Pointer on the list of MC interface component to inked with UI.
 <#if MC.DRIVE_TYPE == "FOC"><#-- Specific to FOC algorithm usage -->
  * @param  pMCT Pointer on the list of MC tuning component to inked with UI.
</#if>
  * @param  pUICfg Pointer on the user interface configuration list. 
  *         Each element of the list must be a bit field containing one (or more) of
  *         the exported configuration option UI_CFGOPT_xxx (eventually OR-ed).
  * @retval none.
  */
<#if MC.DRIVE_TYPE == "FOC"><#-- Specific to FOC algorithm usage -->
__weak void UI_Init(UI_Handle_t *pHandle, uint8_t bMCNum, MCI_Handle_t ** pMCI, MCT_Handle_t** pMCT, uint32_t* pUICfg)
<#elseif MC.DRIVE_TYPE == "SIX_STEP"><#-- Specific to 6_STEP algorithm usage -->
__weak void UI_Init(UI_Handle_t *pHandle, uint8_t bMCNum, MC_Handle_t ** pMCI, uint32_t* pUICfg)
</#if>
{
  pHandle->bDriveNum = bMCNum;
  pHandle->pMCI = pMCI;
<#if MC.DRIVE_TYPE == "FOC"><#-- Specific to FOC algorithm usage -->
  pHandle->pMCT = pMCT;
</#if>
  pHandle->bSelectedDrive = 0u;
  pHandle->pUICfg = pUICfg;
}


<#-- ST MCWB monitoring usage management (used when MC.SERIAL_COMMUNICATION == true) -->
<#if MC.DRIVE_TYPE == "FOC" || MC.SERIAL_COMMUNICATION == true><#-- TODO: PBo, Is this condition (MC.DRIVE_TYPE == "FOC") really needed ? -->
/**
  * @brief  Allow to select the MC on which UI operates.
  * @param  pHandle: Pointer on Handle structure of UI component.
  * @param  bSelectMC: The new selected MC, zero based, on which UI operates.
  * @retval Boolean set to true if the bSelectMC is valid oterwise return false.
  */
__weak bool UI_SelectMC(UI_Handle_t *pHandle,uint8_t bSelectMC)
{
  bool retVal = true;
  if (bSelectMC  >= pHandle->bDriveNum)
  {
    retVal = false;
  }
  else
  {
    pHandle->bSelectedDrive = bSelectMC;
  }
  return retVal;
}


/**
  * @brief  Allow to retrieve the MC on which UI currently operates.
  * @param  pHandle: Pointer on Handle structure of UI component.
  * @retval Return the currently selected MC, zero based, on which UI operates.
  */
__weak uint8_t UI_GetSelectedMC(UI_Handle_t *pHandle)
{
  return (pHandle->bSelectedDrive);
}


/**
  * @brief  Retrieve the configuration of the MC on which UI currently operates.
  * @param  pHandle: Pointer on Handle structure of UI component.
  * @retval Return the currently configuration of selected MC on which UI operates.
  *         It represents a bit field containing one (or more) of
  *         the exported configuration option UI_CFGOPT_xxx (eventually OR-ed).
  */
__weak uint32_t UI_GetSelectedMCConfig(UI_Handle_t *pHandle)
{
  return pHandle->pUICfg[pHandle->bSelectedDrive];
}


/**
  * @brief  Allow to execute a SetReg command coming from the user.
  * @param  pHandle: Pointer on Handle structure of UI component.
  * @param  bRegID: Code of register to update.
  *         See MC_PROTOCOL_REG_xxx for code definition.
  * @param  wValue: New value to set.
  * @retval Return the currently selected MC, zero based, on which UI operates.
  */
__weak bool UI_SetReg(UI_Handle_t *pHandle, MC_Protocol_REG_t bRegID, int32_t wValue)
{
	<#if MC.PFC_ENABLED==true ||  MC.HFINJECTION==true || (MC.DUALDRIVE==true && MC.HFINJECTION2==true)>
  PID_Handle_t* pPID;
	</#if>
	<#if MC.DRIVE_TYPE == "FOC"><#-- Specific to FOC algorithm usage -->
  MCI_Handle_t * pMCI = pHandle->pMCI[pHandle->bSelectedDrive];
  MCT_Handle_t * pMCT = pHandle->pMCT[pHandle->bSelectedDrive];
	<#elseif MC.DRIVE_TYPE == "SIX_STEP"><#-- Specific to 6_STEP algorithm usage -->
  MC_Handle_t * pMCI = pHandle->pMCI[pHandle->bSelectedDrive];
	</#if>

  bool retVal = true;
  switch (bRegID)
  {
	<#-- Shared between FOC and 6_STEP algorithms usage -->
  case MC_PROTOCOL_REG_TARGET_MOTOR:
    {
      retVal = UI_SelectMC(pHandle,(uint8_t)wValue);
    }
    break;
<#if MC.DRIVE_TYPE=="SIX_STEP">

  case MC_PROTOCOL_REG_SPEED_REF:
    {

      pMCI->speed_target_value = wValue;

    }
    break;
</#if><#-- MC.DRIVE_TYPE=="SIX_STEP" -->

  case MC_PROTOCOL_REG_RAMP_FINAL_SPEED:
    {
	<#if MC.DRIVE_TYPE == "FOC" ><#-- Specific to FOC algorithm usage -->
      MCI_ExecSpeedRamp(pMCI,(int16_t)((wValue*SPEED_UNIT)/_RPM),0);
	<#elseif MC.DRIVE_TYPE == "SIX_STEP" ><#-- Specific to 6_STEP algorithm usage -->
      (void)MC_Core_SetSpeed( pMCI, wValue );
	</#if>
    }
    break;

  case MC_PROTOCOL_REG_SPEED_KP:
    {
	<#if MC.DRIVE_TYPE == "FOC" ><#-- Specific to FOC algorithm usage -->
      PID_SetKP(pMCT->pPIDSpeed,(int16_t)wValue);
	<#elseif MC.DRIVE_TYPE == "SIX_STEP" ><#-- Specific to 6_STEP algorithm usage -->
		<#if MC.SIX_STEP_SPEED_LOOP == true><#-- Speed Loop usage -->
      pMCI->pid_parameters.kp = wValue;
		</#if>
	</#if>
    }
    break;

  case MC_PROTOCOL_REG_SPEED_KI:
    {
	<#if MC.DRIVE_TYPE == "FOC" ><#-- Specific to FOC algorithm usage -->
      PID_SetKI(pMCT->pPIDSpeed,(int16_t)wValue);
	<#elseif MC.DRIVE_TYPE == "SIX_STEP" ><#-- Specific to 6_STEP algorithm usage -->
		<#if MC.SIX_STEP_SPEED_LOOP == true><#-- Speed Loop usage -->
      pMCI->pid_parameters.ki = wValue;
		</#if>
	</#if>
    }
    break;

  case MC_PROTOCOL_REG_SPEED_KD:
    {
	<#if MC.DRIVE_TYPE == "FOC" ><#-- Specific to FOC algorithm usage -->
      PID_SetKD(pMCT->pPIDSpeed,(int16_t)wValue);
	<#elseif MC.DRIVE_TYPE == "SIX_STEP" ><#-- Specific to 6_STEP algorithm usage -->
		<#if MC.SIX_STEP_SPEED_LOOP == true><#-- Speed Loop usage -->
      pMCI->pid_parameters.kd = wValue;
		</#if>
 	</#if>
    }
    break;

	<#-- Specific to FOC algorithm usage -->
	<#if MC.DRIVE_TYPE == "FOC">
  case MC_PROTOCOL_REG_CONTROL_MODE:
    {
      if ((STC_Modality_t)wValue == STC_TORQUE_MODE)
      {
        MCI_ExecTorqueRamp(pMCI, MCI_GetTeref(pMCI),0);
      }
      if ((STC_Modality_t)wValue == STC_SPEED_MODE)
      {
        MCI_ExecSpeedRamp(pMCI, MCI_GetMecSpeedRefUnit(pMCI),0);
      }
    }
    break;

  case MC_PROTOCOL_REG_TORQUE_REF:
    {
      qd_t currComp;
      currComp = MCI_GetIqdref(pMCI);
      currComp.q = (int16_t)wValue;
      MCI_SetCurrentReferences(pMCI,currComp);
    }
    break;

  case MC_PROTOCOL_REG_TORQUE_KP:
    {
      PID_SetKP(pMCT->pPIDIq,(int16_t)wValue);
    }
    break;

  case MC_PROTOCOL_REG_TORQUE_KI:
    {
      PID_SetKI(pMCT->pPIDIq,(int16_t)wValue);
    }
    break;

  case MC_PROTOCOL_REG_TORQUE_KD:
    {
      PID_SetKD(pMCT->pPIDIq,(int16_t)wValue);
    }
    break;

  case MC_PROTOCOL_REG_FLUX_REF:
    {
      qd_t currComp;
      currComp = MCI_GetIqdref(pMCI);
      currComp.d = (int16_t)wValue;
      MCI_SetCurrentReferences(pMCI,currComp);
    }
    break;

  case MC_PROTOCOL_REG_FLUX_KP:
    {
      PID_SetKP(pMCT->pPIDId,(int16_t)wValue);
    }
    break;

  case MC_PROTOCOL_REG_FLUX_KI:
    {
      PID_SetKI(pMCT->pPIDId,(int16_t)wValue);
    }
    break;

  case MC_PROTOCOL_REG_FLUX_KD:
    {
      PID_SetKD(pMCT->pPIDId,(int16_t)wValue);
    }
    break;

		<#-- State Observer + Cordic features usage -->
		<#if MC.STATE_OBSERVER_CORDIC==true || MC.STATE_OBSERVER_CORDIC2==true || MC.AUX_STATE_OBSERVER_CORDIC==true || MC.AUX_STATE_OBSERVER_CORDIC2==true>
  case MC_PROTOCOL_REG_OBSERVER_CR_C1:
    {
      uint32_t hUICfg = pHandle->pUICfg[pHandle->bSelectedDrive];
      SpeednPosFdbk_Handle_t* pSPD = MC_NULL;
      int16_t hC1,hC2;
      if (MAIN_SCFG_VALUE(hUICfg) == UI_SCODE_STO_CR)
      {
        pSPD = pMCT->pSpeedSensorMain;
      }
      if (AUX_SCFG_VALUE(hUICfg) == UI_SCODE_STO_CR)
      {
        pSPD = pMCT->pSpeedSensorAux;
      }
      if (pSPD != MC_NULL)
      {
        STO_CR_GetObserverGains((STO_CR_Handle_t*)pSPD,&hC1,&hC2);
        STO_CR_SetObserverGains((STO_CR_Handle_t*)pSPD,(int16_t)wValue,hC2);
      }
    }
    break;

  case MC_PROTOCOL_REG_OBSERVER_CR_C2:
    {
      uint32_t hUICfg = pHandle->pUICfg[pHandle->bSelectedDrive];
      SpeednPosFdbk_Handle_t* pSPD = MC_NULL;
      int16_t hC1,hC2;
      if (MAIN_SCFG_VALUE(hUICfg) == UI_SCODE_STO_CR)
      {
        pSPD = pMCT->pSpeedSensorMain;
      }
      if (AUX_SCFG_VALUE(hUICfg) == UI_SCODE_STO_CR)
      {
        pSPD = pMCT->pSpeedSensorAux;
      }
      if (pSPD != MC_NULL)
      {
        STO_CR_GetObserverGains((STO_CR_Handle_t*)pSPD,&hC1,&hC2);
        STO_CR_SetObserverGains((STO_CR_Handle_t*)pSPD,hC1,(int16_t)wValue);
      }
    }
    break;
		</#if>

		<#-- State Observer + PLL features usage -->
		<#if MC.STATE_OBSERVER_PLL==true || MC.STATE_OBSERVER_PLL2==true || MC.AUX_STATE_OBSERVER_PLL==true || MC.AUX_STATE_OBSERVER_PLL2==true>
  case MC_PROTOCOL_REG_OBSERVER_C1:
    {
      uint32_t hUICfg = pHandle->pUICfg[pHandle->bSelectedDrive];
      SpeednPosFdbk_Handle_t* pSPD = MC_NULL;
      int16_t hC1,hC2;
      if (MAIN_SCFG_VALUE(hUICfg) == UI_SCODE_STO_PLL)
      {
        pSPD = pMCT->pSpeedSensorMain;
      }
      if (AUX_SCFG_VALUE(hUICfg) == UI_SCODE_STO_PLL)
      {
        pSPD = pMCT->pSpeedSensorAux;
      }
      if (pSPD != MC_NULL)
      {
        STO_PLL_GetObserverGains((STO_PLL_Handle_t*)pSPD,&hC1,&hC2);
        STO_PLL_SetObserverGains((STO_PLL_Handle_t*)pSPD,(int16_t)wValue,hC2);
      }
    }
    break;

  case MC_PROTOCOL_REG_OBSERVER_C2:
    {
      uint32_t hUICfg = pHandle->pUICfg[pHandle->bSelectedDrive];
      SpeednPosFdbk_Handle_t* pSPD = MC_NULL;
      int16_t hC1,hC2;
      if (MAIN_SCFG_VALUE(hUICfg) == UI_SCODE_STO_PLL)
      {
        pSPD = pMCT->pSpeedSensorMain;
      }
      if (AUX_SCFG_VALUE(hUICfg) == UI_SCODE_STO_PLL)
      {
        pSPD = pMCT->pSpeedSensorAux;
      }
      if (pSPD != MC_NULL)
      {
        STO_PLL_GetObserverGains((STO_PLL_Handle_t*)pSPD,&hC1,&hC2);
        STO_PLL_SetObserverGains((STO_PLL_Handle_t*)pSPD,hC1,(int16_t)wValue);
      }
    }
    break;

  case MC_PROTOCOL_REG_PLL_KI:
    {
      uint32_t hUICfg = pHandle->pUICfg[pHandle->bSelectedDrive];
      SpeednPosFdbk_Handle_t* pSPD = MC_NULL;
      int16_t hPgain, hIgain;
      if (MAIN_SCFG_VALUE(hUICfg) == UI_SCODE_STO_PLL)
      {
        pSPD = pMCT->pSpeedSensorMain;
      }
      if (AUX_SCFG_VALUE(hUICfg) == UI_SCODE_STO_PLL)
      {
        pSPD = pMCT->pSpeedSensorAux;
      }
      if (pSPD != MC_NULL)
      {
        STO_GetPLLGains((STO_PLL_Handle_t*)pSPD,&hPgain,&hIgain);
        STO_SetPLLGains((STO_PLL_Handle_t*)pSPD,hPgain,(int16_t)wValue);
      }
    }
    break;

  case MC_PROTOCOL_REG_PLL_KP:
	{
      uint32_t hUICfg = pHandle->pUICfg[pHandle->bSelectedDrive];
      SpeednPosFdbk_Handle_t* pSPD = MC_NULL;
      int16_t hPgain, hIgain;
      if (MAIN_SCFG_VALUE(hUICfg) == UI_SCODE_STO_PLL)
      {
        pSPD = pMCT->pSpeedSensorMain;
      }
      if (AUX_SCFG_VALUE(hUICfg) == UI_SCODE_STO_PLL)
      {
        pSPD = pMCT->pSpeedSensorAux;
      }
      if (pSPD != MC_NULL)
      {
        STO_GetPLLGains((STO_PLL_Handle_t*)pSPD,&hPgain,&hIgain);
        STO_SetPLLGains((STO_PLL_Handle_t*)pSPD,(int16_t)wValue,hIgain);
      }
    }
    break;
		</#if>

		<#-- Flux Weakening feature usage -->
		<#if MC.FLUX_WEAKENING_ENABLING==true || MC.FLUX_WEAKENING_ENABLING2==true>
  case MC_PROTOCOL_REG_FLUXWK_KP:
    {
      PID_SetKP(pMCT->pPIDFluxWeakening,(int16_t)wValue);
    }
    break;

  case MC_PROTOCOL_REG_FLUXWK_KI:
    {
      PID_SetKI(pMCT->pPIDFluxWeakening,(int16_t)wValue);
    }
    break;

  case MC_PROTOCOL_REG_FLUXWK_BUS:
    {
      if (pMCT->pFW)
      {
        FW_SetVref(pMCT->pFW,(uint16_t)wValue);
      }
    }
    break;
		</#if>

  case MC_PROTOCOL_REG_IQ_SPEEDMODE:
    {
      MCI_SetIdref(pMCI,(int16_t)wValue);
    }
    break;

		<#-- Feed Forward feature usage -->
		<#if MC.FEED_FORWARD_CURRENT_REG_ENABLING==true || MC.FEED_FORWARD_CURRENT_REG_ENABLING2==true>
  case MC_PROTOCOL_REG_FF_1Q:
    {
      FF_TuningStruct_t sNewConstants;
      sNewConstants = FF_GetFFConstants(pMCT->pFF);
      sNewConstants.wConst_1Q = wValue;
      FF_SetFFConstants(pMCT->pFF,sNewConstants);
    }
    break;

  case MC_PROTOCOL_REG_FF_1D:
    {
      FF_TuningStruct_t sNewConstants;
      sNewConstants = FF_GetFFConstants(pMCT->pFF);
      sNewConstants.wConst_1D = wValue;
      FF_SetFFConstants(pMCT->pFF,sNewConstants);
    }
    break;

  case MC_PROTOCOL_REG_FF_2:
    {
      FF_TuningStruct_t sNewConstants;
      sNewConstants = FF_GetFFConstants(pMCT->pFF);
      sNewConstants.wConst_2 = wValue;
      FF_SetFFConstants(pMCT->pFF,sNewConstants);
    }
    break;
		</#if>
<#if MC.POSITION_CTRL_ENABLING == true || MC.POSITION_CTRL_ENABLING2 == true>

  case MC_PROTOCOL_REG_POSITION_KP:
    {
      PID_SetKP(pMCT->pPosCtrl->PIDPosRegulator,(int16_t)wValue);
    }
    break;

  case MC_PROTOCOL_REG_POSITION_KI:
    {
      PID_SetKI(pMCT->pPosCtrl->PIDPosRegulator,(int16_t)wValue);
    }
    break;

  case MC_PROTOCOL_REG_POSITION_KD:
    {
      PID_SetKD(pMCT->pPosCtrl->PIDPosRegulator,(int16_t)wValue);
    }
    break;
</#if>

		<#-- PFC feature usage -->
		<#if MC.PFC_ENABLED==true>
  case MC_PROTOCOL_REG_PFC_DCBUS_REF:
    {
      PFC_SetBoostVoltageReference( &PFC, (int16_t)wValue);
    }
    break;

  case MC_PROTOCOL_REG_PFC_I_KP:
    {
      pPID = PFC_GetCurrentLoopPI( &PFC );
      PID_SetKP(pPID,(int16_t)wValue);
    }
    break;

  case MC_PROTOCOL_REG_PFC_I_KI:
    {
      pPID = PFC_GetCurrentLoopPI( &PFC );
      PID_SetKI(pPID,(int16_t)wValue);
    }
    break;

  case MC_PROTOCOL_REG_PFC_I_KD:
    {
      uint32_t hUICfg = pHandle->pUICfg[pHandle->bSelectedDrive];
      if ((hUICfg & UI_CFGOPT_PFC_I_KD) != 0u)
      {
        pPID = PFC_GetCurrentLoopPI( &PFC );
        PID_SetKD( pPID, (int16_t) wValue );
      }
    }
    break;

  case MC_PROTOCOL_REG_PFC_V_KP:
    {
      pPID = PFC_GetVoltageLoopPI( &PFC );
      PID_SetKP(pPID,(int16_t)wValue);
    }
    break;

  case MC_PROTOCOL_REG_PFC_V_KI:
    {
      pPID = PFC_GetVoltageLoopPI( &PFC );
      PID_SetKI(pPID,(int16_t)wValue);
    }
    break;

  case MC_PROTOCOL_REG_PFC_V_KD:
    {
      uint32_t hUICfg = pHandle->pUICfg[pHandle->bSelectedDrive];
      if ((hUICfg & UI_CFGOPT_PFC_V_KD) != 0u)
      {
        pPID = PFC_GetVoltageLoopPI( &PFC );
        PID_SetKD( pPID, (int16_t) wValue );
      }
    }
    break;

  case MC_PROTOCOL_REG_PFC_STARTUP_DURATION:
    {
      PFC_SetStartUpDuration( &PFC, (int16_t) wValue );
    }
    break;
		</#if>

		<#-- High Frequency Injection usage -->
		<#if MC.HFINJECTION==true || (MC.DUALDRIVE==true && MC.HFINJECTION2==true)>
  case MC_PROTOCOL_REG_HFI_INIT_ANG_SAT_DIFF:
    {
      uint32_t hUICfg = pHandle->pUICfg[pHandle->bSelectedDrive];
      HFI_FP_Ctrl_Handle_t* pHFI;
      if (MAIN_SCFG_VALUE(hUICfg) == UI_SCODE_HFINJ)
      {
        pHFI = pMCT->pHFI;
      }
      if (pHFI != MC_NULL)
      {
        HFI_FP_SetMinSaturationDifference(pMCT->pHFI,(int16_t)wValue);
      }
    }
    break;

  case MC_PROTOCOL_REG_HFI_PI_TRACK_KP:
    {
      uint32_t hUICfg = pHandle->pUICfg[pHandle->bSelectedDrive];
      HFI_FP_Ctrl_Handle_t* pHFI;
      if (MAIN_SCFG_VALUE(hUICfg) == UI_SCODE_HFINJ)
      {
        pHFI = pMCT->pHFI;
      }
      if (pHFI != MC_NULL)
      {
        pPID = HFI_FP_GetPITrack(pHFI);
        PID_SetKP(pPID,(int16_t)wValue);
      }
    }
    break;

  case MC_PROTOCOL_REG_HFI_PI_TRACK_KI:
    {
      uint32_t hUICfg = pHandle->pUICfg[pHandle->bSelectedDrive];
      HFI_FP_Ctrl_Handle_t* pHFI;
      if (MAIN_SCFG_VALUE(hUICfg) == UI_SCODE_HFINJ)
      {
        pHFI = pMCT->pHFI;
      }
      if (pHFI != MC_NULL)
      {
        pPID = HFI_FP_GetPITrack(pHFI);
        PID_SetKI(pPID,(int16_t)wValue);
      }
    }
    break;
		</#if>

		<#-- Motor Profiler usage -->
		<#if MC.MOTOR_PROFILER==true>
  case MC_PROTOCOL_REG_SC_PP:
    {
      if (pMCT->pSpeedSensorMain != MC_NULL)
      {
        SPD_SetElToMecRatio(pMCT->pSpeedSensorMain,(uint8_t)wValue);
      }

      if (pMCT->pSpeedSensorVirtual != MC_NULL)
      {
        SPD_SetElToMecRatio(&pMCT->pSpeedSensorVirtual->_Super,(uint8_t)wValue);
      }

      if (pMCT->pSCC != MC_NULL)
      {
        SCC_SetPolesPairs(pMCT->pSCC,(uint8_t)wValue);
      }

      if (pMCT->pOTT != MC_NULL)
      {
        OTT_SetPolesPairs(pMCT->pOTT, (uint8_t)wValue);
      }
    }
    break;

  case MC_PROTOCOL_REG_SC_CURRENT:
    {
      float fCurrent = *(float*)(&wValue);
      if (pMCT->pSCC != MC_NULL)
      {
        SCC_SetNominalCurrent(pMCT->pSCC, fCurrent);
      }
    }
    break;

  case MC_PROTOCOL_REG_SC_SPDBANDWIDTH:
    {
      float fBW = *(float*)(&wValue);

      if (pMCT->pOTT != MC_NULL)
      {
        OTT_SetSpeedRegulatorBandwidth(pMCT->pOTT, fBW);
      }

    }
    break;

  case MC_PROTOCOL_REG_SC_LDLQRATIO:
    {
      float fLdLqRatio = *(float*)(&wValue);

      if (pMCT->pSCC != MC_NULL)
      {
        SCC_SetLdLqRatio(pMCT->pSCC, fLdLqRatio);
      }
    }
    break;

  case MC_PROTOCOL_REG_SC_NOMINAL_SPEED:
    {

      if (pMCT->pSCC != MC_NULL)
      {
        SCC_SetNominalSpeed(pMCT->pSCC, wValue);
      }
    }
    break;

  case MC_PROTOCOL_REG_SC_CURRBANDWIDTH:
    {
      float fBW = *(float*)(&wValue);

      if (pMCT->pSCC != MC_NULL)
      {
        SCC_SetCurrentBandwidth(pMCT->pSCC, fBW);
      }
    }
    break;
		</#if>
	</#if><#-- MC.DRIVE_TYPE == "FOC" -->

  default:
    retVal = false;
    break;
  }

  return retVal;
}


/* Used to execute a GetReg command coming from the user. */
__weak int32_t UI_GetReg(UI_Handle_t *pHandle, MC_Protocol_REG_t bRegID, bool * success)
{
	<#if MC.PFC_ENABLED==true ||  MC.HFINJECTION==true || (MC.DUALDRIVE==true && MC.HFINJECTION2==true)>
  PID_Handle_t* pPID;
	</#if>
	<#if MC.DRIVE_TYPE == "FOC" ><#-- Specific to FOC algorithm usage -->
  MCT_Handle_t* pMCT = pHandle->pMCT[pHandle->bSelectedDrive];
  MCI_Handle_t * pMCI = pHandle->pMCI[pHandle->bSelectedDrive];
	<#elseif  MC.DRIVE_TYPE == "SIX_STEP" ><#-- Specific to 6_STEP algorithm usage -->
  MC_Handle_t * pMCI = pHandle->pMCI[pHandle->bSelectedDrive];
	</#if>

  int32_t bRetVal = 0;

  if ( success != (bool *) 0 ) 
  {
    *success = true;
  }

  switch (bRegID)
  {
	<#-- Shared between FOC and 6_STEP algorithms usage -->
    case MC_PROTOCOL_REG_TARGET_MOTOR:
    {
      bRetVal = (int32_t)UI_GetSelectedMC(pHandle);
    }
    break;

    case MC_PROTOCOL_REG_FLAGS:
    {
	<#if MC.DRIVE_TYPE == "FOC" ><#-- Specific to FOC algorithm usage -->
      bRetVal = (int32_t)STM_GetFaultState(pMCT->pStateMachine);
	<#elseif MC.DRIVE_TYPE == "SIX_STEP"><#-- Specific to 6_STEP algorithm usage -->
      switch ( pMCI->status )
      {
        case MC_IDLE:
        case MC_STOP:
        case MC_ALIGNMENT:
        case MC_STARTUP:
        case MC_VALIDATION:
        case MC_RUN:
          bRetVal = (int32_t) 0;
          break;
        case MC_SPEEDFBKERROR:
          bRetVal = MC_SPEED_FDBK;
          break;
        case MC_OVERCURRENT:
          bRetVal = MC_BREAK_IN;
          break;
        case MC_VALIDATION_FAILURE:
          bRetVal = MC_START_UP;
          break;
        case MC_VALIDATION_BEMF_FAILURE:
          bRetVal = (MC_SW_ERROR | MC_SPEED_FDBK);
          break;
        case MC_VALIDATION_HALL_FAILURE:
          bRetVal = (MC_SW_ERROR | MC_SPEED_FDBK);
          break;
        case MC_LF_TIMER_FAILURE:
          bRetVal = MC_FOC_DURATION;
          break;
        default: 
          bRetVal = MC_SW_ERROR;
		  break;
	  }
	</#if>
    }
	break;

    case MC_PROTOCOL_REG_STATUS:
    {
	<#if MC.DRIVE_TYPE == "FOC"><#-- Specific to FOC algorithm usage -->
      bRetVal = (int32_t)STM_GetState(pMCT->pStateMachine);
	<#elseif MC.DRIVE_TYPE == "SIX_STEP"><#-- Specific to 6_STEP algorithm usage -->
      switch ( pMCI->status )
        {
        case MC_IDLE:
          bRetVal = IDLE;
          break;
        case MC_STOP:
          bRetVal = STOP;
          break;
        case MC_ALIGNMENT:
          bRetVal = ALIGNMENT;
          break;
        case MC_STARTUP:
          bRetVal = START;
          break;
        case MC_VALIDATION:
          bRetVal = START_RUN;
          break;
        case MC_RUN:
          bRetVal = RUN;
          break;
        case MC_SPEEDFBKERROR:
        case MC_OVERCURRENT:
        case MC_VALIDATION_FAILURE:
        case MC_VALIDATION_BEMF_FAILURE:
        case MC_VALIDATION_HALL_FAILURE:
        case MC_LF_TIMER_FAILURE:
        case MC_ADC_CALLBACK_FAILURE:
          bRetVal = FAULT_OVER;
          break;
        default: 
          bRetVal = FAULT_NOW;
		  break;
		}
	</#if>
    }
	break;

    case MC_PROTOCOL_REG_SPEED_REF:
    {
	<#if MC.DRIVE_TYPE == "FOC" ><#-- Specific to FOC algorithm usage -->
      bRetVal = (int32_t)((MCI_GetMecSpeedRefUnit(pMCI)*_RPM)/SPEED_UNIT);
	<#elseif MC.DRIVE_TYPE == "SIX_STEP"><#-- Specific to 6_STEP algorithm usage -->
      bRetVal = (int32_t) pMCI->speed_target_command;
	</#if>
    }
    break;

    case MC_PROTOCOL_REG_SPEED_KP:
    {
	<#if MC.DRIVE_TYPE == "FOC" ><#-- Specific to FOC algorithm usage -->
      bRetVal = (int32_t)PID_GetKP(pMCT->pPIDSpeed);
	<#elseif MC.DRIVE_TYPE == "SIX_STEP"><#-- Specific to 6_STEP algorithm usage -->
		<#if MC.SIX_STEP_SPEED_LOOP == true><#-- Speed Loop usage -->
      bRetVal = (int32_t) pMCI->pid_parameters.kp;
		</#if>
	</#if>
    }
    break;

    case MC_PROTOCOL_REG_SPEED_KI:
    {
	<#if MC.DRIVE_TYPE == "FOC" ><#-- Specific to FOC algorithm usage -->
      bRetVal = (int32_t)PID_GetKI(pMCT->pPIDSpeed);
	<#elseif MC.DRIVE_TYPE == "SIX_STEP"><#-- Specific to 6_STEP algorithm usage -->
		<#if MC.SIX_STEP_SPEED_LOOP == true><#-- Speed Loop usage -->
      bRetVal = (int32_t) pMCI->pid_parameters.ki;
		</#if>
	</#if>
    }
    break;

    case MC_PROTOCOL_REG_SPEED_KD:
    {
	<#if MC.DRIVE_TYPE == "FOC" ><#-- Specific to FOC algorithm usage -->
      bRetVal = (int32_t)PID_GetKD(pMCT->pPIDSpeed);
	<#elseif MC.DRIVE_TYPE == "SIX_STEP"><#-- Specific to 6_STEP algorithm usage -->
		<#if MC.SIX_STEP_SPEED_LOOP == true><#-- Speed Loop usage -->
      bRetVal = (int32_t) pMCI->pid_parameters.kd;
		</#if>
	</#if>
    }
    break;

    case MC_PROTOCOL_REG_BUS_VOLTAGE:
    {
	<#if MC.DRIVE_TYPE == "FOC" ><#-- Specific to FOC algorithm usage -->
      bRetVal = (int32_t)VBS_GetAvBusVoltage_V(pMCT->pBusVoltageSensor);
	<#elseif MC.DRIVE_TYPE == "SIX_STEP" ><#-- Specific to 6_STEP algorithm usage -->
		<#if MC.SIX_STEP_POWER_BOARD == "IHM07M1">
      bRetVal = (int32_t) (${MC.ADC_REFERENCE_VOLTAGE} / IHM07M1_ADC_FULL_SCALE / ${MC.VBUS_PARTITIONING_FACTOR} * pMCI->adc_user.measurement[MC_USER_MEAS_3]);
		</#if>
		<#if MC.SIX_STEP_POWER_BOARD == "IHM08M1">
      bRetVal = (int32_t) (${MC.ADC_REFERENCE_VOLTAGE} / IHM08M1_ADC_FULL_SCALE / ${MC.VBUS_PARTITIONING_FACTOR} * pMCI->adc_user.measurement[MC_USER_MEAS_3]);
		</#if>
		<#if MC.SIX_STEP_POWER_BOARD == "IHM16M1">
      bRetVal = (int32_t) (${MC.ADC_REFERENCE_VOLTAGE} / IHM16M1_ADC_FULL_SCALE / ${MC.VBUS_PARTITIONING_FACTOR} * pMCI->adc_user.measurement[MC_USER_MEAS_3]);
		</#if>
	</#if>
    }
    break;

    case MC_PROTOCOL_REG_HEATS_TEMP:
    {
	<#if MC.DRIVE_TYPE == "FOC" ><#-- Specific to FOC algorithm usage -->
      bRetVal = (int32_t)NTC_GetAvTemp_C(pMCT->pTemperatureSensor);
	<#elseif MC.DRIVE_TYPE == "SIX_STEP"><#-- Specific to 6_STEP algorithm usage -->
		<#if MC.SIX_STEP_POWER_BOARD == "IHM07M1">
      bRetVal = (int32_t) (${MC.ADC_REFERENCE_VOLTAGE} / IHM07M1_ADC_FULL_SCALE / ${MC.VBUS_PARTITIONING_FACTOR} * pMCI->adc_user.measurement[MC_USER_MEAS_4]);
		</#if>
		<#if MC.SIX_STEP_POWER_BOARD == "IHM08M1">
      bRetVal = (int32_t) (${MC.ADC_REFERENCE_VOLTAGE} / IHM08M1_ADC_FULL_SCALE / ${MC.VBUS_PARTITIONING_FACTOR} * pMCI->adc_user.measurement[MC_USER_MEAS_4]);
		</#if>
		<#if MC.SIX_STEP_POWER_BOARD == "IHM16M1">
      bRetVal = (int32_t) (${MC.ADC_REFERENCE_VOLTAGE} / IHM16M1_ADC_FULL_SCALE / ${MC.VBUS_PARTITIONING_FACTOR} * pMCI->adc_user.measurement[MC_USER_MEAS_4]);
		</#if>
	</#if>
    }
    break;

    case MC_PROTOCOL_REG_SPEED_MEAS:
    {
	<#if MC.DRIVE_TYPE == "FOC" ><#-- Specific to FOC algorithm usage -->
      bRetVal = (int32_t)((MCI_GetAvrgMecSpeedUnit(pMCI) * _RPM)/SPEED_UNIT);
	<#elseif MC.DRIVE_TYPE == "SIX_STEP"><#-- Specific to 6_STEP algorithm usage -->
      bRetVal = (int32_t) MC_Core_GetSpeed( pMCI );
	</#if>
    }
    break;

    case MC_PROTOCOL_REG_UID:
    {
      bRetVal = (int32_t)(MC_UID);
    }
    break;

    case MC_PROTOCOL_REG_CTRBDID:
    {
      bRetVal = CTRBDID;
    }
    break;

    case MC_PROTOCOL_REG_PWBDID:
    {
      bRetVal = PWBDID;
    }
    break;

    case MC_PROTOCOL_REG_PWBDID2:
    {
	<#if MC.DUALDRIVE==true>
      bRetVal = PWBDID2;
	<#else>
      bRetVal = (uint32_t) 0;
	</#if>
    }
    break;

    case MC_PROTOCOL_REG_TORQUE_REF:
    {
	<#if MC.DRIVE_TYPE == "FOC" ><#-- Specific to FOC algorithm usage -->
      qd_t currComp;
      currComp = MCI_GetIqdref(pMCI);
      bRetVal = (int32_t)currComp.q;
	<#elseif MC.DRIVE_TYPE == "SIX_STEP"><#-- Specific to 6_STEP algorithm usage -->
      bRetVal = (int32_t) pMCI->pulse_value;
	</#if>
    }
    break;

    case MC_PROTOCOL_REG_FLUX_REF:
    {
	<#if MC.DRIVE_TYPE == "FOC" ><#-- Specific to FOC algorithm usage -->
      qd_t currComp;
      currComp = MCI_GetIqdref(pMCI);
      bRetVal = (int32_t)currComp.d;
	<#elseif MC.DRIVE_TYPE == "SIX_STEP"><#-- Specific to 6_STEP algorithm usage -->
      bRetVal = (int32_t) pMCI->startup_reference;
	</#if>
    }
    break;

	<#-- Specific to FOC algorithm usage -->
	<#if MC.DRIVE_TYPE == "FOC" >
    case MC_PROTOCOL_REG_CONTROL_MODE:
    {
      bRetVal = (int32_t)MCI_GetControlMode(pMCI);
    }
    break;

    case MC_PROTOCOL_REG_RAMP_FINAL_SPEED:
    {
      if (MCI_GetControlMode(pMCI) == STC_SPEED_MODE)
      {
      bRetVal = (int32_t)((MCI_GetLastRampFinalSpeed(pMCI) * _RPM)/SPEED_UNIT) ;
      }
      else
      {
      bRetVal = (int32_t)((MCI_GetMecSpeedRefUnit(pMCI) * _RPM)/SPEED_UNIT) ;
      }
    }
    break;

    case MC_PROTOCOL_REG_SPEED_KP_DIV:
    {
      bRetVal = (int32_t)PID_GetKPDivisor(pMCT->pPIDSpeed);
    }
    break;

    case MC_PROTOCOL_REG_SPEED_KI_DIV:
    {
      bRetVal = (int32_t)PID_GetKIDivisor(pMCT->pPIDSpeed);
    }
    break;

    case MC_PROTOCOL_REG_TORQUE_KP:
    {
      bRetVal = (int32_t)PID_GetKP(pMCT->pPIDIq);
    }
    break;

    case MC_PROTOCOL_REG_TORQUE_KI:
    {
      bRetVal = (int32_t)PID_GetKI(pMCT->pPIDIq);
    }
    break;

    case MC_PROTOCOL_REG_TORQUE_KD:
    {
      bRetVal = (int32_t)PID_GetKD(pMCT->pPIDIq);
    }
    break;

    case MC_PROTOCOL_REG_IQ_SPEEDMODE:
    {
      qd_t currComp;
      currComp = MCI_GetIqdref(pMCI);
      bRetVal = (int32_t)currComp.d;
    }
    break;

    case MC_PROTOCOL_REG_FLUX_KP:
    {
      bRetVal = (int32_t)PID_GetKP(pMCT->pPIDId);
    }
    break;

    case MC_PROTOCOL_REG_FLUX_KI:
    {
      bRetVal = (int32_t)PID_GetKI(pMCT->pPIDId);
    }
    break;

    case MC_PROTOCOL_REG_FLUX_KD:
    {
      bRetVal = (int32_t)PID_GetKD(pMCT->pPIDId);
    }
    break;

		<#-- State Observer + Cordic feature usage -->
		<#if MC.STATE_OBSERVER_CORDIC==true || MC.STATE_OBSERVER_CORDIC2==true || MC.AUX_STATE_OBSERVER_CORDIC==true || MC.AUX_STATE_OBSERVER_CORDIC2==true>
    case MC_PROTOCOL_REG_OBSERVER_CR_C1:
    {
      uint32_t hUICfg = pHandle->pUICfg[pHandle->bSelectedDrive];
      SpeednPosFdbk_Handle_t* pSPD = MC_NULL;
      int16_t hC1,hC2;
      if (MAIN_SCFG_VALUE(hUICfg) == UI_SCODE_STO_CR)
      {
        pSPD = pMCT->pSpeedSensorMain;
      }
      if (AUX_SCFG_VALUE(hUICfg) == UI_SCODE_STO_CR)
      {
        pSPD = pMCT->pSpeedSensorAux;
      }
      if (pSPD != MC_NULL)
      {
        STO_CR_GetObserverGains((STO_CR_Handle_t*)pSPD,&hC1,&hC2);
      }
      bRetVal = (int32_t)hC1;
    }
    break;

    case MC_PROTOCOL_REG_OBSERVER_CR_C2:
    {
      uint32_t hUICfg = pHandle->pUICfg[pHandle->bSelectedDrive];
      SpeednPosFdbk_Handle_t* pSPD = MC_NULL;
      int16_t hC1,hC2;
      if (MAIN_SCFG_VALUE(hUICfg) == UI_SCODE_STO_CR)
      {
        pSPD = pMCT->pSpeedSensorMain;
      }
      if (AUX_SCFG_VALUE(hUICfg) == UI_SCODE_STO_CR)
      {
        pSPD = pMCT->pSpeedSensorAux;
      }
      if (pSPD != MC_NULL)
      {
        STO_CR_GetObserverGains((STO_CR_Handle_t*)pSPD,&hC1,&hC2);
      }
      bRetVal = (int32_t)hC2;
    }
    break;

    case MC_PROTOCOL_REG_OBS_CR_EL_ANGLE:
    {
      uint32_t hUICfg = pHandle->pUICfg[pHandle->bSelectedDrive];
      SpeednPosFdbk_Handle_t* pSPD = MC_NULL;
      if (MAIN_SCFG_VALUE(hUICfg) == UI_SCODE_STO_CR)
      {
        pSPD = pMCT->pSpeedSensorMain;
      }
      if (AUX_SCFG_VALUE(hUICfg) == UI_SCODE_STO_CR)
      {
        pSPD = pMCT->pSpeedSensorAux;
      }
      if (pSPD != MC_NULL)
      {
        bRetVal = SPD_GetElAngle(pSPD);
      }
    }
    break;

    case MC_PROTOCOL_REG_OBS_CR_ROT_SPEED:
    {
      uint32_t hUICfg = pHandle->pUICfg[pHandle->bSelectedDrive];
      SpeednPosFdbk_Handle_t* pSPD = MC_NULL;
      if (MAIN_SCFG_VALUE(hUICfg) == UI_SCODE_STO_CR)
      {
        pSPD = pMCT->pSpeedSensorMain;
      }
      if (AUX_SCFG_VALUE(hUICfg) == UI_SCODE_STO_CR)
      {
        pSPD = pMCT->pSpeedSensorAux;
      }
      if (pSPD != MC_NULL)
      {
        bRetVal = SPD_GetS16Speed(pSPD);
      }
    }
    break;

    case MC_PROTOCOL_REG_OBS_CR_I_ALPHA:
    {
      uint32_t hUICfg = pHandle->pUICfg[pHandle->bSelectedDrive];
      SpeednPosFdbk_Handle_t* pSPD = MC_NULL;
      if (MAIN_SCFG_VALUE(hUICfg) == UI_SCODE_STO_CR)
      {
        pSPD = pMCT->pSpeedSensorMain;
      }
      if (AUX_SCFG_VALUE(hUICfg) == UI_SCODE_STO_CR)
      {
        pSPD = pMCT->pSpeedSensorAux;
      }
      if (pSPD != MC_NULL)
      {
        bRetVal = STO_CR_GetEstimatedCurrent((STO_CR_Handle_t*)pSPD).alpha;
      }
    }
    break;

    case MC_PROTOCOL_REG_OBS_CR_I_BETA:
    {
      uint32_t hUICfg = pHandle->pUICfg[pHandle->bSelectedDrive];
      SpeednPosFdbk_Handle_t* pSPD = MC_NULL;
      if (MAIN_SCFG_VALUE(hUICfg) == UI_SCODE_STO_CR)
      {
        pSPD = pMCT->pSpeedSensorMain;
      }
      if (AUX_SCFG_VALUE(hUICfg) == UI_SCODE_STO_CR)
      {
        pSPD = pMCT->pSpeedSensorAux;
      }
      if (pSPD != MC_NULL)
      {
        bRetVal = STO_CR_GetEstimatedCurrent((STO_CR_Handle_t*)pSPD).beta;
      }
    }
    break;

    case MC_PROTOCOL_REG_OBS_CR_BEMF_ALPHA:
    {
      uint32_t hUICfg = pHandle->pUICfg[pHandle->bSelectedDrive];
      SpeednPosFdbk_Handle_t* pSPD = MC_NULL;
      if (MAIN_SCFG_VALUE(hUICfg) == UI_SCODE_STO_CR)
      {
        pSPD = pMCT->pSpeedSensorMain;
      }
      if (AUX_SCFG_VALUE(hUICfg) == UI_SCODE_STO_CR)
      {
        pSPD = pMCT->pSpeedSensorAux;
      }
      if (pSPD != MC_NULL)
      {
        bRetVal = STO_CR_GetEstimatedBemf((STO_CR_Handle_t*)pSPD).alpha;
      }
    }
    break;

    case MC_PROTOCOL_REG_OBS_CR_BEMF_BETA:
    {
      uint32_t hUICfg = pHandle->pUICfg[pHandle->bSelectedDrive];
      SpeednPosFdbk_Handle_t* pSPD = MC_NULL;
      if (MAIN_SCFG_VALUE(hUICfg) == UI_SCODE_STO_CR)
      {
        pSPD = pMCT->pSpeedSensorMain;
      }
      if (AUX_SCFG_VALUE(hUICfg) == UI_SCODE_STO_CR)
      {
        pSPD = pMCT->pSpeedSensorAux;
      }
      if (pSPD != MC_NULL)
      {
        bRetVal = STO_CR_GetEstimatedBemf((STO_CR_Handle_t*)pSPD).beta;
      }
    }
    break;

    case MC_PROTOCOL_REG_EST_CR_BEMF_LEVEL:
    {
      uint32_t hUICfg = pHandle->pUICfg[pHandle->bSelectedDrive];
      SpeednPosFdbk_Handle_t* pSPD = MC_NULL;
      if (MAIN_SCFG_VALUE(hUICfg) == UI_SCODE_STO_CR)
      {
        pSPD = pMCT->pSpeedSensorMain;
      }
      if (AUX_SCFG_VALUE(hUICfg) == UI_SCODE_STO_CR)
      {
        pSPD = pMCT->pSpeedSensorAux;
      }
      if (pSPD != MC_NULL)
      {
        bRetVal = STO_CR_GetEstimatedBemfLevel((STO_CR_Handle_t*)pSPD) >> 16;
      }
    }
    break;

    case MC_PROTOCOL_REG_OBS_CR_BEMF_LEVEL:
    {
      uint32_t hUICfg = pHandle->pUICfg[pHandle->bSelectedDrive];
      SpeednPosFdbk_Handle_t* pSPD = MC_NULL;
      if (MAIN_SCFG_VALUE(hUICfg) == UI_SCODE_STO_CR)
      {
        pSPD = pMCT->pSpeedSensorMain;
      }
      if (AUX_SCFG_VALUE(hUICfg) == UI_SCODE_STO_CR)
      {
        pSPD = pMCT->pSpeedSensorAux;
      }
      if (pSPD != MC_NULL)
      {
        bRetVal = STO_CR_GetObservedBemfLevel((STO_CR_Handle_t*)pSPD) >> 16;
      }
    }
    break;
		</#if>

		<#-- State Observer + PLL feature usage -->
		<#if MC.STATE_OBSERVER_PLL==true || MC.STATE_OBSERVER_PLL2==true || MC.AUX_STATE_OBSERVER_PLL==true || MC.AUX_STATE_OBSERVER_PLL2==true>
    case MC_PROTOCOL_REG_OBSERVER_C1:
    {
      uint32_t hUICfg = pHandle->pUICfg[pHandle->bSelectedDrive];
      SpeednPosFdbk_Handle_t* pSPD = MC_NULL;
      int16_t hC1,hC2;
      if (MAIN_SCFG_VALUE(hUICfg) == UI_SCODE_STO_PLL)
      {
        pSPD = pMCT->pSpeedSensorMain;
      }
      if (AUX_SCFG_VALUE(hUICfg) == UI_SCODE_STO_PLL)
      {
        pSPD = pMCT->pSpeedSensorAux;
      }
      if (pSPD != MC_NULL)
      {
        STO_PLL_GetObserverGains((STO_PLL_Handle_t*)pSPD,&hC1,&hC2);
      }
      bRetVal = (int32_t)hC1;
    }
    break;

    case MC_PROTOCOL_REG_OBSERVER_C2:
    {
      uint32_t hUICfg = pHandle->pUICfg[pHandle->bSelectedDrive];
      SpeednPosFdbk_Handle_t* pSPD = MC_NULL;
      int16_t hC1,hC2;
      if (MAIN_SCFG_VALUE(hUICfg) == UI_SCODE_STO_PLL)
      {
        pSPD = pMCT->pSpeedSensorMain;
      }
      if (AUX_SCFG_VALUE(hUICfg) == UI_SCODE_STO_PLL)
      {
        pSPD = pMCT->pSpeedSensorAux;
      }
      if (pSPD != MC_NULL)
      {
        STO_PLL_GetObserverGains((STO_PLL_Handle_t*)pSPD,&hC1,&hC2);
      }
      bRetVal = (int32_t)hC2;
    }
    break;

    case MC_PROTOCOL_REG_OBS_EL_ANGLE:
    {
      uint32_t hUICfg = pHandle->pUICfg[pHandle->bSelectedDrive];
      SpeednPosFdbk_Handle_t* pSPD = MC_NULL;
      if (MAIN_SCFG_VALUE(hUICfg) == UI_SCODE_STO_PLL)
      {
        pSPD = pMCT->pSpeedSensorMain;
      }
      if (AUX_SCFG_VALUE(hUICfg) == UI_SCODE_STO_PLL)
      {
        pSPD = pMCT->pSpeedSensorAux;
      }
      if (pSPD != MC_NULL)
      {
        bRetVal = SPD_GetElAngle(pSPD);
      }
    }
    break;

    case MC_PROTOCOL_REG_PLL_KP:
    {
      uint32_t hUICfg = pHandle->pUICfg[pHandle->bSelectedDrive];
      SpeednPosFdbk_Handle_t* pSPD = MC_NULL;
      int16_t hPgain, hIgain;
      if (MAIN_SCFG_VALUE(hUICfg) == UI_SCODE_STO_PLL)
      {
        pSPD = pMCT->pSpeedSensorMain;
      }
      if (AUX_SCFG_VALUE(hUICfg) == UI_SCODE_STO_PLL)
      {
        pSPD = pMCT->pSpeedSensorAux;
      }
      if (pSPD != MC_NULL)
      {
        STO_GetPLLGains((STO_PLL_Handle_t*)pSPD,&hPgain,&hIgain);
      }
      bRetVal = (int32_t)hPgain;
    }
    break;

    case MC_PROTOCOL_REG_PLL_KI:
    {
      uint32_t hUICfg = pHandle->pUICfg[pHandle->bSelectedDrive];
      SpeednPosFdbk_Handle_t* pSPD = MC_NULL;
      int16_t hPgain, hIgain;
      if (MAIN_SCFG_VALUE(hUICfg) == UI_SCODE_STO_PLL)
      {
        pSPD = pMCT->pSpeedSensorMain;
      }
      if (AUX_SCFG_VALUE(hUICfg) == UI_SCODE_STO_PLL)
      {
        pSPD = pMCT->pSpeedSensorAux;
      }
      if (pSPD != MC_NULL)
      {
        STO_GetPLLGains((STO_PLL_Handle_t*)pSPD,&hPgain,&hIgain);
      }
      bRetVal = (int32_t)hIgain;
    }
    break;

    case MC_PROTOCOL_REG_OBS_ROT_SPEED:
    {
      uint32_t hUICfg = pHandle->pUICfg[pHandle->bSelectedDrive];
      SpeednPosFdbk_Handle_t* pSPD = MC_NULL;
      if (MAIN_SCFG_VALUE(hUICfg) == UI_SCODE_STO_PLL)
      {
        pSPD = pMCT->pSpeedSensorMain;
      }
      if (AUX_SCFG_VALUE(hUICfg) == UI_SCODE_STO_PLL)
      {
        pSPD = pMCT->pSpeedSensorAux;
      }
      if (pSPD != MC_NULL)
      {
        bRetVal = SPD_GetS16Speed(pSPD);
      }
    }
    break;

    case MC_PROTOCOL_REG_OBS_I_ALPHA:
    {
      uint32_t hUICfg = pHandle->pUICfg[pHandle->bSelectedDrive];
      SpeednPosFdbk_Handle_t* pSPD = MC_NULL;
      if (MAIN_SCFG_VALUE(hUICfg) == UI_SCODE_STO_PLL)
      {
        pSPD = pMCT->pSpeedSensorMain;
      }
      if (AUX_SCFG_VALUE(hUICfg) == UI_SCODE_STO_PLL)
      {
        pSPD = pMCT->pSpeedSensorAux;
      }
      if (pSPD != MC_NULL)
      {
        bRetVal = STO_PLL_GetEstimatedCurrent((STO_PLL_Handle_t*)pSPD).alpha;
      }
    }
    break;

    case MC_PROTOCOL_REG_OBS_I_BETA:
    {
      uint32_t hUICfg = pHandle->pUICfg[pHandle->bSelectedDrive];
      SpeednPosFdbk_Handle_t* pSPD = MC_NULL;
      if (MAIN_SCFG_VALUE(hUICfg) == UI_SCODE_STO_PLL)
      {
        pSPD = pMCT->pSpeedSensorMain;
      }
      if (AUX_SCFG_VALUE(hUICfg) == UI_SCODE_STO_PLL)
      {
        pSPD = pMCT->pSpeedSensorAux;
      }
      if (pSPD != MC_NULL)
      {
        bRetVal = STO_PLL_GetEstimatedCurrent((STO_PLL_Handle_t*)pSPD).beta;
      }
    }
    break;

    case MC_PROTOCOL_REG_OBS_BEMF_ALPHA:
    {
      uint32_t hUICfg = pHandle->pUICfg[pHandle->bSelectedDrive];
      SpeednPosFdbk_Handle_t* pSPD = MC_NULL;
      if (MAIN_SCFG_VALUE(hUICfg) == UI_SCODE_STO_PLL)
      {
        pSPD = pMCT->pSpeedSensorMain;
      }
      if (AUX_SCFG_VALUE(hUICfg) == UI_SCODE_STO_PLL)
      {
        pSPD =  pMCT->pSpeedSensorAux;
      }
      if (pSPD != MC_NULL)
      {
        bRetVal = STO_PLL_GetEstimatedBemf((STO_PLL_Handle_t*)pSPD).alpha;
      }
    }
    break;

    case MC_PROTOCOL_REG_OBS_BEMF_BETA:
    {
      uint32_t hUICfg = pHandle->pUICfg[pHandle->bSelectedDrive];
      SpeednPosFdbk_Handle_t* pSPD = MC_NULL;
      if (MAIN_SCFG_VALUE(hUICfg) == UI_SCODE_STO_PLL)
      {
       pSPD = pMCT->pSpeedSensorMain;
      }
      if (AUX_SCFG_VALUE(hUICfg) == UI_SCODE_STO_PLL)
      {
        pSPD = pMCT->pSpeedSensorAux;
      }
      if (pSPD != MC_NULL)
      {
        bRetVal = STO_PLL_GetEstimatedBemf((STO_PLL_Handle_t*)pSPD).beta;
      }
    }
    break;

    case MC_PROTOCOL_REG_EST_BEMF_LEVEL:
    {
      uint32_t hUICfg = pHandle->pUICfg[pHandle->bSelectedDrive];
      SpeednPosFdbk_Handle_t* pSPD = MC_NULL;
      if (MAIN_SCFG_VALUE(hUICfg) == UI_SCODE_STO_PLL)
      {
        pSPD = pMCT->pSpeedSensorMain;
      }
      if (AUX_SCFG_VALUE(hUICfg) == UI_SCODE_STO_PLL)
      {
        pSPD = pMCT->pSpeedSensorAux;
      }
      if (pSPD != MC_NULL)
      {
        bRetVal = STO_PLL_GetEstimatedBemfLevel((STO_PLL_Handle_t*)pSPD) >> 16;
      }
    }
    break;

    case MC_PROTOCOL_REG_OBS_BEMF_LEVEL:
    {
      uint32_t hUICfg = pHandle->pUICfg[pHandle->bSelectedDrive];
      SpeednPosFdbk_Handle_t* pSPD = MC_NULL;
      if (MAIN_SCFG_VALUE(hUICfg) == UI_SCODE_STO_PLL)
      {
        pSPD = pMCT->pSpeedSensorMain;
      }
      if (AUX_SCFG_VALUE(hUICfg) == UI_SCODE_STO_PLL)
      {
        pSPD = pMCT->pSpeedSensorAux;
      }
      if (pSPD != MC_NULL)
      {
        bRetVal = STO_PLL_GetObservedBemfLevel((STO_PLL_Handle_t*)pSPD) >> 16;
      }
    }
    break;
		</#if>

		<#-- Flux Weakening feature usage -->
		<#if MC.FLUX_WEAKENING_ENABLING==true || MC.FLUX_WEAKENING_ENABLING2==true>
    case MC_PROTOCOL_REG_FLUXWK_KP:
    {
      bRetVal = PID_GetKP(pMCT->pPIDFluxWeakening);
    }
    break;

    case MC_PROTOCOL_REG_FLUXWK_KI:
    {
      bRetVal = PID_GetKI(pMCT->pPIDFluxWeakening);
    }
    break;

    case MC_PROTOCOL_REG_FLUXWK_BUS:
    {
      if (pMCT->pFW)
      {
        bRetVal = (int32_t)FW_GetVref(pMCT->pFW);
      }
    }
    break;

    case MC_PROTOCOL_REG_FLUXWK_BUS_MEAS:
    {
      if (pMCT->pFW)
      {
        bRetVal = ((int32_t)FW_GetAvVPercentage(pMCT->pFW));
      }
    }
    break;
		</#if>

    case MC_PROTOCOL_REG_MOTOR_POWER:
    {
      bRetVal = MPM_GetAvrgElMotorPowerW(pMCT->pMPM);
    }
    break;

		<#-- DAC usage for monitoring -->
		<#if MC.DAC_FUNCTIONALITY==true>
    case MC_PROTOCOL_REG_DAC_OUT1:
    {
      MC_Protocol_REG_t value = UI_GetDAC(pHandle, DAC_CH0);
      bRetVal = value;
    }
    break;

    case MC_PROTOCOL_REG_DAC_OUT2:
    {
      MC_Protocol_REG_t value = UI_GetDAC(pHandle, DAC_CH1);
      bRetVal = value;
    }
    break;

    case MC_PROTOCOL_REG_DAC_USER1:
    {
      if (pHandle->pFctDACGetUserChannelValue)
      {
        bRetVal = (int32_t) pHandle->pFctDACGetUserChannelValue(pHandle, 0);
      }
      else
      {
        bRetVal = (uint32_t) 0;
      }
    }
    break;

    case MC_PROTOCOL_REG_DAC_USER2:
    {
      if (pHandle->pFctDACGetUserChannelValue)
      {
        bRetVal = (int32_t) pHandle->pFctDACGetUserChannelValue(pHandle, 1);
      }
      else
      {
        bRetVal = (uint32_t) 0;
      }
    }
    break;
		</#if>

		<#-- Position sensors feature usage -->
		<#if MC.AUX_ENCODER==true || MC.AUX_ENCODER2==true || MC.ENCODER==true || MC.ENCODER2==true ||
		 MC.AUX_HALL_SENSORS==true || MC.AUX_HALL_SENSORS2==true || MC.HALL_SENSORS==true || MC.HALL_SENSORS2==true>
    case MC_PROTOCOL_REG_MEAS_EL_ANGLE:
    {
      uint32_t hUICfg = pHandle->pUICfg[pHandle->bSelectedDrive];
      SpeednPosFdbk_Handle_t* pSPD = MC_NULL;
      if ((MAIN_SCFG_VALUE(hUICfg) == UI_SCODE_ENC) ||
          (MAIN_SCFG_VALUE(hUICfg) == UI_SCODE_HALL))
      {
        pSPD = pMCT->pSpeedSensorMain;
      }
      if ((AUX_SCFG_VALUE(hUICfg) == UI_SCODE_ENC) ||
          (AUX_SCFG_VALUE(hUICfg) == UI_SCODE_HALL))
      {
        pSPD = pMCT->pSpeedSensorAux;
      }
      if (pSPD != MC_NULL)
      {
        bRetVal = SPD_GetElAngle(pSPD);
      }
    }
    break;

    case MC_PROTOCOL_REG_MEAS_ROT_SPEED:
    {
      uint32_t hUICfg = pHandle->pUICfg[pHandle->bSelectedDrive];
      SpeednPosFdbk_Handle_t* pSPD = MC_NULL;
      if ((MAIN_SCFG_VALUE(hUICfg) == UI_SCODE_ENC) ||
          (MAIN_SCFG_VALUE(hUICfg) == UI_SCODE_HALL))
      {
        pSPD = pMCT->pSpeedSensorMain;
      }
      if ((AUX_SCFG_VALUE(hUICfg) == UI_SCODE_ENC) ||
          (AUX_SCFG_VALUE(hUICfg) == UI_SCODE_HALL))
      {
        pSPD = pMCT->pSpeedSensorAux;
      }
      if (pSPD != MC_NULL)
      {
        bRetVal = SPD_GetS16Speed(pSPD);
      }
    }
    break;
		</#if>

    <#-- Position Control registers handling -->
    <#if MC.POSITION_CTRL_ENABLING == true || MC.POSITION_CTRL_ENABLING2 == true>
    case MC_PROTOCOL_REG_CURRENT_POSITION:
      {
        FloatToU32 ReadVal;
        ReadVal.Float_Val = TC_GetCurrentPosition(pMCT->pPosCtrl);
        bRetVal = ReadVal.U32_Val;
      }
      break;
    case MC_PROTOCOL_REG_TARGET_POSITION:
      {
        FloatToU32 ReadVal;
        ReadVal.Float_Val = TC_GetTargetPosition(pMCT->pPosCtrl);
        bRetVal = ReadVal.U32_Val;
      }
      break;
    case MC_PROTOCOL_REG_MOVE_DURATION:
      {
        FloatToU32 ReadVal;
        ReadVal.Float_Val = TC_GetMoveDuration(pMCT->pPosCtrl);
        bRetVal = ReadVal.U32_Val;
      }
      break;
      
      case MC_PROTOCOL_REG_POSITION_KP:
      bRetVal = (int32_t) PID_GetKP( pMCT->pPosCtrl->PIDPosRegulator );
      break;
      
      case MC_PROTOCOL_REG_POSITION_KI:
      bRetVal = (int32_t) PID_GetKI( pMCT->pPosCtrl->PIDPosRegulator );
      break;
      
      case MC_PROTOCOL_REG_POSITION_KD:
      bRetVal = (int32_t) PID_GetKD( pMCT->pPosCtrl->PIDPosRegulator );
      break;
    </#if>

		<#-- High Frequency Injection feature usage -->
		<#if MC.HFINJECTION==true || MC.HFINJECTION2==true>
    case MC_PROTOCOL_REG_HFI_EL_ANGLE:
    {
      uint32_t hUICfg = pHandle->pUICfg[pHandle->bSelectedDrive];
      SpeednPosFdbk_Handle_t* pSPD = MC_NULL;
      if (MAIN_SCFG_VALUE(hUICfg) == UI_SCODE_HFINJ)
      {
        pSPD = pMCT->pSpeedSensorMain;
      }
      if (pSPD != MC_NULL)
      {
        bRetVal = SPD_GetElAngle(pSPD);
      }
    }
    break;

    case MC_PROTOCOL_REG_HFI_ROT_SPEED:
    {
      uint32_t hUICfg = pHandle->pUICfg[pHandle->bSelectedDrive];
      SpeednPosFdbk_Handle_t* pSPD = MC_NULL;
      if (MAIN_SCFG_VALUE(hUICfg) == UI_SCODE_HFINJ)
      {
        pSPD = pMCT->pSpeedSensorMain;
      }
      if (pSPD != MC_NULL)
      {
        bRetVal = SPD_GetS16Speed(pSPD);
      }
    }
    break;

    case MC_PROTOCOL_REG_HFI_CURRENT:
    {
      uint32_t hUICfg = pHandle->pUICfg[pHandle->bSelectedDrive];
      HFI_FP_Ctrl_Handle_t* pHFI;
      if (MAIN_SCFG_VALUE(hUICfg) == UI_SCODE_HFINJ)
      {
        pHFI = pMCT->pHFI;
      }
      if (pHFI != MC_NULL)
      {
        bRetVal = HFI_FP_GetCurrent(pHFI);
      }
    }
    break;

    case MC_PROTOCOL_REG_HFI_INIT_ANG_PLL:
    {
      uint32_t hUICfg = pHandle->pUICfg[pHandle->bSelectedDrive];
      HFI_FP_Ctrl_Handle_t* pHFI;
      if (MAIN_SCFG_VALUE(hUICfg) == UI_SCODE_HFINJ)
      {
        pHFI = pMCT->pHFI;
      }
      if (pHFI != MC_NULL)
      {
        bRetVal = HFI_FP_GetRotorAngleLock(pHFI);
      }
    }
    break;

    case MC_PROTOCOL_REG_HFI_INIT_ANG_SAT_DIFF:
    {
      uint32_t hUICfg = pHandle->pUICfg[pHandle->bSelectedDrive];
      HFI_FP_Ctrl_Handle_t* pHFI;
      if (MAIN_SCFG_VALUE(hUICfg) == UI_SCODE_HFINJ)
      {
        pHFI = pMCT->pHFI;
      }
      if (pHFI != MC_NULL)
      {
        bRetVal = HFI_FP_GetSaturationDifference(pHFI);
      }
    }
    break;

    case MC_PROTOCOL_REG_HFI_PI_TRACK_KP:
    {
      uint32_t hUICfg = pHandle->pUICfg[pHandle->bSelectedDrive];
      HFI_FP_Ctrl_Handle_t* pHFI;
      if (MAIN_SCFG_VALUE(hUICfg) == UI_SCODE_HFINJ)
      {
        pHFI = pMCT->pHFI;
      }
      if (pHFI != MC_NULL)
      {
        pPID = HFI_FP_GetPITrack(pHFI);
        bRetVal = PID_GetKP(pPID);
      }
    }
    break;

    case MC_PROTOCOL_REG_HFI_PI_TRACK_KI:
    {
      uint32_t hUICfg = pHandle->pUICfg[pHandle->bSelectedDrive];
      HFI_FP_Ctrl_Handle_t* pHFI;
      if (MAIN_SCFG_VALUE(hUICfg) == UI_SCODE_HFINJ)
      {
        pHFI = pMCT->pHFI;
      }
      if (pHFI != MC_NULL)
      {
        pPID = HFI_FP_GetPITrack(pHFI);
        bRetVal = PID_GetKI(pPID);
      }
    }
    break;
		</#if>

		<#-- Feed Forward feature usage -->
		<#if MC.FEED_FORWARD_CURRENT_REG_ENABLING==true || MC.FEED_FORWARD_CURRENT_REG_ENABLING2==true>
    case MC_PROTOCOL_REG_FF_1Q:
    {
      bRetVal = FF_GetFFConstants(pMCT->pFF).wConst_1Q;
    }
    break;

    case MC_PROTOCOL_REG_FF_1D:
    {
      bRetVal = FF_GetFFConstants(pMCT->pFF).wConst_1D;
    }
    break;

   case MC_PROTOCOL_REG_FF_2:
    {
      bRetVal = FF_GetFFConstants(pMCT->pFF).wConst_2;
    }
    break;

    case MC_PROTOCOL_REG_FF_VQ:
    {
      bRetVal = FF_GetVqdff(pMCT->pFF).q;
    }
    break;

    case MC_PROTOCOL_REG_FF_VD:
    {
      bRetVal = FF_GetVqdff(pMCT->pFF).d;
    }
    break;

    case MC_PROTOCOL_REG_FF_VQ_PIOUT:
    {
      bRetVal = FF_GetVqdAvPIout(pMCT->pFF).q;
    }
    break;

    case MC_PROTOCOL_REG_FF_VD_PIOUT:
    {
      bRetVal = FF_GetVqdAvPIout(pMCT->pFF).d;
    }
    break;
		</#if>

    case MC_PROTOCOL_REG_MAX_APP_SPEED:
    {
      bRetVal = (STC_GetMaxAppPositiveMecSpeedUnit(pMCT->pSpeednTorqueCtrl) * _RPM)/SPEED_UNIT ;
    }
    break;

    case MC_PROTOCOL_REG_MIN_APP_SPEED:
    {
      bRetVal = (STC_GetMinAppNegativeMecSpeedUnit(pMCT->pSpeednTorqueCtrl)  * _RPM)/SPEED_UNIT ;
    }
    break;

    case MC_PROTOCOL_REG_TORQUE_MEAS:
    case MC_PROTOCOL_REG_I_Q:
    {
      bRetVal = MCI_GetIqd(pMCI).q;
    }
    break;

    case MC_PROTOCOL_REG_FLUX_MEAS:
    case MC_PROTOCOL_REG_I_D:
    {
      bRetVal = MCI_GetIqd(pMCI).d;
    }
    break;

    case MC_PROTOCOL_REG_RUC_STAGE_NBR:
    {
      if (pMCT->pRevupCtrl)
      {
        bRetVal = (int32_t)RUC_GetNumberOfPhases(pMCT->pRevupCtrl);
      }
      else
      {
        bRetVal = (uint32_t) 0;
      }
    }
    break;

    case MC_PROTOCOL_REG_I_A:
    {
      bRetVal = MCI_GetIab(pMCI).a;
    }
    break;

    case MC_PROTOCOL_REG_I_B:
    {
      bRetVal = MCI_GetIab(pMCI).b;
    }
    break;

    case MC_PROTOCOL_REG_I_ALPHA:
    {
      bRetVal = MCI_GetIalphabeta(pMCI).alpha;
    }
    break;

    case MC_PROTOCOL_REG_I_BETA:
    {
      bRetVal = MCI_GetIalphabeta(pMCI).beta;
    }
    break;

    case MC_PROTOCOL_REG_I_Q_REF:
    {
      bRetVal = MCI_GetIqdref(pMCI).q;
    }
    break;

    case MC_PROTOCOL_REG_I_D_REF:
    {
      bRetVal = MCI_GetIqdref(pMCI).d;
    }
    break;

    case MC_PROTOCOL_REG_V_Q:
    {
      bRetVal = MCI_GetVqd(pMCI).q;
    }
    break;

    case MC_PROTOCOL_REG_V_D:
    {
      bRetVal = MCI_GetVqd(pMCI).d;
    }
    break;

   case MC_PROTOCOL_REG_V_ALPHA:
    {
      bRetVal = MCI_GetValphabeta(pMCI).alpha;
    }
    break;

    case MC_PROTOCOL_REG_V_BETA:
    {
      bRetVal = MCI_GetValphabeta(pMCI).beta;
    }
    break;

		<#-- PFC feature usage -->
		<#if MC.PFC_ENABLED==true>
    case MC_PROTOCOL_REG_PFC_STATUS:
    {
      STM_Handle_t *pSTM = PFC_GetStateMachine( &PFC );
      bRetVal = (int32_t)STM_GetState(pSTM);
    }
    break;

    case MC_PROTOCOL_REG_PFC_FAULTS:
    {
      STM_Handle_t *pSTM = PFC_GetStateMachine( &PFC );
      bRetVal = (int32_t)STM_GetFaultState(pSTM);
    }
    break;

    case MC_PROTOCOL_REG_PFC_DCBUS_REF:
    {
      bRetVal = (int32_t)PFC_GetBoostVoltageReference( &PFC );
    }
    break;

    case MC_PROTOCOL_REG_PFC_DCBUS_MEAS:
    {
      bRetVal = (int32_t)PFC_GetAvBusVoltage_V( &PFC );
    }
    break;

    case MC_PROTOCOL_REG_PFC_ACBUS_FREQ:
    {
      bRetVal = (int32_t)PFC_GetMainsFrequency( &PFC );
    }
    break;

    case MC_PROTOCOL_REG_PFC_ACBUS_RMS:
    {
      bRetVal = (int32_t)PFC_GetMainsVoltage( &PFC );
    }
    break;

    case MC_PROTOCOL_REG_PFC_I_KP:
    {
      pPID = PFC_GetCurrentLoopPI( &PFC );
      bRetVal = (int32_t)PID_GetKP(pPID);
    }
    break;

    case MC_PROTOCOL_REG_PFC_I_KI:
    {
      pPID = PFC_GetCurrentLoopPI( &PFC );
      bRetVal = (int32_t)PID_GetKI(pPID);
    }
    break;

    case MC_PROTOCOL_REG_PFC_I_KD:
    {
      uint32_t hUICfg = pHandle->pUICfg[pHandle->bSelectedDrive];
      if ((hUICfg & UI_CFGOPT_PFC_I_KD) != 0u)
      {
        pPID = PFC_GetCurrentLoopPI( &PFC );
        bRetVal = (int32_t)PID_GetKD( pPID );
      }
    }
    break;

    case MC_PROTOCOL_REG_PFC_V_KP:
    {
      pPID = PFC_GetVoltageLoopPI( &PFC );
      bRetVal = (int32_t)PID_GetKP(pPID);
    }
    break;

    case MC_PROTOCOL_REG_PFC_V_KI:
    {
      pPID = PFC_GetVoltageLoopPI( &PFC );
      bRetVal = (int32_t)PID_GetKI(pPID);
    }
    break;

    case MC_PROTOCOL_REG_PFC_V_KD:
    {
      uint32_t hUICfg = pHandle->pUICfg[pHandle->bSelectedDrive];
      if ((hUICfg & UI_CFGOPT_PFC_V_KD) != 0u)
      {
        pPID = PFC_GetVoltageLoopPI( &PFC );
        bRetVal = (int32_t)PID_GetKD( pPID );
      }
    }
    break;

    case MC_PROTOCOL_REG_PFC_STARTUP_DURATION:
    {
      bRetVal = (int32_t)PFC_GetStartUpDuration( &PFC );
    }
    break;

    case MC_PROTOCOL_REG_PFC_ENABLED:
    {
      bRetVal = (int32_t)PFC_IsEnabled( &PFC );
    }
    break;
		</#if>

		<#-- Motor Profiler feature usage -->
		<#if MC.MOTOR_PROFILER==true>
  case MC_PROTOCOL_REG_SC_CHECK:
    {
      bRetVal = 1;
    }
    break;

  case MC_PROTOCOL_REG_SC_STATE:
    {
      uint8_t state = 0;
      if (pMCT->pSCC != MC_NULL)
      {
        state += SCC_GetState(pMCT->pSCC);
      }
      if (pMCT->pOTT != MC_NULL)
      {
        state += OTT_GetState(pMCT->pOTT);
      }
      bRetVal = (int32_t)(state);
    }
    break;

  case MC_PROTOCOL_REG_SC_STEPS:
    {
      uint8_t state = 0;
      if (pMCT->pSCC != MC_NULL)
      {
        state += SCC_GetSteps(pMCT->pSCC);
      }
      if (pMCT->pOTT != MC_NULL)
      {
        state += OTT_GetSteps(pMCT->pOTT);
      }
      bRetVal = (int32_t)(state - 1u);
    }
    break;

  case MC_PROTOCOL_REG_SC_RS:
    {
      if (pMCT->pSCC != MC_NULL)
      {
        bRetVal = SCC_GetRs(pMCT->pSCC);
      }
    }
    break;

  case MC_PROTOCOL_REG_SC_LS:
    {
      if (pMCT->pSCC != MC_NULL)
      {
        bRetVal = SCC_GetLs(pMCT->pSCC);
      }
    }
    break;

  case MC_PROTOCOL_REG_SC_KE:
    {
      if (pMCT->pSCC != MC_NULL)
      {
        bRetVal = SCC_GetKe(pMCT->pSCC);
      }
    }
    break;

  case MC_PROTOCOL_REG_SC_VBUS:
    {
      if (pMCT->pSCC != MC_NULL)
      {
        bRetVal = SCC_GetVbus(pMCT->pSCC);
      }
    }
    break;

  case MC_PROTOCOL_REG_SC_MEAS_NOMINALSPEED:
    {
      if (pMCT->pOTT != MC_NULL)
      {
        bRetVal = OTT_GetNominalSpeed(pMCT->pOTT);
      }
    }
    break;

  case MC_PROTOCOL_REG_SC_PP:
    {
      if (pMCT->pSpeedSensorMain != MC_NULL)
      {
        bRetVal = SPD_GetElToMecRatio(pMCT->pSpeedSensorMain);
      }
    }
    break;

  case MC_PROTOCOL_REG_SC_CURRENT:
    {
      if (pMCT->pSCC != MC_NULL)
      {
        bRetVal = MCM_floatToIntBit(SCC_GetNominalCurrent(pMCT->pSCC));
      }
    }
    break;

  case MC_PROTOCOL_REG_SC_SPDBANDWIDTH:
    {
      if (pMCT->pOTT != MC_NULL)
      {
        bRetVal = MCM_floatToIntBit(OTT_GetSpeedRegulatorBandwidth(pMCT->pOTT));
      }

    }
    break;

  case MC_PROTOCOL_REG_SC_LDLQRATIO:
    {
      if (pMCT->pSCC != MC_NULL)
      {
        bRetVal = MCM_floatToIntBit(SCC_GetLdLqRatio(pMCT->pSCC));
      }
    }
    break;

  case MC_PROTOCOL_REG_SC_NOMINAL_SPEED:
    {
      if (pMCT->pSCC != MC_NULL)
      {
        bRetVal = SCC_GetNominalSpeed(pMCT->pSCC);
      }
    }
    break;

  case MC_PROTOCOL_REG_SC_CURRBANDWIDTH:
    {
      if (pMCT->pSCC != MC_NULL)
      {
        bRetVal = MCM_floatToIntBit(SCC_GetCurrentBandwidth(pMCT->pSCC));
      }
    }
    break;

  case MC_PROTOCOL_REG_SC_J:
    {
      if (pMCT->pOTT != MC_NULL)
      {
        bRetVal = MCM_floatToIntBit(OTT_GetJ(pMCT->pOTT));
      }
    }
    break;

  case MC_PROTOCOL_REG_SC_F:
    {
      if (pMCT->pOTT != MC_NULL)
      {
        bRetVal = MCM_floatToIntBit(OTT_GetF(pMCT->pOTT));
      }
    }
    break;

  case MC_PROTOCOL_REG_SC_MAX_CURRENT:
    {
      if (pMCT->pSCC != MC_NULL)
      {
        bRetVal = MCM_floatToIntBit(SCC_GetStartupCurrentAmp(pMCT->pSCC));
      }
    }
    break;

  case MC_PROTOCOL_REG_SC_STARTUP_SPEED:
    {
      if (pMCT->pSCC != MC_NULL)
      {
        bRetVal = (int32_t)(SCC_GetEstMaxOLSpeed(pMCT->pSCC));
      }
    }
    break;

  case MC_PROTOCOL_REG_SC_STARTUP_ACC:
    {
      if (pMCT->pSCC != MC_NULL)
      {
        bRetVal = (int32_t)(SCC_GetEstMaxAcceleration(pMCT->pSCC));
      }
    }
    break;

  case MC_PROTOCOL_REG_SC_PWM_FREQUENCY:
    {
      if (pMCT->pSCC != MC_NULL)
      {
        bRetVal = (int32_t)SCC_GetPWMFrequencyHz(pMCT->pSCC);
      }
    }
    break;

  case MC_PROTOCOL_REG_SC_FOC_REP_RATE:
    {
      if (pMCT->pSCC != MC_NULL)
      {
        bRetVal = (int32_t)SCC_GetFOCRepRate(pMCT->pSCC);
      }
    }
    break;

  case MC_PROTOCOL_REG_SC_COMPLETED:
    {
      bRetVal = (int32_t) 0;
      if (pMCT->pOTT != MC_NULL)
      {
        bRetVal = OTT_IsMotorAlreadyProfiled(pMCT->pOTT);
      }
    }
    break;
		</#if>
	</#if><#-- MC.DRIVE_TYPE == "FOC" -->

    default:
	{
	<#if MC.DRIVE_TYPE == "FOC" ><#-- Specific to FOC algorithm usage -->
      if ( success != (bool *) 0 ) 
      {
        *success = false;
      }
	<#elseif MC.DRIVE_TYPE == "SIX_STEP"><#-- Specific to 6_STEP algorithm usage -->
      bRetVal = (int32_t) 0;
	</#if>
	}
    break;
  }
  return bRetVal;
}


/**
  * @brief  Allow to execute a command coming from the user.
  * @param  pHandle: Pointer on Handle structure of UI component.
  * @param  bCmdID: Code of command to execute.
  *         See MC_PROTOCOL_CMD_xxx for code definition.
  *  @retval Return true if the command executed succesfully, otherwise false.
*/
__weak bool UI_ExecCmd(UI_Handle_t *pHandle, uint8_t bCmdID)
{
  bool retVal = true;

	<#if MC.DRIVE_TYPE == "FOC" ><#-- Specific to FOC algorithm usage -->
  MCI_Handle_t * pMCI = pHandle->pMCI[pHandle->bSelectedDrive];
	<#elseif MC.DRIVE_TYPE == "SIX_STEP" ><#-- Specific to 6_STEP algorithm usage -->
  MC_Handle_t * pMCI = pHandle->pMCI[pHandle->bSelectedDrive];
	</#if>

  switch (bCmdID)
  {
  case MC_PROTOCOL_CMD_START_MOTOR:
    {
	<#if MC.DRIVE_TYPE == "FOC" ><#-- Specific to FOC algorithm usage -->
      /* Call MCI Start motor; */
      MCI_StartMotor(pMCI);
	<#elseif MC.DRIVE_TYPE == "SIX_STEP" ><#-- Specific to 6_STEP algorithm usage -->
      MC_Status_t mc_status = MC_Core_GetStatus( pMCI );
      if ( mc_status == MC_IDLE || mc_status == MC_STOP ) 
      {
        (void) MC_Core_Start( pMCI );
      }
	</#if>
    }
    break;

  case MC_PROTOCOL_CMD_STOP_MOTOR:
  case MC_PROTOCOL_CMD_SC_STOP:
    {
	<#if MC.DRIVE_TYPE == "FOC" ><#-- Specific to FOC algorithm usage -->
		<#if MC.MOTOR_PROFILER==true>
      MCT_Handle_t* pMCT = pHandle->pMCT[pHandle->bSelectedDrive];
      if (pMCT->pSCC)
      {
        SCC_StopProfile(pMCT->pSCC);
      }
		</#if>
      /* Call MCI Stop motor; */
      MCI_StopMotor(pMCI);
	<#elseif MC.DRIVE_TYPE == "SIX_STEP" ><#-- Specific to 6_STEP algorithm usage -->
      MC_Status_t mc_status = MC_Core_GetStatus( pMCI );
      if ( mc_status == MC_RUN ) 
      {
        (void) MC_Core_Stop( pMCI );
      }
	</#if>
    }
    break;

  case MC_PROTOCOL_CMD_STOP_RAMP:
    {
	<#if MC.DRIVE_TYPE == "FOC" ><#-- Specific to FOC algorithm usage -->
      if (MCI_GetSTMState(pMCI) == RUN)
      {
        MCI_StopRamp(pMCI);
      }
	<#elseif MC.DRIVE_TYPE == "SIX_STEP" ><#-- Specific to 6_STEP algorithm usage -->
      MC_Status_t mc_status = MC_Core_GetStatus( pMCI );
      if ( mc_status == MC_RUN ) 
      {
        (void) MC_Core_Stop( pMCI );
      }
	</#if>
    }
    break;

  case MC_PROTOCOL_CMD_PING:
    {
	  /* Do nothing at the moment */
    }
    break;

  case MC_PROTOCOL_CMD_START_STOP:
    {
	<#if MC.DRIVE_TYPE == "FOC" ><#-- Specific to FOC algorithm usage -->
      /* Queries the STM and a command start or stop depending on the state. */
      if (MCI_GetSTMState(pMCI) == IDLE)
      {
        MCI_StartMotor(pMCI);
      }
      else
      {
        MCI_StopMotor(pMCI);
      }
	<#elseif MC.DRIVE_TYPE == "SIX_STEP" ><#-- Specific to 6_STEP algorithm usage -->
      MC_Status_t mc_status = MC_Core_GetStatus( pMCI );
      if ( mc_status == MC_IDLE || mc_status == MC_STOP ) 
      {
        (void) MC_Core_Start( pMCI );
      }
      else if ( mc_status == MC_RUN ) 
      {
        (void) MC_Core_Stop( pMCI );
      }
	</#if>
    }
    break;

  case MC_PROTOCOL_CMD_RESET:
    {
	<#if MC.DRIVE_TYPE == "FOC" ><#-- Specific to FOC algorithm usage -->
	  /* Do nothing at the moment */
	<#elseif MC.DRIVE_TYPE == "SIX_STEP" ><#-- Specific to 6_STEP algorithm usage -->
        (void) MC_Core_Reset( pMCI );
	</#if>
    }
    break;

  case MC_PROTOCOL_CMD_FAULT_ACK:
    {
	<#if MC.DRIVE_TYPE == "FOC" ><#-- Specific to FOC algorithm usage -->
      MCI_FaultAcknowledged(pMCI);
	<#elseif MC.DRIVE_TYPE == "SIX_STEP" ><#-- Specific to 6_STEP algorithm usage -->
      MC_Status_t mc_status = MC_Core_GetStatus( pMCI );
      if ( mc_status == MC_SPEEDFBKERROR || mc_status == MC_OVERCURRENT || mc_status == MC_VALIDATION_FAILURE ||
           mc_status == MC_VALIDATION_BEMF_FAILURE || mc_status == MC_VALIDATION_HALL_FAILURE || 
		   mc_status == MC_ADC_CALLBACK_FAILURE || mc_status == MC_LF_TIMER_FAILURE )
      {
        /* This call transitions the state to MC_STOP. Not an error state anymore and ready to start again. */
        (void) MC_Core_Stop( pMCI );
      }
	</#if>
    }
    break;

  case MC_PROTOCOL_CMD_ENCODER_ALIGN:
    {
	<#if MC.DRIVE_TYPE == "FOC" ><#-- Specific to FOC algorithm usage -->
      MCI_EncoderAlign(pMCI);
	<#elseif MC.DRIVE_TYPE == "SIX_STEP" ><#-- Specific to 6_STEP algorithm usage -->
	  /* Do nothing at the moment */
	</#if>
    }
    break;

  case MC_PROTOCOL_CMD_IQDREF_CLEAR:
    {
	<#if MC.DRIVE_TYPE == "FOC" ><#-- Specific to FOC algorithm usage -->
      MCI_Clear_Iqdref(pMCI);
	<#elseif MC.DRIVE_TYPE == "SIX_STEP" ><#-- Specific to 6_STEP algorithm usage -->
	  /* Do nothing at the moment */
	</#if>
    }
    break;

	<#-- PFC feature usage -->
	<#if MC.PFC_ENABLED==true>
  case MC_PROTOCOL_CMD_PFC_ENABLE:
    {
      if ((pHandle->pUICfg[pHandle->bSelectedDrive] & UI_CFGOPT_PFC) == 0u)
      {
        // No PFC configured
        retVal = false;
      }
      else
      {
        PFC_Enable( &PFC );
      }
    }
    break;

  case MC_PROTOCOL_CMD_PFC_DISABLE:
    {
      if ((pHandle->pUICfg[pHandle->bSelectedDrive] & UI_CFGOPT_PFC) == 0u)
      {
        // No PFC configured
        retVal = false;
      }
      else
      {
        PFC_Disable( &PFC );
      }
    }
    break;

  case MC_PROTOCOL_CMD_PFC_FAULT_ACK:
    {
      if ((pHandle->pUICfg[pHandle->bSelectedDrive] & UI_CFGOPT_PFC) == 0u)
      {
        // No PFC configured
        retVal = false;
      }
      else
      {
        PFC_AcknowledgeFaults( &PFC );
      }
    }
    break;
	</#if>

	<#-- Motor Profiler feature usage -->
	<#if MC.MOTOR_PROFILER==true>
  case MC_PROTOCOL_CMD_SC_START:
    {
      MCT_Handle_t* pMCT = pHandle->pMCT[pHandle->bSelectedDrive];
      if (pMCT->pSCC)
      {
        SCC_ForceProfile(pMCT->pSCC);
      }
      if (pMCT->pOTT)
      {
        OTT_ForceTuning(pMCT->pOTT);
      }
      MCI_FaultAcknowledged(pMCI);
      MCI_StartMotor(pMCI);
    }
    break;
	</#if>

  default:
    {
    retVal = false;
	}
    break;
  }
  return retVal;
}


/**
  * @brief  Allow to execute a speed ramp command coming from the user.
  * @param  pHandle: Pointer on Handle structure of UI component.
  * @param  wFinalMecSpeedUnit: Final speed value expressed in the unit defined by #SPEED_UNIT.
  * @param  hDurationms: Duration of the ramp expressed in milliseconds. 
  *         It is possible to set 0 to perform an instantaneous change in the value.
  *  @retval Return true if the command executed succesfully, otherwise false.
  */
__weak bool UI_ExecSpeedRamp(UI_Handle_t *pHandle, int32_t wFinalMecSpeedUnit, uint16_t hDurationms)
{
	<#if MC.DRIVE_TYPE == "FOC" ><#-- Specific to FOC algorithm usage -->
  MCI_Handle_t * pMCI = pHandle->pMCI[pHandle->bSelectedDrive];

  /* Call MCI Exec Ramp */
  MCI_ExecSpeedRamp(pMCI,(int16_t)((wFinalMecSpeedUnit*SPEED_UNIT)/_RPM),hDurationms);
	<#elseif MC.DRIVE_TYPE == "SIX_STEP" ><#-- Specific to 6_STEP algorithm usage -->
  MC_Handle_t * pMCI = pHandle->pMCI[pHandle->bSelectedDrive];

  if (wFinalMecSpeedUnit >= 0)
  {
    (void)MC_Core_SetDirection( pMCI, 0 );
    (void)MC_Core_SetSpeed( pMCI, wFinalMecSpeedUnit );
  }
  else
  {
    (void)MC_Core_SetDirection( pMCI, 1 );
    (void)MC_Core_SetSpeed( pMCI, (-wFinalMecSpeedUnit) );
  }
	</#if>
  return true;
}
</#if><#-- MC.DRIVE_TYPE == "FOC" || MC.SERIAL_COMMUNICATION == true -->


<#-- Specific to FOC algorithm usage -->
<#if MC.DRIVE_TYPE == "FOC" >
/**
  * @brief  It is used to execute a torque ramp command coming from the user.
  * @param  pHandle: Pointer on Handle structure of UI component.
  * @param  hTargetFinal: final torque value. See MCI interface for more
            details.
  * @param  hDurationms: the duration of the ramp expressed in milliseconds. It
  *         is possible to set 0 to perform an instantaneous change in the value.
  *  @retval Return true if the command executed succesfully, otherwise false.
  */
__weak bool UI_ExecTorqueRamp(UI_Handle_t *pHandle, int16_t hTargetFinal, uint16_t hDurationms)
{

  MCI_Handle_t * pMCI = pHandle->pMCI[pHandle->bSelectedDrive];

  /* Call MCI Exec Ramp */
  MCI_ExecTorqueRamp(pMCI,hTargetFinal,hDurationms);
  return true;
}


<#if MC.POSITION_CTRL_ENABLING == true || MC.POSITION_CTRL_ENABLING2 == true>
/**
  * @brief  It is used to execute a position command coming from the user.
  * @param  pHandle: Pointer on Handle structure of UI component.
  * @param  fTargetPosition: final position value.
  * @param  fDuration: duration alllowed to complete the positioning (expressed in seconds).
  *  @retval Return true if the command executed successfully, otherwise false.
  */
__weak bool UI_ExecPositionCmd(UI_Handle_t *pHandle, float fTargetPosition, float fDuration)
{

  MCI_Handle_t * pMCI = pHandle->pMCI[pHandle->bSelectedDrive];

  /* Call MCI Position Command */
  MCI_ExecPositionCommand(pMCI,fTargetPosition,fDuration);
  return true;
}
</#if>
/**
  * @brief  Executes a get Revup data command coming from the user
  *
  * @param  pHandle Pointer on Handle structure of UI component.
  * @param  bStage Rev up phase to be read (zero based).
  * @param  pDurationms Pointer to an uint16_t variable used to retrieve
  *         the duration of the Revup stage.
  * @param  pFinalMecSpeedUnit Pointer to an int16_t variable used to
  *         retrieve the mechanical speed at the end of that stage. Expressed in
  *         the unit defined by #SPEED_UNIT.
  * @param  pFinalTorque Pointer to an int16_t variable used to
  *         retrieve the value of motor torque at the end of that stage. 
  *         This value represents actually the Iq current expressed in digit.
  *         
  *  @retval Returns true if the command executed successfully, false otherwise.
  */
__weak bool UI_GetRevupData(UI_Handle_t *pHandle, uint8_t bStage, uint16_t* pDurationms,
                     int16_t* pFinalMecSpeedUnit, int16_t* pFinalTorque )
{
  bool hRetVal = true;

  RevUpCtrl_Handle_t *pRevupCtrl = pHandle->pMCT[pHandle->bSelectedDrive]->pRevupCtrl;
  if (pRevupCtrl)
  {
    *pDurationms = RUC_GetPhaseDurationms(pRevupCtrl, bStage);
    *pFinalMecSpeedUnit = RUC_GetPhaseFinalMecSpeedUnit(pRevupCtrl, bStage);
    *pFinalTorque = RUC_GetPhaseFinalTorque(pRevupCtrl, bStage);
  }
  else
  {
    hRetVal = false;
  }
  return hRetVal;
}


/**
  * @brief  It is used to execute a set Revup data command coming from the user.
  * @param  pHandle: Pointer on Handle structure of UI component.
  * @param  bStage: is the rev up phase, zero based, to be modified.
  * @param  hDurationms: is the new duration of the Revup stage.
  * @param  hFinalMecSpeedUnit: is the new mechanical speed at the end of that
  *         stage expressed in the unit defined by SPEED_UNIT.
  * @param  hFinalTorque: is the new value of motor torque at the end of that
  *         stage. This value represents actually the Iq current expressed in
  *         digit.
  *  @retval Return true if the command executed successfully, otherwise false.
  */
__weak bool UI_SetRevupData(UI_Handle_t *pHandle, uint8_t bStage, uint16_t hDurationms,
                     int16_t hFinalMecSpeedUnit, int16_t hFinalTorque )
{
  RevUpCtrl_Handle_t *pRevupCtrl = pHandle->pMCT[pHandle->bSelectedDrive]->pRevupCtrl;
  RUC_SetPhaseDurationms(pRevupCtrl, bStage, hDurationms);
  RUC_SetPhaseFinalMecSpeedUnit(pRevupCtrl, bStage, hFinalMecSpeedUnit);
  RUC_SetPhaseFinalTorque(pRevupCtrl, bStage, hFinalTorque);
  return true;
}


/**
  * @brief  Allow to execute a set current reference command coming from the user.
  * @param  pHandle: Pointer on Handle structure of UI component.
  * @param  hIqRef: Current Iq reference on qd reference frame. 
  *         This value is expressed in digit. 
  * @note   current convertion formula (from digit to Amps):
  *               Current(Amps) = [Current(digit) * Vdd micro] / [65536 * Rshunt * Aop]
  * @param  hIdRef: Current Id reference on qd reference frame. 
  *         This value is expressed in digit. See hIqRef param description.
  * @retval none.
  */
__weak void UI_SetCurrentReferences(UI_Handle_t *pHandle, int16_t hIqRef, int16_t hIdRef)
{

  MCI_Handle_t * pMCI = pHandle->pMCI[pHandle->bSelectedDrive];
  qd_t currComp;
  currComp.q = hIqRef;
  currComp.d = hIdRef;
  MCI_SetCurrentReferences(pMCI,currComp);
}


/**
  * @brief  Allow to get information about MP registers available for each step.
  *         PC send to the FW the list of steps to get the available registers. 
  *         The FW returs the list of available registers for that steps.
  * @param  stepList: List of requested steps.
  * @param  pMPInfo: The returned list of register.
  *         It is populated by this function.
  * @retval true if MP is enabled, false otherwise.
  */
__weak bool UI_GetMPInfo(pMPInfo_t stepList, pMPInfo_t pMPInfo)
{
	<#-- Motor Profiler feature usage -->
	<#if MC.MOTOR_PROFILER==true>
    CreateMPInfoBuffer(stepList,pMPInfo);
    return true;
	<#else>
    return false;
	</#if>
}
</#if><#-- MC.DRIVE_TYPE == "FOC" -->


<#-- Motor Profiler feature usage -->
<#if MC.MOTOR_PROFILER==true>
__weak void MPInfoStep(uint8_t step, pMPInfo_t pMPInfoStep)
{
  switch (step)
  {
  case 0:
  case 1:
  case 3:
  case 7:
  case 8:
  case 9:
  case 10:
    {
      pMPInfoStep->data = MPInfoDataStepX;
      pMPInfoStep->len = MPInfoDataStepX[0];
    }
    break;
  case 2:
    {
      pMPInfoStep->data = MPInfoDataStep2;
      pMPInfoStep->len = MPInfoDataStep2[0];
    }
    break;
  case 4:
    {
      pMPInfoStep->data = MPInfoDataStep4;
      pMPInfoStep->len = MPInfoDataStep4[0];
    }
    break;
  case 5:
    {
      pMPInfoStep->data = MPInfoDataStep5;
      pMPInfoStep->len = MPInfoDataStep5[0];
    }
    break;
  case 6:
    {
      pMPInfoStep->data = MPInfoDataStep6;
      pMPInfoStep->len = MPInfoDataStep6[0];
    }
    break;
  case 14:
    {
      pMPInfoStep->data = MPInfoDataStep14;
      pMPInfoStep->len = MPInfoDataStep14[0];
    }
    break;
  default:
    {
    }
    break;
  }
  pMPInfoStep->len++;
}


__weak void CreateMPInfoBuffer(pMPInfo_t stepList, pMPInfo_t pMPInfo)
{
  uint8_t i,j;
  MPInfoDataIndex = 0;
  for (i = 0; i < stepList->len; i++)
  {
    MPInfo_t StepInfo;
    MPInfoStep(stepList->data[i], &StepInfo);
    for (j = 0; j < StepInfo.len; j++)
    {
      MPInfoData[MPInfoDataIndex] = StepInfo.data[j];
      if (MPInfoDataIndex < MPINFODATABUFFERLEN)
      {
        MPInfoDataIndex++;
      }
    }
  }
  pMPInfo->data = MPInfoData;
  pMPInfo->len = MPInfoDataIndex;
}
</#if>


<#-- DAC usage for monitoring -->
<#if MC.DAC_FUNCTIONALITY==true>
/**
  * @brief  Hardware and software DAC initialization.
  * @param  pHandle: Pointer on Handle structure of DACx UI component.
  * @retval none.
  */
__weak void UI_DACInit(UI_Handle_t *pHandle)
{
  if (pHandle->pFct_DACInit)
  {
	  pHandle->pFct_DACInit(pHandle);
  }
}


/**
  * @brief  Allow to update the DAC outputs. 
  * @param  pHandle: Pointer on Handle structure of DACx UI component.
  * @retval none.
  */
void UI_DACExec(UI_Handle_t *pHandle)
{
  if (pHandle->pFct_DACExec)
  {
    pHandle->pFct_DACExec(pHandle);
  }
}


/**
  * @brief  Allow to set up the DAC outputs. 
  *         Selected variables will be provided in the related output channels after next DACExec.
  * @param  pHandle: Pointer on Handle structure of DACx UI component.
  * @param  bChannel: DAC channel to program. 
  *         It must be one of the exported channels (Example: DAC_CH0).
  * @param  bVariable: Value to be provided in out through the selected channel.
  *         It must be one of the exported UI register (Example: MC_PROTOCOL_REG_I_A).
  * @retval none.
  */
void UI_SetDAC(UI_Handle_t *pHandle, DAC_Channel_t bChannel,
                         MC_Protocol_REG_t bVariable)
{
  if (pHandle->pFctDACSetChannelConfig)
  {
	  pHandle->pFctDACSetChannelConfig(pHandle, bChannel, bVariable);
  }
}


/**
  * @brief  Allow to get the current DAC channel selected output.
  * @param  pHandle: Pointer on Handle structure of DACx UI component.
  * @param  bChannel: Inspected DAC channel. 
  *         It must be one of the exported channels (Example: DAC_CH0).
  * @retval MC_Protocol_REG_t: Variables provided in out through the inspected channel. 
  *         It must be one of the exported UI register (Example: MC_PROTOCOL_REG_I_A).
  */
__weak MC_Protocol_REG_t UI_GetDAC(UI_Handle_t *pHandle, DAC_Channel_t bChannel)
{
  MC_Protocol_REG_t retVal = MC_PROTOCOL_REG_UNDEFINED;
  if (pHandle->pFctDACGetChannelConfig)
  {
    retVal = pHandle->pFctDACGetChannelConfig(pHandle, bChannel);
  }
  return retVal;
}


/**
  * @brief  Allow to set the value of the user DAC channel.
  * @param  pHandle: Pointer on Handle structure of DACx UI component.
  * @param  bUserChNumber: user DAC channel to program.
  * @param  hValue: Value to be put in output.
  * @retval none.
  */
__weak void UI_SetUserDAC(UI_Handle_t *pHandle, DAC_UserChannel_t bUserChNumber, int16_t hValue)
{
  if (pHandle->pFctDACSetUserChannelValue)
  {
	  pHandle->pFctDACSetUserChannelValue(pHandle, bUserChNumber, hValue);
  }
}
</#if>

/**
  * @}
  */

/**
  * @}
  */

/**
  * @}
  */

/************************ (C) COPYRIGHT 2019 STMicroelectronics *****END OF FILE****/
