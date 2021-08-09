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

<#assign OPAMPInputMapp_Shared_PHB =
  [ {"Sector": 1 , "INPUT_1" : MC.OPAMP1_NONINVERTINGINPUT_PHB , "INPUT_2" : MC.OPAMP2_NONINVERTINGINPUT_PHC}
   ,{"Sector": 2 , "INPUT_1" : MC.OPAMP1_NONINVERTINGINPUT_PHA , "INPUT_2" : MC.OPAMP2_NONINVERTINGINPUT_PHC}
   ,{"Sector": 3 , "INPUT_1" : MC.OPAMP1_NONINVERTINGINPUT_PHA , "INPUT_2" : MC.OPAMP2_NONINVERTINGINPUT_PHC}
   ,{"Sector": 4 , "INPUT_1" : MC.OPAMP1_NONINVERTINGINPUT_PHA , "INPUT_2" : MC.OPAMP2_NONINVERTINGINPUT_PHB}
   ,{"Sector": 5 , "INPUT_1" : MC.OPAMP1_NONINVERTINGINPUT_PHA , "INPUT_2" : MC.OPAMP2_NONINVERTINGINPUT_PHB}
   ,{"Sector": 6 , "INPUT_1" : MC.OPAMP1_NONINVERTINGINPUT_PHB , "INPUT_2" : MC.OPAMP2_NONINVERTINGINPUT_PHC}
   ] >

<#assign OPAMPInputMapp_Shared_PHB2 =
  [ {"Sector": 1 , "INPUT_1" : MC.OPAMP1_NONINVERTINGINPUT_PHB2 , "INPUT_2" : MC.OPAMP2_NONINVERTINGINPUT_PHC2}
   ,{"Sector": 2 , "INPUT_1" : MC.OPAMP1_NONINVERTINGINPUT_PHA2 , "INPUT_2" : MC.OPAMP2_NONINVERTINGINPUT_PHC2}
   ,{"Sector": 3 , "INPUT_1" : MC.OPAMP1_NONINVERTINGINPUT_PHA2 , "INPUT_2" : MC.OPAMP2_NONINVERTINGINPUT_PHC2}
   ,{"Sector": 4 , "INPUT_1" : MC.OPAMP1_NONINVERTINGINPUT_PHA2 , "INPUT_2" : MC.OPAMP2_NONINVERTINGINPUT_PHB2}
   ,{"Sector": 5 , "INPUT_1" : MC.OPAMP1_NONINVERTINGINPUT_PHA2 , "INPUT_2" : MC.OPAMP2_NONINVERTINGINPUT_PHB2}
   ,{"Sector": 6 , "INPUT_1" : MC.OPAMP1_NONINVERTINGINPUT_PHB2 , "INPUT_2" : MC.OPAMP2_NONINVERTINGINPUT_PHC2}
   ] > 

<#assign OPAMPInputMapp_Shared_PHA =
  [ {"Sector": 1 , "INPUT_1" : MC.OPAMP1_NONINVERTINGINPUT_PHB , "INPUT_2" : MC.OPAMP2_NONINVERTINGINPUT_PHC}
   ,{"Sector": 2 , "INPUT_1" : MC.OPAMP1_NONINVERTINGINPUT_PHA , "INPUT_2" : MC.OPAMP2_NONINVERTINGINPUT_PHC}
   ,{"Sector": 3 , "INPUT_1" : MC.OPAMP1_NONINVERTINGINPUT_PHA , "INPUT_2" : MC.OPAMP2_NONINVERTINGINPUT_PHC}
   ,{"Sector": 4 , "INPUT_1" : MC.OPAMP1_NONINVERTINGINPUT_PHB , "INPUT_2" : MC.OPAMP2_NONINVERTINGINPUT_PHA}
   ,{"Sector": 5 , "INPUT_1" : MC.OPAMP1_NONINVERTINGINPUT_PHB , "INPUT_2" : MC.OPAMP2_NONINVERTINGINPUT_PHA}
   ,{"Sector": 6 , "INPUT_1" : MC.OPAMP1_NONINVERTINGINPUT_PHB , "INPUT_2" : MC.OPAMP2_NONINVERTINGINPUT_PHC}
   ] >

 <#assign OPAMPInputMapp_Shared_PHA2 =
  [ {"Sector": 1 , "INPUT_1" : MC.OPAMP1_NONINVERTINGINPUT_PHB2 , "INPUT_2" : MC.OPAMP2_NONINVERTINGINPUT_PHC2}
   ,{"Sector": 2 , "INPUT_1" : MC.OPAMP1_NONINVERTINGINPUT_PHA2 , "INPUT_2" : MC.OPAMP2_NONINVERTINGINPUT_PHC2}
   ,{"Sector": 3 , "INPUT_1" : MC.OPAMP1_NONINVERTINGINPUT_PHA2 , "INPUT_2" : MC.OPAMP2_NONINVERTINGINPUT_PHC2}
   ,{"Sector": 4 , "INPUT_1" : MC.OPAMP1_NONINVERTINGINPUT_PHB2 , "INPUT_2" : MC.OPAMP2_NONINVERTINGINPUT_PHA2}
   ,{"Sector": 5 , "INPUT_1" : MC.OPAMP1_NONINVERTINGINPUT_PHB2 , "INPUT_2" : MC.OPAMP2_NONINVERTINGINPUT_PHA2}
   ,{"Sector": 6 , "INPUT_1" : MC.OPAMP1_NONINVERTINGINPUT_PHB2 , "INPUT_2" : MC.OPAMP2_NONINVERTINGINPUT_PHC2}
   ] >       
<#-- /* If 2 OPAMP is used, we sample only Phase U and Phase V, the switch is done at OPAMP input level*/-->
<#assign ADCConfig_2OPAMP =
  [ {"Sector": 1 , "Sampling_1" : MC.PHASE_U_CURR_CHANNEL , "Sampling_2" : MC.PHASE_V_CURR_CHANNEL}
   ,{"Sector": 2 , "Sampling_1" : MC.PHASE_U_CURR_CHANNEL , "Sampling_2" : MC.PHASE_V_CURR_CHANNEL}
   ,{"Sector": 3 , "Sampling_1" : MC.PHASE_U_CURR_CHANNEL , "Sampling_2" : MC.PHASE_V_CURR_CHANNEL}
   ,{"Sector": 4 , "Sampling_1" : MC.PHASE_U_CURR_CHANNEL , "Sampling_2" : MC.PHASE_V_CURR_CHANNEL}
   ,{"Sector": 5 , "Sampling_1" : MC.PHASE_U_CURR_CHANNEL , "Sampling_2" : MC.PHASE_V_CURR_CHANNEL}
   ,{"Sector": 6 , "Sampling_1" : MC.PHASE_U_CURR_CHANNEL , "Sampling_2" : MC.PHASE_V_CURR_CHANNEL}
   ] > 
<#assign ADCConfig_2OPAMP2 =
  [ {"Sector": 1 , "Sampling_1" : MC.PHASE_U_CURR_CHANNEL2 , "Sampling_2" : MC.PHASE_V_CURR_CHANNEL2}
   ,{"Sector": 2 , "Sampling_1" : MC.PHASE_U_CURR_CHANNEL2 , "Sampling_2" : MC.PHASE_V_CURR_CHANNEL2}
   ,{"Sector": 3 , "Sampling_1" : MC.PHASE_U_CURR_CHANNEL2 , "Sampling_2" : MC.PHASE_V_CURR_CHANNEL2}
   ,{"Sector": 4 , "Sampling_1" : MC.PHASE_U_CURR_CHANNEL2 , "Sampling_2" : MC.PHASE_V_CURR_CHANNEL2}
   ,{"Sector": 5 , "Sampling_1" : MC.PHASE_U_CURR_CHANNEL2 , "Sampling_2" : MC.PHASE_V_CURR_CHANNEL2}
   ,{"Sector": 6 , "Sampling_1" : MC.PHASE_U_CURR_CHANNEL2 , "Sampling_2" : MC.PHASE_V_CURR_CHANNEL2}
   ] >    
<#assign ADCConfig_Shared_PHB =
  [ {"Sector": 1 , "Sampling_1" : MC.PHASE_V_CURR_CHANNEL , "Sampling_2" : MC.PHASE_W_CURR_CHANNEL}
   ,{"Sector": 2 , "Sampling_1" : MC.PHASE_U_CURR_CHANNEL , "Sampling_2" : MC.PHASE_W_CURR_CHANNEL}
   ,{"Sector": 3 , "Sampling_1" : MC.PHASE_U_CURR_CHANNEL , "Sampling_2" : MC.PHASE_W_CURR_CHANNEL}
   ,{"Sector": 4 , "Sampling_1" : MC.PHASE_U_CURR_CHANNEL , "Sampling_2" : MC.PHASE_V_CURR_CHANNEL}
   ,{"Sector": 5 , "Sampling_1" : MC.PHASE_U_CURR_CHANNEL , "Sampling_2" : MC.PHASE_V_CURR_CHANNEL}
   ,{"Sector": 6 , "Sampling_1" : MC.PHASE_V_CURR_CHANNEL , "Sampling_2" : MC.PHASE_W_CURR_CHANNEL}
   ] >   
   
 <#assign ADCDataRead_Shared_PHB =  
   [ {"Sector": 1 , "Sampling_1" : MC.ADC_1_PERIPH , "Sampling_2" : MC.ADC_2_PERIPH}
    ,{"Sector": 2 , "Sampling_1" : MC.ADC_1_PERIPH , "Sampling_2" : MC.ADC_2_PERIPH}
    ,{"Sector": 3 , "Sampling_1" : MC.ADC_1_PERIPH , "Sampling_2" : MC.ADC_2_PERIPH}
    ,{"Sector": 4 , "Sampling_1" : MC.ADC_1_PERIPH , "Sampling_2" : MC.ADC_2_PERIPH}
    ,{"Sector": 5 , "Sampling_1" : MC.ADC_1_PERIPH , "Sampling_2" : MC.ADC_2_PERIPH}
    ,{"Sector": 6 , "Sampling_1" : MC.ADC_1_PERIPH , "Sampling_2" : MC.ADC_2_PERIPH}
   ] >   

<#assign ADCConfig_Shared_PHB2 =
  [ {"Sector": 1 , "Sampling_1" : MC.PHASE_V_CURR_CHANNEL2 , "Sampling_2" : MC.PHASE_W_CURR_CHANNEL2}
   ,{"Sector": 2 , "Sampling_1" : MC.PHASE_U_CURR_CHANNEL2 , "Sampling_2" : MC.PHASE_W_CURR_CHANNEL2}
   ,{"Sector": 3 , "Sampling_1" : MC.PHASE_U_CURR_CHANNEL2 , "Sampling_2" : MC.PHASE_W_CURR_CHANNEL2}
   ,{"Sector": 4 , "Sampling_1" : MC.PHASE_U_CURR_CHANNEL2 , "Sampling_2" : MC.PHASE_V_CURR_CHANNEL2}
   ,{"Sector": 5 , "Sampling_1" : MC.PHASE_U_CURR_CHANNEL2 , "Sampling_2" : MC.PHASE_V_CURR_CHANNEL2}
   ,{"Sector": 6 , "Sampling_1" : MC.PHASE_V_CURR_CHANNEL2 , "Sampling_2" : MC.PHASE_W_CURR_CHANNEL2}
   ] >   
   
 <#assign ADCDataRead_Shared_PHB2 =  
   [ {"Sector": 1 , "Sampling_1" : MC.ADC_1_PERIPH2 , "Sampling_2" : MC.ADC_2_PERIPH2}
    ,{"Sector": 2 , "Sampling_1" : MC.ADC_1_PERIPH2 , "Sampling_2" : MC.ADC_2_PERIPH2}
    ,{"Sector": 3 , "Sampling_1" : MC.ADC_1_PERIPH2 , "Sampling_2" : MC.ADC_2_PERIPH2}
    ,{"Sector": 4 , "Sampling_1" : MC.ADC_1_PERIPH2 , "Sampling_2" : MC.ADC_2_PERIPH2}
    ,{"Sector": 5 , "Sampling_1" : MC.ADC_1_PERIPH2 , "Sampling_2" : MC.ADC_2_PERIPH2}
    ,{"Sector": 6 , "Sampling_1" : MC.ADC_1_PERIPH2 , "Sampling_2" : MC.ADC_2_PERIPH2}
   ] >
<#assign ADCConfig_Shared_PHA =
  [ {"Sector": 1 , "Sampling_1" : MC.PHASE_V_CURR_CHANNEL , "Sampling_2" : MC.PHASE_W_CURR_CHANNEL}
   ,{"Sector": 2 , "Sampling_1" : MC.PHASE_U_CURR_CHANNEL , "Sampling_2" : MC.PHASE_W_CURR_CHANNEL}
   ,{"Sector": 3 , "Sampling_1" : MC.PHASE_U_CURR_CHANNEL , "Sampling_2" : MC.PHASE_W_CURR_CHANNEL}
   ,{"Sector": 4 , "Sampling_1" : MC.PHASE_V_CURR_CHANNEL , "Sampling_2" : MC.PHASE_U_CURR_CHANNEL}
   ,{"Sector": 5 , "Sampling_1" : MC.PHASE_V_CURR_CHANNEL , "Sampling_2" : MC.PHASE_U_CURR_CHANNEL}
   ,{"Sector": 6 , "Sampling_1" : MC.PHASE_V_CURR_CHANNEL , "Sampling_2" : MC.PHASE_W_CURR_CHANNEL}
   ] >   
   
 <#assign ADCDataRead_Shared_PHA =  
   [ {"Sector": 1 , "Sampling_1" : MC.ADC_1_PERIPH , "Sampling_2" : MC.ADC_2_PERIPH}
    ,{"Sector": 2 , "Sampling_1" : MC.ADC_1_PERIPH , "Sampling_2" : MC.ADC_2_PERIPH}
    ,{"Sector": 3 , "Sampling_1" : MC.ADC_1_PERIPH , "Sampling_2" : MC.ADC_2_PERIPH}
    ,{"Sector": 4 , "Sampling_1" : MC.ADC_2_PERIPH , "Sampling_2" : MC.ADC_1_PERIPH}
    ,{"Sector": 5 , "Sampling_1" : MC.ADC_2_PERIPH , "Sampling_2" : MC.ADC_1_PERIPH}
    ,{"Sector": 6 , "Sampling_1" : MC.ADC_1_PERIPH , "Sampling_2" : MC.ADC_2_PERIPH}
   ] >  
<#assign ADCConfig_Shared_PHA2 =
  [ {"Sector": 1 , "Sampling_1" : MC.PHASE_V_CURR_CHANNEL2 , "Sampling_2" : MC.PHASE_W_CURR_CHANNEL2}
   ,{"Sector": 2 , "Sampling_1" : MC.PHASE_U_CURR_CHANNEL2 , "Sampling_2" : MC.PHASE_W_CURR_CHANNEL2}
   ,{"Sector": 3 , "Sampling_1" : MC.PHASE_U_CURR_CHANNEL2 , "Sampling_2" : MC.PHASE_W_CURR_CHANNEL2}
   ,{"Sector": 4 , "Sampling_1" : MC.PHASE_V_CURR_CHANNEL2 , "Sampling_2" : MC.PHASE_U_CURR_CHANNEL2}
   ,{"Sector": 5 , "Sampling_1" : MC.PHASE_V_CURR_CHANNEL2 , "Sampling_2" : MC.PHASE_U_CURR_CHANNEL2}
   ,{"Sector": 6 , "Sampling_1" : MC.PHASE_V_CURR_CHANNEL2 , "Sampling_2" : MC.PHASE_W_CURR_CHANNEL2}
   ] >   
   
<#assign ADCDataRead_Shared_PHA2 =  
   [ {"Sector": 1 , "Sampling_1" : MC.ADC_1_PERIPH2 , "Sampling_2" : MC.ADC_2_PERIPH2}
    ,{"Sector": 2 , "Sampling_1" : MC.ADC_1_PERIPH2 , "Sampling_2" : MC.ADC_2_PERIPH2}
    ,{"Sector": 3 , "Sampling_1" : MC.ADC_1_PERIPH2 , "Sampling_2" : MC.ADC_2_PERIPH2}
    ,{"Sector": 4 , "Sampling_1" : MC.ADC_2_PERIPH2 , "Sampling_2" : MC.ADC_1_PERIPH2}
    ,{"Sector": 5 , "Sampling_1" : MC.ADC_2_PERIPH2 , "Sampling_2" : MC.ADC_1_PERIPH2}
    ,{"Sector": 6 , "Sampling_1" : MC.ADC_1_PERIPH2 , "Sampling_2" : MC.ADC_2_PERIPH2}
   ] > 
<#assign ADCConfig_Shared_PHC =
  [ {"Sector": 1 , "Sampling_1" : MC.PHASE_W_CURR_CHANNEL , "Sampling_2" : MC.PHASE_V_CURR_CHANNEL}
   ,{"Sector": 2 , "Sampling_1" : MC.PHASE_U_CURR_CHANNEL , "Sampling_2" : MC.PHASE_W_CURR_CHANNEL}
   ,{"Sector": 3 , "Sampling_1" : MC.PHASE_U_CURR_CHANNEL , "Sampling_2" : MC.PHASE_W_CURR_CHANNEL}
   ,{"Sector": 4 , "Sampling_1" : MC.PHASE_U_CURR_CHANNEL , "Sampling_2" : MC.PHASE_V_CURR_CHANNEL}
   ,{"Sector": 5 , "Sampling_1" : MC.PHASE_U_CURR_CHANNEL , "Sampling_2" : MC.PHASE_V_CURR_CHANNEL}
   ,{"Sector": 6 , "Sampling_1" : MC.PHASE_W_CURR_CHANNEL , "Sampling_2" : MC.PHASE_V_CURR_CHANNEL}
   ] >   
   
 <#assign ADCDataRead_Shared_PHC =  
   [ {"Sector": 1 , "Sampling_1" : MC.ADC_2_PERIPH , "Sampling_2" : MC.ADC_1_PERIPH}
    ,{"Sector": 2 , "Sampling_1" : MC.ADC_1_PERIPH , "Sampling_2" : MC.ADC_2_PERIPH}
    ,{"Sector": 3 , "Sampling_1" : MC.ADC_1_PERIPH , "Sampling_2" : MC.ADC_2_PERIPH}
    ,{"Sector": 4 , "Sampling_1" : MC.ADC_1_PERIPH , "Sampling_2" : MC.ADC_2_PERIPH}
    ,{"Sector": 5 , "Sampling_1" : MC.ADC_1_PERIPH , "Sampling_2" : MC.ADC_2_PERIPH}
    ,{"Sector": 6 , "Sampling_1" : MC.ADC_2_PERIPH , "Sampling_2" : MC.ADC_1_PERIPH}
   ] >     
<#assign ADCConfig_Shared_PHC2 =
  [ {"Sector": 1 , "Sampling_1" : MC.PHASE_W_CURR_CHANNEL2 , "Sampling_2" : MC.PHASE_V_CURR_CHANNEL2}
   ,{"Sector": 2 , "Sampling_1" : MC.PHASE_U_CURR_CHANNEL2 , "Sampling_2" : MC.PHASE_W_CURR_CHANNEL2}
   ,{"Sector": 3 , "Sampling_1" : MC.PHASE_U_CURR_CHANNEL2 , "Sampling_2" : MC.PHASE_W_CURR_CHANNEL2}
   ,{"Sector": 4 , "Sampling_1" : MC.PHASE_U_CURR_CHANNEL2 , "Sampling_2" : MC.PHASE_V_CURR_CHANNEL2}
   ,{"Sector": 5 , "Sampling_1" : MC.PHASE_U_CURR_CHANNEL2 , "Sampling_2" : MC.PHASE_V_CURR_CHANNEL2}
   ,{"Sector": 6 , "Sampling_1" : MC.PHASE_W_CURR_CHANNEL2 , "Sampling_2" : MC.PHASE_V_CURR_CHANNEL2}
   ] >   
   
 <#assign ADCDataRead_Shared_PHC2 =  
   [ {"Sector": 1 , "Sampling_1" : MC.ADC_2_PERIPH2 , "Sampling_2" : MC.ADC_1_PERIPH2}
    ,{"Sector": 2 , "Sampling_1" : MC.ADC_1_PERIPH2 , "Sampling_2" : MC.ADC_2_PERIPH2}
    ,{"Sector": 3 , "Sampling_1" : MC.ADC_1_PERIPH2 , "Sampling_2" : MC.ADC_2_PERIPH2}
    ,{"Sector": 4 , "Sampling_1" : MC.ADC_1_PERIPH2 , "Sampling_2" : MC.ADC_2_PERIPH2}
    ,{"Sector": 5 , "Sampling_1" : MC.ADC_1_PERIPH2 , "Sampling_2" : MC.ADC_2_PERIPH2}
    ,{"Sector": 6 , "Sampling_1" : MC.ADC_2_PERIPH2 , "Sampling_2" : MC.ADC_1_PERIPH2}
   ] >    
<#function OPAMPPhase_Input Sector Input Motor=1>
 <#if MC.THREE_SHUNT_INDEPENDENT_RESOURCES || MC.THREE_SHUNT_INDEPENDENT_RESOURCES2 >
   <#if Motor == 1>
     <#local OPAMPMapp = OPAMPInputMapp_Shared_PHB >
   <#else> <#-- Motor 2 -->
     <#local OPAMPMapp = OPAMPInputMapp_Shared_PHB2 >
   </#if>  
 <#elseif MC.THREE_SHUNT_SHARED_RESOURCES || MC.THREE_SHUNT_SHARED_RESOURCES2 >
   <#if Motor == 1>
     <#local OPAMPMapp = OPAMPInputMapp_Shared_PHA >
   <#else> <#-- Motor 2 -->
     <#local OPAMPMapp = OPAMPInputMapp_Shared_PHA2 >
   </#if> 
 </#if>  
 <#list OPAMPMapp as OPAMPItem >
   <#if OPAMPItem.Sector == Sector >
      <#if Input == "INPUT_1" >
        <#return OPAMPItem.INPUT_1>
      <#else>
        <#return OPAMPItem.INPUT_2>
      </#if>      
   </#if>
 </#list> 
</#function>

<#function ADCDataRead Sector Sampling Motor=1>
 <#if MC.THREE_SHUNT_INDEPENDENT_RESOURCES || MC.THREE_SHUNT_INDEPENDENT_RESOURCES2 >
   <#if Motor == 1>
     <#local ADCMapp = ADCDataRead_Shared_PHB >
   <#else> <#-- Motor 2 -->
     <#local ADCMapp = ADCDataRead_Shared_PHB2 >
   </#if>  
 <#elseif MC.THREE_SHUNT_SHARED_RESOURCES || MC.THREE_SHUNT_SHARED_RESOURCES2 >
   <#local ADCMapp = ADCDataRead_Shared_PHA >
 </#if>  
 <#list ADCMapp as ADCItem >
   <#if ADCItem.Sector == Sector >
      <#if Sampling == "Sampling_1" >
        <#return "&"+ADCItem.Sampling_1+"->JDR1">
      <#else>
        <#return "&"+ADCItem.Sampling_2+"->JDR1">
      </#if>      
   </#if>
 </#list> 
</#function>

<#function ADCConfig Sector Sampling Motor=1>     
  <#if Motor == 1>
    <#local Timer = MC.PWM_TIMER_SELECTION>
    <#if _last_word(Timer) != "TIM1" >
      <#if MC.ADC_1_PERIPH == "ADC1">
        <#local ADCSuffix1 = "_ADC12" >
      <#elseif MC.ADC_1_PERIPH == "ADC3"> 
        <#local ADCSuffix1 = "__ADC34" > 
      </#if>
      <#if MC.ADC_2_PERIPH == "ADC1">
        <#local ADCSuffix2 = "_ADC12" >
      <#elseif MC.ADC_2_PERIPH == "ADC3"> 
        <#local ADCSuffix2 = "__ADC34" > 
      </#if>        
    <#else>
      <#local ADCSuffix1 ="" >
      <#local ADCSuffix2 ="" >
    </#if>  
    <#if MC.USE_INTERNAL_OPAMP >
      <#local ADCConfigMap = ADCConfig_2OPAMP>
    <#else>
      <#if MC.THREE_SHUNT_INDEPENDENT_RESOURCES >
        <#local ADCConfigMap = ADCConfig_Shared_PHB >
      <#else>
        <#local ADCConfigMap = ADCConfig_Shared_PHA >
      </#if>
    </#if> 
 <#else> <#-- Motor2-->
    <#local Timer = MC.PWM_TIMER_SELECTION2>
    <#if _last_word(Timer) != "TIM1" >
      <#if MC.ADC_1_PERIPH2 == "ADC1">
        <#local ADCSuffix1 = "_ADC12" >
      <#elseif MC.ADC_1_PERIPH2 == "ADC3"> 
        <#local ADCSuffix1 = "__ADC34" > 
      </#if>
      <#if MC.ADC_2_PERIPH2 == "ADC1">
        <#local ADCSuffix2 = "_ADC12" >
      <#elseif MC.ADC_2_PERIPH2 == "ADC3"> 
        <#local ADCSuffix2 = "__ADC34" > 
      </#if>        
    <#else>
      <#local ADCSuffix1 ="" >
      <#local ADCSuffix2 ="" >
    </#if>      
    <#if MC.USE_INTERNAL_OPAMP2 >
      <#local ADCConfigMap = ADCConfig_2OPAMP2>
    <#else>
      <#if MC.THREE_SHUNT_INDEPENDENT_RESOURCES2 >
        <#local ADCConfigMap = ADCConfig_Shared_PHB2 >
      <#else>
        <#local ADCConfigMap = ADCConfig_Shared_PHA >
      </#if>
    </#if> 
  </#if>
 <#list ADCConfigMap as ADCItem >
   <#if ADCItem.Sector == Sector >
      <#if Sampling == "Sampling_1" >
       <#-- <#return "MC_"+ADCItem.Sampling_1+"<<ADC_JSQR_JSQ1_Pos | (LL_ADC_INJ_TRIG_EXT_${_last_word(Timer)}_CH4"+ADCSuffix1+" & ~ADC_INJ_TRIG_EXT_EDGE_DEFAULT)"-->
        <#return "MC_"+ADCItem.Sampling_1+"<<ADC_JSQR_JSQ1_Pos | (LL_ADC_INJ_TRIG_EXT_${_last_word(Timer)}_TRGO & ~ADC_INJ_TRIG_EXT_EDGE_DEFAULT)">
      <#else>
      <#--  <#return "MC_"+ADCItem.Sampling_2+"<<ADC_JSQR_JSQ1_Pos | (LL_ADC_INJ_TRIG_EXT_${_last_word(Timer)}_CH4"+ADCSuffix2+" & ~ADC_INJ_TRIG_EXT_EDGE_DEFAULT)"-->
        <#return "MC_"+ADCItem.Sampling_2+"<<ADC_JSQR_JSQ1_Pos | (LL_ADC_INJ_TRIG_EXT_${_last_word(Timer)}_TRGO & ~ADC_INJ_TRIG_EXT_EDGE_DEFAULT)">
      </#if>      
   </#if>
 </#list> 
</#function>

<#-- Condition for STM32F302x8x MCU -->
<#assign CondMcu_STM32F302x8x = (McuName?? && McuName?matches("STM32F302.8.*"))>
<#-- Condition for STM32F072xxx MCU -->
<#assign CondMcu_STM32F072xxx = (McuName?? && McuName?matches("STM32F072.*"))>
<#-- Condition for STM32F446xCx or STM32F446xEx -->
<#assign CondMcu_STM32F446xCEx = (McuName?? && McuName?matches("STM32F446.(C|E).*"))>
<#-- Condition for Line STM32F1xx Value -->
<#assign CondLine_STM32F1_Value = (McuName?? && ((McuName?matches("STM32F100.(4|6|8|B).*")))) >
<#-- Condition for Line STM32F1xx Value, Medium Density -->
<#assign CondLine_STM32F1_Value_MD = (McuName?? && ((McuName?matches("STM32F100.(8|B).*"))))>
<#-- Condition for Line STM32F1xx Performance -->
<#assign CondLine_STM32F1_Performance = (McuName?? && McuName?matches("STM32F103.(4|6|8|B).*"))>
<#-- Condition for Line STM32F1xx Performance, Medium Density -->
<#assign CondLine_STM32F1_Performance_MD = (McuName?? && McuName?matches("STM32F103.(8|B).*"))>
<#-- Condition for Line STM32F1xx High Density -->
<#assign CondLine_STM32F1_HD = (McuName?? && McuName?matches("STM32F103.(C|D|E|F|G).*"))>
<#-- Condition for STM32F0 Family -->
<#assign CondFamily_STM32F0 = (FamilyName?? && FamilyName=="STM32F0")>
<#-- Condition for STM32F1 Family -->
<#assign CondFamily_STM32F1 = (CondLine_STM32F1_Value || CondLine_STM32F1_Performance || CondLine_STM32F1_HD)>
<#-- Condition for STM32F3 Family -->
<#assign CondFamily_STM32F3 = (FamilyName?? && FamilyName == "STM32F3") >
<#-- Condition for STM32F4 Family -->
<#assign CondFamily_STM32F4 = (FamilyName?? && FamilyName == "STM32F4") >
<#-- Condition for STM32G4 Family -->
<#assign CondFamily_STM32G4 = (FamilyName?? && FamilyName == "STM32G4") >
<#-- Condition for STM32L4 Family -->
<#assign CondFamily_STM32L4 = (FamilyName?? && FamilyName == "STM32L4") >
<#-- Condition for STM32F7 Family -->
<#assign CondFamily_STM32F7 = (FamilyName?? && FamilyName == "STM32F7") >
<#-- Condition for STM32F7 Family -->
<#assign CondFamily_STM32H7 = (FamilyName?? && FamilyName == "STM32H7") >
<#-- Condition for STM32G0 Family -->
<#assign CondFamily_STM32G0 = (FamilyName?? && FamilyName == "STM32G0") >

<#function _last_word text sep="_"><#return text?split(sep)?last></#function>
<#function _first_word text sep="_"><#return text?split(sep)?first></#function>

