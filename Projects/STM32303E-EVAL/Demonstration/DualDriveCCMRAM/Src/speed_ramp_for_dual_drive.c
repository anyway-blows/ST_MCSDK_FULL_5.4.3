/**
  ******************************************************************************
  * @file           : speed_ramp_for_dual_drive.c
  * @brief          : Speed Ramp for Dual Drive Motors Demonstration Program
  ******************************************************************************
  * @attention
  *
  * <h2><center>&copy; Copyright (c) 2019 STMicroelectronics.
  * All rights reserved.</center></h2>
  *
  * This software component is licensed by ST under Ultimate Liberty license
  * SLA0044, the "License"; You may not use this file except in compliance with
  * the License. You may obtain a copy of the License at:
  *                             www.st.com/SLA0044
  *
  ******************************************************************************
  */

/* Includes ------------------------------------------------------------------*/
#include "speed_ramp_for_dual_drive.h"

/* Private typedef -----------------------------------------------------------*/

/* Private defines -----------------------------------------------------------*/
/*********************** DEFINE for USER STATE MACHINE  ***********************/
#define US_RESET        0x00    /* Start program with 1st speed ramp */
#define US_RAMP_UP      0x01    /* 1st up-speed ramp generation and control */
#define US_RAMP_DWN     0x02    /* 2nd dwn-speed ramp generation and control */
#define US_STOP         0x03    /* Prepare state machine to restart */

#define COUNT_MAX_SEC  5
#define STOP_DURATION_SEC 3
#define COUNT_MAX (COUNT_MAX_SEC * USER_TIMEBASE_FREQUENCY_HZ)
#define STOP_DURATION  (STOP_DURATION_SEC * USER_TIMEBASE_FREQUENCY_HZ)
#define USER_TIMEBASE_FREQUENCY_HZ        10
#define USER_TIMEBASE_OCCURENCE_TICKS  (SYS_TICK_FREQUENCY/USER_TIMEBASE_FREQUENCY_HZ)-1u

/* Global variables ----------------------------------------------------------*/
static uint8_t User_State = US_RESET;                   /* Demonstration State Machine */
static uint16_t UserCnt = 0;                            /* Chronometer for demonstration */
int16_t value_Speed_RPM_M1 = 0;                         /* Measured speed for motor1 */
int16_t value_Speed_RPM_M2 = 0;                         /* Measured speed for motor2 */

uint16_t speed_max_valueRPM = MOTOR_MAX_SPEED_RPM;      /* Maximum speed reference from Workbench */
uint16_t speed_first_valueRPM = 2500;                   /* Set the first value for the speed ramp */
uint16_t speed_firstramp_duration = 500;                /* Set the duration for first ramp */
uint16_t speed_second_valueRPM = 1500;                  /* Set the second value for the speed ramp */
uint16_t speed_secondramp_duration = 200;               /* Set the duration for second ramp */

/* Private macros ------------------------------------------------------------*/

/* Function prototypes -----------------------------------------------*/
void demo_dual_drive(void);

