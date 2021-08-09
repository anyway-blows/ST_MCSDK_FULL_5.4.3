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

#define USER_TIMEBASE_FREQUENCY_HZ        10
#define USER_TIMEBASE_OCCURENCE_TICKS  (SYS_TICK_FREQUENCY/USER_TIMEBASE_FREQUENCY_HZ)-1u

#define M_MIN_SPEED_RPM         200                     /* Minimum reachable speed by using GimBal motor for this demonstration  */
#define POT_POS_THRESHOLD       64                      /* Threshold to ensure a minimum potentiometer position to restart motor  */
#define SPEED_RAMP_DURATION     100

/* Global variables ----------------------------------------------------------*/

bool SpeedRegValueAvailable;
bool AutoRestartAsked;
uint16_t Mimimum_PositionValue;

/* Private macros ------------------------------------------------------------*/

/* Function prototypes -----------------------------------------------*/
bool POT_ReadSpeedRegulation(uint8_t handle, uint16_t *potentiometer_value);

/* Function -----------------------------------------------*/

void PotentiometerControl_Init(uint8_t handle)
{

    AutoRestartAsked = false;  /* Disabled during first StartUp call */

    Mimimum_PositionValue = ((M_MIN_SPEED_RPM*65520)/MOTOR_MAX_SPEED_RPM) - 1;

    return;
}

void PotentiometerControl(uint8_t handle)
{

   uint8_t StartUpStatus;
   uint16_t potentiometer_value;
   int16_t Potentiometer_FinalSpeed;
    
   /* Time for user program to be executed */
   HAL_Delay( USER_TIMEBASE_OCCURENCE_TICKS );

   /* Get motor state */
   State_t MState = MC_GetSTMStateMotor1();
    
   /* User defined code */
   switch (MState)
   {
      case IDLE:
      {
         if (AutoRestartAsked )
         {
            SpeedRegValueAvailable = POT_ReadSpeedRegulation(handle, &potentiometer_value);

            if (SpeedRegValueAvailable)
            {
               /* Restart to be proceeded after a minimum speed */
               if (potentiometer_value >= Mimimum_PositionValue + POT_POS_THRESHOLD)
               {
                  MC_ProgramSpeedRampMotor1( (OBS_MINIMUM_SPEED_RPM * SPEED_UNIT / _RPM), SPEED_RAMP_DURATION );
                  StartUpStatus = MC_StartMotor1();
                  if (StartUpStatus)
                  {
                     AutoRestartAsked = false;   /* Disable auto restart */
                  }
               }
            }
         }
      }
      break;

      case RUN:
      {

         SpeedRegValueAvailable = POT_ReadSpeedRegulation(handle, &potentiometer_value);

         if (SpeedRegValueAvailable)
         {

            if (potentiometer_value <= Mimimum_PositionValue)
            {
                 /* Stop motor */
               MC_StopMotor1();
               if ( (MState == FAULT_NOW) || (MState == FAULT_OVER)  )
               {
                  MC_AcknowledgeFaultMotor1();
               }

               AutoRestartAsked = true;  /* Enable auto restart for next run */
            }
            else
            {
               /* Program motor speed reference accordingly to potentiometer value
                  - via ADC on channel PC2 */
               Potentiometer_FinalSpeed = ((potentiometer_value + 1) * MOTOR_MAX_SPEED_RPM) / 65520;
               MC_ProgramSpeedRampMotor1((Potentiometer_FinalSpeed * SPEED_UNIT / _RPM), SPEED_RAMP_DURATION);
            }
         }
      }
      break;

   }
    
   return;
}

bool POT_ReadSpeedRegulation(uint8_t handle, uint16_t *potentiometer_value)
{
   bool RetVal = false;

   /* Check regular conversion state */
   if (RCM_GetUserConvState() == RCM_USERCONV_IDLE)
   {
      /* if Idle, then program a new conversion request */
      RCM_RequestUserConv(handle);
   }
   else if (RCM_GetUserConvState() == RCM_USERCONV_EOC)
   {
      /* if completed, then read the captured value */
      *potentiometer_value = RCM_GetUserConv();
      RetVal = true;
   }

   return(RetVal);
}

/************************ (C) COPYRIGHT STMicroelectronics *****END OF FILE****/
