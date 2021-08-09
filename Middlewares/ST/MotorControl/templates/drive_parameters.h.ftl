<#ftl>
<#if !MC??>
<#if SWIPdatas??>
<#list SWIPdatas as SWIP>
<#if SWIP.ipName == "MotorControl">
<#if SWIP.parameters??>
<#assign MC = SWIP.parameters>
<#break>
</#if>
</#if>
</#list>
</#if>
<#if MC??>
<#else>
<#stop "No MotorControl SW IP data found">
</#if>
</#if>

<#function Fx_Freq_Scaling pwm_freq>
<#list [ 1 , 2 , 4 , 8 , 16 ] as scaling>
       <#if (pwm_freq/scaling) < 65536 >
            <#return scaling >
        </#if>
    </#list>
    <#return 1 >
</#function>

/**
  ******************************************************************************
  * @file    drive_parameters.h
  * @author  Motor Control SDK Team, ST Microelectronics
  * @brief   This file contains the parameters needed for the Motor Control SDK
  *          in order to configure a motor drive.
  *
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

/* Define to prevent recursive inclusion -------------------------------------*/
#ifndef __DRIVE_PARAMETERS_H
#define __DRIVE_PARAMETERS_H

<#if MC.DUALDRIVE == true>
/**************************
 *** Motor 1 Parameters ***
 **************************/
<#else>
/************************
 *** Motor Parameters ***
 ************************/
</#if>

/******** MAIN AND AUXILIARY SPEED/POSITION SENSOR(S) SETTINGS SECTION ********/

/*** Speed measurement settings ***/
#define MAX_APPLICATION_SPEED_RPM       ${MC.MAX_APPLICATION_SPEED} /*!< rpm, mechanical */
#define MIN_APPLICATION_SPEED_RPM       ${MC.MIN_APPLICATION_SPEED} /*!< rpm, mechanical,  
                                                           absolute value */
#define MEAS_ERRORS_BEFORE_FAULTS       ${MC.MEAS_ERRORS_BEFORE_FAULTS} /*!< Number of speed  
                                                             measurement errors before 
                                                             main sensor goes in fault */
<#if MC.ENCODER || MC.AUX_ENCODER >
/*** Encoder **********************/                                                                                                           
#define ENC_MEAS_ERRORS_BEFORE_FAULTS   ${MC.ENC_MEAS_ERRORS_BEFORE_FAULTS} /*!< Number of failed   
                                                        derived class specific speed 
                                                        measurements before main sensor  
                                                        goes in fault */

#define ENC_INVERT_SPEED                DISABLE  /*!< To be enabled for  
                                                            encoder (main or aux) if  
                                                            measured speed is opposite 
                                                            to real one */        
#define ENC_AVERAGING_FIFO_DEPTH        ${MC.ENC_AVERAGING_FIFO_DEPTH} /*!< depth of the FIFO used to 
                                                              average mechanical speed in 
                                                              0.1Hz resolution */
</#if>
<#if MC.HALL_SENSORS || MC.AUX_HALL_SENSORS >
/****** Hall sensors ************/ 
#define HALL_MEAS_ERRORS_BEFORE_FAULTS  ${MC.HALL_MEAS_ERRORS_BEFORE_FAULTS} /*!< Number of failed   
                                                           derived class specific speed 
                                                           measurements before main sensor  
                                                           goes in fault */

#define HALL_AVERAGING_FIFO_DEPTH        ${MC.HALL_AVERAGING_FIFO_DEPTH} /*!< depth of the FIFO used to 
                                                           average mechanical speed in 
                                                           0.1Hz resolution */  
#define HALL_MTPA <#if MC.HALL_MTPA > true <#else> false </#if>                                                           
</#if>
<#if MC.STATE_OBSERVER_PLL ||  MC.AUX_STATE_OBSERVER_PLL >
/****** State Observer + PLL ****/
#define VARIANCE_THRESHOLD             <#if MC.OPEN_LOOP_FOC> 0 <#else> ${MC.VARIANCE_THRESHOLD}</#if> /*!<Maximum accepted 
                                                            variance on speed 
                                                            estimates (percentage) */
/* State observer scaling factors F1 */                    
#define F1                               ${MC.F1}
#define F2                               ${MC.F2}
#define F1_LOG                           LOG2(${MC.F1})
#define F2_LOG                           LOG2(${MC.F2})

/* State observer constants */
#define GAIN1                            ${MC.GAIN1}
#define GAIN2                            ${MC.GAIN2}
/*Only in case PLL is used, PLL gains */
#define PLL_KP_GAIN                      ${MC.PLL_KP_GAIN}
#define PLL_KI_GAIN                      ${MC.PLL_KI_GAIN}
#define PLL_KPDIV     16384
#define PLL_KPDIV_LOG LOG2(PLL_KPDIV)
#define PLL_KIDIV     65535
#define PLL_KIDIV_LOG LOG2(PLL_KIDIV)

#define OBS_MEAS_ERRORS_BEFORE_FAULTS    ${MC.OBS_MEAS_ERRORS_BEFORE_FAULTS}  /*!< Number of consecutive errors   
                                                           on variance test before a speed 
                                                           feedback error is reported */
#define STO_FIFO_DEPTH_DPP               ${MC.STO_FIFO_DEPTH_DPP}  /*!< Depth of the FIFO used  
                                                            to average mechanical speed  
                                                            in dpp format */
#define STO_FIFO_DEPTH_DPP_LOG           LOG2(${MC.STO_FIFO_DEPTH_DPP})
                                                            
#define STO_FIFO_DEPTH_UNIT              ${MC.STO_FIFO_DEPTH_01HZ}  /*!< Depth of the FIFO used  
                                                            to average mechanical speed 
                                                            in the unit defined by #SPEED_UNIT */
#define BEMF_CONSISTENCY_TOL             ${MC.BEMF_CONSISTENCY_TOL}   /* Parameter for B-emf 
                                                            amplitude-speed consistency */
#define BEMF_CONSISTENCY_GAIN            ${MC.BEMF_CONSISTENCY_GAIN}   /* Parameter for B-emf 
                                                           amplitude-speed consistency */
                                                                                
</#if>
<#if MC.STATE_OBSERVER_CORDIC || MC.AUX_STATE_OBSERVER_CORDIC >  
/****** State Observer + CORDIC ***/
#define CORD_VARIANCE_THRESHOLD          <#if MC.OPEN_LOOP_FOC> 0 <#else> ${MC.CORD_VARIANCE_THRESHOLD} </#if> /*!<Maxiumum accepted 
                                                            variance on speed 
                                                            estimates (percentage) */                                                                                                                
#define CORD_F1                          ${MC.CORD_F1}
#define CORD_F2                          ${MC.CORD_F2}
#define CORD_F1_LOG                      LOG2(${MC.CORD_F1})
#define CORD_F2_LOG                      LOG2(${MC.CORD_F2})

/* State observer constants */
#define CORD_GAIN1                       ${MC.CORD_GAIN1}
#define CORD_GAIN2                       ${MC.CORD_GAIN2}

#define CORD_MEAS_ERRORS_BEFORE_FAULTS   ${MC.CORD_MEAS_ERRORS_BEFORE_FAULTS}  /*!< Number of consecutive errors   
                                                           on variance test before a speed 
                                                           feedback error is reported */
#define CORD_FIFO_DEPTH_DPP              ${MC.CORD_FIFO_DEPTH_DPP}  /*!< Depth of the FIFO used  
                                                            to average mechanical speed  
                                                            in dpp format */
#define CORD_FIFO_DEPTH_DPP_LOG          LOG2(${MC.CORD_FIFO_DEPTH_DPP})
                                                            
#define CORD_FIFO_DEPTH_UNIT            ${MC.CORD_FIFO_DEPTH_01HZ}  /*!< Depth of the FIFO used  
                                                           to average mechanical speed  
                                                           in dpp format */        
#define CORD_MAX_ACCEL_DPPP              ${MC.CORD_MAX_ACCEL_DPPP}  /*!< Maximum instantaneous 
                                                              electrical acceleration (dpp 
                                                              per control period) */
#define CORD_BEMF_CONSISTENCY_TOL        ${MC.CORD_BEMF_CONSISTENCY_TOL}  /* Parameter for B-emf 
                                                           amplitude-speed consistency */