/* Function -----------------------------------------------*/
/*This is the main function to use in the main.c in order to start the demonstration */
void demo_dual_drive()
{
  /* Time for user program to be executed */
  HAL_Delay( USER_TIMEBASE_OCCURENCE_TICKS );
  /* Get all motors state machine */
    State_t M1State = MC_GetSTMStateMotor1();
    State_t M2State = MC_GetSTMStateMotor2();
    
    /* User defined code */
    switch (User_State)
    {
      case US_RESET:
      {
        /* Depending on the state machine of the motor : */
        if (M1State == IDLE)
        {
          /* Do 1st linear speed ramp pre-configuration for motor1 */
          MC_ProgramSpeedRampMotor1((speed_first_valueRPM / 6), speed_firstramp_duration);
        }
        
        if (M2State == IDLE)
        {
          /* Do 2nd linear speed ramp pre-configuration for motor2 */
          MC_ProgramSpeedRampMotor2((speed_second_valueRPM / 6), speed_secondramp_duration);
        }
        
        if ( (M1State == RUN) && (M2State == RUN) )
        {
          /* Execute respective linear speed ramp for all motors */
          User_State = US_RAMP_UP;
        }
        
         /* Stop motor(s) showing trouble(s) */
        if ( (M1State == FAULT_NOW) || (M1State == FAULT_OVER) )
        {
          MC_StopMotor1();
        }
        
        if ( (M2State == FAULT_NOW) || (M2State == FAULT_OVER) )
        {
          MC_StopMotor2();
        }
        
        if ( (M1State == FAULT_NOW) || (M1State == FAULT_OVER) ||
             (M2State == FAULT_NOW) || (M2State == FAULT_OVER) )
        {
          User_State = US_STOP;
        }
        
        /* Reset the Chrono */
        UserCnt = 0;
      }
      break;

      case US_RAMP_UP:
      {
        /* Respective linear speeds ramp configuration for motors.
           It is executed immediately when motors are spinning.
        */
        MC_ProgramSpeedRampMotor1((speed_first_valueRPM / 6), speed_firstramp_duration);
        MC_ProgramSpeedRampMotor2((speed_second_valueRPM / 6), speed_secondramp_duration);
        
        /* Check all speeds value */
        value_Speed_RPM_M1 = MC_GetMecSpeedAverageMotor1() * 6;
        value_Speed_RPM_M2 = MC_GetMecSpeedAverageMotor2() * 6;

        if ( (value_Speed_RPM_M1 <= (speed_first_valueRPM + 6)) &&
             (value_Speed_RPM_M1 >= (speed_first_valueRPM - 6)) &&
             (value_Speed_RPM_M2 <= (speed_second_valueRPM + 6)) &&
             (value_Speed_RPM_M2 >= (speed_second_valueRPM - 6)) )
        {
          /* Keep all speeds during the Chrono */
          if (UserCnt < COUNT_MAX)
          {
            UserCnt++;
          }
          else
          {
            /* All speeds target have been reached and time is elapsed
               -> Go to next step
            */ 
            UserCnt = 0;
            User_State = US_RAMP_DWN;
          }
        }
        else
        {
          /* Check the speed is above a minimum value, otherwise stop all motors */
          if (value_Speed_RPM_M1 <= 500)
          {
            MC_StopMotor1();
          }
          if (value_Speed_RPM_M2 <= 500)
          {
            MC_StopMotor2();
          }
          if ( (value_Speed_RPM_M1 <= 500) || (value_Speed_RPM_M2 <= 500) )
          {          
            User_State = US_STOP;
            UserCnt = 0;
          }
        }
      }
      break;

      case US_RAMP_DWN:
      {
        /* Respective linear speeds ramp configuration for motors.
           It is executed immediately when motors are spinning.
        */
        MC_ProgramSpeedRampMotor1((speed_second_valueRPM / 6), speed_secondramp_duration);
        MC_ProgramSpeedRampMotor2((speed_first_valueRPM / 6), speed_firstramp_duration);
        
        /* Check all speeds value */
        value_Speed_RPM_M1 = MC_GetMecSpeedAverageMotor1() * 6;
        value_Speed_RPM_M2 = MC_GetMecSpeedAverageMotor2() * 6;

        if ( (value_Speed_RPM_M1 <= (speed_second_valueRPM + 6)) &&
             (value_Speed_RPM_M1 >= (speed_second_valueRPM - 6)) &&
             (value_Speed_RPM_M2 <= (speed_first_valueRPM + 6)) &&
             (value_Speed_RPM_M2 >= (speed_first_valueRPM - 6)) )
        {
          /* Keep all speeds during the Chrono */
          if (UserCnt < COUNT_MAX)
          {
            UserCnt++;
          }
          else
          {
            /* All speeds target have been reached and time is elapsed
               -> Go to next step
            */ 
            UserCnt = 0;
            User_State = US_RAMP_UP;
          }
        }
        else
        {
          /* Check the speed is above a minimum value, otherwise stop all motors */
          if (value_Speed_RPM_M1 <= 500)
          {
            MC_StopMotor1();
          }
          if (value_Speed_RPM_M2 <= 500)
          {
            MC_StopMotor2();
          }
          if ( (value_Speed_RPM_M1 <= 500) || (value_Speed_RPM_M2 <= 500) )
          {          
            User_State = US_STOP;
            UserCnt = 0;
          }
        }
      }
      break;

      case US_STOP:
      {
        /* Acknowledge fault automatically
           ---> But caution, this might be not safe for people !! */
        if ( (M1State == FAULT_NOW) || (M1State == FAULT_OVER) )
        {
          MC_AcknowledgeFaultMotor1();
        }
        if ( (M2State == FAULT_NOW) || (M2State == FAULT_OVER) )
        {
          MC_AcknowledgeFaultMotor2();
        }
        
        if ( ((M1State == IDLE) && (M2State == RUN)) ||
             ((M1State == RUN) && (M2State == IDLE)) ||
             ((M1State == IDLE) && (M2State == IDLE)) )
        {
          User_State = US_RESET;
        }
      }
      break;
    }
}

/************************ (C) COPYRIGHT STMicroelectronics *****END OF FILE****/
