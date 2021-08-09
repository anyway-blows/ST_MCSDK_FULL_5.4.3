/**
  * @page MCSDK - NUCLEO-F303RE + X-NUCLEO-IHM07M1 + Maxon motor EC-i40 100W
  *
  * @verbatim
  ********************** (C) COPYRIGHT 2019 STMicroelectronics *******************
  *
  * @file    NUCLEO-F303RE\Demonstration\PositionControl\readme.txt 
  *
  * @author  Motor Control SDK Team
  * @brief   How to generate a Position Control mode.
  *
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
  * The example contains a demo of the position control mode executing a sequence
  * of position commands.
  * After the power-on the FW performs the “alignment sequence” that is a slow moment
  * of the motor to reach the mechanical 0° position.
  *
  * The demo will perform the following sequences of position:
  * From the initial rotor position to 10*2Pi radiant (10 turns in one direction) in 0.36 seconds.
  * Wait for 0.36 seconds.
  * From 10*2p radiant to 0° (10 turns in opposite direction) in 0.36 seconds.
  * Wait for 0.36 seconds.
  * Repeat from the begin. 
  * 
  * User may change all the default values to customize the demo.
  *
  * 
  * @par Directory contents 
  * 
  * - "NUCLEO-F303RE\Demonstration\PositionControl\PositionControl.stmcx"	Workbench project file.
  * - "NUCLEO-F303RE\Demonstration\PositionControl\Src\main.c"	Main C source code including demo.
  * 
  * @par Hardware and Software environment 
  * 
  * This demonstration runs on the [NUCLEO-F303RE] + [X-NUCLEO-IHM07M1] + [MAXON] HW setup.
  * This demonstration is performed with a Quadrature Encoder sensor mode + Z index.
  *   
  * @par How to use it ? 
  * 
  * In order to build the demonstration program, do the following:
  *
  * 1. Open the "PositionControl.stmcx" file with STM32 Motor Control Workbench PC software tool and save 
  *    it to another, empty, location.
  *    BEWARE: Do not change the name of the SawToothRamp.stmcx file, otherwise the 
  *            example will not work properly
  * 2. Click on the "Generate" button to create the demonstration source code, selecting the IDE 
  *    to use: EWARM, MDK-ARM or ST TrueSTUDIO;
  * 3. Open the generated project with this IDE;
  * 4. Build the project and load the resulting binary image into your MCU board;
  * 5. Reset your MCU board;
  * 6. Run the example : through the STM32 MC Workbench monitor GUI (Start Motor), or/and by pressing the Start/Stop button.
  * 
  * ******************** (C) COPYRIGHT 2019 STMicroelectronics *******************
 **/