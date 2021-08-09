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
<#-- Condition for STM32F302x8x MCU -->
<#assign CondMcu_STM32F302x8x = (McuName?? && McuName?matches("STM32F302.8.*"))>
<#-- Condition for STM32F072xxx MCU -->
<#assign CondMcu_STM32F072xxx = (McuName?? && McuName?matches("STM32F072.*"))>
<#-- Condition for STM32F446xCx or STM32F446xEx -->
<#assign CondMcu_STM32F446xCEx = (McuName?? && McuName?matches("STM32F446.(C|E).*"))>
<#-- Condition for Line STM32F1xx Value -->
<#assign CondLine_STM32F1_Value = (McuName?? && (McuName?matches("STM32F100.(4|6|8|B).*")))>
<#-- Condition for Line STM32F1xx Value, Medium Density -->
<#assign CondLine_STM32F1_Value_MD = (McuName?? && (McuName?matches("STM32F100.(8|B).*")))>
<#-- Condition for Line STM32F1xx Performance -->
<#assign CondLine_STM32F1_Performance = (McuName?? && McuName?matches("STM32F103.(4|6|8|B).*"))>
<#-- Condition for Line STM32F1xx Performance, Medium Density -->
<#assign CondLine_STM32F1_Performance_MD = (McuName?? && McuName?matches("STM32F103.(8|B).*"))>
<#-- Condition for Line STM32F1xx High Density -->
<#assign CondLine_STM32F1_HD = (McuName?? && McuName?matches("STM32F103.(C|D|E|F|G).*"))>
<#-- Condition for STM32F0 Family -->
<#assign CondFamily_STM32F0 = (FamilyName?? && FamilyName=="STM32F0")>
<#-- Condition for STM32G0 Family -->
<#assign CondFamily_STM32G0 = (FamilyName?? && FamilyName=="STM32G0") >
<#-- Condition for STM32F1 Family -->
<#assign CondFamily_STM32F1 = (CondLine_STM32F1_Value || CondLine_STM32F1_Performance || CondLine_STM32F1_HD)>
<#-- Condition for STM32F3 Family -->
<#assign CondFamily_STM32F3 = (FamilyName?? && FamilyName == "STM32F3")>
<#-- Condition for STM32F4 Family -->
<#assign CondFamily_STM32F4 = (FamilyName?? && FamilyName == "STM32F4") >
<#-- Condition for STM32G4 Family -->
<#assign CondFamily_STM32G4 = (FamilyName?? && FamilyName == "STM32G4") >
<#-- Condition for STM32L4 Family -->
<#assign CondFamily_STM32L4 = (FamilyName?? && FamilyName == "STM32L4") >
<#-- Condition for STM32F7 Family -->
<#assign CondFamily_STM32F7 = (FamilyName?? && FamilyName == "STM32F7") >
<#-- Condition for STM32H7 Family -->
<#assign CondFamily_STM32H7 = (FamilyName?? && FamilyName == "STM32H7") >
<#-- Define some helper symbols -->
<#assign AUX_SPEED_FDBK_M1 = (MC.AUX_HALL_SENSORS == true || MC.AUX_ENCODER || MC.AUX_STATE_OBSERVER_PLL || MC.AUX_STATE_OBSERVER_CORDIC)>
<#assign AUX_SPEED_FDBK_M2 = (MC.AUX_HALL_SENSORS2 == true || MC.AUX_ENCODER2 || MC.AUX_STATE_OBSERVER_PLL2 || MC.AUX_STATE_OBSERVER_CORDIC2)>
<#assign NoInjectedChannel = (CondFamily_STM32F0 || CondFamily_STM32G0) >	

  <#if  MC.STATE_OBSERVER_PLL == true>
    <#assign SPD_M1   = "&STO_PLL_M1">
    <#assign SPD_init_M1 = "STO_PLL_Init" >
    <#assign SPD_calcAvrgMecSpeedUnit_M1 = "STO_PLL_CalcAvrgMecSpeedUnit" >
	<#assign SPD_calcElAngle_M1 = "STO_PLL_CalcElAngle" >    
	<#assign SPD_calcAvergElSpeedDpp_M1 = "STO_PLL_CalcAvrgElSpeedDpp"> 
	<#assign SPD_clear_M1 = "STO_PLL_Clear">  
  <#elseif  MC.STATE_OBSERVER_CORDIC == true>
    <#assign SPD_M1 = "&STO_CR_M1" >
    <#assign SPD_init_M1 = "STO_CR_Init" >
    <#assign SPD_calcElAngle_M1 = "STO_CR_CalcElAngle" >
    <#assign SPD_calcAvrgMecSpeedUnit_M1 = "STO_CR_CalcAvrgMecSpeedUnit" >
    <#assign SPD_calcAvergElSpeedDpp_M1 = "STO_CR_CalcAvrgElSpeedDpp"> 
	<#assign SPD_clear_M1 = "STO_CR_Clear">  
  <#elseif  MC.HALL_SENSORS == true>
    <#assign SPD_M1 = "&HALL_M1" >
    <#assign SPD_init_M1 = "HALL_Init" >
    <#assign SPD_calcElAngle_M1 = "HALL_CalcElAngle" >
    <#assign SPD_calcAvrgMecSpeedUnit_M1 = "HALL_CalcAvrgMecSpeedUnit" >
	<#assign SPD_clear_M1 = "HALL_Clear">  
  <#elseif  MC.ENCODER == true>
    <#assign SPD_M1 = "&ENCODER_M1" >
	<#assign SPD_init_M1 = "ENC_Init" >
    <#assign SPD_calcElAngle_M1 = "ENC_CalcElAngle" >
    <#assign SPD_calcAvrgMecSpeedUnit_M1 = "ENC_CalcAvrgMecSpeedUnit" >
	<#assign SPD_clear_M1 = "ENC_Clear">  
  <#elseif  MC.HFINJECTION == true>  
    <#assign SPD_M1 = "&HfiFpSpeedM1">
    <#assign SPD_init_M1 = "HFI_FP_SPD_Init">
    <#assign SPD_calcElAngle_M1 = "HFI_FP_SPD_CalcElAngle" >
    <#assign SPD_calcAvrgMecSpeedUnit_M1 = "HFI_FP_SPD_CalcAvrgMecSpeedUnit" >
    <#assign SPD_clear_M1 = "HFI_FP_SPD_Clear">
    
    <#assign SPD_AUX_M1 = "&STO_PLL_M1">
    <#assign SPD_aux_init_M1 = "STO_PLL_Init">
    <#assign SPD_aux_calcAvrgMecSpeedUnit_M1 ="STO_PLL_CalcAvrgMecSpeedUnit">
    <#assign SPD_aux_calcAvrgElSpeedDpp_M1 = "STO_PLL_CalcAvrgElSpeedDpp">
    <#assign SPD_aux_calcElAngle_M1 = "STO_PLL_CalcElAngle">
    <#assign SPD_aux_clear_M1 = "STO_PLL_Clear">
  </#if>
  <#if  AUX_SPEED_FDBK_M1 == true>
    <#if   MC.AUX_STATE_OBSERVER_PLL == true>
      <#assign SPD_AUX_M1 = "&STO_PLL_M1">
	  <#assign SPD_aux_init_M1 = "STO_PLL_Init">
	  <#assign SPD_aux_calcAvrgMecSpeedUnit_M1 ="STO_PLL_CalcAvrgMecSpeedUnit">
	  <#assign SPD_aux_calcAvrgElSpeedDpp_M1 = "STO_PLL_CalcAvrgElSpeedDpp">
	  <#assign SPD_aux_calcElAngle_M1 = "STO_PLL_CalcElAngle">
	  <#assign SPD_aux_clear_M1 = "STO_PLL_Clear">
    <#elseif  MC.AUX_STATE_OBSERVER_CORDIC == true>
      <#assign SPD_AUX_M1 = "&STO_CR_M1">
	  <#assign SPD_aux_init_M1 = "STO_CR_Init">
	  <#assign SPD_aux_calcAvrgMecSpeedUnit_M1 = "STO_CR_CalcAvrgMecSpeedUnit">
	  <#assign SPD_aux_calcAvrgElSpeedDpp_M1 = "STO_CR_CalcAvrgElSpeedDpp">
	  <#assign SPD_aux_calcElAngle_M1 = "STO_CR_CalcElAngle">
	  <#assign SPD_aux_clear_M1 = "STO_CR_Clear">
	<#elseif  MC.AUX_HALL_SENSORS == true>
      <#assign SPD_AUX_M1 = "&HALL_M1">
	  <#assign SPD_aux_init_M1 = "HALL_Init" >
	  <#assign SPD_aux_calcAvrgMecSpeedUnit_M1 = "HALL_CalcAvrgMecSpeedUnit">
	  <#assign SPD_aux_clear_M1 = "HALL_Clear">
    <#elseif  MC.AUX_ENCODER == true>
      <#assign SPD_AUX_M1 = "&ENCODER_M1">
	  <#assign SPD_aux_init_M1 = "ENC_Init" >
	  <#assign SPD_aux_calcAvrgMecSpeedUnit_M1 = "ENC_CalcAvrgMecSpeedUnit">
	  <#assign SPD_aux_clear_M1 = "ENC_Clear">
    </#if>
  </#if>
    <#if  MC.STATE_OBSERVER_PLL2 == true>
    <#assign SPD_M2   = "&STO_PLL_M2">
    <#assign SPD_init_M2 = "STO_PLL_Init" >
    <#assign SPD_calcAvrgMecSpeedUnit_M2 = "STO_PLL_CalcAvrgMecSpeedUnit" >
	<#assign SPD_calcElAngle_M2 = "STO_PLL_CalcElAngle" >   /* if not sensorless then 2nd parameter is MC_NULL*/    
	<#assign SPD_calcAvergElSpeedDpp_M2 = "STO_PLL_CalcAvrgElSpeedDpp"> 
	<#assign SPD_clear_M2 = "STO_PLL_Clear">  
  <#elseif  MC.STATE_OBSERVER_CORDIC2 == true>
    <#assign SPD_M2 = "&STO_CR_M2" >
    <#assign SPD_init_M2 = "STO_CR_Init" >
    <#assign SPD_calcElAngle_M2 = "STO_CR_CalcElAngle" >
    <#assign SPD_calcAvrgMecSpeedUnit_M2 = "STO_CR_CalcAvrgMecSpeedUnit" >
    <#assign SPD_calcAvergElSpeedDpp_M2 = "STO_CR_CalcAvrgElSpeedDpp"> 
	<#assign SPD_clear_M2 = "STO_CR_Clear">  
  <#elseif  MC.HALL_SENSORS2 == true>
    <#assign SPD_M2 = "&HALL_M2" >
    <#assign SPD_init_M2 = "HALL_Init" >
    <#assign SPD_calcElAngle_M2 = "HALL_CalcElAngle" >
    <#assign SPD_calcAvrgMecSpeedUnit_M2 = "HALL_CalcAvrgMecSpeedUnit" >
	<#assign SPD_clear_M2 = "HALL_Clear">  
  <#elseif  MC.ENCODER2 == true>
    <#assign SPD_M2 = "&ENCODER_M2" >
	<#assign SPD_init_M2 = "ENC_Init" >
    <#assign SPD_calcElAngle_M2 = "ENC_CalcElAngle" >
    <#assign SPD_calcAvrgMecSpeedUnit_M2 = "ENC_CalcAvrgMecSpeedUnit" >
	<#assign SPD_clear_M2 = "ENC_Clear">  
  <#elseif  MC.HFINJECTION2 == true>  
    <#assign SPD_M2 = "&HfiFpSpeedM2">
    <#assign SPD_init_M2 = "HFI_FP_SPD_Init">
    <#assign SPD_calcElAngle_M2 = "HFI_FP_SPD_CalcElAngle" >
    <#assign SPD_calcAvrgMecSpeedUnit_M2 = "HFI_FP_SPD_CalcAvrgMecSpeedUnit" >
    <#assign SPD_clear_M2 = "HFI_FP_SPD_Clear">
    
    <#assign SPD_AUX_M2 = "&STO_PLL_M2">
    <#assign SPD_aux_init_M2 = "STO_PLL_Init">
    <#assign SPD_aux_calcAvrgMecSpeedUnit_M2 ="STO_PLL_CalcAvrgMecSpeedUnit">
    <#assign SPD_aux_calcAvrgElSpeedDpp_M2 = "STO_PLL_CalcAvrgElSpeedDpp">
    <#assign SPD_aux_calcElAngle_M2 = "STO_PLL_CalcElAngle">
    <#assign SPD_aux_clear_M2 = "STO_PLL_Clear">
  </#if>
  <#if  AUX_SPEED_FDBK_M2 == true>
    <#if   MC.AUX_STATE_OBSERVER_PLL2 == true>
      <#assign SPD_AUX_M2 = "&STO_PLL_M2">
	  <#assign SPD_aux_init_M2 = "STO_PLL_Init" >
	  <#assign SPD_aux_calcAvrgMecSpeedUnit_M2 ="STO_PLL_CalcAvrgMecSpeedUnit">
	  <#assign SPD_aux_calcAvrgElSpeedDpp_M2 = "STO_PLL_CalcAvrgElSpeedDpp">
	  <#assign SPD_aux_calcElAngle_M2 = "STO_PLL_CalcElAngle">
	  <#assign SPD_aux_clear_M2 = "STO_PLL_Clear">
    <#elseif  MC.AUX_STATE_OBSERVER_CORDIC2 == true>
      <#assign SPD_AUX_M2 = "&STO_CR_M2">
	  <#assign SPD_aux_init_M2 = "STO_CR_Init" >
	  <#assign SPD_aux_calcAvrgMecSpeedUnit_M2 = "STO_CR_CalcAvrgMecSpeedUnit">
	  <#assign SPD_aux_calcAvrgElSpeedDpp_M2 = "STO_CR_CalcAvrgElSpeedDpp">
	  <#assign SPD_aux_calcElAngle_M2 = "STO_CR_CalcElAngle">
	  <#assign SPD_aux_clear_M2 = "STO_CR_Clear">
	<#elseif  MC.AUX_HALL_SENSORS2 == true>
      <#assign SPD_AUX_M2 = "&HALL_M2">
	  <#assign SPD_aux_init_M2 = "HALL_Init" >
	  <#assign SPD_aux_calcElAngle_M2 = "HALL_CalcElAngle">
	  <#assign SPD_aux_calcAvrgMecSpeedUnit_M2 = "HALL_CalcAvrgMecSpeedUnit">
	  <#assign SPD_aux_clear_M2 = "HALL_Clear">
    <#elseif  MC.AUX_ENCODER2 == true>
      <#assign SPD_AUX_M2 = "&ENCODER_M2">
	  <#assign SPD_aux_init_M2 = "ENC_Init" >
	  <#assign SPD_aux_calcElAngle_M2 = "ENC_CalcElAngle">
	  <#assign SPD_aux_calcAvrgMecSpeedUnit_M2 = "ENC_CalcAvrgMecSpeedUnit">
	  <#assign SPD_aux_clear_M2 = "ENC_Clear">
    </#if>
  </#if>
  <#if CondFamily_STM32F3 &&  MC.THREE_SHUNT == true>
	<#assign PWM_Init = "R3_1_Init">
	<#assign PWM_TurnOnLowSides = "R3_1_TurnOnLowSides">
	<#assign PWM_SwitchOn = "R3_1_SwitchOnPWM">
	<#assign PWM_SwitchOff = "R3_1_SwitchOffPWM">
	<#assign PWM_GetPhaseCurrents ="R3_1_GetPhaseCurrents">
<#elseif CondFamily_STM32F3 &&  MC.SINGLE_SHUNT == true>
	<#assign PWM_Init = "R1F30X_Init"> 
	<#assign PWM_TurnOnLowSides = "R1F30X_TurnOnLowSides">
	<#assign PWM_SwitchOn = "R1F30X_SwitchOnPWM">
	<#assign PWM_SwitchOff = "R1F30X_SwitchOffPWM">	
	<#assign PWM_GetPhaseCurrents ="R1F30X_GetPhaseCurrents">
<#elseif CondFamily_STM32F3 &&  (MC.THREE_SHUNT_SHARED_RESOURCES ||  MC.THREE_SHUNT_INDEPENDENT_RESOURCES )>
	<#assign PWM_Init = "R3_2_Init">
	<#assign PWM_TurnOnLowSides = "R3_2_TurnOnLowSides">
	<#assign PWM_SwitchOn = "R3_2_SwitchOnPWM">
	<#assign PWM_SwitchOff = "R3_2_SwitchOffPWM">
	<#assign PWM_GetPhaseCurrents ="R3_2_GetPhaseCurrents">
<#elseif CondFamily_STM32F4 &&  MC.THREE_SHUNT == true>
  <#assign PWM_Handle_M1 = "PWMC_R3_1_Handle_M1">
	<#assign PWM_Init = "R3_1_Init">  
	<#assign PWM_TurnOnLowSides = "R3_1_TurnOnLowSides">
	<#assign PWM_SwitchOn = "R3_1_SwitchOnPWM">
	<#assign PWM_SwitchOff = "R3_1_SwitchOffPWM">
	<#assign PWM_GetPhaseCurrents ="R3_1_GetPhaseCurrents">
<#elseif CondFamily_STM32F4 &&  MC.SINGLE_SHUNT == true> 
	<#assign PWM_Init = "R1F4XX_Init"> 
	<#assign PWM_TurnOnLowSides = "R1F4XX_TurnOnLowSides">
	<#assign PWM_SwitchOn = "R1F4XX_SwitchOnPWM">
	<#assign PWM_SwitchOff = "R1F4XX_SwitchOffPWM">
	<#assign PWM_GetPhaseCurrents ="R1F4XX_GetPhaseCurrents">
<#elseif CondFamily_STM32F4 &&  MC.THREE_SHUNT_INDEPENDENT_RESOURCES == true>
	<#assign PWM_Init = "R3_2_Init">
	<#assign PWM_TurnOnLowSides = "R3_2_TurnOnLowSides">
	<#assign PWM_SwitchOn = "R3_2_SwitchOnPWM">
	<#assign PWM_SwitchOff = "R3_2_SwitchOffPWM">
	<#assign PWM_GetPhaseCurrents ="R3_2_GetPhaseCurrents">
<#elseif CondFamily_STM32F0 &&  MC.SINGLE_SHUNT == true> 
	<#assign PWM_Init = "R1F0XX_Init">  
	<#assign PWM_TurnOnLowSides = "R1F0XX_TurnOnLowSides">
	<#assign PWM_SwitchOn = "R1F0XX_SwitchOnPWM">
	<#assign PWM_SwitchOff = "R1F0XX_SwitchOffPWM">
	<#assign PWM_GetPhaseCurrents ="">
<#elseif CondFamily_STM32F0 &&  MC.THREE_SHUNT == true> 
	<#assign PWM_Init = "R3_1_Init">  
	<#assign PWM_TurnOnLowSides = "R3_1_TurnOnLowSides">
	<#assign PWM_SwitchOn = "R3_1_SwitchOnPWM">
	<#assign PWM_SwitchOff = "R3_1_SwitchOffPWM">
	<#assign PWM_GetPhaseCurrents ="">
<#elseif CondFamily_STM32G0 &&  MC.SINGLE_SHUNT == true> 
	<#assign PWM_Init = "R1G0XX_Init">  
	<#assign PWM_TurnOnLowSides = "R1G0XX_TurnOnLowSides">
	<#assign PWM_SwitchOn = "R1G0XX_SwitchOnPWM">
	<#assign PWM_SwitchOff = "R1G0XX_SwitchOffPWM">
	<#assign PWM_GetPhaseCurrents ="">
<#elseif CondFamily_STM32G0 &&  MC.THREE_SHUNT == true> 
	<#assign PWM_Init = "R3_1_Init">  
	<#assign PWM_TurnOnLowSides = "R3_1_TurnOnLowSides">
	<#assign PWM_SwitchOn = "R3_1_SwitchOnPWM">
	<#assign PWM_SwitchOff = "R3_1_SwitchOffPWM">
	<#assign PWM_GetPhaseCurrents ="">
<#elseif CondFamily_STM32F1 &&  MC.THREE_SHUNT == true>
	<#assign PWM_Init = "R3_2_Init">
	<#assign PWM_TurnOnLowSides = "R3_2_TurnOnLowSides">
	<#assign PWM_SwitchOn = "R3_2_SwitchOnPWM">
	<#assign PWM_SwitchOff = "R3_2_SwitchOffPWM">
	<#assign PWM_GetPhaseCurrents ="R3_2_GetPhaseCurrents">
<#elseif CondLine_STM32F1_HD &&  MC.SINGLE_SHUNT == true>
	<#assign PWM_Init = "R1HD2_Init">
	<#assign PWM_TurnOnLowSides = "R1HD2_TurnOnLowSides">
	<#assign PWM_SwitchOn = "R1HD2_SwitchOnPWM">
	<#assign PWM_SwitchOff = "R1HD2_SwitchOffPWM">
	<#assign PWM_GetPhaseCurrents ="R1HD2_GetPhaseCurrents">
<#elseif (CondLine_STM32F1_Value || CondLine_STM32F1_Performance) &&  MC.SINGLE_SHUNT == true >
	<#assign PWM_Init = "R1VL1_Init"> 
	<#assign PWM_TurnOnLowSides = "R1VL1_TurnOnLowSides">
	<#assign PWM_SwitchOn = "R1VL1_SwitchOnPWM">
	<#assign PWM_SwitchOff = "R1VL1_SwitchOffPWM">
	<#assign PWM_GetPhaseCurrents ="R1VL1_GetPhaseCurrents">
<#elseif CondFamily_STM32F3 && MC.ICS_SENSORS == true> 
	<#assign PWM_Init = "ICS_Init"> 
	<#assign PWM_TurnOnLowSides = "ICS_TurnOnLowSides">
	<#assign PWM_SwitchOn = "ICS_SwitchOnPWM">
	<#assign PWM_SwitchOff = "ICS_SwitchOffPWM">
	<#assign PWM_GetPhaseCurrents ="ICS_GetPhaseCurrents">
<#elseif CondLine_STM32F1_Performance && MC.ICS_SENSORS == true> 
	<#assign PWM_Init = "ICS_Init"> 
	<#assign PWM_TurnOnLowSides = "ICS_TurnOnLowSides">
	<#assign PWM_SwitchOn = "ICS_SwitchOnPWM">
	<#assign PWM_SwitchOff = "ICS_SwitchOffPWM">
	<#assign PWM_GetPhaseCurrents ="ICS_GetPhaseCurrents">
<#elseif CondLine_STM32F1_HD && MC.ICS_SENSORS == true> 
	<#assign PWM_Init = "ICS_Init">
	<#assign PWM_TurnOnLowSides = "ICS_TurnOnLowSides">
	<#assign PWM_SwitchOn = "ICS_SwitchOnPWM">
	<#assign PWM_SwitchOff = "ICS_SwitchOffPWM">
	<#assign PWM_GetPhaseCurrents ="ICS_GetPhaseCurrents">
<#elseif CondFamily_STM32F4 && MC.ICS_SENSORS == true> 
	<#assign PWM_Init = "ICS_Init">
	<#assign PWM_TurnOnLowSides = "ICS_TurnOnLowSides">
	<#assign PWM_SwitchOn = "ICS_SwitchOnPWM">
	<#assign PWM_SwitchOff = "ICS_SwitchOffPWM">
	<#assign PWM_GetPhaseCurrents ="ICS_GetPhaseCurrents">
<#elseif CondFamily_STM32G4 && MC.THREE_SHUNT_INDEPENDENT_RESOURCES == true>   
 	<#assign PWM_Init = "R3_2_Init">  
	<#assign PWM_TurnOnLowSides = "R3_2_TurnOnLowSides">
	<#assign PWM_SwitchOn = "R3_2_SwitchOnPWM">
	<#assign PWM_SwitchOff = "R3_2_SwitchOffPWM">
	<#assign PWM_GetPhaseCurrents ="R3_2_GetPhaseCurrents"> 
<#elseif CondFamily_STM32G4 && MC.SINGLE_SHUNT == true>   
 	<#assign PWM_Init = "R1_Init">  
	<#assign PWM_TurnOnLowSides = "R1_TurnOnLowSides">
	<#assign PWM_SwitchOn = "R1_SwitchOnPWM">
	<#assign PWM_SwitchOff = "R1_SwitchOffPWM">
	<#assign PWM_GetPhaseCurrents ="R1_GetPhaseCurrents">   
<#elseif CondFamily_STM32G4 && MC.ICS_SENSORS == true>   
 	<#assign PWM_Init = "ICS_Init">  
	<#assign PWM_TurnOnLowSides = "ICS_TurnOnLowSides">
	<#assign PWM_SwitchOn = "ICS_SwitchOnPWM">
	<#assign PWM_SwitchOff = "ICS_SwitchOffPWM">
	<#assign PWM_GetPhaseCurrents ="ICS_GetPhaseCurrents">  				
</#if>
<#if CondFamily_STM32L4 &&  MC.THREE_SHUNT_INDEPENDENT_RESOURCES == true>
	<#assign PWM_Init = "R3_2_Init">
	<#assign PWM_TurnOnLowSides = "R3_2_TurnOnLowSides">
	<#assign PWM_SwitchOn = "R3_2_SwitchOnPWM">
	<#assign PWM_SwitchOff = "R3_2_SwitchOffPWM">
	<#assign PWM_GetPhaseCurrents ="R3_2_GetPhaseCurrents">
<#elseif CondFamily_STM32L4 &&  MC.SINGLE_SHUNT == true>
	<#assign PWM_Init = "R1L4XX_Init"> 
	<#assign PWM_TurnOnLowSides = "R1L4XX_TurnOnLowSides">
	<#assign PWM_SwitchOn = "R1L4XX_SwitchOnPWM">
	<#assign PWM_SwitchOff = "R1L4XX_SwitchOffPWM">	
	<#assign PWM_GetPhaseCurrents ="R1L4XX_GetPhaseCurrents">
<#elseif CondFamily_STM32L4 &&  MC.THREE_SHUNT == true>
	<#assign PWM_Init = "R3_1_Init"> 
	<#assign PWM_TurnOnLowSides = "R3_1_TurnOnLowSides">
	<#assign PWM_SwitchOn = "R3_1_SwitchOnPWM">
	<#assign PWM_SwitchOff = "R3_1_SwitchOffPWM">	
	<#assign PWM_GetPhaseCurrents ="R3_1_GetPhaseCurrents">	