<#function _filter_opamp opamp >
  <#if opamp == "OPAMP1" >
   <#return "OPAMP" >   
  <#else>
   <#return opamp >
  </#if>
</#function>

<#macro setScandir Ph1 Ph2>
<#if Ph1?number < Ph2?number>
   LL_ADC_REG_SEQ_SCAN_DIR_FORWARD>>ADC_CFGR1_SCANDIR_Pos,
<#else>
   LL_ADC_REG_SEQ_SCAN_DIR_BACKWARD>>ADC_CFGR1_SCANDIR_Pos,
</#if>
<#return>
</#macro>
/**
  ******************************************************************************
  * @file    mc_parameters.c
  * @author  Motor Control SDK Team, ST Microelectronics
  * @brief   This file provides definitions of HW parameters specific to the 
  *          configuration of the subsystem.
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
#include "parameters_conversion.h"
<#if CondFamily_STM32F4 > 
  <#if MC.SINGLE_SHUNT2 == true || MC.SINGLE_SHUNT == true >
#include "r1_f4xx_pwm_curr_fdbk.h"
  </#if>
  <#if MC.THREE_SHUNT == true >
#include "r3_1_f4xx_pwm_curr_fdbk.h"
  </#if>
  <#if MC.THREE_SHUNT_INDEPENDENT_RESOURCES == true || MC.THREE_SHUNT_INDEPENDENT_RESOURCES2 == true >
#include "r3_2_f4xx_pwm_curr_fdbk.h"
  </#if>
  <#if MC.ICS_SENSORS == true || MC.ICS_SENSORS2 == true >
#include "ics_f4xx_pwm_curr_fdbk.h"  
  </#if>
</#if>
<#if CondFamily_STM32F0 > 
  <#if MC.THREE_SHUNT == true >
#include "r3_f0xx_pwm_curr_fdbk.h"
  </#if>
  <#if MC.SINGLE_SHUNT == true >
#include "r1_f0xx_pwm_curr_fdbk.h"
  </#if>
</#if>
<#if CondFamily_STM32F3 > <#-- CondFamily_STM32F3 --->
  <#if MC.SINGLE_SHUNT || MC.SINGLE_SHUNT2 >
#include "r1_f30x_pwm_curr_fdbk.h"
  </#if>
  <#if MC.ICS_SENSORS ||  MC.ICS_SENSORS2>
#include "ics_f30x_pwm_curr_fdbk.h"
  </#if>
  <#if  MC.THREE_SHUNT_INDEPENDENT_RESOURCES || MC.THREE_SHUNT_INDEPENDENT_RESOURCES2 ||
        MC.THREE_SHUNT_SHARED_RESOURCES  || MC.THREE_SHUNT_SHARED_RESOURCES2>
#include "r3_2_f30x_pwm_curr_fdbk.h"
  </#if>
  <#if  MC.THREE_SHUNT  >
#include "r3_1_f30x_pwm_curr_fdbk.h"
  </#if>
</#if> <#-- CondFamily_STM32F3 --->
<#if CondFamily_STM32G4 > <#-- CondFamily_STM32G4 --->
 <#if MC.SINGLE_SHUNT || MC.SINGLE_SHUNT2 >
#include "r1_g4xx_pwm_curr_fdbk.h"
  </#if>
  <#if  MC.THREE_SHUNT_INDEPENDENT_RESOURCES || MC.THREE_SHUNT_INDEPENDENT_RESOURCES2 >
#include "r3_2_g4xx_pwm_curr_fdbk.h"
  </#if>
  <#if MC.ICS_SENSORS ||  MC.ICS_SENSORS2>
#include "ics_g4xx_pwm_curr_fdbk.h"
  </#if>  
</#if> <#-- CondFamily_STM32G4 --->
<#if CondFamily_STM32G0 > <#-- CondFamily_STM32G0 --->
 <#if MC.SINGLE_SHUNT >
#include "r1_g0xx_pwm_curr_fdbk.h"
  </#if>
  <#if  MC.THREE_SHUNT  >
#include "r3_g0xx_pwm_curr_fdbk.h"
  </#if>
</#if> <#-- CondFamily_STM32G4 --->
<#if CondFamily_STM32L4 > <#-- CondFamily_STM32L4 --->
  <#if MC.SINGLE_SHUNT >
#include "r1_l4xx_pwm_curr_fdbk.h"
  </#if>
  <#if MC.ICS_SENSORS >
#include "ics_l4xx_pwm_curr_fdbk.h"
  </#if>
  <#if  MC.THREE_SHUNT_INDEPENDENT_RESOURCES  >
#include "r3_2_l4xx_pwm_curr_fdbk.h"
  </#if>
  <#if  MC.THREE_SHUNT  >
#include "r3_1_l4xx_pwm_curr_fdbk.h"
  </#if>
</#if> <#-- CondFamily_STM32L4 --->
<#if CondFamily_STM32F7 > <#-- CondFamily_STM32F7 --->
  <#if MC.SINGLE_SHUNT >
#include "r1_f7xx_pwm_curr_fdbk.h"
  </#if>
  <#if MC.ICS_SENSORS >
#include "ics_f7xx_pwm_curr_fdbk.h"
  </#if>
  <#if  MC.THREE_SHUNT_INDEPENDENT_RESOURCES  >
#include "r3_2_f7xx_pwm_curr_fdbk.h"
  </#if>
  <#if  MC.THREE_SHUNT  >
#include "r3_1_f7xx_pwm_curr_fdbk.h"
  </#if>
</#if> <#-- CondFamily_STM32F7 --->
<#if CondFamily_STM32H7 > <#-- CondFamily_STM32H7 --->
  <#if MC.SINGLE_SHUNT || MC.SINGLE_SHUNT2 >
#error " H7 Single shunt not supported yet "
  </#if>
  <#if MC.ICS_SENSORS ||  MC.ICS_SENSORS2>
#error " H7 Single shunt not supported yet "
  </#if>
  <#if  MC.THREE_SHUNT_INDEPENDENT_RESOURCES || MC.THREE_SHUNT_INDEPENDENT_RESOURCES2 ||
        MC.THREE_SHUNT_SHARED_RESOURCES  || MC.THREE_SHUNT_SHARED_RESOURCES2>
#include "r3_2_h7xx_pwm_curr_fdbk.h"
  </#if>

  <#if  MC.THREE_SHUNT  >
#include "r3_1_f30x_pwm_curr_fdbk.h"
  </#if>
</#if> <#-- CondFamily_STM32F3 --->
<#if (CondFamily_STM32F1) && MC.THREE_SHUNT == true > <#-- CondFamily_STM32F1 -->
#include "r3_2_f1xx_pwm_curr_fdbk.h"
</#if> 
<#if CondLine_STM32F1_HD && MC.SINGLE_SHUNT == true >
#include "r1_hd2_pwm_curr_fdbk.h"
</#if>
<#if CondLine_STM32F1_Performance && MC.SINGLE_SHUNT == true >
#include "r1_vl1_pwm_curr_fdbk.h"
</#if>   
<#if CondLine_STM32F1_HD && MC.ICS_SENSORS == true >
#include "ics_hd2_pwm_curr_fdbk.h"  
</#if>
<#-- CondFamily_STM32F1 HD/MD --->
<#if CondLine_STM32F1_Performance && MC.ICS_SENSORS == true >
#include "ics_lm1_pwm_curr_fdbk.h"
</#if> <#-- CondFamily_STM32F1 --->
<#if MC.PFC_ENABLED == true>
#include "pfc.h"
</#if>
<#if MC.MOTOR_PROFILER == true>
#include "mp_self_com_ctrl.h"
#include "mp_one_touch_tuning.h"
</#if>

/* USER CODE BEGIN Additional include */

/* USER CODE END Additional include */  

<#if MC.SINGLEDRIVE == true>
#define FREQ_RATIO 1                /* Dummy value for single drive */
#define FREQ_RELATION HIGHEST_FREQ  /* Dummy value for single drive */
</#if> 
<#if CondFamily_STM32F0 || CondFamily_STM32G0 > 
<#if MC.THREE_SHUNT>
extern  PWMC_R3_1_Handle_t PWM_Handle_M1;
</#if> <#-- MC.THREE_SHUNT -->
</#if> <#-- CondFamily_STM32F0 || CondFamily_STM32G0 -->

<#if CondFamily_STM32F4 > 
  <#if MC.THREE_SHUNT_INDEPENDENT_RESOURCES2 == true> <#-- inside CondFamily_STM32F4 -->
/**
  * @brief  Current sensor parameters Motor 2 - three shunt
  */
const R3_2_Params_t R3_2_ParamsM2 =
{

/* Dual MC parameters --------------------------------------------------------*/
  .Tw               = MAX_TWAIT2,                   
  .bFreqRatio       = FREQ_RATIO,                   
  .bIsHigherFreqTim = FREQ_RELATION2,               

  .ADCx_1                  = ${MC.ADC_1_PERIPH2},                 
  .ADCx_2                  = ${MC.ADC_2_PERIPH2},
                                            
/* PWM generation parameters --------------------------------------------------*/
  .TIMx               = ${_last_word(MC.PWM_TIMER_SELECTION2)},
  .hDeadTime          = DEAD_TIME_COUNTS2,
  .RepetitionCounter = REP_COUNTER2,
  .hTafter            = TW_AFTER2,
  .hTbefore           = TW_BEFORE2,
  
/* PWM Driving signals initialization ----------------------------------------*/
  .LowSideOutputs = (LowSideOutputsFunction_t)LOW_SIDE_SIGNALS_ENABLING2,
<#if MC.LOW_SIDE_SIGNALS_ENABLING2 == "ES_GPIO"> 
<#if MC.SHARED_SIGNAL_ENABLE2 == false>
  .pwm_en_u_port     = M2_PWM_EN_U_GPIO_Port,
  .pwm_en_u_pin      = M2_PWM_EN_U_Pin,
  .pwm_en_v_port     = M2_PWM_EN_V_GPIO_Port,
  .pwm_en_v_pin      = M2_PWM_EN_V_Pin,
  .pwm_en_w_port     = M2_PWM_EN_W_GPIO_Port,
  .pwm_en_w_pin      = M2_PWM_EN_W_Pin,    
<#else>
  .pwm_en_u_port     = M2_PWM_EN_UVW_GPIO_Port,
  .pwm_en_u_pin      = M2_PWM_EN_UVW_Pin,
  .pwm_en_v_port     = M2_PWM_EN_UVW_GPIO_Port,
  .pwm_en_v_pin      = M2_PWM_EN_UVW_Pin,
  .pwm_en_w_port     = M2_PWM_EN_UVW_GPIO_Port,
  .pwm_en_w_pin      = M2_PWM_EN_UVW_Pin, 
</#if>    
</#if>

  .ADCConfig1 = {   MC_${MC.PHASE_V_CURR_CHANNEL2}<<ADC_JSQR_JSQ4_Pos
                   ,MC_${MC.PHASE_U_CURR_CHANNEL2}<<ADC_JSQR_JSQ4_Pos
                   ,MC_${MC.PHASE_U_CURR_CHANNEL2}<<ADC_JSQR_JSQ4_Pos
                   ,MC_${MC.PHASE_U_CURR_CHANNEL2}<<ADC_JSQR_JSQ4_Pos
                   ,MC_${MC.PHASE_U_CURR_CHANNEL2}<<ADC_JSQR_JSQ4_Pos
                   ,MC_${MC.PHASE_V_CURR_CHANNEL2}<<ADC_JSQR_JSQ4_Pos
                  },

  .ADCConfig2 = {   MC_${MC.PHASE_W_CURR_CHANNEL2}<<ADC_JSQR_JSQ4_Pos
                   ,MC_${MC.PHASE_W_CURR_CHANNEL2}<<ADC_JSQR_JSQ4_Pos
                   ,MC_${MC.PHASE_W_CURR_CHANNEL2}<<ADC_JSQR_JSQ4_Pos
                   ,MC_${MC.PHASE_V_CURR_CHANNEL2}<<ADC_JSQR_JSQ4_Pos
                   ,MC_${MC.PHASE_V_CURR_CHANNEL2}<<ADC_JSQR_JSQ4_Pos
                   ,MC_${MC.PHASE_W_CURR_CHANNEL2}<<ADC_JSQR_JSQ4_Pos
                  },

  .ADCDataReg1 = {  &${MC.ADC_1_PERIPH2}->JDR1 // Phase B, Phase C
                   ,&${MC.ADC_1_PERIPH2}->JDR1 // Phase A, Phase C
                   ,&${MC.ADC_1_PERIPH2}->JDR1 // Phase A, Phase C
                   ,&${MC.ADC_1_PERIPH2}->JDR1 // Phase A, Phase B
                   ,&${MC.ADC_1_PERIPH2}->JDR1 // Phase A, Phase B
                   ,&${MC.ADC_1_PERIPH2}->JDR1 // Phase B, Phase C
                  },

  .ADCDataReg2 = {  &${MC.ADC_2_PERIPH2}->JDR1  // Phase B, Phase C
                   ,&${MC.ADC_2_PERIPH2}->JDR1  // Phase A, Phase C
                   ,&${MC.ADC_2_PERIPH2}->JDR1  // Phase A, Phase C
                   ,&${MC.ADC_2_PERIPH2}->JDR1  // Phase A, Phase B
                   ,&${MC.ADC_2_PERIPH2}->JDR1  // Phase A, Phase B
                   ,&${MC.ADC_2_PERIPH2}->JDR1  // Phase B, Phase C
                   },

   
/* PWM Driving signals initialization ----------------------------------------*/
  .EmergencyStop = (FunctionalState) <#if MC.SW_OV_CURRENT_PROT_ENABLING2==true>ENABLE<#else>DISABLE</#if>,
};
  </#if> <#-- MC.THREE_SHUNT_INDEPENDENT_RESOURCES2 == true -->

  <#if MC.SINGLE_SHUNT2 == true>  <#-- insidde CondFamily_STM32F4 -->
/**
  * @brief  Current sensor parameters Dual Drive Motor 2 - one shunt
  */
const R1_F4_Params_t R1_F4_ParamsM2 =
{

/* Instance number -----------------------------------------------------------*/
  .bFreqRatio          = FREQ_RATIO,
  .bIsHigherFreqTim    = FREQ_RELATION2,
  
/* Current reading A/D Conversions initialization -----------------------------*/
  .ADCx_Inj = ${MC.ADC_PERIPH2},
  .hIChannel       = MC_${MC.PHASE_CURRENTS_CHANNEL2},
  
/* PWM generation parameters --------------------------------------------------*/
  .TIMx                = ${_last_word(MC.PWM_TIMER_SELECTION2)},
  .TIMx_2             = <#if MC.ADC_PERIPH2 == "ADC3">TIM5<#else>TIM4</#if>,
  .hDeadTime          = DEAD_TIME_COUNTS2,    
  .RepetitionCounter = REP_COUNTER2,         
  .hTafter            = TAFTER2,  
  .hTbefore           = TBEFORE2, 
  .hTMin              = TMIN2,    
  .hHTMin             = HTMIN2,   
  .hTSample           = SAMPLING_TIME2, 
  .hMaxTrTs           = MAX_TRTS2,

/* PWM Driving signals initialization ----------------------------------------*/
  .LowSideOutputs = (LowSideOutputsFunction_t)LOW_SIDE_SIGNALS_ENABLING2,
<#if MC.LOW_SIDE_SIGNALS_ENABLING2 == "ES_GPIO"> 
<#if MC.SHARED_SIGNAL_ENABLE2 == false>
  .pwm_en_u_port     = M2_PWM_EN_U_GPIO_Port,  
  .pwm_en_u_pin      = M2_PWM_EN_U_Pin,        
  .pwm_en_v_port     = M2_PWM_EN_V_GPIO_Port,  
  .pwm_en_v_pin      = M2_PWM_EN_V_Pin,        
  .pwm_en_w_port     = M2_PWM_EN_W_GPIO_Port,  
  .pwm_en_w_pin      = M2_PWM_EN_W_Pin,   
<#else>
  .pwm_en_u_port     = M2_PWM_EN_UVW_GPIO_Port,  
  .pwm_en_u_pin      = M2_PWM_EN_UVW_Pin,        
  .pwm_en_v_port     = M2_PWM_EN_UVW_GPIO_Port,  
  .pwm_en_v_pin      = M2_PWM_EN_UVW_Pin,        
  .pwm_en_w_port     = M2_PWM_EN_UVW_GPIO_Port,  
  .pwm_en_w_pin      = M2_PWM_EN_UVW_Pin,     
</#if>                                                              
</#if>    <#-- MC.LOW_SIDE_SIGNALS_ENABLING2 == ES_GPIO -->                                           
/* Emergengy signal initialization ----------------------------------------*/
  .EmergencyStop = (FunctionalState) <#if MC.SW_OV_CURRENT_PROT_ENABLING2==true>ENABLE<#else>DISABLE</#if>,
};
  </#if> <#-- MC.SINGLE_SHUNT2 == true -->
  
    <#if MC.THREE_SHUNT == true > <#-- inside CondFamily_STM32F4 -->
  /**
  * @brief  Current sensor parameters Motor 1 - three shunt - STM32F401x8
  */
R3_1_Params_t R3_1_ParamsM1 =
{
/* Current reading A/D Conversions initialization -----------------------------*/
  .ADCx = ${MC.ADC_PERIPH},     
                                        
/* PWM generation parameters --------------------------------------------------*/
  .RepetitionCounter = REP_COUNTER,                       
  .hTafter            = TW_AFTER,                          
  .hTbefore           = TW_BEFORE_R3_1,                    
  .TIMx               = ${_last_word(MC.PWM_TIMER_SELECTION)},               
                                     
/* PWM Driving signals initialization ----------------------------------------*/
  .LowSideOutputs = (LowSideOutputsFunction_t)LOW_SIDE_SIGNALS_ENABLING, 
<#if MC.LOW_SIDE_SIGNALS_ENABLING == "ES_GPIO" >    
  .pwm_en_u_port = M1_PWM_EN_U_GPIO_Port,                                 
  .pwm_en_u_pin  = M1_PWM_EN_U_Pin,                    
  .pwm_en_v_port = M1_PWM_EN_V_GPIO_Port,                   
  .pwm_en_v_pin  = M1_PWM_EN_V_Pin,                    
  .pwm_en_w_port = M1_PWM_EN_W_GPIO_Port,                   
  .pwm_en_w_pin  = M1_PWM_EN_W_Pin,                    
<#else>
  .pwm_en_u_port = MC_NULL,                                 
  .pwm_en_u_pin  = (uint16_t) 0,                    
  .pwm_en_v_port = MC_NULL,                   
  .pwm_en_v_pin  = (uint16_t) 0,                    
  .pwm_en_w_port = MC_NULL,                   
  .pwm_en_w_pin  = (uint16_t) 0,  
</#if>

  .ADCConfig = {
                 MC_${MC.PHASE_V_CURR_CHANNEL}<<ADC_JSQR_JSQ3_Pos | MC_${MC.PHASE_W_CURR_CHANNEL}<<ADC_JSQR_JSQ4_Pos | 1<<ADC_JSQR_JL_Pos,
                 MC_${MC.PHASE_U_CURR_CHANNEL}<<ADC_JSQR_JSQ3_Pos | MC_${MC.PHASE_W_CURR_CHANNEL}<<ADC_JSQR_JSQ4_Pos | 1<<ADC_JSQR_JL_Pos,
                 MC_${MC.PHASE_W_CURR_CHANNEL}<<ADC_JSQR_JSQ3_Pos | MC_${MC.PHASE_U_CURR_CHANNEL}<<ADC_JSQR_JSQ4_Pos | 1<<ADC_JSQR_JL_Pos,
                 MC_${MC.PHASE_V_CURR_CHANNEL}<<ADC_JSQR_JSQ3_Pos | MC_${MC.PHASE_U_CURR_CHANNEL}<<ADC_JSQR_JSQ4_Pos | 1<<ADC_JSQR_JL_Pos,
                 MC_${MC.PHASE_U_CURR_CHANNEL}<<ADC_JSQR_JSQ3_Pos | MC_${MC.PHASE_V_CURR_CHANNEL}<<ADC_JSQR_JSQ4_Pos | 1<<ADC_JSQR_JL_Pos,
                 MC_${MC.PHASE_W_CURR_CHANNEL}<<ADC_JSQR_JSQ3_Pos | MC_${MC.PHASE_V_CURR_CHANNEL}<<ADC_JSQR_JSQ4_Pos | 1<<ADC_JSQR_JL_Pos,
  },
  
  .ADCDataReg1 = {
                   &${MC.ADC_PERIPH}->JDR1,
                   &${MC.ADC_PERIPH}->JDR1,
                   &${MC.ADC_PERIPH}->JDR2,
                   &${MC.ADC_PERIPH}->JDR2,
                   &${MC.ADC_PERIPH}->JDR1,
                   &${MC.ADC_PERIPH}->JDR2,
  },
  .ADCDataReg2 = {
                   &${MC.ADC_PERIPH}->JDR2,
                   &${MC.ADC_PERIPH}->JDR2,
                   &${MC.ADC_PERIPH}->JDR1,
                   &${MC.ADC_PERIPH}->JDR1,
                   &${MC.ADC_PERIPH}->JDR2,
                   &${MC.ADC_PERIPH}->JDR1,
  },
  
/* Emergency input (BKIN2) signal initialization -----------------------------*/
  .EmergencyStop = DISABLE,                               
};
  </#if> <#-- MC.THREE_SHUNT == true -->

  <#if MC.THREE_SHUNT_INDEPENDENT_RESOURCES == true > <#-- inside CondFamily_STM32F4 -->

/**
  * @brief  Current sensor parameters Motor 1 - three shunt
  */
const R3_2_Params_t R3_2_ParamsM1 =
{
  .Tw                       = MAX_TWAIT,
  .bFreqRatio               = FREQ_RATIO,          
  .bIsHigherFreqTim         = FREQ_RELATION,       
                                                     
/* Current reading A/D Conversions initialization ----------------------------*/
  .ADCx_1                  = ${MC.ADC_1_PERIPH},                 
  .ADCx_2                  = ${MC.ADC_2_PERIPH},
   
/* PWM generation parameters --------------------------------------------------*/
  .TIMx                       =	${_last_word(MC.PWM_TIMER_SELECTION)},
  .RepetitionCounter         =	REP_COUNTER,        
  .hTafter                    =	TW_AFTER,           
  .hTbefore                   =	TW_BEFORE,          
                                                    
/* PWM Driving signals initialization ----------------------------------------*/
  .LowSideOutputs             =	(LowSideOutputsFunction_t)LOW_SIDE_SIGNALS_ENABLING, 
<#if MC.LOW_SIDE_SIGNALS_ENABLING == "ES_GPIO"> 
<#if MC.SHARED_SIGNAL_ENABLE == false>
  .pwm_en_u_port          =	M1_PWM_EN_U_GPIO_Port,              
  .pwm_en_u_pin           =	M1_PWM_EN_U_Pin,                    
  .pwm_en_v_port          =	M1_PWM_EN_V_GPIO_Port,              
  .pwm_en_v_pin           =	M1_PWM_EN_V_Pin,                    
  .pwm_en_w_port          =	M1_PWM_EN_W_GPIO_Port,              
  .pwm_en_w_pin           =	M1_PWM_EN_W_Pin,  
<#else>
  .pwm_en_u_port          =	M1_PWM_EN_UVW_GPIO_Port,              
  .pwm_en_u_pin           =	M1_PWM_EN_UVW_Pin,                    
  .pwm_en_v_port          =	M1_PWM_EN_UVW_GPIO_Port,              
  .pwm_en_v_pin           =	M1_PWM_EN_UVW_Pin,                    
  .pwm_en_w_port          =	M1_PWM_EN_UVW_GPIO_Port,              
  .pwm_en_w_pin           =	M1_PWM_EN_UVW_Pin,  
</#if>                    
</#if> <#-- MC.LOW_SIDE_SIGNALS_ENABLING == ES_GPIO -->

  .ADCConfig1 = {   MC_${MC.PHASE_V_CURR_CHANNEL}<<ADC_JSQR_JSQ4_Pos
                   ,MC_${MC.PHASE_U_CURR_CHANNEL}<<ADC_JSQR_JSQ4_Pos
                   ,MC_${MC.PHASE_U_CURR_CHANNEL}<<ADC_JSQR_JSQ4_Pos
                   ,MC_${MC.PHASE_U_CURR_CHANNEL}<<ADC_JSQR_JSQ4_Pos
                   ,MC_${MC.PHASE_U_CURR_CHANNEL}<<ADC_JSQR_JSQ4_Pos
                   ,MC_${MC.PHASE_V_CURR_CHANNEL}<<ADC_JSQR_JSQ4_Pos
                  },

  .ADCConfig2 = {   MC_${MC.PHASE_W_CURR_CHANNEL}<<ADC_JSQR_JSQ4_Pos
                   ,MC_${MC.PHASE_W_CURR_CHANNEL}<<ADC_JSQR_JSQ4_Pos
                   ,MC_${MC.PHASE_W_CURR_CHANNEL}<<ADC_JSQR_JSQ4_Pos
                   ,MC_${MC.PHASE_V_CURR_CHANNEL}<<ADC_JSQR_JSQ4_Pos
                   ,MC_${MC.PHASE_V_CURR_CHANNEL}<<ADC_JSQR_JSQ4_Pos
                   ,MC_${MC.PHASE_W_CURR_CHANNEL}<<ADC_JSQR_JSQ4_Pos
                  },
                  
  .ADCDataReg1 = {
                   &${MC.ADC_1_PERIPH}->JDR1,
                   &${MC.ADC_1_PERIPH}->JDR1,
                   &${MC.ADC_1_PERIPH}->JDR1,
                   &${MC.ADC_1_PERIPH}->JDR1,
                   &${MC.ADC_1_PERIPH}->JDR1,
                   &${MC.ADC_1_PERIPH}->JDR1,
  },
  .ADCDataReg2 = {
                   &${MC.ADC_2_PERIPH}->JDR1,
                   &${MC.ADC_2_PERIPH}->JDR1,
                   &${MC.ADC_2_PERIPH}->JDR1,
                   &${MC.ADC_2_PERIPH}->JDR1,
                   &${MC.ADC_2_PERIPH}->JDR1,
                   &${MC.ADC_2_PERIPH}->JDR1,
  },
  
/* PWM Driving signals initialization ----------------------------------------*/
  .EmergencyStop                =	(FunctionalState) <#if MC.SW_OV_CURRENT_PROT_ENABLING>ENABLE<#else>DISABLE</#if>,
};
  </#if> <#-- MC.THREE_SHUNT_INDEPENDENT_RESOURCES == true -->

  <#if MC.SINGLE_SHUNT == true > <#-- inside CondFamily_STM32F4 -->
/**
  * @brief  Current sensor parameters Dual Drive Motor 1 - one shunt
  */
const R1_F4_Params_t R1_F4_ParamsM1 =
{
  .bFreqRatio               =	FREQ_RATIO,   
  .bIsHigherFreqTim         =	FREQ_RELATION,

  /* Current reading A/D Conversions initialization --------------------------*/
  .ADCx_Inj = ${MC.ADC_PERIPH},  /*!< ADC Pperipheral used for phase current sampling */

  .hIChannel                  =	MC_${MC.PHASE_CURRENTS_CHANNEL},

/* PWM generation parameters --------------------------------------------------*/
  .TIMx                       = ${_last_word(MC.PWM_TIMER_SELECTION)},
  .TIMx_2                     = <#if MC.ADC_PERIPH == "ADC3">TIM5<#else>TIM4</#if>,               
  .hDeadTime                  =	DEAD_TIME_COUNTS,   
  .RepetitionCounter         =	REP_COUNTER,        
  .hTafter                    =	TAFTER,             
  .hTbefore                   =	TBEFORE,            
  .hTMin                      =	TMIN,              
  .hHTMin                     =	HTMIN,              
  .hTSample                   =	SAMPLING_TIME,            
  .hMaxTrTs                   =	MAX_TRTS,           

  /* PWM Driving signals initialization ----------------------------------------*/
  .LowSideOutputs         =	(LowSideOutputsFunction_t)LOW_SIDE_SIGNALS_ENABLING, 
<#if MC.LOW_SIDE_SIGNALS_ENABLING == "ES_GPIO"> 
<#if MC.SHARED_SIGNAL_ENABLE == false>
  .pwm_en_u_port          =	M1_PWM_EN_U_GPIO_Port,              
  .pwm_en_u_pin           =	M1_PWM_EN_U_Pin,                    
  .pwm_en_v_port          =	M1_PWM_EN_V_GPIO_Port,              
  .pwm_en_v_pin           =	M1_PWM_EN_V_Pin,                    
  .pwm_en_w_port          =	M1_PWM_EN_W_GPIO_Port,              
  .pwm_en_w_pin           =	M1_PWM_EN_W_Pin, 
<#else>
  .pwm_en_u_port          =	M1_PWM_EN_UVW_GPIO_Port,              
  .pwm_en_u_pin           =	M1_PWM_EN_UVW_Pin,                    
  .pwm_en_v_port          =	M1_PWM_EN_UVW_GPIO_Port,              
  .pwm_en_v_pin           =	M1_PWM_EN_UVW_Pin,                    
  .pwm_en_w_port          =	M1_PWM_EN_UVW_GPIO_Port,              
  .pwm_en_w_pin           =	M1_PWM_EN_UVW_Pin,
</#if>                   
</#if> <#-- MC.LOW_SIDE_SIGNALS_ENABLING == ES_GPIO -->                   

  /* PWM Driving signals initialization ----------------------------------------*/
  .EmergencyStop                =	(FunctionalState) <#if MC.SW_OV_CURRENT_PROT_ENABLING>ENABLE<#else>DISABLE</#if>,
};
  </#if> <#-- MC.SINGLE_SHUNT == true) -->

<#if  MC.ICS_SENSORS == true>
/**
  * @brief  Current sensor parameters Dual Drive Motor 1 - ICS
  */