#define CORD_BEMF_CONSISTENCY_GAIN       ${MC.CORD_BEMF_CONSISTENCY_GAIN}  /* Parameter for B-emf 
                                                          amplitude-speed consistency */
</#if>

/* USER CODE BEGIN angle reconstruction M1 */
<#if MC.STATE_OBSERVER_PLL == true || MC.STATE_OBSERVER_CORDIC == true>
#define PARK_ANGLE_COMPENSATION_FACTOR 0
</#if>
#define REV_PARK_ANGLE_COMPENSATION_FACTOR 0
/* USER CODE END angle reconstruction M1 */

<#if MC.HFINJECTION == true>
/****** HFI ******/
#define HFINJECTION

#define HFI_FREQUENCY                    ${MC.HFI_FREQUENCY}
#define HFI_AMPLITUDE                    ${MC.HFI_AMPLITUDE}

#define HFI_PID_KP_DEFAULT               ${MC.HFI_PID_KP_DEFAULT}
#define HFI_PID_KI_DEFAULT               ${MC.HFI_PID_KI_DEFAULT}
#define HFI_PID_KPDIV	                   ${MC.HFI_PID_KPDIV}
#define HFI_PID_KIDIV	                   ${MC.HFI_PID_KIDIV}
#define HFI_PID_KPDIV_LOG                LOG2(${MC.HFI_PID_KPDIV})
#define HFI_PID_KIDIV_LOG                LOG2(${MC.HFI_PID_KIDIV})

#define HFI_IDH_DELAY	                 32400

#define HFI_PLL_KP_DEFAULT               ${MC.HFI_PLL_KP_DEFAULT}
#define HFI_PLL_KI_DEFAULT               ${MC.HFI_PLL_KI_DEFAULT}

#define HFI_NOTCH_0_COEFF                ${MC.HFI_NOTCH_IQD_0_COEFF}
#define HFI_NOTCH_1_COEFF                ${MC.HFI_NOTCH_IQD_1_COEFF}
#define HFI_NOTCH_2_COEFF                ${MC.HFI_NOTCH_IQD_2_COEFF}
#define HFI_NOTCH_3_COEFF                ${MC.HFI_NOTCH_IQD_3_COEFF}
#define HFI_NOTCH_4_COEFF                ${MC.HFI_NOTCH_IQD_4_COEFF}

#define HFI_LP_0_COEFF                   ${MC.HFI_LP_ID_0_COEFF}
#define HFI_LP_1_COEFF                   ${MC.HFI_LP_ID_1_COEFF}
#define HFI_LP_2_COEFF                   ${MC.HFI_LP_ID_2_COEFF}
#define HFI_LP_3_COEFF                   ${MC.HFI_LP_ID_3_COEFF}
#define HFI_LP_4_COEFF                   ${MC.HFI_LP_ID_4_COEFF}

#define HFI_HP_0_COEFF                   ${MC.HFI_HP_ID_0_COEFF}
#define HFI_HP_1_COEFF                   ${MC.HFI_HP_ID_1_COEFF}
#define HFI_HP_2_COEFF                   ${MC.HFI_HP_ID_2_COEFF}
#define HFI_HP_3_COEFF                   ${MC.HFI_HP_ID_3_COEFF}
#define HFI_HP_4_COEFF                   ${MC.HFI_HP_ID_4_COEFF}

#define HFI_DC_0_COEFF                   ${MC.HFI_DC_0_COEFF}
#define HFI_DC_1_COEFF                   ${MC.HFI_DC_1_COEFF}
#define HFI_DC_2_COEFF                   ${MC.HFI_DC_2_COEFF}
#define HFI_DC_3_COEFF                   ${MC.HFI_DC_3_COEFF}
#define HFI_DC_4_COEFF                   ${MC.HFI_DC_4_COEFF}

#define HFI_MINIMUM_SPEED_RPM            ${MC.HFI_MINIMUM_SPEED_RPM}
#define HFI_SPD_BUFFER_DEPTH_01HZ        ${MC.HFI_SPD_BUFFER_DEPTH_01HZ}
#define HFI_LOCKFREQ                     ${MC.HFI_LOCKFREQ}
#define HFI_SCANROTATIONSNO              ${MC.HFI_SCANROTATIONSNO}
#define HFI_WAITBEFORESN                 ${MC.HFI_WAITBEFORESN}
#define HFI_WAITAFTERNS                  ${MC.HFI_WAITAFTERNS}
#define HFI_HIFRAMPLSCAN                 ${MC.HFI_HIFRAMPLSCAN}
#define HFI_NSMAXDETPOINTS               ${MC.HFI_NSMAXDETPOINTS}
#define HFI_NSDETPOINTSSKIP              ${MC.HFI_NSDETPOINTSSKIP}
#define	HFI_DEBUG_MODE                   false

#define HFI_STO_RPM_TH                   OBS_MINIMUM_SPEED_RPM
#define STO_HFI_RPM_TH                   ${MC.STO_HFI_RPM_TH}
#define HFI_RESTART_RPM_TH               (((HFI_STO_RPM_TH) + (STO_HFI_RPM_TH))/2)
#define HFI_NS_MIN_SAT_DIFF              ${MC.HFI_NS_MIN_SAT_DIFF}

#define HFI_REVERT_DIRECTION             true
#define HFI_WAITTRACK                    20
#define HFI_WAITSYNCH                    20
#define HFI_STEPANGLE                    3640
#define HFI_MAXANGLEDIFF                 3640
#define HFI_RESTARTTIMESEC               0.1
</#if>                                      

/**************************    DRIVE SETTINGS SECTION   **********************/
/* PWM generation and current reading */


#define PWM_FREQUENCY   ${MC.PWM_FREQUENCY}
#define PWM_FREQ_SCALING ${Fx_Freq_Scaling((MC.PWM_FREQUENCY)?number)}

#define LOW_SIDE_SIGNALS_ENABLING        ${MC.LOW_SIDE_SIGNALS_ENABLING}
<#if MC.LOW_SIDE_SIGNALS_ENABLING == 'LS_PWM_TIMER'>
#define SW_DEADTIME_NS                   ${MC.SW_DEADTIME_NS} /*!< Dead-time to be inserted  
                                                           by FW, only if low side 
                                                           signals are enabled */
</#if>
                                                                                         
/* Torque and flux regulation loops */
#define REGULATION_EXECUTION_RATE     ${MC.REGULATION_EXECUTION_RATE}    /*!< FOC execution rate in 
                                                           number of PWM cycles */     
/* Gains values for torque and flux control loops */
#define PID_TORQUE_KP_DEFAULT         ${MC.PID_TORQUE_KP_DEFAULT}       
#define PID_TORQUE_KI_DEFAULT         ${MC.PID_TORQUE_KI_DEFAULT}
#define PID_TORQUE_KD_DEFAULT         ${MC.PID_TORQUE_KD_DEFAULT}
#define PID_FLUX_KP_DEFAULT           ${MC.PID_FLUX_KP_DEFAULT}
#define PID_FLUX_KI_DEFAULT           ${MC.PID_FLUX_KI_DEFAULT}
#define PID_FLUX_KD_DEFAULT           ${MC.PID_FLUX_KD_DEFAULT}

/* Torque/Flux control loop gains dividers*/
#define TF_KPDIV                      ${MC.TF_KPDIV}
#define TF_KIDIV                      ${MC.TF_KIDIV}
#define TF_KDDIV                      ${MC.TF_KDDIV}
#define TF_KPDIV_LOG                  LOG2(${MC.TF_KPDIV})
#define TF_KIDIV_LOG                  LOG2(${MC.TF_KIDIV})
#define TF_KDDIV_LOG                  LOG2(${MC.TF_KDDIV})
#define TFDIFFERENTIAL_TERM_ENABLING  DISABLE

<#if MC.POSITION_CTRL_ENABLING == true >
#define POSITION_LOOP_FREQUENCY_HZ    ${MC.POSITION_LOOP_FREQUENCY_HZ} /*!<Execution rate of position control regulation loop (Hz) */
<#else>
/* Speed control loop */ 
#define SPEED_LOOP_FREQUENCY_HZ       ${MC.SPEED_LOOP_FREQUENCY_HZ} /*!<Execution rate of speed   
                                                      regulation loop (Hz) */
