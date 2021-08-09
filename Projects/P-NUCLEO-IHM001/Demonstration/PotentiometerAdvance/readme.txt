/**
  * @page Speed regulation using external Potentiometer & LEDs
  *
  * @verbatim
  ******************** (C) COPYRIGHT 2018 STMicroelectronics *******************
  * @file    P-NUCLEO-IHM001\Demonstration\PotentiometerAdvance.stmcx
  * @author  Motor Control SDK Team
  * @brief   How to regulate the motor speed using an external potentiometer 
  *          connected to ADC channel of micro-controller ?
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
  * This demonstration presents API usage from the Motor Control library
  * to control the speed of a motor through an external potentiometer.
  * 
  * Its purpose is also to present how to modify generated C source files using
  * the STM32CubeMx software tool.
  * 
  * This demonstration uses the Start/Stop button and the Green LED located on
  * the NUCLEO-F302R8 board.
  * The potentiometer and the Red LED which are also used, are located on the
  * X-NUCLEO-IHM07M1 board.
  * 
  * The potentiometer is connected to one ADC channel of the micro-controller (MCU).
  * 
  * The MC-Lib uses the following API:
  *
  * - MC_GetSTMStateMotor1();
  * - MC_ProgramSpeedRampMotor1();
  * - MC_StartMotor1();
  * - MC_StopMotor1();
  * - RCM_RegisterRegConv_WithCB();
  * - RCM_GetUserConvState();
  * - RCM_RequestUserConv ();
  * 
  * @par Directory contents 
  * 
  * "P-NUCLEO-IHM001\Demonstration\PotentiometerAdvance\Src\main.c"     Demonstration C source code
  * 
  * @par Hardware and Software environment 
  * 
  * This demonstration runs on the P-NUCLEO-IHM001 Motor Control Kit
  * ([NUCLEO-F302R8] + [X-NUCLEO-IHM07M1] + [BullRunning BR2804-1700Kv-1] HW setup)
  * 
  * @par How to use it ? 
  * 
  * In order to make the demonstration program, you must do the following:
  *
  * 1. Open the "PotentiometerAdvance.stmcx" file with STM32 Motor Control Workbench PC software tool and save 
  *    it to another, empty, location.
  *    BEWARE: Do not change the name of the PotentiometerAdvance.stmcx file, otherwise the 
  *            example will not work properly;
  * 2. Click on the Update button (within the Generate window) to Update the demonstration source code 
  *    selecting the IDE to use: EWARM, or MDK-ARM or ST TrueSTUDIO;
  * 3. Open the generated project with this IDE;
  * 4. Build the project and load the resulting binary image into your MCU board;
  * 5. Reset your MCU board;
  * 6. Run the example : through the STM32 MC Workbench monitor GUI, or/and pressing the Start/Stop button;
  * 7. Wait for the Green LED lighting;
  * 8. Turn the potentiometer knob: clock wise to decrease the motor speed and counter clock wise to increase it;
  * 9. Red LED lighting indicates that an error has occurred (this can be checked with STM32 Workbench monitor GUI);
  *    In such a case, reset the board to be able to start again from step 7.
  * 
  ******************** (C) COPYRIGHT 2018 STMicroelectronics *******************
 **/