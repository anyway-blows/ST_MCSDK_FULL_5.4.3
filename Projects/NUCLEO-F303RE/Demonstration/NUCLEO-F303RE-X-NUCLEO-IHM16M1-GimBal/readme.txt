/**
  * @page MCSDK - NUCLEO-F303RE + X-NUCLEO-IHM16M1 + Gimbal motor 
  *
  * @verbatim
  ********************** (C) COPYRIGHT 2018 STMicroelectronics *******************
  *
  * @file    NUCLEO-F303RE\Demonstration\NUCLEO-F303RE-X-NUCLEO-IHM16M1-GimBal\readme.txt 
  *
  * @author  Motor Control SDK Team
  * @brief   How to generate use the X-NUCLEO-IHM16M1 power board with a Gimbal motor 
  *          and a NUCLEO-F303RE control board?
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
  * This demonstration presents the usage of an X-NUCLEO-IHM16M1 power board with a 
  * Gimbal motor and the NUCLEO-F303RE control board. This motor requires some manual
  * tunning in order to operate well and it is the purpose of this example to show
  * what needs to be done.
  * 
  * This demonstration uses the Start/Stop button to start or to stop the motor. The 
  * rotation speed is set constant to around 500 RPM. Alternatively, the demonstration
  * can be controlled with the STM32 Motor Control Monitor that is delivered with ST Motor 
  * Control SDK. Thanks to it, the speed and rotation direction of the motor can be 
  * freely set.
  * 
  * User may change all the default values.
  *
  *  In order to operate well with the Gimbal motor, it is needed that the Integral term 
  * of the PID regulator used to control the rotation speed of the motor be set to 0 at the 
  * end of the startup phase. This can be done by defining the PID_SPEED_INTEGRAL_INIT_DIV
  * symbol to 0 in the file Inc/drive_parameters.h. This file is delivered with the example.
  * Looking into it around line 217, one can see the following sequence
  *
  *   /* USER CODE BEGIN PID_SPEED_INTEGRAL_INIT_DIV */
  *   #define PID_SPEED_INTEGRAL_INIT_DIV 0 /*  */
  *   /* USER CODE END PID_SPEED_INTEGRAL_INIT_DIV */
  *
  * As it can be seen, the symbol PID_SPEED_INTEGRAL_INIT_DIV is set to 0 which ensures that 
  * the integral term of the PID will be set to 0 at the end of the startrup procedure. Moreover,
  * this definition is placed in a User Section, a section of code that is surrounded by the 
  * /* USER CODE BEGIN PID_SPEED_INTEGRAL_INIT_DIV */ and /* USER CODE END PID_SPEED_INTEGRAL_INIT_DIV */
  * comments pair. This ensures that the definition will not be altered when re-generating the 
  * project with the Workbench or with Cube Mx. Note that any code placed in such sections is kept 
  * across regenerations of the project. Such user sections have been placed throughout the code
  * of the Motor Control SDK for users to insert their own code in them.
  * 
  * @par Directory contents 
  * 
  * - "NUCLEO-F303RE\Demonstration\NUCLEO-F303RE-X-NUCLEO-IHM16M1-GimBal\NUCLEO-F303RE-X-NUCLEO-IHM16M1-GimBal.stmcx"	Workbench project file
  * - "NUCLEO-F303RE\Demonstration\NUCLEO-F303RE-X-NUCLEO-IHM16M1-GimBal\Inc\drive_parameters.h" header file in which the needed define is placed.
  * 
  * @par Hardware and Software environment 
  * 
  * This demonstration runs on the [NUCLEO-F303RE] + [X-NUCLEO-IHM16M1] + [iPOWER GBM2804H-100T] HW setup.
  * This demonstration is performed in sensorless mode and does not use the CCMRAM feature.
  *   
  * @par How to use it ? 
  * 
  * In order to build the demonstration program, do the following:
  *
  * 1. Open the "NUCLEO-F303RE-X-NUCLEO-IHM16M1-GimBal.stmcx" file with STM32 Motor Control Workbench PC software tool and save 
  *    it to another, empty, location;
  * 2. Click on the "Generate" button to create the demonstration source code, selecting the IDE 
  *    to use: EWARM, MDK-ARM or ST TrueSTUDIO;
  * 3. Open the generated project with this IDE;
  * 4. Build the project and load the resulting binary image into your MCU board;
  * 5. Reset your MCU board;
  * 6. Run the example : through the STM32 MC Workbench monitor GUI, or/and by pressing the Start/Stop button.
  * 
  * ******************** (C) COPYRIGHT 2018 STMicroelectronics *******************
 **/