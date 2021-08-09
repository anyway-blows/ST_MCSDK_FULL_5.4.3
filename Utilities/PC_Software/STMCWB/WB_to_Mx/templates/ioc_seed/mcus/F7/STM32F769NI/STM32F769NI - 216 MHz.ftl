<#global DAC1 = "DAC" >

<#import "../../cmns/ioc_Mcu_PCC.ftl" as u >
<@u.ioc_Mcu_PCC
{ "Family"    : "STM32F7"
, "Package"   : "TFBGA216"
, "Name"      : "STM32F769NIHx"
, "UserName"  : "STM32F769NIHx"
, "Line"      : "STM32F7x9"
} />

############################################################
# PINs for the External OSCILLATOR                         #
############################################################
#
<#import "../../../ioc_collect_pins_and_ips.ftl" as Mcu>
#
${ Mcu.PINs("PH0/OSC_IN", "PH1/OSC_OUT") }
#
PH0/OSC_IN.Locked=true
PH0/OSC_IN.Mode=HSE-External-Oscillator
PH0/OSC_IN.Signal=RCC_OSC_IN
#
PH1/OSC_OUT.Locked=true
PH1/OSC_OUT.Mode=HSE-External-Oscillator
PH1/OSC_OUT.Signal=RCC_OSC_OUT
############################################################

<#--${ Mcu.IPs("CORTEX_M7") }-->
<#--<#include "../../../mcus/cmns/NVIC_seed.ftl" >-->
<#include "../../../mcus/cmns/FreeRTOS_IsAvaliable.ftl">

# 216 MHz specific settings
RCC.AHBFreq_Value=216000000
RCC.APB1CLKDivider=RCC_HCLK_DIV4
RCC.APB1Freq_Value=54000000
RCC.APB1TimFreq_Value=108000000
RCC.APB2CLKDivider=RCC_HCLK_DIV2
RCC.APB2Freq_Value=108000000
RCC.APB2TimFreq_Value=216000000
RCC.CECFreq_Value=32786.88524590164
RCC.CortexFreq_Value=216000000
RCC.DFSDMAudioFreq_Value=96000000
RCC.DFSDMFreq_Value=108000000
RCC.DSIFreq_Value=62500000
RCC.DSITXEscFreq_Value=15625000
RCC.EnbaleCSS=true
RCC.EthernetFreq_Value=216000000
RCC.FCLKCortexFreq_Value=216000000
RCC.FamilyName=M
RCC.HCLKFreq_Value=216000000
RCC.HSE_VALUE=25000000
RCC.HSI_VALUE=16000000
RCC.I2C1Freq_Value=54000000
RCC.I2C2Freq_Value=54000000
RCC.I2C3Freq_Value=54000000
RCC.I2C4Freq_Value=54000000
RCC.I2SFreq_Value=96000000
RCC.LCDTFTFreq_Value=48000000
RCC.LPTIM1Freq_Value=54000000
RCC.LSE_VALUE=32768
RCC.LSI_VALUE=32000
RCC.MCO2PinFreq_Value=216000000
RCC.PLLCLKFreq_Value=216000000
RCC.PLLDSIVCOFreq_Value=1000000000
RCC.PLLI2SPCLKFreq_Value=96000000
RCC.PLLI2SQCLKFreq_Value=96000000
RCC.PLLI2SRCLKFreq_Value=96000000
RCC.PLLI2SRoutputFreq_Value=96000000
RCC.PLLM=25
RCC.PLLN=432
RCC.PLLQCLKFreq_Value=216000000
RCC.PLLQoutputFreq_Value=216000000
RCC.PLLRFreq_Value=216000000
RCC.PLLSAIPCLKFreq_Value=96000000
RCC.PLLSAIQCLKFreq_Value=96000000
RCC.PLLSAIRCLKFreq_Value=96000000
RCC.PLLSAIoutputFreq_Value=96000000
RCC.PLLSourceVirtual=RCC_PLLSOURCE_HSE
RCC.RNGFreq_Value=216000000
RCC.SAI1Freq_Value=96000000
RCC.SAI2Freq_Value=96000000
RCC.SDMMC2Freq_Value=216000000
RCC.SDMMCFreq_Value=216000000
RCC.SPDIFRXFreq_Value=96000000
RCC.SYSCLKFreq_VALUE=216000000
RCC.SYSCLKSource=RCC_SYSCLKSOURCE_PLLCLK

<#list ["USART1", "USART2", "USART3", "UART4", "UART5", "USART6", "UART7", "UART8"] as ip>
RCC.${ ip }CLockSelection=RCC_${ ip }CLKSOURCE_SYSCLK
</#list>

RCC.USBFreq_Value=216000000

RCC.VCOI2SOutputFreq_Value=192000000
RCC.VCOInputFreq_Value=1000000
RCC.VCOOutputFreq_Value=432000000
RCC.VCOSAIOutputFreq_Value=192000000

RCC.IPParameters=AHBFreq_Value,APB1CLKDivider,APB1Freq_Value,APB1TimFreq_Value,APB2CLKDivider,APB2Freq_Value,APB2TimFreq_Value,CECFreq_Value,CortexFreq_Value,DFSDMAudioFreq_Value,DFSDMFreq_Value,DSIFreq_Value,DSITXEscFreq_Value,EnbaleCSS,EthernetFreq_Value,FCLKCortexFreq_Value,FamilyName,HCLKFreq_Value,HSE_VALUE,HSI_VALUE,I2C1Freq_Value,I2C2Freq_Value,I2C3Freq_Value,I2C4Freq_Value,I2SFreq_Value,LCDTFTFreq_Value,LPTIM1Freq_Value,LSE_VALUE,LSI_VALUE,MCO2PinFreq_Value,PLLCLKFreq_Value,PLLDSIVCOFreq_Value,PLLI2SPCLKFreq_Value,PLLI2SQCLKFreq_Value,PLLI2SRCLKFreq_Value,PLLI2SRoutputFreq_Value,PLLM,PLLN,PLLQCLKFreq_Value,PLLQoutputFreq_Value,PLLRFreq_Value,PLLSAIPCLKFreq_Value,PLLSAIQCLKFreq_Value,PLLSAIRCLKFreq_Value,PLLSAIoutputFreq_Value,PLLSourceVirtual,RNGFreq_Value,SAI1Freq_Value,SAI2Freq_Value,SDMMC2Freq_Value,SDMMCFreq_Value,SPDIFRXFreq_Value,SYSCLKFreq_VALUE,SYSCLKSource,\
USART1CLockSelection,\
USART2CLockSelection,\
USART3CLockSelection,\
UART4CLockSelection,\
UART5CLockSelection,\
USART6CLockSelection,\
UART7CLockSelection,\
UART8CLockSelection,\
USBFreq_Value,VCOI2SOutputFreq_Value,VCOInputFreq_Value,VCOOutputFreq_Value,VCOSAIOutputFreq_Value