<#elseif CondFamily_STM32L4 &&  MC.ICS_SENSORS == true>
	<#assign PWM_Init = "ICS_Init"> 
	<#assign PWM_TurnOnLowSides = "ICS_TurnOnLowSides">
	<#assign PWM_SwitchOn = "ICS_SwitchOnPWM">
	<#assign PWM_SwitchOff = "ICS_SwitchOffPWM">	
	<#assign PWM_GetPhaseCurrents ="ICS_GetPhaseCurrents">	
</#if>
<#if CondFamily_STM32F7 &&  MC.THREE_SHUNT_INDEPENDENT_RESOURCES == true>
	<#assign PWM_Init = "R3_2_Init">
	<#assign PWM_TurnOnLowSides = "R3_2_TurnOnLowSides">
	<#assign PWM_SwitchOn = "R3_2_SwitchOnPWM">
	<#assign PWM_SwitchOff = "R3_2_SwitchOffPWM">
	<#assign PWM_GetPhaseCurrents ="R3_2_GetPhaseCurrents">
<#elseif CondFamily_STM32F7 &&  MC.SINGLE_SHUNT == true>
	<#assign PWM_Init = "R1F7XX_Init"> 
	<#assign PWM_TurnOnLowSides = "R1F7XX_TurnOnLowSides">
	<#assign PWM_SwitchOn = "R1F7XX_SwitchOnPWM">
	<#assign PWM_SwitchOff = "R1F7XX_SwitchOffPWM">	
	<#assign PWM_GetPhaseCurrents ="R1F7XX_GetPhaseCurrents">
<#elseif CondFamily_STM32F7 &&  MC.THREE_SHUNT == true>
	<#assign PWM_Init = "R3_1_Init"> 
	<#assign PWM_TurnOnLowSides = "R3_1_TurnOnLowSides">
	<#assign PWM_SwitchOn = "R3_1_SwitchOnPWM">
	<#assign PWM_SwitchOff = "R3_1_SwitchOffPWM">	
	<#assign PWM_GetPhaseCurrents ="R3_1_GetPhaseCurrents">	
<#elseif CondFamily_STM32F7 &&  MC.ICS_SENSORS == true>
	<#assign PWM_Init = "ICS_Init"> 
	<#assign PWM_TurnOnLowSides = "ICS_TurnOnLowSides">
	<#assign PWM_SwitchOn = "ICS_SwitchOnPWM">
	<#assign PWM_SwitchOff = "ICS_SwitchOffPWM">	
	<#assign PWM_GetPhaseCurrents ="ICS_GetPhaseCurrents">	
</#if>
<#if CondFamily_STM32H7 &&  MC.THREE_SHUNT_INDEPENDENT_RESOURCES == true>
	<#assign PWM_Init = "R3_2_Init">
	<#assign PWM_TurnOnLowSides = "R3_2_TurnOnLowSides">
	<#assign PWM_SwitchOn = "R3_2_SwitchOnPWM">
	<#assign PWM_SwitchOff = "R3_2_SwitchOffPWM">
	<#assign PWM_GetPhaseCurrents ="R3_2_GetPhaseCurrents">
<#elseif CondFamily_STM32H7 &&  MC.SINGLE_SHUNT == true>
	<#assign PWM_Init = "R1_Init"> 
	<#assign PWM_TurnOnLowSides = "R1_TurnOnLowSides">
	<#assign PWM_SwitchOn = "R1_SwitchOnPWM">
	<#assign PWM_SwitchOff = "R1_SwitchOffPWM">	
	<#assign PWM_GetPhaseCurrents ="R1_GetPhaseCurrents">
<#elseif CondFamily_STM32H7 &&  MC.THREE_SHUNT == true>
	<#assign PWM_Init = "R3_1_Init"> 
	<#assign PWM_TurnOnLowSides = "R3_1_TurnOnLowSides">
	<#assign PWM_SwitchOn = "R3_1_SwitchOnPWM">
	<#assign PWM_SwitchOff = "R3_1_SwitchOffPWM">	
	<#assign PWM_GetPhaseCurrents ="R3_1_GetPhaseCurrents">	
<#elseif CondFamily_STM32H7 &&  MC.ICS_SENSORS == true>
	<#assign PWM_Init = "ICS_Init"> 
	<#assign PWM_TurnOnLowSides = "ICS_TurnOnLowSides">
	<#assign PWM_SwitchOn = "ICS_SwitchOnPWM">
	<#assign PWM_SwitchOff = "ICS_SwitchOffPWM">	
	<#assign PWM_GetPhaseCurrents ="ICS_GetPhaseCurrents">	
</#if>
<#if CondFamily_STM32F3 &&  MC.SINGLE_SHUNT2 == true>
	<#assign PWM_Init_M2 = "R1F30X_Init">
	<#assign PWM_TurnOnLowSides_M2 = "R1F30X_TurnOnLowSides">
	<#assign PWM_SwitchOn_M2 = "R1F30X_SwitchOnPWM">
	<#assign PWM_SwitchOff_M2 = "R1F30X_SwitchOffPWM">
	<#assign PWM_GetPhaseCurrents_M2 ="">  
<#elseif CondFamily_STM32F3 && (MC.THREE_SHUNT_SHARED_RESOURCES2 ||  MC.THREE_SHUNT_INDEPENDENT_RESOURCES2 )>
	<#assign PWM_Init_M2 = "R3_2_Init">
	<#assign PWM_TurnOnLowSides_M2 = "R3_2_TurnOnLowSides">
	<#assign PWM_SwitchOn_M2 = "R3_2_SwitchOnPWM">
	<#assign PWM_SwitchOff_M2 = "R3_2_SwitchOffPWM">
	<#assign PWM_GetPhaseCurrents_M2 ="">  
<#elseif CondFamily_STM32F4 &&  MC.SINGLE_SHUNT2 == true>
	<#assign PWM_Init_M2 = "R1F4XX_Init">
	<#assign PWM_TurnOnLowSides_M2 = "R1F4XX_TurnOnLowSides">
	<#assign PWM_SwitchOn_M2 = "R1F4XX_SwitchOnPWM">
	<#assign PWM_SwitchOff_M2 = "R1F4XX_SwitchOffPWM">
	<#assign PWM_GetPhaseCurrents_M2 ="">    
<#elseif CondFamily_STM32F4 &&  MC.THREE_SHUNT_INDEPENDENT_RESOURCES2 == true> 
	<#assign PWM_Init_M2 = "R3_2_Init">
	<#assign PWM_TurnOnLowSides_M2 = "R3_2_TurnOnLowSides">
	<#assign PWM_SwitchOn_M2 = "R3_2_SwitchOnPWM">
	<#assign PWM_SwitchOff_M2 = "R3_2_SwitchOffPWM">
	<#assign PWM_GetPhaseCurrents_M2 ="">
<#elseif CondFamily_STM32F3 && MC.ICS_SENSORS2 == true> 
	<#assign PWM_Init_M2 = "ICS_Init">
	<#assign PWM_TurnOnLowSides_M2 = "ICS_TurnOnLowSides">
	<#assign PWM_SwitchOn_M2 = "ICS_SwitchOnPWM">
	<#assign PWM_SwitchOff_M2 = "ICS_SwitchOffPWM">
	<#assign PWM_GetPhaseCurrents_M2 ="">    
<#elseif CondLine_STM32F1_HD == true && MC.ICS_SENSORS2 == true> 
	<#assign PWM_Init_M2 = "ICS_Init">
	<#assign PWM_TurnOnLowSides_M2 = "ICS_TurnOnLowSides">
	<#assign PWM_SwitchOn_M2 = "ICS_SwitchOnPWM">
	<#assign PWM_SwitchOff_M2 = "ICS_SwitchOffPWM">
	<#assign PWM_GetPhaseCurrents_M2 ="">
<#elseif CondLine_STM32F1_HD && MC.THREE_SHUNT2 == true>
	<#assign PWM_Init_M2 = "R3_Init">
	<#assign PWM_TurnOnLowSides_M2 = "R3_TurnOnLowSides">
	<#assign PWM_SwitchOn_M2 = "R3_SwitchOnPWM">
	<#assign PWM_SwitchOff_M2 = "R3_SwitchOffPWM">
	<#assign PWM_GetPhaseCurrents_M2 ="">     
<#elseif CondLine_STM32F1_HD && MC.SINGLE_SHUNT2 == true> 
	<#assign PWM_Init_M2 = "R1HD2_Init">
	<#assign PWM_TurnOnLowSides_M2 = "R1HD2_TurnOnLowSides">
	<#assign PWM_SwitchOn_M2 = "R1HD2_SwitchOnPWM">
	<#assign PWM_SwitchOff_M2 = "R1HD2_SwitchOffPWM">
	<#assign PWM_GetPhaseCurrents_M2 ="">  
<#elseif CondLine_STM32F1_Performance && MC.THREE_SHUNT2 == true> 
	<#assign PWM_Init_M2 = "R3_Init">
	<#assign PWM_TurnOnLowSides_M2 = "R3_TurnOnLowSides">
	<#assign PWM_SwitchOn_M2 = "R3_SwitchOnPWM">
	<#assign PWM_SwitchOff_M2 = "R3_SwitchOffPWM">
	<#assign PWM_GetPhaseCurrents_M2 =""> 
<#elseif CondLine_STM32F1_Performance && MC.SINGLE_SHUNT2 == true> 
	<#assign PWM_Init_M2 = "R1VL1_Init">
	<#assign PWM_TurnOnLowSides_M2 = "R1VL1_TurnOnLowSides">
	<#assign PWM_SwitchOn_M2 = "R1VL1_SwitchOnPWM">
	<#assign PWM_SwitchOff_M2 = "R1VL1_SwitchOffPWM">
	<#assign PWM_GetPhaseCurrents_M2 =""> 	
<#elseif CondFamily_STM32F4 && MC.ICS_SENSORS2 == true> 
 	<#assign PWM_Init_M2 = "ICS_Init">
	<#assign PWM_TurnOnLowSides_M2 = "ICS_TurnOnLowSides">
	<#assign PWM_SwitchOn_M2 = "ICS_SwitchOnPWM">
	<#assign PWM_SwitchOff_M2 = "ICS_SwitchOffPWM">
	<#assign PWM_GetPhaseCurrents_M2 ="">  
<#elseif CondFamily_STM32G4 && MC.THREE_SHUNT_INDEPENDENT_RESOURCES2 == true>   
 	<#assign PWM_Init_M2 = "R3_2_Init">  
	<#assign PWM_TurnOnLowSides_M2 = "R3_2_TurnOnLowSides">
	<#assign PWM_SwitchOn_M2 = "R3_2_SwitchOnPWM">
	<#assign PWM_SwitchOff_M2 = "R3_2_SwitchOffPWM">
	<#assign PWM_GetPhaseCurrents_M2 ="R3_2_GetPhaseCurrents"> 
<#elseif CondFamily_STM32G4 && MC.SINGLE_SHUNT2 == true>   
 	<#assign PWM_Init_M2 = "R1_Init">  
	<#assign PWM_TurnOnLowSides_M2 = "R1_TurnOnLowSides">
	<#assign PWM_SwitchOn_M2 = "R1_SwitchOnPWM">
	<#assign PWM_SwitchOff_M2 = "R1_SwitchOffPWM">
	<#assign PWM_GetPhaseCurrents_M2 ="R1_GetPhaseCurrents">  	
<#elseif CondFamily_STM32G4 && MC.ICS_SENSORS2 == true>   
 	<#assign PWM_Init_M2 = "ICS_Init">  
	<#assign PWM_TurnOnLowSides_M2 = "ICS_TurnOnLowSides">
	<#assign PWM_SwitchOn_M2 = "ICS_SwitchOnPWM">
	<#assign PWM_SwitchOff_M2 = "ICS_SwitchOffPWM">
	<#assign PWM_GetPhaseCurrents_M2 ="ICS_GetPhaseCurrents">  		
</#if>
<#-- Charge Boot Cap enable condition -->
<#assign CHARGE_BOOT_CAP_ENABLING = ! MC.OTF_STARTUP>
<#assign CHARGE_BOOT_CAP_ENABLING2 = ! MC.OTF_STARTUP2>

/**
  ******************************************************************************
  * @file    mc_tasks.c
  * @author  Motor Control SDK Team, ST Microelectronics
  * @brief   This file implements tasks definition
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

/* Includes ------------------------------------------------------------------*/
#include "main.h"
#include "mc_type.h"
#include "mc_math.h"
#include "motorcontrol.h"
#include "regular_conversion_manager.h"
<#if MC.RTOS == "FREERTOS">
#include "cmsis_os.h"
</#if>
#include "mc_interface.h"
#include "mc_tuning.h"
#include "digital_output.h"
#include "state_machine.h"
#include "pwm_common.h"

<#if  MC.ONE_TOUCH_TUNING == true || MC.MOTOR_PROFILER == true>
#include "mp_one_touch_tuning.h"
#include "mp_self_com_ctrl.h"
</#if>

<#if  MC.POSITION_CTRL_ENABLING == true || MC.POSITION_CTRL_ENABLING2 == true>
#include "trajectory_ctrl.h"
</#if>

#include "mc_tasks.h"
#include "parameters_conversion.h"

/* USER CODE BEGIN Includes */

/* USER CODE END Includes */

/* USER CODE BEGIN Private define */
/* Private define ------------------------------------------------------------*/

#define CHARGE_BOOT_CAP_MS  10
#define CHARGE_BOOT_CAP_MS2 10
#define OFFCALIBRWAIT_MS     0
#define OFFCALIBRWAIT_MS2    0
#define STOPPERMANENCY_MS  400
#define STOPPERMANENCY_MS2 400
#define CHARGE_BOOT_CAP_TICKS  (uint16_t)((SYS_TICK_FREQUENCY * CHARGE_BOOT_CAP_MS)/ 1000)
#define CHARGE_BOOT_CAP_TICKS2 (uint16_t)((SYS_TICK_FREQUENCY * CHARGE_BOOT_CAP_MS2)/ 1000)
#define OFFCALIBRWAITTICKS     (uint16_t)((SYS_TICK_FREQUENCY * OFFCALIBRWAIT_MS)/ 1000)
#define OFFCALIBRWAITTICKS2    (uint16_t)((SYS_TICK_FREQUENCY * OFFCALIBRWAIT_MS2)/ 1000)
#define STOPPERMANENCY_TICKS   (uint16_t)((SYS_TICK_FREQUENCY * STOPPERMANENCY_MS)/ 1000)
#define STOPPERMANENCY_TICKS2  (uint16_t)((SYS_TICK_FREQUENCY * STOPPERMANENCY_MS2)/ 1000)

/* Un-Comment this macro define in order to activate the smooth
   braking action on over voltage */
/* #define  MC.SMOOTH_BRAKING_ACTION_ON_OVERVOLTAGE */

/* USER CODE END Private define */
<#if MC.OV_TEMPERATURE_PROT_ENABLING == true &&  MC.UV_VOLTAGE_PROT_ENABLING == true && MC.OV_VOLTAGE_PROT_ENABLING == true>
#define VBUS_TEMP_ERR_MASK (MC_OVER_VOLT| MC_UNDER_VOLT| MC_OVER_TEMP)
<#else>
<#if  MC.UV_VOLTAGE_PROT_ENABLING == false>
<#assign UV_ERR = "MC_UNDER_VOLT">
<#else>
<#assign UV_ERR = "0">
</#if>
<#if MC.OV_VOLTAGE_PROT_ENABLING == false>
<#assign OV_ERR = "MC_OVER_VOLT">
<#else>
<#assign OV_ERR = "0">
</#if>
<#if MC.OV_TEMPERATURE_PROT_ENABLING == false>
<#assign OT_ERR = "MC_OVER_TEMP">
<#else>
<#assign OT_ERR = "0">
</#if>
#define VBUS_TEMP_ERR_MASK ~(${OV_ERR} | ${UV_ERR} | ${OT_ERR})
</#if>
<#if   MC.DUALDRIVE == true>
<#if MC.OV_TEMPERATURE_PROT_ENABLING2 == true &&  MC.UV_VOLTAGE_PROT_ENABLING2 == true && MC.OV_VOLTAGE_PROT_ENABLING2 == true>
#define VBUS_TEMP_ERR_MASK2 (MC_OVER_VOLT| MC_UNDER_VOLT| MC_OVER_TEMP)
<#else>
<#if  MC.UV_VOLTAGE_PROT_ENABLING2 == false>
<#assign UV_ERR2 = "MC_UNDER_VOLT">
<#else>
<#assign UV_ERR2 = "0">
</#if>
<#if MC.OV_VOLTAGE_PROT_ENABLING2 == false>
<#assign OV_ERR2 = "MC_OVER_VOLT">
<#else>
<#assign OV_ERR2 = "0">
</#if>
<#if MC.OV_TEMPERATURE_PROT_ENABLING == false>
<#assign OT_ERR2 = "MC_OVER_TEMP">
<#else>
<#assign OT_ERR2 = "0">
</#if>
#define VBUS_TEMP_ERR_MASK2 ~(${OV_ERR2} | ${UV_ERR2} | ${OT_ERR2})
</#if>
</#if>

/* Private variables----------------------------------------------------------*/
FOCVars_t FOCVars[NBR_OF_MOTORS];
MCI_Handle_t Mci[NBR_OF_MOTORS];
MCI_Handle_t * oMCInterface[NBR_OF_MOTORS];
<#if MC.MC_TUNING_INTERFACE == true>
MCT_Handle_t MCT[NBR_OF_MOTORS];
</#if>
STM_Handle_t STM[NBR_OF_MOTORS];
SpeednTorqCtrl_Handle_t *pSTC[NBR_OF_MOTORS];
PID_Handle_t *pPIDSpeed[NBR_OF_MOTORS];
PID_Handle_t *pPIDIq[NBR_OF_MOTORS];
PID_Handle_t *pPIDId[NBR_OF_MOTORS];
<#if  MC.ENCODER == true || MC.ENCODER2 == true || MC.AUX_ENCODER == true || MC.AUX_ENCODER2 == true >
EncAlign_Handle_t *pEAC[NBR_OF_MOTORS];
</#if>
<#if  MC.BUS_VOLTAGE_READING == true>
RDivider_Handle_t *pBusSensorM1;
<#else>
VirtualBusVoltageSensor_Handle_t *pBusSensorM1;
</#if>

<#if  MC.POSITION_CTRL_ENABLING == true || MC.POSITION_CTRL_ENABLING2 == true>
PosCtrl_Handle_t *pPosCtrl[NBR_OF_MOTORS];
PID_Handle_t *pPIDPosCtrl[NBR_OF_MOTORS];
</#if>  

<#if   MC.DUALDRIVE == true>
<#if  MC.BUS_VOLTAGE_READING2 == true>
RDivider_Handle_t *pBusSensorM2;
<#else>
VirtualBusVoltageSensor_Handle_t *pBusSensorM2;
</#if>
</#if>
<#if  MC.SMOOTH_BRAKING_ACTION_ON_OVERVOLTAGE == true>
<#if  MC.SINGLEDRIVE == true>
static uint16_t nominalBusd[1] = {0u};
static uint16_t ovthd[1] = {OVERVOLTAGE_THRESHOLD_d};
<#else> 
static uint16_t nominalBusd[2] = {0u,0u};
static uint16_t ovthd[2] = {OVERVOLTAGE_THRESHOLD_d,OVERVOLTAGE_THRESHOLD_d2};
</#if>
</#if>
NTC_Handle_t *pTemperatureSensor[NBR_OF_MOTORS];
PWMC_Handle_t * pwmcHandle[NBR_OF_MOTORS];
DOUT_handle_t *pR_Brake[NBR_OF_MOTORS];
DOUT_handle_t *pOCPDisabling[NBR_OF_MOTORS];
PQD_MotorPowMeas_Handle_t *pMPM[NBR_OF_MOTORS];
CircleLimitation_Handle_t *pCLM[NBR_OF_MOTORS];
<#if  MC.FLUX_WEAKENING_ENABLING == true || MC.FLUX_WEAKENING_ENABLING2 == true>
FW_Handle_t *pFW[NBR_OF_MOTORS];     /* only if M1 or M2 has FW */
</#if>
<#if  MC.FEED_FORWARD_CURRENT_REG_ENABLING == true || MC.FEED_FORWARD_CURRENT_REG_ENABLING2 == true>
FF_Handle_t *pFF[NBR_OF_MOTORS];     /* only if M1 or M2 has FF */
</#if>
<#if  MC.MTPA_ENABLING == true || MC.MTPA_ENABLING2 == true>
MTPA_Handle_t *pMaxTorquePerAmpere[2] = {MC_NULL,MC_NULL}; 
</#if>
<#if ( MC.DUALDRIVE == true &&  MC.OPEN_LOOP_FOC2 == true)>
OpenLoop_Handle_t *pOpenLoop[2] = {MC_NULL,MC_NULL};  /* only if M1 or M2 has OPEN LOOP */
<#elseif ( MC.SINGLEDRIVE == true &&  MC.OPEN_LOOP_FOC == true)>
OpenLoop_Handle_t *pOpenLoop[1] = {MC_NULL};          /* only if M1 has OPEN LOOP */
</#if>
<#if  MC.HFINJECTION == true>
HFI_FP_Ctrl_Handle_t *pHFI[NBR_OF_MOTORS];/* only if M1 or M2 has HFI */
</#if>
<#if MC.MOTOR_PROFILER == true || MC.ONE_TOUCH_TUNING == true>
SCC_Handle_t *pSCC = MC_NULL;
OTT_Handle_t *pOTT = MC_NULL;
</#if>
RampExtMngr_Handle_t *pREMNG[NBR_OF_MOTORS];   /*!< Ramp manager used to modify the Iq ref
                                                    during the start-up switch over.*/

static volatile uint16_t hMFTaskCounterM1 = 0;
static volatile uint16_t hBootCapDelayCounterM1 = 0;
static volatile uint16_t hStopPermanencyCounterM1 = 0;
<#if  MC.DUALDRIVE == true>
static volatile uint16_t hMFTaskCounterM2 = 0;
static volatile uint16_t hBootCapDelayCounterM2 = 0;
static volatile uint16_t hStopPermanencyCounterM2 = 0;
</#if>

uint8_t bMCBootCompleted = 0;

/* USER CODE BEGIN Private Variables */

/* USER CODE END Private Variables */

/* Private functions ---------------------------------------------------------*/
void TSK_MediumFrequencyTaskM1(void);
void FOC_Clear(uint8_t bMotor);
void FOC_InitAdditionalMethods(uint8_t bMotor);
void FOC_CalcCurrRef(uint8_t bMotor);
<#if MC.MOTOR_PROFILER != true>
static uint16_t FOC_CurrControllerM1(void);
<#if  MC.DUALDRIVE == true>
static uint16_t FOC_CurrControllerM2(void);
</#if>
<#else>
bool SCC_DetectBemf( SCC_Handle_t * pHandle );
</#if>
void TSK_SetChargeBootCapDelayM1(uint16_t hTickCount);
bool TSK_ChargeBootCapDelayHasElapsedM1(void);
void TSK_SetStopPermanencyTimeM1(uint16_t hTickCount);
bool TSK_StopPermanencyTimeHasElapsedM1(void);
<#if MC.ON_OVER_VOLTAGE == "TURN_OFF_PWM" || MC.ON_OVER_VOLTAGE2 == "TURN_OFF_PWM">
void TSK_SafetyTask_PWMOFF(uint8_t motor);
</#if>
<#if MC.ON_OVER_VOLTAGE == "TURN_ON_R_BRAKE" || MC.ON_OVER_VOLTAGE2 == "TURN_ON_R_BRAKE">
void TSK_SafetyTask_RBRK(uint8_t motor);
</#if>
<#if MC.ON_OVER_VOLTAGE == "TURN_ON_LOW_SIDES" || MC.ON_OVER_VOLTAGE2 == "TURN_ON_LOW_SIDES">
void TSK_SafetyTask_LSON(uint8_t motor);
</#if>
<#if  MC.DUALDRIVE == true>
void TSK_MediumFrequencyTaskM2(void);
void TSK_SetChargeBootCapDelayM2(uint16_t hTickCount);
bool TSK_ChargeBootCapDelayHasElapsedM2(void);
void TSK_SetStopPermanencyTimeM2(uint16_t SysTickCount);
bool TSK_StopPermanencyTimeHasElapsedM2(void);

#define FOC_ARRAY_LENGTH 2
static uint8_t FOC_array[FOC_ARRAY_LENGTH]={ 0, 0 };
static uint8_t FOC_array_head = 0; // Next obj to be executed
static uint8_t FOC_array_tail = 0; // Last arrived
</#if>

void UI_Scheduler(void);

<#if  MC.EXAMPLE_SPEEDMONITOR == true>
/****************************** USE ONLY FOR SDK 4.0 EXAMPLES *************/
   void ARR_TIM5_update(SpeednPosFdbk_Handle_t pSPD);
/**************************************************************************/
</#if>
/* USER CODE BEGIN Private Functions */

/* USER CODE END Private Functions */
/**
  * @brief  It initializes the whole MC core according to user defined
  *         parameters.
  * @param  pMCIList pointer to the vector of MCInterface objects that will be
  *         created and initialized. The vector must have length equal to the
  *         number of motor drives.
  * @param  pMCTList pointer to the vector of MCTuning objects that will be
  *         created and initialized. The vector must have length equal to the
  *         number of motor drives.
  * @retval None
  */
