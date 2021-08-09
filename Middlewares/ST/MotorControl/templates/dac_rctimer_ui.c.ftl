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
  * @file    dac_rctimer_ui.c
  * @author  Motor Control SDK Team, ST Microelectronics
  * @brief   This file provides firmware functions that implement the following features
  *          of the dac component of the Motor Control SDK:
  *           + dac initialization
  *           + dac execution
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

/* Includes ------------------------------------------------------------------*/
#include "dac_rctimer_ui.h"
#include "dac_common_ui.h"


/** @addtogroup MCSDK
  * @{
  */

/**
 * @addtogroup MCUI
 * @{
 */

/** @defgroup dac_rctimer_ui DAC RC Timer User Interface
  *
  * @brief RC Timer DAC User Interface implementation
  *
  * Digital to Analog Converter common component. In Motor Control context, the DAC is used for
  * debug purposes by outputting information with low overhead. It is particularly useful to
  * output fast changing analog-like data as voltage references or measured currents to compare
  * them with measurements made with other means, for instance.
  *
  * The RC Timer DAC component aims at using a PWM Timer coupled with an RC network as a DAC
  *
  *
  * @{
  */

/**
  * @brief  Hardware and software initialization of the DAC object. This is the
  *         implementation of the virtual function.
  * @param  pHandle related component instance.
  */
__weak void DACT_Init(UI_Handle_t *pHandle)
{
<#if MC.DAC_EMULATED_1 == "NOT_USED" && MC.DAC_EMULATED_2 == "NOT_USED">
<#elseif MC.DAC_EMULATED_1 != "NOT_USED" && MC.DAC_EMULATED_2 != "NOT_USED" >
   /* CH1 configuration  */
  LL_TIM_CC_EnableChannel(${MC.DAC_TIMER_SELECTION}, LL_TIM_CHANNEL_${MC.DAC_EMULATED_1});
  LL_TIM_OC_DisablePreload(${MC.DAC_TIMER_SELECTION}, LL_TIM_CHANNEL_${MC.DAC_EMULATED_1});
  
  /* CH2 configuration  */
  LL_TIM_CC_EnableChannel(${MC.DAC_TIMER_SELECTION}, LL_TIM_CHANNEL_${MC.DAC_EMULATED_2});
  LL_TIM_OC_DisablePreload(${MC.DAC_TIMER_SELECTION}, LL_TIM_CHANNEL_${MC.DAC_EMULATED_2});
  
  /* start Timer */
  LL_TIM_EnableCounter(${MC.DAC_TIMER_SELECTION});
  
<#else> 
<#if MC.DAC_EMULATED_1 == "NOT_USED" >
  /* CH2 configuration  */
  LL_TIM_CC_EnableChannel(${MC.DAC_TIMER_SELECTION}, LL_TIM_CHANNEL_${MC.DAC_EMULATED_2});
  LL_TIM_OC_DisablePreload(${MC.DAC_TIMER_SELECTION}, LL_TIM_CHANNEL_${MC.DAC_EMULATED_2});
<#else>
  /* CH1 configuration  */
  LL_TIM_CC_EnableChannel(${MC.DAC_TIMER_SELECTION}, LL_TIM_CHANNEL_${MC.DAC_EMULATED_1});
  LL_TIM_OC_DisablePreload(${MC.DAC_TIMER_SELECTION}, LL_TIM_CHANNEL_${MC.DAC_EMULATED_1});
</#if>
  /* start Timer */
  LL_TIM_EnableCounter(${MC.DAC_TIMER_SELECTION});
</#if>
}

/**
  * @brief  This method is used to update the DAC outputs. The selected
  *         variables will be provided in the related output channels. This is
  *         the implementation of the virtual function.
  * @param  pHandle related component instance.
  * @retval none.
  */
__weak void DACT_Exec(UI_Handle_t *pHandle)
{
<#if MC.DAC_EMULATED_1 == "NOT_USED" && MC.DAC_EMULATED_2 == "NOT_USED">
<#elseif MC.DAC_EMULATED_1 != "NOT_USED" && MC.DAC_EMULATED_2 != "NOT_USED" >
  DAC_UI_Handle_t *pDacHandle = (DAC_UI_Handle_t *)pHandle;
  MC_Protocol_REG_t bCh1_var;
  MC_Protocol_REG_t bCh2_var;
  
  bCh1_var = pDacHandle->bChannel_variable[DAC_CH0];
  bCh2_var = pDacHandle->bChannel_variable[DAC_CH1];
  LL_TIM_OC_SetCompare${MC.DAC_EMULATED_1}(${MC.DAC_TIMER_SELECTION}, ((uint16_t)((int16_t)(((int16_t)UI_GetReg(pHandle,bCh1_var,MC_NULL)+32768)/32))));
  LL_TIM_OC_SetCompare${MC.DAC_EMULATED_2}(${MC.DAC_TIMER_SELECTION}, ((uint16_t)((int16_t)(((int16_t)UI_GetReg(pHandle,bCh2_var,MC_NULL)+32768)/32))));
<#else> 
<#if MC.DAC_EMULATED_1 == "NOT_USED" >
  DAC_UI_Handle_t *pDacHandle = (DAC_UI_Handle_t *)pHandle;
  MC_Protocol_REG_t bCh2_var;

  bCh2_var = pDacHandle->bChannel_variable[DAC_CH1];  
  LL_TIM_OC_SetCompare${MC.DAC_EMULATED_2}(${MC.DAC_TIMER_SELECTION}, ((uint16_t)((int16_t)(((int16_t)UI_GetReg(pHandle,bCh2_var,MC_NULL)+32768)/32))));
<#else>
  DAC_UI_Handle_t *pDacHandle = (DAC_UI_Handle_t *)pHandle;
  MC_Protocol_REG_t bCh1_var;

  bCh1_var = pDacHandle->bChannel_variable[DAC_CH0];
  LL_TIM_OC_SetCompare${MC.DAC_EMULATED_1}(${MC.DAC_TIMER_SELECTION}, ((uint16_t)((int16_t)(((int16_t)UI_GetReg(pHandle,bCh1_var,MC_NULL)+32768)/32))));
</#if>
</#if>
}

/**
  * @}
  */

/**
  * @}
  */

/**
  * @}
  */


/******************* (C) COPYRIGHT 2019 STMicroelectronics *****END OF FILE****/
