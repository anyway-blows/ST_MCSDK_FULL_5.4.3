<#import "../../../mcus/F4/cmns/ioc_Mcu_PCC.ftl" as u >

<@u.ioc_Mcu_PCC
{ "Family"    : "STM32F4"
, "Package"   : "LQFP64"
, "Name"      : "STM32F446R(C-E)Tx"
, "UserName"  : "STM32F446RETx"
, "Line"      : "STM32F446"
} />

<#include "../../../mcus/F4/cmns/FreeRTOS_IsAvaliable.ftl">
<#--<#include "../../../mcus/F4/cmns/Sys_Jtms_pin.ftl" >-->
<#include "../../../mcus/F4/cmns/OSC_IN-OSC_OUT.ftl" >

<#global DAC1 = "DAC" >
<#--

Mcu.Family=STM32F4
Mcu.Name=STM32F446R(C-E)Tx
Mcu.UserName=STM32F446RETx
Mcu.Package=LQFP64

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
PCC.Line=STM32F446
PCC.MCU=STM32F446R(C-E)Tx
PCC.PartNumber=STM32F446RETx
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

RCC.AHBFreq_Value=180000000
RCC.APB1CLKDivider=RCC_HCLK_DIV4
RCC.APB1Freq_Value=45000000
RCC.APB1TimFreq_Value=90000000
RCC.APB2CLKDivider=RCC_HCLK_DIV2
RCC.APB2Freq_Value=90000000
RCC.APB2TimFreq_Value=180000000
RCC.CECFreq_Value=32786.88524590164
RCC.CortexFreq_Value=180000000
RCC.FCLKCortexFreq_Value=180000000
RCC.FMPI2C1Freq_Value=45000000
RCC.FamilyName=M
RCC.HCLKFreq_Value=180000000
RCC.HSE_VALUE=25000000
RCC.I2S1Freq_Value=150000000
RCC.I2S2Freq_Value=150000000
RCC.EnbaleCSS=true
RCC.IPParameters=AHBFreq_Value,APB1CLKDivider,APB1Freq_Value,APB1TimFreq_Value,APB2CLKDivider,APB2Freq_Value,APB2TimFreq_Value,CECFreq_Value,CortexFreq_Value,EnbaleCSS,FCLKCortexFreq_Value,FMPI2C1Freq_Value,FamilyName,HCLKFreq_Value,HSE_VALUE,I2S1Freq_Value,I2S2Freq_Value,MCO2PinFreq_Value,PLLCLKFreq_Value,PLLI2SPCLKFreq_Value,PLLI2SQCLKFreq_Value,PLLI2SRCLKFreq_Value,PLLI2SoutputFreq_Value,PLLM,PLLN,PLLQCLKFreq_Value,PLLRCLKFreq_Value,PLLSAIPCLKFreq_Value,PLLSAIQCLKFreq_Value,PLLSAIoutputFreq_Value,PLLSourceVirtual,PWRFreq_Value,SAIAFreq_Value,SAIBFreq_Value,SDIOFreq_Value,SPDIFRXFreq_Value,SYSCLKFreq_VALUE,SYSCLKSource,USBFreq_Value,VCOI2SInputFreq_Value,VCOI2SOutputFreq_Value,VCOInputFreq_Value,VCOOutputFreq_Value,VCOSAIInputFreq_Value,VCOSAIOutputFreq_Value
RCC.MCO2PinFreq_Value=180000000
RCC.PLLCLKFreq_Value=180000000
RCC.PLLI2SPCLKFreq_Value=150000000
RCC.PLLI2SQCLKFreq_Value=150000000
RCC.PLLI2SRCLKFreq_Value=150000000
RCC.PLLI2SoutputFreq_Value=150000000
RCC.PLLM=15
RCC.PLLN=216
RCC.PLLQCLKFreq_Value=180000000
RCC.PLLRCLKFreq_Value=180000000
RCC.PLLSAIPCLKFreq_Value=150000000
RCC.PLLSAIQCLKFreq_Value=150000000
RCC.PLLSAIoutputFreq_Value=150000000
RCC.PLLSourceVirtual=RCC_PLLSOURCE_HSE
RCC.PWRFreq_Value=180000000
RCC.SAIAFreq_Value=150000000
RCC.SAIBFreq_Value=150000000
RCC.SDIOFreq_Value=180000000
RCC.SPDIFRXFreq_Value=180000000
RCC.SYSCLKFreq_VALUE=180000000
RCC.SYSCLKSource=RCC_SYSCLKSOURCE_PLLCLK
RCC.USBFreq_Value=180000000
RCC.VCOI2SInputFreq_Value=1562500
RCC.VCOI2SOutputFreq_Value=300000000
RCC.VCOInputFreq_Value=1666666.6666666667
RCC.VCOOutputFreq_Value=360000000
RCC.VCOSAIInputFreq_Value=1562500
RCC.VCOSAIOutputFreq_Value=300000000
