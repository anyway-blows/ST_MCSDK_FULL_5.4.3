/**
  ******************************************************************************
  * @file           : potentiometer.c
  * @brief          : potentiometer demonstration program body
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
#include "mc_api.h"
#include "regular_conversion_manager.h"
#include "parameters_conversion.h"    

/* Private typedef -----------------------------------------------------------*/

/* Private defines -----------------------------------------------------------*/
/*********************** DEFINE for USER STATE MACHINE  ***********************/
#define US_RESET        0x00    /* Start program with speed ramp */
#define US_RUN          0x01    /* speed control */
#define US_STOP         0x02    /* Prepare state machine to restart */

#define COUNT_MAX_SEC  3
#define STOP_DURATION_SEC 2
#define COUNT_MAX (COUNT_MAX_SEC * USER_TIMEBASE_FREQUENCY_HZ)
#define STOP_DURATION  (STOP_DURATION_SEC * USER_TIMEBASE_FREQUENCY_HZ)
#define USER_TIMEBASE_FREQUENCY_HZ        10
#define USER_TIMEBASE_OCCURENCE_TICKS  (SYS_TICK_FREQUENCY/USER_TIMEBASE_FREQUENCY_HZ)-1u

/* Global variables ----------------------------------------------------------*/

static uint8_t User_State = US_RESET;                   /* Demonstration State Machine */
static uint16_t UserCnt = 0;                            /* Chronometer for demonstration */
uint16_t potentiometer_value = 0;                       /* Default potentiometer value */

uint16_t speed_max_valueRPM = MOTOR_MAX_SPEED_RPM;      /* Maximum speed reference value from Workbench */
uint16_t speed_min_valueRPM = 1000;                     /* Set the minimum value for the speed reference */
uint16_t speed_ramp_duration = 500;                     /* Set the duration for speed ramp */ 

/* Private macros ------------------------------------------------------------*/

/* Function prototypes -----------------------------------------------*/

/* Function -----------------------------------------------*/

/* Main demonstration function used from the main.c */
void demo_potentiometer(uint8_t handle)
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
          /* Do linear speed ramp pre-configuration */
          MC_ProgramSpeedRampMotor1((speed_min_valueRPM / 6), speed_ramp_duration);
        }
        
        if (MState == RUN)
        {
          /* Motor is ready for demo */
          User_State = US_RUN;
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
      
      case US_RUN:
      {
        /* Check regular conversion readiness */
        if (RCM_GetUserConvState() == RCM_USERCONV_IDLE)
        {
          /* if Idle, then program a new conversion request */
          RCM_RequestUserConv(handle);
        }
        else if (RCM_GetUserConvState() == RCM_USERCONV_EOC)
        {
          /* if Done, then read the captured value */
          potentiometer_value = RCM_GetUserConv();
        }

        /* Keep speed during a chrono */
        if (UserCnt < COUNT_MAX)
        {
          UserCnt++;
        }
        else
        {
          /* Check the speed is above a minimum value, otherwise stop the motor */
          if ( ((potentiometer_value + 1) * speed_max_valueRPM / 65535) <= speed_min_valueRPM )
          {
            MC_StopMotor1();
            User_State = US_STOP;
            UserCnt = 0;
          }
          else
          {
            /* Program motor speed reference accordingly to potentiometer value
               - via ADC on channel PC4 */         
            MC_ProgramSpeedRampMotor1((((potentiometer_value + 1) * speed_max_valueRPM / 65535) / 6), speed_ramp_duration);
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
