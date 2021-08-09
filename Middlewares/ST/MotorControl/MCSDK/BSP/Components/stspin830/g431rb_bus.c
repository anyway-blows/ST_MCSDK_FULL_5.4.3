/**
  ******************************************************************************
  * @file           : g431rb_bus.c
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
#include "g431rb_bus.h"
#include "g431rb_errno.h"
#include "stm32g4xx_hal.h"
#include "stm32g4xx_ll_gpio.h"
#include "main.h"

/** @addtogroup BSP
  * @{
  */

/** @addtogroup G431RB
  * @{
  */

/** @defgroup G431RB_BUS G431RB BUS
  * @{
  */

/** @defgroup G431RB_BUS_Private_Defines G431RB BUS Private Defines
  * @{
  */

#define NUMBER_OF_GPIO_PORTS  (1)

typedef struct
{
  GPIO_TypeDef*    peripheral;
  GPIO_InitTypeDef peripheral_configuration;
  uint8_t          peripheral_is_initialized;
} BSP_GPIO_t;


/**
  * @}
  */
  
/** @defgroup G431RB_BUS_Private_Variables G431RB BUS Private Variables
  * @{
  */

BSP_GPIO_t hgpio[NUMBER_OF_GPIO_PORTS];

/**
  * @}
  */

/** @defgroup G431RB_LOW_LEVEL_Private_Functions G431RB LOW LEVEL Private Functions
  * @{
  */

/** @defgroup G431RB_BUS_Exported_Functions G431RB_BUS Exported Functions
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
    __HAL_RCC_GPIOB_CLK_ENABLE();
  
    /* Configure GPIO pins : STBY_RESET_Pin */
    hgpio[0].peripheral = GPIOB;
    hgpio[0].peripheral_configuration.Pin = STBY_RESET_Pin;
    hgpio[0].peripheral_configuration.Mode = GPIO_MODE_OUTPUT_PP;
    hgpio[0].peripheral_configuration.Pull = GPIO_PULLUP;
    hgpio[0].peripheral_configuration.Speed = GPIO_SPEED_FREQ_LOW;
    HAL_GPIO_Init(hgpio[0].peripheral, &(hgpio[0].peripheral_configuration));
    hgpio[0].peripheral_is_initialized = 1;
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

  /* Deconfigure GPIO pins : STBY_RESET_Pin */
  HAL_GPIO_DeInit(GPIOB, STBY_RESET_Pin);
  hgpio[0].peripheral_is_initialized = 0;
  
  return ret;
}

int32_t BSP_GetPwrStage(STSPIN830_PowerStage_t *PwrStage)
{
  int32_t ret = BSP_ERROR_NONE;
  
  if (HAL_GPIO_ReadPin(EN_FAULT_GPIO_Port, EN_FAULT_Pin) == GPIO_PIN_RESET)
  {
    *PwrStage = STSPIN830_PWR_DISABLE;
  }
  else
  {
    *PwrStage = STSPIN830_PWR_ENABLE;
  }
  
  return ret;
}

int32_t BSP_SetPwrStage(STSPIN830_PowerStage_t PwrStage)
{
  int32_t ret = BSP_ERROR_NONE;
  
  if (PwrStage == STSPIN830_PWR_DISABLE)
  {
    LL_GPIO_SetPinPull(EN_FAULT_GPIO_Port, EN_FAULT_Pin, LL_GPIO_PULL_DOWN);
  }
  else if (PwrStage == STSPIN830_PWR_ENABLE)
  {
    LL_GPIO_SetPinPull(EN_FAULT_GPIO_Port, EN_FAULT_Pin, LL_GPIO_PULL_UP);
  }
  else
  {
    ret = BSP_ERROR_WRONG_PARAM;
  }
  
  return ret;
}

int32_t BSP_GetStby(STSPIN830_Standby_t *Stby)
{
  int32_t ret = BSP_ERROR_NONE;
  
  if (HAL_GPIO_ReadPin(STBY_RESET_GPIO_Port, STBY_RESET_Pin) == GPIO_PIN_RESET)
  {
    *Stby = STSPIN830_STBY_ENABLE;
  }
  else
  {
    *Stby = STSPIN830_STBY_DISABLE;
  }
  
  return ret;
}

int32_t BSP_SetStby(STSPIN830_Standby_t Stby)
{
  int32_t ret = BSP_ERROR_NONE;
  
  if (Stby == STSPIN830_STBY_DISABLE)
  {
    HAL_GPIO_WritePin(STBY_RESET_GPIO_Port, STBY_RESET_Pin, GPIO_PIN_SET);
  }
  else if (Stby == STSPIN830_STBY_ENABLE)
  {
    HAL_GPIO_WritePin(STBY_RESET_GPIO_Port, STBY_RESET_Pin, GPIO_PIN_RESET);
  }
  else
  {
    ret = BSP_ERROR_WRONG_PARAM;
  }
  
  return ret;
}

/************************ (C) COPYRIGHT STMicroelectronics *****END OF FILE****/
