/**
  ******************************************************************************
  * @file           : saw_speed_ramp.c
  * @brief          : Saw speed Ramp demonstration program
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
#include "saw_speed_ramp.h"

/* Private typedef -----------------------------------------------------------*/

/* Private defines -----------------------------------------------------------*/
/*********************** USER STATE MACHINE DEFINITION  ***********************/
#define US_RESET        0x00    /* Start program with 1st speed ramp */
#define US_RAMP_UP      0x01    /* 1st up-speed ramp generation and control */
#define US_RAMP_DWN     0x02    /* 2nd dwn-speed ramp generation and control */
#define US_STOP         0x03    /* Prepare state machine to restart */

#define COUNT_MAX_SEC  5
#define STOP_DURATION_SEC 3
#define COUNT_MAX (COUNT_MAX_SEC * USER_TIMEBASE_FREQUENCY_HZ)
#define STOP_DURATION  (STOP_DURATION_SEC * USER_TIMEBASE_FREQUENCY_HZ)
#define USER_TIMEBASE_FREQUENCY_HZ        10
#define USER_TIMEBASE_OCCURENCE_TICKS  ((SYS_TICK_FREQUENCY / USER_TIMEBASE_FREQUENCY_HZ) - 1u)

/* Global variables ----------------------------------------------------------*/
static uint8_t User_State = US_RESET;                   /* Demonstration State Machine */
static uint16_t UserCnt = 0;                            /* Chronometer for demonstration */
int16_t value_Speed_RPM = 0;                            /* Measured speed */

uint16_t speed_max_valueRPM = MOTOR_MAX_SPEED_RPM;      /* Maximum speed reference value from Workbench */
uint16_t speed_first_valueRPM = 7500;                   /* Set the first value for the speed ramp */
uint16_t speed_firstramp_duration = 200;                /* Set the duration for first ramp */
uint16_t speed_second_valueRPM = 2500;                  /* Set the second value for the speed ramp */
uint16_t speed_secondramp_duration = 500;               /* Set the duration for second ramp */

/* Private macros ------------------------------------------------------------*/

/* Function prototypes -----------------------------------------------*/

/* Function -----------------------------------------------*/
/* Main demonstration function used from the main.c */
void demo_ramp()
{
  /* Time for user program to be executed */
  HAL_Delay( USER_TIMEBASE_OCCURENCE_TICKS );

  /* Get the motor state machine */
  State_t MState = MC_GetSTMStateMotor1();
    
   /* User defined code */
    switch (User_State)
    {
      case US_RESET:
      {
        /* Depending on the state machine of the motor : */
        if (MState == IDLE)
        {
          /* Do 1st linear speed ramp pre-configuration */
          MC_ProgramSpeedRampMotor1( (speed_first_valueRPM * SPEED_UNIT / _RPM), speed_firstramp_duration );
        }
        
        if (MState == RUN)
        {
          /* Execute 1st linear up-speed ramp */
          User_State = US_RAMP_UP;
        }
        
        if ( (MState == FAULT_NOW) ||
             (MState == FAULT_OVER)  )
        {
          /* Stop motor in case of trouble */
          MC_StopMotor1();
          User_State = US_STOP;
        }

        /* Reset Chronometer */
        UserCnt = 0;
      }
      break;
    
      case US_RAMP_UP:
      { 
        /* 1st linear speed ramp configuration.
           It is executed immediately when motor is spinning.
        */
        MC_ProgramSpeedRampMotor1( (speed_first_valueRPM * SPEED_UNIT / _RPM), speed_firstramp_duration );
        
        /* Check the speed value */
        value_Speed_RPM = MC_GetMecSpeedAverageMotor1() * _RPM / SPEED_UNIT;
        if ( (value_Speed_RPM <= (speed_first_valueRPM + 6)) &&
             (value_Speed_RPM >= (speed_first_valueRPM - 6)) )
        {
          /* Keep speed during a chrono */
          if (UserCnt < COUNT_MAX)
          {
            UserCnt++;
          }
          else
          {
            /* The speed target has been reached and time is elapsed
               -> Go to next step
            */ 
            UserCnt = 0;
            User_State = US_RAMP_DWN;
          }
        }
        else
        {
          /* Check the speed is above a minimum value, otherwise stop the motor */
          if (value_Speed_RPM <= 1000)
          {
            MC_StopMotor1();
            User_State = US_STOP;
            UserCnt = 0;
          }
        }
      }
      break;  

      case US_RAMP_DWN:
      { 
        /* 2nd linear speed ramp configuration.
           It is executed immediately when motor is spinning.
        */
        MC_ProgramSpeedRampMotor1( (speed_second_valueRPM * SPEED_UNIT / _RPM), speed_secondramp_duration );        

        /* Check the speed value */
        value_Speed_RPM = MC_GetMecSpeedAverageMotor1() * _RPM / SPEED_UNIT;
        if ( (value_Speed_RPM <= (speed_second_valueRPM + 6)) &&
             (value_Speed_RPM >= (speed_second_valueRPM - 6)) )
        {
         /* Keep speed during a chrono */
          if (UserCnt < COUNT_MAX)
          {
            UserCnt++;
          }
          else
          {
            /* The speed target has been reached and time is elapsed
               -> Go to next step
            */ 
            UserCnt = 0;
            User_State = US_RAMP_UP;
          }
        }
        else
        {
          /* Check the speed is above a minimum value, otherwise stop the motor */
          if (value_Speed_RPM <= 1000)
          {
            MC_StopMotor1();
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
        if ( (MState == FAULT_NOW) ||
             (MState == FAULT_OVER)  )
        {
          MC_AcknowledgeFaultMotor1();
        }
        
        if (MState == IDLE)
        {
          User_State = US_RESET;
        }
      }
      break;
    }
    
}

/************************ (C) COPYRIGHT STMicroelectronics *****END OF FILE****/