const ICS_Params_t ICS_ParamsM1 = {

/* Dual MC parameters --------------------------------------------------------*/
  .InstanceNbr =			1,                      
  .Tw =						MAX_TWAIT,              
  .FreqRatio =				FREQ_RATIO,             
  .IsHigherFreqTim =		FREQ_RELATION,          

/* Current reading A/D Conversions initialization -----------------------------*/
  .IaChannel       =	MC_${MC.PHASE_U_CURR_CHANNEL},                 
  .IbChannel       =	MC_${MC.PHASE_V_CURR_CHANNEL},        
  
/* PWM generation parameters --------------------------------------------------*/
  .RepetitionCounter =	REP_COUNTER,                         
  .TIMx               =	${_last_word(MC.PWM_TIMER_SELECTION)},                 
                                                             
/* PWM Driving signals initialization ----------------------------------------*/
  .LowSideOutputs 						  =	(LowSideOutputsFunction_t)LOW_SIDE_SIGNALS_ENABLING,
<#if MC.LOW_SIDE_SIGNALS_ENABLING == "ES_GPIO"> 
<#if MC.SHARED_SIGNAL_ENABLE == false>
  .pwm_en_u_port          =	M1_PWM_EN_U_GPIO_Port,              
  .pwm_en_u_pin           =	M1_PWM_EN_U_Pin,                    
  .pwm_en_v_port          =	M1_PWM_EN_V_GPIO_Port,              
  .pwm_en_v_pin           =	M1_PWM_EN_V_Pin,                    
  .pwm_en_w_port          =	M1_PWM_EN_W_GPIO_Port,              
  .pwm_en_w_pin           =	M1_PWM_EN_W_Pin, 
<#else>
  .pwm_en_u_port          =	M1_PWM_EN_UVW_GPIO_Port,              
  .pwm_en_u_pin           =	M1_PWM_EN_UVW_Pin,                    
  .pwm_en_v_port          =	M1_PWM_EN_UVW_GPIO_Port,              
  .pwm_en_v_pin           =	M1_PWM_EN_UVW_Pin,                    
  .pwm_en_w_port          =	M1_PWM_EN_UVW_GPIO_Port,              
  .pwm_en_w_pin           =	M1_PWM_EN_UVW_Pin, 
</#if>  
<#else>
  .pwm_en_u_port          =	MC_NULL,              
  .pwm_en_u_pin           = (uint16_t) 0,                    
  .pwm_en_v_port          =	MC_NULL,              
  .pwm_en_v_pin           = (uint16_t) 0,                    
  .pwm_en_w_port          =	MC_NULL,              
  .pwm_en_w_pin           = (uint16_t) 0,                        
</#if> <#-- MC.LOW_SIDE_SIGNALS_ENABLING == ES_GPIO -->         
                                    
/* Emergengy signal initialization ----------------------------------------*/
  .EmergencyStop				=	(FunctionalState) <#if MC.SW_OV_CURRENT_PROT_ENABLING>ENABLE<#else>DISABLE</#if>,
  
};
</#if> <#-- MC.ICS_SENSORS == true) -->

<#if  MC.ICS_SENSORS2 == true>
/**
  * @brief  Current sensor parameters Dual Drive Motor 2 - ICS
  */
const ICS_Params_t ICS_ParamsM2 = {
/* Dual MC parameters --------------------------------------------------------*/
  .InstanceNbr     = 2,                  
  .Tw               = MAX_TWAIT2,                      
  .FreqRatio       = FREQ_RATIO,                                         
  .IsHigherFreqTim = FREQ_RELATION2,          
 
                                               
/* Current reading A/D Conversions initialization -----------------------------*/
  .IaChannel       = MC_${MC.PHASE_U_CURR_CHANNEL2},                                                        
  .IbChannel       = MC_${MC.PHASE_V_CURR_CHANNEL2},           
                                   
/* PWM generation parameters --------------------------------------------------*/                                                  
  .RepetitionCounter = REP_COUNTER2,                                                             
  .TIMx               = ${_last_word(MC.PWM_TIMER_SELECTION2)},          
                                                       
/* PWM Driving signals initialization ----------------------------------------*/
  .LowSideOutputs    = (LowSideOutputsFunction_t)LOW_SIDE_SIGNALS_ENABLING2,  
<#if MC.LOW_SIDE_SIGNALS_ENABLING2 == "ES_GPIO"> 
<#if MC.SHARED_SIGNAL_ENABLE2 == false>
  .pwm_en_u_port          =	M2_PWM_EN_U_GPIO_Port,              
  .pwm_en_u_pin           =	M2_PWM_EN_U_Pin,                    
  .pwm_en_v_port          =	M2_PWM_EN_V_GPIO_Port,              
  .pwm_en_v_pin           =	M2_PWM_EN_V_Pin,                    
  .pwm_en_w_port          =	M2_PWM_EN_W_GPIO_Port,              
  .pwm_en_w_pin           =	M2_PWM_EN_W_Pin,
<#else>
  .pwm_en_u_port          =	M2_PWM_EN_UVW_GPIO_Port,              
  .pwm_en_u_pin           =	M2_PWM_EN_UVW_Pin,                    
  .pwm_en_v_port          =	M2_PWM_EN_UVW_GPIO_Port,              
  .pwm_en_v_pin           =	M2_PWM_EN_UVW_Pin,                    
  .pwm_en_w_port          =	M2_PWM_EN_UVW_GPIO_Port,              
  .pwm_en_w_pin           =	M2_PWM_EN_UVW_Pin,
</#if> 
<#else>
  .pwm_en_u_port          =	MC_NULL,              
  .pwm_en_u_pin           = (uint16_t) 0,                    
  .pwm_en_v_port          =	MC_NULL,              
  .pwm_en_v_pin           = (uint16_t) 0,                    
  .pwm_en_w_port          =	MC_NULL,              
  .pwm_en_w_pin           = (uint16_t) 0,                        
</#if> <#-- MC.LOW_SIDE_SIGNALS_ENABLING2 == ES_GPIO -->        
                                               
/* Emergency signal initialization ----------------------------------------*/
  .EmergencyStop =   (FunctionalState) <#if MC.SW_OV_CURRENT_PROT_ENABLING2==true>ENABLE<#else>DISABLE</#if>, 
                                                         
};
</#if> <#-- MC.ICS_SENSORS2 == true) -->

</#if> <#-- <#if CondFamily_STM32F4 -->

<#if CondFamily_STM32F0 >
  <#if MC.THREE_SHUNT == true>
<#assign phaseA = (MC.PHASE_U_CURR_CHANNEL?replace("ADC_CHANNEL_", ""))?number >
<#assign phaseB = (MC.PHASE_V_CURR_CHANNEL?replace("ADC_CHANNEL_", ""))?number >
<#assign phaseC = (MC.PHASE_W_CURR_CHANNEL?replace("ADC_CHANNEL_", ""))?number >  
/**
  * @brief  Current sensor parameters Single Drive - three shunt, STM32F0X
  */
const R3_1_Params_t R3_1_Params =
{
/* Current reading A/D Conversions initialization -----------------------------*/
  .b_ISamplingTime =  LL_ADC_SAMPLINGTIME_${MC.CURR_SAMPLING_TIME}<#if MC.CURR_SAMPLING_TIME != "1">CYCLES_5<#else>CYCLE_5</#if>,

/* PWM generation parameters --------------------------------------------------*/
  .hDeadTime = DEAD_TIME_COUNTS,
  .RepetitionCounter = REP_COUNTER,
  .hTafter = TW_AFTER,
  .hTbefore = TW_BEFORE_R3_1, 
  .TIMx = ${_last_word(MC.PWM_TIMER_SELECTION)},
  
/* PWM Driving signals initialization ----------------------------------------*/
  .LowSideOutputs= (LowSideOutputsFunction_t)LOW_SIDE_SIGNALS_ENABLING,  
<#if MC.LOW_SIDE_SIGNALS_ENABLING == "ES_GPIO"> 
<#if MC.SHARED_SIGNAL_ENABLE == false>
  .pwm_en_u_port          =	M1_PWM_EN_U_GPIO_Port,              
  .pwm_en_u_pin           =	M1_PWM_EN_U_Pin,                    
  .pwm_en_v_port          =	M1_PWM_EN_V_GPIO_Port,              
  .pwm_en_v_pin           =	M1_PWM_EN_V_Pin,                    
  .pwm_en_w_port          =	M1_PWM_EN_W_GPIO_Port,              
  .pwm_en_w_pin           =	M1_PWM_EN_W_Pin,     
<#else>
  .pwm_en_u_port          =	M1_PWM_EN_UVW_GPIO_Port,              
  .pwm_en_u_pin           =	M1_PWM_EN_UVW_Pin,                    
  .pwm_en_v_port          =	M1_PWM_EN_UVW_GPIO_Port,              
  .pwm_en_v_pin           =	M1_PWM_EN_UVW_Pin,                    
  .pwm_en_w_port          =	M1_PWM_EN_UVW_GPIO_Port,              
  .pwm_en_w_pin           =	M1_PWM_EN_UVW_Pin,  
</#if>                 
</#if> <#-- MC.LOW_SIDE_SIGNALS_ENABLING == ES_GPIO -->   
  .ADCConfig = {
                 1<< MC_${MC.PHASE_V_CURR_CHANNEL}| 1<<MC_${MC.PHASE_W_CURR_CHANNEL},
                 1<< MC_${MC.PHASE_U_CURR_CHANNEL}| 1<<MC_${MC.PHASE_W_CURR_CHANNEL},
                 1<< MC_${MC.PHASE_U_CURR_CHANNEL}| 1<<MC_${MC.PHASE_W_CURR_CHANNEL},
                 1<< MC_${MC.PHASE_U_CURR_CHANNEL}| 1<<MC_${MC.PHASE_V_CURR_CHANNEL},
                 1<< MC_${MC.PHASE_U_CURR_CHANNEL}| 1<<MC_${MC.PHASE_V_CURR_CHANNEL},
                 1<< MC_${MC.PHASE_V_CURR_CHANNEL}| 1<<MC_${MC.PHASE_W_CURR_CHANNEL},
  },
  .ADCScandir = {
                  <@setScandir Ph1=phaseB Ph2=phaseC/>
                  <@setScandir Ph1=phaseA Ph2=phaseC/>
                  <@setScandir Ph1=phaseC Ph2=phaseA/>
                  <@setScandir Ph1=phaseB Ph2=phaseA/>
                  <@setScandir Ph1=phaseA Ph2=phaseB/>
                  <@setScandir Ph1=phaseC Ph2=phaseB/>
  },
  .ADCDataReg1 = {          
               &PWM_Handle_M1.ADC1_DMA_converted[0],
               &PWM_Handle_M1.ADC1_DMA_converted[0],
               &PWM_Handle_M1.ADC1_DMA_converted[1],
               &PWM_Handle_M1.ADC1_DMA_converted[1],
               &PWM_Handle_M1.ADC1_DMA_converted[0],
               &PWM_Handle_M1.ADC1_DMA_converted[1],
  },
     
  .ADCDataReg2 = {
               &PWM_Handle_M1.ADC1_DMA_converted[1],
               &PWM_Handle_M1.ADC1_DMA_converted[1],
               &PWM_Handle_M1.ADC1_DMA_converted[0],
               &PWM_Handle_M1.ADC1_DMA_converted[0],
               &PWM_Handle_M1.ADC1_DMA_converted[1],
               &PWM_Handle_M1.ADC1_DMA_converted[0],  
  },                 
};
  </#if> <#-- MC.THREE_SHUNT == true  -->
  <#if MC.SINGLE_SHUNT == true>
/**
  * @brief  Current sensor parameters Single Drive - one shunt
  */
const R1_F0XX_Params_t R1_F0XX_Params =
{
/* Current reading A/D Conversions initialization -----------------------------*/
  .ISamplingTime = LL_ADC_SAMPLINGTIME_${MC.CURR_SAMPLING_TIME}<#if MC.CURR_SAMPLING_TIME != "1">CYCLES_5<#else>CYCLE_5</#if>,
  .IChannel = MC_${MC.PHASE_CURRENTS_CHANNEL},
  
/* PWM generation parameters --------------------------------------------------*/
  .DeadTime = DEAD_TIME_COUNTS, 
  .RepetitionCounter = REP_COUNTER,
  .Tafter = TAFTER,
  .Tbefore = TBEFORE,
  .TMin = TMIN,
  .HTMin = HTMIN,
  .TSample = SAMPLING_TIME,
  .MaxTrTs = MAX_TRTS,

/* PWM Driving signals initialization ----------------------------------------*/
  .TIMx = ${_last_word(MC.PWM_TIMER_SELECTION)},
  .AuxTIM = R1_PWM_AUX_TIM, 
  
  .LowSideOutputs = (LowSideOutputsFunction_t)LOW_SIDE_SIGNALS_ENABLING, 
<#if MC.LOW_SIDE_SIGNALS_ENABLING == "ES_GPIO">
<#if MC.SHARED_SIGNAL_ENABLE == false> 
  .pwm_en_u_port          =	M1_PWM_EN_U_GPIO_Port,              
  .pwm_en_u_pin           =	M1_PWM_EN_U_Pin,                    
  .pwm_en_v_port          =	M1_PWM_EN_V_GPIO_Port,              
  .pwm_en_v_pin           =	M1_PWM_EN_V_Pin,                    
  .pwm_en_w_port          =	M1_PWM_EN_W_GPIO_Port,              
  .pwm_en_w_pin           =	M1_PWM_EN_W_Pin,     
<#else>
  .pwm_en_u_port          =	M1_PWM_EN_UVW_GPIO_Port,              
  .pwm_en_u_pin           =	M1_PWM_EN_UVW_Pin,                    
  .pwm_en_v_port          =	M1_PWM_EN_UVW_GPIO_Port,              
  .pwm_en_v_pin           =	M1_PWM_EN_UVW_Pin,                    
  .pwm_en_w_port          =	M1_PWM_EN_UVW_GPIO_Port,              
  .pwm_en_w_pin           =	M1_PWM_EN_UVW_Pin,  
</#if>               
</#if> <#-- MC.LOW_SIDE_SIGNALS_ENABLING == ES_GPIO -->   
};

  </#if>    <#-- MC_SINGLE_SHUNT == true -->
</#if> <#-- CondFamily_STM32F0 -->
<#if CondFamily_STM32G0 >
  <#if MC.THREE_SHUNT == true>
<#assign phaseA = (MC.PHASE_U_CURR_CHANNEL?replace("ADC_CHANNEL_", ""))?number >
<#assign phaseB = (MC.PHASE_V_CURR_CHANNEL?replace("ADC_CHANNEL_", ""))?number >
<#assign phaseC = (MC.PHASE_W_CURR_CHANNEL?replace("ADC_CHANNEL_", ""))?number >  
/**
  * @brief  Current sensor parameters Single Drive - three shunt, STM32G0X
  */
const R3_1_Params_t R3_1_Params =
{
/* PWM generation parameters --------------------------------------------------*/
  .hDeadTime = DEAD_TIME_COUNTS,
  .RepetitionCounter = REP_COUNTER,
  .hTafter = TW_AFTER,
  .hTbefore = TW_BEFORE_R3_1, 
  .TIMx = ${_last_word(MC.PWM_TIMER_SELECTION)},
  
/* PWM Driving signals initialization ----------------------------------------*/
  .LowSideOutputs= (LowSideOutputsFunction_t)LOW_SIDE_SIGNALS_ENABLING,  
<#if MC.LOW_SIDE_SIGNALS_ENABLING == "ES_GPIO"> 
<#if MC.SHARED_SIGNAL_ENABLE == false>
  .pwm_en_u_port          =	M1_PWM_EN_U_GPIO_Port,              
  .pwm_en_u_pin           =	M1_PWM_EN_U_Pin,                    
  .pwm_en_v_port          =	M1_PWM_EN_V_GPIO_Port,              
  .pwm_en_v_pin           =	M1_PWM_EN_V_Pin,                    
  .pwm_en_w_port          =	M1_PWM_EN_W_GPIO_Port,              
  .pwm_en_w_pin           =	M1_PWM_EN_W_Pin,     
<#else>
  .pwm_en_u_port          =	M1_PWM_EN_UVW_GPIO_Port,              
  .pwm_en_u_pin           =	M1_PWM_EN_UVW_Pin,                    
  .pwm_en_v_port          =	M1_PWM_EN_UVW_GPIO_Port,              
  .pwm_en_v_pin           =	M1_PWM_EN_UVW_Pin,                    
  .pwm_en_w_port          =	M1_PWM_EN_UVW_GPIO_Port,              
  .pwm_en_w_pin           =	M1_PWM_EN_UVW_Pin,  
</#if>                 
</#if> <#-- MC.LOW_SIDE_SIGNALS_ENABLING == ES_GPIO -->    
  .ADCConfig = {
                  1<<MC_${MC.PHASE_V_CURR_CHANNEL} | 1<<MC_${MC.PHASE_W_CURR_CHANNEL},
                  1<<MC_${MC.PHASE_U_CURR_CHANNEL} | 1<<MC_${MC.PHASE_W_CURR_CHANNEL},
                  1<<MC_${MC.PHASE_U_CURR_CHANNEL} | 1<<MC_${MC.PHASE_W_CURR_CHANNEL},
                  1<<MC_${MC.PHASE_U_CURR_CHANNEL} | 1<<MC_${MC.PHASE_V_CURR_CHANNEL},
                  1<<MC_${MC.PHASE_U_CURR_CHANNEL} | 1<<MC_${MC.PHASE_V_CURR_CHANNEL},
                  1<<MC_${MC.PHASE_V_CURR_CHANNEL} | 1<<MC_${MC.PHASE_W_CURR_CHANNEL},
  },
  .ADCScandir = {
                  <@setScandir Ph1=phaseB Ph2=phaseC/>
                  <@setScandir Ph1=phaseA Ph2=phaseC/>
                  <@setScandir Ph1=phaseC Ph2=phaseA/>
                  <@setScandir Ph1=phaseB Ph2=phaseA/>
                  <@setScandir Ph1=phaseA Ph2=phaseB/>
                  <@setScandir Ph1=phaseC Ph2=phaseB/>
  },
  .ADCDataReg1 = {          
               &PWM_Handle_M1.ADC1_DMA_converted[0],
               &PWM_Handle_M1.ADC1_DMA_converted[0],
               &PWM_Handle_M1.ADC1_DMA_converted[1],
               &PWM_Handle_M1.ADC1_DMA_converted[1],
               &PWM_Handle_M1.ADC1_DMA_converted[0],
               &PWM_Handle_M1.ADC1_DMA_converted[1],
  },
     
  .ADCDataReg2 = {
               &PWM_Handle_M1.ADC1_DMA_converted[1],
               &PWM_Handle_M1.ADC1_DMA_converted[1],
               &PWM_Handle_M1.ADC1_DMA_converted[0],
               &PWM_Handle_M1.ADC1_DMA_converted[0],
               &PWM_Handle_M1.ADC1_DMA_converted[1],
               &PWM_Handle_M1.ADC1_DMA_converted[0],  
  },                 
};
  </#if> <#-- MC.THREE_SHUNT == true  -->
  <#if MC.SINGLE_SHUNT == true>
/**
  * @brief  Current sensor parameters Single Drive - one shunt
  */
const R1_G0XXParams_t R1_G0XX_Params =
{
/* Current reading A/D Conversions initialization -----------------------------*/
  .IChannel = MC_${MC.PHASE_CURRENTS_CHANNEL},
  
/* PWM generation parameters --------------------------------------------------*/
  .DeadTime = DEAD_TIME_COUNTS, 
  .RepetitionCounter = REP_COUNTER,
  .Tafter = TAFTER,
  .Tbefore = TBEFORE,
  .TMin = TMIN,
  .HTMin = HTMIN,
  .CHTMin = CHTMIN,
  .TSample = SAMPLING_TIME,
  .MaxTrTs = MAX_TRTS,

/* PWM Driving signals initialization ----------------------------------------*/
  .TIMx = ${_last_word(MC.PWM_TIMER_SELECTION)},
  
  .LowSideOutputs = (LowSideOutputsFunction_t)LOW_SIDE_SIGNALS_ENABLING, 
<#if MC.LOW_SIDE_SIGNALS_ENABLING == "ES_GPIO">
<#if MC.SHARED_SIGNAL_ENABLE == false> 
  .pwm_en_u_port          =	M1_PWM_EN_U_GPIO_Port,              
  .pwm_en_u_pin           =	M1_PWM_EN_U_Pin,                    
  .pwm_en_v_port          =	M1_PWM_EN_V_GPIO_Port,              
  .pwm_en_v_pin           =	M1_PWM_EN_V_Pin,                    
  .pwm_en_w_port          =	M1_PWM_EN_W_GPIO_Port,              
  .pwm_en_w_pin           =	M1_PWM_EN_W_Pin,     
<#else>
  .pwm_en_u_port          =	M1_PWM_EN_UVW_GPIO_Port,              
  .pwm_en_u_pin           =	M1_PWM_EN_UVW_Pin,                    
  .pwm_en_v_port          =	M1_PWM_EN_UVW_GPIO_Port,              
  .pwm_en_v_pin           =	M1_PWM_EN_UVW_Pin,                    
  .pwm_en_w_port          =	M1_PWM_EN_UVW_GPIO_Port,              
  .pwm_en_w_pin           =	M1_PWM_EN_UVW_Pin,  
</#if>               
</#if> <#-- MC.LOW_SIDE_SIGNALS_ENABLING == ES_GPIO -->   
};

  </#if>    <#-- MC_SINGLE_SHUNT == true -->
</#if> <#-- CondFamily_STM32G0 -->
<#if CondFamily_STM32L4 > <#-- CondFamily_STM32L4 --->
  <#if MC.SINGLE_SHUNT > 
/**
  * @brief  Current sensor parameters Motor 1 - single shunt - L4XX
  */
const R1_L4XXParams_t R1_L4XXParamsM1 =
{
/* Dual MC parameters --------------------------------------------------------*/                                                                                                                                
  .FreqRatio       = FREQ_RATIO,                                                                       
  .IsHigherFreqTim = FREQ_RELATION, 
                                                                     
/* Current reading A/D Conversions initialization -----------------------------*/
  .ADCx            = ${MC.ADC_PERIPH},                        
  .IChannel       = MC_${MC.PHASE_CURRENTS_CHANNEL},            
                                                                                                            
/* PWM generation parameters --------------------------------------------------*/
  .RepetitionCounter = REP_COUNTER,                                                                        
  .Tafter            = TAFTER,                                                                             
  .Tbefore           = TBEFORE,                                                                             
  .TMin              = TMIN,                                                                                
  .HTMin             = HTMIN,                          
  .CHTMin            = CHTMIN,                         
  .TSample           = SAMPLING_TIME,                                                                             
  .TIMx               = ${_last_word(MC.PWM_TIMER_SELECTION)},            
                                                                
/* PWM Driving signals initialization ----------------------------------------*/
  .LowSideOutputs = (LowSideOutputsFunction_t)LOW_SIDE_SIGNALS_ENABLING,
<#if MC.LOW_SIDE_SIGNALS_ENABLING == "ES_GPIO" >
<#if MC.SHARED_SIGNAL_ENABLE == false>    
  .pwm_en_u_port  = M1_PWM_EN_U_GPIO_Port,                                                           
  .pwm_en_u_pin   = M1_PWM_EN_U_Pin,                                                             
  .pwm_en_v_port  = M1_PWM_EN_V_GPIO_Port,                                                       
  .pwm_en_v_pin   = M1_PWM_EN_V_Pin,                                                           
  .pwm_en_w_port  = M1_PWM_EN_W_GPIO_Port,                                                        
  .pwm_en_w_pin   = M1_PWM_EN_W_Pin,    
<#else>
  .pwm_en_u_port  = M1_PWM_EN_UVW_GPIO_Port,                                                           
  .pwm_en_u_pin   = M1_PWM_EN_UVW_Pin,                                                             
  .pwm_en_v_port  = M1_PWM_EN_UVW_GPIO_Port,                                                       
  .pwm_en_v_pin   = M1_PWM_EN_UVW_Pin,                                                           
  .pwm_en_w_port  = M1_PWM_EN_UVW_GPIO_Port,                                                        
  .pwm_en_w_pin   = M1_PWM_EN_UVW_Pin,  
</#if>
<#else>
  .pwm_en_u_port  = MC_NULL,                                                           
  .pwm_en_u_pin   = (uint16_t) 0,                                                             
  .pwm_en_v_port  = MC_NULL,                                                       
  .pwm_en_v_pin   = (uint16_t) 0,                                                           
  .pwm_en_w_port  = MC_NULL,                                                        
  .pwm_en_w_pin   = (uint16_t) 0,   
</#if>       
                                                    
/* Emergency input (BKIN2) signal initialization -----------------------------*/
  .BKIN2Mode      = ${MC.BKIN2_MODE},                         
  
/* Internal OPAMP common settings --------------------------------------------*/
<#if MC.USE_INTERNAL_OPAMP>
  .OPAMP_Selection = ${_filter_opamp (MC.OPAMP_SELECTION)},   
<#else>
  .OPAMP_Selection = MC_NULL,                                                                  
</#if>                                            
/* Internal COMP settings ----------------------------------------------------*/
<#if MC.INTERNAL_OVERCURRENTPROTECTION>
  .CompOCPSelection = ${MC.OCP_SELECTION},            
  .CompOCPInvInput_MODE = ${MC.OCP_INVERTINGINPUT_MODE},  
<#else>                          
  .CompOCPSelection = MC_NULL,                             
  .CompOCPInvInput_MODE = NONE,                             
</#if>      
<#if MC.INTERNAL_OVERVOLTAGEPROTECTION>                                                            
  .CompOVPSelection = OVP_SELECTION,       
  .CompOVPInvInput_MODE = OVP_INVERTINGINPUT_MODE,   
<#else>
  .CompOVPSelection = MC_NULL,        
  .CompOVPInvInput_MODE =  NONE,
</#if>                   
                                                      
/* DAC settings --------------------------------------------------------------*/
  .DAC_OCP_Threshold =  ${MC.OCPREF},                                                                               
  .DAC_OVP_Threshold =  ${MC.OVPREF},                                                                              
                                                       
};
  <#elseif MC.ICS_SENSORS > <#-- Inside CondFamily_STM32L4 --->
ICS_Params_t ICS_ParamsM1 = 
{                                 
/* Dual MC parameters --------------------------------------------------------*/
  .FreqRatio =				FREQ_RATIO,                 
  .IsHigherFreqTim =		FREQ_RELATION,              

/* Current reading A/D Conversions initialization -----------------------------*/
  .ADCx_1 = ADC1,
  .ADCx_2 = ADC2,        
  .IaChannel = MC_${MC.PHASE_U_CURR_CHANNEL},                 
  .IbChannel = MC_${MC.PHASE_V_CURR_CHANNEL},                 

/* PWM generation parameters --------------------------------------------------*/
  .RepetitionCounter =	REP_COUNTER,                           
  .TIMx               =	${_last_word(MC.PWM_TIMER_SELECTION)},                   
                                                               
/* PWM Driving signals initialization ----------------------------------------*/
  .LowSideOutputs =	(LowSideOutputsFunction_t)LOW_SIDE_SIGNALS_ENABLING, 
<#if MC.LOW_SIDE_SIGNALS_ENABLING == "ES_GPIO" >  
<#if MC.SHARED_SIGNAL_ENABLE == false>                               
  .pwm_en_u_port      = M1_PWM_EN_U_GPIO_Port,                                         
  .pwm_en_u_pin       = M1_PWM_EN_U_Pin,                              
  .pwm_en_v_port      = M1_PWM_EN_V_GPIO_Port,                                              
  .pwm_en_v_pin       = M1_PWM_EN_V_Pin,
  .pwm_en_w_port      = M1_PWM_EN_W_GPIO_Port,                                                       
  .pwm_en_w_pin       = M1_PWM_EN_W_Pin,   
<#else>
  .pwm_en_u_port      = M1_PWM_EN_UVW_GPIO_Port,                                         
  .pwm_en_u_pin       = M1_PWM_EN_UVW_Pin,                              
  .pwm_en_v_port      = M1_PWM_EN_UVW_GPIO_Port,                                              
  .pwm_en_v_pin       = M1_PWM_EN_UVW_Pin,
  .pwm_en_w_port      = M1_PWM_EN_UVW_GPIO_Port,                                                       
  .pwm_en_w_pin       = M1_PWM_EN_UVW_Pin,
</#if>       
<#else>
  .pwm_en_u_port      = MC_NULL,                                         
  .pwm_en_u_pin       = (uint16_t) 0,                              
  .pwm_en_v_port      = MC_NULL,                                              
  .pwm_en_v_pin       = (uint16_t) 0,
  .pwm_en_w_port      = MC_NULL,                                                       
  .pwm_en_w_pin       = (uint16_t) 0, 
</#if> 
                                        
/* Emergengy signal initialization ----------------------------------------*/
  .BKIN2Mode           = ${MC.BKIN2_MODE},      

};
<#elseif  MC.THREE_SHUNT> <#-- Inside CondFamily_STM32L4 --->
/**
  * @brief  Current sensor parameters Motor 1 - three shunt 1 ADC 
  */
