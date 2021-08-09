/**
  * @page MCSDK - Saw speed ramp generation on a dual drive configuration + CCMRAM
  * 
  * @verbatim
  ******************** (C) COPYRIGHT 2018 STMicroelectronics *******************
  * @file    STM32303E-EVAL\Demonstration\DualDriveCCMRAM.stmcx
  * @author  Motor Control SDK Team
  * @brief   How to spin two motors with an STM32303E-EVAL board ?
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
  * in order to generate a sawtooth-like speed ramp for controlling both motors of 
  * a dual drive configuration. Four parameters set the behavior of the sawtooth ramp:
  *
  *  1. speed_first_valueRPM (default is 2500 rpm);
  *  2. speed_firstramp_duration (default is 500 ms);
  *  3. speed_second_valueRPM (default is 1500 rpm);
  *  4. speed_secondramp_duration (default is 200 ms).
  * 
  * This demonstration uses the Start/Stop button to start or to stop both motors.
  * If a motor speed is below a minimum speed threshold, the faulty motor is stopped
  * and error is acknowledge, but this motor is not re-started (unless performed
  * through the STM32 MC Workbench monitor feature). Consequently, pressing the
  * Start/Stop button again changes the demonstration mode to a flip-flop mode
  * between motors.
  * 
  * Although not mandatory, this demonstration is using the CCMRAM feature from F3
  * family to show the best performances and CCMRAM usage.
  * However, this can be disabled by removing the definition of the CCMRAM preprocessor 
  * symbol from the settings of the demonstration project.
  * 
  * User can change the values of any of these parameters.
  * 
  * The following user state machine controls the demonstration:
  * 1. A linear (but different) speed ramp is configured for each motor,
  *    and waits for all motors to spin (thanks to the Start/Stop button usage ;-).
  * 2. Configured the linear speed ramps.
  *    When all the speed targets are reached, the demonstration waits for few seconds.
  *    Then, go to next step.
  *    When a motor speed is too low, then stop the faulty motor and go to step 4/.
  * 3. Configured the linear speed ramps.
  *    When all the speed targets are reached, the demonstration waits for few seconds.
  *    Then, go to previous step.
  *    When a motor speed is too low, then stop the faulty motor and go to step 4/.
  * 4. When a motor is stopped, potential error is acknowledged. Then, go to step 1/.
  * 
  * 
  * The demonstration uses the following API:
  *
  * - MC_GetSTMStateMotor1();
  * - MC_GetSTMStateMotor2();
  * - MC_ProgramSpeedRampMotor1();
  * - MC_ProgramSpeedRampMotor2();
  * - MC_GetMecSpeedAverageMotor1();
  * - MC_GetMecSpeedAverageMotor2();
  * - MC_AcknowledgeFaultMotor1();
  * - MC_AcknowledgeFaultMotor2();
  * - MC_StartMotor1();
  * - MC_StopMotor1();
  * - MC_StartMotor2();
  * - MC_StopMotor2();
  *
  * It also defines the following preprocessor symbol to trigger the use of the CCMRAM:
  *
  * - CCMRAM
  *
  * For more information on the usage of CCMRAM in software projects on STM32, refer to 
  * Application Note AN4296 "Overview and tips for using STM32F303/328/334/358xx CCM RAM
  * with IAR EWARM, Keil MDK-ARM and GNU-based toolchains", available on the ST website:
  * https://www.st.com.
  * 
  * @par Directory contents 
  * 
  * - STM32303E-EVAL\Demonstration\DualDriveCCMRAM\Src\main.c - Main C source code
  * - STM32303E-EVAL\Demonstration\DualDriveCCMRAM\Inc\speed_ramp_for_dual_drive.h - Demonstration header
  * - STM32303E-EVAL\Demonstration\DualDriveCCMRAM\Src\speed_ramp_for_dual_drive.c - Demonstration C source code
  * - STM32303E-EVAL\Demonstration\DualDriveCCMRAM\Src\system_stm32f3xx.c - CCMRAM redefinition usage C source code
  * - STM32303E-EVAL\Demonstration\DualDriveCCMRAM\Src\ui_task.c - User button usage C source code
  * 
  * @par Hardware and Software environment 
  * 
  * This demonstration runs on the [STM32303E-EVAL] + 2x [IHM045V1] + 2x [Shinano LA052-080ENL1] HW setup.
  * This demonstration is performed in sensorless mode, using the CCMRAM feature.
  * 
  * @par How to use it ? 
  * 
  * In order to build the demonstration program, do the following:
  *
  * 1. COpen the DualDriveCCMRAM.stmcx file with STM32 Motor Control Workbench PC software tool and save 
  *    it to another, empty, location.
  *    BEWARE: Do not change the name of the DualDriveCCMRAM.stmcx file, otherwise the 
  *            example will not work properly;
  * 2. Click on the "Generate" button to create the demonstration source code, selecting the IDE to use: EWARM or MDK-ARM 
  *    or ST TrueSTUDIO;
  * 3. Open the generated project with this IDE;
  * 4. If the chosen IDE is ST TrueSTUDIO or STM32Cube IDE, Open the Project -> Properties dialog and navigate to the 
  *    C/C++ General -> Paths and Symbols pane. Select the Libraries tab. Change the libmc-GCC_M4_NoCCMRAM.lib library into 
  *    libmc-GCC_M4.lib. Click OK.
  * 5. Build the project and load the resulting binary image into your MCU board;
  * 6. Reset your MCU board;
  * 7. Run the example : through the STM32 MC Workbench monitor GUI, or/and pressing the Start/Stop button.
  * 
  * 
  * ******************** (C) COPYRIGHT 2018 STMicroelectronics *******************
 **/