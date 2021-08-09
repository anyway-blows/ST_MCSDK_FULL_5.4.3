/**
  * @page freeRtos integration with Motor Control library
  * 
  * @verbatim
  ******************** (C) COPYRIGHT 2018 STMicroelectronics *******************
  * @file    P-NUCLEO-IHM001\Demonstration\Freertos.stmcx
  * @author  Motor Control SDK Team
  * @brief   How to regulate the motor speed using an external Freertos 
             connected to ADC channel of micro-controller ?
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
  * This demonstration presents an example of integration of freeRtos with
  * the Motor Control library. 
  * 
  * @par Directory contents 
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
  * 1. Open the Freertos.stmcx file with STM32 Motor Control Workbench PC software tool and 
  *    save it to another location.
  *    BEWARE: Do not change the name of the Freertos.stmcx file, otherwise the 
  *            example will not work properly;
  * 2. Click on GENERATE;
  * 3. Open the generated project with the chosen IDE and set the highest optimization option 
  *    ( high (speed) with IAR, -O3 -OTime with Keil and -oFast with TrueSTUDIO or STM32CubeIDE );
  * 4. Build the project and load the resulting binary image into your MCU board;
  * 5. Reset your MCU board;
  * 6. Run the example : through the STM32 MC Workbench monitor GUI, or/and by pressing the Start/Stop button;
  * 
  * ******************** (C) COPYRIGHT 2018 STMicroelectronics *******************
  **/