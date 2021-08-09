/**
  * @page Power Factor Correction feature usage
  * 
  * @verbatim
  ******************** (C) COPYRIGHT 2018 STMicroelectronics *******************
  * @file    STEVAL-IHM034V2\Demonstration\PFC.stmcx
  * @author  Motor Control SDK Team
  * @brief   How to use the tuned PFC feature using the STEVAL-IHM034V2 ?
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
  * @endverbatim
  *
  * @par Demonstration description
  * 
  * This demonstration presents API usage from the Motor Control library (aka MC-Lib)
  * and provides you with a tuned use case of the Power Factor Correction feature
  * for STM32F1 family. This demonstration runs with an STEVAL-IHM034V2 inverter board.
  * 
  * This demonstration uses the Start/Stop button to control the motor spinning.
  * 
  * The MC-Lib uses the following API:
  *
  * - MC_StartMotor1();
  * - MC_StopMotor1();
  * 
  * 
  * @par Directory contents 
  * 
  * STEVAL-IHM034V2\Demonstration\PFC\Src\main.c - Demonstration C source code
  * 
  * 
  * @par Hardware and Software environment 
  * 
  * This demonstration runs on the STEVAL-IHM034V2 inverter board running :
  * either an Allen Bradley motor (ref. TL-A220P HJ32AN) or an electronic load.
  * 
  * 
  * @par How to use it ? 
  * 
  * In order to make the demonstration program, you must do the following:
  * 1. Open the PFC.stmcx file with STM32 Motor Control Workbench PC software tool and save 
  *    it to another, empty, location;
  * 2. Check or uncheck the PFC feature box to compare the benefit;
  * 3. Click on the Generate button to create the demonstration source code selecting 
  *    the IDE to use: EWARM, or MDK-ARM or ST TrueSTUDIO;
  * 4. Open the generated project with this IDE;
  * 5. Build the project and load the resulting binary image into your MCU board;
  * 6. Reset your MCU board;
  * 7. Run the example : through the STM32 MC Workbench monitor GUI, or/and by pressing the Start/Stop button.
  * 
  * 
  * ******************** (C) COPYRIGHT 2018 STMicroelectronics *******************
 **/