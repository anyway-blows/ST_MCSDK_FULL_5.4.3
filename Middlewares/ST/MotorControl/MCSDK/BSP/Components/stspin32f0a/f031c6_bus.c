/**
  ******************************************************************************
  * @file           : f031c6_bus.c
  * @brief          : source file for the BSP BUS IO driver
  ******************************************************************************
  * This notice applies to any and all portions of this file
  * that are not between comment pairs USER CODE BEGIN and
  * USER CODE END. Other portions of this file, whether
  * inserted by the user or by software development tools
  * are owned by their respective copyright owners.
  *
  * Copyright (c) 2018 STMicroelectronics International N.V.
  * All rights reserved.
  *
  * Redistribution and use in source and binary forms, with or without
  * modification, are permitted, provided that the following conditions are met:
  *
  * 1. Redistribution of source code must retain the above copyright notice,
  *    this list of conditions and the following disclaimer.
  * 2. Redistributions in binary form must reproduce the above copyright notice,
  *    this list of conditions and the following disclaimer in the documentation
  *    and/or other materials provided with the distribution.
  * 3. Neither the name of STMicroelectronics nor the names of other
  *    contributors to this software may be used to endorse or promote products
  *    derived from this software without specific written permission.
  * 4. This software, including modifications and/or derivative works of this
  *    software, must execute solely and exclusively on microcontroller or
  *    microprocessor devices manufactured by or for STMicroelectronics.
  * 5. Redistribution and use of this software other than as permitted under
  *    this license is void and will automatically terminate your rights under
  *    this license.
  *
  * THIS SOFTWARE IS PROVIDED BY STMICROELECTRONICS AND CONTRIBUTORS "AS IS"
  * AND ANY EXPRESS, IMPLIED OR STATUTORY WARRANTIES, INCLUDING, BUT NOT
  * LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY, FITNESS FOR A
  * PARTICULAR PURPOSE AND NON-INFRINGEMENT OF THIRD PARTY INTELLECTUAL PROPERTY
  * RIGHTS ARE DISCLAIMED TO THE FULLEST EXTENT PERMITTED BY LAW. IN NO EVENT
  * SHALL STMICROELECTRONICS OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT,
  * INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
  * LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA,
  * OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF
  * LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING
  * NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE,
  * EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
  *
  ******************************************************************************
*/

/* Includes ------------------------------------------------------------------*/
#include "f031c6_bus.h"
#include "f031c6_errno.h"
#include "stm32f0xx_hal.h"
#include "main.h"

/** @addtogroup BSP
  * @{
  */

/** @addtogroup F031C6
  * @{
  */

/** @defgroup F031C6_BUS F031C6 BUS
  * @{
  */

/** @defgroup F031C6_BUS_Private_Defines F031C6 BUS Private Defines
  * @{
  */

#define NUMBER_OF_GPIO_PORTS  (2)

typedef struct
{
  GPIO_TypeDef*    peripheral;
  GPIO_InitTypeDef peripheral_configuration;
  uint8_t          peripheral_is_initialized;
} BSP_GPIO_t;


/**
  * @}
  */
  
/** @defgroup F031C6_BUS_Private_Variables F031C6 BUS Private Variables
  * @{
  */

BSP_GPIO_t hgpio[NUMBER_OF_GPIO_PORTS];

/**
  * @}
  */

/** @defgroup F031C6_LOW_LEVEL_Private_Functions F031C6 LOW LEVEL Private Functions
  * @{
  */

/** @defgroup F031C6_BUS_Exported_Functions F031C6_BUS Exported Functions
  * @{
  */
/* BUS IO driver over GPIO Peripheral */
/*******************************************************************************
                            BUS OPERATIONS OVER GPIO
*******************************************************************************/
/**
  * @brief  Initialize GPIO
  * @param None
  * @retval BSP status
  */
int32_t BSP_GPIO_Init(void)
{
  int32_t ret = BSP_ERROR_NONE;

  if (hgpio[0].peripheral_is_initialized == 0)
  {
    /* GPIO Ports Clock Enable */
    __HAL_RCC_GPIOF_CLK_ENABLE();
  
    /* Configure GPIO pins : OC_TH_STBY2_Pin OC_TH_STBY1_Pin */
    hgpio[0].peripheral = GPIOF;
    hgpio[0].peripheral_configuration.Pin = OC_TH_STBY2_Pin|OC_TH_STBY1_Pin;
    hgpio[0].peripheral_configuration.Mode = GPIO_MODE_OUTPUT_PP;
    hgpio[0].peripheral_configuration.Pull = GPIO_PULLUP;
    hgpio[0].peripheral_configuration.Speed = GPIO_SPEED_FREQ_LOW;
    HAL_GPIO_Init(hgpio[0].peripheral, &(hgpio[0].peripheral_configuration));
    hgpio[0].peripheral_is_initialized = 1;
  }
 
  if (hgpio[1].peripheral_is_initialized == 0)
  {
    /* GPIO Ports Clock Enable */
    __HAL_RCC_GPIOA_CLK_ENABLE();
    
    /* Configure GPIO pins : OC_SEL_Pin */
    hgpio[1].peripheral = GPIOA;
    hgpio[1].peripheral_configuration.Pin = OC_SEL_Pin;
    hgpio[1].peripheral_configuration.Mode = GPIO_MODE_OUTPUT_PP;
    hgpio[1].peripheral_configuration.Pull = GPIO_NOPULL;
    hgpio[1].peripheral_configuration.Speed = GPIO_SPEED_FREQ_LOW;
    HAL_GPIO_Init(hgpio[1].peripheral, &(hgpio[1].peripheral_configuration));
    hgpio[1].peripheral_is_initialized = 1;
  }
 
  return ret;
}