R3_1_Params_t R3_1_ParamsM1 =
{
/* Current reading A/D Conversions initialization -----------------------------*/
  .ADCx = ${MC.ADC_PERIPH},     
  .ADCConfig = {
                 MC_${MC.PHASE_V_CURR_CHANNEL}<<ADC_JSQR_JSQ1_Pos | MC_${MC.PHASE_W_CURR_CHANNEL}<<ADC_JSQR_JSQ2_Pos | 1<<ADC_JSQR_JL_Pos | (LL_ADC_INJ_TRIG_EXT_${_last_word(MC.PWM_TIMER_SELECTION)}_TRGO & ~ADC_INJ_TRIG_EXT_EDGE_DEFAULT),
                 MC_${MC.PHASE_U_CURR_CHANNEL}<<ADC_JSQR_JSQ1_Pos | MC_${MC.PHASE_W_CURR_CHANNEL}<<ADC_JSQR_JSQ2_Pos | 1<<ADC_JSQR_JL_Pos | (LL_ADC_INJ_TRIG_EXT_${_last_word(MC.PWM_TIMER_SELECTION)}_TRGO & ~ADC_INJ_TRIG_EXT_EDGE_DEFAULT),
                 MC_${MC.PHASE_W_CURR_CHANNEL}<<ADC_JSQR_JSQ1_Pos | MC_${MC.PHASE_U_CURR_CHANNEL}<<ADC_JSQR_JSQ2_Pos | 1<<ADC_JSQR_JL_Pos | (LL_ADC_INJ_TRIG_EXT_${_last_word(MC.PWM_TIMER_SELECTION)}_TRGO & ~ADC_INJ_TRIG_EXT_EDGE_DEFAULT),
                 MC_${MC.PHASE_V_CURR_CHANNEL}<<ADC_JSQR_JSQ1_Pos | MC_${MC.PHASE_U_CURR_CHANNEL}<<ADC_JSQR_JSQ2_Pos | 1<<ADC_JSQR_JL_Pos | (LL_ADC_INJ_TRIG_EXT_${_last_word(MC.PWM_TIMER_SELECTION)}_TRGO & ~ADC_INJ_TRIG_EXT_EDGE_DEFAULT),
                 MC_${MC.PHASE_U_CURR_CHANNEL}<<ADC_JSQR_JSQ1_Pos | MC_${MC.PHASE_V_CURR_CHANNEL}<<ADC_JSQR_JSQ2_Pos | 1<<ADC_JSQR_JL_Pos | (LL_ADC_INJ_TRIG_EXT_${_last_word(MC.PWM_TIMER_SELECTION)}_TRGO & ~ADC_INJ_TRIG_EXT_EDGE_DEFAULT),
                 MC_${MC.PHASE_W_CURR_CHANNEL}<<ADC_JSQR_JSQ1_Pos | MC_${MC.PHASE_V_CURR_CHANNEL}<<ADC_JSQR_JSQ2_Pos | 1<<ADC_JSQR_JL_Pos | (LL_ADC_INJ_TRIG_EXT_${_last_word(MC.PWM_TIMER_SELECTION)}_TRGO & ~ADC_INJ_TRIG_EXT_EDGE_DEFAULT),
  },
  
  .ADCDataReg1 = {
                   &${MC.ADC_PERIPH}->JDR1,
                   &${MC.ADC_PERIPH}->JDR1,
                   &${MC.ADC_PERIPH}->JDR2,
                   &${MC.ADC_PERIPH}->JDR2,
                   &${MC.ADC_PERIPH}->JDR1,
                   &${MC.ADC_PERIPH}->JDR2,
  },
  .ADCDataReg2 = {
                   &${MC.ADC_PERIPH}->JDR2,
                   &${MC.ADC_PERIPH}->JDR2,
                   &${MC.ADC_PERIPH}->JDR1,
                   &${MC.ADC_PERIPH}->JDR1,
                   &${MC.ADC_PERIPH}->JDR2,
                   &${MC.ADC_PERIPH}->JDR1,
  },                                      
/* PWM generation parameters --------------------------------------------------*/
  .RepetitionCounter = REP_COUNTER,                       
  .hTafter            = TW_AFTER,                          
  .hTbefore           = TW_BEFORE_R3_1,                    
  .TIMx               = ${_last_word(MC.PWM_TIMER_SELECTION)},               
                                     
/* PWM Driving signals initialization ----------------------------------------*/
  .LowSideOutputs = (LowSideOutputsFunction_t)LOW_SIDE_SIGNALS_ENABLING, 
<#if MC.LOW_SIDE_SIGNALS_ENABLING == "ES_GPIO" >
<#if MC.SHARED_SIGNAL_ENABLE == false>    
  .pwm_en_u_port = M1_PWM_EN_U_GPIO_Port,                                 
  .pwm_en_u_pin  = M1_PWM_EN_U_Pin,                    
  .pwm_en_v_port = M1_PWM_EN_V_GPIO_Port,                   
  .pwm_en_v_pin  = M1_PWM_EN_V_Pin,                    
  .pwm_en_w_port = M1_PWM_EN_W_GPIO_Port,                   
  .pwm_en_w_pin  = M1_PWM_EN_W_Pin,   
<#else>
  .pwm_en_u_port = M1_PWM_EN_UVW_GPIO_Port,                                 
  .pwm_en_u_pin  = M1_PWM_EN_UVW_Pin,                    
  .pwm_en_v_port = M1_PWM_EN_UVW_GPIO_Port,                   
  .pwm_en_v_pin  = M1_PWM_EN_UVW_Pin,                    
  .pwm_en_w_port = M1_PWM_EN_UVW_GPIO_Port,                   
  .pwm_en_w_pin  = M1_PWM_EN_UVW_Pin, 
</#if>
<#else>
  .pwm_en_u_port = MC_NULL,                                   
  .pwm_en_u_pin  = (uint16_t) 0,                    
  .pwm_en_v_port = MC_NULL,                   
  .pwm_en_v_pin  = (uint16_t) 0,                    
  .pwm_en_w_port = MC_NULL,                   
  .pwm_en_w_pin  = (uint16_t) 0,  
</#if>
/* Emergency input (BKIN2) signal initialization -----------------------------*/
  .bBKIN2Mode = ${MC.BKIN2_MODE},                                     
};
<#elseif  MC.THREE_SHUNT_INDEPENDENT_RESOURCES> <#-- Inside CondFamily_STM32L4 --->
/**
  * @brief  Current sensor parameters Motor 1 - three shunt - L4XX - Independent Resources
  */
R3_2_Params_t R3_2_ParamsM1 =
{
/* Dual MC parameters --------------------------------------------------------*/
  .bFreqRatio       = FREQ_RATIO,                                                                                  
  .bIsHigherFreqTim = FREQ_RELATION,                       
                                                     
/* Current reading A/D Conversions initialization -----------------------------*/
 .ADCx_1 = ${MC.ADC_1_PERIPH},                 
 .ADCx_2 = ${MC.ADC_2_PERIPH},
 .ADCConfig1 = {
                  MC_${MC.PHASE_V_CURR_CHANNEL}<<ADC_JSQR_JSQ1_Pos | 0<<ADC_JSQR_JL_Pos | (LL_ADC_INJ_TRIG_EXT_${_last_word(MC.PWM_TIMER_SELECTION)}_TRGO & ~ADC_INJ_TRIG_EXT_EDGE_DEFAULT),
                  MC_${MC.PHASE_U_CURR_CHANNEL}<<ADC_JSQR_JSQ1_Pos | 0<<ADC_JSQR_JL_Pos | (LL_ADC_INJ_TRIG_EXT_${_last_word(MC.PWM_TIMER_SELECTION)}_TRGO & ~ADC_INJ_TRIG_EXT_EDGE_DEFAULT),
                  MC_${MC.PHASE_U_CURR_CHANNEL}<<ADC_JSQR_JSQ1_Pos | 0<<ADC_JSQR_JL_Pos | (LL_ADC_INJ_TRIG_EXT_${_last_word(MC.PWM_TIMER_SELECTION)}_TRGO & ~ADC_INJ_TRIG_EXT_EDGE_DEFAULT),
                  MC_${MC.PHASE_U_CURR_CHANNEL}<<ADC_JSQR_JSQ1_Pos | 0<<ADC_JSQR_JL_Pos | (LL_ADC_INJ_TRIG_EXT_${_last_word(MC.PWM_TIMER_SELECTION)}_TRGO & ~ADC_INJ_TRIG_EXT_EDGE_DEFAULT),
                  MC_${MC.PHASE_U_CURR_CHANNEL}<<ADC_JSQR_JSQ1_Pos | 0<<ADC_JSQR_JL_Pos | (LL_ADC_INJ_TRIG_EXT_${_last_word(MC.PWM_TIMER_SELECTION)}_TRGO & ~ADC_INJ_TRIG_EXT_EDGE_DEFAULT),
                  MC_${MC.PHASE_V_CURR_CHANNEL}<<ADC_JSQR_JSQ1_Pos | 0<<ADC_JSQR_JL_Pos | (LL_ADC_INJ_TRIG_EXT_${_last_word(MC.PWM_TIMER_SELECTION)}_TRGO & ~ADC_INJ_TRIG_EXT_EDGE_DEFAULT),  
  },
  .ADCConfig2 = {
                  MC_${MC.PHASE_W_CURR_CHANNEL}<<ADC_JSQR_JSQ1_Pos | 0<<ADC_JSQR_JL_Pos | (LL_ADC_INJ_TRIG_EXT_${_last_word(MC.PWM_TIMER_SELECTION)}_TRGO & ~ADC_INJ_TRIG_EXT_EDGE_DEFAULT),
                  MC_${MC.PHASE_W_CURR_CHANNEL}<<ADC_JSQR_JSQ1_Pos | 0<<ADC_JSQR_JL_Pos | (LL_ADC_INJ_TRIG_EXT_${_last_word(MC.PWM_TIMER_SELECTION)}_TRGO & ~ADC_INJ_TRIG_EXT_EDGE_DEFAULT),
                  MC_${MC.PHASE_W_CURR_CHANNEL}<<ADC_JSQR_JSQ1_Pos | 0<<ADC_JSQR_JL_Pos | (LL_ADC_INJ_TRIG_EXT_${_last_word(MC.PWM_TIMER_SELECTION)}_TRGO & ~ADC_INJ_TRIG_EXT_EDGE_DEFAULT),
                  MC_${MC.PHASE_V_CURR_CHANNEL}<<ADC_JSQR_JSQ1_Pos | 0<<ADC_JSQR_JL_Pos | (LL_ADC_INJ_TRIG_EXT_${_last_word(MC.PWM_TIMER_SELECTION)}_TRGO & ~ADC_INJ_TRIG_EXT_EDGE_DEFAULT),
                  MC_${MC.PHASE_V_CURR_CHANNEL}<<ADC_JSQR_JSQ1_Pos | 0<<ADC_JSQR_JL_Pos | (LL_ADC_INJ_TRIG_EXT_${_last_word(MC.PWM_TIMER_SELECTION)}_TRGO & ~ADC_INJ_TRIG_EXT_EDGE_DEFAULT),
                  MC_${MC.PHASE_W_CURR_CHANNEL}<<ADC_JSQR_JSQ1_Pos | 0<<ADC_JSQR_JL_Pos | (LL_ADC_INJ_TRIG_EXT_${_last_word(MC.PWM_TIMER_SELECTION)}_TRGO & ~ADC_INJ_TRIG_EXT_EDGE_DEFAULT),    
  },
  .ADCDataReg1 = {
                   &ADC1->JDR1,
                   &ADC1->JDR1,
                   &ADC1->JDR1,
                   &ADC1->JDR1,
                   &ADC1->JDR1,
                   &ADC1->JDR1,
  },
  .ADCDataReg2 = {
                   &ADC2->JDR1,
                   &ADC2->JDR1,
                   &ADC2->JDR1,
                   &ADC2->JDR1,
                   &ADC2->JDR1,
                   &ADC2->JDR1,
  }, 
/* PWM generation parameters --------------------------------------------------*/
  .RepetitionCounter = REP_COUNTER,                           
  .hTafter            = TW_AFTER,                         
  .hTbefore           = TW_BEFORE,                         
  .TIMx               = ${_last_word(MC.PWM_TIMER_SELECTION)},              
                                                          
/* PWM Driving signals initialization ----------------------------------------*/
 .LowSideOutputs = (LowSideOutputsFunction_t)LOW_SIDE_SIGNALS_ENABLING,
<#if MC.LOW_SIDE_SIGNALS_ENABLING == "ES_GPIO" >  
<#if MC.SHARED_SIGNAL_ENABLE == false>
 .pwm_en_u_port      = M1_PWM_EN_U_GPIO_Port,                   
 .pwm_en_u_pin       = M1_PWM_EN_U_Pin,
 .pwm_en_v_port      = M1_PWM_EN_V_GPIO_Port,                     
 .pwm_en_v_pin       = M1_PWM_EN_V_Pin,                  
 .pwm_en_w_port      = M1_PWM_EN_W_GPIO_Port,                   
 .pwm_en_w_pin       = M1_PWM_EN_W_Pin,
<#else>
 .pwm_en_u_port      = M1_PWM_EN_UVW_GPIO_Port,                   
 .pwm_en_u_pin       = M1_PWM_EN_UVW_Pin,
 .pwm_en_v_port      = M1_PWM_EN_UVW_GPIO_Port,                     
 .pwm_en_v_pin       = M1_PWM_EN_UVW_Pin,                  
 .pwm_en_w_port      = M1_PWM_EN_UVW_GPIO_Port,                   
 .pwm_en_w_pin       = M1_PWM_EN_UVW_Pin,
</#if> 
<#else>
 .pwm_en_u_port      = MC_NULL,                   
 .pwm_en_u_pin       = (uint16_t) 0,
 .pwm_en_v_port      = MC_NULL,                     
 .pwm_en_v_pin       = (uint16_t) 0,                  
 .pwm_en_w_port      = MC_NULL,                   
 .pwm_en_w_pin       = (uint16_t) 0,
</#if>
 
/* Emergency input (BKIN2) signal initialization -----------------------------*/
  .bBKIN2Mode     = ${MC.BKIN2_MODE}, 
};
</#if>
</#if> <#-- CondFamily_STM32L4 --->
<#if CondFamily_STM32F7 > <#-- CondFamily_STM32F7 --->
  <#if MC.SINGLE_SHUNT > 
/**
  * @brief  Current sensor parameters Motor 1 - single shunt - F7XX
  */
R1_F7_Params_t R1_F7_ParamsM1 =
{
/* Dual MC parameters --------------------------------------------------------*/                                                                                                                                
  .FreqRatio       = FREQ_RATIO,                                                                       
  .IsHigherFreqTim = FREQ_RELATION, 
                                                                     
/* Current reading A/D Conversions initialization -----------------------------*/
  .ADCx            = ${MC.ADC_PERIPH},                        
  .IChannel       = MC_${MC.PHASE_CURRENTS_CHANNEL},            
                                                                                                            
/* PWM generation parameters --------------------------------------------------*/
  .RepetitionCounter = REP_COUNTER,                                                                        
  .Tafter            = TAFTER,                                                                             
  .Tbefore           = TBEFORE,                                                                             
  .TMin              = TMIN,                                                                                
  .HTMin             = HTMIN,                          
  .CHTMin            = CHTMIN,                         
  .TSample           = SAMPLING_TIME,                                                                             
  .MaxTrTs           = MAX_TRTS,                                                                            
  .TIMx               = ${_last_word(MC.PWM_TIMER_SELECTION)},            
                                                                
/* PWM Driving signals initialization ----------------------------------------*/
  .LowSideOutputs = (LowSideOutputsFunction_t)LOW_SIDE_SIGNALS_ENABLING,
<#if MC.LOW_SIDE_SIGNALS_ENABLING == "ES_GPIO" >
<#if MC.SHARED_SIGNAL_ENABLE == false>    
  .pwm_en_u_port  = M1_PWM_EN_U_GPIO_Port,                                                           
  .pwm_en_u_pin   = M1_PWM_EN_U_Pin,                                                             
  .pwm_en_v_port  = M1_PWM_EN_V_GPIO_Port,                                                       
  .pwm_en_v_pin   = M1_PWM_EN_V_Pin,                                                           
  .pwm_en_w_port  = M1_PWM_EN_W_GPIO_Port,                                                        
  .pwm_en_w_pin   = M1_PWM_EN_W_Pin,    
<#else>
  .pwm_en_u_port  = M1_PWM_EN_UVW_GPIO_Port,                                                           
  .pwm_en_u_pin   = M1_PWM_EN_UVW_Pin,                                                             
  .pwm_en_v_port  = M1_PWM_EN_UVW_GPIO_Port,                                                       
  .pwm_en_v_pin   = M1_PWM_EN_UVW_Pin,                                                           
  .pwm_en_w_port  = M1_PWM_EN_UVW_GPIO_Port,                                                        
  .pwm_en_w_pin   = M1_PWM_EN_UVW_Pin,  
</#if>
<#else>
  .pwm_en_u_port  = MC_NULL,                                                           
  .pwm_en_u_pin   = (uint16_t) 0,                                                             
  .pwm_en_v_port  = MC_NULL,                                                       
  .pwm_en_v_pin   = (uint16_t) 0,                                                           
  .pwm_en_w_port  = MC_NULL,                                                        
  .pwm_en_w_pin   = (uint16_t) 0,   
</#if>       

/* Emergency input (BKIN) signal initialization -----------------------------*/
  .EmergencyStop      = ${MC.BKIN_MODE},
                                                     
};
  <#elseif  MC.THREE_SHUNT> <#-- Inside CondFamily_STM32F7 --->
/**
  * @brief  Current sensor parameters Motor 1 - three shunt 1 ADC (STM32F302x8)
  */
R3_1_Params_t R3_1_ParamsM1 =
{
/* Current reading A/D Conversions initialization -----------------------------*/
  .ADCx = ${MC.ADC_PERIPH},     
  .ADCConfig = {
                 MC_${MC.PHASE_V_CURR_CHANNEL}<<ADC_JSQR_JSQ3_Pos | MC_${MC.PHASE_W_CURR_CHANNEL}<<ADC_JSQR_JSQ4_Pos | 1<<ADC_JSQR_JL_Pos,
                 MC_${MC.PHASE_U_CURR_CHANNEL}<<ADC_JSQR_JSQ3_Pos | MC_${MC.PHASE_W_CURR_CHANNEL}<<ADC_JSQR_JSQ4_Pos | 1<<ADC_JSQR_JL_Pos,
                 MC_${MC.PHASE_W_CURR_CHANNEL}<<ADC_JSQR_JSQ3_Pos | MC_${MC.PHASE_U_CURR_CHANNEL}<<ADC_JSQR_JSQ4_Pos | 1<<ADC_JSQR_JL_Pos,
                 MC_${MC.PHASE_V_CURR_CHANNEL}<<ADC_JSQR_JSQ3_Pos | MC_${MC.PHASE_U_CURR_CHANNEL}<<ADC_JSQR_JSQ4_Pos | 1<<ADC_JSQR_JL_Pos,
                 MC_${MC.PHASE_U_CURR_CHANNEL}<<ADC_JSQR_JSQ3_Pos | MC_${MC.PHASE_V_CURR_CHANNEL}<<ADC_JSQR_JSQ4_Pos | 1<<ADC_JSQR_JL_Pos,
                 MC_${MC.PHASE_W_CURR_CHANNEL}<<ADC_JSQR_JSQ3_Pos | MC_${MC.PHASE_V_CURR_CHANNEL}<<ADC_JSQR_JSQ4_Pos | 1<<ADC_JSQR_JL_Pos,
  },
  
  .ADCDataReg1 = {
                   &${MC.ADC_PERIPH}->JDR1,
                   &${MC.ADC_PERIPH}->JDR1,
                   &${MC.ADC_PERIPH}->JDR2,
                   &${MC.ADC_PERIPH}->JDR2,
                   &${MC.ADC_PERIPH}->JDR1,
                   &${MC.ADC_PERIPH}->JDR2,
  },
  .ADCDataReg2 = {
                   &${MC.ADC_PERIPH}->JDR2,
                   &${MC.ADC_PERIPH}->JDR2,
                   &${MC.ADC_PERIPH}->JDR1,
                   &${MC.ADC_PERIPH}->JDR1,
                   &${MC.ADC_PERIPH}->JDR2,
                   &${MC.ADC_PERIPH}->JDR1,
  },
                                                                                
/* PWM generation parameters --------------------------------------------------*/
  .RepetitionCounter = REP_COUNTER,                       
  .Tafter            = TW_AFTER,                          
  .Tbefore           = TW_BEFORE_R3_1,                    
  .TIMx               = ${_last_word(MC.PWM_TIMER_SELECTION)},               
                                     
/* PWM Driving signals initialization ----------------------------------------*/
  .LowSideOutputs = (LowSideOutputsFunction_t)LOW_SIDE_SIGNALS_ENABLING, 
<#if MC.LOW_SIDE_SIGNALS_ENABLING == "ES_GPIO" >
<#if MC.SHARED_SIGNAL_ENABLE == false>    
  .pwm_en_u_port = M1_PWM_EN_U_GPIO_Port,                                 
  .pwm_en_u_pin  = M1_PWM_EN_U_Pin,                    
  .pwm_en_v_port = M1_PWM_EN_V_GPIO_Port,                   
  .pwm_en_v_pin  = M1_PWM_EN_V_Pin,                    
  .pwm_en_w_port = M1_PWM_EN_W_GPIO_Port,                   
  .pwm_en_w_pin  = M1_PWM_EN_W_Pin,   
<#else>
  .pwm_en_u_port = M1_PWM_EN_UVW_GPIO_Port,                                 
  .pwm_en_u_pin  = M1_PWM_EN_UVW_Pin,                    
  .pwm_en_v_port = M1_PWM_EN_UVW_GPIO_Port,                   
  .pwm_en_v_pin  = M1_PWM_EN_UVW_Pin,                    
  .pwm_en_w_port = M1_PWM_EN_UVW_GPIO_Port,                   
  .pwm_en_w_pin  = M1_PWM_EN_UVW_Pin, 
</#if>
<#else> 
  .pwm_en_u_port = MC_NULL,                                 
  .pwm_en_u_pin  = (uint16_t) 0,                    
  .pwm_en_v_port = MC_NULL,                   
  .pwm_en_v_pin  = (uint16_t) 0,                    
  .pwm_en_w_port = MC_NULL,                   
  .pwm_en_w_pin  = (uint16_t) 0,  
</#if>

/* Emergency input (BKIN2) signal initialization -----------------------------*/
  .EmergencyStop = ${MC.BKIN2_MODE},                                              
                                     
};  
  <#elseif  MC.THREE_SHUNT_INDEPENDENT_RESOURCES> <#-- Inside CondFamily_STM32F7 --->
/**
  * @brief  Current sensor parameters Motor 1 - three shunt
  */
R3_2_Params_t R3_2_ParamsM1 =
{
/* Dual MC parameters --------------------------------------------------------*/
  .Tw                       =	MAX_TWAIT,
  .bFreqRatio               =	FREQ_RATIO,          
  .bIsHigherFreqTim         =	FREQ_RELATION,       
                                                     
/* Current reading A/D Conversions initialization ----------------------------*/
   .ADCx_1 = ${MC.ADC_1_PERIPH},                 
   .ADCx_2 = ${MC.ADC_2_PERIPH},
  .ADCConfig1 = {
                  MC_${MC.PHASE_V_CURR_CHANNEL}<<ADC_JSQR_JSQ4_Pos | 0<<ADC_JSQR_JL_Pos,
                  MC_${MC.PHASE_U_CURR_CHANNEL}<<ADC_JSQR_JSQ4_Pos | 0<<ADC_JSQR_JL_Pos,
                  MC_${MC.PHASE_U_CURR_CHANNEL}<<ADC_JSQR_JSQ4_Pos | 0<<ADC_JSQR_JL_Pos,
                  MC_${MC.PHASE_U_CURR_CHANNEL}<<ADC_JSQR_JSQ4_Pos | 0<<ADC_JSQR_JL_Pos,
                  MC_${MC.PHASE_U_CURR_CHANNEL}<<ADC_JSQR_JSQ4_Pos | 0<<ADC_JSQR_JL_Pos,
                  MC_${MC.PHASE_V_CURR_CHANNEL}<<ADC_JSQR_JSQ4_Pos | 0<<ADC_JSQR_JL_Pos,  
  },
  .ADCConfig2 = {
                  MC_${MC.PHASE_W_CURR_CHANNEL}<<ADC_JSQR_JSQ4_Pos | 0<<ADC_JSQR_JL_Pos,
                  MC_${MC.PHASE_W_CURR_CHANNEL}<<ADC_JSQR_JSQ4_Pos | 0<<ADC_JSQR_JL_Pos,
                  MC_${MC.PHASE_W_CURR_CHANNEL}<<ADC_JSQR_JSQ4_Pos | 0<<ADC_JSQR_JL_Pos,
                  MC_${MC.PHASE_V_CURR_CHANNEL}<<ADC_JSQR_JSQ4_Pos | 0<<ADC_JSQR_JL_Pos,
                  MC_${MC.PHASE_V_CURR_CHANNEL}<<ADC_JSQR_JSQ4_Pos | 0<<ADC_JSQR_JL_Pos,
                  MC_${MC.PHASE_W_CURR_CHANNEL}<<ADC_JSQR_JSQ4_Pos | 0<<ADC_JSQR_JL_Pos,    
  },
  
  .ADCDataReg1 = {
                   &ADC1->JDR1,
                   &ADC1->JDR1,
                   &ADC1->JDR1,
                   &ADC1->JDR1,
                   &ADC1->JDR1,
                   &ADC1->JDR1,
  },
  .ADCDataReg2 = {
                   &ADC2->JDR1,
                   &ADC2->JDR1,
                   &ADC2->JDR1,
                   &ADC2->JDR1,
                   &ADC2->JDR1,
                   &ADC2->JDR1,
  },
/* PWM generation parameters --------------------------------------------------*/
  .TIMx                       =	${_last_word(MC.PWM_TIMER_SELECTION)},
  .RepetitionCounter         =	REP_COUNTER,        
  .hTafter                    =	TW_AFTER,           
  .hTbefore                   =	TW_BEFORE,          
                                                    
/* PWM Driving signals initialization ----------------------------------------*/
  .LowSideOutputs             =	(LowSideOutputsFunction_t)LOW_SIDE_SIGNALS_ENABLING, 
<#if MC.LOW_SIDE_SIGNALS_ENABLING == "ES_GPIO"> 
<#if MC.SHARED_SIGNAL_ENABLE == false>
  .pwm_en_u_port          =	M1_PWM_EN_U_GPIO_Port,              
  .pwm_en_u_pin           =	M1_PWM_EN_U_Pin,                    
  .pwm_en_v_port          =	M1_PWM_EN_V_GPIO_Port,              
  .pwm_en_v_pin           =	M1_PWM_EN_V_Pin,                    
  .pwm_en_w_port          =	M1_PWM_EN_W_GPIO_Port,              
  .pwm_en_w_pin           =	M1_PWM_EN_W_Pin,  
<#else>
  .pwm_en_u_port          =	M1_PWM_EN_UVW_GPIO_Port,              
  .pwm_en_u_pin           =	M1_PWM_EN_UVW_Pin,                    
  .pwm_en_v_port          =	M1_PWM_EN_UVW_GPIO_Port,              
  .pwm_en_v_pin           =	M1_PWM_EN_UVW_Pin,                    
  .pwm_en_w_port          =	M1_PWM_EN_UVW_GPIO_Port,              
  .pwm_en_w_pin           =	M1_PWM_EN_UVW_Pin,  
</#if>                    
</#if>

/* PWM Driving signals initialization ----------------------------------------*/
  .EmergencyStop                =	(FunctionalState) <#if MC.SW_OV_CURRENT_PROT_ENABLING>ENABLE<#else>DISABLE</#if>,    
};
  <#elseif  MC.ICS_SENSORS> <#-- Inside CondFamily_STM32F7 --->
/**
  * @brief  Current sensor parameters Dual Drive Motor 1 - ICS
  */
ICS_Params_t ICS_ParamsM1 = {

/* Dual MC parameters --------------------------------------------------------*/
  .InstanceNbr =			1,                      
  .Tw =						MAX_TWAIT,              
  .FreqRatio =				FREQ_RATIO,             
  .IsHigherFreqTim =		FREQ_RELATION,          

/* Current reading A/D Conversions initialization -----------------------------*/
  .IaChannel       =	MC_${MC.PHASE_U_CURR_CHANNEL},                 
  .IbChannel       =	MC_${MC.PHASE_V_CURR_CHANNEL},        
  
/* PWM generation parameters --------------------------------------------------*/
  .RepetitionCounter =	REP_COUNTER,                         
  .TIMx               =	${_last_word(MC.PWM_TIMER_SELECTION)},                 
                                                             
/* PWM Driving signals initialization ----------------------------------------*/
  .LowSideOutputs 						  =	(LowSideOutputsFunction_t)LOW_SIDE_SIGNALS_ENABLING,
<#if MC.LOW_SIDE_SIGNALS_ENABLING == "ES_GPIO"> 
<#if MC.SHARED_SIGNAL_ENABLE == false>
  .pwm_en_u_port          =	M1_PWM_EN_U_GPIO_Port,              
  .pwm_en_u_pin           =	M1_PWM_EN_U_Pin,                    
  .pwm_en_v_port          =	M1_PWM_EN_V_GPIO_Port,              
  .pwm_en_v_pin           =	M1_PWM_EN_V_Pin,                    
  .pwm_en_w_port          =	M1_PWM_EN_W_GPIO_Port,              
  .pwm_en_w_pin           =	M1_PWM_EN_W_Pin,
<#else>   
  .pwm_en_u_port          =	M1_PWM_EN_UVW_GPIO_Port,              
  .pwm_en_u_pin           =	M1_PWM_EN_UVW_Pin,                    
  .pwm_en_v_port          =	M1_PWM_EN_UVW_GPIO_Port,              
  .pwm_en_v_pin           =	M1_PWM_EN_UVW_Pin,                    
  .pwm_en_w_port          =	M1_PWM_EN_UVW_GPIO_Port,              
  .pwm_en_w_pin           =	M1_PWM_EN_UVW_Pin,                 
</#if>
<#else>
  .pwm_en_u_port          =	MC_NULL,              
  .pwm_en_u_pin           = (uint16_t) 0,                    
  .pwm_en_v_port          =	MC_NULL,              
  .pwm_en_v_pin           = (uint16_t) 0,                    
  .pwm_en_w_port          =	MC_NULL,              
  .pwm_en_w_pin           = (uint16_t) 0,                        
</#if> <#-- MC.LOW_SIDE_SIGNALS_ENABLING == ES_GPIO -->         
                                    
/* Emergengy signal initialization ----------------------------------------*/
  .EmergencyStop                = (FunctionalState) <#if MC.SW_OV_CURRENT_PROT_ENABLING>ENABLE<#else>DISABLE</#if>,
  
}; 
</#if>
</#if> <#-- CondFamily_STM32F7 --->