</#if>
                                        
#define PID_SPEED_KP_DEFAULT          ${MC.PID_SPEED_KP_DEFAULT}/(SPEED_UNIT/10) /* Workbench compute the gain for 01Hz unit*/
#define PID_SPEED_KI_DEFAULT          ${MC.PID_SPEED_KI_DEFAULT}/(SPEED_UNIT/10) /* Workbench compute the gain for 01Hz unit*/
#define PID_SPEED_KD_DEFAULT          ${MC.PID_SPEED_KD_DEFAULT}/(SPEED_UNIT/10) /* Workbench compute the gain for 01Hz unit*/
/* Speed PID parameter dividers */
#define SP_KPDIV                      ${MC.SP_KPDIV}
#define SP_KIDIV                      ${MC.SP_KIDIV}
#define SP_KDDIV                      ${MC.SP_KDDIV}
#define SP_KPDIV_LOG                  LOG2(${MC.SP_KPDIV})
#define SP_KIDIV_LOG                  LOG2(${MC.SP_KIDIV})
#define SP_KDDIV_LOG                  LOG2(${MC.SP_KDDIV})

/* USER CODE BEGIN PID_SPEED_INTEGRAL_INIT_DIV */
#define PID_SPEED_INTEGRAL_INIT_DIV 1 /*  */
/* USER CODE END PID_SPEED_INTEGRAL_INIT_DIV */

#define SPD_DIFFERENTIAL_TERM_ENABLING DISABLE
#define IQMAX                          ${MC.IQMAX}

/* Default settings */
#define DEFAULT_CONTROL_MODE           ${MC.DEFAULT_CONTROL_MODE} /*!< STC_TORQUE_MODE or 
                                                        STC_SPEED_MODE */
#define DEFAULT_TARGET_SPEED_RPM      <#if MC.OPEN_LOOP_FOC>OPEN_LOOP_SPEED_RPM<#else>${MC.DEFAULT_TARGET_SPEED_RPM}</#if>
#define DEFAULT_TARGET_SPEED_UNIT      (DEFAULT_TARGET_SPEED_RPM*SPEED_UNIT/_RPM)
#define DEFAULT_TORQUE_COMPONENT       ${MC.DEFAULT_TORQUE_COMPONENT}
#define DEFAULT_FLUX_COMPONENT         ${MC.DEFAULT_FLUX_COMPONENT}

<#if  MC.POSITION_CTRL_ENABLING == true >
#define PID_POSITION_KP_GAIN			${MC.POSITION_CTRL_KP_GAIN}
#define PID_POSITION_KI_GAIN			${MC.POSITION_CTRL_KI_GAIN}
#define PID_POSITION_KD_GAIN			${MC.POSITION_CTRL_KD_GAIN}
#define PID_POSITION_KPDIV				${MC.POSITION_CTRL_KPDIV}     
#define PID_POSITION_KIDIV				${MC.POSITION_CTRL_KIDIV}
#define PID_POSITION_KDDIV				${MC.POSITION_CTRL_KDDIV}
#define PID_POSITION_KPDIV_LOG			LOG2(${MC.POSITION_CTRL_KPDIV})    
#define PID_POSITION_KIDIV_LOG			LOG2(${MC.POSITION_CTRL_KIDIV}) 
#define PID_POSITION_KDDIV_LOG			LOG2(${MC.POSITION_CTRL_KDDIV}) 
#define PID_POSITION_ANGLE_STEP			${MC.POSITION_CTRL_ANGLE_STEP}
#define PID_POSITION_MOV_DURATION		${MC.POSITION_CTRL_MOV_DURATION}
</#if>


/**************************    FIRMWARE PROTECTIONS SECTION   *****************/
#define OV_VOLTAGE_PROT_ENABLING        ENABLE
#define UV_VOLTAGE_PROT_ENABLING        ENABLE
#define OV_VOLTAGE_THRESHOLD_V          ${MC.OV_VOLTAGE_THRESHOLD_V} /*!< Over-voltage 
                                                         threshold */
#define UD_VOLTAGE_THRESHOLD_V          ${MC.UD_VOLTAGE_THRESHOLD_V} /*!< Under-voltage 
                                                          threshold */
#if 0
#define ON_OVER_VOLTAGE                 ${MC.ON_OVER_VOLTAGE} /*!< TURN_OFF_PWM, 
                                                         TURN_ON_R_BRAKE or 
                                                         TURN_ON_LOW_SIDES */
#endif /* 0 */
#define R_BRAKE_SWITCH_OFF_THRES_V      ${MC.R_BRAKE_SWITCH_OFF_THRES_V}

#define OV_TEMPERATURE_THRESHOLD_C      ${MC.OV_TEMPERATURE_THRESHOLD_C} /*!< Celsius degrees */
#define OV_TEMPERATURE_HYSTERESIS_C     ${MC.OV_TEMPERATURE_HYSTERESIS_C} /*!< Celsius degrees */

#define HW_OV_CURRENT_PROT_BYPASS       DISABLE /*!< In case ON_OVER_VOLTAGE  
                                                          is set to TURN_ON_LOW_SIDES
                                                          this feature may be used to
                                                          bypass HW over-current
                                                          protection (if supported by 
                                                          power stage) */
/******************************   START-UP PARAMETERS   **********************/
<#if ( MC.ENCODER == true ||  MC.AUX_ENCODER == true)>
/* Encoder alignment */
#define ALIGNMENT_DURATION              ${MC.ALIGNMENT_DURATION} /*!< milliseconds */
#define ALIGNMENT_ANGLE_DEG             ${MC.ALIGNMENT_ANGLE_DEG} /*!< degrees [0...359] */
#define FINAL_I_ALIGNMENT               ${MC.FINAL_I_ALIGNMENT} /*!< s16A */
// With ALIGNMENT_ANGLE_DEG equal to 90 degrees final alignment 
// phase current = (FINAL_I_ALIGNMENT * 1.65/ Av)/(32767 * Rshunt)  
// being Av the voltage gain between Rshunt and A/D input
</#if>

<#if ( MC.STATE_OBSERVER_PLL || MC.STATE_OBSERVER_CORDIC )>
  <#if MC.OPEN_LOOP_FOC >
/* USER CODE BEGIN OPENLOOP M1 */

#define OPEN_LOOP_VOLTAGE_d           6000      /*!< Three Phase voltage amplitude
                                                      in int16_t format */
#define OPEN_LOOP_SPEED_RPM           100       /*!< Final forced speed in rpm */
#define OPEN_LOOP_SPEED_RAMP_DURATION_MS  1000  /*!< 0-to-Final speed ramp duration  */      
#define OPEN_LOOP_VF                  false     /*!< true to enable V/F mode */
#define OPEN_LOOP_K                   44        /*! Slope of V/F curve expressed in int16_t Voltage for 
                                                     each 0.1Hz of mecchanical frequency increment. */
#define OPEN_LOOP_OFF                 4400      /*! Offset of V/F curve expressed in int16_t Voltage 
                                                     applied when frequency is zero. */
/* USER CODE END OPENLOOP M1 */

/* Phase 1 */
#define PHASE1_DURATION		        OPEN_LOOP_SPEED_RAMP_DURATION_MS
#define PHASE1_FINAL_SPEED_UNIT	  (OPEN_LOOP_SPEED_RPM*SPEED_UNIT/_RPM)
#define PHASE1_FINAL_CURRENT      ${MC.PHASE1_FINAL_CURRENT}

/* Phase 2 */
#define PHASE2_DURATION		      65535   /*milliseconds */
#define PHASE2_FINAL_SPEED_RPM	  PHASE1_FINAL_SPEED_UNIT
#define PHASE2_FINAL_CURRENT      ${MC.PHASE2_FINAL_CURRENT}

/* Phase 3 */
#define PHASE3_DURATION		       65535   /*milliseconds */
#define PHASE3_FINAL_SPEED_RPM	  PHASE1_FINAL_SPEED_UNIT
#define PHASE3_FINAL_CURRENT      ${MC.PHASE3_FINAL_CURRENT}

/* Phase 4 */
#define PHASE4_DURATION		  65535   /*milliseconds */
#define PHASE4_FINAL_SPEED_RPM	  PHASE1_FINAL_SPEED_UNIT
#define PHASE4_FINAL_CURRENT      ${MC.PHASE4_FINAL_CURRENT}