__weak void MCboot( MCI_Handle_t* pMCIList[NBR_OF_MOTORS],MCT_Handle_t* pMCTList[NBR_OF_MOTORS] )
{
  /* USER CODE BEGIN MCboot 0 */

  /* USER CODE END MCboot 0 */
<#if  MC.FEED_FORWARD_CURRENT_REG_ENABLING == true>
  
</#if>
<#if  MC.HFINJECTION == true>
  
</#if>


<#-- Configuring GPIOs for Testing Environment -->
<#-- <#function _first_word text sep="-"><#return text?split(sep)?first></#function> -->
<#if MC.TESTENV == true && MC.PFC_ENABLED == false >
  <#assign NucleoCond = MC.BOARD?contains("NUCLEO") || 
                        McuName?starts_with("STM32F030R8") ||
                        McuName?starts_with("STM32F072RB") ||
                        McuName?starts_with("STM32G071RB") ||
                        McuName?starts_with("STM32G431RB") ||
                        McuName?starts_with("STM32F103RB") ||
                        McuName?starts_with("STM32F302R8") || 
                        McuName?starts_with("STM32F303RE") ||
                        McuName?starts_with("STM32F401RE") ||
                        McuName?starts_with("STM32F446RE") ||
                        McuName?starts_with("STM32F746ZG") ||
                        McuName?starts_with("STM32L452RE") ||
                        McuName?starts_with("STM32L476RG")
                        >
  <#assign  STM32072B_EVALCond = MC.BOARD == "STM32072B-EVAL" || McuName?starts_with("STM32F072VB")>
  <#assign   STM3210E_EVALCond = MC.BOARD == "STM3210E-EVAL" || McuName?starts_with("STM32F103ZG")>
  <#assign  STM32303E_EVALCond = MC.BOARD == "STM32303E-EVAL" || McuName?starts_with("STM32F303VE")>
  <#assign  STM32446E_EVALCond = MC.BOARD == "STM32446E-EVAL" || McuName?starts_with("STM32F446ZE")>
  <#assign   STM3240G_EVALCond = MC.BOARD == "STM3240G-EVAL" || McuName?starts_with("STM32F407IG")>
  <#assign   STM3241G_EVALCond = MC.BOARD == "STM3241G-EVAL" || McuName?starts_with("STM32F417IG")>
  <#assign STEVAL_IHM039V1Cond = McuName?starts_with("STM32F415ZG")>
  <#assign STM32G081B_EVALCond = MC.BOARD == "STM32G081B-EVAL" || McuName?starts_with("STM32G081RBT")>
  <#assign STM32G474E_EVALCond = McuName?starts_with("STM32G474QE")>
  <#assign STM32L476G_EVALCond = MC.BOARD == "STM32L476G-EVAL" || McuName?starts_with("STM32L476ZG")>
  <#assign STM32F769I_EVALCond = MC.BOARD == "STM32F769I-EVAL" || McuName?starts_with("STM32F769NI")> 

  <#-- 2 Pins need to be configured to drive the WELL board 
       CS stands for Current sensing - Connected to Motor connector DissipativeBrake
       SF stands for Speed feedback  - Connected to Motor connector ICL or MC_NTC (depending on the board)
       PM stands for Performance Measurement - Connected to Motor connector PFC PWM
	   BoardEnable stands for board detection in Automatic test - Connected to Motor connector PFC SYNC
    The connection with Morpho connector is done trough CN10-2 and CN10-4 (from IHM07 schematic)
  -->
  <#if NucleoCond == true >
    <#assign CS_Port = "GPIOC">
    <#assign CS_Pin  = "6">
    <#assign SF_Port = "GPIOC">
    <#assign SF_Pin  = "8">
    <#assign PM_Port = "GPIOC">
    <#assign PM_Pin  = "9">
    <#if McuName?starts_with("STM32G431RB")  >
       <#assign BoardEnable_Port  = "GPIOC">
       <#assign BoardEnable_Pin  = "7"> 
    <#else>
       <#assign BoardEnable_Port  = "GPIOC">
      <#assign BoardEnable_Pin  = "5">
    </#if> 
  <#elseif STM32072B_EVALCond == true>
      <#assign CS_Port = "GPIOB">
      <#assign CS_Pin  = "11">
      <#assign SF_Port = "GPIOE">
      <#assign SF_Pin  = "7">
      <#assign PM_Port = "GPIOC">
      <#assign PM_Pin  = "9">    
      <#assign BoardEnable_Port  = "GPIOC">
      <#assign BoardEnable_Pin  = "8">	   	  
  <#elseif STM3210E_EVALCond == true>
      <#assign CS_Port = "GPIOA">
      <#assign CS_Pin  = "3">
      <#assign SF_Port = "GPIOB">
      <#assign SF_Pin  = "12">
      <#assign PM_Port = "GPIOB">
      <#assign PM_Pin  = "5">   
      <#assign BoardEnable_Port  = "GPIOD">
      <#assign BoardEnable_Pin  = "2">	  	  
  <#elseif STM32303E_EVALCond == true>
    <#assign CS_Port = "GPIOE">
    <#assign CS_Pin  = "5">
    <#assign SF_Port = "GPIOE">
    <#assign SF_Pin  = "4">
    <#assign PM_Port = "GPIOE">
    <#assign PM_Pin  = "3">                
    <#assign BoardEnable_Port  = "GPIOE">
    <#assign BoardEnable_Pin  = "2">
  <#if MC.DUALDRIVE == true && MC.INRUSH_CURRLIMIT_ENABLING == false && MC.ON_OVER_VOLTAGE != "TURN_ON_R_BRAKE"> 
      <#assign CS_PortM2 = "GPIOF">
      <#assign CS_PinM2  = "10">
      <#assign SF_PortM2 = "GPIOD">
      <#assign SF_PinM2  = "15">
    </#if> 
  <#elseif STEVAL_IHM039V1Cond == true>
    <#assign CS_Port = "GPIOB">
    <#assign CS_Pin  = "6">
    <#assign SF_Port = "GPIOB">
    <#assign SF_Pin  = "7">
    <#assign PM_Port = "GPIOB">
    <#assign PM_Pin  = "5"> 
    <#assign BoardEnable_Port  = "GPIOB">
    <#assign BoardEnable_Pin  = "4">	
    <#if MC.DUALDRIVE == true && MC.INRUSH_CURRLIMIT_ENABLING == false && MC.ON_OVER_VOLTAGE != "TURN_ON_R_BRAKE"> 
      <#assign CS_PortM2 = "GPIOB">
      <#assign CS_PinM2  = "8">
      <#assign SF_PortM2 = "GPIOB">
      <#assign SF_PinM2  = "9">
    </#if>    
  <#elseif STM3240G_EVALCond == true>
      <#assign CS_Port = "GPIOC">
      <#assign CS_Pin  = "8">
      <#assign SF_Port = "GPIOH">
      <#assign SF_Pin  = "8">
      <#assign PM_Port = "GPIOH">
      <#assign PM_Pin  = "12">   
      <#assign BoardEnable_Port  = "GPIOH">
      <#assign BoardEnable_Pin  = "10">		  
  <#elseif STM3241G_EVALCond == true>
      <#assign CS_Port = "GPIOC">
      <#assign CS_Pin  = "8">
      <#assign SF_Port = "GPIOH">
      <#assign SF_Pin  = "8">
      <#assign PM_Port = "GPIOH">
      <#assign PM_Pin  = "12"> 
      <#assign BoardEnable_Port  = "GPIOH">
      <#assign BoardEnable_Pin  = "10">
  <#elseif STM32446E_EVALCond == true>
      <#assign CS_Port = "GPIOD">
      <#assign CS_Pin  = "3">
      <#assign SF_Port = "GPIOG">
      <#assign SF_Pin  = "6">
      <#assign PM_Port = "GPIOA">
      <#assign PM_Pin  = "11">       
      <#assign BoardEnable_Port  = "GPIOA">
      <#assign BoardEnable_Pin  = "8">
  <#elseif STM32F769I_EVALCond == true>
      <#assign CS_Port = "GPIOH">
      <#assign CS_Pin  = "6">
      <#assign SF_Port = "GPIOG">
      <#assign SF_Pin  = "11">
      <#assign PM_Port = "GPIOA">
      <#assign PM_Pin  = "11">             
      <#assign BoardEnable_Port  = "GPIOA">
      <#assign BoardEnable_Pin  = "12">
  <#elseif STM32L476G_EVALCond == true>
      <#assign CS_Port = "GPIOB">
      <#assign CS_Pin  = "2">
      <#assign SF_Port = "GPIOG">
      <#assign SF_Pin  = "6">
      <#assign PM_Port = "GPIOF">
      <#assign PM_Pin  = "10">                   
      <#assign BoardEnable_Port  = "GPIOF">
      <#assign BoardEnable_Pin  = "9">
  <#elseif STM32G081B_EVALCond == true>
      <#assign CS_Port = "GPIOB">
      <#assign CS_Pin  = "15">
      <#assign SF_Port = "GPIOB">
      <#assign SF_Pin  = "9">      
      <#assign PM_Port = "GPIOB">
      <#assign PM_Pin  = "1"> 
      <#assign BoardEnable_Port  = "GPIOD">
      <#assign BoardEnable_Pin  = "0">
  <#elseif STM32G474E_EVALCond == true>
      <#assign CS_Port = "GPIOE">
      <#assign CS_Pin  = "5">
      <#assign SF_Port = "GPIOE">
      <#assign SF_Pin  = "4">      
      <#assign PM_Port = "GPIOE">
      <#assign PM_Pin  = "3">
      <#assign BoardEnable_Port  = "GPIOE">
      <#assign BoardEnable_Pin  = "2">	  
  <#else>
    #error "Cannot generate Test Env code with this control board"
    <#assign CS_Port = "">
    <#assign CS_Pin  = "">
    <#assign SF_Port = "">
    <#assign SF_Pin  = "">
    <#assign PM_Port = "">
    <#assign PM_Pin  = "">
    <#assign CS_PortM2 = "">
    <#assign CS_PinM2  = "">
    <#assign SF_PortM2 = "">
    <#assign SF_PinM2  = "">
  </#if>
  /* ************************************************************************************** */
  /* ***                               Test Environment Setup                           *** */
  /* ************************************************************************************** */
  /* *** MC.BOARD == ${MC.BOARD} -- McuName == ${McuName} *** */
#ifdef MC_HAL_IS_USED
  {
    GPIO_InitTypeDef GPIO_InitStruct;
  
    /* Enabling clock for Current Sensing topology control GPIO Port */
    if (__HAL_RCC_${CS_Port}_IS_CLK_DISABLED())
    {
      __HAL_RCC_${CS_Port}_CLK_ENABLE();
    }
  
    /* Enabling clock for Speed Feedback technology control GPIO Port */
    if (__HAL_RCC_${SF_Port}_IS_CLK_DISABLED())
    {
      __HAL_RCC_${SF_Port}_CLK_ENABLE();
    }

    /* Enabling clock for the performance measurement GPIO Port */
    if (__HAL_RCC_${PM_Port}_IS_CLK_DISABLED())
    {
      __HAL_RCC_${PM_Port}_CLK_ENABLE();
    }
    
    <#if MC.CURRENT_READING_TOPOLOGY == "SINGLE_SHUNT">
    /* Current Reading Topology: Single Shunt configuration */
    HAL_GPIO_WritePin( ${CS_Port}, GPIO_PIN_${CS_Pin}, GPIO_PIN_RESET );
    <#else>
    /* Current Reading Topology: Three Shunts or ICS configuration */
    HAL_GPIO_WritePin( ${CS_Port}, GPIO_PIN_${CS_Pin}, GPIO_PIN_SET );
    </#if>
  
    <#if MC.SPEED_SENSOR_SELECTION == "ENCODER">
    /* Speed Feedback Technology: Encoder configuration */
    HAL_GPIO_WritePin( ${SF_Port}, GPIO_PIN_${SF_Pin}, GPIO_PIN_RESET );
    <#else>
    /* Speed Feedback Technology: Hall sensor or sensorless configuration */
    HAL_GPIO_WritePin( ${SF_Port}, GPIO_PIN_${SF_Pin}, GPIO_PIN_SET );
    </#if>

    /* Performance Measurement: initialization */
    HAL_GPIO_WritePin( ${PM_Port}, GPIO_PIN_${PM_Pin}, GPIO_PIN_RESET );

    /*  Test Board Enable */
    HAL_GPIO_WritePin( ${BoardEnable_Port}, GPIO_PIN_${BoardEnable_Pin}, GPIO_PIN_SET );

    /* Configuring Current Sensing topology control GPIO port and pin */  
    GPIO_InitStruct.Pin = GPIO_PIN_${CS_Pin};
    GPIO_InitStruct.Mode = GPIO_MODE_OUTPUT_PP;
    GPIO_InitStruct.Pull = GPIO_NOPULL;
    GPIO_InitStruct.Speed = GPIO_SPEED_FREQ_LOW;
    HAL_GPIO_Init( ${CS_Port}, &GPIO_InitStruct );
    
    /* Configuring Speed Feedback technology control GPIO port and pin */  
    GPIO_InitStruct.Pin = GPIO_PIN_${SF_Pin};
    GPIO_InitStruct.Mode = GPIO_MODE_OUTPUT_PP;
    GPIO_InitStruct.Pull = GPIO_NOPULL;
    GPIO_InitStruct.Speed = GPIO_SPEED_FREQ_LOW;
    HAL_GPIO_Init( ${SF_Port}, &GPIO_InitStruct );

    /* Configuring the Performance Measurement GPIO port and pin */  
    GPIO_InitStruct.Pin = GPIO_PIN_${PM_Pin};
    GPIO_InitStruct.Mode = GPIO_MODE_OUTPUT_PP;
    GPIO_InitStruct.Pull = GPIO_NOPULL;
    GPIO_InitStruct.Speed = GPIO_SPEED_FREQ_LOW;
    HAL_GPIO_Init( ${PM_Port}, &GPIO_InitStruct );

    /* Configuring the Test Board Enable GPIO port and pin */  
    GPIO_InitStruct.Pin = GPIO_PIN_${BoardEnable_Pin};
    GPIO_InitStruct.Mode = GPIO_MODE_OUTPUT_PP;
    GPIO_InitStruct.Pull = GPIO_NOPULL;
    GPIO_InitStruct.Speed = GPIO_SPEED_FREQ_LOW;
    HAL_GPIO_Init( ${BoardEnable_Port}, &GPIO_InitStruct );

    <#if MC.DUALDRIVE == true && MC.INRUSH_CURRLIMIT_ENABLING == false && MC.ON_OVER_VOLTAGE != "TURN_ON_R_BRAKE">
    /* Enabling clock for Current Sensing topology control GPIO Port, Motor 2 */
    if (__HAL_RCC_${CS_PortM2}_IS_CLK_DISABLED())
    {
      __HAL_RCC_${CS_PortM2}_CLK_ENABLE();
    }
  
    /* Enabling clock for Speed Feedback technology control GPIO Port, Motor 2 */
    if (__HAL_RCC_${SF_PortM2}_IS_CLK_DISABLED())
    {
      __HAL_RCC_${SF_PortM2}_CLK_ENABLE();
    }
  
      <#if MC.CURRENT_READING_TOPOLOGY2 == "SINGLE_SHUNT2">
    /* Current Reading Topology: Single Shunt configuration, Motor 2 */
    HAL_GPIO_WritePin( ${CS_PortM2}, GPIO_PIN_${CS_PinM2}, GPIO_PIN_RESET );
      <#else>
    /* Current Reading Topology: Three Shunts or ICS configuration, Motor 2 */
    HAL_GPIO_WritePin( ${CS_PortM2}, GPIO_PIN_${CS_PinM2}, GPIO_PIN_SET );
      </#if>
  
      <#if MC.SPEED_SENSOR_SELECTION2 == "ENCODER2">
    /* Speed Feedback Technology: Encoder configuration, Motor 2 */
    HAL_GPIO_WritePin( ${SF_PortM2}, GPIO_PIN_${SF_PinM2}, GPIO_PIN_RESET );
      <#else>
    /* Speed Feedback Technology: Hall sensor or sensorless configuration, Motor 2 */
    HAL_GPIO_WritePin( ${SF_PortM2}, GPIO_PIN_${SF_PinM2}, GPIO_PIN_SET );
      </#if>

    /* Configuring Current Sensing topology control GPIO port and pin */  
    GPIO_InitStruct.Pin = GPIO_PIN_${CS_PinM2};
    GPIO_InitStruct.Mode = GPIO_MODE_OUTPUT_PP;
    GPIO_InitStruct.Pull = GPIO_NOPULL;
    GPIO_InitStruct.Speed = GPIO_SPEED_FREQ_LOW;
    HAL_GPIO_Init( ${CS_PortM2}, &GPIO_InitStruct );
    
    /* Configuring Speed Feedback technology control GPIO port and pin */  
    GPIO_InitStruct.Pin = GPIO_PIN_${SF_PinM2};
    GPIO_InitStruct.Mode = GPIO_MODE_OUTPUT_PP;
    GPIO_InitStruct.Pull = GPIO_NOPULL;
    GPIO_InitStruct.Speed = GPIO_SPEED_FREQ_LOW;
    HAL_GPIO_Init( ${SF_PortM2}, &GPIO_InitStruct );
    </#if>
  }
#else /* MC_HAL_IS_USED */
  {
    LL_GPIO_InitTypeDef GPIO_TestEnvInitStruct;
    
    /* Enabling clock for Current Sensing topology control GPIO Port */
    if (  LL_AHB1_GRP1_IsEnabledClock( LL_AHB1_GRP1_PERIPH_${CS_Port} ) ) 
    {
      /* GPIOC block clock is not enabled. Enable it */
      LL_AHB1_GRP1_EnableClock(LL_AHB1_GRP1_PERIPH_${CS_Port});
    }
    
    /* Enabling clock for Speed Feedback technology control GPIO Port */
    if (  LL_AHB1_GRP1_IsEnabledClock( LL_AHB1_GRP1_PERIPH_${SF_Port} ) ) 
    {
      /* GPIOC block clock is not enabled. Enable it */
      LL_AHB1_GRP1_EnableClock(LL_AHB1_GRP1_PERIPH_${SF_Port});
    }

    /* Enabling clock for the performance measurement GPIO Port */
    if (  LL_AHB1_GRP1_IsEnabledClock( LL_AHB1_GRP1_PERIPH_${PM_Port} ) ) 
    {
      /* GPIOC block clock is not enabled. Enable it */
      LL_AHB1_GRP1_EnableClock(LL_AHB1_GRP1_PERIPH_${PM_Port});
    }
        
    <#if MC.CURRENT_READING_TOPOLOGY == "SINGLE_SHUNT">
    /* Current Reading Topology: Single Shunt configuration */
    LL_GPIO_ResetOutputPin( ${CS_Port}, LL_GPIO_PIN_${CS_Pin} );
    <#else>
    /* Current Reading Topology: Three Shunts or ICS configuration */
    LL_GPIO_SetOutputPin( ${CS_Port}, LL_GPIO_PIN_${CS_Pin} );
    </#if>
    
    <#if MC.SPEED_SENSOR_SELECTION == "ENCODER">
    /* Speed Feedback Technology: Encoder configuration */
    LL_GPIO_ResetOutputPin( ${SF_Port}, LL_GPIO_PIN_${SF_Pin} );
    <#else>
    /* Speed Feedback Technology: Hall sensor or sensorless configuration */
    LL_GPIO_SetOutputPin( ${SF_Port}, LL_GPIO_PIN_${SF_Pin} );
    </#if>

    /* Performance Measurement: initialization */
    LL_GPIO_ResetOutputPin( ${PM_Port}, LL_GPIO_PIN_${PM_Pin} );
    
    /* Configuring Current Sensing topology control GPIO port and pin */  
    GPIO_TestEnvInitStruct.Pin = LL_GPIO_PIN_${CS_Pin};
    GPIO_TestEnvInitStruct.Mode = LL_GPIO_MODE_OUTPUT;
    GPIO_TestEnvInitStruct.Speed = LL_GPIO_SPEED_FREQ_LOW;
    GPIO_TestEnvInitStruct.OutputType = LL_GPIO_OUTPUT_PUSHPULL;
    GPIO_TestEnvInitStruct.Pull = LL_GPIO_PULL_NO;
    LL_GPIO_Init( ${CS_Port}, &GPIO_TestEnvInitStruct );

    /* Configuring Speed Feedback technology control GPIO port and pin */  
    GPIO_TestEnvInitStruct.Pin = LL_GPIO_PIN_${SF_Pin};
    GPIO_TestEnvInitStruct.Mode = LL_GPIO_MODE_OUTPUT;
    GPIO_TestEnvInitStruct.Speed = LL_GPIO_SPEED_FREQ_LOW;
    GPIO_TestEnvInitStruct.OutputType = LL_GPIO_OUTPUT_PUSHPULL;
    GPIO_TestEnvInitStruct.Pull = LL_GPIO_PULL_NO;
    LL_GPIO_Init( ${SF_Port}, &GPIO_TestEnvInitStruct );

    /* Configuring the Performance Measurement GPIO port and pin */  
    GPIO_TestEnvInitStruct.Pin = LL_GPIO_PIN_${PM_Pin};
    GPIO_TestEnvInitStruct.Mode = LL_GPIO_MODE_OUTPUT;
    GPIO_TestEnvInitStruct.Speed = LL_GPIO_SPEED_FREQ_LOW;
    GPIO_TestEnvInitStruct.OutputType = LL_GPIO_OUTPUT_PUSHPULL;
    GPIO_TestEnvInitStruct.Pull = LL_GPIO_PULL_NO;
    LL_GPIO_Init( ${PM_Port}, &GPIO_TestEnvInitStruct );

    <#if MC.DUALDRIVE == true && MC.INRUSH_CURRLIMIT_ENABLING == false && MC.ON_OVER_VOLTAGE != "TURN_ON_R_BRAKE">
    /* Enabling clock for Current Sensing topology control GPIO Port, Motor2 */
    if (  LL_AHB1_GRP1_IsEnabledClock( LL_AHB1_GRP1_PERIPH_${CS_PortM2} ) ) 
    {
      /* GPIOC block clock is not enabled. Enable it */
      LL_AHB1_GRP1_EnableClock(LL_AHB1_GRP1_PERIPH_${CS_PortM2});
    }
    
    /* Enabling clock for Speed Feedback technology control GPIO Port, Motor2 */
    if (  LL_AHB1_GRP1_IsEnabledClock( LL_AHB1_GRP1_PERIPH_${SF_PortM2} ) ) 
    {
      /* GPIOC block clock is not enabled. Enable it */
      LL_AHB1_GRP1_EnableClock(LL_AHB1_GRP1_PERIPH_${SF_PortM2});
    }
    
      <#if MC.CURRENT_READING_TOPOLOGY2 == "SINGLE_SHUNT2">
    /* Current Reading Topology: Single Shunt configuration, Motor2 */
    LL_GPIO_ResetOutputPin( ${CS_PortM2}, LL_GPIO_PIN_${CS_PinM2} );
      <#else>
    /* Current Reading Topology: Three Shunts or ICS configuration, Motor2 */
    LL_GPIO_SetOutputPin( ${CS_PortM2}, LL_GPIO_PIN_${CS_PinM2} );
      </#if>
    
      <#if MC.SPEED_SENSOR_SELECTION2 == "ENCODER2">
    /* Speed Feedback Technology: Encoder configuration, Motor2 */
    LL_GPIO_ResetOutputPin( ${SF_PortM2}, LL_GPIO_PIN_${SF_PinM2} );
      <#else>
    /* Speed Feedback Technology: Hall sensor or sensorless configuration, Motor2 */
    LL_GPIO_SetOutputPin( ${SF_PortM2}, LL_GPIO_PIN_${SF_PinM2} );
      </#if>
  
    /* Configuring Current Sensing topology control GPIO port and pin, Motor2 */  
    GPIO_TestEnvInitStruct.Pin = LL_GPIO_PIN_${CS_PinM2};
    GPIO_TestEnvInitStruct.Mode = LL_GPIO_MODE_OUTPUT;
    GPIO_TestEnvInitStruct.Speed = LL_GPIO_SPEED_FREQ_LOW;
    GPIO_TestEnvInitStruct.OutputType = LL_GPIO_OUTPUT_PUSHPULL;
    GPIO_TestEnvInitStruct.Pull = LL_GPIO_PULL_NO;
    LL_GPIO_Init( ${CS_PortM2}, &GPIO_TestEnvInitStruct );

    /* Configuring Speed Feedback technology control GPIO port and pin, Motor2 */  
    GPIO_TestEnvInitStruct.Pin = LL_GPIO_PIN_${SF_PinM2};
    GPIO_TestEnvInitStruct.Mode = LL_GPIO_MODE_OUTPUT;
    GPIO_TestEnvInitStruct.Speed = LL_GPIO_SPEED_FREQ_LOW;
    GPIO_TestEnvInitStruct.OutputType = LL_GPIO_OUTPUT_PUSHPULL;
    GPIO_TestEnvInitStruct.Pull = LL_GPIO_PULL_NO;
    LL_GPIO_Init( ${SF_PortM2}, &GPIO_TestEnvInitStruct );
    </#if>
 }
#endif /* MC_HAL_IS_USED */
</#if>

<#if  MC.DUALDRIVE == true>

<#if  MC.FEED_FORWARD_CURRENT_REG_ENABLING2 == true>
  
</#if>
<#if  MC.HFINJECTION2 == true>
 
</#if>
</#if>
  /**************************************/
  /*    State machine initialization    */
  /**************************************/
  STM_Init(&STM[M1]);
  
<#if MC.USE_STGAP1S>
  /**************************************/
  /*    STGAP1AS initialization         */
  /**************************************/
  if (GAP_Configuration(&STGAP_M1) == false)
  {
    STM_FaultProcessing( &STM[M1], MC_SW_ERROR, 0 );
  }
</#if>  
  bMCBootCompleted = 0;
  pCLM[M1] = &CircleLimitationM1;
<#if  MC.FLUX_WEAKENING_ENABLING == true>
  pFW[M1] = &FW_M1; /* only if M1 has FW */
<#elseif MC.FLUX_WEAKENING_ENABLING == false && MC.FLUX_WEAKENING_ENABLING2 == true>
  pFW[M1] = MC_NULL;
</#if>
<#if  MC.FEED_FORWARD_CURRENT_REG_ENABLING == true>
  pFF[M1] = &FF_M1; /* only if M1 has FF */
<#elseif  MC.FEED_FORWARD_CURRENT_REG_ENABLING == false && MC.FEED_FORWARD_CURRENT_REG_ENABLING2 == true>
  pFF[M1] = MC_NULL;
</#if>
<#if  MC.HFINJECTION == true>
  
</#if>

<#if  MC.MTPA_ENABLING == true>
  pMaxTorquePerAmpere[M1] = &MTPARegM1;
</#if>
<#if  MC.HW_OV_CURRENT_PROT_BYPASS == true &&  MC.ON_OVER_VOLTAGE == "TURN_ON_LOW_SIDES">
  pOCPDisabling[M1] = &DOUT_OCPDisablingParamsM1;
  DOUT_SetOutputState(pOCPDisabling[M1],INACTIVE);
</#if>
<#if  MC.DUALDRIVE == true>
  pCLM[M2] = &CircleLimitationM2;
<#if  MC.FLUX_WEAKENING_ENABLING2 == true>
  pFW[M2] = &FW_M2; /* only if M2 has FW */
<#elseif MC.FLUX_WEAKENING_ENABLING2 == false && MC.FLUX_WEAKENING_ENABLING == true>
  pFW[M2] = MC_NULL;
</#if>
<#if  MC.FEED_FORWARD_CURRENT_REG_ENABLING2 == true>
  pFF[M2] = &FF_M2; /* only if M2 has FF */
<#elseif MC.FEED_FORWARD_CURRENT_REG_ENABLING2 == false && MC.FEED_FORWARD_CURRENT_REG_ENABLING == true>
  pFF[M2] = MC_NULL;
</#if>
<#if  MC.MTPA_ENABLING2 == true>
  pMaxTorquePerAmpere[M2] = &MTPARegM2;
</#if>
<#if  MC.HFINJECTION2 == true>
  
</#if>

<#if  MC.HW_OV_CURRENT_PROT_BYPASS2 == true &&  MC.ON_OVER_VOLTAGE2 == "TURN_ON_LOW_SIDES"> 
  pOCPDisabling[M2] = &DOUT_OCPDisablingParamsM2;
  DOUT_SetOutputState(pOCPDisabling[M2],INACTIVE);
</#if> 
</#if> 
  /**********************************************************/
  /*    PWM and current sensing component initialization    */
  /**********************************************************/
  pwmcHandle[M1] = &PWM_Handle_M1._Super;
  ${PWM_Init}(&PWM_Handle_M1);
<#if  MC.DUALDRIVE == true> 
  pwmcHandle[M2] = &PWM_Handle_M2._Super;
  ${PWM_Init_M2}(&PWM_Handle_M2); 
</#if>
  /* USER CODE BEGIN MCboot 1 */

  /* USER CODE END MCboot 1 */

<#if ! CondFamily_STM32F0 >
  /**************************************/
  /*    Start timers synchronously      */
  /**************************************/
  startTimers();    
</#if>   

  /******************************************************/
  /*   PID component initialization: speed regulation   */
  /******************************************************/
  PID_HandleInit(&PIDSpeedHandle_M1);
  pPIDSpeed[M1] = &PIDSpeedHandle_M1;
  
  /******************************************************/
  /*   Main speed sensor component initialization       */
  /******************************************************/
  pSTC[M1] = &SpeednTorqCtrlM1;
  ${SPD_init_M1} (${SPD_M1});
  
<#if  MC.ENCODER == true>
  /******************************************************/
  /*   Main encoder alignment component initialization  */
  /******************************************************/
  EAC_Init(&EncAlignCtrlM1,pSTC[M1],&VirtualSpeedSensorM1,${SPD_M1});
  pEAC[M1] = &EncAlignCtrlM1;
  
</#if>  

<#if  MC.POSITION_CTRL_ENABLING == true>
  /******************************************************/
  /*   Position Control component initialization        */
  /******************************************************/
  pPIDPosCtrl[M1] = &PID_PosParamsM1;
  PID_HandleInit(pPIDPosCtrl[M1]);
  
  pPosCtrl[M1] = &pPosCtrlM1;
  TC_Init(pPosCtrl[M1], pPIDPosCtrl[M1], &SpeednTorqCtrlM1, ${SPD_M1});
</#if>  

  /******************************************************/
  /*   Speed & torque component initialization          */
  /******************************************************/
  STC_Init(pSTC[M1],pPIDSpeed[M1], ${SPD_M1}._Super);
  
 <#if  AUX_SPEED_FDBK_M1  == true ||  MC.HFINJECTION == true>
  /******************************************************/
  /*   Auxiliary speed sensor component initialization  */
  /******************************************************/
  ${SPD_aux_init_M1} (${SPD_AUX_M1});
  
 <#if  MC.AUX_ENCODER == true>
  /***********************************************************/
  /*   Auxiliary encoder alignment component initialization  */
  /***********************************************************/
  EAC_Init(&EncAlignCtrlM1,pSTC[M1],&VirtualSpeedSensorM1,${SPD_AUX_M1});
  pEAC[M1] = &EncAlignCtrlM1;
 </#if>
 </#if>
<#if   MC.STATE_OBSERVER_PLL == true || MC.STATE_OBSERVER_CORDIC == true ||  MC.ENCODER == true ||  MC.AUX_ENCODER == true> 
  /****************************************************/
  /*   Virtual speed sensor component initialization  */
  /****************************************************/ 
  VSS_Init (&VirtualSpeedSensorM1);
  
</#if>
<#if   MC.STATE_OBSERVER_PLL == true || MC.STATE_OBSERVER_CORDIC == true>  
  /**************************************/
  /*   Rev-up component initialization  */
  /**************************************/
  RUC_Init(&RevUpControlM1,pSTC[M1],&VirtualSpeedSensorM1, &STO_M1, pwmcHandle[M1]);  
      
</#if>
  /********************************************************/
  /*   PID component initialization: current regulation   */
  /********************************************************/
  PID_HandleInit(&PIDIqHandle_M1);
  PID_HandleInit(&PIDIdHandle_M1);
  pPIDIq[M1] = &PIDIqHandle_M1;
  pPIDId[M1] = &PIDIdHandle_M1;
  
<#if   MC.BUS_VOLTAGE_READING == true>
  /********************************************************/
  /*   Bus voltage sensor component initialization        */
  /********************************************************/
  pBusSensorM1 = &RealBusVoltageSensorParamsM1;
  RVBS_Init(pBusSensorM1);
  
<#else>
  /**********************************************************/
  /*   Virtual bus voltage sensor component initialization  */
  /**********************************************************/
  pBusSensorM1 = &VirtualBusVoltageSensorParamsM1; 
  VVBS_Init(pBusSensorM1);
  
</#if>
  /*************************************************/
  /*   Power measurement component initialization  */
  /*************************************************/
  pMPM[M1] = &PQD_MotorPowMeasM1;
  pMPM[M1]->pVBS = &(pBusSensorM1->_Super);
  pMPM[M1]->pFOCVars = &FOCVars[M1];
  
<#if   MC.ON_OVER_VOLTAGE == "TURN_ON_R_BRAKE">  
  pR_Brake[M1] = &R_BrakeParamsM1;
  DOUT_SetOutputState(pR_Brake[M1],INACTIVE);
  
</#if> 
  /*******************************************************/
  /*   Temperature measurement component initialization  */
  /*******************************************************/
  NTC_Init(&TempSensorParamsM1);    
  pTemperatureSensor[M1] = &TempSensorParamsM1;
    
<#if  MC.FLUX_WEAKENING_ENABLING == true>
  /*******************************************************/
  /*   Flux weakening component initialization           */
  /*******************************************************/
  PID_HandleInit(&PIDFluxWeakeningHandle_M1);
  FW_Init(pFW[M1],pPIDSpeed[M1],&PIDFluxWeakeningHandle_M1);   
             
</#if>
<#if  MC.FEED_FORWARD_CURRENT_REG_ENABLING == true>
  /*******************************************************/
  /*   Feed forward component initialization             */
  /*******************************************************/
  FF_Init(pFF[M1],&(pBusSensorM1->_Super),pPIDId[M1],pPIDIq[M1]);  
  
</#if>
<#if  MC.OPEN_LOOP_FOC == true>
  OL_Init(&OpenLoop_ParamsM1, &VirtualSpeedSensorM1);     /* only if M1 has open loop */
  pOpenLoop[M1] = &OpenLoop_ParamsM1;
</#if>
<#if  MC.HFINJECTION == true>
  /*******************************************************/
  /*   HFI sensorless component initialization           */
  /*******************************************************/
  HfiFpCtrlM1.pHfiFpSpeedSensor = ${SPD_M1}; 
  HfiFpCtrlM1.FOCVars = &FOCVars[M1];                           
  HfiFpCtrlM1.pPIDq = pPIDIq[M1];                                    
  HfiFpCtrlM1.pPIDd = pPIDId[M1];                                   
  HfiFpCtrlM1.pVbusSensor = &(pBusSensorM1->_Super);                      
  HFI_FP_Init(&HfiFpCtrlM1);                              
  pHFI[M1] = &HfiFpCtrlM1; 
  
</#if>

  pREMNG[M1] = &RampExtMngrHFParamsM1;
  REMNG_Init(pREMNG[M1]);

<#if (MC.MOTOR_PROFILER == true || MC.ONE_TOUCH_TUNING == true)>
  pSCC = &SCC; /* only if M1 has MOTOR_PROFILER */
  pOTT = &OTT;
  pSCC->pPWMC = pwmcHandle[M1];
  pSCC->pVBS = pBusSensorM1;
  pSCC->pFOCVars = &FOCVars[M1];
  pSCC->pSTM = &STM[M1];
  pSCC->pVSS = &VirtualSpeedSensorM1;
  pSCC->pCLM = pCLM[M1];
  pSCC->pPIDIq = pPIDIq[M1];
  pSCC->pPIDId = pPIDId[M1];
  pSCC->pRevupCtrl = &RevUpControlM1;
  pSCC->pSTO = &STO_PLL_M1;
  pSCC->pSTC = pSTC[M1];
  pSCC->pOTT = pOTT;
  SCC_Init(&SCC);

  pOTT->pSpeedSensor = &STO_PLL_M1._Super;
  pOTT->pFOCVars = &FOCVars[M1];
  pOTT->pPIDSpeed = pPIDSpeed[M1];
  pOTT->pSTC = pSTC[M1];
  OTT_Init(&OTT);
</#if>
  
  FOC_Clear(M1);
  FOCVars[M1].bDriveInput = EXTERNAL;
  FOCVars[M1].Iqdref = STC_GetDefaultIqdref(pSTC[M1]);
  FOCVars[M1].UserIdref = STC_GetDefaultIqdref(pSTC[M1]).d;
  oMCInterface[M1] = & Mci[M1];
<#if MC.POSITION_CTRL_ENABLING == true || MC.POSITION_CTRL_ENABLING2 == true>
<#if MC.POSITION_CTRL_ENABLING == true>  
  MCI_Init(oMCInterface[M1], &STM[M1], pSTC[M1], &FOCVars[M1], pPosCtrl[M1]);
<#else>
  MCI_Init(oMCInterface[M1], &STM[M1], pSTC[M1], &FOCVars[M1], MC_NULL);
</#if>
<#else>
  MCI_Init(oMCInterface[M1], &STM[M1], pSTC[M1], &FOCVars[M1] );
</#if>
  MCI_ExecSpeedRamp(oMCInterface[M1],
  STC_GetMecSpeedRefUnitDefault(pSTC[M1]),0); /*First command to STC*/
  pMCIList[M1] = oMCInterface[M1];
<#if MC.MC_TUNING_INTERFACE == true>
  MCT[M1].pPIDSpeed = pPIDSpeed[M1];
  MCT[M1].pPIDIq = pPIDIq[M1];
  MCT[M1].pPIDId = pPIDId[M1];
<#if  MC.FLUX_WEAKENING_ENABLING == true>
  MCT[M1].pPIDFluxWeakening = &PIDFluxWeakeningHandle_M1; /* only if M1 has FW */
<#else>
  MCT[M1].pPIDFluxWeakening = MC_NULL; /* if M1 doesn't has FW */
</#if>
  MCT[M1].pPWMnCurrFdbk = pwmcHandle[M1];
<#if MC.STATE_OBSERVER_PLL == true || MC.STATE_OBSERVER_CORDIC == true>
  MCT[M1].pRevupCtrl = &RevUpControlM1;              /* only if M1 is sensorless*/
<#else>
  MCT[M1].pRevupCtrl = MC_NULL;              /* only if M1 is not sensorless*/
</#if>
  MCT[M1].pSpeedSensorMain = (SpeednPosFdbk_Handle_t *) ${SPD_M1}; 
<#if   AUX_SPEED_FDBK_M1 == true ||  MC.HFINJECTION == true>  
  MCT[M1].pSpeedSensorAux = (SpeednPosFdbk_Handle_t *) ${SPD_AUX_M1}; 
<#else>
  MCT[M1].pSpeedSensorAux = MC_NULL;
</#if>
<#if   MC.STATE_OBSERVER_PLL == true || MC.STATE_OBSERVER_CORDIC == true>
  MCT[M1].pSpeedSensorVirtual = &VirtualSpeedSensorM1;  /* only if M1 is sensorless*/
<#else>
  MCT[M1].pSpeedSensorVirtual = MC_NULL;
</#if>
  MCT[M1].pSpeednTorqueCtrl = pSTC[M1];
  MCT[M1].pStateMachine = &STM[M1];
  MCT[M1].pTemperatureSensor = (NTC_Handle_t *) pTemperatureSensor[M1];
  MCT[M1].pBusVoltageSensor = &(pBusSensorM1->_Super);
  MCT[M1].pBrakeDigitalOutput = MC_NULL;   /* brake is defined, oBrakeM1*/
  MCT[M1].pNTCRelay = MC_NULL;             /* relay is defined, oRelayM1*/
  MCT[M1].pMPM =  (MotorPowMeas_Handle_t*)pMPM[M1];
<#if  MC.FLUX_WEAKENING_ENABLING == true>
  MCT[M1].pFW = pFW[M1];
<#else>
  MCT[M1].pFW = MC_NULL;
</#if>
<#if  MC.FEED_FORWARD_CURRENT_REG_ENABLING == true>
  MCT[M1].pFF = pFF[M1];
<#else>
  MCT[M1].pFF = MC_NULL;
</#if>

<#if  MC.POSITION_CTRL_ENABLING == true>  
  MCT[M1].pPosCtrl = pPosCtrl[M1];
<#else>
  MCT[M1].pPosCtrl = MC_NULL;
</#if>

<#if  MC.HFINJECTION == true>
  MCT[M1].pHFI = pHFI[M1];
</#if>
<#if (MC.MOTOR_PROFILER == true || MC.ONE_TOUCH_TUNING == true)>
  MCT[M1].pSCC = pSCC;
  MCT[M1].pOTT = pOTT;
<#else>
  MCT[M1].pSCC = MC_NULL;
  MCT[M1].pOTT = MC_NULL;
</#if>
  pMCTList[M1] = &MCT[M1];
</#if>
<#if  MC.DUALDRIVE == true>

  /******************************************************/
  /*   Motor 2 features initialization                  */
  /******************************************************/
  
  /**************************************/
  /*    State machine initialization    */
  /**************************************/
  STM_Init(&STM[M2]);
  
  /******************************************************/
  /*   PID component initialization: speed regulation   */
  /******************************************************/  
  PID_HandleInit(&PIDSpeedHandle_M2);
  pPIDSpeed[M2] = &PIDSpeedHandle_M2;
  
  /***********************************************************/
  /*   Main speed  sensor initialization: speed regulation   */
  /***********************************************************/ 
  pSTC[M2] = &SpeednTorqCtrlM2;
  ${SPD_init_M2} (${SPD_M2});
<#if  MC.ENCODER2 == true>
  
  /******************************************************/
  /*   Main encoder alignment component initialization  */
  /******************************************************/  
  EAC_Init(&EncAlignCtrlM2,pSTC[M2],&VirtualSpeedSensorM2,${SPD_M2});
  pEAC[M2] = &EncAlignCtrlM2;  
</#if>  

<#if  MC.POSITION_CTRL_ENABLING2 == true>
  /******************************************************/
  /*   Position Control component initialization        */
  /******************************************************/
  pPIDPosCtrl[M2] = &PID_PosParamsM2;
  PID_HandleInit(pPIDPosCtrl[M2]);
  
  pPosCtrl[M2] = &pPosCtrlM2;
  TC_Init(pPosCtrl[M2], pPIDPosCtrl[M2], &SpeednTorqCtrlM2, ${SPD_M2});
</#if> 

  /******************************************************/
  /*   Speed & torque component initialization          */
  /******************************************************/
  STC_Init(pSTC[M2],pPIDSpeed[M2], ${SPD_M2}._Super);
 <#if AUX_SPEED_FDBK_M2 ||  MC.HFINJECTION2 == true>
 
  /***********************************************************/
  /*   Auxiliary speed sensor component initialization       */
  /***********************************************************/ 
  ${SPD_aux_init_M2} (${SPD_AUX_M2});
 <#if  MC.AUX_ENCODER2 == true>

  /***********************************************************/
  /*   Auxiliary encoder alignment component initialization  */
  /***********************************************************/ 
  EAC_Init(&EncAlignCtrlM2,pSTC[M2],&VirtualSpeedSensorM2,${SPD_AUX_M2});
  pEAC[M2] = &EncAlignCtrlM2;  
 </#if>
 </#if>  
<#if   MC.STATE_OBSERVER_PLL2 == true || MC.STATE_OBSERVER_CORDIC2 == true ||  MC.ENCODER2 == true ||  MC.AUX_ENCODER2 == true > 
  /****************************************************/
  /*   Virtual speed sensor component initialization  */
  /****************************************************/ 
  VSS_Init (&VirtualSpeedSensorM2);                              
</#if>
<#if   MC.STATE_OBSERVER_PLL2 == true || MC.STATE_OBSERVER_CORDIC2 == true>   
  
  /****************************************************/
  /*   Rev-up component initialization                */
  /****************************************************/ 
  RUC_Init(&RevUpControlM2,pSTC[M2],&VirtualSpeedSensorM2, &STO_M2, pwmcHandle[M2]);        /* only if sensorless*/
</#if>

  /********************************************************/
  /*   PID component initialization: current regulation   */
  /********************************************************/
  PID_HandleInit(&PIDIqHandle_M2);
  PID_HandleInit(&PIDIdHandle_M2);
  pPIDIq[M2] = &PIDIqHandle_M2;
  pPIDId[M2] = &PIDIdHandle_M2;
<#if   MC.BUS_VOLTAGE_READING2 == true>
  
  /**********************************************************/
  /*   Bus voltage sensor component initialization          */
  /**********************************************************/
  pBusSensorM2 = &RealBusVoltageSensorParamsM2; /* powerboard configuration: Rdivider or Virtual*/
  RVBS_Init(pBusSensorM2);
<#else>

  /**********************************************************/
  /*   Virtual bus voltage sensor component initialization  */
  /**********************************************************/
  pBusSensorM2 = &VirtualBusVoltageSensorParamsM2; /* powerboard configuration: Rdivider or Virtual*/
  VVBS_Init(pBusSensorM2);
</#if>

  /*************************************************/
  /*   Power measurement component initialization  */
  /*************************************************/    
  pMPM[M2] = &PQD_MotorPowMeasM2;
  pMPM[M2]->pVBS = &(pBusSensorM2->_Super);
  pMPM[M2]->pFOCVars = &FOCVars[M2];
<#if   MC.ON_OVER_VOLTAGE2 == "TURN_ON_R_BRAKE">
  
  pR_Brake[M2] = &R_BrakeParamsM2;
  DOUT_SetOutputState(pR_Brake[M2],INACTIVE);
</#if>

  /*******************************************************/
  /*   Temperature measurement component initialization  */
  /*******************************************************/
  NTC_Init(&TempSensorParamsM2);  
  pTemperatureSensor[M2] = &TempSensorParamsM2;
<#if  MC.FLUX_WEAKENING_ENABLING2 == true>

  /*************************************************/
  /*   Flux weakening component initialization     */
  /*************************************************/
  PID_HandleInit(&PIDFluxWeakeningHandle_M2);
  FW_Init(pFW[M2],pPIDSpeed[M2],&PIDFluxWeakeningHandle_M2);    /* only if M2 has FW */
</#if>
<#if  MC.FEED_FORWARD_CURRENT_REG_ENABLING2 == true>

  /*************************************************/
  /*   Feed forward component initialization       */
  /*************************************************/
  FF_Init(pFF[M2],&(pBusSensorM2->_Super),pPIDId[M2],pPIDIq[M2]);    /* only if M2 has FF */
</#if>
<#if  MC.OPEN_LOOP_FOC2 == true>
  
  OL_Init(&OpenLoop_ParamsM2, &VirtualSpeedSensorM2._Super);     /* only if M2 has open loop */
  pOpenLoop[M2] = &OpenLoop_ParamsM2;
</#if>
<#if  MC.HFINJECTION2 == true>

  /*************************************************/
  /*   HFI sensorless component initialization     */
  /*************************************************/
  HfiFpCtrlM2.pHfiFpSpeedSensor = oSpeedSensor[M2]; /* only if M2 has HFI */
  HfiFpCtrlM2.FOCVars = &FOCVars[M2];                            /* only if M2 has HFI */
  HfiFpCtrlM2.pPIDq = pPIDIq[M2];                                    /* only if M2 has HFI */
  HfiFpCtrlM2.pPIDd = pPIDId[M2];                                    /* only if M2 has HFI */
  HfiFpCtrlM2.pVbusSensor = &(pBusSensorM2->_Super);                          /* only if M1 has HFI */
  HFI_FP_Init(&HfiFpCtrlM2, &HFI_FP_InitStructureM2);                               /* only if M2 has HFI */
  pHFI[M2] = &HfiFpCtrlM2;
</#if>
  pREMNG[M2] = &RampExtMngrHFParamsM2;
  REMNG_Init(pREMNG[M2]);
  FOC_Clear(M2);
  FOCVars[M2].bDriveInput = EXTERNAL;
  FOCVars[M2].Iqdref = STC_GetDefaultIqdref(pSTC[M2]);
  FOCVars[M2].UserIdref = STC_GetDefaultIqdref(pSTC[M2]).d;
  oMCInterface[M2] = &Mci[M2];
<#if MC.POSITION_CTRL_ENABLING == true || MC.POSITION_CTRL_ENABLING2 == true>
<#if  MC.POSITION_CTRL_ENABLING2 == true>  
  MCI_Init(oMCInterface[M2], &STM[M2], pSTC[M2], &FOCVars[M2], pPosCtrl[M2]);
<#else>
  MCI_Init(oMCInterface[M2], &STM[M2], pSTC[M2], &FOCVars[M2], MC_NULL );
</#if>
<#else>
  MCI_Init(oMCInterface[M2], &STM[M2], pSTC[M2], &FOCVars[M2] );
</#if>  
  MCI_ExecSpeedRamp(oMCInterface[M2],
  STC_GetMecSpeedRefUnitDefault(pSTC[M2]),0); /*First command to STC*/
  pMCIList[M2] = oMCInterface[M2];
<#if MC.MC_TUNING_INTERFACE == true>
  MCT[M2].pPIDSpeed = pPIDSpeed[M2];
  MCT[M2].pPIDIq = pPIDIq[M2];
  MCT[M2].pPIDId = pPIDId[M2];
<#if  MC.FLUX_WEAKENING_ENABLING2 == true>
  MCT[M2].pPIDFluxWeakening = &PIDFluxWeakeningHandle_M2; /* only if M2 has FW */
<#else>
  MCT[M2].pPIDFluxWeakening = MC_NULL; /* if M2 doesn't has FW */
</#if>
  MCT[M2].pPWMnCurrFdbk = pwmcHandle[M2];
<#if   MC.STATE_OBSERVER_PLL2 == true || MC.STATE_OBSERVER_CORDIC2 == true>
  MCT[M2].pRevupCtrl = &RevUpControlM2;              /* only if M2 is sensorless*/
<#else>
  MCT[M2].pRevupCtrl = MC_NULL;              /* only if M2 is not sensorless*/
</#if>
  MCT[M2].pSpeedSensorMain = (SpeednPosFdbk_Handle_t *) ${SPD_M2};
<#if   AUX_SPEED_FDBK_M2 == true ||  MC.HFINJECTION2 == true>  
  MCT[M2].pSpeedSensorAux = (SpeednPosFdbk_Handle_t *) ${SPD_AUX_M2};
<#else>
  MCT[M2].pSpeedSensorAux = MC_NULL;
</#if>
<#if   MC.STATE_OBSERVER_PLL2 == true || MC.STATE_OBSERVER_CORDIC2 == true> 
  MCT[M2].pSpeedSensorVirtual = &VirtualSpeedSensorM2;  /* only if M2 is sensorless*/
<#else>
  MCT[M2].pSpeedSensorVirtual = MC_NULL;
</#if>
  MCT[M2].pSpeednTorqueCtrl = pSTC[M2];
  MCT[M2].pStateMachine = &STM[M2];
  MCT[M2].pTemperatureSensor = (NTC_Handle_t *) pTemperatureSensor[M2];
  MCT[M2].pBusVoltageSensor = &(pBusSensorM2->_Super);
  MCT[M2].pBrakeDigitalOutput = MC_NULL;   /* brake is defined, oBrakeM2*/
  MCT[M2].pNTCRelay = MC_NULL;             /* relay is defined, oRelayM2*/
  MCT[M2].pMPM = (MotorPowMeas_Handle_t*)pMPM[M2];
<#if  MC.FLUX_WEAKENING_ENABLING2 == true>
  MCT[M2].pFW = pFW[M2];
<#else>
  MCT[M2].pFW = MC_NULL;
</#if>
<#if  MC.FEED_FORWARD_CURRENT_REG_ENABLING2 == true>
  MCT[M2].pFF = pFF[M2];
<#else>
  MCT[M2].pFF = MC_NULL;
</#if>
<#if  MC.POSITION_CTRL_ENABLING2 == true>  
  MCT[M2].pPosCtrl = pPosCtrl[M2];
<#else>
  MCT[M2].pPosCtrl = MC_NULL;
</#if>
<#if  MC.HFINJECTION2 == true>
  MCT[M2].pHFI = pHFI[M2];
</#if>
  MCT[M2].pSCC = MC_NULL;
  pMCTList[M2] = &MCT[M2];
</#if> <#--  end of MC.MC_TUNING_INTERFACE -->
</#if> <#--  end of dualdrive -->
<#if  MC.INRUSH_CURRLIMIT_ENABLING == true>
  DOUT_SetOutputState(&ICLDOUTParamsM1, INACTIVE);
  ICL_Init(&ICL_M1, &(pBusSensorM1->_Super), &ICLDOUTParamsM1);
  STM_NextState(&STM[M1],ICLWAIT);
</#if>
<#if  MC.INRUSH_CURRLIMIT_ENABLING2 == true>
  DOUT_SetOutputState(&ICLDOUTParamsM2,INACTIVE);
  ICL_Init(&ICL_M2, &(pBusSensorM2->_Super), &ICLDOUTParamsM2);
  STM_NextState(&STM[M2],ICLWAIT);
</#if>

<#if MC.PFC_ENABLED == true>
  /* Initializing the PFC component */
  PFC_Init( & PFC );
</#if> <#-- end of if MC.PFC_ENABLED == true -->

  /* USER CODE BEGIN MCboot 2 */

  /* USER CODE END MCboot 2 */

  bMCBootCompleted = 1;
}

