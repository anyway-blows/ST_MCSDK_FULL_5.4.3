/**
 ******************************************************************************
 * @file    steval-spin3204.c
 * @author  IPC Rennes
 * @brief   This file provides the set of functions to manage the motor driver
 ******************************************************************************
 * @attention
 *
 * <h2><center>&copy; COPYRIGHT(c) 2018 STMicroelectronics</center></h2>
 *
 * Redistribution and use in source and binary forms, with or without modification,
 * are permitted provided that the following conditions are met:
 *   1. Redistributions of source code must retain the above copyright notice,
 *      this list of conditions and the following disclaimer.
 *   2. Redistributions in binary form must reproduce the above copyright notice,
 *      this list of conditions and the following disclaimer in the documentation
 *      and/or other materials provided with the distribution.
 *   3. Neither the name of STMicroelectronics nor the names of its contributors
 *      may be used to endorse or promote products derived from this software
 *      without specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
 * AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
 * IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
 * DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE
 * FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
 * DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
 * SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
 * CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
 * OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
 * OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 *
 ******************************************************************************
 */

/** @addtogroup DRIVERS     DRIVERS 
  * @brief  Driver Layer
  * @{ 
  */

/** @addtogroup BSP     BSP 
  * @brief  BSP Layer
  * @{ 
  */

/** @defgroup STEVAL_SPIN3204    STEVAL_SPIN3204
  * @brief  X-Nucleo board
  * @{ 
  */

/* Includes ------------------------------------------------------------------*/
#include "steval-spin3204.h"

STSPIN32F0A_Dev_t   Stspin32f0a_Dev;
STSPIN32F0A_Drv_t   Stspin32f0a_Drv;

/** @defgroup STEVAL_SPIN3204_MOTION_SENSOR_Exported_Functions STEVAL_SPIN3204 MOTION SENSOR Exported Functions
 * @{
 */
/**
 * @brief  Initializes the motor driver
 * @param  Instance Motor driver instance
 * @retval BSP status
 */
int32_t STEVAL_SPIN3204_MOTOR_DRIVER_Init(void)
{
  int32_t ret = BSP_ERROR_NONE;
  
  if (Stspin32f0a_Dev.is_initialized == 0)
  { 
    /* Configure the motor driver */
    Stspin32f0a_Drv.Init        = STEVAL_SPIN3204_Init;
    Stspin32f0a_Drv.DeInit      = STEVAL_SPIN3204_DeInit;
    Stspin32f0a_Drv.GetOcVis    = STEVAL_SPIN3204_GetOcVis;
    Stspin32f0a_Drv.SetOcVis    = STEVAL_SPIN3204_SetOcVis;
    Stspin32f0a_Drv.GetOcTh     = STEVAL_SPIN3204_GetOcTh;
    Stspin32f0a_Drv.SetOcTh     = STEVAL_SPIN3204_SetOcTh;
  }
  ret = Stspin32f0a_Drv.Init();
  if (ret == BSP_ERROR_NONE)
  {
    Stspin32f0a_Dev.is_initialized = 1;
  }

  return ret;
}

int32_t STEVAL_SPIN3204_MOTOR_DRIVER_DeInit(void)
{
  int32_t ret = BSP_ERROR_NONE;
  
  ret = Stspin32f0a_Drv.DeInit();
  if (ret != BSP_ERROR_NONE)
  {
    Stspin32f0a_Dev.is_initialized = 0;
  }
  
  return ret;
}

int32_t STEVAL_SPIN3204_MOTOR_DRIVER_GetOcVis(STSPIN32F0A_OvercurrentVisibility_t *OcVis)
{
  int32_t ret = Stspin32f0a_Drv.GetOcVis(OcVis);
  Stspin32f0a_Dev.overcurrent_vis = *OcVis;
  return ret;
}

int32_t STEVAL_SPIN3204_MOTOR_DRIVER_SetOcVis(STSPIN32F0A_OvercurrentVisibility_t OcVis)
{
  int32_t ret = Stspin32f0a_Drv.SetOcVis(OcVis);
  Stspin32f0a_Dev.overcurrent_vis = OcVis;
  return ret;
}

int32_t STEVAL_SPIN3204_MOTOR_DRIVER_GetOcTh(STSPIN32F0A_OvercurrentThresholds_t *OcTh)
{
  int32_t ret = Stspin32f0a_Drv.GetOcTh(OcTh);
  Stspin32f0a_Dev.overcurrent_th = *OcTh;
  return ret;
}

int32_t STEVAL_SPIN3204_MOTOR_DRIVER_SetOcTh(STSPIN32F0A_OvercurrentThresholds_t OcTh)
{
  int32_t ret = Stspin32f0a_Drv.SetOcTh(OcTh);
  Stspin32f0a_Dev.overcurrent_th = OcTh;
  return ret;
}

/**
  * @}  end STEVAL_SPIN3204_MOTION_SENSOR_Exported_Functions 
  */

/**
  * @}  end STEVAL_SPIN3204 
  */

/**
  * @}  end BSP
  */

/**
  * @}  end DRIVERS
  */
