/**
 ******************************************************************************
 * @file    stspin32f0a.h
 * @author  IPC Rennes
 * @brief   This file provides a set of functions to manage STSPIN32F0A driver
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
#ifndef __STSPIN32F0A_H
#define __STSPIN32F0A_H

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

/** @addtogroup STSPIN32F0A    STSPIN32F0A
  * @brief  STSPIN32F0A driver section
  * @{ 
  */

/** @defgroup STSPIN32F0A_Exported_Constants STSPIN32F0A Exported Constants
 * @{
 */
#define STSPIN32F0A_TS_CAL_1_TEMP     ((int8_t)   30)
#define STSPIN32F0A_TS_CAL_2_TEMP     ((int8_t)   110)
#define STSPIN32F0A_TS_CAL_1_ADDR     ((uint32_t) 0x1FFFF7B8)
#define STSPIN32F0A_TS_CAL_2_ADDR     ((uint32_t) 0x1FFFF7C2)
#define STSPIN32F0A_VREFINT_CAL_ADDR  ((uint32_t) 0x1FFFF7BA)

/**
  * @} end STSPIN32F0A_Exported_Constants
  */

/** @defgroup STSPIN32F0A_Exported_Types STSPIN32F0A Exported Types
 * @{
 */

typedef enum {
  STSPIN32F0A_OC_VIS_FROM_MCU = 0,
  STSPIN32F0A_OC_VIS_FROM_MCU_AND_GATE_LOGIC = 1,
} STSPIN32F0A_OvercurrentVisibility_t;

typedef enum {
  STSPIN32F0A_OC_TH_STBY  = 0,
  STSPIN32F0A_OC_TH_100mV = 1,
  STSPIN32F0A_OC_TH_250mV = 2,
  STSPIN32F0A_OC_TH_500mV = 3
} STSPIN32F0A_OvercurrentThresholds_t;

typedef struct
{
  uint8_t                             is_initialized;
  STSPIN32F0A_OvercurrentVisibility_t overcurrent_vis;
  STSPIN32F0A_OvercurrentThresholds_t overcurrent_th;
} STSPIN32F0A_Dev_t;

typedef struct
{
  int32_t (*Init)(void);
  int32_t (*DeInit)(void);
  int32_t (*GetOcVis)(STSPIN32F0A_OvercurrentVisibility_t *);  
  int32_t (*SetOcVis)(STSPIN32F0A_OvercurrentVisibility_t);
  int32_t (*GetOcTh)(STSPIN32F0A_OvercurrentThresholds_t *);  
  int32_t (*SetOcTh)(STSPIN32F0A_OvercurrentThresholds_t);
} STSPIN32F0A_Drv_t;

/**
  * @}  end STSPIN32F0A_Exported_Types
  */
  
/**
  * @}  end STSPIN32F0A 
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