<#if CondFamily_STM32H7 > <#-- CondFamily_STM32H7 --->
  <#if MC.SINGLE_SHUNT > 
#error " H7 Single shunt not supported yet "
  <#elseif MC.ICS_SENSORS > <#-- Inside CondFamily_STM32H7 --->
#error " H7 ICS not supported yet "

  <#elseif MC.THREE_SHUNT_SHARED_RESOURCES || MC.THREE_SHUNT_INDEPENDENT_RESOURCES> <#-- Inside CondFamily_STM32H7 --->
     <#if MC.USE_INTERNAL_OPAMP>
/**
  * @brief  Internal OPAMP parameters Motor 1 - three shunt - F3xx 
  */
R3_2_OPAMPParams_t R3_2_OPAMPParamsM1 =
{
  .OPAMPx_1 = ${MC.OPAMP1_SELECTION},
  .OPAMPx_2 = ${MC.OPAMP2_SELECTION},            
  .OPAMPConfig1 = { ${OPAMPPhase_Input (1,"INPUT_1")} 
                   ,${OPAMPPhase_Input (2,"INPUT_1")} 
                   ,${OPAMPPhase_Input (3,"INPUT_1")} 
                   ,${OPAMPPhase_Input (4,"INPUT_1")} 
                   ,${OPAMPPhase_Input (5,"INPUT_1")} 
                   ,${OPAMPPhase_Input (6,"INPUT_1")}  
                 }, 
  .OPAMPConfig2 = { ${OPAMPPhase_Input (1,"INPUT_2")}   
                   ,${OPAMPPhase_Input (2,"INPUT_2")} 
                   ,${OPAMPPhase_Input (3,"INPUT_2")} 
                   ,${OPAMPPhase_Input (4,"INPUT_2")}
                   ,${OPAMPPhase_Input (5,"INPUT_2")}
                   ,${OPAMPPhase_Input (6,"INPUT_2")}
                  },                    
};
    </#if>    
  
  /**
  * @brief  Current sensor parameters Motor 1 - three shunt - F30x - Shared Resources
  */
const R3_2_Params_t R3_2_ParamsM1 =
{
/* Dual MC parameters --------------------------------------------------------*/
  .FreqRatio       = FREQ_RATIO,                         
  .IsHigherFreqTim = FREQ_RELATION,                      
                                                          
/* Current reading A/D Conversions initialization -----------------------------*/
  .ADCx_1           = ${MC.ADC_1_PERIPH},                   
  .ADCx_2           = ${MC.ADC_2_PERIPH},                   
  
  .ADCConfig1 = { ${ADCConfig(1,"Sampling_1")}
                , ${ADCConfig(2,"Sampling_1")} 
                , ${ADCConfig(3,"Sampling_1")} 
                , ${ADCConfig(4,"Sampling_1")} 
                , ${ADCConfig(5,"Sampling_1")} 
                , ${ADCConfig(6,"Sampling_1")} 
                },
  .ADCConfig2 = { ${ADCConfig(1,"Sampling_2")}
                , ${ADCConfig(2,"Sampling_2")}
                , ${ADCConfig(3,"Sampling_2")}
                , ${ADCConfig(4,"Sampling_2")}
                , ${ADCConfig(5,"Sampling_2")}
                , ${ADCConfig(6,"Sampling_2")} 
                },
  .ADCDataReg1 = { ${ADCDataRead(1,"Sampling_1")}
                 , ${ADCDataRead(2,"Sampling_1")}
                 , ${ADCDataRead(3,"Sampling_1")}
                 , ${ADCDataRead(4,"Sampling_1")}
                 , ${ADCDataRead(5,"Sampling_1")}
                 , ${ADCDataRead(6,"Sampling_1")}                          
                 },
  .ADCDataReg2 =  { ${ADCDataRead(1,"Sampling_2")}
                  , ${ADCDataRead(2,"Sampling_2")}
                  , ${ADCDataRead(3,"Sampling_2")}
                  , ${ADCDataRead(4,"Sampling_2")}
                  , ${ADCDataRead(5,"Sampling_2")}
                  , ${ADCDataRead(6,"Sampling_2")}                            
                  },
/* PWM generation parameters --------------------------------------------------*/
  .RepetitionCounter = REP_COUNTER,                    
  .Tafter            = TW_AFTER,                       
  .Tbefore           = TW_BEFORE,                      
  .TIMx               = ${_last_word(MC.PWM_TIMER_SELECTION)},            
                                                        
/* PWM Driving signals initialization ----------------------------------------*/
  .LowSideOutputs = (LowSideOutputsFunction_t)LOW_SIDE_SIGNALS_ENABLING, 
<#if MC.LOW_SIDE_SIGNALS_ENABLING == "ES_GPIO" >  
<#if MC.SHARED_SIGNAL_ENABLE == false > 
 .pwm_en_u_port      = M1_PWM_EN_U_GPIO_Port,                   
 .pwm_en_u_pin       = M1_PWM_EN_U_Pin,
 .pwm_en_v_port      = M1_PWM_EN_V_GPIO_Port,                     
 .pwm_en_v_pin       = M1_PWM_EN_V_Pin,                  
 .pwm_en_w_port      = M1_PWM_EN_W_GPIO_Port,                   
 .pwm_en_w_pin       = M1_PWM_EN_W_Pin,
<#else>
 .pwm_en_u_port      = M1_PWM_EN_UVW_GPIO_Port,                   
 .pwm_en_u_pin       = M1_PWM_EN_UVW_Pin,
 .pwm_en_v_port      = M1_PWM_EN_UVW_GPIO_Port,                     
 .pwm_en_v_pin       = M1_PWM_EN_UVW_Pin,                  
 .pwm_en_w_port      = M1_PWM_EN_UVW_GPIO_Port,                   
 .pwm_en_w_pin       = M1_PWM_EN_UVW_Pin,
</#if>
<#else>
 .pwm_en_u_port      = MC_NULL,                   
 .pwm_en_u_pin       = (uint16_t) 0,
 .pwm_en_v_port      = MC_NULL,                     
 .pwm_en_v_pin       = (uint16_t) 0,                  
 .pwm_en_w_port      = MC_NULL,                   
 .pwm_en_w_pin       = (uint16_t) 0,
</#if>
                

/* Emergency input (BKIN2) signal initialization -----------------------------*/
  .BKIN2Mode     = ${MC.BKIN2_MODE},                         

/* Internal OPAMP common settings --------------------------------------------*/
<#if MC.USE_INTERNAL_OPAMP>
  .OPAMPParams     = &R3_2_OPAMPParamsM1,
<#else>  
  .OPAMPParams     = MC_NULL,
</#if>  
/* Internal COMP settings ----------------------------------------------------*/
<#if MC.INTERNAL_OVERCURRENTPROTECTION>
  .CompOCPASelection     = ${MC.OCPA_SELECTION},
  .CompOCPAInvInput_MODE = ${MC.OCPA_INVERTINGINPUT_MODE},                          
  .CompOCPBSelection     = ${MC.OCPB_SELECTION},                
  .CompOCPBInvInput_MODE = ${MC.OCPB_INVERTINGINPUT_MODE},              
  .CompOCPCSelection     = ${MC.OCPC_SELECTION},                  
  .CompOCPCInvInput_MODE = ${MC.OCPC_INVERTINGINPUT_MODE},                                           
<#else>  
  .CompOCPASelection     = MC_NULL,
  .CompOCPAInvInput_MODE = NONE,                          
  .CompOCPBSelection     = MC_NULL,      
  .CompOCPBInvInput_MODE = NONE,              
  .CompOCPCSelection     = MC_NULL,        
  .CompOCPCInvInput_MODE = NONE,                                         
</#if>

<#if MC.INTERNAL_OVERVOLTAGEPROTECTION>
  .CompOVPSelection      = OVP_SELECTION,                  
  .CompOVPInvInput_MODE  = OVP_INVERTINGINPUT_MODE,  
<#else>
  .CompOVPSelection      = MC_NULL,       
  .CompOVPInvInput_MODE  = NONE,
</#if>   
                                                         
/* DAC settings --------------------------------------------------------------*/
  .DAC_OCP_Threshold =  ${MC.OCPREF},                                        
  .DAC_OVP_Threshold =  ${MC.OVPREF},                                                                       
};
  <#elseif  MC.THREE_SHUNT> <#-- Inside CondFamily_STM32H7 --->
#error " H7 Single ADC not supported yet"
</#if>
</#if> <#-- CondFamily_STM32H7 --->
  
<#if CondFamily_STM32F3 > <#-- CondFamily_STM32F3 --->
  <#if MC.SINGLE_SHUNT > 
/**
  * @brief  Current sensor parameters Motor 1 - single shunt - F30x
  */
const R1_F30XParams_t R1_F30XParamsM1 =
{
/* Dual MC parameters --------------------------------------------------------*/                                                                                                                                
  .FreqRatio       = FREQ_RATIO,                                                                       
  .IsHigherFreqTim = FREQ_RELATION, 
                                                                     
/* Current reading A/D Conversions initialization -----------------------------*/
  .ADCx            = ${MC.ADC_PERIPH},                        
  .IChannel       = MC_${MC.PHASE_CURRENTS_CHANNEL},            
                                                                                                            
/* PWM generation parameters --------------------------------------------------*/
  .RepetitionCounter = REP_COUNTER,                                                                        
  .Tafter            = TAFTER,                                                                             
  .Tbefore           = TBEFORE,                                                                             
  .TMin              = TMIN,                                                                                
  .HTMin             = HTMIN,                          
  .CHTMin            = CHTMIN,                         
  .TSample           = SAMPLING_TIME,                                                                             
  .TIMx               = ${_last_word(MC.PWM_TIMER_SELECTION)},            
                                                                
/* PWM Driving signals initialization ----------------------------------------*/
  .LowSideOutputs = (LowSideOutputsFunction_t)LOW_SIDE_SIGNALS_ENABLING,
<#if MC.LOW_SIDE_SIGNALS_ENABLING == "ES_GPIO" >
<#if MC.SHARED_SIGNAL_ENABLE == false>    
  .pwm_en_u_port  = M1_PWM_EN_U_GPIO_Port,                                                           
  .pwm_en_u_pin   = M1_PWM_EN_U_Pin,                                                             
  .pwm_en_v_port  = M1_PWM_EN_V_GPIO_Port,                                                       
  .pwm_en_v_pin   = M1_PWM_EN_V_Pin,                                                           
  .pwm_en_w_port  = M1_PWM_EN_W_GPIO_Port,                                                        
  .pwm_en_w_pin   = M1_PWM_EN_W_Pin,    
<#else>
  .pwm_en_u_port  = M1_PWM_EN_UVW_GPIO_Port,                                                           
  .pwm_en_u_pin   = M1_PWM_EN_UVW_Pin,                                                             
  .pwm_en_v_port  = M1_PWM_EN_UVW_GPIO_Port,                                                       
  .pwm_en_v_pin   = M1_PWM_EN_UVW_Pin,                                                           
  .pwm_en_w_port  = M1_PWM_EN_UVW_GPIO_Port,                                                        
  .pwm_en_w_pin   = M1_PWM_EN_UVW_Pin,  
</#if>
<#else>
  .pwm_en_u_port  = MC_NULL,                                                           
  .pwm_en_u_pin   = (uint16_t) 0,                                                             
  .pwm_en_v_port  = MC_NULL,                                                       
  .pwm_en_v_pin   = (uint16_t) 0,                                                           
  .pwm_en_w_port  = MC_NULL,                                                        
  .pwm_en_w_pin   = (uint16_t) 0,   
</#if>       
                                                    
/* Emergency input (BKIN2) signal initialization -----------------------------*/
  .BKIN2Mode      = ${MC.BKIN2_MODE},                         
  
/* Internal OPAMP common settings --------------------------------------------*/
<#if MC.USE_INTERNAL_OPAMP>
  .OPAMP_Selection = ${_filter_opamp (MC.OPAMP_SELECTION)},   
<#else>
  .OPAMP_Selection = MC_NULL,                                                                  
</#if>                                            
/* Internal COMP settings ----------------------------------------------------*/
<#if MC.INTERNAL_OVERCURRENTPROTECTION>
  .CompOCPSelection = ${MC.OCP_SELECTION},            
  .CompOCPInvInput_MODE = ${MC.OCP_INVERTINGINPUT_MODE},  
<#else>                          
  .CompOCPSelection = MC_NULL,                             
  .CompOCPInvInput_MODE = NONE,                             
</#if>      
<#if MC.INTERNAL_OVERVOLTAGEPROTECTION>                                                            
  .CompOVPSelection = OVP_SELECTION,       
  .CompOVPInvInput_MODE = OVP_INVERTINGINPUT_MODE,   
<#else>
  .CompOVPSelection = MC_NULL,        
  .CompOVPInvInput_MODE =  NONE,
</#if>                   
                                                      
/* DAC settings --------------------------------------------------------------*/
  .DAC_OCP_Threshold =  ${MC.OCPREF},                                                                               
  .DAC_OVP_Threshold =  ${MC.OVPREF},                                                                              
                                                       
};
  <#elseif MC.ICS_SENSORS > <#-- Inside CondFamily_STM32F3 --->
const ICS_Params_t ICS_ParamsM1 = 
{                                 
/* Dual MC parameters --------------------------------------------------------*/
  .FreqRatio =				FREQ_RATIO,                 
  .IsHigherFreqTim =		FREQ_RELATION,              

/* Current reading A/D Conversions initialization -----------------------------*/
  .ADCx_1 = ${MC.ADC_1_PERIPH},
  .ADCx_2 = ${MC.ADC_2_PERIPH},        
  .IaChannel = MC_${MC.PHASE_U_CURR_CHANNEL},                 
  .IbChannel = MC_${MC.PHASE_V_CURR_CHANNEL},                 

/* PWM generation parameters --------------------------------------------------*/
  .RepetitionCounter =	REP_COUNTER,                           
  .TIMx               =	${_last_word(MC.PWM_TIMER_SELECTION)},                   
                                                               
/* PWM Driving signals initialization ----------------------------------------*/
  .LowSideOutputs =	(LowSideOutputsFunction_t)LOW_SIDE_SIGNALS_ENABLING, 
<#if MC.LOW_SIDE_SIGNALS_ENABLING == "ES_GPIO" >  
<#if MC.SHARED_SIGNAL_ENABLE == false>                               
  .pwm_en_u_port      = M1_PWM_EN_U_GPIO_Port,                                         
  .pwm_en_u_pin       = M1_PWM_EN_U_Pin,                              
  .pwm_en_v_port      = M1_PWM_EN_V_GPIO_Port,                                              
  .pwm_en_v_pin       = M1_PWM_EN_V_Pin,
  .pwm_en_w_port      = M1_PWM_EN_W_GPIO_Port,                                                       
  .pwm_en_w_pin       = M1_PWM_EN_W_Pin,   
<#else>
  .pwm_en_u_port      = M1_PWM_EN_UVW_GPIO_Port,                                         
  .pwm_en_u_pin       = M1_PWM_EN_UVW_Pin,                              
  .pwm_en_v_port      = M1_PWM_EN_UVW_GPIO_Port,                                              
  .pwm_en_v_pin       = M1_PWM_EN_UVW_Pin,
  .pwm_en_w_port      = M1_PWM_EN_UVW_GPIO_Port,                                                       
  .pwm_en_w_pin       = M1_PWM_EN_UVW_Pin,
</#if>       
<#else>
  .pwm_en_u_port      = MC_NULL,                                         
  .pwm_en_u_pin       = (uint16_t) 0,                              
  .pwm_en_v_port      = MC_NULL,                                              
  .pwm_en_v_pin       = (uint16_t) 0,
  .pwm_en_w_port      = MC_NULL,                                                       
  .pwm_en_w_pin       = (uint16_t) 0, 
</#if> 
                                        
/* Emergengy signal initialization ----------------------------------------*/
  .BKIN2Mode           = ${MC.BKIN2_MODE},      

};

  <#elseif MC.THREE_SHUNT_SHARED_RESOURCES || MC.THREE_SHUNT_INDEPENDENT_RESOURCES> <#-- Inside CondFamily_STM32F3 --->
     <#if MC.USE_INTERNAL_OPAMP>
/**
  * @brief  Internal OPAMP parameters Motor 1 - three shunt - F3xx 
  */
R3_2_OPAMPParams_t R3_2_OPAMPParamsM1 =
{
  .OPAMPx_1 = ${MC.OPAMP1_SELECTION},
  .OPAMPx_2 = ${MC.OPAMP2_SELECTION},            
  .OPAMPConfig1 = { ${OPAMPPhase_Input (1,"INPUT_1")} 
                   ,${OPAMPPhase_Input (2,"INPUT_1")} 
                   ,${OPAMPPhase_Input (3,"INPUT_1")} 
                   ,${OPAMPPhase_Input (4,"INPUT_1")} 
                   ,${OPAMPPhase_Input (5,"INPUT_1")} 
                   ,${OPAMPPhase_Input (6,"INPUT_1")}  
                 }, 
  .OPAMPConfig2 = { ${OPAMPPhase_Input (1,"INPUT_2")}   
                   ,${OPAMPPhase_Input (2,"INPUT_2")} 
                   ,${OPAMPPhase_Input (3,"INPUT_2")} 
                   ,${OPAMPPhase_Input (4,"INPUT_2")}
                   ,${OPAMPPhase_Input (5,"INPUT_2")}
                   ,${OPAMPPhase_Input (6,"INPUT_2")}
                  },                    
};
    </#if>    
  
  /**
  * @brief  Current sensor parameters Motor 1 - three shunt - F30x - Shared Resources
  */
const R3_2_Params_t R3_2_ParamsM1 =
{
/* Dual MC parameters --------------------------------------------------------*/
  .FreqRatio       = FREQ_RATIO,                         
  .IsHigherFreqTim = FREQ_RELATION,                      
                                                          
/* Current reading A/D Conversions initialization -----------------------------*/
  .ADCx_1           = ${MC.ADC_1_PERIPH},                   
  .ADCx_2           = ${MC.ADC_2_PERIPH},                   
  
  .ADCConfig1 = { ${ADCConfig(1,"Sampling_1")}
                , ${ADCConfig(2,"Sampling_1")} 
                , ${ADCConfig(3,"Sampling_1")} 
                , ${ADCConfig(4,"Sampling_1")} 
                , ${ADCConfig(5,"Sampling_1")} 
                , ${ADCConfig(6,"Sampling_1")} 
                },
  .ADCConfig2 = { ${ADCConfig(1,"Sampling_2")}
                , ${ADCConfig(2,"Sampling_2")}
                , ${ADCConfig(3,"Sampling_2")}
                , ${ADCConfig(4,"Sampling_2")}
                , ${ADCConfig(5,"Sampling_2")}
                , ${ADCConfig(6,"Sampling_2")} 
                },
  .ADCDataReg1 = { ${ADCDataRead(1,"Sampling_1")}
                 , ${ADCDataRead(2,"Sampling_1")}
                 , ${ADCDataRead(3,"Sampling_1")}
                 , ${ADCDataRead(4,"Sampling_1")}
                 , ${ADCDataRead(5,"Sampling_1")}
                 , ${ADCDataRead(6,"Sampling_1")}                          
                 },
  .ADCDataReg2 =  { ${ADCDataRead(1,"Sampling_2")}
                  , ${ADCDataRead(2,"Sampling_2")}
                  , ${ADCDataRead(3,"Sampling_2")}
                  , ${ADCDataRead(4,"Sampling_2")}
                  , ${ADCDataRead(5,"Sampling_2")}
                  , ${ADCDataRead(6,"Sampling_2")}                            
                  },
/* PWM generation parameters --------------------------------------------------*/
  .RepetitionCounter = REP_COUNTER,                    
  .Tafter            = TW_AFTER,                       
  .Tbefore           = TW_BEFORE,                      
  .TIMx               = ${_last_word(MC.PWM_TIMER_SELECTION)},            
                                                        
/* PWM Driving signals initialization ----------------------------------------*/
  .LowSideOutputs = (LowSideOutputsFunction_t)LOW_SIDE_SIGNALS_ENABLING, 
<#if MC.LOW_SIDE_SIGNALS_ENABLING == "ES_GPIO" >  
<#if MC.SHARED_SIGNAL_ENABLE == false > 
 .pwm_en_u_port      = M1_PWM_EN_U_GPIO_Port,                   
 .pwm_en_u_pin       = M1_PWM_EN_U_Pin,
 .pwm_en_v_port      = M1_PWM_EN_V_GPIO_Port,                     
 .pwm_en_v_pin       = M1_PWM_EN_V_Pin,                  
 .pwm_en_w_port      = M1_PWM_EN_W_GPIO_Port,                   
 .pwm_en_w_pin       = M1_PWM_EN_W_Pin,
<#else>
 .pwm_en_u_port      = M1_PWM_EN_UVW_GPIO_Port,                   
 .pwm_en_u_pin       = M1_PWM_EN_UVW_Pin,
 .pwm_en_v_port      = M1_PWM_EN_UVW_GPIO_Port,                     
 .pwm_en_v_pin       = M1_PWM_EN_UVW_Pin,                  
 .pwm_en_w_port      = M1_PWM_EN_UVW_GPIO_Port,                   
 .pwm_en_w_pin       = M1_PWM_EN_UVW_Pin,
</#if>
<#else>
 .pwm_en_u_port      = MC_NULL,                   
 .pwm_en_u_pin       = (uint16_t) 0,
 .pwm_en_v_port      = MC_NULL,                     
 .pwm_en_v_pin       = (uint16_t) 0,                  
 .pwm_en_w_port      = MC_NULL,                   
 .pwm_en_w_pin       = (uint16_t) 0,
</#if>
                

/* Emergency input (BKIN2) signal initialization -----------------------------*/
  .BKIN2Mode     = ${MC.BKIN2_MODE},                         

/* Internal OPAMP common settings --------------------------------------------*/
<#if MC.USE_INTERNAL_OPAMP>
  .OPAMPParams     = &R3_2_OPAMPParamsM1,
<#else>  
  .OPAMPParams     = MC_NULL,
</#if>  
/* Internal COMP settings ----------------------------------------------------*/
<#if MC.INTERNAL_OVERCURRENTPROTECTION>
  .CompOCPASelection     = ${MC.OCPA_SELECTION},
  .CompOCPAInvInput_MODE = ${MC.OCPA_INVERTINGINPUT_MODE},                          
  .CompOCPBSelection     = ${MC.OCPB_SELECTION},                
  .CompOCPBInvInput_MODE = ${MC.OCPB_INVERTINGINPUT_MODE},              
  .CompOCPCSelection     = ${MC.OCPC_SELECTION},                  
  .CompOCPCInvInput_MODE = ${MC.OCPC_INVERTINGINPUT_MODE},                                           
<#else>  
  .CompOCPASelection     = MC_NULL,
  .CompOCPAInvInput_MODE = NONE,                          
  .CompOCPBSelection     = MC_NULL,      
  .CompOCPBInvInput_MODE = NONE,              
  .CompOCPCSelection     = MC_NULL,        
  .CompOCPCInvInput_MODE = NONE,                                         
</#if>

<#if MC.INTERNAL_OVERVOLTAGEPROTECTION>
  .CompOVPSelection      = OVP_SELECTION,                  
  .CompOVPInvInput_MODE  = OVP_INVERTINGINPUT_MODE,  
<#else>
  .CompOVPSelection      = MC_NULL,       
  .CompOVPInvInput_MODE  = NONE,
</#if>   
                                                         
/* DAC settings --------------------------------------------------------------*/
  .DAC_OCP_Threshold =  ${MC.OCPREF},                                        
  .DAC_OVP_Threshold =  ${MC.OVPREF},                                                                       
};
  <#elseif  MC.THREE_SHUNT> <#-- Inside CondFamily_STM32F3 --->
/**
  * @brief  Current sensor parameters Motor 1 - three shunt 1 ADC (STM32F302x8)
  */
const R3_1_Params_t R3_1_ParamsM1 =
{
/* Dual MC parameters --------------------------------------------------------*/
  .FreqRatio       = FREQ_RATIO,                         
  .IsHigherFreqTim = FREQ_RELATION,                      
                                                          
/* Current reading A/D Conversions initialization -----------------------------*/
  .ADCx           = ${MC.ADC_PERIPH},
  .ADCConfig = {
                 MC_${MC.PHASE_V_CURR_CHANNEL}<<ADC_JSQR_JSQ1_Pos | MC_${MC.PHASE_W_CURR_CHANNEL}<<ADC_JSQR_JSQ2_Pos | 1<<ADC_JSQR_JL_Pos | (LL_ADC_INJ_TRIG_EXT_${_last_word(MC.PWM_TIMER_SELECTION)}_TRGO & ~ADC_INJ_TRIG_EXT_EDGE_DEFAULT),
                 MC_${MC.PHASE_U_CURR_CHANNEL}<<ADC_JSQR_JSQ1_Pos | MC_${MC.PHASE_W_CURR_CHANNEL}<<ADC_JSQR_JSQ2_Pos | 1<<ADC_JSQR_JL_Pos | (LL_ADC_INJ_TRIG_EXT_${_last_word(MC.PWM_TIMER_SELECTION)}_TRGO & ~ADC_INJ_TRIG_EXT_EDGE_DEFAULT),
                 MC_${MC.PHASE_W_CURR_CHANNEL}<<ADC_JSQR_JSQ1_Pos | MC_${MC.PHASE_U_CURR_CHANNEL}<<ADC_JSQR_JSQ2_Pos | 1<<ADC_JSQR_JL_Pos | (LL_ADC_INJ_TRIG_EXT_${_last_word(MC.PWM_TIMER_SELECTION)}_TRGO & ~ADC_INJ_TRIG_EXT_EDGE_DEFAULT),
                 MC_${MC.PHASE_V_CURR_CHANNEL}<<ADC_JSQR_JSQ1_Pos | MC_${MC.PHASE_U_CURR_CHANNEL}<<ADC_JSQR_JSQ2_Pos | 1<<ADC_JSQR_JL_Pos | (LL_ADC_INJ_TRIG_EXT_${_last_word(MC.PWM_TIMER_SELECTION)}_TRGO & ~ADC_INJ_TRIG_EXT_EDGE_DEFAULT),
                 MC_${MC.PHASE_U_CURR_CHANNEL}<<ADC_JSQR_JSQ1_Pos | MC_${MC.PHASE_V_CURR_CHANNEL}<<ADC_JSQR_JSQ2_Pos | 1<<ADC_JSQR_JL_Pos | (LL_ADC_INJ_TRIG_EXT_${_last_word(MC.PWM_TIMER_SELECTION)}_TRGO & ~ADC_INJ_TRIG_EXT_EDGE_DEFAULT),
                 MC_${MC.PHASE_W_CURR_CHANNEL}<<ADC_JSQR_JSQ1_Pos | MC_${MC.PHASE_V_CURR_CHANNEL}<<ADC_JSQR_JSQ2_Pos | 1<<ADC_JSQR_JL_Pos | (LL_ADC_INJ_TRIG_EXT_${_last_word(MC.PWM_TIMER_SELECTION)}_TRGO & ~ADC_INJ_TRIG_EXT_EDGE_DEFAULT),
  },
  
  .ADCDataReg1 = {
                   &${MC.ADC_PERIPH}->JDR1,
                   &${MC.ADC_PERIPH}->JDR1,
                   &${MC.ADC_PERIPH}->JDR2,
                   &${MC.ADC_PERIPH}->JDR2,
                   &${MC.ADC_PERIPH}->JDR1,
                   &${MC.ADC_PERIPH}->JDR2,
  },
  .ADCDataReg2 = {
                   &${MC.ADC_PERIPH}->JDR2,
                   &${MC.ADC_PERIPH}->JDR2,
                   &${MC.ADC_PERIPH}->JDR1,
                   &${MC.ADC_PERIPH}->JDR1,
                   &${MC.ADC_PERIPH}->JDR2,
                   &${MC.ADC_PERIPH}->JDR1,
  },  
 
/* PWM generation parameters --------------------------------------------------*/
  .RepetitionCounter = REP_COUNTER,                    
  .Tafter            = TW_AFTER,                       
  .Tbefore           = TW_BEFORE_R3_1,                      
  .TIMx               = ${_last_word(MC.PWM_TIMER_SELECTION)},            
                                                        
/* PWM Driving signals initialization ----------------------------------------*/
  .LowSideOutputs = (LowSideOutputsFunction_t)LOW_SIDE_SIGNALS_ENABLING, 
<#if MC.LOW_SIDE_SIGNALS_ENABLING == "ES_GPIO" >  
<#if MC.SHARED_SIGNAL_ENABLE == false > 
 .pwm_en_u_port      = M1_PWM_EN_U_GPIO_Port,                   
 .pwm_en_u_pin       = M1_PWM_EN_U_Pin,
 .pwm_en_v_port      = M1_PWM_EN_V_GPIO_Port,                     
 .pwm_en_v_pin       = M1_PWM_EN_V_Pin,                  
 .pwm_en_w_port      = M1_PWM_EN_W_GPIO_Port,                   
 .pwm_en_w_pin       = M1_PWM_EN_W_Pin,
<#else>
 .pwm_en_u_port      = M1_PWM_EN_UVW_GPIO_Port,                   
 .pwm_en_u_pin       = M1_PWM_EN_UVW_Pin,
 .pwm_en_v_port      = M1_PWM_EN_UVW_GPIO_Port,                     
 .pwm_en_v_pin       = M1_PWM_EN_UVW_Pin,                  
 .pwm_en_w_port      = M1_PWM_EN_UVW_GPIO_Port,                   
 .pwm_en_w_pin       = M1_PWM_EN_UVW_Pin,
</#if>
<#else>
 .pwm_en_u_port      = MC_NULL,                   
 .pwm_en_u_pin       = (uint16_t) 0,
 .pwm_en_v_port      = MC_NULL,                     
 .pwm_en_v_pin       = (uint16_t) 0,                  
 .pwm_en_w_port      = MC_NULL,                   
 .pwm_en_w_pin       = (uint16_t) 0,
</#if>
                

/* Emergency input (BKIN2) signal initialization -----------------------------*/
  .BKIN2Mode     = ${MC.BKIN2_MODE},                         

/* Internal COMP settings ----------------------------------------------------*/
<#if MC.INTERNAL_OVERCURRENTPROTECTION>
  .CompOCPASelection     = ${MC.OCPA_SELECTION},
  .CompOCPAInvInput_MODE = ${MC.OCPA_INVERTINGINPUT_MODE},                          
  .CompOCPBSelection     = ${MC.OCPB_SELECTION},                
  .CompOCPBInvInput_MODE = ${MC.OCPB_INVERTINGINPUT_MODE},              
  .CompOCPCSelection     = ${MC.OCPC_SELECTION},                  
  .CompOCPCInvInput_MODE = ${MC.OCPC_INVERTINGINPUT_MODE},                                           
<#else>  
  .CompOCPASelection     = MC_NULL,
  .CompOCPAInvInput_MODE = NONE,                          
  .CompOCPBSelection     = MC_NULL,      
  .CompOCPBInvInput_MODE = NONE,              
  .CompOCPCSelection     = MC_NULL,        
  .CompOCPCInvInput_MODE = NONE,                                         
</#if>

<#if MC.INTERNAL_OVERVOLTAGEPROTECTION>
  .CompOVPSelection      = OVP_SELECTION,                  
  .CompOVPInvInput_MODE  = OVP_INVERTINGINPUT_MODE,  
<#else>
  .CompOVPSelection      = MC_NULL,       
  .CompOVPInvInput_MODE  = NONE,
</#if>   
                                                         
/* DAC settings --------------------------------------------------------------*/
  .DAC_OCP_Threshold =  ${MC.OCPREF},                                        
  .DAC_OVP_Threshold =  ${MC.OVPREF},                                                                       
};
  </#if>
  <#if MC.SINGLE_SHUNT2 == true>  <#-- Inside CondFamily_STM32F3 --->
 /*
  * @brief  Current sensor parameters Motor 2 - single shunt - F30x
  */