/**
 * @brief Runs all the Tasks of the Motor Control cockpit
 *
 * This function is to be called periodically at least at the Medium Frequency task
 * rate (It is typically called on the Systick interrupt). Exact invokation rate is 
 * the Speed regulator execution rate set in the Motor Contorl Workbench.
 *
 * The following tasks are executed in this order:
 *
 * - Medium Frequency Tasks of each motors
 * - Safety Task
 * - Power Factor Correction Task (if enabled)
 * - User Interface task. 
 */
__weak void MC_RunMotorControlTasks(void)
{
  if ( bMCBootCompleted ) {
    /* ** Medium Frequency Tasks ** */
    MC_Scheduler();
<#if MC.RTOS == "NONE">    

    /* Safety task is run after Medium Frequency task so that  
     * it can overcome actions they initiated if needed. */
    TSK_SafetyTask();
    
</#if>
<#if MC.PFC_ENABLED == true>
    /* ** Power Factor Correction Task ** */ 
    PFC_Scheduler();
</#if>

    /* ** User Interface Task ** */
    UI_Scheduler();
  }
}

/**
 * @brief  Executes the Medium Frequency Task functions for each drive instance. 
 *
 * It is to be clocked at the Systick frequency.
 */
__weak void MC_Scheduler(void)
{
/* USER CODE BEGIN MC_Scheduler 0 */

/* USER CODE END MC_Scheduler 0 */

  if (bMCBootCompleted == 1)
  {    
    if(hMFTaskCounterM1 > 0u)
    {
      hMFTaskCounterM1--;
    }
    else
    {
      TSK_MediumFrequencyTaskM1();
      /* USER CODE BEGIN MC_Scheduler 1 */

      /* USER CODE END MC_Scheduler 1 */
<#if  MC.EXAMPLE_SPEEDMONITOR == true>
      /****************************** USE ONLY FOR SDK 4.0 EXAMPLES *************/
      ARR_TIM5_update(${SPD_M1});

      /**************************************************************************/
</#if>
      hMFTaskCounterM1 = MF_TASK_OCCURENCE_TICKS;
    }
<#if  MC.DUALDRIVE == true>
    if(hMFTaskCounterM2 > 0u)
    {
      hMFTaskCounterM2--;
    }
    else
    {
      TSK_MediumFrequencyTaskM2();
      /* USER CODE BEGIN MC_Scheduler MediumFrequencyTask M2 */

      /* USER CODE END MC_Scheduler MediumFrequencyTask M2 */
      hMFTaskCounterM2 = MF_TASK_OCCURENCE_TICKS2;
    }
</#if>
    if(hBootCapDelayCounterM1 > 0u)
    {
      hBootCapDelayCounterM1--;
    }
    if(hStopPermanencyCounterM1 > 0u)
    {
      hStopPermanencyCounterM1--;
    }
<#if  MC.DUALDRIVE == true>
    if(hBootCapDelayCounterM2 > 0u)
    {
      hBootCapDelayCounterM2--;
    }
    if(hStopPermanencyCounterM2 > 0u)
    {
      hStopPermanencyCounterM2--;
    }
</#if>
  }
  else
  {
  }
  /* USER CODE BEGIN MC_Scheduler 2 */

  /* USER CODE END MC_Scheduler 2 */
}

