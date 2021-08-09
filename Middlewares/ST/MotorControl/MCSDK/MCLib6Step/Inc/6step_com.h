/**
 ******************************************************************************
 * @file    6step_com.h
 * @author  IPC Rennes
 * @brief   Header file for 6step_com.c file
 ******************************************************************************
 * @attention
 *
 * <h2><center>&copy; Copyright (c) 2018 STMicroelectronics International N.V.
 * All rights reserved.</center></h2>
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

/* Define to prevent recursive inclusion -------------------------------------*/
#ifndef __6STEP_COM_H
#define __6STEP_COM_H

#ifdef __cplusplus
extern "C" {
#endif

/* Includes ------------------------------------------------------------------*/
#include "6step_core.h"

/** @addtogroup MIDDLEWARES
  * @brief  Middlewares Layer
  * @{ 
  */
  
/** @addtogroup MC_6STEP_LIB
  * @{
  */

/** @addtogroup MC_6STEP_COM
  * @{
  */

/** @defgroup MC_6STEP_COM_Exported_Defines
  * @{
  */ 
#define MC_COM_TX_BUFFER_MAX  50
#define MC_COM_TX_TIMEOUT     5000
/**
  * @} end MC_6STEP_COM_Exported_Defines
  */     
    
/** @defgroup MC_6STEP_COM_Exported_Functions_Prototypes
  * @{
  */
void HAL_UART_TxCpltCallback(UART_HandleTypeDef *huart);
MC_FuncStatus_t MC_Com_Init(uint32_t *pMcCom);   
MC_FuncStatus_t MC_Com_Irq_Handler(void);
MC_FuncStatus_t MC_Com_GetStatus(void);
MC_FuncStatus_t MC_Com_ProcessInput(void);
MC_FuncStatus_t MC_Com_Task(void);

/**
  * @} end MC_6STEP_COM_Exported_Functions_Prototypes
  */

/** @defgroup MC_6STEP_COM_Exported_LL_Functions_Prototypes
  * @{
  */
MC_FuncStatus_t MC_Com_LL_Init(uint32_t *pMcCom);
MC_FuncStatus_t MC_Com_LL_Irq_Handler(void);
MC_FuncStatus_t MC_Com_LL_Receive_It(uint8_t* pString, uint8_t Size);
MC_FuncStatus_t MC_Com_LL_Receive_Reset(uint8_t * pString);
MC_FuncStatus_t MC_Com_LL_Reply(uint8_t* pString, uint8_t Size);
MC_FuncStatus_t MC_Com_LL_Send(uint8_t* pString, uint8_t Size);
/**
  * @} end MC_6STEP_COM_Exported_LL_Functions_Prototypes
  */
 
/**
  * @}  end MC_6STEP_COM
  */ 

/**
  * @}  end MC_6STEP_LIB
  */

/**
  * @}  end MIDDLEWARES
  */

#ifdef __cplusplus
}
#endif

#endif /* __6STEP_COM_H */

/************************ (C) COPYRIGHT STMicroelectronics *****END OF FILE****/