const R1_F30XParams_t R1_F30XParamsM2 =
{
/* Dual MC parameters --------------------------------------------------------*/                                          
  .FreqRatio       = FREQ_RATIO,                                                                                         
  .IsHigherFreqTim = FREQ_RELATION2,  
                                                 
/* Current reading A/D Conversions initialization -----------------------------*/
  .ADCx            = ${MC.ADC_PERIPH2},                         
  .IChannel       = MC_${MC.PHASE_CURRENTS_CHANNEL2},                                        
                                                          
/* PWM generation parameters --------------------------------------------------*/
  .RepetitionCounter = REP_COUNTER2,                                
  .Tafter            = TAFTER2,                                 
  .Tbefore           = TBEFORE2,                                    
  .TMin              = TMIN2,                                                
  .HTMin             = HTMIN2,                          
  .CHTMin            = CHTMIN2,                         
  .TSample           = SAMPLING_TIME2,                                                   
  .TIMx               = ${_last_word(MC.PWM_TIMER_SELECTION2)},            
                                                     
/* PWM Driving signals initialization ----------------------------------------*/
  .LowSideOutputs = (LowSideOutputsFunction_t)LOW_SIDE_SIGNALS_ENABLING2,    
<#if MC.LOW_SIDE_SIGNALS_ENABLING2 == "ES_GPIO" >       
<#if MC.SHARED_SIGNAL_ENABLE2 == false>                          
  .pwm_en_u_port      = M2_PWM_EN_U_GPIO_Port,                                         
  .pwm_en_u_pin       = M2_PWM_EN_U_Pin,                              
  .pwm_en_v_port      = M2_PWM_EN_V_GPIO_Port,                                              
  .pwm_en_v_pin       = M2_PWM_EN_V_Pin,
  .pwm_en_w_port      = M2_PWM_EN_W_GPIO_Port,                                                       
  .pwm_en_w_pin       = M2_PWM_EN_W_Pin, 
<#else>
  .pwm_en_u_port      = M2_PWM_EN_UVW_GPIO_Port,                                         
  .pwm_en_u_pin       = M2_PWM_EN_UVW_Pin,                              
  .pwm_en_v_port      = M2_PWM_EN_UVW_GPIO_Port,                                              
  .pwm_en_v_pin       = M2_PWM_EN_UVW_Pin,
  .pwm_en_w_port      = M2_PWM_EN_UVW_GPIO_Port,                                                       
  .pwm_en_w_pin       = M2_PWM_EN_UVW_Pin, 
</#if>         
<#else>
  .pwm_en_u_port      = MC_NULL,                                         
  .pwm_en_u_pin       = (uint16_t) 0,                              
  .pwm_en_v_port      = MC_NULL,                                              
  .pwm_en_v_pin       = (uint16_t) 0,
  .pwm_en_w_port      = MC_NULL,                                                       
  .pwm_en_w_pin       = (uint16_t) 0, 
</#if>                                        
                                                    
/* Emergency input (BKIN2) signal initialization -----------------------------*/
  .BKIN2Mode      = ${MC.BKIN2_MODE2},                       

/* Internal OPAMP common settings --------------------------------------------*/
<#if MC.USE_INTERNAL_OPAMP2>
  .OPAMP_Selection = ${_filter_opamp (MC.OPAMP_SELECTION2)},                                                                     
<#else>
  .OPAMP_Selection = MC_NULL,
</#if>                                             
/* Internal COMP settings ----------------------------------------------------*/
<#if MC.INTERNAL_OVERCURRENTPROTECTION2>
  .CompOCPSelection = ${MC.OCP_SELECTION2},                           
  .CompOCPInvInput_MODE = ${MC.OCP_INVERTINGINPUT_MODE2},                        
<#else> 
  .CompOCPSelection = MC_NULL,                           
  .CompOCPInvInput_MODE = NONE,
</#if>                                             
<#if MC.INTERNAL_OVERVOLTAGEPROTECTION2>
  .CompOVPSelection = OVP_SELECTION2,                           
  .CompOVPInvInput_MODE = OVP_INVERTINGINPUT_MODE2,                        
<#else> 
  .CompOVPSelection = MC_NULL,                           
  .CompOVPInvInput_MODE = NONE,
</#if>                                                                       
                                                       
/* DAC settings --------------------------------------------------------------*/
  .DAC_OCP_Threshold =  ${MC.OCPREF2},                                                                                    
  .DAC_OVP_Threshold =  ${MC.OVPREF2},                                                                                     
                                                                                                   
};
  <#elseif MC.ICS_SENSORS2 == true>  <#-- Inside CondFamily_STM32F3 --->
ICS_Params_t ICS_ParamsM2 =
{                          
/* Dual MC parameters --------------------------------------------------------*/
  .FreqRatio =				FREQ_RATIO,
  .IsHigherFreqTim =		FREQ_RELATION2,                    

/* Current reading A/D Conversions initialization -----------------------------*/
  .ADCx_1 = ${MC.ADC_1_PERIPH2},
  .ADCx_2 = ${MC.ADC_2_PERIPH2},
  .IaChannel       =	MC_${MC.PHASE_U_CURR_CHANNEL2},
  .IbChannel       =	MC_${MC.PHASE_V_CURR_CHANNEL2},

/* PWM generation parameters --------------------------------------------------*/
  .RepetitionCounter =	REP_COUNTER2,
  .TIMx               =	${_last_word(MC.PWM_TIMER_SELECTION2)},
  
/* PWM Driving signals initialization ----------------------------------------*/

  .LowSideOutputs 	  = (LowSideOutputsFunction_t)LOW_SIDE_SIGNALS_ENABLING,                                                                               
<#if MC.LOW_SIDE_SIGNALS_ENABLING2 == "ES_GPIO" >   
<#if MC.SHARED_SIGNAL_ENABLE2 == false>                                 
  .pwm_en_u_port      = M2_PWM_EN_U_GPIO_Port,                                         
  .pwm_en_u_pin       = M2_PWM_EN_U_Pin,                              
  .pwm_en_v_port      = M2_PWM_EN_V_GPIO_Port,                                              
  .pwm_en_v_pin       = M2_PWM_EN_V_Pin,
  .pwm_en_w_port      = M2_PWM_EN_W_GPIO_Port,                                                       
  .pwm_en_w_pin       = M2_PWM_EN_W_Pin, 
<#else>    
  .pwm_en_u_port      = M2_PWM_EN_UVW_GPIO_Port,                                         
  .pwm_en_u_pin       = M2_PWM_EN_UVW_Pin,                              
  .pwm_en_v_port      = M2_PWM_EN_UVW_GPIO_Port,                                              
  .pwm_en_v_pin       = M2_PWM_EN_UVW_Pin,
  .pwm_en_w_port      = M2_PWM_EN_UVW_GPIO_Port,                                                       
  .pwm_en_w_pin       = M2_PWM_EN_UVW_Pin,      
</#if>
<#else>
  .pwm_en_u_port      = MC_NULL,                                         
  .pwm_en_u_pin       = (uint16_t) 0,                              
  .pwm_en_v_port      = MC_NULL,                                              
  .pwm_en_v_pin       = (uint16_t) 0,
  .pwm_en_w_port      = MC_NULL,                                                       
  .pwm_en_w_pin       = (uint16_t) 0, 
</#if> 
/* Emergengy signal initialization ----------------------------------------*/
  .BKIN2Mode           = ${MC.BKIN2_MODE2},
};
  <#elseif MC.THREE_SHUNT_SHARED_RESOURCES2 || MC.THREE_SHUNT_INDEPENDENT_RESOURCES2 > <#-- Inside CondFamily_STM32F3 --->
     <#if MC.USE_INTERNAL_OPAMP2>
/**
  * @brief  Internal OPAMP parameters Motor 2 - three shunt - F3xx 
  */
R3_2_OPAMPParams_t R3_2_OPAMPParamsM2 =
{
  .OPAMPx_1 = ${MC.OPAMP1_SELECTION2},
  .OPAMPx_2 = ${MC.OPAMP2_SELECTION2},
  .OPAMPConfig1 = { ${OPAMPPhase_Input (1,"INPUT_1",2)} 
                   ,${OPAMPPhase_Input (2,"INPUT_1",2)} 
                   ,${OPAMPPhase_Input (3,"INPUT_1",2)} 
                   ,${OPAMPPhase_Input (4,"INPUT_1",2)} 
                   ,${OPAMPPhase_Input (5,"INPUT_1",2)} 
                   ,${OPAMPPhase_Input (6,"INPUT_1",2)}  
                 }, 
  .OPAMPConfig2 = { ${OPAMPPhase_Input (1,"INPUT_2",2)}   
                   ,${OPAMPPhase_Input (2,"INPUT_2",2)} 
                   ,${OPAMPPhase_Input (3,"INPUT_2",2)} 
                   ,${OPAMPPhase_Input (4,"INPUT_2",2)}
                   ,${OPAMPPhase_Input (5,"INPUT_2",2)}
                   ,${OPAMPPhase_Input (6,"INPUT_2",2)}
                  },                    
};
    </#if>    
  
  /**
  * @brief  Current sensor parameters Motor 2 - three shunt - F30x 
  */
const R3_2_Params_t R3_2_ParamsM2 =
{
/* Dual MC parameters --------------------------------------------------------*/
  .FreqRatio       = FREQ_RATIO,                         
  .IsHigherFreqTim = FREQ_RELATION2,                      
                                                          
/* Current reading A/D Conversions initialization -----------------------------*/
  .ADCx_1           = ${MC.ADC_1_PERIPH2},                   
  .ADCx_2           = ${MC.ADC_2_PERIPH2},                   
  
  .ADCConfig1 = { ${ADCConfig(1,"Sampling_1",2)}
                , ${ADCConfig(2,"Sampling_1",2)} 
                , ${ADCConfig(3,"Sampling_1",2)} 
                , ${ADCConfig(4,"Sampling_1",2)} 
                , ${ADCConfig(5,"Sampling_1",2)} 
                , ${ADCConfig(6,"Sampling_1",2)} 
                },
  .ADCConfig2 = { ${ADCConfig(1,"Sampling_2",2)}
                , ${ADCConfig(2,"Sampling_2",2)}
                , ${ADCConfig(3,"Sampling_2",2)}
                , ${ADCConfig(4,"Sampling_2",2)}
                , ${ADCConfig(5,"Sampling_2",2)}
                , ${ADCConfig(6,"Sampling_2",2)} 
                },
  .ADCDataReg1 = { ${ADCDataRead(1,"Sampling_1",2)}
                 , ${ADCDataRead(2,"Sampling_1",2)}
                 , ${ADCDataRead(3,"Sampling_1",2)}
                 , ${ADCDataRead(4,"Sampling_1",2)}
                 , ${ADCDataRead(5,"Sampling_1",2)}
                 , ${ADCDataRead(6,"Sampling_1",2)}                          
                 },
  .ADCDataReg2 =  { ${ADCDataRead(1,"Sampling_2",2)}
                  , ${ADCDataRead(2,"Sampling_2",2)}
                  , ${ADCDataRead(3,"Sampling_2",2)}
                  , ${ADCDataRead(4,"Sampling_2",2)}
                  , ${ADCDataRead(5,"Sampling_2",2)}
                  , ${ADCDataRead(6,"Sampling_2",2)}                            
                  },
/* PWM generation parameters --------------------------------------------------*/
  .RepetitionCounter = REP_COUNTER2,                    
  .Tafter            = TW_AFTER2,                       
  .Tbefore           = TW_BEFORE2,                      
  .TIMx               = ${_last_word(MC.PWM_TIMER_SELECTION2)},            
                                                        
/* PWM Driving signals initialization ----------------------------------------*/
  .LowSideOutputs = (LowSideOutputsFunction_t)LOW_SIDE_SIGNALS_ENABLING2, 
<#if MC.LOW_SIDE_SIGNALS_ENABLING2 == "ES_GPIO" >  
<#if MC.SHARED_SIGNAL_ENABLE2 == false > 
 .pwm_en_u_port      = M2_PWM_EN_U_GPIO_Port,                   
 .pwm_en_u_pin       = M2_PWM_EN_U_Pin,
 .pwm_en_v_port      = M2_PWM_EN_V_GPIO_Port,                     
 .pwm_en_v_pin       = M2_PWM_EN_V_Pin,                  
 .pwm_en_w_port      = M2_PWM_EN_W_GPIO_Port,                   
 .pwm_en_w_pin       = M2_PWM_EN_W_Pin,
<#else>
 .pwm_en_u_port      = M2_PWM_EN_UVW_GPIO_Port,                   
 .pwm_en_u_pin       = M2_PWM_EN_UVW_Pin,
 .pwm_en_v_port      = M2_PWM_EN_UVW_GPIO_Port,                     
 .pwm_en_v_pin       = M2_PWM_EN_UVW_Pin,                  
 .pwm_en_w_port      = M2_PWM_EN_UVW_GPIO_Port,                   
 .pwm_en_w_pin       = M2_PWM_EN_UVW_Pin,
</#if>
<#else>
 .pwm_en_u_port      = MC_NULL,                   
 .pwm_en_u_pin       = (uint16_t) 0,
 .pwm_en_v_port      = MC_NULL,                     
 .pwm_en_v_pin       = (uint16_t) 0,                  
 .pwm_en_w_port      = MC_NULL,                   
 .pwm_en_w_pin       = (uint16_t) 0,
</#if>
                

/* Emergency input (BKIN2) signal initialization -----------------------------*/
  .BKIN2Mode     = ${MC.BKIN2_MODE2},                         

/* Internal OPAMP common settings --------------------------------------------*/
<#if MC.USE_INTERNAL_OPAMP2>
  .OPAMPParams     = &R3_2_OPAMPParamsM2,
<#else>  
  .OPAMPParams     = MC_NULL,
</#if>  
/* Internal COMP settings ----------------------------------------------------*/
<#if MC.INTERNAL_OVERCURRENTPROTECTION2>
  .CompOCPASelection     = ${MC.OCPA_SELECTION2},
  .CompOCPAInvInput_MODE = ${MC.OCPA_INVERTINGINPUT_MODE2},                          
  .CompOCPBSelection     = ${MC.OCPB_SELECTION2},                
  .CompOCPBInvInput_MODE = ${MC.OCPB_INVERTINGINPUT_MODE2},              
  .CompOCPCSelection     = ${MC.OCPC_SELECTION2},                  
  .CompOCPCInvInput_MODE = ${MC.OCPC_INVERTINGINPUT_MODE2},                                           
<#else>  
  .CompOCPASelection     = MC_NULL,
  .CompOCPAInvInput_MODE = NONE,                          
  .CompOCPBSelection     = MC_NULL,      
  .CompOCPBInvInput_MODE = NONE,              
  .CompOCPCSelection     = MC_NULL,        
  .CompOCPCInvInput_MODE = NONE,                                         
</#if>

<#if MC.INTERNAL_OVERVOLTAGEPROTECTION2>
  .CompOVPSelection      = OVP_SELECTION2,                  
  .CompOVPInvInput_MODE  = OVP_INVERTINGINPUT_MODE2,  
<#else>
  .CompOVPSelection      = MC_NULL,       
  .CompOVPInvInput_MODE  = NONE,
</#if>   
                                                         
/* DAC settings --------------------------------------------------------------*/
  .DAC_OCP_Threshold =  ${MC.OCPREF2},                                        
  .DAC_OVP_Threshold =  ${MC.OVPREF2},                                                                       
};

  <#elseif MC.THREE_SHUNT2>  <#-- Inside CondFamily_STM32F3 --->
  <#-- provision for future 
extern R3_1_F30XParams_t R3_1_F30XParamsM2;
  -->
  </#if>
</#if> <#-- CondFamily_STM32F3 --->

<#if CondFamily_STM32F1 && CondLine_STM32F1_HD && MC.SINGLE_SHUNT == true>
/**
  * @brief  Current sensor parameters Dual Drive Motor 1 - one shunt
  */

const R1_DDParams_t R1_DDParamsM1 =
{

/* Instance number -----------------------------------------------------------*/
  .InstanceNbr             =	1,
  
  .IsFirstR1DDInstance      =	true,
  
  .FreqRatio               =	FREQ_RATIO,
  
  .IsHigherFreqTim         =	FREQ_RELATION,
  
  .TIMx                     =	${_last_word(MC.PWM_TIMER_SELECTION)}, 

  .TIMx_2                     = TIM5,               


  /* Current reading A/D Conversions initialization --------------------------*/
  .ADCx_Inj = ADC3,          /*!< ADC Pperipheral used for phase current sampling */
  .ADCx_Reg = ADC1,          /*!< ADC Pperipheral used for regular conversion */
  .IChannel                  =	MC_${MC.PHASE_CURRENTS_CHANNEL},
  
/* PWM generation parameters --------------------------------------------------*/
  .DeadTime                  =	DEAD_TIME_COUNTS,
  
  .RepetitionCounter         =	REP_COUNTER,
  
  .Tafter                    =	TAFTER,
  
  .Tbefore                   =	TBEFORE, 
  .TMin                      =	 TMIN,

  .HTMin                     =	HTMIN,  
  
  .TSample                   =	SAMPLING_TIME,
  
  .MaxTrTs                   =	MAX_TRTS,

/* PWM Driving signals initialization ----------------------------------------*/

  .LowSideOutputs         =	(LowSideOutputsFunction_t)LOW_SIDE_SIGNALS_ENABLING,

<#if MC.LOW_SIDE_SIGNALS_ENABLING == "ES_GPIO"> 
<#if MC.SHARED_SIGNAL_ENABLE == false>
  .pwm_en_u_port          =	M1_PWM_EN_U_GPIO_Port,              
  .pwm_en_u_pin           =	M1_PWM_EN_U_Pin<<8,                    
  .pwm_en_v_port          =	M1_PWM_EN_V_GPIO_Port,              
  .pwm_en_v_pin           =	M1_PWM_EN_V_Pin<<8,                    
  .pwm_en_w_port          =	M1_PWM_EN_W_GPIO_Port,              
  .pwm_en_w_pin           =	M1_PWM_EN_W_Pin<<8,  
<#else>
  .pwm_en_u_port          =	M1_PWM_EN_UVW_GPIO_Port,              
  .pwm_en_u_pin           =	M1_PWM_EN_UVW_Pin<<8,                    
  .pwm_en_v_port          =	M1_PWM_EN_UVW_GPIO_Port,              
  .pwm_en_v_pin           =	M1_PWM_EN_UVW_Pin<<8,                    
  .pwm_en_w_port          =	M1_PWM_EN_UVW_GPIO_Port,              
  .pwm_en_w_pin           =	M1_PWM_EN_UVW_Pin<<8,
</#if>                  
</#if> <#-- MC.LOW_SIDE_SIGNALS_ENABLING == ES_GPIO -->                   

/* PWM Driving signals initialization ----------------------------------------*/
  .EmergencyStop                = (FunctionalState) <#if MC.SW_OV_CURRENT_PROT_ENABLING>ENABLE<#else>DISABLE</#if>,
  
};
</#if> <#-- CondFamily_STM32F1 - HD Single Shunt --->

<#if CondFamily_STM32F1 == true && MC.THREE_SHUNT == true >  
/**
  * @brief  Current sensor parameters Motor 1 - three shunt
  */
const R3_2_Params_t R3_2_ParamsM1 =
{
  .FreqRatio         = FREQ_RATIO,   
  .IsHigherFreqTim   = FREQ_RELATION,
  .TIMx              = ${_last_word(MC.PWM_TIMER_SELECTION)},  
  .ADCx_1            = ${MC.ADC_1_PERIPH},
  .ADCx_2            = ${MC.ADC_2_PERIPH},
  
  /* PWM generation parameters --------------------------------------------------*/
  .RepetitionCounter      =	REP_COUNTER,
 
  .Tafter                 =	TW_AFTER,
  .Tbefore                =	TW_BEFORE,

  /* PWM Driving signals initialization ----------------------------------------*/
 
  .LowSideOutputs          =	(LowSideOutputsFunction_t)LOW_SIDE_SIGNALS_ENABLING,
  
<#if MC.LOW_SIDE_SIGNALS_ENABLING == "ES_GPIO"> 
<#if MC.SHARED_SIGNAL_ENABLE == false>
  .pwm_en_u_port          =	M1_PWM_EN_U_GPIO_Port,              
  .pwm_en_u_pin           =	M1_PWM_EN_U_Pin<<8,                    
  .pwm_en_v_port          =	M1_PWM_EN_V_GPIO_Port,              
  .pwm_en_v_pin           =	M1_PWM_EN_V_Pin<<8,                    
  .pwm_en_w_port          =	M1_PWM_EN_W_GPIO_Port,              
  .pwm_en_w_pin           =	M1_PWM_EN_W_Pin<<8, 
<#else>
  .pwm_en_u_port          =	M1_PWM_EN_UVW_GPIO_Port,              
  .pwm_en_u_pin           =	M1_PWM_EN_UVW_Pin<<8,                    
  .pwm_en_v_port          =	M1_PWM_EN_UVW_GPIO_Port,              
  .pwm_en_v_pin           =	M1_PWM_EN_UVW_Pin<<8,                    
  .pwm_en_w_port          =	M1_PWM_EN_UVW_GPIO_Port,              
  .pwm_en_w_pin           =	M1_PWM_EN_UVW_Pin<<8,
</#if>                   
</#if> <#-- MC.LOW_SIDE_SIGNALS_ENABLING == ES_GPIO -->                   

  .ADCConfig1 = {   MC_${MC.PHASE_V_CURR_CHANNEL}<<ADC_JSQR_JSQ4_Pos
                   ,MC_${MC.PHASE_U_CURR_CHANNEL}<<ADC_JSQR_JSQ4_Pos
                   ,MC_${MC.PHASE_U_CURR_CHANNEL}<<ADC_JSQR_JSQ4_Pos
                   ,MC_${MC.PHASE_U_CURR_CHANNEL}<<ADC_JSQR_JSQ4_Pos
                   ,MC_${MC.PHASE_U_CURR_CHANNEL}<<ADC_JSQR_JSQ4_Pos
                   ,MC_${MC.PHASE_V_CURR_CHANNEL}<<ADC_JSQR_JSQ4_Pos
                  },

  .ADCConfig2 = {   MC_${MC.PHASE_W_CURR_CHANNEL}<<ADC_JSQR_JSQ4_Pos
                   ,MC_${MC.PHASE_W_CURR_CHANNEL}<<ADC_JSQR_JSQ4_Pos
                   ,MC_${MC.PHASE_W_CURR_CHANNEL}<<ADC_JSQR_JSQ4_Pos
                   ,MC_${MC.PHASE_V_CURR_CHANNEL}<<ADC_JSQR_JSQ4_Pos
                   ,MC_${MC.PHASE_V_CURR_CHANNEL}<<ADC_JSQR_JSQ4_Pos
                   ,MC_${MC.PHASE_W_CURR_CHANNEL}<<ADC_JSQR_JSQ4_Pos
                  },
				  
  .ADCDataReg1 = { &${MC.ADC_1_PERIPH}->JDR1 // Phase B, Phase C
                   ,&${MC.ADC_1_PERIPH}->JDR1 // Phase A, Phase C
                   ,&${MC.ADC_1_PERIPH}->JDR1 // Phase A, Phase C
                   ,&${MC.ADC_1_PERIPH}->JDR1 // Phase A, Phase B
                   ,&${MC.ADC_1_PERIPH}->JDR1 // Phase A, Phase B
                   ,&${MC.ADC_1_PERIPH}->JDR1 // Phase B, Phase C
                  },

  .ADCDataReg2 = { &${MC.ADC_2_PERIPH}->JDR1  // Phase B, Phase C
                   ,&${MC.ADC_2_PERIPH}->JDR1  // Phase A, Phase C
                   ,&${MC.ADC_2_PERIPH}->JDR1  // Phase A, Phase C
                   ,&${MC.ADC_2_PERIPH}->JDR1  // Phase A, Phase B
                   ,&${MC.ADC_2_PERIPH}->JDR1  // Phase A, Phase B
                   ,&${MC.ADC_2_PERIPH}->JDR1  // Phase B, Phase C
                   },

/* PWM Driving signals initialization ----------------------------------------*/
  .EmergencyStop                = (FunctionalState) <#if MC.SW_OV_CURRENT_PROT_ENABLING>ENABLE<#else>DISABLE</#if>,
  
  };
</#if> <#-- CondFamily_STM32F1 - HD/MD Three Shunt --->


<#if CondFamily_STM32F1 && CondLine_STM32F1_HD && MC.ICS_SENSORS == true>    
/**
  * @brief  Current sensor parameters Dual Drive Motor 1 - ICS
  */
const ICS_Params_t ICS_ParamsM1 = {

/* Dual MC parameters --------------------------------------------------------*/
  .InstanceNbr =			1,                      
  .Tw =						MAX_TWAIT,              
  .FreqRatio =				FREQ_RATIO,             
  .IsHigherFreqTim =		FREQ_RELATION,          

/* Current reading A/D Conversions initialization -----------------------------*/
  .IaChannel       =	MC_${MC.PHASE_U_CURR_CHANNEL},                 
  .IbChannel       =	MC_${MC.PHASE_V_CURR_CHANNEL},        
  
/* PWM generation parameters --------------------------------------------------*/
  .RepetitionCounter =	REP_COUNTER,                         
  .TIMx               =	${_last_word(MC.PWM_TIMER_SELECTION)},                 
                                                             
/* PWM Driving signals initialization ----------------------------------------*/
  .LowSideOutputs 						  =	(LowSideOutputsFunction_t)LOW_SIDE_SIGNALS_ENABLING,
<#if MC.LOW_SIDE_SIGNALS_ENABLING == "ES_GPIO"> 
<#if MC.SHARED_SIGNAL_ENABLE == false>
  .pwm_en_u_port          =	M1_PWM_EN_U_GPIO_Port,              
  .pwm_en_u_pin           =	M1_PWM_EN_U_Pin<<8,                    
  .pwm_en_v_port          =	M1_PWM_EN_V_GPIO_Port,              
  .pwm_en_v_pin           =	M1_PWM_EN_V_Pin<<8,                    
  .pwm_en_w_port          =	M1_PWM_EN_W_GPIO_Port,              
  .pwm_en_w_pin           =	M1_PWM_EN_W_Pin<<8,
<#else>   
  .pwm_en_u_port          =	M1_PWM_EN_UVW_GPIO_Port,              
  .pwm_en_u_pin           =	M1_PWM_EN_UVW_Pin<<8,                    
  .pwm_en_v_port          =	M1_PWM_EN_UVW_GPIO_Port,              
  .pwm_en_v_pin           =	M1_PWM_EN_UVW_Pin<<8,                    
  .pwm_en_w_port          =	M1_PWM_EN_UVW_GPIO_Port,              
  .pwm_en_w_pin           =	M1_PWM_EN_UVW_Pin<<8,                 
</#if>
<#else>
  .pwm_en_u_port          =	MC_NULL,              
  .pwm_en_u_pin           = (uint16_t) 0,                    
  .pwm_en_v_port          =	MC_NULL,              
  .pwm_en_v_pin           = (uint16_t) 0,                    
  .pwm_en_w_port          =	MC_NULL,              
  .pwm_en_w_pin           = (uint16_t) 0,                        
</#if> <#-- MC.LOW_SIDE_SIGNALS_ENABLING == ES_GPIO -->         
                                    
/* Emergengy signal initialization ----------------------------------------*/
  .EmergencyStop                = (FunctionalState) <#if MC.SW_OV_CURRENT_PROT_ENABLING>ENABLE<#else>DISABLE</#if>,
  
};
</#if> <#-- CondFamily_STM32F1 - HD ICS --->

<#if (CondLine_STM32F1_Value || CondLine_STM32F1_Performance) && MC.SINGLE_SHUNT == true>

/**
  * @brief  Current sensor parameters Single Drive - one shunt, STM32F100
  */