/**
  * @brief Executes medium frequency periodic Motor Control tasks
  *
  * This function performs some of the control duties on Motor 1 according to the 
  * present state of its state machine. In particular, duties requiring a periodic 
  * execution at a medium frequency rate (such as the speed controller for instance) 
  * are executed here.
  */
__weak void TSK_MediumFrequencyTaskM1(void)
{
  /* USER CODE BEGIN MediumFrequencyTask M1 0 */

  /* USER CODE END MediumFrequencyTask M1 0 */

  State_t StateM1;
  int16_t wAux = 0;

<#if  MC.INRUSH_CURRLIMIT_ENABLING == true>
  ICL_State_t ICLstate = ICL_Exec( &ICL_M1 );
</#if>
<#if MC.HFINJECTION == true >
  bool IsSpeedReliableAux = ${SPD_aux_calcAvrgMecSpeedUnit_M1}( ${SPD_AUX_M1}, &wAux );
<#elseif  AUX_SPEED_FDBK_M1 == true >
  (void) ${SPD_aux_calcAvrgMecSpeedUnit_M1}( ${SPD_AUX_M1}, &wAux );
</#if>
<#if  MC.SPEED_FEEDBACK_CHECK == true || MC.HFINJECTION == true || MC.HALL_SENSORS == true >
  bool IsSpeedReliable = ${SPD_calcAvrgMecSpeedUnit_M1}( ${SPD_M1}, &wAux );
<#else>
  (void) ${SPD_calcAvrgMecSpeedUnit_M1}( ${SPD_M1}, &wAux );
</#if>   
  PQD_CalcElMotorPower( pMPM[M1] );

  StateM1 = STM_GetState( &STM[M1] );

  switch ( StateM1 )
  {
<#if ( MC.INRUSH_CURRLIMIT_ENABLING == true)>
  case ICLWAIT:
    if ( ICLstate == ICL_INACTIVE )
    {
      /* If ICL is Inactive, move to IDLE */
      STM_NextState( &STM[M1], IDLE );
    }
    break;

</#if>
<#if (( MC.ENCODER == true)||( MC.AUX_ENCODER == true))> <#-- only for encoder -->  
  case IDLE:
    if ( EAC_GetRestartState( &EncAlignCtrlM1 ) )
    {
      /* The Encoder Restart State is true: the IDLE state has been entered
       * after Encoder alignment was performed. The motor can now be started. */
      EAC_SetRestartState( &EncAlignCtrlM1,false );

      /* USER CODE BEGIN MediumFrequencyTask M1 Encoder Restart */

      /* USER CODE END MediumFrequencyTask M1 Encoder Restart */

      STM_NextState( &STM[M1], IDLE_START );
    }
    break;

</#if>
  case IDLE_START:
<#if ( MC.STATE_OBSERVER_PLL == true || MC.STATE_OBSERVER_CORDIC == true)>
    RUC_Clear( &RevUpControlM1, MCI_GetImposedMotorDirection( oMCInterface[M1] ) );
</#if>  
<#if (MC.MOTOR_PROFILER == true || MC.ONE_TOUCH_TUNING == true)>
    OTT_Clear( pOTT );

</#if>
<#if (( MC.ENCODER  == true)||( MC.AUX_ENCODER == true))> <#-- only for encoder -->
    if ( EAC_IsAligned( &EncAlignCtrlM1 ) == false )
    {
      /* The encoder is not aligned. It needs to be and the alignment procedure will make 
       * the state machine go back to IDLE. Setting the Restart State to true ensures that
       * the start up procedure will carry on after alignment. */
      EAC_SetRestartState( &EncAlignCtrlM1, true ); 

      STM_NextState( &STM[M1], IDLE_ALIGNMENT );
      break;
    }

</#if>
<#if ( CHARGE_BOOT_CAP_ENABLING == true)>
    ${PWM_TurnOnLowSides}( pwmcHandle[M1] );
    TSK_SetChargeBootCapDelayM1( CHARGE_BOOT_CAP_TICKS );
    STM_NextState( &STM[M1], CHARGE_BOOT_CAP );
<#else>
    PWMC_CurrentReadingCalibr( pwmcHandle[M1], CRC_START );
    STM_NextState( &STM[M1], OFFSET_CALIB );
</#if>
    break;

<#if ( CHARGE_BOOT_CAP_ENABLING == true)>
  case CHARGE_BOOT_CAP:
    if ( TSK_ChargeBootCapDelayHasElapsedM1() )
    {
      PWMC_CurrentReadingCalibr( pwmcHandle[M1], CRC_START );

      /* USER CODE BEGIN MediumFrequencyTask M1 Charge BootCap elapsed */

      /* USER CODE END MediumFrequencyTask M1 Charge BootCap elapsed */

      STM_NextState(&STM[M1],OFFSET_CALIB);
    }
    break;

</#if>
  case OFFSET_CALIB:
    if ( PWMC_CurrentReadingCalibr( pwmcHandle[M1], CRC_EXEC ) )
    {
<#if (MC.MOTOR_PROFILER == true || MC.ONE_TOUCH_TUNING == true)>    
      STM_NextState( &STM[M1], WAIT_STOP_MOTOR );
<#else>
      STM_NextState( &STM[M1], CLEAR );
</#if>      
    }
    break;

<#if (MC.MOTOR_PROFILER == true || MC.ONE_TOUCH_TUNING == true)>    
  case WAIT_STOP_MOTOR:
    {
      if ( SCC_DetectBemf( pSCC ) == 0 )
      {
        PWMC_SwitchOffPWM( pwmcHandle[M1] );
        STM_NextState( &STM[M1], CLEAR );
      }
    }
    break;

</#if>    
  case CLEAR:
<#if ( MC.STATE_OBSERVER_PLL == true || MC.STATE_OBSERVER_CORDIC == true)>
    /* In a sensorless configuration. Initiate the Revup procedure */
    FOCVars[M1].bDriveInput = EXTERNAL;
    STC_SetSpeedSensor( pSTC[M1], &VirtualSpeedSensorM1._Super );
</#if>
<#if ( MC.HFINJECTION == true)>
    STC_SetSpeedSensor( pSTC[M1], (SpeednPosFdbk_Handle_t *) ${SPD_M1}._Super );

</#if>
    ${SPD_clear_M1}( ${SPD_M1} );
   <#if  AUX_SPEED_FDBK_M1 == true ||  MC.HFINJECTION == true>
    ${SPD_aux_clear_M1}( ${SPD_AUX_M1} );
   </#if>

    if ( STM_NextState( &STM[M1], START ) == true )
    {
      FOC_Clear( M1 );

<#if (MC.MOTOR_PROFILER == true)>
      SCC_Start( pSCC );
      /* The generic function needs to be called here as the undelying   
       * implementation changes in time depending on the Profiler's state 
       * machine. Calling the generic function ensures that the correct
       * implementation is invoked. */
      PWMC_SwitchOnPWM(pwmcHandle[M1]);

<#else>
      ${PWM_SwitchOn}( pwmcHandle[M1] );
</#if>
    }
    break;

<#if  MC.ENCODER == true ||  MC.AUX_ENCODER == true > <#-- only for encoder -->
  case IDLE_ALIGNMENT:
<#if ( CHARGE_BOOT_CAP_ENABLING == true)>
    ${PWM_TurnOnLowSides}( pwmcHandle[M1] );
    TSK_SetChargeBootCapDelayM1( CHARGE_BOOT_CAP_TICKS );
    STM_NextState( &STM[M1], ALIGN_CHARGE_BOOT_CAP );
<#else>
    PWMC_CurrentReadingCalibr( pwmcHandle[M1], CRC_START );
    STM_NextState( &STM[M1], ALIGN_OFFSET_CALIB );
</#if>
    break;

<#if ( CHARGE_BOOT_CAP_ENABLING == true)>
  case ALIGN_CHARGE_BOOT_CAP:
    if ( TSK_ChargeBootCapDelayHasElapsedM1() )
    {
      PWMC_CurrentReadingCalibr( pwmcHandle[M1], CRC_START );

      /* USER CODE BEGIN MediumFrequencyTask M1 Align Charge BootCap elapsed */

      /* USER CODE END MediumFrequencyTask M1 Align Charge BootCap elapsed */

      STM_NextState(&STM[M1],ALIGN_OFFSET_CALIB);
    }
    break;

</#if>
  case ALIGN_OFFSET_CALIB:
    if ( PWMC_CurrentReadingCalibr( pwmcHandle[M1], CRC_EXEC ) )
    {
      STM_NextState( &STM[M1], ALIGN_CLEAR );
    }
    break;

  case ALIGN_CLEAR:
    FOCVars[M1].bDriveInput = EXTERNAL;
    STC_SetSpeedSensor( pSTC[M1], &VirtualSpeedSensorM1._Super );
    EAC_StartAlignment( &EncAlignCtrlM1 );

    if ( STM_NextState( &STM[M1], ALIGNMENT ) == true )
    {
      FOC_Clear( M1 );
      ${PWM_SwitchOn}( pwmcHandle[M1] );
    }
    break;

</#if>
  case START:
    {
<#if ( MC.STATE_OBSERVER_PLL == true || MC.STATE_OBSERVER_CORDIC == true)>  <#-- only for sensor-less control -->
      /* Mechanical speed as imposed by the Virtual Speed Sensor during the Rev Up phase. */
      int16_t hForcedMecSpeedUnit;
      qd_t IqdRef;
      bool ObserverConverged = false;

      /* Execute the Rev Up procedure */
      <#if ( MC.OTF_STARTUP == true )>
      if ( ! RUC_OTF_Exec( &RevUpControlM1 ) )
      <#else>  
      if( ! RUC_Exec( &RevUpControlM1 ) )
      </#if>      
      {
        /* The time allowed for the startup sequence has expired */
        <#if ((MC.OPEN_LOOP_FOC == true) || (MC.MOTOR_PROFILER == true))>
        /* However, no error is generated when OPEN LOOP is enabled 
         * since then the system does not try to close the loop... */
        <#else>
        STM_FaultProcessing( &STM[M1], MC_START_UP, 0 );  
        </#if>
      }
      else
      {
        /* Execute the torque open loop current start-up ramp:
         * Compute the Iq reference current as configured in the Rev Up sequence */
        IqdRef.q = STC_CalcTorqueReference( pSTC[M1] );
        IqdRef.d = FOCVars[M1].UserIdref;
        /* Iqd reference current used by the High Frequency Loop to generate the PWM output */
        FOCVars[M1].Iqdref = IqdRef;
      }

      (void) VSS_CalcAvrgMecSpeedUnit( &VirtualSpeedSensorM1, &hForcedMecSpeedUnit );

      <#if ( MC.OPEN_LOOP_FOC == true)>
      /* Open Loop */
      {
        int16_t hOLFinalMecSpeedUnit = MCI_GetLastRampFinalSpeed( oMCInterface[M1] );

        if ( hOLFinalMecSpeedUnit != VSS_GetLastRampFinalSpeed( &VirtualSpeedSensorM1 ) )
        {
          VSS_SetMecAcceleration( &VirtualSpeedSensorM1, hOLFinalMecSpeedUnit, OPEN_LOOP_SPEED_RAMP_DURATION_MS );
        }
        
        OL_Calc( pOpenLoop[M1] );
      }

      </#if>
      <#if (( MC.STATE_OBSERVER_PLL == true))>
      ObserverConverged = STO_PLL_IsObserverConverged( &STO_PLL_M1,hForcedMecSpeedUnit );
      (void) VSS_SetStartTransition( &VirtualSpeedSensorM1, ObserverConverged );
      <#elseif (( MC.STATE_OBSERVER_CORDIC == true))>
      ObserverConverged = STO_CR_IsObserverConverged( &STO_CR_M1,hForcedMecSpeedUnit );
      (void) VSS_SetStartTransition( &VirtualSpeedSensorM1, ObserverConverged );
      </#if>

      if ( ObserverConverged )
      {
        qd_t StatorCurrent = MCM_Park( FOCVars[M1].Ialphabeta, SPD_GetElAngle( ${SPD_M1}._Super ) );

        /* Start switch over ramp. This ramp will transition from the revup to the closed loop FOC. */
        REMNG_Init( pREMNG[M1] );
        REMNG_ExecRamp( pREMNG[M1], FOCVars[M1].Iqdref.q, 0 );
        REMNG_ExecRamp( pREMNG[M1], StatorCurrent.q, TRANSITION_DURATION );
        
        STM_NextState( &STM[M1], SWITCH_OVER );
      }
</#if>    
<#if ((  MC.ENCODER == true)||(  MC.HALL_SENSORS == true))>
   <#if  MC.POSITION_CTRL_ENABLING == true >
        TC_EncAlignmentCommand(pPosCtrl[M1]);
   </#if>
        STM_NextState( &STM[M1], START_RUN ); /* only for sensored*/
</#if> 
<#if ( MC.HFINJECTION == true)>
      /* HFI validation check */
      if ( HFI_FP_Start( pHFI[M1] ) == true )
      {
        STM_NextState( &STM[M1], START_RUN );
      }
</#if>
    }
    break;
    
<#if ( MC.STATE_OBSERVER_PLL == true || MC.STATE_OBSERVER_CORDIC == true)> <#-- only for sensor-less control -->
  case SWITCH_OVER:
    {
      bool LoopClosed;
      int16_t hForcedMecSpeedUnit;
      
      <#if MC.MOTOR_PROFILER == false> <#-- No need to call RUC_Exec() when in MP in this state -->
      <#if (( MC.OTF_STARTUP == true))>
      if ( ! RUC_OTF_Exec( &RevUpControlM1 ) )
      <#else>  
      if( ! RUC_Exec( &RevUpControlM1 ) )
      </#if>      
      {
          <#if ((MC.OPEN_LOOP_FOC == true) || (MC.MOTOR_PROFILER == true))>
          /* No error is generated when OPEN LOOP is enabled. */
          <#else>
          /* The time allowed for the startup sequence has expired */
          STM_FaultProcessing( &STM[M1], MC_START_UP, 0 );  
          </#if>
      } 
      else
      </#if>
      { 
        /* Compute the virtual speed and positions of the rotor. 
           The function returns true if the virtual speed is in the reliability range */
        LoopClosed = VSS_CalcAvrgMecSpeedUnit(&VirtualSpeedSensorM1,&hForcedMecSpeedUnit);
        /* Check if the transition ramp has completed. */ 
        LoopClosed |= VSS_TransitionEnded( &VirtualSpeedSensorM1 );
        
        /* If any of the above conditions is true, the loop is considered closed. 
           The state machine transitions to the START_RUN state. */
        if ( LoopClosed == true ) 
        {
          #if ( PID_SPEED_INTEGRAL_INIT_DIV == 0 )  
          PID_SetIntegralTerm( pPIDSpeed[M1], 0 );
          #else
          PID_SetIntegralTerm( pPIDSpeed[M1],
                               (int32_t) ( FOCVars[M1].Iqdref.q * PID_GetKIDivisor(pPIDSpeed[M1]) /
                               PID_SPEED_INTEGRAL_INIT_DIV ) );
          #endif
          
          STM_NextState( &STM[M1], START_RUN );
        }  
      }
    }

    break;

</#if>
<#if (( MC.ENCODER == true)||( MC.AUX_ENCODER == true))>
  case ALIGNMENT:
    if ( !EAC_Exec( &EncAlignCtrlM1 ) )
    {
      qd_t IqdRef;
      IqdRef.q = 0;
      IqdRef.d = STC_CalcTorqueReference( pSTC[M1] );
      FOCVars[M1].Iqdref = IqdRef;	
    }
    else
    {
      ${PWM_SwitchOff}( pwmcHandle[M1] );
      STC_SetControlMode( pSTC[M1], STC_SPEED_MODE );
      STC_SetSpeedSensor( pSTC[M1], &ENCODER_M1._Super );

      /* USER CODE BEGIN MediumFrequencyTask M1 EndOfEncAlignment */

      /* USER CODE END MediumFrequencyTask M1 EndOfEncAlignment */

      STM_NextState( &STM[M1], ANY_STOP );
    }    
    break;

</#if>
  case START_RUN:
<#if (MC.MOTOR_PROFILER == true || MC.ONE_TOUCH_TUNING == true)>
    OTT_SR(pOTT);
</#if>
<#if ( MC.STATE_OBSERVER_PLL == true || MC.STATE_OBSERVER_CORDIC == true)> /* only for sensor-less control */
    STC_SetSpeedSensor(pSTC[M1], ${SPD_M1}._Super); /*Observer has converged*/
</#if>
<#if ( MC.HFINJECTION == true)>
    if ( !HFI_FP_STMRUN( pHFI[M1] ) )
    {
      STM_FaultProcessing( &STM[M1], MC_SPEED_FDBK, 0 );
    }
    else
</#if>
    {
      /* USER CODE BEGIN MediumFrequencyTask M1 1 */

      /* USER CODE END MediumFrequencyTask M1 1 */      
	  FOC_InitAdditionalMethods(M1);
      FOC_CalcCurrRef( M1 );
      STM_NextState( &STM[M1], RUN );
    }
    STC_ForceSpeedReferenceToCurrentSpeed( pSTC[M1] ); /* Init the reference speed to current speed */
    MCI_ExecBufferedCommands( oMCInterface[M1] ); /* Exec the speed ramp after changing of the speed sensor */
	
    break;

  case RUN:
    /* USER CODE BEGIN MediumFrequencyTask M1 2 */

    /* USER CODE END MediumFrequencyTask M1 2 */

  <#if  MC.POSITION_CTRL_ENABLING == true >
    TC_PositionRegulation(pPosCtrl[M1]);
  </#if>

    MCI_ExecBufferedCommands( oMCInterface[M1] );
    FOC_CalcCurrRef( M1 );
<#if ( MC.HFINJECTION == true)>

    if ( STC_GetSpeedSensor( pSTC[M1]) == &STO_PLL_M1._Super )
    {
      int16_t hObsSpeedUnit = SPD_GetAvrgMecSpeedUnit( &STO_PLL_M1._Super );
      int16_t hHFISpeedDpp = SPD_GetElSpeedDpp( &STO_PLL_M1._Super );
      int32_t wtemp = (int32_t) hHFISpeedDpp * (int32_t) hObsSpeedUnit;
      
      if( !IsSpeedReliable )
      {
        STM_FaultProcessing( &STM[M1], MC_SPEED_FDBK, 0 );
      }

      if ( wtemp < 0 )
      {
        STO_SetPLL( &STO_PLL_M1, hHFISpeedDpp, SPD_GetElAngle( &HfiFpSpeedM1._Super ) );      
      }      
      
      if ( !HFI_FP_SPD_AccelerationStageReached( ${SPD_M1} ) )
      {
        STO_SetPLL( &STO_PLL_M1, SPD_GetElSpeedDpp( ${SPD_M1}._Super ), SPD_GetElAngle( ${SPD_M1}._Super ) );        
      } 
      else
      {
        if ( STO_PLL_IsObserverConverged( &STO_PLL_M1, SPD_GetAvrgMecSpeedUnit(${SPD_M1}._Super ) ) )
        {
          STC_SetSpeedSensor( pSTC[M1], &STO_PLL_M1._Super );
          HFI_FP_DisHFGeneration( pHFI[M1] );           
        }
      }
    }
    else  /* STO - HFI */
    {
      int16_t hObsSpeedUnit = SPD_GetAvrgMecSpeedUnit( &STO_PLL_M1._Super );
      
      if(!IsSpeedReliableAux)
      {
        STM_FaultProcessing(&STM[M1], MC_SPEED_FDBK, 0);
      }

      if (HFI_FP_SPD_Restart(${SPD_M1},hObsSpeedUnit))
      {
        if (HFI_FP_Restart(pHFI[M1]) == true)
        {
          if (HFI_FP_SPD_IsConverged(${SPD_M1},hObsSpeedUnit))
          {
            ${SPD_clear_M1}(${SPD_M1});
            HFI_FP_SPD_SetElAngle(${SPD_M1},SPD_GetElAngle(&STO_PLL_M1._Super));          
            HFI_FP_SPD_SetElSpeedDpp(${SPD_M1},-SPD_GetElSpeedDpp(&STO_PLL_M1._Super));            
            HFI_FP_SPD_SetAvrgMecSpeedUnit(${SPD_M1},-SPD_GetAvrgMecSpeedUnit(&STO_PLL_M1._Super));
            HFI_FP_SPD_SetHFState(${SPD_M1},true);
            HFI_FP_STMRUN(pHFI[M1]);
            STC_SetSpeedSensor(pSTC[M1],${SPD_M1}._Super);
          }
        }
      }
      else
      {
        HFI_FP_DisHFGeneration(pHFI[M1]);
      }
    }

<#else> <#-- #if MC.HFINJECTION == true -->
<#if  MC.SPEED_FEEDBACK_CHECK == true || MC.HALL_SENSORS == true >
    if( !IsSpeedReliable )
    {
      STM_FaultProcessing( &STM[M1], MC_SPEED_FDBK, 0 );
    }

</#if>	
</#if> <#-- else #if MC.HFINJECTION == true -->
    /* USER CODE BEGIN MediumFrequencyTask M1 3 */

    /* USER CODE END MediumFrequencyTask M1 3 */
<#if (MC.MOTOR_PROFILER == true || MC.ONE_TOUCH_TUNING == true)>

    OTT_MF( pOTT );
</#if>
    break;

  case ANY_STOP:
<#if (MC.MOTOR_PROFILER == true)>
    SCC_Stop( pSCC );
    OTT_Stop( pOTT );

</#if>
    ${PWM_SwitchOff}( pwmcHandle[M1] );
    FOC_Clear( M1 );
    MPM_Clear( (MotorPowMeas_Handle_t*) pMPM[M1] );
    TSK_SetStopPermanencyTimeM1( STOPPERMANENCY_TICKS );

    /* USER CODE BEGIN MediumFrequencyTask M1 4 */

    /* USER CODE END MediumFrequencyTask M1 4 */

    STM_NextState( &STM[M1], STOP );
    break;

  case STOP:
    if ( TSK_StopPermanencyTimeHasElapsedM1() )
    {
      STM_NextState( &STM[M1], STOP_IDLE );
    }
    break;

  case STOP_IDLE:
<#if ( MC.STATE_OBSERVER_PLL == true || MC.STATE_OBSERVER_CORDIC == true)>
    STC_SetSpeedSensor( pSTC[M1],&VirtualSpeedSensorM1._Super );  	/*  sensor-less */
    VSS_Clear( &VirtualSpeedSensorM1 ); /* Reset measured speed in IDLE */

</#if>
<#if ( MC.HFINJECTION == true)>
    HFI_FP_DisHFGeneration( pHFI[M1] );

</#if>
    /* USER CODE BEGIN MediumFrequencyTask M1 5 */

    /* USER CODE END MediumFrequencyTask M1 5 */
<#if ( MC.INRUSH_CURRLIMIT_ENABLING == true)>
    STM_NextState( &STM[M1], ICLWAIT );
<#else>
    STM_NextState( &STM[M1], IDLE );
</#if>
    break;

  default:
    break;
  }

<#if (MC.MOTOR_PROFILER == true)>
    SCC_MF( pSCC );

</#if>
  /* USER CODE BEGIN MediumFrequencyTask M1 6 */

  /* USER CODE END MediumFrequencyTask M1 6 */
}

/**
  * @brief  It re-initializes the current and voltage variables. Moreover
  *         it clears qd currents PI controllers, voltage sensor and SpeednTorque
  *         controller. It must be called before each motor restart.
  *         It does not clear speed sensor.
  * @param  bMotor related motor it can be M1 or M2
  * @retval none
  */
