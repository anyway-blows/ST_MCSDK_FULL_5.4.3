/**
  ******************************************************************************
  * @file           : potentiometer.h
  * @brief          : Header for potentiometer.c file.
  *                   This file contains the common defines of the application.
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

/* Define to prevent recursive inclusion -------------------------------------*/
#ifndef __POTENTIOMETER_H__
#define __POTENTIOMETER_H__

/* Includes ------------------------------------------------------------------*/
#include "mc_api.h"
#include "pmsm_motor_parameters.h"
#include "parameters_conversion.h"

/* Private define ------------------------------------------------------------*/

#ifdef __cplusplus
 extern "C" {
#endif

/** @addtogroup MCSDK
  * @{
  */

/** @addtogroup MCDEMO
  * @{
  */

/* Demonstration C source code */
void demo_potentiometer(uint8_t handle);

/**
  * @}
  */

/**
  * @}
  */

#ifdef __cplusplus
}
#endif

#endif /* __POTENTIOMETER_H__ */

/************************ (C) COPYRIGHT STMicroelectronics *****END OF FILE****/