/* Phase 5 */
#define PHASE5_DURATION		  65535    /* milliseconds */
#define PHASE5_FINAL_SPEED_RPM	  PHASE1_FINAL_SPEED_UNIT
#define PHASE5_FINAL_CURRENT      ${MC.PHASE5_FINAL_CURRENT}

 <#else> <#-- MC.OPEN_LOOP_FOC == false inside MC.STATE_OBSERVER_PLL || MC.STATE_OBSERVER_CORDIC -->
/* Phase 1 */
#define PHASE1_DURATION                ${MC.PHASE1_DURATION} /*milliseconds */
#define PHASE1_FINAL_SPEED_UNIT         (${MC.PHASE1_FINAL_SPEED_RPM}*SPEED_UNIT/_RPM) 
#define PHASE1_FINAL_CURRENT           ${MC.PHASE1_FINAL_CURRENT}
/* Phase 2 */
#define PHASE2_DURATION                ${MC.PHASE2_DURATION} /*milliseconds */
#define PHASE2_FINAL_SPEED_UNIT         (${MC.PHASE2_FINAL_SPEED_RPM}*SPEED_UNIT/_RPM)
#define PHASE2_FINAL_CURRENT           ${MC.PHASE2_FINAL_CURRENT}
/* Phase 3 */
#define PHASE3_DURATION                ${MC.PHASE3_DURATION} /*milliseconds */
#define PHASE3_FINAL_SPEED_UNIT         (${MC.PHASE3_FINAL_SPEED_RPM}*SPEED_UNIT/_RPM)
#define PHASE3_FINAL_CURRENT           ${MC.PHASE3_FINAL_CURRENT}
/* Phase 4 */
#define PHASE4_DURATION                ${MC.PHASE4_DURATION} /*milliseconds */
#define PHASE4_FINAL_SPEED_UNIT         (${MC.PHASE4_FINAL_SPEED_RPM}*SPEED_UNIT/_RPM)
#define PHASE4_FINAL_CURRENT           ${MC.PHASE4_FINAL_CURRENT}
/* Phase 5 */
#define PHASE5_DURATION                ${MC.PHASE5_DURATION} /* milliseconds */
#define PHASE5_FINAL_SPEED_UNIT         (${MC.PHASE5_FINAL_SPEED_RPM}*SPEED_UNIT/_RPM)
#define PHASE5_FINAL_CURRENT           ${MC.PHASE5_FINAL_CURRENT}

  </#if>
#define ENABLE_SL_ALGO_FROM_PHASE      ${MC.ENABLE_SL_ALGO_FROM_PHASE}
/* Sensor-less rev-up sequence */
#define STARTING_ANGLE_DEG             ${MC.STARTING_ANGLE_DEG}  /*!< degrees [0...359] */                                                             
</#if>
<#if MC.STATE_OBSERVER_PLL || MC.STATE_OBSERVER_CORDIC || MC.AUX_STATE_OBSERVER_PLL || MC.AUX_STATE_OBSERVER_CORDIC>
/* Observer start-up output conditions  */
#define OBS_MINIMUM_SPEED_RPM          ${MC.OBS_MINIMUM_SPEED_RPM}

#define NB_CONSECUTIVE_TESTS           ${MC.NB_CONSECUTIVE_TESTS} /* corresponding to 
                                                         former NB_CONSECUTIVE_TESTS/
                                                         (TF_REGULATION_RATE/
                                                         MEDIUM_FREQUENCY_TASK_RATE) */
#define SPEED_BAND_UPPER_LIMIT         ${MC.SPEED_BAND_UPPER_LIMIT} /*!< It expresses how much 
                                                            estimated speed can exceed 
                                                            forced stator electrical 
                                                            without being considered wrong. 
                                                            In 1/16 of forced speed */
#define SPEED_BAND_LOWER_LIMIT         ${MC.SPEED_BAND_LOWER_LIMIT}  /*!< It expresses how much 
                                                             estimated speed can be below 
                                                             forced stator electrical 
                                                             without being considered wrong.
                                                             In 1/16 of forced speed */ 
</#if>                                                             
                                                                                    
#define TRANSITION_DURATION            ${MC.TRANSITION_DURATION}  /* Switch over duration, ms */ 
<#if   MC.BUS_VOLTAGE_READING >
/******************************   BUS VOLTAGE Motor 1  **********************/
#define  M1_VBUS_SAMPLING_TIME  LL_ADC_SAMPLING_CYCLE(${MC.VBUS_ADC_SAMPLING_TIME})
</#if>
<#if MC.TEMPERATURE_READING >
/******************************   Temperature sensing Motor 1  **********************/
#define  M1_TEMP_SAMPLING_TIME  LL_ADC_SAMPLING_CYCLE(${MC.TEMP_ADC_SAMPLING_TIME})
</#if>
/******************************   Current sensing Motor 1   **********************/
#define ADC_SAMPLING_CYCLES (${MC.CURR_SAMPLING_TIME} + SAMPLING_CYCLE_CORRECTION)

/******************************   ADDITIONAL FEATURES   **********************/

<#if MC.FLUX_WEAKENING_ENABLING>
#define FW_VOLTAGE_REF                ${MC.FW_VOLTAGE_REF} /*!<Vs reference, tenth 
                                                        of a percent */
#define FW_KP_GAIN                    ${MC.FW_KP_GAIN} /*!< Default Kp gain */
#define FW_KI_GAIN                    ${MC.FW_KI_GAIN} /*!< Default Ki gain */
#define FW_KPDIV                      ${MC.FW_KPDIV}      
                                                /*!< Kp gain divisor.If FULL_MISRA_C_COMPLIANCY
                                                is not defined the divisor is implemented through       
                                                algebrical right shifts to speed up PIs execution. 
                                                Only in this case this parameter specifies the 
                                                number of right shifts to be executed */
#define FW_KIDIV                      ${MC.FW_KIDIV}
                                                /*!< Ki gain divisor.If FULL_MISRA_C_COMPLIANCY
                                                is not defined the divisor is implemented through       
                                                algebrical right shifts to speed up PIs execution. 
                                                Only in this case this parameter specifies the 
                                                number of right shifts to be executed */
#define FW_KPDIV_LOG                  LOG2(${MC.FW_KPDIV})
#define FW_KIDIV_LOG                  LOG2(${MC.FW_KIDIV})
</#if>
<#if MC.FEED_FORWARD_CURRENT_REG_ENABLING>                                                
/*  Feed-forward parameters */
#define FEED_FORWARD_CURRENT_REG_ENABLING <#if MC.FEED_FORWARD_CURRENT_REG_ENABLING==true>ENABLE<#else>DISABLE</#if>
#define CONSTANT1_Q                    ${MC.CONSTANT1_Q}
#define CONSTANT1_D                    ${MC.CONSTANT1_D}
#define CONSTANT2_QD                   ${MC.CONSTANT2_QD}
</#if>
<#if MC.MTPA_ENABLING>
/*  Maximum Torque Per Ampere strategy parameters */

#define MTPA_ENABLING                  
#define SEGDIV                         ${MC.SEGDIV}
#define ANGC                           ${MC.ANGC}
#define OFST                           ${MC.OFST}
</#if>

<#if MC.INRUSH_CURRLIMIT_ENABLING>
/* Inrush current limiter parameters */
#define INRUSH_CURRLIMIT_AT_POWER_ON     ${MC.INRUSH_CURRLIMIT_AT_POWER_ON}  /* ACTIVE or INACTIVE */
#define INRUSH_CURRLIMIT_CHANGE_AFTER_MS ${MC.INRUSH_CURRLIMIT_CHANGE_AFTER_MS}  /* milliseconds */                
</#if>

/*** On the fly start-up ***/
<#-- ToDo: On the Fly start-up -->

<#if MC.DUALDRIVE == true>
/**************************
 *** Motor 2 Parameters ***
 **************************/

/******** MAIN AND AUXILIARY SPEED/POSITION SENSOR(S) SETTINGS SECTION ********/

/*** Speed measurement settings ***/
#define MAX_APPLICATION_SPEED_RPM2           ${MC.MAX_APPLICATION_SPEED2} /*!< rpm, mechanical */
#define MIN_APPLICATION_SPEED_RPM2           ${MC.MIN_APPLICATION_SPEED2} /*!< rpm, mechanical,  
                                                           absolute value */