const R1_VL1Params_t R1_VL1ParamsSD =
{

/* Instance number -----------------------------------------------------------*/
    
  .TIMx                     = ${_last_word(MC.PWM_TIMER_SELECTION)}, 

  .TIMx_2                   = R1_PWM_AUX_TIM,               

  /* Current reading A/D Conversions initialization --------------------------*/
  .ADCx_Inj = ADC1,

  .hIChannel                  =	MC_${MC.PHASE_CURRENTS_CHANNEL},
  
/* PWM generation parameters --------------------------------------------------*/
  .hDeadTime                  =	DEAD_TIME_COUNTS,
  
  .RepetitionCounter         =	REP_COUNTER,
  
  .hTafter                    =	TAFTER,
  
  .hTbefore                   =	TBEFORE, 
  .hTMin                      =	 TMIN,

  .hHTMin                     =	HTMIN,  
  
  .hTSample                   =	SAMPLING_TIME,
  
  .hMaxTrTs                   =	MAX_TRTS,

/* PWM Driving signals initialization ----------------------------------------*/

  .LowSideOutputs         =	(LowSideOutputsFunction_t)LOW_SIDE_SIGNALS_ENABLING,

<#if MC.LOW_SIDE_SIGNALS_ENABLING == "ES_GPIO"> 
<#if MC.SHARED_SIGNAL_ENABLE == false>
  .pwm_en_u_port          =	M1_PWM_EN_U_GPIO_Port,              
  .pwm_en_u_pin           =	M1_PWM_EN_U_Pin<<8,                    
  .pwm_en_v_port          =	M1_PWM_EN_V_GPIO_Port,              
  .pwm_en_v_pin           =	M1_PWM_EN_V_Pin<<8,                    
  .pwm_en_w_port          =	M1_PWM_EN_W_GPIO_Port,              
  .pwm_en_w_pin           =	M1_PWM_EN_W_Pin<<8,         
<#else>
  .pwm_en_u_port          =	M1_PWM_EN_UVW_GPIO_Port,              
  .pwm_en_u_pin           =	M1_PWM_EN_UVW_Pin<<8,                    
  .pwm_en_v_port          =	M1_PWM_EN_UVW_GPIO_Port,              
  .pwm_en_v_pin           =	M1_PWM_EN_UVW_Pin<<8,                    
  .pwm_en_w_port          =	M1_PWM_EN_UVW_GPIO_Port,              
  .pwm_en_w_pin           =	M1_PWM_EN_UVW_Pin<<8,  
</#if>           
</#if> <#-- MC.LOW_SIDE_SIGNALS_ENABLING == ES_GPIO -->                   

/* PWM Driving signals initialization ----------------------------------------*/
  .EmergencyStop                = (FunctionalState) <#if MC.SW_OV_CURRENT_PROT_ENABLING>ENABLE<#else>DISABLE</#if>,
};
</#if> <#-- CondFamily_STM32F1 - LD/MD Single Shunt --->

<#if (CondLine_STM32F1_Value || CondLine_STM32F1_Performance) && MC.ICS_SENSORS == true>
/**
  * @brief  Current sensor parameters Dual Drive Motor 1 - ICS
  */
const ICS_Params_t ICS_ParamsM1 = {

/* Dual MC parameters --------------------------------------------------------*/
  .InstanceNbr =			1,                      
  .Tw =						MAX_TWAIT,              
  .FreqRatio =				FREQ_RATIO,             
  .IsHigherFreqTim =		FREQ_RELATION,          

/* Current reading A/D Conversions initialization -----------------------------*/
  .IaChannel       =	MC_${MC.PHASE_U_CURR_CHANNEL},                 
  .IbChannel       =	MC_${MC.PHASE_V_CURR_CHANNEL},        
  
/* PWM generation parameters --------------------------------------------------*/
  .RepetitionCounter =	REP_COUNTER,                         
  .TIMx               =	${_last_word(MC.PWM_TIMER_SELECTION)},                 
                                                             
/* PWM Driving signals initialization ----------------------------------------*/
  .LowSideOutputs 						  =	(LowSideOutputsFunction_t)LOW_SIDE_SIGNALS_ENABLING,
<#if MC.LOW_SIDE_SIGNALS_ENABLING == "ES_GPIO"> 
<#if MC.SHARED_SIGNAL_ENABLE == false>
  .pwm_en_u_port          =	M1_PWM_EN_U_GPIO_Port,              
  .pwm_en_u_pin           =	M1_PWM_EN_U_Pin<<8,                    
  .pwm_en_v_port          =	M1_PWM_EN_V_GPIO_Port,              
  .pwm_en_v_pin           =	M1_PWM_EN_V_Pin<<8,                    
  .pwm_en_w_port          =	M1_PWM_EN_W_GPIO_Port,              
  .pwm_en_w_pin           =	M1_PWM_EN_W_Pin<<8,        
<#else>
  .pwm_en_u_port          =	M1_PWM_EN_UVW_GPIO_Port,              
  .pwm_en_u_pin           =	M1_PWM_EN_UVW_Pin<<8,                    
  .pwm_en_v_port          =	M1_PWM_EN_UVW_GPIO_Port,              
  .pwm_en_v_pin           =	M1_PWM_EN_UVW_Pin<<8,                    
  .pwm_en_w_port          =	M1_PWM_EN_UVW_GPIO_Port,              
  .pwm_en_w_pin           =	M1_PWM_EN_UVW_Pin<<8, 
</#if>            
<#else>
  .pwm_en_u_port          =	MC_NULL,              
  .pwm_en_u_pin           = (uint16_t) 0,                    
  .pwm_en_v_port          =	MC_NULL,              
  .pwm_en_v_pin           = (uint16_t) 0,                    
  .pwm_en_w_port          =	MC_NULL,              
  .pwm_en_w_pin           = (uint16_t) 0,                        
</#if> <#-- MC.LOW_SIDE_SIGNALS_ENABLING == ES_GPIO -->         
                                    
/* Emergengy signal initialization ----------------------------------------*/
  .EmergencyStop                = (FunctionalState) <#if MC.SW_OV_CURRENT_PROT_ENABLING>ENABLE<#else>DISABLE</#if>,
  
};
</#if> <#-- CondFamily_STM32F1 - LD/MD ICS --->

<#if CondFamily_STM32G4 >
  <#if MC.THREE_SHUNT_INDEPENDENT_RESOURCES2 ||MC.THREE_SHUNT_SHARED_RESOURCES2  > 
    <#if MC.USE_INTERNAL_OPAMP2>
R3_3_OPAMPParams_t R3_3_OPAMPParamsM2 =  
{ 
  .OPAMPx_1 = ${MC.OPAMP1_SELECTION2},
  .OPAMPx_2 = ${MC.OPAMP2_SELECTION2},
  .OPAMPx_3 = MC_NULL,
  .OPAMPSelect_1 = { ${MC.OPAMP1_SELECTION2}
                    ,${MC.OPAMP1_SELECTION2} 
                    ,${MC.OPAMP1_SELECTION2} 
                    ,${MC.OPAMP1_SELECTION2} 
                    ,${MC.OPAMP1_SELECTION2} 
                    ,${MC.OPAMP1_SELECTION2} 
               },               
  .OPAMPSelect_2 = { ${MC.OPAMP2_SELECTION2} 
                    ,${MC.OPAMP2_SELECTION2}  
                    ,${MC.OPAMP2_SELECTION2}  
                    ,${MC.OPAMP2_SELECTION2}  
                    ,${MC.OPAMP2_SELECTION2}  
                    ,${MC.OPAMP2_SELECTION2}  
               },                        
  .OPAMPConfig1 = { ${OPAMPPhase_Input (1,"INPUT_1",2)} 
                   ,${OPAMPPhase_Input (2,"INPUT_1",2)} 
                   ,${OPAMPPhase_Input (3,"INPUT_1",2)} 
                   ,${OPAMPPhase_Input (4,"INPUT_1",2)} 
                   ,${OPAMPPhase_Input (5,"INPUT_1",2)} 
                   ,${OPAMPPhase_Input (6,"INPUT_1",2)}  
                 }, 
  .OPAMPConfig2 = { ${OPAMPPhase_Input (1,"INPUT_2",2)}   
                   ,${OPAMPPhase_Input (2,"INPUT_2",2)} 
                   ,${OPAMPPhase_Input (3,"INPUT_2",2)} 
                   ,${OPAMPPhase_Input (4,"INPUT_2",2)}
                   ,${OPAMPPhase_Input (5,"INPUT_2",2)}
                   ,${OPAMPPhase_Input (6,"INPUT_2",2)}
                  },
};
    </#if>
/**
  * @brief  Current sensor parameters Motor 2 - three shunt - G4 
  */
R3_2_Params_t R3_2_ParamsM2 =
{
/* Dual MC parameters --------------------------------------------------------*/
  .FreqRatio       = FREQ_RATIO,                         
  .IsHigherFreqTim = FREQ_RELATION2,                      
                                                          
/* Current reading A/D Conversions initialization -----------------------------*/
  .ADCx_1           = ${MC.ADC_1_PERIPH2},                   
  .ADCx_2           = ${MC.ADC_2_PERIPH2},
  /* Motor Control Kit config */ 
  .ADCConfig1 = { ${ADCConfig(1,"Sampling_1",2)}
                , ${ADCConfig(2,"Sampling_1",2)} 
                , ${ADCConfig(3,"Sampling_1",2)} 
                , ${ADCConfig(4,"Sampling_1",2)} 
                , ${ADCConfig(5,"Sampling_1",2)} 
                , ${ADCConfig(6,"Sampling_1",2)} 
                },
  .ADCConfig2 = { ${ADCConfig(1,"Sampling_2",2)}
                , ${ADCConfig(2,"Sampling_2",2)}
                , ${ADCConfig(3,"Sampling_2",2)}
                , ${ADCConfig(4,"Sampling_2",2)}
                , ${ADCConfig(5,"Sampling_2",2)}
                , ${ADCConfig(6,"Sampling_2",2)} 
                },
  .ADCDataReg1 = { ${ADCDataRead(1,"Sampling_1",2)}
                 , ${ADCDataRead(2,"Sampling_1",2)}
                 , ${ADCDataRead(3,"Sampling_1",2)}
                 , ${ADCDataRead(4,"Sampling_1",2)}
                 , ${ADCDataRead(5,"Sampling_1",2)}
                 , ${ADCDataRead(6,"Sampling_1",2)}                          
                 },
  .ADCDataReg2 = { ${ADCDataRead(1,"Sampling_2",2)}
                 , ${ADCDataRead(2,"Sampling_2",2)}
                 , ${ADCDataRead(3,"Sampling_2",2)}
                 , ${ADCDataRead(4,"Sampling_2",2)}
                 , ${ADCDataRead(5,"Sampling_2",2)}
                 , ${ADCDataRead(6,"Sampling_2",2)}                           
                 },    
    /* PWM generation parameters --------------------------------------------------*/
  .RepetitionCounter = REP_COUNTER2,                    
  .Tafter            = TW_AFTER2,                       
  .Tbefore           = TW_BEFORE2,                      
  .TIMx               = ${_last_word(MC.PWM_TIMER_SELECTION2)},            
                                                        
/* PWM Driving signals initialization ----------------------------------------*/
  .LowSideOutputs = (LowSideOutputsFunction_t)LOW_SIDE_SIGNALS_ENABLING2, 
<#if MC.LOW_SIDE_SIGNALS_ENABLING2 == "ES_GPIO" >  
<#if MC.SHARED_SIGNAL_ENABLE2 == false > 
 .pwm_en_u_port      = M2_PWM_EN_U_GPIO_Port,                   
 .pwm_en_u_pin       = M2_PWM_EN_U_Pin,
 .pwm_en_v_port      = M2_PWM_EN_V_GPIO_Port,                     
 .pwm_en_v_pin       = M2_PWM_EN_V_Pin,                  
 .pwm_en_w_port      = M2_PWM_EN_W_GPIO_Port,                   
 .pwm_en_w_pin       = M2_PWM_EN_W_Pin,
<#else>
 .pwm_en_u_port      = M2_PWM_EN_UVW_GPIO_Port,                   
 .pwm_en_u_pin       = M2_PWM_EN_UVW_Pin,
 .pwm_en_v_port      = M2_PWM_EN_UVW_GPIO_Port,                     
 .pwm_en_v_pin       = M2_PWM_EN_UVW_Pin,                  
 .pwm_en_w_port      = M2_PWM_EN_UVW_GPIO_Port,                   
 .pwm_en_w_pin       = M2_PWM_EN_UVW_Pin,
</#if>
<#else>
 .pwm_en_u_port      = MC_NULL,                   
 .pwm_en_u_pin       = (uint16_t) 0,
 .pwm_en_v_port      = MC_NULL,                     
 .pwm_en_v_pin       = (uint16_t) 0,                  
 .pwm_en_w_port      = MC_NULL,                   
 .pwm_en_w_pin       = (uint16_t) 0,
</#if>
                

/* Emergency input (BKIN2) signal initialization -----------------------------*/
  .BKIN2Mode     = ${MC.BKIN2_MODE2},                         

/* Internal OPAMP common settings --------------------------------------------*/
<#if MC.USE_INTERNAL_OPAMP2>
  .OPAMPParams     = &R3_3_OPAMPParamsM2,
<#else>  
  .OPAMPParams     = MC_NULL,
</#if>  
/* Internal COMP settings ----------------------------------------------------*/
<#if MC.INTERNAL_OVERCURRENTPROTECTION2>
  .CompOCPASelection     = ${MC.OCPA_SELECTION2},
  .CompOCPAInvInput_MODE = ${MC.OCPA_INVERTINGINPUT_MODE2},                          
  .CompOCPBSelection     = ${MC.OCPB_SELECTION2},                
  .CompOCPBInvInput_MODE = ${MC.OCPB_INVERTINGINPUT_MODE2},              
  .CompOCPCSelection     = ${MC.OCPC_SELECTION2},  
  .CompOCPCInvInput_MODE = ${MC.OCPC_INVERTINGINPUT_MODE2},   
<#if (MC.DAC_OCP_A_M2 != "NOT_USED") && (MC.DAC_OCP_B_M2 != "NOT_USED") && (MC.DAC_OCP_C_M2 != "NOT_USED")>  
  .DAC_OCP_ASelection    = ${_first_word(MC.DAC_OCP_A_M2)},
  .DAC_OCP_BSelection    = ${_first_word(MC.DAC_OCP_B_M2)},
  .DAC_OCP_CSelection    = ${_first_word(MC.DAC_OCP_C_M2)},
  .DAC_Channel_OCPA      = LL_DAC_CHANNEL_${_last_word(MC.DAC_OCP_A_M2, "CH")},
  .DAC_Channel_OCPB      = LL_DAC_CHANNEL_${_last_word(MC.DAC_OCP_B_M2, "CH")},
  .DAC_Channel_OCPC      = LL_DAC_CHANNEL_${_last_word(MC.DAC_OCP_C_M2, "CH")},
<#else>
  .DAC_OCP_ASelection    = MC_NULL,
  .DAC_OCP_BSelection    = MC_NULL,
  .DAC_OCP_CSelection    = MC_NULL,
  .DAC_Channel_OCPA      = (uint32_t) 0,
  .DAC_Channel_OCPB      = (uint32_t) 0,
  .DAC_Channel_OCPC      = (uint32_t) 0,
</#if>                                                
<#else>  
  .CompOCPASelection     = MC_NULL,
  .CompOCPAInvInput_MODE = NONE,                          
  .CompOCPBSelection     = MC_NULL,      
  .CompOCPBInvInput_MODE = NONE,              
  .CompOCPCSelection     = MC_NULL,        
  .CompOCPCInvInput_MODE = NONE,  
  .DAC_OCP_ASelection    = MC_NULL,
  .DAC_OCP_BSelection    = MC_NULL,
  .DAC_OCP_CSelection    = MC_NULL,
  .DAC_Channel_OCPA      = (uint32_t) 0,
  .DAC_Channel_OCPB      = (uint32_t) 0,
  .DAC_Channel_OCPC      = (uint32_t) 0,                                         
</#if>

<#if MC.INTERNAL_OVERVOLTAGEPROTECTION2>
  .CompOVPSelection      = OVP_SELECTION2,                  
  .CompOVPInvInput_MODE  = OVP_INVERTINGINPUT_MODE2,  
<#if MC.DAC_OVP_M2 != "NOT_USED">  
  .DAC_OVP_Selection = ${_first_word(MC.DAC_OVP_M2)},
  .DAC_Channel_OVP = LL_DAC_CHANNEL_${_last_word(MC.DAC_OVP_M2, "CH")},
<#else>
  .DAC_OVP_Selection = MC_NULL,
  .DAC_Channel_OVP = (uint32_t) 0,
</#if>  
<#else>
  .CompOVPSelection      = MC_NULL,       
  .CompOVPInvInput_MODE  = NONE,
  .DAC_OVP_Selection = MC_NULL, 
  .DAC_Channel_OVP = (uint32_t) 0,  
</#if>   
                                                         
/* DAC settings --------------------------------------------------------------*/
  .DAC_OCP_Threshold =  ${MC.OCPREF2},                                        
  .DAC_OVP_Threshold =  ${MC.OVPREF2},                                                                                                                           
};                 
 </#if>
    <#if MC.SINGLE_SHUNT2 > 
/**
  * @brief  Current sensor parameters Motor 1 - single shunt - G40x
  */
const R1_Params_t R1_ParamsM2 =
{
/* Dual MC parameters --------------------------------------------------------*/                                                                                                                                
  .FreqRatio       = FREQ_RATIO,                                                                       
  .IsHigherFreqTim = FREQ_RELATION2, 
  .TIMx               = ${_last_word(MC.PWM_TIMER_SELECTION2)}, 
                                                                     
/* Current reading A/D Conversions initialization -----------------------------*/
  .ADCx            = ${MC.ADC_PERIPH2},                        
  .IChannel        = MC_${MC.PHASE_CURRENTS_CHANNEL2},            
                                                                                                            
/* PWM generation parameters --------------------------------------------------*/
  .RepetitionCounter = REP_COUNTER2,                                                                        
  .Tafter            = TAFTER2,                                                                             
  .Tbefore           = TBEFORE2,                                                                             
  .TMin              = TMIN2,                                                                                
  .HTMin             = HTMIN2,                          
  .CHTMin            = CHTMIN2,                         
  .TSample           = SAMPLING_TIME2,                                                                             
           
                                                                
/* PWM Driving signals initialization ----------------------------------------*/
  .LowSideOutputs = (LowSideOutputsFunction_t)LOW_SIDE_SIGNALS_ENABLING2,
<#if MC.LOW_SIDE_SIGNALS_ENABLING2 == "ES_GPIO" >
<#if MC.SHARED_SIGNAL_ENABLE2 == false>    
  .pwm_en_u_port  = M2_PWM_EN_U_GPIO_Port,                                                           
  .pwm_en_u_pin   = M2_PWM_EN_U_Pin,                                                             
  .pwm_en_v_port  = M2_PWM_EN_V_GPIO_Port,                                                       
  .pwm_en_v_pin   = M2_PWM_EN_V_Pin,                                                           
  .pwm_en_w_port  = M2_PWM_EN_W_GPIO_Port,                                                        
  .pwm_en_w_pin   = M2_PWM_EN_W_Pin,    
<#else>
  .pwm_en_u_port  = M2_PWM_EN_UVW_GPIO_Port,                                                           
  .pwm_en_u_pin   = M2_PWM_EN_UVW_Pin,                                                             
  .pwm_en_v_port  = M2_PWM_EN_UVW_GPIO_Port,                                                       
  .pwm_en_v_pin   = M2_PWM_EN_UVW_Pin,                                                           
  .pwm_en_w_port  = M2_PWM_EN_UVW_GPIO_Port,                                                        
  .pwm_en_w_pin   = M2_PWM_EN_UVW_Pin,  
</#if>
<#else>
  .pwm_en_u_port  = MC_NULL,                                                           
  .pwm_en_u_pin   = (uint16_t) 0,                                                             
  .pwm_en_v_port  = MC_NULL,                                                       
  .pwm_en_v_pin   = (uint16_t) 0,                                                           
  .pwm_en_w_port  = MC_NULL,                                                        
  .pwm_en_w_pin   = (uint16_t) 0,   
</#if>       
                                                    
/* Emergency input (BKIN2) signal initialization -----------------------------*/
  .BKIN2Mode      = ${MC.BKIN2_MODE2},                         
  
/* Internal OPAMP common settings --------------------------------------------*/
<#if MC.USE_INTERNAL_OPAMP2>
  .OPAMP_Selection = ${_filter_opamp (MC.OPAMP_SELECTION2)},   
<#else>
  .OPAMP_Selection = MC_NULL,                                                                  
</#if>                                            
/* Internal COMP settings ----------------------------------------------------*/
<#if MC.INTERNAL_OVERCURRENTPROTECTION2>
  .CompOCPSelection = ${MC.OCP_SELECTION2},            
  .CompOCPInvInput_MODE = ${MC.OCP_INVERTINGINPUT_MODE2},  
<#if MC.DAC_OCP_M2 != "NOT_USED">
  .DAC_OCP_Selection    = ${_first_word(MC.DAC_OCP_M2)},
  .DAC_Channel_OCP      = LL_DAC_CHANNEL_${_last_word(MC.DAC_OCP_M2, "CH")},
<#else>
  .DAC_OCP_Selection    = MC_NULL,
  .DAC_Channel_OCP      = (uint32_t) 0,
</#if>  
<#else>                          
  .CompOCPSelection = MC_NULL,                             
  .CompOCPInvInput_MODE = NONE,            
  .DAC_OCP_Selection    = MC_NULL, 
  .DAC_Channel_OCP      = (uint32_t) 0,       
</#if>      
<#if MC.INTERNAL_OVERVOLTAGEPROTECTION2>                                                            
  .CompOVPSelection = OVP_SELECTION2,       
  .CompOVPInvInput_MODE = OVP_INVERTINGINPUT_MODE2,  
<#if MC.DAC_OVP_M2 != "NOT_USED">  
  .DAC_OVP_Selection    =  ${_first_word(MC.DAC_OVP_M2)},
  .DAC_Channel_OVP      = LL_DAC_CHANNEL_${_last_word(MC.DAC_OVP_M2, "CH")},   
<#else>
  .DAC_OVP_Selection    = MC_NULL,
  .DAC_Channel_OVP      = (uint32_t) 0, 
</#if>
<#else>
  .CompOVPSelection = MC_NULL,        
  .CompOVPInvInput_MODE =  NONE,
  .DAC_OVP_Selection    = MC_NULL,  
  .DAC_Channel_OVP      = (uint32_t) 0,   
</#if>                   
                                                      
/* DAC settings --------------------------------------------------------------*/
  .DAC_OCP_Threshold =  ${MC.OCPREF2},                                                                               
  .DAC_OVP_Threshold =  ${MC.OVPREF2},                                                                              
};
  </#if> <#-- SINGLE_SHUNT 2 -->

<#if MC.ICS_SENSORS2>
const ICS_Params_t ICS_ParamsM2 = 
{                                 
/* Dual MC parameters --------------------------------------------------------*/
  .FreqRatio =				FREQ_RATIO,                 
  .IsHigherFreqTim =		FREQ_RELATION,              

/* Current reading A/D Conversions initialization -----------------------------*/
  .ADCx_1 = ${MC.ADC_1_PERIPH2},
  .ADCx_2 = ${MC.ADC_2_PERIPH2},                       
<#if MC.PWM_TIMER_SELECTION2 == "PWM_TIM1">
  .ADCConfig1 =   (MC_${MC.PHASE_U_CURR_CHANNEL2} << ADC_JSQR_JSQ1_Pos) | LL_ADC_INJ_TRIG_EXT_RISING | LL_ADC_INJ_TRIG_EXT_TIM1_TRGO,  
  .ADCConfig2 =   (MC_${MC.PHASE_V_CURR_CHANNEL2} << ADC_JSQR_JSQ1_Pos) | LL_ADC_INJ_TRIG_EXT_RISING | LL_ADC_INJ_TRIG_EXT_TIM1_TRGO,     
<#elseif MC.PWM_TIMER_SELECTION2 == "PWM_TIM8">
<#if MC.PHASE_CURRENTS_ADC2 == "ADC1_2">
  .ADCConfig1 =   (MC_${MC.PHASE_U_CURR_CHANNEL2} << ADC_JSQR_JSQ1_Pos) | LL_ADC_INJ_TRIG_EXT_RISING | LL_ADC_INJ_TRIG_EXT_TIM8_TRGO,  
  .ADCConfig2 =   (MC_${MC.PHASE_V_CURR_CHANNEL2} << ADC_JSQR_JSQ1_Pos) | LL_ADC_INJ_TRIG_EXT_RISING | LL_ADC_INJ_TRIG_EXT_TIM8_TRGO,
<#elseif  MC.PHASE_CURRENTS_ADC2 == "ADC3">
  .ADCConfig1 =   (MC_${MC.PHASE_U_CURR_CHANNEL2} << ADC_JSQR_JSQ1_Pos) | LL_ADC_INJ_TRIG_EXT_RISING | LL_ADC_INJ_TRIG_EXT_TIM8_TRGO,  
  .ADCConfig2 =   (MC_${MC.PHASE_V_CURR_CHANNEL2} << ADC_JSQR_JSQ1_Pos) | LL_ADC_INJ_TRIG_EXT_RISING | LL_ADC_INJ_TRIG_EXT_TIM8_TRGO,
</#if>    
</#if> 

/* PWM generation parameters --------------------------------------------------*/
  .RepetitionCounter =	REP_COUNTER2,                           
  .TIMx               =	${_last_word(MC.PWM_TIMER_SELECTION2)},                   
                                                               
/* PWM Driving signals initialization ----------------------------------------*/
  .LowSideOutputs =	(LowSideOutputsFunction_t)LOW_SIDE_SIGNALS_ENABLING2, 
<#if MC.LOW_SIDE_SIGNALS_ENABLING2 == "ES_GPIO" >  
<#if MC.SHARED_SIGNAL_ENABLE2 == false>                               
  .pwm_en_u_port      = M2_PWM_EN_U_GPIO_Port,                                         
  .pwm_en_u_pin       = M2_PWM_EN_U_Pin,                              
  .pwm_en_v_port      = M2_PWM_EN_V_GPIO_Port,                                              
  .pwm_en_v_pin       = M2_PWM_EN_V_Pin,
  .pwm_en_w_port      = M2_PWM_EN_W_GPIO_Port,                                                       
  .pwm_en_w_pin       = M2_PWM_EN_W_Pin,   
<#else>
  .pwm_en_u_port      = M2_PWM_EN_UVW_GPIO_Port,                                         
  .pwm_en_u_pin       = M2_PWM_EN_UVW_Pin,                              
  .pwm_en_v_port      = M2_PWM_EN_UVW_GPIO_Port,                                              
  .pwm_en_v_pin       = M2_PWM_EN_UVW_Pin,
  .pwm_en_w_port      = M2_PWM_EN_UVW_GPIO_Port,                                                       
  .pwm_en_w_pin       = M2_PWM_EN_UVW_Pin,
</#if>       
<#else>
  .pwm_en_u_port      = MC_NULL,                                         
  .pwm_en_u_pin       = (uint16_t) 0,                              
  .pwm_en_v_port      = MC_NULL,                                              
  .pwm_en_v_pin       = (uint16_t) 0,
  .pwm_en_w_port      = MC_NULL,                                                       
  .pwm_en_w_pin       = (uint16_t) 0, 
</#if> 
                                        
/* Emergengy signal initialization ----------------------------------------*/
  .BKIN2Mode           = ${MC.BKIN2_MODE2},      

};
</#if>

<#if MC.ICS_SENSORS>
  const ICS_Params_t ICS_ParamsM1 = 
{                                 
/* Dual MC parameters --------------------------------------------------------*/
  .FreqRatio =				FREQ_RATIO,                 
  .IsHigherFreqTim =		FREQ_RELATION,              

/* Current reading A/D Conversions initialization -----------------------------*/
  .ADCx_1 = ${MC.ADC_1_PERIPH},
  .ADCx_2 = ${MC.ADC_2_PERIPH},                       
<#if MC.PWM_TIMER_SELECTION == "PWM_TIM1">
  .ADCConfig1 =   (MC_${MC.PHASE_U_CURR_CHANNEL} << ADC_JSQR_JSQ1_Pos) | LL_ADC_INJ_TRIG_EXT_RISING | LL_ADC_INJ_TRIG_EXT_TIM1_TRGO,  
  .ADCConfig2 =   (MC_${MC.PHASE_V_CURR_CHANNEL} << ADC_JSQR_JSQ1_Pos) | LL_ADC_INJ_TRIG_EXT_RISING | LL_ADC_INJ_TRIG_EXT_TIM1_TRGO,     
<#elseif MC.PWM_TIMER_SELECTION == "PWM_TIM8">
<#if MC.PHASE_CURRENTS_ADC == "ADC1_2">
  .ADCConfig1 =   (MC_${MC.PHASE_U_CURR_CHANNEL} << ADC_JSQR_JSQ1_Pos) | LL_ADC_INJ_TRIG_EXT_RISING | LL_ADC_INJ_TRIG_EXT_TIM8_TRGO,  
  .ADCConfig2 =   (MC_${MC.PHASE_V_CURR_CHANNEL} << ADC_JSQR_JSQ1_Pos) | LL_ADC_INJ_TRIG_EXT_RISING | LL_ADC_INJ_TRIG_EXT_TIM8_TRGO,
<#elseif  MC.PHASE_CURRENTS_ADC == "ADC3">
  .ADCConfig1 =   (MC_${MC.PHASE_U_CURR_CHANNEL} << ADC_JSQR_JSQ1_Pos) | LL_ADC_INJ_TRIG_EXT_RISING | LL_ADC_INJ_TRIG_EXT_TIM8_TRGO,  
  .ADCConfig2 =   (MC_${MC.PHASE_V_CURR_CHANNEL} << ADC_JSQR_JSQ1_Pos) | LL_ADC_INJ_TRIG_EXT_RISING | LL_ADC_INJ_TRIG_EXT_TIM8_TRGO,
</#if>    
</#if>  

/* PWM generation parameters --------------------------------------------------*/
  .RepetitionCounter =	REP_COUNTER,                           
  .TIMx               =	${_last_word(MC.PWM_TIMER_SELECTION)},                   
                                                               
/* PWM Driving signals initialization ----------------------------------------*/
  .LowSideOutputs =	(LowSideOutputsFunction_t)LOW_SIDE_SIGNALS_ENABLING, 
<#if MC.LOW_SIDE_SIGNALS_ENABLING == "ES_GPIO" >  
<#if MC.SHARED_SIGNAL_ENABLE == false>                               
  .pwm_en_u_port      = M1_PWM_EN_U_GPIO_Port,                                         
  .pwm_en_u_pin       = M1_PWM_EN_U_Pin,                              
  .pwm_en_v_port      = M1_PWM_EN_V_GPIO_Port,                                              
  .pwm_en_v_pin       = M1_PWM_EN_V_Pin,
  .pwm_en_w_port      = M1_PWM_EN_W_GPIO_Port,                                                       
  .pwm_en_w_pin       = M1_PWM_EN_W_Pin,   
<#else>
  .pwm_en_u_port      = M1_PWM_EN_UVW_GPIO_Port,                                         
  .pwm_en_u_pin       = M1_PWM_EN_UVW_Pin,                              
  .pwm_en_v_port      = M1_PWM_EN_UVW_GPIO_Port,                                              
  .pwm_en_v_pin       = M1_PWM_EN_UVW_Pin,
  .pwm_en_w_port      = M1_PWM_EN_UVW_GPIO_Port,                                                       
  .pwm_en_w_pin       = M1_PWM_EN_UVW_Pin,
</#if>       
<#else>
  .pwm_en_u_port      = MC_NULL,                                         
  .pwm_en_u_pin       = (uint16_t) 0,                              
  .pwm_en_v_port      = MC_NULL,                                              
  .pwm_en_v_pin       = (uint16_t) 0,
  .pwm_en_w_port      = MC_NULL,                                                       
  .pwm_en_w_pin       = (uint16_t) 0, 
</#if> 
                                        
/* Emergengy signal initialization ----------------------------------------*/
  .BKIN2Mode           = ${MC.BKIN2_MODE},      

};
</#if>
  
  <#if MC.THREE_SHUNT_INDEPENDENT_RESOURCES || MC.THREE_SHUNT_SHARED_RESOURCES> <#-- Inside CondFamily_STM32G4 --->
     <#if MC.USE_INTERNAL_OPAMP>
