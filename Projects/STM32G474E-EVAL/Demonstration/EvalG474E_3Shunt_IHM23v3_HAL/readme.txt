/**
  * @page Speed regulation using external potentiometer
  * 
  * @verbatim
  ******************** (C) COPYRIGHT 2019 STMicroelectronics *******************
  * @file    STM32-G474E_Eval\Demonstration\EvalG474E_3Shunt_IHM23v3_HAL\readme.txt
  * @author  Motor Control SDK Team
  * @brief   SW code for MB1397B EVALBoard-G4 MOTOR CONTROL DEMO 
  ******************************************************************************
  * This notice applies to any and all portions of this file
  * that are not between comment pairs USER CODE BEGIN and
  * USER CODE END. Other portions of this file, whether 
  * inserted by the user or by software development tools
  * are owned by their respective copyright owners.
  *
  * Copyright (c) 2019 STMicroelectronics International N.V. 
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
  * To run the demonstration MB1397B Eval board needs to be connected to STEVAL-IHM023V3 (low voltage) and a Shinano motor.  
  * The Green LED1 will be light up after the initialization phase showing that the code is now in IDLE sate and
  * is waiting for a command (press User Button B2 or Start with WB Monitor GUI) to run the motor.
  * The Green LED1 flicking will be seen only during the motor spin.
  * In case of any error(s) reported by the Motor Control code the Red LED will be light up.
  * 
  * @par Directory contents 
  * 
  * STM32-G474E_Eval\Demonstration\EvalG474E_3Shunt_IHM23v3_HAL\EvalG474E_3Shunt_IHM23v3_HAL.stmcx -- Workbench project file
  * STM32-G474E_Eval\Demonstration\EvalG474E_3Shunt_IHM23v3_HAL\Src\main.c -- source file modified to add LEDs usage.
  * STM32-G474E_Eval\Demonstration\EvalG474E_3Shunt_IHM23v3_HAL\Inc\main.h -- header file modified to add LEDs usage.
  * 
  * @par Hardware and Software environment 
  * 
  * This demonstration runs on the following configuration:
  * - STM32G474E-EVAL
  * - STEVAL-IHM023V3
  * - Shinano LA052-080E3NL1
  * 
  * @par How to use it ? 
  * 
  * In order to make the demonstration program, you must do the following:
  *
  * 1. Open the "EvalG474E_3Shunt_IHM23v3_HAL.stmcx" file with STM32 Motor Control Workbench PC software tool and save 
  *    it to another, empty, location; 
  *    BEWARE: Do not change the name of the EvalG474E_3Shunt_IHM23v3_HAL.stmcx file, otherwise the 
  *            example will not work properly;
  * 2. Click on the Generate button (within the Generate window) in order to get the full demonstration source 
  *    code, selecting the IDE to use: EWARM, or MDK-ARM or ST TrueSTUDIO;
  *    BEWARE: Make sure not to select HAL as the driver of choice.
  * 3. Open the generated project with this IDE;
  * 4. Build the project and load the resulting binary image into your MCU board;
  * 5. Reset your MCU board;
  * 6. Run the example : through the STM32 MC Workbench monitor GUI, or/and by pressing the Start/Stop button;
  * 
  * ******************** (C) COPYRIGHT 2019 STMicroelectronics *******************
  **/