#define MEAS_ERRORS_BEFORE_FAULTS2       ${MC.MEAS_ERRORS_BEFORE_FAULTS2} /*!< Number of speed  
                                                             measurement errors before 
                                                             main sensor goes in fault */
<#if MC.ENCODER2 || MC.AUX_ENCODER2 >
/*** Encoder **********************/                                                                                                           
#define ENC_MEAS_ERRORS_BEFORE_FAULTS2   ${MC.ENC_MEAS_ERRORS_BEFORE_FAULTS2} /*!< Number of failed   
                                                        derived class specific speed 
                                                        measurements before main sensor  
                                                        goes in fault */
#define ENC_INVERT_SPEED2                DISABLE  /*!< To be enabled for  
                                                            encoder (main or aux) if  
                                                            measured speed is opposite 
                                                            to real one */        
#define ENC_AVERAGING_FIFO_DEPTH2        ${MC.ENC_AVERAGING_FIFO_DEPTH2} /*!< depth of the FIFO used to 
                                                              average mechanical speed in 
                                                              0.1Hz resolution */
</#if>
<#if MC.HALL_SENSORS2 || MC.AUX_HALL_SENSORS2 >
/****** Hall sensors ************/ 
#define HALL_MEAS_ERRORS_BEFORE_FAULTS2  ${MC.HALL_MEAS_ERRORS_BEFORE_FAULTS2} /*!< Number of failed   
                                                           derived class specific speed 
                                                           measurements before main sensor  
                                                           goes in fault */
#define HALL_AVERAGING_FIFO_DEPTH2        ${MC.HALL_AVERAGING_FIFO_DEPTH2} /*!< depth of the FIFO used to 
                                                           average mechanical speed in 
                                                           0.1Hz resolution */ 
#define HALL_MTPA2 <#if MC.HALL_MTPA2 > true <#else> false </#if>                                                           
</#if>
<#if MC.STATE_OBSERVER_PLL2 ||  MC.AUX_STATE_OBSERVER_PLL2 >
/****** State Observer + PLL ****/
#define VARIANCE_THRESHOLD2               <#if MC.OPEN_LOOP_FOC2> 0 <#else> ${MC.VARIANCE_THRESHOLD2}</#if> /*!<Maximum accepted 
                                                            variance on speed 
                                                            estimates (percentage) */
/* State observer scaling factors F1 */                    
#define F12                               ${MC.F12}
#define F22                               ${MC.F22}
#define F1_LOG2                           LOG2(${MC.F12})
#define F2_LOG2                           LOG2(${MC.F22})

/* State observer constants */
#define GAIN12                            ${MC.GAIN12}
#define GAIN22                            ${MC.GAIN22}
/*Only in case PLL is used, PLL gains */
#define PLL_KP_GAIN2                      ${MC.PLL_KP_GAIN2}
#define PLL_KI_GAIN2                      ${MC.PLL_KI_GAIN2}
#define PLL_KPDIV2                        16384
#define PLL_KPDIV_LOG2                    LOG2(PLL_KPDIV2)
#define PLL_KIDIV2                        65535
#define PLL_KIDIV_LOG2                    LOG2(PLL_KIDIV2)


#define OBS_MEAS_ERRORS_BEFORE_FAULTS2    ${MC.OBS_MEAS_ERRORS_BEFORE_FAULTS2}  /*!< Number of consecutive errors   
                                                           on variance test before a speed 
                                                           feedback error is reported */
#define STO_FIFO_DEPTH_DPP2               ${MC.STO_FIFO_DEPTH_DPP2}  /*!< Depth of the FIFO used  
                                                            to average mechanical speed  
                                                            in dpp format */
#define STO_FIFO_DEPTH_DPP_LOG2           LOG2(${MC.STO_FIFO_DEPTH_DPP2})

#define STO_FIFO_DEPTH_UNIT2              ${MC.STO_FIFO_DEPTH_01HZ2}  /*!< Depth of the FIFO used  
                                                            to average mechanical speed  
                                                            in dpp format */
#define BEMF_CONSISTENCY_TOL2             ${MC.BEMF_CONSISTENCY_TOL2}   /* Parameter for B-emf 
                                                            amplitude-speed consistency */
#define BEMF_CONSISTENCY_GAIN2            ${MC.BEMF_CONSISTENCY_GAIN2}   /* Parameter for B-emf 
                                                           amplitude-speed consistency */
</#if>

<#if MC.STATE_OBSERVER_CORDIC2 || MC.AUX_STATE_OBSERVER_CORDIC2 >                                                                                
/****** State Observer + CORDIC ***/
#define CORD_VARIANCE_THRESHOLD2          <#if MC.OPEN_LOOP_FOC2> 0 <#else> ${MC.CORD_VARIANCE_THRESHOLD2} </#if> /*!<Maxiumum accepted 
                                                            variance on speed 
                                                            estimates (percentage) */                                                                                                                
#define CORD_F12                          ${MC.CORD_F12}
#define CORD_F22                          ${MC.CORD_F22}
#define CORD_F1_LOG2                      LOG2(${MC.CORD_F12})
#define CORD_F2_LOG2                      LOG2(${MC.CORD_F22})

/* State observer constants */
#define CORD_GAIN12                       ${MC.CORD_GAIN12}
#define CORD_GAIN22                       ${MC.CORD_GAIN22}

#define CORD_MEAS_ERRORS_BEFORE_FAULTS2   ${MC.CORD_MEAS_ERRORS_BEFORE_FAULTS2}  /*!< Number of consecutive errors   
                                                           on variance test before a speed 
                                                           feedback error is reported */
#define CORD_FIFO_DEPTH_DPP2              ${MC.CORD_FIFO_DEPTH_DPP2}  /*!< Depth of the FIFO used  
                                                            to average mechanical speed  
                                                            in dpp format */
#define CORD_FIFO_DEPTH_DPP_LOG2          LOG2(${MC.CORD_FIFO_DEPTH_DPP2})
                                                            
#define CORD_FIFO_DEPTH_UNIT2             ${MC.CORD_FIFO_DEPTH_01HZ2}  /*!< Depth of the FIFO used  
                                                           to average mechanical speed  
                                                           in dpp format */        
#define CORD_MAX_ACCEL_DPPP2              ${MC.CORD_MAX_ACCEL_DPPP2}  /*!< Maximum instantaneous 
                                                              electrical acceleration (dpp 
                                                              per control period) */
#define CORD_BEMF_CONSISTENCY_TOL2        ${MC.CORD_BEMF_CONSISTENCY_TOL2}  /* Parameter for B-emf 
                                                           amplitude-speed consistency */
#define CORD_BEMF_CONSISTENCY_GAIN2       ${MC.CORD_BEMF_CONSISTENCY_GAIN2}  /* Parameter for B-emf 
                                                          amplitude-speed consistency */
</#if>

/* USER CODE BEGIN angle reconstruction M2 */
<#if MC.STATE_OBSERVER_PLL2 == true || MC.STATE_OBSERVER_CORDIC2 == true>
#define PARK_ANGLE_COMPENSATION_FACTOR2 0
</#if>
#define REV_PARK_ANGLE_COMPENSATION_FACTOR2 0
/* USER CODE END angle reconstruction M2 */

<#if MC.HFINJECTION2>                                                          
/****** HFI ******/
#define HFINJECTION2

#define HFI_FREQUENCY2                    ${MC.HFI_FREQUENCY2}
#define HFI_AMPLITUDE2                    ${MC.HFI_AMPLITUDE2}

#define HFI_PID_KP_DEFAULT2               ${MC.HFI_PID_KP_DEFAULT2}
#define HFI_PID_KI_DEFAULT2               ${MC.HFI_PID_KI_DEFAULT2}
#define HFI_PID_KPDIV2	                  ${MC.HFI_PID_KPDIV2}
#define HFI_PID_KIDIV2	                  ${MC.HFI_PID_KIDIV2}
#define HFI_PID_KPDIV_LOG2                LOG2(${MC.HFI_PID_KPDIV2})
#define HFI_PID_KIDIV_LOG2                LOG2(${MC.HFI_PID_KIDIV2})

#define HFI_IDH_DELAY2	                 32400