/**
  * @brief  Internal OPAMP parameters Motor 1 - three shunt - G4xx - Shared Resources
  * temporary hard coded to ESC G4 board
  */
R3_3_OPAMPParams_t R3_3_OPAMPParamsM1 =
{
   .OPAMPx_1 = ${MC.OPAMP1_SELECTION},
   .OPAMPx_2 = ${MC.OPAMP2_SELECTION},
   .OPAMPx_3 = <#if MC.INVERTERBOARD == "ESC_G4" >OPAMP3<#else> MC_NULL</#if>,
    // OPAMPMatrix is used to specify if the ADC source comes from internal channel of which OPAMP. 
    <#if MC.INVERTERBOARD != "ESC_G4" >
   .OPAMPSelect_1 = { ${MC.OPAMP1_SELECTION}
                    ,${MC.OPAMP1_SELECTION} 
                    ,${MC.OPAMP1_SELECTION} 
                    ,${MC.OPAMP1_SELECTION} 
                    ,${MC.OPAMP1_SELECTION} 
                    ,${MC.OPAMP1_SELECTION} 
                    },               
  .OPAMPSelect_2 = { ${MC.OPAMP2_SELECTION} 
                    ,${MC.OPAMP2_SELECTION}  
                    ,${MC.OPAMP2_SELECTION}  
                    ,${MC.OPAMP2_SELECTION}  
                    ,${MC.OPAMP2_SELECTION}  
                    ,${MC.OPAMP2_SELECTION}  
                    },                       
  .OPAMPConfig1 = { ${OPAMPPhase_Input (1,"INPUT_1")} 
                   ,${OPAMPPhase_Input (2,"INPUT_1")} 
                   ,${OPAMPPhase_Input (3,"INPUT_1")} 
                   ,${OPAMPPhase_Input (4,"INPUT_1")} 
                   ,${OPAMPPhase_Input (5,"INPUT_1")} 
                   ,${OPAMPPhase_Input (6,"INPUT_1")}  
                 }, 
  .OPAMPConfig2 = { ${OPAMPPhase_Input (1,"INPUT_2")}   
                   ,${OPAMPPhase_Input (2,"INPUT_2")} 
                   ,${OPAMPPhase_Input (3,"INPUT_2")} 
                   ,${OPAMPPhase_Input (4,"INPUT_2")}
                   ,${OPAMPPhase_Input (5,"INPUT_2")}
                   ,${OPAMPPhase_Input (6,"INPUT_2")}
                  },                        
    <#else>
  .OPAMPSelect_1 = { OPAMP3 
                   , NULL   
                   , NULL   
                   , NULL   
                   , NULL   
                   , OPAMP3 
                   },
  .OPAMPSelect_2 = { NULL  
                   , OPAMP3
                   , OPAMP3
                   , NULL  
                   , NULL  
                   , NULL  
                   },                  
 // Define for each config the VPSEL and the Internal output enable bit
  .OPAMPConfig1 = {  0x0 
                    ,0x0 
                    ,0x0 
                    ,0x0 
                    ,0x0 
                    ,0x0  
                  }, 
  .OPAMPConfig2 = {   0x0   
                    , OPAMP_CSR_OPAMPINTEN  
                    , OPAMP_CSR_OPAMPINTEN  
                    , 0x0 
                    , 0x0 
                    , 0x0 
                  }, 
    </#if>              
};
    </#if> 
/**
  * @brief  Current sensor parameters Motor 1 - three shunt - G4 
  */
R3_2_Params_t R3_2_ParamsM1 =
{
/* Dual MC parameters --------------------------------------------------------*/
  .FreqRatio       = FREQ_RATIO,                         
  .IsHigherFreqTim = FREQ_RELATION,                      
                                                          
/* Current reading A/D Conversions initialization -----------------------------*/
  .ADCx_1           = ${MC.ADC_1_PERIPH},                   
  .ADCx_2           = ${MC.ADC_2_PERIPH},
<#if MC.INVERTERBOARD != "ESC_G4" >
  /* Motor Control Kit config */ 
  .ADCConfig1 = { ${ADCConfig(1,"Sampling_1")}
                , ${ADCConfig(2,"Sampling_1")} 
                , ${ADCConfig(3,"Sampling_1")} 
                , ${ADCConfig(4,"Sampling_1")} 
                , ${ADCConfig(5,"Sampling_1")} 
                , ${ADCConfig(6,"Sampling_1")} 
                },
  .ADCConfig2 = { ${ADCConfig(1,"Sampling_2")}
                , ${ADCConfig(2,"Sampling_2")}
                , ${ADCConfig(3,"Sampling_2")}
                , ${ADCConfig(4,"Sampling_2")}
                , ${ADCConfig(5,"Sampling_2")}
                , ${ADCConfig(6,"Sampling_2")} 
                },
  .ADCDataReg1 = { ${ADCDataRead(1,"Sampling_1")}
                 , ${ADCDataRead(2,"Sampling_1")}
                 , ${ADCDataRead(3,"Sampling_1")}
                 , ${ADCDataRead(4,"Sampling_1")}
                 , ${ADCDataRead(5,"Sampling_1")}
                 , ${ADCDataRead(6,"Sampling_1")}                          
                 },
  .ADCDataReg2 = { ${ADCDataRead(1,"Sampling_2")}
                 , ${ADCDataRead(2,"Sampling_2")}
                 , ${ADCDataRead(3,"Sampling_2")}
                 , ${ADCDataRead(4,"Sampling_2")}
                 , ${ADCDataRead(5,"Sampling_2")}
                 , ${ADCDataRead(6,"Sampling_2")}                           
                 },
<#else>
 /* ESC-G4 Kit config */ 
   .ADCConfig1 = {MC_${MC.PHASE_W_CURR_CHANNEL}<<ADC_JSQR_JSQ1_Pos | (LL_ADC_INJ_TRIG_EXT_TIM1_TRGO & ~ADC_INJ_TRIG_EXT_EDGE_DEFAULT)
                 ,MC_${MC.PHASE_U_CURR_CHANNEL}<<ADC_JSQR_JSQ1_Pos | (LL_ADC_INJ_TRIG_EXT_TIM1_TRGO & ~ADC_INJ_TRIG_EXT_EDGE_DEFAULT)
                 ,MC_${MC.PHASE_U_CURR_CHANNEL}<<ADC_JSQR_JSQ1_Pos | (LL_ADC_INJ_TRIG_EXT_TIM1_TRGO & ~ADC_INJ_TRIG_EXT_EDGE_DEFAULT)
                 ,MC_${MC.PHASE_U_CURR_CHANNEL}<<ADC_JSQR_JSQ1_Pos | (LL_ADC_INJ_TRIG_EXT_TIM1_TRGO & ~ADC_INJ_TRIG_EXT_EDGE_DEFAULT)
                 ,MC_${MC.PHASE_U_CURR_CHANNEL}<<ADC_JSQR_JSQ1_Pos | (LL_ADC_INJ_TRIG_EXT_TIM1_TRGO & ~ADC_INJ_TRIG_EXT_EDGE_DEFAULT)
                 ,MC_${MC.PHASE_W_CURR_CHANNEL}<<ADC_JSQR_JSQ1_Pos | (LL_ADC_INJ_TRIG_EXT_TIM1_TRGO & ~ADC_INJ_TRIG_EXT_EDGE_DEFAULT)
                 },
   .ADCConfig2 = {  MC_${MC.PHASE_V_CURR_CHANNEL}<<ADC_JSQR_JSQ1_Pos | (LL_ADC_INJ_TRIG_EXT_TIM1_TRGO & ~ADC_INJ_TRIG_EXT_EDGE_DEFAULT)
                 , 18 << ADC_JSQR_JSQ1_Pos | (LL_ADC_INJ_TRIG_EXT_TIM1_TRGO & ~ADC_INJ_TRIG_EXT_EDGE_DEFAULT)// Phase C ADC2 on channel 18 (OPAMP3)
                 , 18 << ADC_JSQR_JSQ1_Pos | (LL_ADC_INJ_TRIG_EXT_TIM1_TRGO & ~ADC_INJ_TRIG_EXT_EDGE_DEFAULT)
                 , MC_${MC.PHASE_V_CURR_CHANNEL}<<ADC_JSQR_JSQ1_Pos | (LL_ADC_INJ_TRIG_EXT_TIM1_TRGO & ~ADC_INJ_TRIG_EXT_EDGE_DEFAULT)
                 , MC_${MC.PHASE_V_CURR_CHANNEL}<<ADC_JSQR_JSQ1_Pos | (LL_ADC_INJ_TRIG_EXT_TIM1_TRGO & ~ADC_INJ_TRIG_EXT_EDGE_DEFAULT)
                 , MC_${MC.PHASE_V_CURR_CHANNEL}<<ADC_JSQR_JSQ1_Pos | (LL_ADC_INJ_TRIG_EXT_TIM1_TRGO & ~ADC_INJ_TRIG_EXT_EDGE_DEFAULT)
                 },              
  .ADCDataReg1 = { &ADC2->JDR1 // Phase B,
                 , &ADC1->JDR1 // Phase A,
                 , &ADC1->JDR1 // Phase A,
                 , &ADC1->JDR1 // Phase A,
                 , &ADC1->JDR1 // Phase A,
                 , &ADC2->JDR1 // Phase B,                            
                 },
  .ADCDataReg2 = { &ADC1->JDR1 // Phase C
                 , &ADC2->JDR1 // Phase C
                 , &ADC2->JDR1 // Phase C
                 , &ADC2->JDR1 // Phase B
                 , &ADC2->JDR1 // Phase B
                 , &ADC1->JDR1 // Phase C                            
                 },                            
</#if>
  /* PWM generation parameters --------------------------------------------------*/
  .RepetitionCounter = REP_COUNTER,                    
  .Tafter            = TW_AFTER,                       
  .Tbefore           = TW_BEFORE,                      
  .TIMx               = ${_last_word(MC.PWM_TIMER_SELECTION)},            
                                                        
/* PWM Driving signals initialization ----------------------------------------*/
  .LowSideOutputs = (LowSideOutputsFunction_t)LOW_SIDE_SIGNALS_ENABLING, 
<#if MC.LOW_SIDE_SIGNALS_ENABLING == "ES_GPIO" >  
<#if MC.SHARED_SIGNAL_ENABLE == false > 
 .pwm_en_u_port      = M1_PWM_EN_U_GPIO_Port,                   
 .pwm_en_u_pin       = M1_PWM_EN_U_Pin,
 .pwm_en_v_port      = M1_PWM_EN_V_GPIO_Port,                     
 .pwm_en_v_pin       = M1_PWM_EN_V_Pin,                  
 .pwm_en_w_port      = M1_PWM_EN_W_GPIO_Port,                   
 .pwm_en_w_pin       = M1_PWM_EN_W_Pin,
<#else>
 .pwm_en_u_port      = M1_PWM_EN_UVW_GPIO_Port,                   
 .pwm_en_u_pin       = M1_PWM_EN_UVW_Pin,
 .pwm_en_v_port      = M1_PWM_EN_UVW_GPIO_Port,                     
 .pwm_en_v_pin       = M1_PWM_EN_UVW_Pin,                  
 .pwm_en_w_port      = M1_PWM_EN_UVW_GPIO_Port,                   
 .pwm_en_w_pin       = M1_PWM_EN_UVW_Pin,
</#if>
<#else>
 .pwm_en_u_port      = MC_NULL,                   
 .pwm_en_u_pin       = (uint16_t) 0,
 .pwm_en_v_port      = MC_NULL,                     
 .pwm_en_v_pin       = (uint16_t) 0,                  
 .pwm_en_w_port      = MC_NULL,                   
 .pwm_en_w_pin       = (uint16_t) 0,
</#if>
                

/* Emergency input (BKIN2) signal initialization -----------------------------*/
  .BKIN2Mode     = ${MC.BKIN2_MODE},                         

/* Internal OPAMP common settings --------------------------------------------*/
<#if MC.USE_INTERNAL_OPAMP>
  .OPAMPParams     = &R3_3_OPAMPParamsM1,
<#else>  
  .OPAMPParams     = MC_NULL,
</#if>  
/* Internal COMP settings ----------------------------------------------------*/
<#if MC.INTERNAL_OVERCURRENTPROTECTION>
  .CompOCPASelection     = ${MC.OCPA_SELECTION},
  .CompOCPAInvInput_MODE = ${MC.OCPA_INVERTINGINPUT_MODE},                          
  .CompOCPBSelection     = ${MC.OCPB_SELECTION},                
  .CompOCPBInvInput_MODE = ${MC.OCPB_INVERTINGINPUT_MODE},              
  .CompOCPCSelection     = ${MC.OCPC_SELECTION},  
  .CompOCPCInvInput_MODE = ${MC.OCPC_INVERTINGINPUT_MODE},  
<#if (MC.DAC_OCP_A_M1 != "NOT_USED") && (MC.DAC_OCP_B_M1 != "NOT_USED") && (MC.DAC_OCP_C_M1 != "NOT_USED") >  
  .DAC_OCP_ASelection    = ${_first_word(MC.DAC_OCP_A_M1)},
  .DAC_OCP_BSelection    = ${_first_word(MC.DAC_OCP_B_M1)},
  .DAC_OCP_CSelection    = ${_first_word(MC.DAC_OCP_C_M1)},
  .DAC_Channel_OCPA      = LL_DAC_CHANNEL_${_last_word(MC.DAC_OCP_A_M1, "CH")},
  .DAC_Channel_OCPB      = LL_DAC_CHANNEL_${_last_word(MC.DAC_OCP_B_M1, "CH")},
  .DAC_Channel_OCPC      = LL_DAC_CHANNEL_${_last_word(MC.DAC_OCP_C_M1, "CH")},   
<#else>
  .DAC_OCP_ASelection    = MC_NULL,
  .DAC_OCP_BSelection    = MC_NULL,
  .DAC_OCP_CSelection    = MC_NULL,
  .DAC_Channel_OCPA      = (uint32_t) 0,
  .DAC_Channel_OCPB      = (uint32_t) 0,
  .DAC_Channel_OCPC      = (uint32_t) 0,  
</#if>                                                                           
<#else>  
  .CompOCPASelection     = MC_NULL,
  .CompOCPAInvInput_MODE = NONE,                          
  .CompOCPBSelection     = MC_NULL,      
  .CompOCPBInvInput_MODE = NONE,              
  .CompOCPCSelection     = MC_NULL,        
  .CompOCPCInvInput_MODE = NONE,   
  .DAC_OCP_ASelection    = MC_NULL,
  .DAC_OCP_BSelection    = MC_NULL,
  .DAC_OCP_CSelection    = MC_NULL,
  .DAC_Channel_OCPA      = (uint32_t) 0,
  .DAC_Channel_OCPB      = (uint32_t) 0,
  .DAC_Channel_OCPC      = (uint32_t) 0,                                        
</#if>

<#if MC.INTERNAL_OVERVOLTAGEPROTECTION>
  .CompOVPSelection      = OVP_SELECTION,                  
  .CompOVPInvInput_MODE  = OVP_INVERTINGINPUT_MODE,  
<#if MC.DAC_OVP_M1 != "NOT_USED">    
  .DAC_OVP_Selection     = ${_first_word(MC.DAC_OVP_M1)},
  .DAC_Channel_OVP       = LL_DAC_CHANNEL_${_last_word(MC.DAC_OVP_M1, "CH")},
<#else>
  .DAC_OVP_Selection     = MC_NULL,
  .DAC_Channel_OVP       = (uint32_t) 0,
</#if>  
<#else>
  .CompOVPSelection      = MC_NULL,       
  .CompOVPInvInput_MODE  = NONE,
  .DAC_OVP_Selection     = MC_NULL,
  .DAC_Channel_OVP       = (uint32_t) 0,   
</#if>   
                                                         
/* DAC settings --------------------------------------------------------------*/
  .DAC_OCP_Threshold =  ${MC.OCPREF},                                        
  .DAC_OVP_Threshold =  ${MC.OVPREF},                                                                       
                                                    
};
  </#if> <#-- if MC.THREE_SHUNT --> <#-- Inside CondFamily_STM32G4 -->  
  
   <#if MC.SINGLE_SHUNT > 
/**
  * @brief  Current sensor parameters Motor 1 - single shunt - F30x
  */
const R1_Params_t R1_ParamsM1 =
{
/* Dual MC parameters --------------------------------------------------------*/                                                                                                                                
  .FreqRatio       = FREQ_RATIO,                                                                       
  .IsHigherFreqTim = FREQ_RELATION, 
  .TIMx               = ${_last_word(MC.PWM_TIMER_SELECTION)}, 
                                                                     
/* Current reading A/D Conversions initialization -----------------------------*/
  .ADCx            = ${MC.ADC_PERIPH},                        
  .IChannel        = MC_${MC.PHASE_CURRENTS_CHANNEL},            
                                                                                                            
/* PWM generation parameters --------------------------------------------------*/
  .RepetitionCounter = REP_COUNTER,                                                                        
  .Tafter            = TAFTER,                                                                             
  .Tbefore           = TBEFORE,                                                                             
  .TMin              = TMIN,                                                                                
  .HTMin             = HTMIN,                          
  .CHTMin            = CHTMIN,                         
  .TSample           = SAMPLING_TIME,                                                                             
           
                                                                
/* PWM Driving signals initialization ----------------------------------------*/
  .LowSideOutputs = (LowSideOutputsFunction_t)LOW_SIDE_SIGNALS_ENABLING,
<#if MC.LOW_SIDE_SIGNALS_ENABLING == "ES_GPIO" >
<#if MC.SHARED_SIGNAL_ENABLE == false>    
  .pwm_en_u_port  = M1_PWM_EN_U_GPIO_Port,                                                           
  .pwm_en_u_pin   = M1_PWM_EN_U_Pin,                                                             
  .pwm_en_v_port  = M1_PWM_EN_V_GPIO_Port,                                                       
  .pwm_en_v_pin   = M1_PWM_EN_V_Pin,                                                           
  .pwm_en_w_port  = M1_PWM_EN_W_GPIO_Port,                                                        
  .pwm_en_w_pin   = M1_PWM_EN_W_Pin,    
<#else>
  .pwm_en_u_port  = M1_PWM_EN_UVW_GPIO_Port,                                                           
  .pwm_en_u_pin   = M1_PWM_EN_UVW_Pin,                                                             
  .pwm_en_v_port  = M1_PWM_EN_UVW_GPIO_Port,                                                       
  .pwm_en_v_pin   = M1_PWM_EN_UVW_Pin,                                                           
  .pwm_en_w_port  = M1_PWM_EN_UVW_GPIO_Port,                                                        
  .pwm_en_w_pin   = M1_PWM_EN_UVW_Pin,  
</#if>
<#else>
  .pwm_en_u_port  = MC_NULL,                                                           
  .pwm_en_u_pin   = (uint16_t) 0,                                                             
  .pwm_en_v_port  = MC_NULL,                                                       
  .pwm_en_v_pin   = (uint16_t) 0,                                                           
  .pwm_en_w_port  = MC_NULL,                                                        
  .pwm_en_w_pin   = (uint16_t) 0,   
</#if>       
                                                    
/* Emergency input (BKIN2) signal initialization -----------------------------*/
  .BKIN2Mode      = ${MC.BKIN2_MODE},                         
  
/* Internal OPAMP common settings --------------------------------------------*/
<#if MC.USE_INTERNAL_OPAMP>
  .OPAMP_Selection = ${_filter_opamp (MC.OPAMP_SELECTION)},   
<#else>
  .OPAMP_Selection = MC_NULL,                                                                  
</#if>                                            
/* Internal COMP settings ----------------------------------------------------*/
<#if MC.INTERNAL_OVERCURRENTPROTECTION>
  .CompOCPSelection = ${MC.OCP_SELECTION},            
  .CompOCPInvInput_MODE = ${MC.OCP_INVERTINGINPUT_MODE},  
<#if MC.DAC_OCP_M1 != "NOT_USED">  
  .DAC_OCP_Selection    = ${_first_word(MC.DAC_OCP_M1)},
  .DAC_Channel_OCP      = LL_DAC_CHANNEL_${_last_word(MC.DAC_OCP_M1, "CH")},  
<#else>
  .DAC_OCP_Selection    = MC_NULL,
  .DAC_Channel_OCP      = (uint32_t) 0,
</#if>    
<#else>                          
  .CompOCPSelection = MC_NULL,                             
  .CompOCPInvInput_MODE = NONE,                             
</#if>      
<#if MC.INTERNAL_OVERVOLTAGEPROTECTION>                                                            
  .CompOVPSelection = OVP_SELECTION,       
  .CompOVPInvInput_MODE = OVP_INVERTINGINPUT_MODE,  
<#if MC.DAC_OVP_M1 != "NOT_USED">  
  .DAC_OVP_Selection     = ${_first_word(MC.DAC_OVP_M1)},
  .DAC_Channel_OVP       = LL_DAC_CHANNEL_${_last_word(MC.DAC_OVP_M1, "CH")},  
<#else>
  .DAC_OVP_Selection     = MC_NULL,
  .DAC_Channel_OVP       = (uint32_t) 0,  
</#if>   
<#else>
  .CompOVPSelection = MC_NULL,        
  .CompOVPInvInput_MODE =  NONE,
</#if>                   
                                                      
/* DAC settings --------------------------------------------------------------*/
  .DAC_OCP_Threshold =  ${MC.OCPREF},                                                                               
  .DAC_OVP_Threshold =  ${MC.OVPREF},                                                                              
};
  </#if> <#-- SINGLE_SHUNT -->
  
</#if><#-- CondFamily_STM32G4 -->  

<#if MC.PFC_ENABLED == true>
const PFC_Parameters_t PFC_Params = 
{
  .ADCx                     = ADC2,
  .TIMx                     = TIM3,
  .DMAx                     = DMA1,
  .DMAChannel               = LL_DMA_CHANNEL_3, 
  .wCPUFreq                 = SYSCLK_FREQ,
  .wPWMFreq                 = PFC_PWMFREQ,
  .hPWMARR                  = (SYSCLK_FREQ/PFC_PWMFREQ),
  .bFaultPolarity           = PFC_FAULTPOLARITY,
  .hFaultPort               = PFC_FAULTPORT,
  .hFaultPin                = PFC_FAULTPIN,
  .bCurrentLoopRate         = (uint8_t) (PFC_PWMFREQ/PFC_CURRCTRLFREQUENCY),
  .bVoltageLoopRate         = (uint8_t) (SYS_TICK_FREQUENCY/PFC_VOLTCTRLFREQUENCY),
  .hNominalCurrent          = (int16_t) PFC_NOMINALCURRENTS16A,
  .hMainsFreqLowTh          = PFC_MAINSFREQLOWTHR,
  .hMainsFreqHiTh           = PFC_MAINSFREQHITHR,
  .OutputPowerActivation    = PFC_OUTPUTPOWERACTIVATION,
  .OutputPowerDeActivation  = PFC_OUTPUTPOWERDEACTIVATION,
  .SWOverVoltageTh          = PFC_SWOVERVOLTAGETH,
  .hPropDelayOnTimCk        = (uint16_t) (PFC_PROPDELAYON/PFC_TIMCK_NS),
  .hPropDelayOffTimCk       = (uint16_t) (PFC_PROPDELAYOFF/PFC_TIMCK_NS),
  .hADCSamplingTimeTimCk    = (uint16_t) (SYSCLK_FREQ/(ADC_CLK_MHz*1000000.0)*PFC_ISAMPLINGTIMEREAL),
  .hADCConversionTimeTimCk  = (uint16_t) (SYSCLK_FREQ/(ADC_CLK_MHz*1000000.0)*12),
  .hADCLatencyTimeTimCk     = (uint16_t) (SYSCLK_FREQ/(ADC_CLK_MHz*1000000.0)*3),
  .hMainsConversionFactor   = (uint16_t) (32767.0/(3.3 * PFC_VMAINS_PARTITIONING_FACTOR)),
  .hCurrentConversionFactor = (uint16_t) ((PFC_SHUNTRESISTOR*PFC_AMPLGAIN*65536.0)/3.3)
};
</#if>

<#if MC.MOTOR_PROFILER == true>

/*** Motor Profiler ***/

SCC_Params_t SCC_Params = 
{
  {
    .FrequencyHz = TF_REGULATION_RATE,
  },
  .fRshunt = RSHUNT,   
  .fAmplificationGain = AMPLIFICATION_GAIN, 
  .fVbusConvFactor = BUS_VOLTAGE_CONVERSION_FACTOR,
  .fVbusPartitioningFactor = VBUS_PARTITIONING_FACTOR, 
  
  .fRVNK = (float)(CALIBRATION_FACTOR),
                        
  .fRSMeasCurrLevelMax = (float)(DC_CURRENT_RS_MEAS),
  
  .hDutyRampDuration  = (uint16_t) 8000,  
  
  .hAlignmentDuration = (uint16_t)(1000),
  .hRSDetectionDuration = (uint16_t)(500),   
  .fLdLqRatio = (float)(LDLQ_RATIO),
  .fCurrentBW = (float)(CURRENT_REGULATOR_BANDWIDTH),
  .bPBCharacterization = false,         
                      
  .wNominalSpeed = MOTOR_MAX_SPEED_RPM, 
  .hPWMFreqHz = (uint16_t)(PWM_FREQUENCY), 
  .bFOCRepRate = (uint8_t)(REGULATION_EXECUTION_RATE), 
  .fMCUPowerSupply = (float) ADC_REFERENCE_VOLTAGE,	
  .IThreshold = I_THRESHOLD

};

OTT_Params_t OTT_Params =
{
  {
    .FrequencyHz = MEDIUM_FREQUENCY_TASK_RATE, /*!< Frequency expressed in Hz at which the user
                                   clocks the OTT calling OTT_MF method */
  },
  .fBWdef = (float)(SPEED_REGULATOR_BANDWIDTH),/*!< Default bandwidth of speed regulator.*/
  .fMeasWin = 1.0f,                       /*!< Duration of measurement window for speed and
                                   current Iq, expressed in seconds.*/
  .bPolesPairs = POLE_PAIR_NUM,              /*!< Number of motor poles pairs.*/
  .hMaxPositiveTorque = (int16_t)NOMINAL_CURRENT,   /*!< Maximum positive value of motor
                                   torque. This value represents
                                   actually the maximum Iq current
                                   expressed in digit.*/
  .fCurrtRegStabTimeSec = 10.0f,                      /*!< Current regulation stabilization time in seconds.*/
  .fOttLowSpeedPerc = 0.6f,                       /*!< OTT lower speed percentage.*/
  .fOttHighSpeedPerc = 0.8f,                       /*!< OTT higher speed percentage.*/
  .fSpeedStabTimeSec = 20.0f,                      /*!< Speed stabilization time in seconds.*/
  .fTimeOutSec = 10.0f,                      /*!< Timeout for speed stabilization.*/
  .fSpeedMargin = 0.90f,                      /*!< Speed margin percentage to validate speed ctrl.*/
  .wNominalSpeed = MOTOR_MAX_SPEED_RPM,        /*!< Nominal speed set by the user expressed in RPM.*/
  .spdKp = MP_KP,                      /*!< Initial KP factor of the speed regulator to be tuned.*/
  .spdKi = MP_KI,                      /*!< Initial KI factor of the speed regulator to be tuned.*/
  .spdKs = 0.1f,                       /*!< Initial antiwindup factor of the speed regulator to be tuned.*/
  .fRshunt = (float)(RSHUNT),            /*!< Value of shunt resistor.*/
  .fAmplificationGain = (float)(AMPLIFICATION_GAIN) /*!< Current sensing amplification gain.*/

};

</#if>

/* USER CODE BEGIN Additional parameters */


/* USER CODE END Additional parameters */  

/******************* (C) COPYRIGHT 2019 STMicroelectronics *****END OF FILE****/
