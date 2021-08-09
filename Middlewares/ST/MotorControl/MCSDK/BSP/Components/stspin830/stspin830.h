/**
 ******************************************************************************
 * @file    stspin830.h
 * @author  IPC Rennes
 * @brief   This file provides a set of functions to manage STSPIN830 driver
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

/* Define to prevent recursive inclusion -------------------------------------*/
#ifndef __STSPIN830_H
#define __STSPIN830_H

#include "stdint.h"
  
  /** @addtogroup DRIVERS     DRIVERS 
  * @brief  Driver Layer
  * @{ 
  */

/** @addtogroup BSP    BSP
  * @brief  BSP Layer
  * @{ 
  */

/** @addtogroup COMPONENTS    COMPONENTS
  * @brief  Components
  * @{ 
  */

/** @addtogroup STSPIN830    STSPIN830
  * @brief  STSPIN830 driver section
  * @{ 
  */

/** @defgroup STSPIN830_Exported_Constants STSPIN830 Exported Constants
 * @{
 */

/**
  * @} end STSPIN830_Exported_Constants
  */

/** @defgroup STSPIN830_Exported_Types STSPIN830 Exported Types
 * @{
 */

typedef enum {
  STSPIN830_PWR_DISABLE = 0,
  STSPIN830_PWR_ENABLE = 1
} STSPIN830_PowerStage_t;

typedef enum {
  STSPIN830_STBY_ENABLE = 0,
  STSPIN830_STBY_DISABLE = 1
} STSPIN830_Standby_t;

typedef enum {
  STSPIN830_THREE_PWM = 0,
  STSPIN830_SIX_PWM = 1
} STSPIN830_InputDrivingMethod_t;

typedef struct
{
  uint8_t                        is_initialized;
  STSPIN830_PowerStage_t         power_stage;
  STSPIN830_Standby_t            standby;
  STSPIN830_InputDrivingMethod_t input_driving_method;
} STSPIN830_Dev_t;

typedef struct
{
  int32_t (*Init)(void);
  int32_t (*DeInit)(void);
  int32_t (*GetPwrStage)(STSPIN830_PowerStage_t *);
  int32_t (*SetPwrStage)(STSPIN830_PowerStage_t);
  int32_t (*GetStby)(STSPIN830_Standby_t *);
  int32_t (*SetStby)(STSPIN830_Standby_t);
  int32_t (*GetInpDrvMethod)(STSPIN830_InputDrivingMethod_t *);
  int32_t (*SetInpDrvMethod)(STSPIN830_InputDrivingMethod_t);
} STSPIN830_Drv_t;

/**
  * @}  end STSPIN830_Exported_Types
  */
  
/**
  * @}  end STSPIN830 
  */

/**
  * @}  end COMPONENTS 
  */

/**
  * @}  end BSP 
  */

/**
  * @}  end DRIVERS
  */

#endif
