<#import "../../../mcus/F4/cmns/ioc_Mcu_PCC.ftl" as u >

<@u.ioc_Mcu_PCC
{ "Family"    : "STM32F4"
, "Package"   : "LQFP144"
, "Name"      : "STM32F415ZGTx"
, "UserName"  : "STM32F415ZGTx"
, "Line"      : "STM32F405/415"
} />

<#include "../../../mcus/F4/cmns/FreeRTOS_IsAvaliable.ftl">
<#--<#include "../../../mcus/F4/cmns/Sys_Jtms_pin.ftl" >-->
<#include "../../../mcus/F4/cmns/OSC_IN-OSC_OUT.ftl" >

<#global DAC1 = "DAC" >

<#--
Mcu.Family=STM32F4
Mcu.Name=STM32F415ZGTx
Mcu.UserName=STM32F415ZGTx
Mcu.Package=LQFP144

${ Mcu.IPs ( "NVIC"
, "RCC"
, "SYS"
)}
${ Mcu.PINs( "PH0-OSC_IN"
, "PH1-OSC_OUT"
, "VP_SYS_VS_Systick"
)}
<#global DAC1 = "DAC" >

NVIC.BusFault_IRQn=true\:0\:0\:false\:false\:false\:false
NVIC.DebugMonitor_IRQn=true\:0\:0\:false\:false\:false\:false
NVIC.HardFault_IRQn=true\:0\:0\:false\:false\:false\:false
NVIC.MemoryManagement_IRQn=true\:0\:0\:false\:false\:false\:false
NVIC.NonMaskableInt_IRQn=true\:0\:0\:false\:false\:false\:false
NVIC.PendSV_IRQn=true\:0\:0\:false\:false\:false\:false
NVIC.PriorityGroup=NVIC_PRIORITYGROUP_3
NVIC.SVCall_IRQn=true\:0\:0\:false\:false\:false\:false
NVIC.SysTick_IRQn=true\:4\:0\:true\:false\:false\:false
NVIC.UsageFault_IRQn=true\:0\:0\:false\:false\:false\:false

PCC.Checker=false
PCC.Line=STM32F405/415
PCC.MCU=STM32F415ZGTx
PCC.PartNumber=STM32F415ZGTx
PCC.Seq0=0
PCC.Series=STM32F4
PCC.Temperature=25
PCC.Vdd=3.3

# PINs for the External OSCILLATOR
PH0-OSC_IN.Locked=true
PH0-OSC_IN.Mode=HSE-External-Oscillator
PH0-OSC_IN.Signal=RCC_OSC_IN
PH1-OSC_OUT.Locked=true
PH1-OSC_OUT.Mode=HSE-External-Oscillator
PH1-OSC_OUT.Signal=RCC_OSC_OUT

VP_SYS_VS_Systick.Mode=SysTick
VP_SYS_VS_Systick.Signal=SYS_VS_Systick
-->


RCC.48MHZClocksFreq_Value=84000000
RCC.AHBFreq_Value=168000000
RCC.APB1CLKDivider=RCC_HCLK_DIV4
RCC.APB1Freq_Value=42000000
RCC.APB1TimFreq_Value=84000000
RCC.APB2CLKDivider=RCC_HCLK_DIV2
RCC.APB2Freq_Value=84000000
RCC.APB2TimFreq_Value=168000000
RCC.CortexFreq_Value=168000000
RCC.EnbaleCSS=true
RCC.EthernetFreq_Value=168000000
RCC.FCLKCortexFreq_Value=168000000
RCC.FamilyName=M
RCC.HCLKFreq_Value=168000000
RCC.HSE_VALUE=16000000
RCC.HSI_VALUE=16000000
RCC.I2SClocksFreq_Value=192000000
RCC.IPParameters=48MHZClocksFreq_Value,AHBFreq_Value,APB1CLKDivider,APB1Freq_Value,APB1TimFreq_Value,APB2CLKDivider,APB2Freq_Value,APB2TimFreq_Value,CortexFreq_Value,EnbaleCSS,EthernetFreq_Value,FCLKCortexFreq_Value,FamilyName,HCLKFreq_Value,HSE_VALUE,HSI_VALUE,I2SClocksFreq_Value,LSE_VALUE,LSI_VALUE,MCO2PinFreq_Value,PLLCLKFreq_Value,PLLM,PLLN,PLLQCLKFreq_Value,PLLSourceVirtual,RTCFreq_Value,RTCHSEDivFreq_Value,SYSCLKFreq_VALUE,SYSCLKSource,VCOI2SOutputFreq_Value,VCOInputFreq_Value,VCOOutputFreq_Value,VcooutputI2S
RCC.LSE_VALUE=32768
RCC.LSI_VALUE=32000
RCC.MCO2PinFreq_Value=168000000
RCC.PLLCLKFreq_Value=168000000
RCC.PLLM=8
RCC.PLLN=168
RCC.PLLQCLKFreq_Value=84000000
RCC.PLLSourceVirtual=RCC_PLLSOURCE_HSE
RCC.RTCFreq_Value=32000
RCC.RTCHSEDivFreq_Value=8000000
RCC.SYSCLKFreq_VALUE=168000000
RCC.SYSCLKSource=RCC_SYSCLKSOURCE_PLLCLK
RCC.VCOI2SOutputFreq_Value=384000000
RCC.VCOInputFreq_Value=2000000
RCC.VCOOutputFreq_Value=336000000
RCC.VcooutputI2S=192000000