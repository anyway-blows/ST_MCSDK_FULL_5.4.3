/**
  * @page MCSDK - Sawtooth speed ramp generation in a single drive configuration
  *
  * @verbatim
  ********************** (C) COPYRIGHT 2018 STMicroelectronics *******************
  *
  * @file    NUCLEO-F303RE\Demonstration\SawToothRamp\readme.txt 
  *
  * @author  Motor Control SDK Team
  * @brief   How to generate a Sawtooth Speed Ramp ?
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
  * This demonstration presents the usage of some APIs of the Motor Control library
  * in order to generate a sawtooth-like speed ramp for a motor using two parameters:
  *    1. speed_first_valueRPM (default is 7500 rpm);
  *    2. speed_firstramp_duration (default is 200 ms);
  *    3. speed_second_valueRPM (default is 2500 rpm);
  *    4. speed_secondramp_duration (default is 500 ms).
  * 
  * This demonstration uses the Start/Stop button to start or to stop the motor.
  * If the motor speed is below a minimum speed threshold, the motor is stopped
  * and error is acknowledged, but the motor is not re-started (unless performed
  * through the STM32 MC Workbench monitor feature). Consequently, pressing the
  * Start/Stop button again re-starts the motor.
  * 
  * User may change all the default values.
  * 
  * Note that the CCMRAM feature is not used with this example.
  * 
  * The following user state machine controls the demonstration:
  * 1. A first linear up-speed ramp is configured, and waits for the motor to spin
  *    (thanks to the Start/Stop button usage).
  * 2. Configured the 1st linear up-speed ramp.
  *    When the 1st up-speed target is reached, the demonstration waits for few seconds.
  *    Then, go to next step.
  *    When the motor speed is too low, then stop the motor and go to step 4/.
  * 3. Configured the 2nd linear down-speed ramp.
  *    When the 2nd down-speed target is reached, the demonstration waits for few seconds.
  *    Then, go to previous step.
  *    When the motor speed is too low, then stop the motor and go to step 4/.
  * 4. When motor is stopped, potential error is acknowledged. Then, go to step 1/.
  * 
  * This demonstration uses the following API of the Motor Control library:
  *
  * - MC_GetSTMStateMotor1();
  * - MC_ProgramSpeedRampMotor1();
  * - MC_GetMecSpeedAverageMotor1();
  * - MC_AcknowledgeFaultMotor1();
  * - MC_StartMotor1();
  * - MC_StopMotor1();
  * 
  * @par Directory contents 
  * 
  * - "NUCLEO-F303RE\Demonstration\SawToothRamp\Src\main.c"		Main C source code
  * - "NUCLEO-F303RE\Demonstration\SawToothRamp\Inc\saw_speed_ramp.h"	Demonstration header
  * - "NUCLEO-F303RE\Demonstration\SawToothRamp\Src\saw_speed_ramp.c"	Demonstration C source code
  * 
  * @par Hardware and Software environment 
  * 
  * This demonstration runs on the [NUCLEO-F303RE] + [X-NUCLEO-IHM07M1] + [BullRunning BR2804-1700Kv-1] HW setup.
  * This demonstration is performed in sensorless mode and does not use the CCMRAM feature.
  *   
  * This demonstration can be run on different board when re-configured and updated from the ST MC Workbench.
  * 
  * @par How to use it ? 
  * 
  * In order to build the demonstration program, do the following:
  *
  * 1. Open the "SawToothRamp.stmcx" file with STM32 Motor Control Workbench PC software tool and save 
  *    it to another, empty, location.
  *    BEWARE: Do not change the name of the SawToothRamp.stmcx file, otherwise the 
  *            example will not work properly
  * 2. Click on the "Generate" button to create the demonstration source code, selecting the IDE 
  *    to use: EWARM, MDK-ARM or ST TrueSTUDIO;
  * 3. Open the generated project with this IDE;
  * 4. Build the project and load the resulting binary image into your MCU board;
  * 5. Reset your MCU board;
  * 6. Run the example : through the STM32 MC Workbench monitor GUI, or/and by pressing the Start/Stop button.
  * 
  * ******************** (C) COPYRIGHT 2018 STMicroelectronics *******************
 **/