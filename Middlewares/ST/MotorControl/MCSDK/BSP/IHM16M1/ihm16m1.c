/**
 ******************************************************************************
 * @file    ihm16m1.c
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

/** @defgroup IHM16M1    IHM16M1
  * @brief  X-Nucleo board
  * @{ 
  */

/* Includes ------------------------------------------------------------------*/
#include "ihm16m1.h"

STSPIN830_Dev_t   Stspin830_Dev;
STSPIN830_Drv_t   Stspin830_Drv;

/** @defgroup IHM16M1_MOTOR_DRIVER_Exported_Functions IHM16M1 MOTOR DRIVER Exported Functions
 * @{
 */
/**
 * @brief  Initializes the motor driver
 * @param  Instance Motor driver instance
 * @retval BSP status
 */
int32_t IHM16M1_MOTOR_DRIVER_Init(void)
{
  int32_t ret = BSP_ERROR_NONE;
  
  if (Stspin830_Dev.is_initialized == 0)
  { 
    /* Configure the motor driver */
    Stspin830_Drv.Init        = IHM16M1_Init;
    Stspin830_Drv.DeInit      = IHM16M1_DeInit;
    Stspin830_Drv.GetPwrStage = IHM16M1_GetPwrStage;
    Stspin830_Drv.SetPwrStage = IHM16M1_SetPwrStage;
    Stspin830_Drv.GetStby     = IHM16M1_GetStby;
    Stspin830_Drv.SetStby     = IHM16M1_SetStby;
  }
  ret = Stspin830_Drv.Init();
  if (ret == BSP_ERROR_NONE)
  {
    Stspin830_Dev.is_initialized = 1;
  }

  return ret;
}

int32_t IHM16M1_MOTOR_DRIVER_DeInit(void)
{
  int32_t ret = BSP_ERROR_NONE;
  
  ret = Stspin830_Drv.DeInit();
  if (ret != BSP_ERROR_NONE)
  {
    Stspin830_Dev.is_initialized = 0;
  }
  
  return ret;
}

int32_t IHM16M1_MOTOR_DRIVER_GetPwrStage(STSPIN830_PowerStage_t *PwrStage)
{
  int32_t ret = Stspin830_Drv.GetPwrStage(PwrStage);
  Stspin830_Dev.power_stage = *PwrStage;
  return ret;
}

int32_t IHM16M1_MOTOR_DRIVER_SetPwrStage(STSPIN830_PowerStage_t PwrStage)
{
  int32_t ret = Stspin830_Drv.SetPwrStage(PwrStage);
  Stspin830_Dev.power_stage = PwrStage;
  return ret;
}

int32_t IHM16M1_MOTOR_DRIVER_GetStby(STSPIN830_Standby_t *Stby)
{
  int32_t ret = Stspin830_Drv.GetStby(Stby);
  Stspin830_Dev.standby = *Stby;
  return ret;
}

int32_t IHM16M1_MOTOR_DRIVER_SetStby(STSPIN830_Standby_t Stby)
{
  int32_t ret = Stspin830_Drv.SetStby(Stby);
  Stspin830_Dev.standby = Stby;
  return ret;
}

/**
  * @}  end IHM16M1_MOTOR_DRIVER_Exported_Functions 
  */

/**
  * @}  end IHM16M1 
  */

/**
  * @}  end BSP
  */

/**
  * @}  end DRIVERS
  */
