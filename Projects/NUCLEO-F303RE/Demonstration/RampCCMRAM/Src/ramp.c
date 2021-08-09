/**
  ******************************************************************************
  * @file           : ramp.c
  * @brief          : ramp example program body
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
#include "parameters_conversion_f30x.h"
#include "pmsm_motor_parameters.h"
#include "parameters_conversion.h"
#include "mc_interface.h"
#include "speed_pos_fdbk.h"
#include "motorcontrol.h"

/* Private typedef -----------------------------------------------------------*/

/* Private defines -----------------------------------------------------------*/
/*********************** DEFINE for USER STATE MACHINE  ***********************/
#define US_RESET        0x00 
#define US_POSITIVE_RUN 0x01
#define US_STOP         0x02
#define US_RAMP         0x03
#define US_SPEED        0x04
#define COUNT_MAX_SEC  5
#define STOP_DURATION_SEC 3
#define COUNT_MAX (COUNT_MAX_SEC * USER_TIMEBASE_FREQUENCY_HZ)
#define STOP_DURATION  (STOP_DURATION_SEC * USER_TIMEBASE_FREQUENCY_HZ)
#define USER_TIMEBASE_FREQUENCY_HZ        10
#define USER_TIMEBASE_OCCURENCE_TICKS  (SYS_TICK_FREQUENCY/USER_TIMEBASE_FREQUENCY_HZ)-1u

/* Global variables ----------------------------------------------------------*/
static uint8_t User_State = US_RESET;
bool cmd_status = false;
static uint16_t UserCnt = 0;
int16_t value_Speed_RPM = 0;
uint16_t speed_max_valueRPM = MOTOR_MAX_SPEED_RPM;     /* Maximum value for speed reference from Workbench */
uint16_t speed_first_valueRPM = 7500;                  /* Set the first value for the speed ramp */
uint16_t speed_firstramp_duration = 200;               /* Set the duration for first ramp */
uint16_t speed_second_valueRPM = 2500;                 /* Set the second value for the speed ramp */
uint16_t speed_secondramp_duration = 500;              /* Set the duration for second ramp */
SpeednPosFdbk_Handle_t *speedSensHdl = (SpeednPosFdbk_Handle_t *) & STO_PLL_M1;

/* Private macros ------------------------------------------------------------*/

/* Function prototypes -----------------------------------------------*/

/* Function -----------------------------------------------*/
/*This is the main function to use in the main.c in order to start the current example */
void ramp_demo()
{

  HAL_Delay( USER_TIMEBASE_OCCURENCE_TICKS );

  /* User defined code */
  switch (User_State)
  {
    case US_RESET:
    {
      /* Next state */
      /* This command sets what will be the first speed ramp after the
      MCI_StartMotor command. It requires as first parameter the pMciHdl[0], as
      second parameter the target mechanical speed in thenth of Hz and as
      third parameter the speed ramp duration in milliseconds. */
      MC_ProgramSpeedRampMotor1(speed_first_valueRPM*SPEED_UNIT/_RPM, speed_firstramp_duration);

      /* This is a user command used to start the motor. The speed ramp shall be
      pre programmed before the command.*/
      cmd_status = MC_StartMotor1();

      /* It verifies if the command  "MCI_StartMotor" is successfully executed
      otherwise it tries to restart the procedure */
      if(cmd_status==false)
      {
        User_State = US_RESET; // Command NOT executed
      }
      else
        User_State = US_RAMP;           // Command executed

      UserCnt = 0;

    }
    break;  
    case US_RAMP:
    { 
      /* It returns TRUE if the ramp is completed, FALSE otherwise. */  
      if( MC_HasRampCompletedMotor1() )
       {  
        UserCnt = 0;
        User_State = US_SPEED;            // Command executed
       }          
    }
    break;  
   
    case US_SPEED:
    { 
       value_Speed_RPM = SPD_GetAvrgMecSpeedUnit(speedSensHdl)*_RPM/SPEED_UNIT;
     
       /* The following code controls if the speed target is reached otherwise it remains in current state machine state*/
       if(value_Speed_RPM >=(speed_first_valueRPM-6))
        {
         /* The speed target has been reached */ 
         User_State = US_POSITIVE_RUN;    
         UserCnt = 0;
        }        
    }
    break;      

    case US_POSITIVE_RUN:
    {      
       
      /* It counts the delay time for new speed value assignment  */
      if (UserCnt < COUNT_MAX) 
       {
        UserCnt++;
       }
      else
       {
        UserCnt=0;     
          
        MC_ProgramSpeedRampMotor1( speed_second_valueRPM*SPEED_UNIT/_RPM, speed_secondramp_duration );
       }
       value_Speed_RPM = SPD_GetAvrgMecSpeedUnit(speedSensHdl)*_RPM/SPEED_UNIT;
      
       /* The following code controls if the speed target goes below minimum value  */
       if(value_Speed_RPM <=1000)
        {
         User_State = US_STOP;    
         UserCnt = 0;
        }
    }  
    break;
    
    case US_STOP:
    {
       /* This is a user command to stop the motor */
       MC_StopMotor1();
        
       /* After the time "STOP_DURATION" the motor will be restarted */
       if (UserCnt >= STOP_DURATION)
          {
            /* Next state */ 
            
            User_State = US_RESET;
            UserCnt = 0;
          }
          else
          {
            UserCnt++;
          }
    }
    break;  
  }
}

/************************ (C) COPYRIGHT STMicroelectronics *****END OF FILE****/
