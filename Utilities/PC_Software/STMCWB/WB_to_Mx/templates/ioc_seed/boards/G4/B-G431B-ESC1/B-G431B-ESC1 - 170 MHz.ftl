<#import "../../../mcus/cmns/ioc_Mcu_PCC.ftl" as u >
<@u.ioc_Mcu_PCC
{ "Family"    : "STM32G4"
, "Package"   : "UFQFPN48"
, "Name"      : "STM32G431C(6-8-B)Ux"
, "UserName"  : "STM32G431CBUx"
, "Line"      : ""
} />

<#include "../../../mcus/cmns/FreeRTOS_IsAvaliable.ftl">
<#--<#include "../../../mcus/cmns/NVIC_seed.ftl" >-->
<#--<#include "../../../mcus/cmns/basic_ips_and_pins_int.ftl">-->
<#include "../../../mcus/cmns/OSC_IN-OSC_OUT.ftl">
<#include "../../../mcus/G4/cmns/JTMS_SWDIO-SWCLK_pins.ftl">
<#include "../../../mcus/cmns/cordic.ftl">



<#global DAC1 = "DAC1" >
RCC.ADC12CLockSelection=RCC_ADC12CLKSOURCE_PLL
RCC.ADC12Freq_Value=42500000
RCC.AHBFreq_Value=170000000
RCC.APB1Freq_Value=170000000
RCC.APB1TimFreq_Value=170000000
RCC.APB2Freq_Value=170000000
RCC.APB2TimFreq_Value=170000000
RCC.CRSFreq_Value=48000000
RCC.CortexFreq_Value=170000000
RCC.EXTERNAL_CLOCK_VALUE=12288000
RCC.FCLKCortexFreq_Value=170000000
RCC.FDCANFreq_Value=170000000
RCC.FamilyName=M
RCC.HCLKFreq_Value=170000000
RCC.HSE_VALUE=8000000
RCC.HSI48_VALUE=48000000
RCC.HSI_VALUE=16000000
RCC.I2C1Freq_Value=170000000
RCC.I2C2Freq_Value=170000000
RCC.I2C3Freq_Value=170000000
RCC.I2SFreq_Value=170000000
RCC.IPParameters=ADC12CLockSelection,ADC12Freq_Value,AHBFreq_Value,APB1Freq_Value,APB1TimFreq_Value,APB2Freq_Value,APB2TimFreq_Value,CRSFreq_Value,CortexFreq_Value,EXTERNAL_CLOCK_VALUE,FCLKCortexFreq_Value,FDCANFreq_Value,FamilyName,HCLKFreq_Value,HSE_VALUE,HSI48_VALUE,HSI_VALUE,I2C1Freq_Value,I2C2Freq_Value,I2C3Freq_Value,I2SFreq_Value,LPTIM1Freq_Value,LPUART1Freq_Value,LSCOPinFreq_Value,LSE_VALUE,LSI_VALUE,MCO1PinFreq_Value,PLLM,PLLN,PLLP,PLLPoutputFreq_Value,PLLQoutputFreq_Value,PLLRCLKFreq_Value,PLLSourceVirtual,PWRFreq_Value,RNGFreq_Value,SAI1Freq_Value,SYSCLKFreq_VALUE,SYSCLKSource,UART4Freq_Value,USART1Freq_Value,USART2Freq_Value,USART3Freq_Value,USBFreq_Value,VCOInputFreq_Value,VCOOutputFreq_Value
RCC.LPTIM1Freq_Value=170000000
RCC.LPUART1Freq_Value=170000000
RCC.LSCOPinFreq_Value=32000
RCC.LSE_VALUE=32768
RCC.LSI_VALUE=32000
RCC.MCO1PinFreq_Value=16000000
RCC.PLLM=RCC_PLLM_DIV2
RCC.PLLN=85
RCC.PLLP=RCC_PLLP_DIV8
RCC.PLLPoutputFreq_Value=42500000
RCC.PLLQoutputFreq_Value=170000000
RCC.PLLRCLKFreq_Value=170000000
RCC.PLLSourceVirtual=RCC_PLLSOURCE_HSE
RCC.PWRFreq_Value=170000000
RCC.RNGFreq_Value=170000000
RCC.SAI1Freq_Value=170000000
RCC.SYSCLKFreq_VALUE=170000000
RCC.SYSCLKSource=RCC_SYSCLKSOURCE_PLLCLK
RCC.UART4Freq_Value=170000000
RCC.USART1Freq_Value=170000000
RCC.USART2Freq_Value=170000000
RCC.USART3Freq_Value=170000000
RCC.USBFreq_Value=170000000
RCC.VCOInputFreq_Value=4000000
RCC.VCOOutputFreq_Value=340000000