#define HFI_PLL_KP_DEFAULT2               ${MC.HFI_PLL_KP_DEFAULT2}
#define HFI_PLL_KI_DEFAULT2               ${MC.HFI_PLL_KI_DEFAULT2}

#define HFI_NOTCH_0_COEFF2                ${MC.HFI_NOTCH_IQD_0_COEFF2}
#define HFI_NOTCH_1_COEFF2                ${MC.HFI_NOTCH_IQD_1_COEFF2}
#define HFI_NOTCH_2_COEFF2                ${MC.HFI_NOTCH_IQD_2_COEFF2}
#define HFI_NOTCH_3_COEFF2                ${MC.HFI_NOTCH_IQD_3_COEFF2}
#define HFI_NOTCH_4_COEFF2                ${MC.HFI_NOTCH_IQD_4_COEFF2}

#define HFI_LP_0_COEFF2                   ${MC.HFI_LP_ID_0_COEFF2}
#define HFI_LP_1_COEFF2                   ${MC.HFI_LP_ID_1_COEFF2}
#define HFI_LP_2_COEFF2                   ${MC.HFI_LP_ID_2_COEFF2}
#define HFI_LP_3_COEFF2                   ${MC.HFI_LP_ID_3_COEFF2}
#define HFI_LP_4_COEFF2                   ${MC.HFI_LP_ID_4_COEFF2}

#define HFI_HP_0_COEFF2                   ${MC.HFI_HP_ID_0_COEFF2}
#define HFI_HP_1_COEFF2                   ${MC.HFI_HP_ID_1_COEFF2}
#define HFI_HP_2_COEFF2                   ${MC.HFI_HP_ID_2_COEFF2}
#define HFI_HP_3_COEFF2                   ${MC.HFI_HP_ID_3_COEFF2}
#define HFI_HP_4_COEFF2                   ${MC.HFI_HP_ID_4_COEFF2}

#define HFI_DC_0_COEFF2                   ${MC.HFI_DC_0_COEFF2}
#define HFI_DC_1_COEFF2                   ${MC.HFI_DC_1_COEFF2}
#define HFI_DC_2_COEFF2                   ${MC.HFI_DC_2_COEFF2}
#define HFI_DC_3_COEFF2                   ${MC.HFI_DC_3_COEFF2}
#define HFI_DC_4_COEFF2                   ${MC.HFI_DC_4_COEFF2}

#define HFI_MINIMUM_SPEED_RPM2            ${MC.HFI_MINIMUM_SPEED_RPM2}
#define HFI_SPD_BUFFER_DEPTH_01HZ2        ${MC.HFI_SPD_BUFFER_DEPTH_01HZ2}
#define HFI_LOCKFREQ2                     ${MC.HFI_LOCKFREQ2}
#define HFI_SCANROTATIONSNO2              ${MC.HFI_SCANROTATIONSNO2}
#define HFI_WAITBEFORESN2                 ${MC.HFI_WAITBEFORESN2}
#define HFI_WAITAFTERNS2                  ${MC.HFI_WAITAFTERNS2}
#define HFI_HIFRAMPLSCAN2                 ${MC.HFI_HIFRAMPLSCAN2}
#define HFI_NSMAXDETPOINTS2               ${MC.HFI_NSMAXDETPOINTS2}
#define HFI_NSDETPOINTSSKIP2              ${MC.HFI_NSDETPOINTSSKIP2}
#define	HFI_DEBUG_MODE                   false

#define HFI_STO_RPM_TH2                   OBS_MINIMUM_SPEED_RPM2
#define STO_HFI_RPM_TH2                   ${MC.STO_HFI_RPM_TH2}
#define HFI_RESTART_RPM_TH2               (((HFI_STO_RPM_TH2) + (STO_HFI_RPM_TH2))/2)
#define HFI_NS_MIN_SAT_DIFF2              ${MC.HFI_NS_MIN_SAT_DIFF2}

#define HFI_REVERT_DIRECTION2             true
#define HFI_WAITTRACK2                    20
#define HFI_WAITSYNCH2                    20
#define HFI_STEPANGLE2                    3640
#define HFI_MAXANGLEDIFF2                 3640
#define HFI_RESTARTTIMESEC2               0.1
</#if>

/**************************    DRIVE SETTINGS SECTION   **********************/
/* Dual drive specific parameters */
#define FREQ_RATIO                      ${MC.FREQ_RATIO}  /* Higher PWM frequency/lower PWM frequency */  
#define FREQ_RELATION                   ${MC.FREQ_RELATION}  /* It refers to motor 1 and can be 
                                                           HIGHEST_FREQ or LOWEST frequency depending 
                                                           on motor 1 and 2 frequency relationship */
#define FREQ_RELATION2                  ${MC.FREQ_RELATION2}   /* It refers to motor 2 and can be 
                                                           HIGHEST_FREQ or LOWEST frequency depending 
                                                           on motor 1 and 2 frequency relationship */

/* PWM generation and current reading */
#define PWM_FREQUENCY2                    ${MC.PWM_FREQUENCY2}
#define PWM_FREQ_SCALING2 ${Fx_Freq_Scaling((MC.PWM_FREQUENCY2)?number)}
 
#define LOW_SIDE_SIGNALS_ENABLING2        ${MC.LOW_SIDE_SIGNALS_ENABLING2}
<#if MC.LOW_SIDE_SIGNALS_ENABLING2 == 'LS_PWM_TIMER'>
#define SW_DEADTIME_NS2                   ${MC.SW_DEADTIME_NS2} /*!< Dead-time to be inserted  
                                                           by FW, only if low side 
                                                           signals are enabled */
</#if>
/* Torque and flux regulation loops */
#define REGULATION_EXECUTION_RATE2     ${MC.REGULATION_EXECUTION_RATE2}    /*!< FOC execution rate in 
                                                           number of PWM cycles */     
/* Gains values for torque and flux control loops */
#define PID_TORQUE_KP_DEFAULT2         ${MC.PID_TORQUE_KP_DEFAULT2}       
#define PID_TORQUE_KI_DEFAULT2         ${MC.PID_TORQUE_KI_DEFAULT2}
#define PID_TORQUE_KD_DEFAULT2         ${MC.PID_TORQUE_KD_DEFAULT2}
#define PID_FLUX_KP_DEFAULT2           ${MC.PID_FLUX_KP_DEFAULT2}
#define PID_FLUX_KI_DEFAULT2           ${MC.PID_FLUX_KI_DEFAULT2}
#define PID_FLUX_KD_DEFAULT2           ${MC.PID_FLUX_KD_DEFAULT2}

/* Torque/Flux control loop gains dividers*/
#define TF_KPDIV2                      ${MC.TF_KPDIV2}
#define TF_KIDIV2                      ${MC.TF_KIDIV2}
#define TF_KDDIV2                      ${MC.TF_KDDIV2}
#define TF_KPDIV_LOG2                  LOG2(${MC.TF_KPDIV2})
#define TF_KIDIV_LOG2                  LOG2(${MC.TF_KIDIV2})
#define TF_KDDIV_LOG2                  LOG2(${MC.TF_KDDIV2})

#define TFDIFFERENTIAL_TERM_ENABLING2  DISABLE

<#if MC.POSITION_CTRL_ENABLING2 == true >
#define POSITION_LOOP_FREQUENCY_HZ2    ${MC.POSITION_LOOP_FREQUENCY_HZ2} /*!<Execution rate of position control regulation loop (Hz) */
<#else>
/* Speed control loop */ 
#define SPEED_LOOP_FREQUENCY_HZ2       ${MC.SPEED_LOOP_FREQUENCY_HZ2} /*!<Execution rate of speed   
                                                      regulation loop (Hz) */
</#if>
#define PID_SPEED_KP_DEFAULT2          ${MC.PID_SPEED_KP_DEFAULT2}/(SPEED_UNIT/10) /* Workbench compute the gain for 01Hz unit*/
#define PID_SPEED_KI_DEFAULT2          ${MC.PID_SPEED_KI_DEFAULT2}/(SPEED_UNIT/10) /* Workbench compute the gain for 01Hz unit*/
#define PID_SPEED_KD_DEFAULT2          ${MC.PID_SPEED_KD_DEFAULT2}/(SPEED_UNIT/10) /* Workbench compute the gain for 01Hz unit*/
/* Speed PID parameter dividers */
#define SP_KPDIV2                      ${MC.SP_KPDIV2}
#define SP_KIDIV2                      ${MC.SP_KIDIV2}
#define SP_KDDIV2                      ${MC.SP_KDDIV2}
#define SP_KPDIV_LOG2                  LOG2(${MC.SP_KPDIV2})
#define SP_KIDIV_LOG2                  LOG2(${MC.SP_KIDIV2})
#define SP_KDDIV_LOG2                  LOG2(${MC.SP_KDDIV2})