__weak void FOC_Clear(uint8_t bMotor)
{
  /* USER CODE BEGIN FOC_Clear 0 */

  /* USER CODE END FOC_Clear 0 */
  ab_t NULL_ab = {(int16_t)0, (int16_t)0};
  qd_t NULL_qd = {(int16_t)0, (int16_t)0};
  alphabeta_t NULL_alphabeta = {(int16_t)0, (int16_t)0};
  
  FOCVars[bMotor].Iab = NULL_ab;
  FOCVars[bMotor].Ialphabeta = NULL_alphabeta;
  FOCVars[bMotor].Iqd = NULL_qd;
  FOCVars[bMotor].Iqdref = NULL_qd;
  FOCVars[bMotor].hTeref = (int16_t)0;
  FOCVars[bMotor].Vqd = NULL_qd;
  FOCVars[bMotor].Valphabeta = NULL_alphabeta;
  FOCVars[bMotor].hElAngle = (int16_t)0;

  PID_SetIntegralTerm(pPIDIq[bMotor], (int32_t)0);
  PID_SetIntegralTerm(pPIDId[bMotor], (int32_t)0);

  STC_Clear(pSTC[bMotor]);

  PWMC_SwitchOffPWM(pwmcHandle[bMotor]);

<#if ( MC.FLUX_WEAKENING_ENABLING == true) || (MC.FLUX_WEAKENING_ENABLING2 == true)>
  if (pFW[bMotor])
  {
    FW_Clear(pFW[bMotor]);
  }
</#if>
<#if ( MC.FEED_FORWARD_CURRENT_REG_ENABLING == true) || ( MC.FEED_FORWARD_CURRENT_REG_ENABLING2 == true)>
  if (pFF[bMotor])
  {
    FF_Clear(pFF[bMotor]);
  }
</#if>
<#if ( MC.HFINJECTION == true) || ( MC.HFINJECTION2 == true)>
  if (pHFI[bMotor])
  {
    HFI_FP_Clear(pHFI[bMotor]);
  }
</#if>
  /* USER CODE BEGIN FOC_Clear 1 */

  /* USER CODE END FOC_Clear 1 */
}

/**
  * @brief  Use this method to initialize additional methods (if any) in
  *         START_TO_RUN state
  * @param  bMotor related motor it can be M1 or M2
  * @retval none
  */
__weak void FOC_InitAdditionalMethods(uint8_t bMotor)
{
<#if ( MC.FEED_FORWARD_CURRENT_REG_ENABLING == true) || ( MC.FEED_FORWARD_CURRENT_REG_ENABLING2 == true)>
    if (pFF[bMotor])
    {
      FF_InitFOCAdditionalMethods(pFF[bMotor]);
    }
</#if>
  /* USER CODE BEGIN FOC_InitAdditionalMethods 0 */

  /* USER CODE END FOC_InitAdditionalMethods 0 */
}

/**
  * @brief  It computes the new values of Iqdref (current references on qd
  *         reference frame) based on the required electrical torque information
  *         provided by oTSC object (internally clocked).
  *         If implemented in the derived class it executes flux weakening and/or
  *         MTPA algorithm(s). It must be called with the periodicity specified
  *         in oTSC parameters
  * @param  bMotor related motor it can be M1 or M2
  * @retval none
  */
__weak void FOC_CalcCurrRef(uint8_t bMotor)
{
<#if (( MC.MTPA_ENABLING == false) &&  (MC.FLUX_WEAKENING_ENABLING == true)) || 
     (( MC.MTPA_ENABLING2 == false) &&  (MC.FLUX_WEAKENING_ENABLING2 == true)) >
  qd_t IqdTmp;
</#if>
    
  /* USER CODE BEGIN FOC_CalcCurrRef 0 */

  /* USER CODE END FOC_CalcCurrRef 0 */
  if(FOCVars[bMotor].bDriveInput == INTERNAL)
  {
    FOCVars[bMotor].hTeref = STC_CalcTorqueReference(pSTC[bMotor]);
    FOCVars[bMotor].Iqdref.q = FOCVars[bMotor].hTeref;
<#if ( MC.MTPA_ENABLING == true) ||  (MC.MTPA_ENABLING2 == true)>
    if (pMaxTorquePerAmpere[bMotor])
    {
      MTPA_CalcCurrRefFromIq(pMaxTorquePerAmpere[bMotor], &FOCVars[bMotor].Iqdref);
    }
</#if>

<#if ( MC.FLUX_WEAKENING_ENABLING == true) || ( MC.FLUX_WEAKENING_ENABLING2 == true)>
    if (pFW[bMotor])
    {
<#if MC.DUALDRIVE == false >
<#if ( MC.MTPA_ENABLING == true)>
      FOCVars[bMotor].Iqdref = FW_CalcCurrRef(pFW[bMotor],FOCVars[bMotor].Iqdref);
<#else>
      IqdTmp.q = FOCVars[bMotor].Iqdref.q;
      IqdTmp.d = FOCVars[bMotor].UserIdref; 
      FOCVars[bMotor].Iqdref = FW_CalcCurrRef(pFW[bMotor],IqdTmp);
</#if>
<#else>
<#if ( MC.MTPA_ENABLING == true) &&  (MC.MTPA_ENABLING2 == true)>
      FOCVars[bMotor].Iqdref = FW_CalcCurrRef(pFW[bMotor],FOCVars[bMotor].Iqdref);        
<#elseif ( MC.MTPA_ENABLING == false) &&  (MC.MTPA_ENABLING2 == false)>
      IqdTmp.q = FOCVars[bMotor].Iqdref.q;
      IqdTmp.d = FOCVars[bMotor].UserIdref; 
      FOCVars[bMotor].Iqdref = FW_CalcCurrRef(pFW[bMotor],IqdTmp); 
<#else>
      if (pMaxTorquePerAmpere[bMotor])
      {
        FOCVars[bMotor].Iqdref = FW_CalcCurrRef(pFW[bMotor],FOCVars[bMotor].Iqdref);
      }
      else
      {
        IqdTmp.q = FOCVars[bMotor].Iqdref.q;
        IqdTmp.d = FOCVars[bMotor].UserIdref; 
        FOCVars[bMotor].Iqdref = FW_CalcCurrRef(pFW[bMotor],IqdTmp);
      }     
</#if>     
</#if>       
    }
</#if>
<#if ( MC.FEED_FORWARD_CURRENT_REG_ENABLING == true) || ( MC.FEED_FORWARD_CURRENT_REG_ENABLING2 == true)>
    if (pFF[bMotor])
    {
      FF_VqdffComputation(pFF[bMotor], FOCVars[bMotor].Iqdref, pSTC[bMotor]);
    }
</#if>
  }
  /* USER CODE BEGIN FOC_CalcCurrRef 1 */

  /* USER CODE END FOC_CalcCurrRef 1 */
}

/**
  * @brief  It set a counter intended to be used for counting the delay required
  *         for drivers boot capacitors charging of motor 1
  * @param  hTickCount number of ticks to be counted
  * @retval void
  */
__weak void TSK_SetChargeBootCapDelayM1(uint16_t hTickCount)
{
   hBootCapDelayCounterM1 = hTickCount;
}

/**
  * @brief  Use this function to know whether the time required to charge boot
  *         capacitors of motor 1 has elapsed
  * @param  none
  * @retval bool true if time has elapsed, false otherwise
  */
__weak bool TSK_ChargeBootCapDelayHasElapsedM1(void)
{
  bool retVal = false;
  if (hBootCapDelayCounterM1 == 0)
  {
    retVal = true;
  }
  return (retVal);
}

/**
  * @brief  It set a counter intended to be used for counting the permanency
  *         time in STOP state of motor 1
  * @param  hTickCount number of ticks to be counted
  * @retval void
  */
__weak void TSK_SetStopPermanencyTimeM1(uint16_t hTickCount)
{
  hStopPermanencyCounterM1 = hTickCount;
}

/**
  * @brief  Use this function to know whether the permanency time in STOP state
  *         of motor 1 has elapsed
  * @param  none
  * @retval bool true if time is elapsed, false otherwise
  */
__weak bool TSK_StopPermanencyTimeHasElapsedM1(void)
{
  bool retVal = false;
  if (hStopPermanencyCounterM1 == 0)
  {
    retVal = true;
  }
  return (retVal);
}

<#if  MC.DUALDRIVE == true>
#if defined (CCMRAM_ENABLED)
#if defined (__ICCARM__)
#pragma location = ".ccmram"
#elif defined (__CC_ARM)
__attribute__((section (".ccmram")))
#endif
#endif
/**
  * @brief Executes medium frequency periodic Motor Control tasks
  *
  * This function performs some of the control duties on Motor 2 according to the 
  * present state of its state machine. In particular, duties requiring a periodic 
  * execution at a medium frequency rate (such as the speed controller for instance) 
  * are executed here.
  */
__weak void TSK_MediumFrequencyTaskM2(void)
{
  /* USER CODE BEGIN MediumFrequencyTask M2 0 */

  /* USER CODE END MediumFrequencyTask M2 0 */
  State_t StateM2;
  int16_t wAux = 0;

<#if MC.INRUSH_CURRLIMIT_ENABLING2 == true >
  ICLState_t ICLState = ICL_Exec( &ICL_M2 );
</#if>

<#if MC.HFINJECTION2 == true >
  bool IsSpeedReliableAux = ${SPD_aux_calcAvrgMecSpeedUnit_M2}( ${SPD_AUX_M2}, &wAux );
<#elseif  AUX_SPEED_FDBK_M2 == true >
  (void) ${SPD_aux_calcAvrgMecSpeedUnit_M2}( ${SPD_AUX_M2}, &wAux );
</#if>
<#if  MC.SPEED_FEEDBACK_CHECK2 == true || MC.HFINJECTION2 == true || MC.HALL_SENSORS2 == true>
  bool IsSpeedReliable = ${SPD_calcAvrgMecSpeedUnit_M2}( ${SPD_M2} ,&wAux );
<#else>
  (void) ${SPD_calcAvrgMecSpeedUnit_M2}( ${SPD_M2}, &wAux );
</#if>   
  PQD_CalcElMotorPower( pMPM[M2] );

  StateM2 = STM_GetState( &STM[M2] );

  switch ( StateM2 )
  {
<#if ( MC.INRUSH_CURRLIMIT_ENABLING2 == true)>
  case ICLWAIT:
    if ( ICLState == ICL_INACTIVE )
    {
      /* If ICL Inactive move to IDLE */
      STM_NextState( &STM[M2], IDLE );
    }
    break;
</#if>
<#if (( MC.ENCODER2 == true)||( MC.AUX_ENCODER2 == true))> <#-- only for encoder -->
  case IDLE:
    if ( EAC_GetRestartState( &EncAlignCtrlM2 ) )
    {
      /* The Encoder Restart State is true: the IDLE state has been entered
       * after Encoder alignment was performed. The motor can now be started. */
      EAC_SetRestartState( &EncAlignCtrlM2,false );

      /* USER CODE BEGIN MediumFrequencyTask M2 Encoder Restart */

      /* USER CODE END MediumFrequencyTask M2 Encoder Restart */

      STM_NextState( &STM[M2], IDLE_START );
    }
    break;

</#if>
  case IDLE_START:
<#if ( MC.STATE_OBSERVER_PLL2 == true || MC.STATE_OBSERVER_CORDIC2 == true)>
    RUC_Clear( &RevUpControlM2, MCI_GetImposedMotorDirection( oMCInterface[M2] ) );
</#if>  
<#if (( MC.ENCODER2  == true)||( MC.AUX_ENCODER2 == true))> /*  only for encoder*/
    if ( EAC_IsAligned ( &EncAlignCtrlM2 ) == false )
    {
      /* The encoder is not aligned. It needs to be and the alignment procedure will make 
       * the state machine go back to IDLE. Setting the Restart State to true ensures that
       * the start up procedure will carry on after alignment. */
      EAC_SetRestartState( &EncAlignCtrlM2, true ); 

      STM_NextState( &STM[M2], IDLE_ALIGNMENT );
      break;
    }

</#if>  
<#if ( CHARGE_BOOT_CAP_ENABLING2 == true)>
    ${PWM_TurnOnLowSides_M2}( pwmcHandle[M2] );
    TSK_SetChargeBootCapDelayM2( CHARGE_BOOT_CAP_TICKS2 );
    STM_NextState( &STM[M2], CHARGE_BOOT_CAP );
<#else>
    PWMC_CurrentReadingCalibr( pwmcHandle[M2], CRC_START );
    STM_NextState( &STM[M2], OFFSET_CALIB );
</#if>
    break;

<#if ( CHARGE_BOOT_CAP_ENABLING2 == true)>
  case CHARGE_BOOT_CAP:
    if ( TSK_ChargeBootCapDelayHasElapsedM2() )
    {
      PWMC_CurrentReadingCalibr( pwmcHandle[M2], CRC_START );

      /* USER CODE BEGIN MediumFrequencyTask M2 Charge BootCap elapsed */

      /* USER CODE END MediumFrequencyTask M2 Charge BootCap elapsed */

      STM_NextState( &STM[M2], OFFSET_CALIB );
    }
    break;

</#if>
  case OFFSET_CALIB:
    if ( PWMC_CurrentReadingCalibr( pwmcHandle[M2], CRC_EXEC ) )
    {
      STM_NextState( &STM[M2], CLEAR );
    }
    break;

  case CLEAR:
<#if ( MC.STATE_OBSERVER_PLL2 == true || MC.STATE_OBSERVER_CORDIC2 == true)>
    /* In a sensorless configuration. Initiate the Revup procedure */
    FOCVars[M2].bDriveInput = EXTERNAL;
    STC_SetSpeedSensor( pSTC[M2], &VirtualSpeedSensorM2._Super );
</#if>
<#if ( MC.HFINJECTION2 == true)>
    STC_SetSpeedSensor( pSTC[M2], ${SPD_M2} );

</#if>
    ${SPD_clear_M2}( ${SPD_M2} );
<#if AUX_SPEED_FDBK_M2 == true>
    ${SPD_aux_clear_M2}( ${SPD_AUX_M2} );
</#if>

    if ( STM_NextState( &STM[M2], START ) == true )
    {
      FOC_Clear(M2);
      ${PWM_SwitchOn_M2}( pwmcHandle[M2] );
    }
    break;

<#if (( MC.ENCODER2 == true)||( MC.AUX_ENCODER2 == true))> /*  only for encoder*/
  case IDLE_ALIGNMENT:
<#if ( CHARGE_BOOT_CAP_ENABLING2 == true)>
    ${PWM_TurnOnLowSides_M2}( pwmcHandle[M2] );
    TSK_SetChargeBootCapDelayM2( CHARGE_BOOT_CAP_TICKS2 );
    STM_NextState( &STM[M2], ALIGN_CHARGE_BOOT_CAP );
<#else>
    PWMC_CurrentReadingCalibr( pwmcHandle[M2], CRC_START );
    STM_NextState( &STM[M2], ALIGN_OFFSET_CALIB );
</#if>
    break;

<#if ( CHARGE_BOOT_CAP_ENABLING2 == true)>
  case ALIGN_CHARGE_BOOT_CAP:
    if ( TSK_ChargeBootCapDelayHasElapsedM2() )
    {
      PWMC_CurrentReadingCalibr( pwmcHandle[M2], CRC_START );

      /* USER CODE BEGIN MediumFrequencyTask M2 Align Charge BootCap elapsed */

      /* USER CODE END MediumFrequencyTask M2 Align Charge BootCap elapsed */

      STM_NextState( &STM[M2], ALIGN_OFFSET_CALIB );
    }
    break;

</#if>
  case ALIGN_OFFSET_CALIB:
    if ( PWMC_CurrentReadingCalibr( pwmcHandle[M2], CRC_EXEC ) )
    {
      STM_NextState( &STM[M2], ALIGN_CLEAR );
    }
    break;

  case ALIGN_CLEAR:
    FOCVars[M2].bDriveInput = EXTERNAL;
    STC_SetSpeedSensor( pSTC[M2], &VirtualSpeedSensorM2._Super );
    EAC_StartAlignment( &EncAlignCtrlM2 );

    if ( STM_NextState( &STM[M2], ALIGNMENT ) == true )
    {
      FOC_Clear( M2 );
      ${PWM_SwitchOn_M2}( pwmcHandle[M2] );
    }
    break;

</#if>
  case START:
    {
<#if (  MC.STATE_OBSERVER_PLL2 == true || MC.STATE_OBSERVER_CORDIC2 == true)>  <#-- only for sensor-less control -->
      int16_t hForcedMecSpeedUnit;
      qd_t IqdRef;
      bool ObserverConverged = false;

<#if (( MC.OTF_STARTUP2 == true))>  
      if ( ! RUC_OTF_Exec( &RevUpControlM2 ) )
<#else>
      if ( ! RUC_Exec( &RevUpControlM2 ) )
</#if>
      {
        <#if ( MC.OPEN_LOOP_FOC2 == true)>
          /* No error generated when OPEN LOOP is enabled. */
        <#else>
          /* The time allowed for the startup sequence has expired */
          STM_FaultProcessing( &STM[M2], MC_START_UP, 0 );
        </#if>
      }
      else
      {
        /* Execute the torque open loop current start-up ramp:
         * Compute the Iq reference current as configured in the Rev Up sequence */
        IqdRef.q = STC_CalcTorqueReference(pSTC[M2]);
        IqdRef.d = FOCVars[M2].UserIdref;
        /* Iqd reference current used by the High Frequency Loop to generate the PWM output */
        FOCVars[M2].Iqdref = IqdRef;
      }
      
      /* Compute the "average" mechanical speed of the magnetic flux induced in the stator */
      (void) VSS_CalcAvrgMecSpeedUnit(&VirtualSpeedSensorM2,&hForcedMecSpeedUnit);
      <#if ( MC.OPEN_LOOP_FOC2 == true)>
      {
        int16_t hOLFinalMecSpeedUnit = MCI_GetLastRampFinalSpeed( oMCInterface[M2] );

        if ( hOLFinalMecSpeedUnit != VSPD_GetLastRampFinalSpeed( &VirtualSpeedSensorM2 ) )
        {
          VSS_SetMecAcceleration( & VirtualSpeedSensorM2, hOLFinalMecSpeedUnit, OPEN_LOOP_SPEED_RAMP_DURATION_MS2 );
        }
        
        OL_Calc( pOpenLoop[M2] );
      }

      </#if>
<#if (( MC.STATE_OBSERVER_PLL2 == true))>

      ObserverConverged = STO_PLL_IsObserverConverged( &STO_PLL_M2, hForcedMecSpeedUnit );
      (void) VSS_SetStartTransition( &VirtualSpeedSensorM2, ObserverConverged );
<#elseif (( MC.STATE_OBSERVER_CORDIC2 == true))>

      ObserverConverged = STO_CR_IsObserverConverged( &STO_CR_M2,hForcedMecSpeedUnit );
      (void) VSS_SetStartTransition( &VirtualSpeedSensorM2, ObserverConverged );
</#if>
	  
      if ( ObserverConverged )
      {
        qd_t StatorCurrent = MCM_Park( FOCVars[M2].Ialphabeta, SPD_GetElAngle( ${SPD_M2}._Super ) );

        /* Start switch over ramp. This ramp will transition from the revup to the closed loop FOC. */
        REMNG_Init( pREMNG[M2] );
        REMNG_ExecRamp( pREMNG[M2], FOCVars[M2].Iqdref.q, 0 );
        REMNG_ExecRamp( pREMNG[M2], StatorCurrent.q, TRANSITION_DURATION2 );
        
        STM_NextState( &STM[M2], SWITCH_OVER );
      }
</#if>
<#if (( MC.ENCODER2 == true)||( MC.HALL_SENSORS2 == true))>
   <#if  MC.POSITION_CTRL_ENABLING2 == true >
      TC_EncAlignmentCommand(pPosCtrl[M2]);
   </#if>
      STM_NextState( &STM[M2], START_RUN ); 
</#if>
<#if ( MC.HFINJECTION2 == true)>

      /* HFI validation check */
      if ( HFI_FP_Start( pHFI[M2] ) == true )
      {
        STM_NextState( &STM[M2], START_RUN );
      }
</#if>
    }
    break;

<#if ( MC.STATE_OBSERVER_PLL2 == true || MC.STATE_OBSERVER_CORDIC2 == true)>
  case SWITCH_OVER:
    {
      bool LoopClosed;
      int16_t hForcedMecSpeedUnit;
      
      <#if (( MC.OTF_STARTUP2 == true))>
      if ( ! RUC_OTF_Exec( &RevUpControlM2 ) )
      <#else>  
      if( ! RUC_Exec( &RevUpControlM2 ) )
      </#if>      
      {
          <#if ( MC.OPEN_LOOP_FOC2 == true )>
          /* No error is generated when OPEN LOOP is enabled. */
          <#else>
          /* The time allowed for the startup sequence has expired */
          STM_FaultProcessing( &STM[M2], MC_START_UP, 0 );  
          </#if>
      } 
      else
      { 
        /* Compute the virtual speed and positions of the rotor. 
           The function returns true if the virtual speed is in the reliability range */
        LoopClosed = VSS_CalcAvrgMecSpeedUnit( &VirtualSpeedSensorM2, &hForcedMecSpeedUnit );
        /* Check if the transition ramp has completed. */ 
        LoopClosed |= VSS_TransitionEnded( &VirtualSpeedSensorM2 );
        
        /* If any of the above conditions is true, the loop is considered closed. 
           The state machine transitions to the START_RUN state. */
        if ( LoopClosed == true ) 
        {
          #if ( PID_SPEED_INTEGRAL_INIT_DIV == 0 )  
          PID_SetIntegralTerm( pPIDSpeed[M2], 0 );
          #else
          PID_SetIntegralTerm( pPIDSpeed[M2],
                               (int32_t) ( FOCVars[M2].Iqdref.q * PID_GetKIDivisor(pPIDSpeed[M2]) /
                               PID_SPEED_INTEGRAL_INIT_DIV ) );
          #endif
          
          STM_NextState( &STM[M2], START_RUN );
        }  
      }
    }

    break;  

</#if>
<#if (( MC.ENCODER2 == true)||( MC.AUX_ENCODER2 == true))> /*  only for encoder*/
  case ALIGNMENT:
    if ( !EAC_Exec( &EncAlignCtrlM2 ) )
    {
      qd_t IqdRef;
      IqdRef.q = 0;
      IqdRef.d = STC_CalcTorqueReference( pSTC[M2] );
      FOCVars[M2].Iqdref = IqdRef;
    }
    else
    {
      ${PWM_SwitchOff_M2}( pwmcHandle[M2] );
      STC_SetControlMode( pSTC[M2], STC_SPEED_MODE );
      STC_SetSpeedSensor( pSTC[M2], &ENCODER_M2._Super );

      /* USER CODE BEGIN MediumFrequencyTask M2 EndOfEncAlignment */

      /* USER CODE END MediumFrequencyTask M2 EndOfEncAlignment */

      STM_NextState( &STM[M2], ANY_STOP );
    }    
    break;

</#if>    
  case START_RUN:
<#if ( MC.STATE_OBSERVER_PLL2 == true || MC.STATE_OBSERVER_CORDIC2 == true)> /* only for sensor-less control */
    STC_SetSpeedSensor(pSTC[M2],${SPD_M2}._Super);  /*Observer has converged*/
</#if>
<#if ( MC.HFINJECTION2 == true)>
    if ( !HFI_FP_STMRUN( pHFI[M2] ) )
    {
      STM_FaultProcessing( &STM[M2], MC_SPEED_FDBK, 0 );
    }
    else
</#if>
    {
      /* USER CODE BEGIN MediumFrequencyTask M2 1 */

      /* USER CODE END MediumFrequencyTask M2 1 */ 

      FOC_InitAdditionalMethods( M2 );
      FOC_CalcCurrRef( M2 );

      STM_NextState(&STM[M2], RUN);
    }
    STC_ForceSpeedReferenceToCurrentSpeed(pSTC[M2]); /* Init the reference speed to current speed */
    MCI_ExecBufferedCommands(oMCInterface[M2]); /* Exec the speed ramp after changing of the speed sensor */
    break;

  case RUN:
    /* USER CODE BEGIN MediumFrequencyTask M2 2 */

    /* USER CODE END MediumFrequencyTask M2 2 */

  <#if  MC.POSITION_CTRL_ENABLING2 == true >
    TC_PositionRegulation(pPosCtrl[M2]);
  </#if>

    MCI_ExecBufferedCommands( oMCInterface[M2] );
    FOC_CalcCurrRef( M2 );
<#if ( MC.HFINJECTION2 == true)>

    if (STC_GetSpeedSensor(pSTC[M2]) == &STO_PLL_M2._Super)
    {
      int16_t hObsSpeedUnit = SPD_GetAvrgMecSpeedUnit(&STO_PLL_M2._Super);
      int16_t hHFISpeedDpp = SPD_GetElSpeedDpp(&STO_PLL_M2._Super);
      int32_t wtemp = (int32_t)hHFISpeedDpp * (int32_t)hObsSpeedUnit;
      if(!IsSpeedReliable)
      {
        STM_FaultProcessing(&STM[M2], MC_SPEED_FDBK, 0);
      }
      if (wtemp < 0)
      {
        STO_SetPLL(&STO_PLL_M2, hHFISpeedDpp,
        SPD_GetElAngle(${SPD_M2}));      
      }      
      if (!HFI_FP_SPD_AccelerationStageReached(${SPD_M2}))
      {
        STO_SetPLL(&STO_PLL_M2, SPD_GetElSpeedDpp(${SPD_M2}._Super),
                   SPD_GetElAngle(${SPD_M2}._Super));        
      } 
      else
      {
        if (STO_PLL_IsObserverConverged(&STO_PLL_M2,SPD_GetAvrgMecSpeedUnit(${SPD_M2})))
        {
          STC_SetSpeedSensor(pSTC[M2], &STO_PLL_M2);
          HFI_FP_DisHFGeneration(pHFI[M2]);           
        }
      }
    }
    else  /* STO - HFI */
    {
      int16_t hObsSpeedUnit = SPD_GetAvrgMecSpeedUnit(&STO_PLL_M2._Super);
      if(!IsSpeedReliableAux)
      {
        STM_FaultProcessing(&STM[M2], MC_SPEED_FDBK, 0);
      }
      if (HFI_FP_SPD_Restart(${SPD_M2},hObsSpeedUnit))
      {
        if (HFI_FP_Restart(pHFI[M2]) == true)
        {
          if (HFI_FP_SPD_IsConverged(${SPD_M2},hObsSpeedUnit))
          {
            SPD_Clear(${SPD_M2});
            HFI_FP_SPD_SetElAngle(${SPD_M2},SPD_GetElAngle(&STO_PLL_M2._Super));
            HFI_FP_SPD_SetElSpeedDpp(${SPD_M2},-SPD_GetElSpeedDpp(&STO_PLL_M2._Super));
            HFI_FP_SPD_SetAvrgMecSpeedUnit(${SPD_M2},-SPD_GetAvrgMecSpeedUnit(&STO_PLL_M2._Super));
            HFI_FP_SPD_SetHFState(${SPD_M2},true);
            HFI_FP_STMRUN(pHFI[M2]);
            STC_SetSpeedSensor(pSTC[M2],${SPD_M2});
          }
        }
      }
      else
      {
        HFI_FP_DisHFGeneration(pHFI[M2]);
      }
    }

<#else> <#-- #if MC.HFINJECTION == true -->
<#if MC.SPEED_FEEDBACK_CHECK2 == true || MC.HALL_SENSORS2 == true >
    if ( !IsSpeedReliable )
    {
      STM_FaultProcessing( &STM[M2], MC_SPEED_FDBK, 0 );
    }

</#if>
</#if> <#-- #if MC.HFINJECTION == true -->
    /* USER CODE BEGIN MediumFrequencyTask M2 3 */

    /* USER CODE END MediumFrequencyTask M2 3 */
    break;

  case ANY_STOP:
    ${PWM_SwitchOff_M2}( pwmcHandle[M2] );
    FOC_Clear( M2 );
    MPM_Clear( (MotorPowMeas_Handle_t*) pMPM[M2] );
    TSK_SetStopPermanencyTimeM2( STOPPERMANENCY_TICKS2 );

    /* USER CODE BEGIN MediumFrequencyTask M2 4 */

    /* USER CODE END MediumFrequencyTask M2 4 */

    STM_NextState(&STM[M2], STOP);
    break;

  case STOP:
    if ( TSK_StopPermanencyTimeHasElapsedM2() )
    {
      STM_NextState( &STM[M2], STOP_IDLE );
    }
    break;

  case STOP_IDLE:
<#if ( MC.STATE_OBSERVER_PLL2 == true || MC.STATE_OBSERVER_CORDIC2 == true)>
    STC_SetSpeedSensor( pSTC[M2], &VirtualSpeedSensorM2._Super ); 
    VSS_Clear ( &VirtualSpeedSensorM2 ); /* Reset measured speed in IDLE */
</#if>
<#if ( MC.HFINJECTION2 == true)>
    HFI_FP_DisHFGeneration(pHFI[M2]);
</#if>
    /* USER CODE BEGIN MediumFrequencyTask M2 5 */

    /* USER CODE END MediumFrequencyTask M2 5 */
<#if ( MC.INRUSH_CURRLIMIT_ENABLING2 == true)>
    STM_NextState ( &STM[M2], ICLWAIT );
<#else>
    STM_NextState( &STM[M2], IDLE );
</#if>
    break;

  default:
    break;
  }

  /* USER CODE BEGIN MediumFrequencyTask M2 6 */

  /* USER CODE END MediumFrequencyTask M2 6 */  
}

