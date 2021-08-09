/**
  * @page 6-Steps speed regulation using the NUCLEOF401RETx/IHM07/BullRunning
  * 
  * @verbatim
  ******************** (C) COPYRIGHT 2019 STMicroelectronics *******************
  * @file    6Steps-NUCLEOF401RETx-IHM07-BullRunning.stmcx
  * @author  Motor Control SDK Team
  * @brief   6-Steps motor drive running on a NUCLEOF401RETx/IHM07/BullRunning
  ******************************************************************************
  * COPYRIGHT(c) 2019 STMicroelectronics
  *
  * Redistribution and use in source and binary forms, with or without modification,
  * are permitted provided that the following conditions are met:
  *   1. Redistributions of source code must retain the above copyright notice,
  *      this list of conditions and the following disclaimer.
  *   2. Redistributions in binary form must reproduce the above copyright notice,
  *      this list of conditions and the following disclaimer in the documentation
  *      and/or other materials provided with the distribution.
  *   3. Neither the name of STMicroelectronics nor the names of its contributors
  *      may be used to endorse or promote products derived from this software
  *      without specific prior written permission.
  *
  * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
  * AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
  * IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
  * DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE
  * FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
  * DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
  * SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
  * CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
  * OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
  * OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
  *
  ******************************************************************************
  * @endverbatim
  *
  * ------------------------------
  * @par Demonstration description 
  * 
  *  This demonstration presents a 6-Steps motor drive application running on 
  * a NUCLEO-F401RETx, an X-NUCLEO-IHM07M1 and a BullRunning motor forming HW setup. 
  *
  * It is configured in sensorless (SIX_STEP_SENSING=SENSORS_LESS), Voltage control 
  * mode (SIX_STEP_CONTROL_MODE=VOLTAGE) which allows the user to set a rotation
  * speed reference for the motor that the application will implement. 
  *
  * It is the first level of integration of a 6-Steps drive solution into the 
  * Motor Control SDK. So far, the level of integration is limited as an example.
  *
  * -----------------------
  * @par Directory contents 
  * 
  * \Projects\NUCLEO-F401RE\Demonstration\6Steps-NUCLEOF401RETx-IHM07-BullRunning\6Steps-NUCLEOF401RETx-IHM07-BullRunning.ioc
  * \Projects\NUCLEO-F401RE\Demonstration\6Steps-NUCLEOF401RETx-IHM07-BullRunning\6Steps-NUCLEOF401RETx-IHM07-BullRunning.stmcx
  * \Projects\NUCLEO-F401RE\Demonstration\6Steps-NUCLEOF401RETx-IHM07-BullRunning\extras.wb_def
  * \Projects\NUCLEO-F401RE\Demonstration\6Steps-NUCLEOF401RETx-IHM07-BullRunning\readme.txt
  * \Projects\NUCLEO-F401RE\Demonstration\6Steps-NUCLEOF401RETx-IHM07-BullRunning\TERATERM_F401RETx_115200_Pnone.ini
  *
  * --------------------------------------
  * @par Hardware and Software environment 
  * 
  * This demonstration runs on the following Hardware Setup:
  * [NUCLEO-F401RE] + [X-NUCLEO-IHM07M1] + [Bull Running BR2804-1700Kv-1] 
  *
  * The following software tools are needed to run the application:
  * - ST Motor Control SDK, version 5.4.2 or later
  * - STM32CubeMx, version 5.3.0 or later
  * - STM32Cube FW Package for STM32F4 Series, version 1.24.1 or later
  * - IAR EWARM 8 or Keil uVision 5.
  * - ST MC Monitor (default) or Teraterm as the user I/F.
  *
  * Note that the current version of this example does not work with STM32CubeIDE 1.0.0.
  *
  *  The X-NUCLEO-IHM07M1 board shall be configured as follows to run the application:
  * - Set jumpers J5 and J6 in 2-3 position
  * - Set jumpers J9, JP1, JP2 and JP3 in Open position
  * See the board's user manual (UM1943) for complete details.
  *
  * ---------------------------------
  * @par How to use the application ?
  *
  * This 6-Steps application example does support either the Motor Control SDK protocol or either
  * the Command Line Interface (CLI) over the serial port (selection is done from STM32CubeMx).
  *
  * => ST MC Monitor usage:
  * By default, the application example is built with the SDK Motor Control Protocol
  * It can be controlled with the Motor Control Monitor delivered as a part of the ST MCSDK.
  *
  * However, the support for the Motor Control Protocol is not complete. For instance, the 
  * Speed ramp feature is not present and the motor cannot be spun at negative speeds with
  * the ST MC Monitor. Also, most of the registers that are available either to 
  * be read or to be written with FOC applications are not available with this 6 Steps example.
  *
  * The motor can be started and stopped with the Start Motor and Stop Motor buttons respectively.
  *
  * => CLI usage:
  * This CLI is accessed using a terminal emulator like Teraterm for instance.
  * The configuration of the TeraTerm (*.ini file) is also provided.
  * 
  * During startup, the application example screens a banner followed by the list of
  * available commands as a welcome message:
  *
  *      *******************
  *      * 6 STEP LIB *
  *      *******************
  *      List of commands:
  *      
  *       <GETSPD> Get Motor Speed
  *       <GETSTA> Get Motor Status
  *       <SELMOT> Select Motor
  *       <SETDIR> Set Motor Direction
  *       <SETSPD> Set Motor Speed
  *       <STARTM> Start Motor
  *       <STOPMT> Stop Motor
  *      
  * 
  * Then, the application waits for the user to type a command and press the enter key to execute it.
  * Each command is 6 characters long. For commands that expect parameter: First type the name of the 
  * command and press enter; Then, a prompt line invites the user to enter the value of the argument.
  * 
  * Description of available commands are:
  * - GETSPD: Returns the mechanical speed of the selected motor (in RPM).
  * - GETSTA: Returns the status of the selected motor among: IDLE, STOP, ALIGNMENT, 
  *           STARTUP, RUN, SPEEDFDBKERROR, OVERCURRENT, VALIDATION_FAIL, LF_TIMER_FAILURE.
  * - SELMOT: Select the motor to drive. This command does nothing on single drive setup.
  * - SETDIR: Sets the direction of the selected motor. Parameter is either CW (Clockwise) or 
  *           CCW (Counter Clockwise).
  * - SETSPD: Sets the mechanical speed reference of the selected motor. This command is active only
  *           when the speed loop has been built in the application. Parameter is the speed (in RPM).
  * - STARTM: Starts the selected motor.
  * - STOPMT: Stops the selected motor.
  *
  * ---------------------------------------
  * @par How to configure the application ?
  *
  *  In its current state the configuration possibilities of the application example are limited.
  * The Motor Control Workbench cannot be used for that purpose: parameters, that users can set
  * with it, are not linked to the 6 steps code (except the PID filter for the speed).
  * Actually, the Motor Control Workbench is mainly useful to generate the example project
  * in the first place and for its monitor feature.
  *
  *  There are two ways to configure the example:
  *
  *  1. First, by using STM32CubeMx, to choose which 6-Step features to use: In the Pinout and 
  * Configuration view, peripheral pane, click on "A-Z" to list all peripherals and middlewares
  * in alphabetical order. Browse down to MotorControl and click on it. This opens a pane in the
  * middle of the window, showing some configuration options. 
  *
  * - SIX_STEP_SENSING configures the sensing method: SENSORS_LESS or HALL_SENSORS usage.
  * - SIX_STEP_CONTROL_MODE allows for choosing between CURRENT and VOLTAGE control mode.
  * - SIX_STEP_SPEED_LOOP: when checked, a speed regulation loop is built in the application and
  *   mechanical speed reference can be set. This is the default for this application.
  *   When unchecked, the speed is not regulated and the only way to control the motor is setting the
  *   PWM duty cycle applied to the active phase(s). Such a control cannot be achieved with the
  *   Motor Control Monitor at the moment.
  * - SIX_STEP_SET_POINT_RAMPING: when checked, it builds the Set Point Ramping feature in the application.
  * - SIX_STEP_THREE_PWM: this must be checked for power boards where the MCU drives uses Enable signals  
  *   instead of the managing also the complementary PWM channels, as for the X-NUCLEO-IHM16M1 or the
  *   X-NUCLEO-IHM07M1 power boards and more generally with gate drivers like the L6230 or the STSPIN 830.
  * - ST MC Monitor usage: when checked, it uses the ST MCSDK monitor feature as the GUI.
  *   When unchecked, it uses the TeraTerm application as the GUI.
  * 
  *  2. Other parameters, like motor parameters or PID factors for instance can be changed in the USER CODE 
  * sections of the 6step_conf_*.h files.
  *
  * ----------------------
  * @par How to build it ? 
  * 
  * In order to build the demonstration program, you proceed exactly as follow:
  * 1/ Open the 6Steps-NUCLEOF401RETx-IHM07-BullRunning.stmcx file with STM32 Motor Control Workbench PC software tool 
  *    and save it to another, but empty, location.
  *    BEWARE:
  *    -------
  *    Do not change the name of the 6Steps-NUCLEOF401RETx-IHM07-BullRunning.stmcx file,
  *    otherwise the example won't run or compile properly;
  *
  * 2/ Open the "extras.wb_def" file with a text editor to change user I/F.
  *    Change the value of the SERIAL_COMMUNICATION key as false for CLI usage.
  *    (by default, it is the ST MC Monitor user interface - this key value is true).
  *
  * 3/ Click on the Tool->Generation menu item. This pops-up a dialog window that lets user selection
  *    on various parameters:
  *    -> Select version 5.3.0 or later for STM32CubeMx;
  *    -> Select your installed IDE version for IAR EWARM or Keil MDK Arm;
  *    -> Select STM32 FW V1.24.1 or later for the Firmware Package version;
  *    -> Make sure to check box about the HAL usage for the Drive Type.
  *    Then, click on the UPDATE button (literally please).
  *
  * 4/ Open the generated project with your favorite IDE;
  *
  * 5/ Build the project and load the resulting binary image into the MCU board;
  *
  * 6/ Reset your MCU board;
  *
  * 7/ Run the example : One can use the BLUE button on the board to start and stop the motor.
  *    Alternatively, the ST MC Monitor or the console interface can be used.
  *    This interface provides more control over the application.
  *    See above for all the details about how to use it.
  * 
  * ******************** (C) COPYRIGHT 2019 STMicroelectronics *******************
  **/