/* USER CODE BEGIN PID_SPEED_INTEGRAL_INIT_DIV2 */
#define PID_SPEED_INTEGRAL_INIT_DIV2 1 
/* USER CODE END PID_SPEED_INTEGRAL_INIT_DIV2 */

#define SPD_DIFFERENTIAL_TERM_ENABLING2 DISABLE
#define IQMAX2                          ${MC.IQMAX2}

/* Default settings */
#define DEFAULT_CONTROL_MODE2           ${MC.DEFAULT_CONTROL_MODE2} /*!< STC_TORQUE_MODE or 
                                                        STC_SPEED_MODE */  
#define DEFAULT_TARGET_SPEED_RPM2 <#if MC.OPEN_LOOP_FOC2>OPEN_LOOP_SPEED_RPM2<#else>${MC.DEFAULT_TARGET_SPEED_RPM2}</#if>
#define DEFAULT_TARGET_SPEED_UNIT2      (DEFAULT_TARGET_SPEED_RPM2*SPEED_UNIT/_RPM)
#define DEFAULT_TORQUE_COMPONENT2       ${MC.DEFAULT_TORQUE_COMPONENT2}
#define DEFAULT_FLUX_COMPONENT2         ${MC.DEFAULT_FLUX_COMPONENT2}

<#if  MC.POSITION_CTRL_ENABLING2 == true >
#define PID_POSITION_KP_GAIN2			${MC.POSITION_CTRL_KP_GAIN2}
#define PID_POSITION_KI_GAIN2			${MC.POSITION_CTRL_KI_GAIN2}
#define PID_POSITION_KD_GAIN2			${MC.POSITION_CTRL_KD_GAIN2}
#define PID_POSITION_KPDIV2				${MC.POSITION_CTRL_KPDIV2}     
#define PID_POSITION_KIDIV2				${MC.POSITION_CTRL_KIDIV2}
#define PID_POSITION_KDDIV2				${MC.POSITION_CTRL_KDDIV2}
#define PID_POSITION_KPDIV_LOG2			LOG2(${MC.POSITION_CTRL_KPDIV2})    
#define PID_POSITION_KIDIV_LOG2			LOG2(${MC.POSITION_CTRL_KIDIV2}) 
#define PID_POSITION_KDDIV_LOG2			LOG2(${MC.POSITION_CTRL_KDDIV2}) 
#define PID_POSITION_ANGLE_STEP2			${MC.POSITION_CTRL_ANGLE_STEP2}
#define PID_POSITION_MOV_DURATION2		${MC.POSITION_CTRL_MOV_DURATION2}
</#if>

/**************************    FIRMWARE PROTECTIONS SECTION   *****************/
#define OV_VOLTAGE_PROT_ENABLING2        ENABLE
#define UV_VOLTAGE_PROT_ENABLING2        ENABLE
#define OV_VOLTAGE_THRESHOLD_V2          ${MC.OV_VOLTAGE_THRESHOLD_V2} /*!< Over-voltage 
                                                         threshold */
#define UD_VOLTAGE_THRESHOLD_V2          ${MC.UD_VOLTAGE_THRESHOLD_V2} /*!< Under-voltage 
                                                          threshold */
#if 0
#define ON_OVER_VOLTAGE2                 ${MC.ON_OVER_VOLTAGE2} /*!< TURN_OFF_PWM, 
                                                         TURN_ON_R_BRAKE or 
                                                         TURN_ON_LOW_SIDES */
#endif /* 0 */
                                                         
#define R_BRAKE_SWITCH_OFF_THRES_V2      ${MC.R_BRAKE_SWITCH_OFF_THRES_V2}

#define OV_TEMPERATURE_THRESHOLD_C2      ${MC.OV_TEMPERATURE_THRESHOLD_C2} /*!< Celsius degrees */
#define OV_TEMPERATURE_HYSTERESIS_C2     ${MC.OV_TEMPERATURE_HYSTERESIS_C2} /*!< Celsius degrees */

#define HW_OV_CURRENT_PROT_BYPASS2       DISABLE /*!< In case ON_OVER_VOLTAGE  
                                                          is set to TURN_ON_LOW_SIDES
                                                          this feature may be used to
                                                          bypass HW over-current
                                                          protection (if supported by 
                                                          power stage) */
/******************************   START-UP PARAMETERS   **********************/
/* Encoder alignment */
#define ALIGNMENT_DURATION2              ${MC.ALIGNMENT_DURATION2} /*!< milliseconds */
#define ALIGNMENT_ANGLE_DEG2             ${MC.ALIGNMENT_ANGLE_DEG2} /*!< degrees [0...359] */
#define FINAL_I_ALIGNMENT2               ${MC.FINAL_I_ALIGNMENT2} /*!< s16A */
// With ALIGNMENT_ANGLE_DEG equal to 90 degrees final alignment 
// phase current = (FINAL_I_ALIGNMENT * 1.65/ Av)/(32767 * Rshunt)  
// being Av the voltage gain between Rshunt and A/D input


<#if ( MC.STATE_OBSERVER_PLL2 || MC.STATE_OBSERVER_CORDIC2 )>
  <#if MC.OPEN_LOOP_FOC2 == true>
/* USER CODE BEGIN OPENLOOP M2 */

#define OPEN_LOOP_VOLTAGE_d2           6000      /*!< Three Phase voltage amplitude
                                                      in int16_t format */
#define OPEN_LOOP_SPEED_RPM2           100       /*!< Final forced speed in rpm */
#define OPEN_LOOP_SPEED_RAMP_DURATION_MS2  1000  /*!< 0-to-Final speed ramp duration  */      
#define OPEN_LOOP_VF2                  false     /*!< true to enable V/F mode */
#define OPEN_LOOP_K2                   44        /*! Slope of V/F curve expressed in int16_t Voltage for 
                                                     each 0.1Hz of mecchanical frequency increment. */
#define OPEN_LOOP_OFF2                 4400      /*! Offset of V/F curve expressed in int16_t Voltage 
                                                     applied when frequency is zero. */
/* USER CODE END OPENLOOP M2 */

/* Phase 1 */
#define PHASE1_DURATION2		        OPEN_LOOP_SPEED_RAMP_DURATION_MS2
#define PHASE1_FINAL_SPEED_UNIT2	    (OPEN_LOOP_SPEED_RPM2*SPEED_UNIT/_RPM)
#define PHASE1_FINAL_CURRENT2           ${MC.PHASE1_FINAL_CURRENT2}

/* Phase 2 */
#define PHASE2_DURATION2		      65535   /*milliseconds */
#define PHASE2_FINAL_SPEED_UNIT2	        PHASE1_FINAL_SPEED_UNIT2
#define PHASE2_FINAL_CURRENT2           ${MC.PHASE2_FINAL_CURRENT2}

/* Phase 3 */
#define PHASE3_DURATION2		       65535   /*milliseconds */
#define PHASE3_FINAL_SPEED_UNIT2	        PHASE1_FINAL_SPEED_UNIT2
#define PHASE3_FINAL_CURRENT2           ${MC.PHASE3_FINAL_CURRENT2}

/* Phase 4 */
#define PHASE4_DURATION2		  65535   /*milliseconds */
#define PHASE4_FINAL_SPEED_UNIT2	  PHASE1_FINAL_SPEED_UNIT2
#define PHASE4_FINAL_CURRENT2           ${MC.PHASE4_FINAL_CURRENT2}

/* Phase 5 */
#define PHASE5_DURATION2		  65535    /* milliseconds */
#define PHASE5_FINAL_SPEED_UNIT2	  PHASE1_FINAL_SPEED_UNIT2
#define PHASE5_FINAL_CURRENT2           ${MC.PHASE5_FINAL_CURRENT2}

  <#else><#-- MC.OPEN_LOOP_FOC2 == false inside MC.STATE_OBSERVER_PLL2 || MC.STATE_OBSERVER_CORDIC2 -->