/**
  * @brief  It set a counter intended to be used for counting the delay required
  *         for drivers boot capacitors charging of motor 2
  * @param  hTickCount number of ticks to be counted
  * @retval void
  */
__weak void TSK_SetChargeBootCapDelayM2(uint16_t hTickCount)
{
   hBootCapDelayCounterM2 = hTickCount;
}

/**
  * @brief  Use this function to know whether the time required to charge boot
  *         capacitors of motor 2 has elapsed
  * @param  none
  * @retval bool true if time has elapsed, false otherwise
  */
__weak bool TSK_ChargeBootCapDelayHasElapsedM2(void)
{
  bool retVal = false;
  if (hBootCapDelayCounterM2 == 0)
  {
    retVal = true;
  }
  return (retVal);
}

/**
  * @brief  It set a counter intended to be used for counting the permanency
  *         time in STOP state of motor 2
  * @param  hTickCount number of ticks to be counted
  * @retval void
  */
__weak void TSK_SetStopPermanencyTimeM2(uint16_t hTickCount)
{
  hStopPermanencyCounterM2 = hTickCount;
}

/**
  * @brief  Use this function to know whether the permanency time in STOP state
  *         of motor 2 has elapsed
  * @param  none
  * @retval bool true if time is elapsed, false otherwise
  */
__weak bool TSK_StopPermanencyTimeHasElapsedM2(void)
{
  bool retVal = false;
  if (hStopPermanencyCounterM2 == 0)
  {
    retVal = true;
  }
  return (retVal);
}
</#if> <#-- if  MC.DUALDRIVE == true -->

<#if MC.MOTOR_PROFILER == false>
#if defined (CCMRAM_ENABLED)
#if defined (__ICCARM__)
#pragma location = ".ccmram"
#elif defined (__CC_ARM)
__attribute__((section (".ccmram")))
#endif
#endif
/**
  * @brief  Executes the Motor Control duties that require a high frequency rate and a precise timing
  *
  *  This is mainly the FOC current control loop. It is executed depending on the state of the Motor Control 
  * subsystem (see the state machine(s)).
  *
  * @retval Number of the  motor instance which FOC loop was executed.
  */
__weak uint8_t TSK_HighFrequencyTask(void)
{
  /* USER CODE BEGIN HighFrequencyTask 0 */

  /* USER CODE END HighFrequencyTask 0 */
  
  uint8_t bMotorNbr = 0;
  uint16_t hFOCreturn;
 
<#if MC.TESTENV == true && MC.PFC_ENABLED == false >
  /* Performance Measurement: start measure */
  LL_GPIO_SetOutputPin( ${PM_Port}, LL_GPIO_PIN_${PM_Pin} );
</#if>

<#if  MC.SINGLEDRIVE == true>
<#if  MC.STATE_OBSERVER_PLL == true || MC.STATE_OBSERVER_CORDIC == true>
  uint16_t hState;  /*  only if sensorless main*/
  Observer_Inputs_t STO_Inputs; /*  only if sensorless main*/
</#if>
<#if  MC.AUX_STATE_OBSERVER_PLL == true ||  MC.AUX_STATE_OBSERVER_CORDIC == true >
  Observer_Inputs_t STO_aux_Inputs; /*  only if sensorless aux*/
  STO_aux_Inputs.Valfa_beta = FOCVars[M1].Valphabeta;  /* only if sensorless*/
</#if>

<#if (( MC.ENCODER == true) ||( MC.AUX_ENCODER == true))>
  ENC_CalcAngle(&ENCODER_M1);   /* if not sensorless then 2nd parameter is MC_NULL*/
<#elseif ( MC.HFINJECTION == true)>
  HFI_FP_SPD_CalcElAngle(${SPD_M1});
</#if>
<#if  ( MC.HALL_SENSORS == true) ||  MC.AUX_HALL_SENSORS == true>
  HALL_CalcElAngle (&HALL_M1); 
</#if>


<#if ( MC.STATE_OBSERVER_PLL == true || MC.STATE_OBSERVER_CORDIC == true)>
  STO_Inputs.Valfa_beta = FOCVars[M1].Valphabeta;  /* only if sensorless*/
  if ( STM[M1].bState == SWITCH_OVER )
  {
    if (!REMNG_RampCompleted(pREMNG[M1]))
    {
      FOCVars[M1].Iqdref.q = REMNG_Calc(pREMNG[M1]);
    }
  }
</#if>
<#if (( MC.OTF_STARTUP == true))>
  if(!RUC_Get_SCLowsideOTF_Status(&RevUpControlM1))
  {
    hFOCreturn = FOC_CurrControllerM1();
  }
  else
  {
    hFOCreturn = MC_NO_ERROR;
  }
<#else>
  /* USER CODE BEGIN HighFrequencyTask SINGLEDRIVE_1 */

  /* USER CODE END HighFrequencyTask SINGLEDRIVE_1 */
  hFOCreturn = FOC_CurrControllerM1();
  /* USER CODE BEGIN HighFrequencyTask SINGLEDRIVE_2 */

  /* USER CODE END HighFrequencyTask SINGLEDRIVE_2 */
</#if>
  if(hFOCreturn == MC_FOC_DURATION)
  {
    STM_FaultProcessing(&STM[M1], MC_FOC_DURATION, 0);
  }
  else
  {
<#if ( MC.STATE_OBSERVER_PLL == true)>
    bool IsAccelerationStageReached = RUC_FirstAccelerationStageReached(&RevUpControlM1); 
</#if> 	   
<#if  MC.STATE_OBSERVER_PLL == true || MC.STATE_OBSERVER_CORDIC == true >
    STO_Inputs.Ialfa_beta = FOCVars[M1].Ialphabeta; /*  only if sensorless*/
    STO_Inputs.Vbus = VBS_GetAvBusVoltage_d(&(pBusSensorM1->_Super)); /*  only for sensorless*/
    ${SPD_calcElAngle_M1} (${SPD_M1}, &STO_Inputs);
    ${SPD_calcAvergElSpeedDpp_M1} (${SPD_M1}); /*  Only in case of Sensor-less */
	<#if ( MC.STATE_OBSERVER_PLL == true)>
	 if (IsAccelerationStageReached == false)
    {
      STO_ResetPLL(&STO_PLL_M1);
    }  
	</#if> 	
    hState = STM_GetState(&STM[M1]);
    if((hState == START) || (hState == SWITCH_OVER) || (hState == START_RUN)) /*  only for sensor-less*/
    {
      int16_t hObsAngle = SPD_GetElAngle(${SPD_M1}._Super);      
      VSS_CalcElAngle(&VirtualSpeedSensorM1,&hObsAngle);  
    }
</#if>    
<#if  MC.AUX_STATE_OBSERVER_PLL == true ||  MC.AUX_STATE_OBSERVER_CORDIC == true>
    STO_aux_Inputs.Ialfa_beta = FOCVars[M1].Ialphabeta; /*  only if sensorless*/    
    STO_aux_Inputs.Vbus = VBS_GetAvBusVoltage_d(&(pBusSensorM1->_Super)); /*  only for sensorless*/ 
    ${SPD_aux_calcElAngle_M1} (${SPD_AUX_M1}, &STO_aux_Inputs);
	${SPD_aux_calcAvrgElSpeedDpp_M1} (${SPD_AUX_M1});
</#if>
    /* USER CODE BEGIN HighFrequencyTask SINGLEDRIVE_3 */

    /* USER CODE END HighFrequencyTask SINGLEDRIVE_3 */  
  }
<#else> <#-- MC.DUALDRIVE -->
<#if MC.STATE_OBSERVER_PLL == true || MC.STATE_OBSERVER_CORDIC == true || MC.STATE_OBSERVER_PLL2 == true || MC.STATE_OBSERVER_CORDIC2 == true >
  uint16_t hState;  /*  only if, at least, one of the two motors is sensorless main*/
  Observer_Inputs_t STO_Inputs; /*  only if sensorless main */
</#if>
<#if  MC.AUX_STATE_OBSERVER_PLL == true ||  MC.AUX_STATE_OBSERVER_PLL2 == true ||  MC.AUX_STATE_OBSERVER_CORDIC == true ||  MC.AUX_STATE_OBSERVER_CORDIC2 == true >
  Observer_Inputs_t STO_aux_Inputs; 
</#if>

  bMotorNbr = FOC_array[FOC_array_head];
  if (bMotorNbr == M1)
  {
<#if  MC.AUX_STATE_OBSERVER_PLL == true ||  MC.AUX_STATE_OBSERVER_CORDIC == true >
    STO_aux_Inputs.Valfa_beta = FOCVars[M1].Valphabeta;  /* only if sensorless*/
</#if>

<#if ( MC.AUX_ENCODER == true) || ( MC.ENCODER == true) >
  ENC_CalcAngle (&ENCODER_M1);
</#if>
<#if ( MC.AUX_HALL_SENSORS == true)||( MC.HALL_SENSORS == true)>    
  HALL_CalcElAngle (&HALL_M1);  
</#if>
<#if ( MC.STATE_OBSERVER_PLL == true || MC.STATE_OBSERVER_CORDIC == true)>
  STO_Inputs.Valfa_beta = FOCVars[M1].Valphabeta;        /* only if motor0 is sensorless*/ 
    if ( STM[M1].bState == SWITCH_OVER )
    {
      if (!REMNG_RampCompleted(pREMNG[M1]))
      {
        FOCVars[M1].Iqdref.q = REMNG_Calc(pREMNG[M1]);
      }
    }
</#if>
<#if (( MC.OTF_STARTUP == true))>
    if(!RUC_Get_SCLowsideOTF_Status(&RevUpControlM1))
    {
      hFOCreturn = FOC_CurrControllerM1();
    }
    else
    {
      hFOCreturn = MC_NO_ERROR;
    }
<#else>
  /* USER CODE BEGIN HighFrequencyTask DUALDRIVE_1 */

  /* USER CODE END HighFrequencyTask DUALDRIVE_1 */
    hFOCreturn = FOC_CurrControllerM1();
  /* USER CODE BEGIN HighFrequencyTask DUALDRIVE_2 */

  /* USER CODE END HighFrequencyTask DUALDRIVE_2 */
</#if>
  }
  else /* bMotorNbr != M1 */
  {
<#if  MC.STATE_OBSERVER_PLL2 == true || MC.STATE_OBSERVER_CORDIC2 == true>
    STO_Inputs.Valfa_beta = FOCVars[M2].Valphabeta;      /* only if motor2 is sensorless*/
</#if>
<#if ((  MC.AUX_STATE_OBSERVER_PLL2 == true)||(  MC.AUX_STATE_OBSERVER_CORDIC2 == true))>
    STO_aux_Inputs.Valfa_beta = FOCVars[M2].Valphabeta;   /* only if motor2 is sensorless*/
</#if>
<#if ( MC.AUX_ENCODER2 == true) || ( MC.ENCODER2 == true) >
   ENC_CalcAngle (&ENCODER_M2);
</#if>
<#if ( MC.AUX_HALL_SENSORS2 == true)||( MC.HALL_SENSORS2 == true)>    
   HALL_CalcElAngle (&HALL_M2);  
</#if>    
<#if ( MC.STATE_OBSERVER_PLL2 == true || MC.STATE_OBSERVER_CORDIC2 == true)>
    if ( STM[M2].bState == SWITCH_OVER )
    {
      if (!REMNG_RampCompleted(pREMNG[M2]))
      {
        FOCVars[M2].Iqdref.q = REMNG_Calc(pREMNG[M2]);
      }
    }
</#if>
<#if (( MC.OTF_STARTUP2 == true))>
    if(!RUC_Get_SCLowsideOTF_Status(&RevUpControlM2))
    {
      hFOCreturn = FOC_CurrControllerM2();
    }
    else
    {
      hFOCreturn = MC_NO_ERROR;
    }
<#else>
  /* USER CODE BEGIN HighFrequencyTask DUALDRIVE_3 */

  /* USER CODE END HighFrequencyTask DUALDRIVE_3 */
    hFOCreturn = FOC_CurrControllerM2();
  /* USER CODE BEGIN HighFrequencyTask DUALDRIVE_4 */

  /* USER CODE END HighFrequencyTask DUALDRIVE_4 */
</#if>
  }
  if(hFOCreturn == MC_FOC_DURATION)
  {
    STM_FaultProcessing(&STM[bMotorNbr], MC_FOC_DURATION, 0);
  }
  else
  {
    if (bMotorNbr == M1)
    {
	<#if ( MC.STATE_OBSERVER_PLL == true)>	
	  bool IsAccelerationStageReached = RUC_FirstAccelerationStageReached(&RevUpControlM1);
	 </#if>
<#if  MC.STATE_OBSERVER_PLL == true || MC.STATE_OBSERVER_CORDIC == true >
      STO_Inputs.Ialfa_beta = FOCVars[M1].Ialphabeta; /*  only if sensorless*/
      STO_Inputs.Vbus = VBS_GetAvBusVoltage_d(&(pBusSensorM1->_Super)); /*  only for sensorless*/
      ${SPD_calcElAngle_M1} (${SPD_M1}, &STO_Inputs);
      ${SPD_calcAvergElSpeedDpp_M1} (${SPD_M1}); /*  Only in case of Sensor-less */
	<#if ( MC.STATE_OBSERVER_PLL == true)>
	  if (IsAccelerationStageReached == false)
      {
        STO_ResetPLL(&STO_PLL_M1);
      }  
	</#if> 	
    hState = STM_GetState(&STM[M1]);
    if((hState == START) || (hState == SWITCH_OVER) || (hState == START_RUN)) /*  only for sensor-less*/
    {
      int16_t hObsAngle = SPD_GetElAngle(${SPD_M1}._Super);      
      VSS_CalcElAngle(&VirtualSpeedSensorM1,&hObsAngle);  
    }
</#if>    
<#if  MC.AUX_STATE_OBSERVER_PLL == true ||  MC.AUX_STATE_OBSERVER_CORDIC == true>
    STO_aux_Inputs.Ialfa_beta = FOCVars[M1].Ialphabeta; /*  only if sensorless*/    
    STO_aux_Inputs.Vbus = VBS_GetAvBusVoltage_d(&(pBusSensorM1->_Super)); /*  only for sensorless*/ 
    ${SPD_aux_calcElAngle_M1} (${SPD_AUX_M1}, &STO_aux_Inputs);
	${SPD_aux_calcAvrgElSpeedDpp_M1} (${SPD_AUX_M1});
</#if>
    }
    else // bMotorNbr != M1
    {
   <#if (  MC.STATE_OBSERVER_PLL2 == true)>
      bool IsAccelerationStageReached = RUC_FirstAccelerationStageReached(&RevUpControlM2);
   </#if>
	<#if  MC.STATE_OBSERVER_PLL2 == true || MC.STATE_OBSERVER_CORDIC2 == true >
      STO_Inputs.Ialfa_beta = FOCVars[M2].Ialphabeta; /*  only if sensorless*/
      STO_Inputs.Vbus = VBS_GetAvBusVoltage_d(&(pBusSensorM2->_Super)); /*  only for sensorless*/
      ${SPD_calcElAngle_M2} (${SPD_M2}, &STO_Inputs);
      ${SPD_calcAvergElSpeedDpp_M2} (${SPD_M2}); /*  Only in case of Sensor-less */
	<#if ( MC.STATE_OBSERVER_PLL2 == true)>
	  if (IsAccelerationStageReached == false)
      {
        STO_ResetPLL(&STO_PLL_M2);
      }  
	</#if> 	
      hState = STM_GetState(&STM[M2]);
      if((hState == START) || (hState == SWITCH_OVER) || (hState == START_RUN)) /*  only for sensor-less*/
      {
        int16_t hObsAngle = SPD_GetElAngle(${SPD_M2}._Super);      
        VSS_CalcElAngle(&VirtualSpeedSensorM2,&hObsAngle);  
      }
    </#if>
  
  <#if  MC.AUX_STATE_OBSERVER_PLL2 == true ||  MC.AUX_STATE_OBSERVER_CORDIC2 == true>
      STO_aux_Inputs.Ialfa_beta = FOCVars[M2].Ialphabeta; /*  only if sensorless*/    
      STO_aux_Inputs.Vbus = VBS_GetAvBusVoltage_d(&(pBusSensorM2->_Super)); /*  only for sensorless*/ 
      ${SPD_aux_calcElAngle_M2} (${SPD_AUX_M2}, &STO_aux_Inputs);
	  ${SPD_aux_calcAvrgElSpeedDpp_M2} (${SPD_AUX_M2});
  </#if>
    }    
  }
  FOC_array_head++;
  if (FOC_array_head == FOC_ARRAY_LENGTH)
  {
    FOC_array_head = 0;
  }
</#if>
  /* USER CODE BEGIN HighFrequencyTask 1 */

  /* USER CODE END HighFrequencyTask 1 */

<#if MC.TESTENV == true && MC.PFC_ENABLED == false >
  /* Performance Measurement: end measure */
  LL_GPIO_ResetOutputPin( ${PM_Port}, LL_GPIO_PIN_${PM_Pin} );
</#if>
    
  return bMotorNbr;
}
</#if>

<#if (MC.MOTOR_PROFILER == true)>
#if defined (CCMRAM)
#if defined (__ICCARM__)
#pragma location = ".ccmram"
#elif defined (__CC_ARM) || defined(__GNUC__)
__attribute__((section (".ccmram")))
#endif
#endif
/**
  * @brief  Motor control profiler HF task
  * @param  None
  * @retval uint8_t It return always 0.
  */
__weak uint8_t TSK_HighFrequencyTask(void)
{
  ab_t Iab;

  if ( STM[M1].bState == SWITCH_OVER )
  {
    if (!REMNG_RampCompleted(pREMNG[M1]))
    {
      FOCVars[M1].Iqdref.q = REMNG_Calc(pREMNG[M1]);
    }
  }

  /* The generic function needs to be called here as the undelying   
   * implementation changes in time depending on the Profiler's state 
   * machine. Calling the generic function ensures that the correct
   * implementation is invoked. */
  PWMC_GetPhaseCurrents(pwmcHandle[M1], &Iab);
  FOCVars[M1].Iab = Iab;
  SCC_SetPhaseVoltage(pSCC);
  return 0; /* Single motor only */
}
</#if>

<#if MC.MOTOR_PROFILER == false>
#if defined (CCMRAM)
#if defined (__ICCARM__)
#pragma location = ".ccmram"
#elif defined (__CC_ARM) || defined(__GNUC__)
__attribute__((section (".ccmram")))
#endif
#endif
/**
  * @brief It executes the core of FOC drive that is the controllers for Iqd
  *        currents regulation. Reference frame transformations are carried out
  *        accordingly to the active speed sensor. It must be called periodically
  *        when new motor currents have been converted
  * @param this related object of class CFOC.
  * @retval int16_t It returns MC_NO_FAULTS if the FOC has been ended before
  *         next PWM Update event, MC_FOC_DURATION otherwise
  */
inline uint16_t FOC_CurrControllerM1(void)
{
  qd_t Iqd, Vqd;
  ab_t Iab;
  alphabeta_t Ialphabeta, Valphabeta;

<#if MC.HFINJECTION == true>
  qd_t IqdHF = {0,0};
</#if>
  int16_t hElAngle;
  uint16_t hCodeError;
  SpeednPosFdbk_Handle_t *speedHandle;

  speedHandle = STC_GetSpeedSensor(pSTC[M1]);
  hElAngle = SPD_GetElAngle(speedHandle);
<#if  MC.STATE_OBSERVER_PLL == true ||  MC.STATE_OBSERVER_CORDIC == true>  
  hElAngle += SPD_GetInstElSpeedDpp(speedHandle)*PARK_ANGLE_COMPENSATION_FACTOR;
</#if>  
  PWMC_GetPhaseCurrents(pwmcHandle[M1], &Iab);
  <#if NoInjectedChannel>  
  RCM_ExecNextConv();
  </#if>
<#if (MC.AMPLIFICATION_GAIN?number <0)>
  /* As the Gain is negative, we invert the current read*/
  Iab.a = -Iab.a;
  Iab.b = -Iab.b;
</#if>
  Ialphabeta = MCM_Clarke(Iab);
  Iqd = MCM_Park(Ialphabeta, hElAngle);
<#if MC.HFINJECTION == true>
  IqdHF = Iqd; /* Stores the Iqd not filtered */
  Iqd = HFI_FP_PreProcessing(pHFI[M1], Iqd);
</#if>
  Vqd.q = PI_Controller(pPIDIq[M1],
            (int32_t)(FOCVars[M1].Iqdref.q) - Iqd.q);

  Vqd.d = PI_Controller(pPIDId[M1],
            (int32_t)(FOCVars[M1].Iqdref.d) - Iqd.d);
<#if MC.FEED_FORWARD_CURRENT_REG_ENABLING == true>
  Vqd = FF_VqdConditioning(pFF[M1],Vqd);
</#if>
  
<#if MC.HFINJECTION == true>
    FOCVars[M1].Vqd = Vqd;
    Vqd = HFI_FP_VqdConditioning(pHFI[M1], Vqd);
</#if>
<#if MC.OPEN_LOOP_FOC == true>
    Vqd = OL_VqdConditioning(pOpenLoop[M1]);
</#if>
  Vqd = Circle_Limitation(pCLM[M1], Vqd);
  hElAngle += SPD_GetInstElSpeedDpp(speedHandle)*REV_PARK_ANGLE_COMPENSATION_FACTOR;
  Valphabeta = MCM_Rev_Park(Vqd, hElAngle);
  hCodeError = PWMC_SetPhaseVoltage(pwmcHandle[M1], Valphabeta);
  <#if NoInjectedChannel>  
  RCM_ReadOngoingConv();
  </#if>
<#if MC.HFINJECTION == false>  
  FOCVars[M1].Vqd = Vqd;
</#if>
  FOCVars[M1].Iab = Iab;
  FOCVars[M1].Ialphabeta = Ialphabeta;
  FOCVars[M1].Iqd = Iqd;
  FOCVars[M1].Valphabeta = Valphabeta;
  FOCVars[M1].hElAngle = hElAngle;
<#if MC.HFINJECTION == true>
  FOCVars[M1].IqdHF = IqdHF;
</#if>
<#if MC.FLUX_WEAKENING_ENABLING == true>
  FW_DataProcess(pFW[M1], Vqd);
</#if>
<#if MC.FEED_FORWARD_CURRENT_REG_ENABLING == true>
  FF_DataProcess(pFF[M1]);
</#if>
<#if MC.HFINJECTION == true>
  HFI_FP_DataProcess(pHFI[M1], IqdHF);
</#if>
  return(hCodeError);
}

<#if ( MC.DUALDRIVE == true)>
#if defined (CCMRAM)
#if defined (__ICCARM__)
#pragma location = ".ccmram"
#elif defined (__CC_ARM) || defined(__GNUC__)
__attribute__((section (".ccmram")))
#endif
#endif
/**
  * @brief It executes the core of FOC drive that is the controllers for Iqd
  *        currents regulation of motor 2. Reference frame transformations are carried out
  *        accordingly to the active speed sensor. It must be called periodically
  *        when new motor currents have been converted
  * @param this related object of class CFOC.
  * @retval int16_t It returns MC_NO_FAULTS if the FOC has been ended before
  *         next PWM Update event, MC_FOC_DURATION otherwise
  */
