/**
 ******************************************************************************
 * @file    ihm16m1.h
 * @author  IPC Rennes
 * @brief   This file provides the set of functions to manage the X-Nucleo board
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

/* Includes ------------------------------------------------------------------*/
#include "stspin830.h"
#include "ihm16m1_conf.h"

/** @addtogroup DRIVERS     DRIVERS 
  * @brief  Driver Layer
  * @{ 
  */

/** @addtogroup BSP
  * @{
  */   

/** @addtogroup IHM16M1
  * @{   
  */

/** @defgroup IHM16M1_MOTOR_DRIVER_Exported_Constants STEVAL SPIN3202 MOTOR DRIVER Exported Constants
 * @{
 */
#define NUMBER_OF_STSPIN830  (1)

/**
  * @} end IHM16M1_MOTOR_DRIVER_Exported_Constants
  */
    
/** @addtogroup IHM16M1_MOTOR_DRIVER_Exported_Functions STEVAL SPIN3202 MOTOR DRIVER Exported Functions
 * @{
 */
int32_t IHM16M1_MOTOR_DRIVER_Init(void);
int32_t IHM16M1_MOTOR_DRIVER_DeInit(void);
int32_t IHM16M1_MOTOR_DRIVER_GetPwrStage(STSPIN830_PowerStage_t *PwrStage);
int32_t IHM16M1_MOTOR_DRIVER_SetPwrStage(STSPIN830_PowerStage_t PwrStage);
int32_t IHM16M1_MOTOR_DRIVER_GetStby(STSPIN830_Standby_t *Stby);
int32_t IHM16M1_MOTOR_DRIVER_SetStby(STSPIN830_Standby_t Stby);
    
/**
  * @} end IHM16M1_MOTOR_DRIVER_Exported_Functions
  */

/**
  * @} end IHM16M1
  */

/**
  * @} end BSP
  */

/**
  * @} end DRIVERS
  */