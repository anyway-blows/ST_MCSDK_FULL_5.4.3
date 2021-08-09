<#import "../cmns/ioc_Mcu_PCC.ftl" as u >
<@u.ioc_Mcu_PCC
{ "Family"    : "STM32F0"
, "Package"   : "LQFP64"
, "Name"      : "STM32F030RCTx"
, "UserName"  : "STM32F030RCTx"
, "Line"      : "STM32F0x0 Value Line"
} />

<#include "../cmns/basic_ips_and_pins.ftl" >



NVIC.NonMaskableInt_IRQn=true\:0\:0\:false\:false\:false\:false
NVIC.PendSV_IRQn=true\:0\:0\:false\:false\:false\:false
NVIC.SVC_IRQn=true\:0\:0\:false\:false\:false\:false
NVIC.HardFault_IRQn=true\:0\:0\:false\:false\:false\:false\:false
NVIC.SysTick_IRQn=true\:2\:0\:true\:false\:false\:false\:false

RCC.AHBFreq_Value=48000000
RCC.APB1Freq_Value=48000000
RCC.APB1TimFreq_Value=48000000
RCC.EnbaleCSS=true
RCC.FCLKCortexFreq_Value=48000000
RCC.FamilyName=M
RCC.HCLKFreq_Value=48000000
RCC.IPParameters=AHBFreq_Value,APB1Freq_Value,APB1TimFreq_Value,EnbaleCSS,FCLKCortexFreq_Value,FamilyName,HCLKFreq_Value,MCOFreq_Value,PLLCLKFreq_Value,PLLMCOFreq_Value,PLLMUL,PLLSourceVirtual,SYSCLKFreq_VALUE,SYSCLKSource,TimSysFreq_Value,USART1Freq_Value,VCOOutput2Freq_Value
RCC.MCOFreq_Value=48000000
RCC.PLLCLKFreq_Value=48000000
RCC.PLLMCOFreq_Value=48000000
RCC.PLLMUL=RCC_PLL_MUL6
RCC.PLLSourceVirtual=RCC_PLLSOURCE_HSE
RCC.SYSCLKFreq_VALUE=48000000
RCC.SYSCLKSource=RCC_SYSCLKSOURCE_PLLCLK
RCC.TimSysFreq_Value=48000000
RCC.USART1Freq_Value=48000000
RCC.VCOOutput2Freq_Value=8000000