inline uint16_t FOC_CurrControllerM2(void)
{
  ab_t Iab;
  alphabeta_t Ialphabeta, Valphabeta;
  qd_t Iqd, Vqd;

<#if MC.HFINJECTION2 == true>
  qd_t IqdHF = {0,0};
</#if>
  int16_t hElAngle;
  uint16_t hCodeError;
  SpeednPosFdbk_Handle_t *speedHandle;

  speedHandle = STC_GetSpeedSensor(pSTC[M2]);
  hElAngle = SPD_GetElAngle(speedHandle);
<#if  MC.STATE_OBSERVER_PLL2 == true ||  MC.STATE_OBSERVER_CORDIC2 == true>  
  hElAngle += SPD_GetInstElSpeedDpp(speedHandle)*PARK_ANGLE_COMPENSATION_FACTOR2;
</#if> 
  PWMC_GetPhaseCurrents(pwmcHandle[M2], &Iab);
<#if NoInjectedChannel>  
  RCM_ExecNextConv();
</#if>
<#if (MC.AMPLIFICATION_GAIN2?number <0)>
  /* As the Gain is negative, we invert the current read*/
  Iab.a = -Iab.a;
  Iab.b = -Iab.b;
</#if>
  Ialphabeta = MCM_Clarke(Iab);
  Iqd = MCM_Park(Ialphabeta, hElAngle);
<#if MC.HFINJECTION2 == true>
    IqdHF = Iqd; /* Stores the Iqd not filtered */
    Iqd = HFI_FP_PreProcessing(pHFI[M2], Iqd);
</#if>
  Vqd.q = PI_Controller(pPIDIq[M2],
            (int32_t)(FOCVars[M2].Iqdref.q) - Iqd.q);

  Vqd.d = PI_Controller(pPIDId[M2],
            (int32_t)(FOCVars[M2].Iqdref.d) - Iqd.d);
<#if MC.FEED_FORWARD_CURRENT_REG_ENABLING2 == true>
  Vqd = FF_VqdConditioning(pFF[M2],Vqd);
</#if>
  
<#if MC.HFINJECTION2 == true>
  FOCVars[M2].Vqd = Vqd;
  Vqd = HFI_FP_VqdConditioning(pHFI[M2], Vqd);
</#if>
<#if MC.OPEN_LOOP_FOC2 == true>
  Vqd = OL_VqdConditioning(pOpenLoop[M2]);
</#if>
  Vqd = Circle_Limitation(pCLM[M2], Vqd);
  hElAngle += SPD_GetInstElSpeedDpp(speedHandle)*REV_PARK_ANGLE_COMPENSATION_FACTOR2;
  Valphabeta = MCM_Rev_Park(Vqd, hElAngle);
  hCodeError = PWMC_SetPhaseVoltage(pwmcHandle[M2], Valphabeta);
  <#if NoInjectedChannel>  
  RCM_ReadOngoingConv();
  </#if>
<#if MC.HFINJECTION2 == false>  
  FOCVars[M2].Vqd = Vqd;
</#if>
  FOCVars[M2].Iab = Iab;
  FOCVars[M2].Ialphabeta = Ialphabeta;
  FOCVars[M2].Iqd = Iqd;
  FOCVars[M2].Valphabeta = Valphabeta;
  FOCVars[M2].hElAngle = hElAngle;
<#if MC.HFINJECTION2 == true>
  FOCVars[M2].IqdHF = IqdHF;
</#if>
<#if MC.FLUX_WEAKENING_ENABLING2 == true>
  FW_DataProcess(pFW[M2], Vqd);
</#if>
<#if MC.FEED_FORWARD_CURRENT_REG_ENABLING2 == true>
  FF_DataProcess(pFF[M2]);
</#if>
<#if MC.HFINJECTION2 == true>
    HFI_FP_DataProcess(pHFI[M2], IqdHF);
</#if>
  return(hCodeError);
}
</#if>
</#if>


/**
  * @brief  Executes safety checks (e.g. bus voltage and temperature) for all drive instances. 
  *
  * Faults flags are updated here.
  */
__weak void TSK_SafetyTask(void)
{
  /* USER CODE BEGIN TSK_SafetyTask 0 */

  /* USER CODE END TSK_SafetyTask 0 */
  if (bMCBootCompleted == 1)
  {  
    <#if (MC.MOTOR_PROFILER == true)>
    SCC_CheckOC_RL(pSCC);
    </#if>
    <#if ( MC.ON_OVER_VOLTAGE == "TURN_OFF_PWM")>
    TSK_SafetyTask_PWMOFF(M1);
    <#elseif ( MC.ON_OVER_VOLTAGE == "TURN_ON_R_BRAKE")>
    TSK_SafetyTask_RBRK(M1);
    <#elseif ( MC.ON_OVER_VOLTAGE == "TURN_ON_LOW_SIDES")>
    TSK_SafetyTask_LSON(M1);
    </#if>
<#if ( MC.DUALDRIVE == true)>
    /* Second drive */
    <#if ( MC.ON_OVER_VOLTAGE2 == "TURN_OFF_PWM")>
    TSK_SafetyTask_PWMOFF(M2);
    <#elseif ( MC.ON_OVER_VOLTAGE2 == "TURN_ON_R_BRAKE")>
    TSK_SafetyTask_RBRK(M2);
    <#elseif ( MC.ON_OVER_VOLTAGE2 == "TURN_ON_LOW_SIDES")>
    TSK_SafetyTask_LSON(M2);
    </#if>
</#if>
    /* User conversion execution */
    RCM_ExecUserConv ();
  /* USER CODE BEGIN TSK_SafetyTask 1 */

  /* USER CODE END TSK_SafetyTask 1 */
  }
}

<#if MC.ON_OVER_VOLTAGE == "TURN_OFF_PWM" || MC.ON_OVER_VOLTAGE2 == "TURN_OFF_PWM">
/**
  * @brief  Safety task implementation if  MC.ON_OVER_VOLTAGE == TURN_OFF_PWM
  * @param  bMotor Motor reference number defined
  *         \link Motors_reference_number here \endlink
  * @retval None
  */
__weak void TSK_SafetyTask_PWMOFF(uint8_t bMotor)
{
  /* USER CODE BEGIN TSK_SafetyTask_PWMOFF 0 */

  /* USER CODE END TSK_SafetyTask_PWMOFF 0 */
  
  uint16_t CodeReturn = MC_NO_ERROR;
<#if  MC.DUALDRIVE == true>  
  uint16_t errMask[NBR_OF_MOTORS] = {VBUS_TEMP_ERR_MASK, VBUS_TEMP_ERR_MASK2};
<#else>
  uint16_t errMask[NBR_OF_MOTORS] = {VBUS_TEMP_ERR_MASK};
</#if>  

  CodeReturn |= errMask[bMotor] & NTC_CalcAvTemp(pTemperatureSensor[bMotor]); /* check for fault if FW protection is activated. It returns MC_OVER_TEMP or MC_NO_ERROR */
  CodeReturn |= PWMC_CheckOverCurrent(pwmcHandle[bMotor]);                    /* check for fault. It return MC_BREAK_IN or MC_NO_FAULTS 
                                                                                 (for STM32F30x can return MC_OVER_VOLT in case of HW Overvoltage) */
<#if  MC.BUS_VOLTAGE_READING == true>
  if(bMotor == M1)
  {
<#if CondMcu_STM32F302x8x || CondFamily_STM32F3>
    CodeReturn |=  errMask[bMotor] & RVBS_CalcAvVbusFilt(pBusSensorM1);
<#else>
    CodeReturn |=  errMask[bMotor] &RVBS_CalcAvVbus(pBusSensorM1);
</#if>  
  }
<#else>
<#-- Nothing to do here the virtual voltage does not need computations nor measurement and it cannot fail... -->
</#if>
<#if  MC.BUS_VOLTAGE_READING2 == true>
  if(bMotor == M2)
  {
<#if CondMcu_STM32F302x8x || CondFamily_STM32F3>
    CodeReturn |=  errMask[bMotor] & RVBS_CalcAvVbusFilt(pBusSensorM2);
<#else>
    CodeReturn |=  errMask[bMotor] & RVBS_CalcAvVbus(pBusSensorM2);
</#if>
  }
<#else>
<#-- Nothing to do here the virtual voltage does not need computations nor measurement and it cannot fail... -->
</#if>

  STM_FaultProcessing(&STM[bMotor], CodeReturn, ~CodeReturn); /* Update the STM according error code */
  switch (STM_GetState(&STM[bMotor])) /* Acts on PWM outputs in case of faults */
  {
  case FAULT_NOW:
<#if (MC.MOTOR_PROFILER == true)>
    SCC_Stop(pSCC);
    OTT_Stop(pOTT);
</#if>
<#if  MC.ENCODER == true || MC.ENCODER2 == true || MC.AUX_ENCODER == true || MC.AUX_ENCODER2 == true >
    /* reset Encoder state */
    if (pEAC[bMotor] != MC_NULL)
    {       
      EAC_SetRestartState( pEAC[bMotor], false );
    }
</#if>
    PWMC_SwitchOffPWM(pwmcHandle[bMotor]);
    FOC_Clear(bMotor);
    MPM_Clear((MotorPowMeas_Handle_t*)pMPM[bMotor]);
    /* USER CODE BEGIN TSK_SafetyTask_PWMOFF 1 */

    /* USER CODE END TSK_SafetyTask_PWMOFF 1 */
    break;
  case FAULT_OVER:
<#if (MC.MOTOR_PROFILER == true)>
    SCC_Stop(pSCC);
    OTT_Stop(pOTT);
</#if>
    PWMC_SwitchOffPWM(pwmcHandle[bMotor]);
	/* USER CODE BEGIN TSK_SafetyTask_PWMOFF 2 */

    /* USER CODE END TSK_SafetyTask_PWMOFF 2 */
    break;
  default:
    break;
  }
<#if  MC.SMOOTH_BRAKING_ACTION_ON_OVERVOLTAGE == true>
  {
    /* Smooth braking action on overvoltage */
    if(bMotor == M1)
    {
      busd = (uint16_t)VBS_GetAvBusVoltage_d(&(pBusSensorM1->_Super));
    }
    else if(bMotor == M2)
    {
      busd = (uint16_t)VBS_GetAvBusVoltage_d(&(pBusSensorM2->_Super));
    }

    if ((STM_GetState(&STM[bMotor]) == IDLE)||
       ((STM_GetState(&STM[bMotor]) == RUN)&&(FOCVars[bMotor].Iqdref.q>0)))
    {
      nominalBusd[bMotor] = busd;
    }
    else
    {
      if((STM_GetState(&STM[bMotor]) == RUN)&&(FOCVars[bMotor].Iqdref.q<0))
      {
        if (busd > ((ovthd[bMotor] + nominalBusd[bMotor]) >> 1))
        {
          FOCVars[bMotor].Iqdref.q = 0;
          FOCVars[bMotor].Iqdref.d = 0;
        }
      }
    }
    /* USER CODE BEGIN TSK_SafetyTask_PWMOFF SMOOTH_BREAKING */

    /* USER CODE END TSK_SafetyTask_PWMOFF SMOOTH_BREAKING */
  }
</#if>
  /* USER CODE BEGIN TSK_SafetyTask_PWMOFF 3 */

  /* USER CODE END TSK_SafetyTask_PWMOFF 3 */
}
</#if>
<#if MC.ON_OVER_VOLTAGE == "TURN_ON_R_BRAKE" || MC.ON_OVER_VOLTAGE2 == "TURN_ON_R_BRAKE">
/**
  * @brief  Safety task implementation if  MC.ON_OVER_VOLTAGE == TURN_ON_R_BRAKE
  * @param  motor Motor reference number defined
  *         \link Motors_reference_number here \endlink
  * @retval None
  */
__weak void TSK_SafetyTask_RBRK(uint8_t bMotor)
{
  /* USER CODE BEGIN TSK_SafetyTask_RBRK 0 */

  /* USER CODE END TSK_SafetyTask_RBRK 0 */
  uint16_t CodeReturn = MC_NO_ERROR;
  uint16_t BusVoltageFaultsFlag;
<#if  MC.DUALDRIVE == true>  
  uint16_t errMask[NBR_OF_MOTORS] = {VBUS_TEMP_ERR_MASK, VBUS_TEMP_ERR_MASK2};
<#else>
  uint16_t errMask[NBR_OF_MOTORS] = {VBUS_TEMP_ERR_MASK};
</#if> 

  /* Brake resistor management */
<#if  MC.BUS_VOLTAGE_READING == true>
  if(bMotor == M1)
  {
  <#if CondMcu_STM32F302x8x || CondFamily_STM32F3>
    BusVoltageFaultsFlag =  errMask[bMotor] & RVBS_CalcAvVbusFilt(pBusSensorM1);
  <#else>
    BusVoltageFaultsFlag =  errMask[bMotor] & RVBS_CalcAvVbus(pBusSensorM1);
  </#if>
  }
<#else> 
 <#-- Nothing to do here the virtual voltage does not need computations nor measurement and it cannot fail... -->
</#if>
<#if  MC.BUS_VOLTAGE_READING2 == true>
  if(bMotor == M2)
  {
  <#if CondMcu_STM32F302x8x || CondFamily_STM32F3>
    BusVoltageFaultsFlag =  errMask[bMotor] & RVBS_CalcAvVbusFilt(pBusSensorM2);
  <#else>
    BusVoltageFaultsFlag =  errMask[bMotor] & RVBS_CalcAvVbus(pBusSensorM2);
  </#if>
  }
<#else>
<#-- Nothing to do here the virtual voltage does not need computations nor measurement and it cannot fail... -->
</#if>
  if (BusVoltageFaultsFlag == MC_OVER_VOLT)
  {
    DOUT_SetOutputState(pR_Brake[bMotor], ACTIVE);
  }
  else
  {
    DOUT_SetOutputState(pR_Brake[bMotor], INACTIVE);
  }
  CodeReturn |= NTC_CalcAvTemp(pTemperatureSensor[bMotor]);   /* check for fault if FW protection is activated. It returns MC_OVER_TEMP or MC_NO_ERROR */
  CodeReturn |= PWMC_CheckOverCurrent(pwmcHandle[bMotor]);    /* check for fault. It return MC_BREAK_IN or MC_NO_FAULTS 
                                                                 (for STM32F30x can return MC_OVER_VOLT in case of HW Overvoltage) */
  CodeReturn |= (BusVoltageFaultsFlag & MC_UNDER_VOLT);       /* MC_UNDER_VOLT generates fault if FW protection is activated,
                                                                 MC_OVER_VOLT doesn't generate fault */
  STM_FaultProcessing(&STM[bMotor], CodeReturn, ~CodeReturn); /* Update the STM according error code */
  switch (STM_GetState(&STM[bMotor]))
  {
  case FAULT_NOW:
<#if (MC.MOTOR_PROFILER == true)>
    SCC_Stop(pSCC);
    OTT_Stop(pOTT);
</#if>
<#if  MC.ENCODER == true || MC.ENCODER2 == true || MC.AUX_ENCODER == true || MC.AUX_ENCODER2 == true >  
          /* reset Encoder state */
          if (pEAC[bMotor] != MC_NULL)
          {       
            EAC_SetRestartState( pEAC[bMotor], false );
          }
</#if>
    PWMC_SwitchOffPWM(pwmcHandle[bMotor]);
    FOC_Clear(bMotor);
    MPM_Clear((MotorPowMeas_Handle_t*)pMPM[bMotor]);
    /* USER CODE BEGIN TSK_SafetyTask_RBRK 1 */

    /* USER CODE END TSK_SafetyTask_RBRK 1 */
    break;
  case FAULT_OVER:
<#if (MC.MOTOR_PROFILER == true)>
    SCC_Stop(pSCC);
    OTT_Stop(pOTT);
</#if>
    PWMC_SwitchOffPWM(pwmcHandle[bMotor]);
    /* USER CODE BEGIN TSK_SafetyTask_RBRK 2 */

    /* USER CODE END TSK_SafetyTask_RBRK 2 */
    break;
  default:
    break;
  }
  /* USER CODE BEGIN TSK_SafetyTask_RBRK 3 */

  /* USER CODE END TSK_SafetyTask_RBRK 3 */  
}
</#if>
<#if MC.ON_OVER_VOLTAGE == "TURN_ON_LOW_SIDES" || MC.ON_OVER_VOLTAGE2 == "TURN_ON_LOW_SIDES">
/**
  * @brief  Safety task implementation if  MC.ON_OVER_VOLTAGE == TURN_ON_LOW_SIDES
  * @param  motor Motor reference number defined
  *         \link Motors_reference_number here \endlink
  * @retval None
  */
__weak void TSK_SafetyTask_LSON(uint8_t bMotor)
{
  /* USER CODE BEGIN TSK_SafetyTask_LSON 0 */

  /* USER CODE END TSK_SafetyTask_LSON 0 */
  uint16_t CodeReturn = MC_NO_ERROR;
<#if  MC.DUALDRIVE == true>  
  uint16_t errMask[NBR_OF_MOTORS] = {VBUS_TEMP_ERR_MASK, VBUS_TEMP_ERR_MASK2};
<#else>
  uint16_t errMask[NBR_OF_MOTORS] = {VBUS_TEMP_ERR_MASK};
</#if> 
  bool TurnOnLowSideAction;
  
  TurnOnLowSideAction = PWMC_GetTurnOnLowSidesAction(pwmcHandle[bMotor]);
  CodeReturn |= errMask[bMotor] & NTC_CalcAvTemp(pTemperatureSensor[bMotor]); /* check for fault if FW protection is activated. */
  CodeReturn |= PWMC_CheckOverCurrent(pwmcHandle[bMotor]);                    /* for fault. It return MC_BREAK_IN or MC_NO_FAULTS
                                                                                (for STM32F30x can return MC_OVER_VOLT in case of HW Overvoltage) */
  /* USER CODE BEGIN TSK_SafetyTask_LSON 1 */

  /* USER CODE END TSK_SafetyTask_LSON 1 */
<#if  MC.BUS_VOLTAGE_READING == true>
  if(bMotor == M1)
  {
  <#if CondMcu_STM32F302x8x || CondFamily_STM32F3>
    CodeReturn |= errMask[bMotor] & RVBS_CalcAvVbusFilt(pBusSensorM1);
  <#else>
    CodeReturn |= errMask[bMotor] & RVBS_CalcAvVbus(pBusSensorM1);
  </#if>
  }
<#else>
  <#-- Nothing to do here the virtual voltage does not need computations nor measurement and it cannot fail... -->
</#if>
<#if  MC.BUS_VOLTAGE_READING2 == true>
  if(bMotor == M2)
  {
  <#if CondMcu_STM32F302x8x || CondFamily_STM32F3>
    CodeReturn |= errMask[bMotor] & RVBS_CalcAvVbusFilt(pBusSensorM2);
  <#else>
    CodeReturn |= errMask[bMotor] & RVBS_CalcAvVbus(pBusSensorM2);
  </#if> 
  }
<#else>
  <#-- Nothing to do here the virtual voltage does not need computations nor measurement and it cannot fail... --> 
</#if>
  STM_FaultProcessing(&STM[bMotor], CodeReturn, ~CodeReturn); /* Update the STM according error code */
  if (((CodeReturn & MC_OVER_VOLT) == MC_OVER_VOLT) && (TurnOnLowSideAction == false))
  {
<#if  MC.ENCODER == true || MC.ENCODER2 == true || MC.AUX_ENCODER == true || MC.AUX_ENCODER2 == true > 
    /* reset Encoder state */
    if (pEAC[bMotor] != MC_NULL)
    {       
      EAC_SetRestartState( pEAC[bMotor], false );
    }
</#if>
    /* Start turn on low side action */
    PWMC_SwitchOffPWM(pwmcHandle[bMotor]); /* Required before //PWMC_TurnOnLowSides */
<#if ( MC.HW_OV_CURRENT_PROT_BYPASS == true)>
    DOUT_SetOutputState(pOCPDisabling[bMotor], ACTIVE); /* Disable the OCP */
</#if>
    /* USER CODE BEGIN TSK_SafetyTask_LSON 2 */

    /* USER CODE END TSK_SafetyTask_LSON 2 */
    PWMC_TurnOnLowSides(pwmcHandle[bMotor]); /* Turn on Low side switches */
  }
  else
  {
    switch (STM_GetState(&STM[bMotor])) /* Is state equal to FAULT_NOW or FAULT_OVER */
    {
    case IDLE:
        /* After a OV occurs the turn on low side action become active. It is released just after a fault acknowledge -> state == IDLE */
        if (TurnOnLowSideAction == true)
        {
          /* End of TURN_ON_LOW_SIDES action */
<#if ( MC.HW_OV_CURRENT_PROT_BYPASS == true)>
          DOUT_SetOutputState(pOCPDisabling[bMotor], INACTIVE); /* Re-enable the OCP */
</#if>
          PWMC_SwitchOffPWM(pwmcHandle[bMotor]);  /* Switch off the PWM */
        }
	  /* USER CODE BEGIN TSK_SafetyTask_LSON 3 */

      /* USER CODE END TSK_SafetyTask_LSON 3 */
      break;
    case FAULT_NOW:
        if (TurnOnLowSideAction == false)
        {
<#if  MC.ENCODER == true || MC.ENCODER2 == true || MC.AUX_ENCODER == true || MC.AUX_ENCODER2 == true >   
          /* reset Encoder state */
          if (pEAC[bMotor] != MC_NULL)
          {       
            EAC_SetRestartState( pEAC[bMotor], false );
          }
</#if>
          /* Switching off the PWM if fault occurs must be done just if TURN_ON_LOW_SIDES action is not in place */
          PWMC_SwitchOffPWM(pwmcHandle[bMotor]);
          FOC_Clear(bMotor);
          MPM_Clear((MotorPowMeas_Handle_t*)pMPM[bMotor]);
        }
      /* USER CODE BEGIN TSK_SafetyTask_LSON 4 */

      /* USER CODE END TSK_SafetyTask_LSON 4 */
      break;
    case FAULT_OVER:
        if (TurnOnLowSideAction == false)
        {
          /* Switching off the PWM if fault occurs must be done just if TURN_ON_LOW_SIDES action is not in place */
          PWMC_SwitchOffPWM(pwmcHandle[bMotor]);
        }
	  /* USER CODE BEGIN TSK_SafetyTask_LSON 5 */

      /* USER CODE END TSK_SafetyTask_LSON 5 */
      break;
    default:
      break;
    }
  }
  /* USER CODE BEGIN TSK_SafetyTask_LSON 6 */

  /* USER CODE END TSK_SafetyTask_LSON 6 */
}
</#if>

<#if  MC.DUALDRIVE == true>
#if defined (CCMRAM_ENABLED)
#if defined (__ICCARM__)
#pragma location = ".ccmram"
#elif defined (__CC_ARM)
__attribute__((section (".ccmram")))
#endif
#endif
/**
  * @brief Reserves FOC execution on ADC ISR half a PWM period in advance
  *
  *  This function is called by TIMx_UP_IRQHandler in case of dual MC and
  * it allows to reserve half PWM period in advance the FOC execution on
  * ADC ISR
  * @param  pDrive Pointer on the FOC Array
  */
__weak void TSK_DualDriveFIFOUpdate(uint8_t Motor)
{
  FOC_array[FOC_array_tail] = Motor;
  FOC_array_tail++;
  if (FOC_array_tail == FOC_ARRAY_LENGTH)
  {
    FOC_array_tail = 0;
  }
}
</#if>

/**
  * @brief  This function returns the reference of the MCInterface relative to
  *         the selected drive.
  * @param  bMotor Motor reference number defined
  *         \link Motors_reference_number here \endlink
  * @retval MCI_Handle_t * Reference to MCInterface relative to the selected drive.
  *         Note: it can be MC_NULL if MCInterface of selected drive is not
  *         allocated.
  */
__weak MCI_Handle_t * GetMCI(uint8_t bMotor)
{
  MCI_Handle_t * retVal = MC_NULL;
  if (bMotor < NBR_OF_MOTORS)
  {
    retVal = oMCInterface[bMotor];
  }
  return retVal;
}

/**
  * @brief  This function returns the reference of the MCTuning relative to
  *         the selected drive.
  * @param  bMotor Motor reference number defined
  *         \link Motors_reference_number here \endlink
  * @retval MCT_Handle_t motor control tuning handler for the selected drive.
  *         Note: it can be MC_NULL if MCInterface of selected drive is not
  *         allocated.
  */
__weak MCT_Handle_t* GetMCT(uint8_t bMotor)
{
  MCT_Handle_t* retVal = MC_NULL;
<#if MC.MC_TUNING_INTERFACE == true>
  if (bMotor < NBR_OF_MOTORS)
  {
    retVal = &MCT[bMotor];
  }
</#if>
  return retVal;
}

/**
  * @brief  Puts the Motor Control subsystem in in safety conditions on a Hard Fault
  *
  *  This function is to be executed when a general hardware failure has been detected  
  * by the microcontroller and is used to put the system in safety condition.
  */
__weak void TSK_HardwareFaultTask(void)
{
  /* USER CODE BEGIN TSK_HardwareFaultTask 0 */

  /* USER CODE END TSK_HardwareFaultTask 0 */
  
<#if (MC.MOTOR_PROFILER == true)>
  SCC_Stop(pSCC);
  OTT_Stop(pOTT);
</#if>
  ${PWM_SwitchOff}(pwmcHandle[M1]);
  STM_FaultProcessing(&STM[M1], MC_SW_ERROR, 0);
<#if  MC.DUALDRIVE == true>
  ${PWM_SwitchOff_M2}(pwmcHandle[M2]);
  STM_FaultProcessing(&STM[M2], MC_SW_ERROR, 0);
</#if>
  /* USER CODE BEGIN TSK_HardwareFaultTask 1 */

  /* USER CODE END TSK_HardwareFaultTask 1 */
}
<#if MC.PFC_ENABLED == true>

/**
  * @brief  Executes the PFC Task.
  */
void PFC_Scheduler(void)
{
	PFC_Task( &PFC );
}
</#if>
<#if MC.RTOS == "FREERTOS">

/* startMediumFrequencyTask function */
void startMediumFrequencyTask(void const * argument)
{
<#if MC.CUBE_MX_VER == "xxx" >
  /* init code for MotorControl */
  MX_MotorControl_Init();
<#else>
<#assign cubeVersion = MC.CUBE_MX_VER?replace(".","") >
<#if cubeVersion?number < 540 >
  /* init code for MotorControl */
  MX_MotorControl_Init();
</#if>  
</#if> 
  /* USER CODE BEGIN MF task 1 */
  /* Infinite loop */
  for(;;)
  {
    /* delay of 500us */
    vTaskDelay(1);
    MC_RunMotorControlTasks();
  }
  /* USER CODE END MF task 1 */
}

/* startSafetyTask function */
void StartSafetyTask(void const * argument)
{
  /* USER CODE BEGIN SF task 1 */
  /* Infinite loop */
  for(;;)
  {
    /* delay of 500us */
    vTaskDelay(1);
    TSK_SafetyTask();
  }
  /* USER CODE END SF task 1 */ 
}

</#if>   
 /**
  * @brief  Locks GPIO pins used for Motor Control to prevent accidental reconfiguration 
  */
__weak void mc_lock_pins (void)
{
<#list configs as dt>
<#list dt.peripheralGPIOParams.values() as io>
<#list io.values() as ipIo>
<#list ipIo.entrySet() as e>
<#if (e.getKey().equals("GPIO_Label")) && (e.getValue()?matches("^M[0-9]+_.*$"))>
LL_GPIO_LockPin(${e.getValue()}_GPIO_Port, ${e.getValue()}_Pin);
</#if>
</#list>
</#list>
</#list>
</#list>
}

/* USER CODE BEGIN mc_task 0 */

/* USER CODE END mc_task 0 */

/******************* (C) COPYRIGHT 2019 STMicroelectronics *****END OF FILE****/
