<#import "../../../mcus/cmns/ioc_Mcu_PCC.ftl" as u >
<@u.ioc_Mcu_PCC
{ "Family"    : "STM32F1"
, "Package"   : "LQFP64"
, "Name"      : "STM32F103R(8-B)Tx"
, "UserName"  : "STM32F103RBTx"
, "Line"      : "STM32F103"
} />

<#global DAC1 = "DAC" >


<#include "../../../mcus/cmns/FreeRTOS_IsAvaliable.ftl">
<#include "../../../mcus/F1/cmns/D-OSC_IN-D-OSC_OUT.ftl">

<#include "../../../mcus/F1/cmns/Sys_Jtms_pin.ftl" >


RCC.ADCFreqValue=12000000
RCC.ADCPresc=RCC_ADCPCLK2_DIV6
RCC.AHBFreq_Value=72000000
RCC.APB1CLKDivider=RCC_HCLK_DIV2
RCC.APB1Freq_Value=36000000
RCC.APB1TimFreq_Value=72000000
RCC.APB2Freq_Value=72000000
RCC.APB2TimFreq_Value=72000000
RCC.EnbaleCSS=true
RCC.FCLKCortexFreq_Value=72000000
RCC.FamilyName=M
RCC.HCLKFreq_Value=72000000
RCC.IPParameters=ADCFreqValue,ADCPresc,AHBFreq_Value,APB1CLKDivider,APB1Freq_Value,APB1TimFreq_Value,APB2Freq_Value,APB2TimFreq_Value,EnbaleCSS,FCLKCortexFreq_Value,FamilyName,HCLKFreq_Value,MCOFreq_Value,PLLCLKFreq_Value,PLLMCOFreq_Value,PLLMUL,PLLSourceVirtual,RTCClockSelection,RTCFreq_Value,SYSCLKFreq_VALUE,SYSCLKSource,TimSysFreq_Value,USBFreq_Value,VCOOutput2Freq_Value
RCC.MCOFreq_Value=72000000
RCC.PLLCLKFreq_Value=72000000
RCC.PLLMCOFreq_Value=36000000
RCC.PLLMUL=RCC_PLL_MUL9
RCC.PLLSourceVirtual=RCC_PLLSOURCE_HSE
RCC.RTCClockSelection=RCC_RTCCLKSOURCE_LSE
RCC.RTCFreq_Value=32768
RCC.SYSCLKFreq_VALUE=72000000
RCC.SYSCLKSource=RCC_SYSCLKSOURCE_PLLCLK
RCC.TimSysFreq_Value=72000000
RCC.USBFreq_Value=72000000
RCC.VCOOutput2Freq_Value=8000000