/* Phase 1 */
#define PHASE1_DURATION2                ${MC.PHASE1_DURATION2} /*milliseconds */
#define PHASE1_FINAL_SPEED_UNIT2        (${MC.PHASE1_FINAL_SPEED_RPM2}*SPEED_UNIT/_RPM) /* rpm */
#define PHASE1_FINAL_CURRENT2           ${MC.PHASE1_FINAL_CURRENT2}
/* Phase 2 */
#define PHASE2_DURATION2                ${MC.PHASE2_DURATION2} /*milliseconds */
#define PHASE2_FINAL_SPEED_UNIT2         (${MC.PHASE2_FINAL_SPEED_RPM2}*SPEED_UNIT/_RPM) /* rpm */
#define PHASE2_FINAL_CURRENT2           ${MC.PHASE2_FINAL_CURRENT2}
/* Phase 3 */
#define PHASE3_DURATION2                ${MC.PHASE3_DURATION2} /*milliseconds */
#define PHASE3_FINAL_SPEED_UNIT2         (${MC.PHASE3_FINAL_SPEED_RPM2}*SPEED_UNIT/_RPM) /* rpm */
#define PHASE3_FINAL_CURRENT2           ${MC.PHASE3_FINAL_CURRENT2}
/* Phase 4 */
#define PHASE4_DURATION2                ${MC.PHASE4_DURATION2} /*milliseconds */
#define PHASE4_FINAL_SPEED_UNIT2         (${MC.PHASE4_FINAL_SPEED_RPM2}*SPEED_UNIT/_RPM) /* rpm */
#define PHASE4_FINAL_CURRENT2           ${MC.PHASE4_FINAL_CURRENT2}
/* Phase 5 */
#define PHASE5_DURATION2                ${MC.PHASE5_DURATION2} /* milliseconds */
#define PHASE5_FINAL_SPEED_UNIT2         (${MC.PHASE5_FINAL_SPEED_RPM2}*SPEED_UNIT/_RPM) /* rpm */
#define PHASE5_FINAL_CURRENT2           ${MC.PHASE5_FINAL_CURRENT2}

  </#if>
#define ENABLE_SL_ALGO_FROM_PHASE2      ${MC.ENABLE_SL_ALGO_FROM_PHASE2}

/* Sensor-less rev-up sequence */
#define STARTING_ANGLE_DEG2             ${MC.STARTING_ANGLE_DEG2}  /*!< degrees [0...359] */
</#if>
<#if MC.STATE_OBSERVER_PLL2 || MC.STATE_OBSERVER_CORDIC2 || MC.AUX_STATE_OBSERVER_PLL2 || MC.AUX_STATE_OBSERVER_CORDIC2>
/* Observer start-up output conditions  */
#define OBS_MINIMUM_SPEED_RPM2          ${MC.OBS_MINIMUM_SPEED_RPM2}
#define NB_CONSECUTIVE_TESTS2           ${MC.NB_CONSECUTIVE_TESTS2} /* corresponding to 
                                                         former NB_CONSECUTIVE_TESTS/
                                                         (TF_REGULATION_RATE/
                                                         MEDIUM_FREQUENCY_TASK_RATE) */
#define SPEED_BAND_UPPER_LIMIT2         ${MC.SPEED_BAND_UPPER_LIMIT2} /*!< It expresses how much 
                                                            estimated speed can exceed 
                                                            forced stator electrical 
                                                            without being considered wrong. 
                                                            In 1/16 of forced speed */
#define SPEED_BAND_LOWER_LIMIT2         ${MC.SPEED_BAND_LOWER_LIMIT2}  /*!< It expresses how much 
                                                             estimated speed can be below 
                                                             forced stator electrical 
                                                             without being considered wrong. 
                                                             In 1/16 of forced speed */  
</#if>


#define TRANSITION_DURATION2            ${MC.TRANSITION_DURATION2}  /* Switch over duration, ms */

<#if   MC.BUS_VOLTAGE_READING2 >
/******************************   BUS VOLTAGE  Motor 2  **********************/
#define  M2_VBUS_SAMPLING_TIME  LL_ADC_SAMPLING_CYCLE(${MC.VBUS_ADC_SAMPLING_TIME2})
</#if>
<#if  MC.TEMPERATURE_READING2 >
/******************************   Temperature sensing Motor 2  **********************/
#define  M2_TEMP_SAMPLING_TIME  LL_ADC_SAMPLING_CYCLE(${MC.TEMP_ADC_SAMPLING_TIME2})
</#if>

/******************************   Current sensing Motor 2   **********************/
#define ADC_SAMPLING_CYCLES2 (${MC.CURR_SAMPLING_TIME2} + SAMPLING_CYCLE_CORRECTION)

/******************************   ADDITIONAL FEATURES   **********************/



<#if MC.FLUX_WEAKENING_ENABLING2>
#define FW_VOLTAGE_REF2                ${MC.FW_VOLTAGE_REF2} /*!<Vs reference, tenth 
                                                        of a percent */
#define FW_KP_GAIN2                    ${MC.FW_KP_GAIN2} /*!< Default Kp gain */
#define FW_KI_GAIN2                    ${MC.FW_KI_GAIN2} /*!< Default Ki gain */
#define FW_KPDIV2                      ${MC.FW_KPDIV2}      
                                                /*!< Kp gain divisor.If FULL_MISRA_C_COMPLIANCY
                                                is not defined the divisor is implemented through       
                                                algebrical right shifts to speed up PIs execution. 
                                                Only in this case this parameter specifies the 
                                                number of right shifts to be executed */
#define FW_KIDIV2                      ${MC.FW_KIDIV2}
                                                /*!< Ki gain divisor.If FULL_MISRA_C_COMPLIANCY
                                                is not defined the divisor is implemented through       
                                                algebrical right shifts to speed up PIs execution. 
                                                Only in this case this parameter specifies the 
                                                number of right shifts to be executed */
#define FW_KPDIV_LOG2                  LOG2(${MC.FW_KPDIV2})
#define FW_KIDIV_LOG2                  LOG2(${MC.FW_KIDIV2})
</#if>
<#if MC.FEED_FORWARD_CURRENT_REG_ENABLING2>
/*  Feed-forward parameters */
#define FEED_FORWARD_CURRENT_REG_ENABLING2 <#if MC.FEED_FORWARD_CURRENT_REG_ENABLING2==true>ENABLE<#else>DISABLE</#if>
#define CONSTANT1_Q2                    ${MC.CONSTANT1_Q2}
#define CONSTANT1_D2                    ${MC.CONSTANT1_D2}
#define CONSTANT2_QD2                   ${MC.CONSTANT2_QD2}
</#if>

<#if MC.MTPA_ENABLING2>
/*  Maximum Torque Per Ampere strategy parameters */
#define MTPA_ENABLING2
#define SEGDIV2                         ${MC.SEGDIV2}
#define ANGC2                           ${MC.ANGC2}
#define OFST2                           ${MC.OFST2}                  
</#if>

<#if MC.INRUSH_CURRLIMIT_ENABLING2>
/* Inrush current limiter parameters */
#define INRUSH_CURRLIMIT_ENABLING2        DISABLE
#define INRUSH_CURRLIMIT_AT_POWER_ON2     ${MC.INRUSH_CURRLIMIT_AT_POWER_ON2}  /* ACTIVE or INACTIVE */
#define INRUSH_CURRLIMIT_CHANGE_AFTER_MS2 ${MC.INRUSH_CURRLIMIT_CHANGE_AFTER_MS2}  /* milliseconds */                
</#if>
/*** On the fly start-up ***/
<#-- ToDo: On the Fly start-up -->

</#if>

/**************************
 *** Control Parameters ***
 **************************/

<#if MC.PFC_ENABLED == true>
/******************************** PFC ENABLING ********************************/
#define PFC_ENABLED
</#if> 

/* ##@@_USER_CODE_START_##@@ */
/* ##@@_USER_CODE_END_##@@ */

#endif /*__DRIVE_PARAMETERS_H*/
/******************* (C) COPYRIGHT 2019 STMicroelectronics *****END OF FILE****/