/**
  * @brief  DeInitialize GPIO
  * @param None
  * @retval BSP status
  */
int32_t BSP_GPIO_DeInit(void)
{
  int32_t ret = BSP_ERROR_NONE;

  /* Deconfigure GPIO pins : OC_TH_STBY2_Pin OC_TH_STBY1_Pin */
  HAL_GPIO_DeInit(GPIOF, OC_TH_STBY2_Pin|OC_TH_STBY1_Pin);
  hgpio[0].peripheral_is_initialized = 0;
  
  /* Deconfigure GPIO pins : OC_SEL_Pin*/
  HAL_GPIO_DeInit(GPIOA, OC_SEL_Pin);
  hgpio[1].peripheral_is_initialized = 0;
  
  return ret;
}

int32_t BSP_GetOcVis(STSPIN32F0A_OvercurrentVisibility_t *OcVis)
{
  int32_t ret = BSP_ERROR_NONE;
  
  if (HAL_GPIO_ReadPin(OC_SEL_GPIO_Port, OC_SEL_Pin) == GPIO_PIN_RESET)
  {
    *OcVis = STSPIN32F0A_OC_VIS_FROM_MCU;
  }
  else
  {
    *OcVis = STSPIN32F0A_OC_VIS_FROM_MCU_AND_GATE_LOGIC;
  }
  
  return ret;
}

int32_t BSP_SetOcVis(STSPIN32F0A_OvercurrentVisibility_t OcVis)
{
  int32_t ret = BSP_ERROR_NONE;
  
  if (OcVis == STSPIN32F0A_OC_VIS_FROM_MCU)
  {
    HAL_GPIO_WritePin(OC_SEL_GPIO_Port, OC_SEL_Pin, GPIO_PIN_RESET);
  }
  else if (OcVis == STSPIN32F0A_OC_VIS_FROM_MCU_AND_GATE_LOGIC)
  {
    HAL_GPIO_WritePin(OC_SEL_GPIO_Port, OC_SEL_Pin, GPIO_PIN_SET);
  }
  else
  {
    ret = BSP_ERROR_WRONG_PARAM;
  }
  
  return ret;
}

int32_t BSP_GetOcTh(STSPIN32F0A_OvercurrentThresholds_t *OcTh)
{
  int32_t ret = BSP_ERROR_NONE;
  uint8_t oc_th_pin1_level = 0, oc_th_pin2_level = 0;
  
  
  if (HAL_GPIO_ReadPin(OC_TH_STBY2_GPIO_Port, OC_TH_STBY2_Pin) != GPIO_PIN_RESET)
  {
    oc_th_pin2_level = 1;
  }
  if (HAL_GPIO_ReadPin(OC_TH_STBY1_GPIO_Port, OC_TH_STBY1_Pin) != GPIO_PIN_RESET)
  {
    oc_th_pin1_level = 1;
  }
  
  *OcTh = (STSPIN32F0A_OvercurrentThresholds_t)(oc_th_pin2_level<<1 | oc_th_pin1_level);
  
  return ret;
}

int32_t BSP_SetOcTh(STSPIN32F0A_OvercurrentThresholds_t OcTh)
{
  int32_t ret = BSP_ERROR_NONE;

  switch (OcTh)
  {
    case STSPIN32F0A_OC_TH_STBY:
      HAL_GPIO_WritePin(GPIOF,OC_TH_STBY2_Pin,GPIO_PIN_RESET);
      HAL_GPIO_WritePin(GPIOF,OC_TH_STBY1_Pin,GPIO_PIN_RESET);
      break;
    case STSPIN32F0A_OC_TH_100mV:
      HAL_GPIO_WritePin(GPIOF,OC_TH_STBY2_Pin,GPIO_PIN_RESET);
      HAL_GPIO_WritePin(GPIOF,OC_TH_STBY1_Pin,GPIO_PIN_SET);
      break;
    case  STSPIN32F0A_OC_TH_250mV:
      HAL_GPIO_WritePin(GPIOF,OC_TH_STBY2_Pin,GPIO_PIN_SET);
      HAL_GPIO_WritePin(GPIOF,OC_TH_STBY1_Pin,GPIO_PIN_RESET);
      break;
    case  STSPIN32F0A_OC_TH_500mV:
      HAL_GPIO_WritePin(GPIOF,OC_TH_STBY2_Pin,GPIO_PIN_SET);
      HAL_GPIO_WritePin(GPIOF,OC_TH_STBY1_Pin,GPIO_PIN_SET);
      break;
  default:
      ret = BSP_ERROR_WRONG_PARAM;
      break;
  }
  
  return ret;
}

/************************ (C) COPYRIGHT STMicroelectronics *****END OF FILE****/
