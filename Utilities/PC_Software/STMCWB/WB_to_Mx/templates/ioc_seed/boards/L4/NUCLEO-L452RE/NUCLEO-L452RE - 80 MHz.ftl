<#import "../../../mcus/cmns/ioc_Mcu_PCC.ftl" as u >
<@u.ioc_Mcu_PCC
{ "Family"    : "STM32L4"
, "Package"   : "LQFP64"
, "Name"      : "STM32L452R(C-E)Tx"
, "UserName"  : "STM32L452RETx"
, "Line"      : "STM32L4x2"
} />

<#--<#include "../../../mcus/cmns/NVIC_seed.ftl" >
<#include "../../../mcus/cmns/basic_ips_and_pins_int.ftl">-->
<#include "../../../mcus/cmns/FreeRTOS_IsAvaliable.ftl">
<#include "../../../mcus/L4/cmns/OSC_IN-OSC_OUT.ftl">
<#include "../../../mcus/L4/cmns/JTMS_SWDIO-SWCLK_pins.ftl">
<#include "../../../mcus/L4/cmns/PushButton_green Led_pins.ftl">

<#global DAC1 = "DAC1" >
RCC.ADCCLockSelection=RCC_ADCCLKSOURCE_SYSCLK
RCC.ADCFreq_Value=80000000
RCC.AHBFreq_Value=80000000
RCC.APB1Freq_Value=80000000
RCC.APB1TimFreq_Value=80000000
RCC.APB2Freq_Value=80000000
RCC.APB2TimFreq_Value=80000000
RCC.CortexFreq_Value=80000000
RCC.DFSDMFreq_Value=80000000
RCC.EnbaleCSS=true
RCC.FCLKCortexFreq_Value=80000000
RCC.FamilyName=M
RCC.HCLKFreq_Value=80000000
RCC.HSE_VALUE=8000000
RCC.HSI48_VALUE=48000000
RCC.HSI_VALUE=16000000
RCC.I2C1Freq_Value=80000000
RCC.I2C2Freq_Value=80000000
RCC.I2C3Freq_Value=80000000
RCC.I2C4Freq_Value=80000000
RCC.IPParameters=ADCCLockSelection,ADCFreq_Value,AHBFreq_Value,APB1Freq_Value,APB1TimFreq_Value,APB2Freq_Value,APB2TimFreq_Value,CortexFreq_Value,DFSDMFreq_Value,EnbaleCSS,FCLKCortexFreq_Value,FamilyName,HCLKFreq_Value,HSE_VALUE,HSI48_VALUE,HSI_VALUE,I2C1Freq_Value,I2C2Freq_Value,I2C3Freq_Value,I2C4Freq_Value,LPTIM1Freq_Value,LPTIM2Freq_Value,LPUART1Freq_Value,LSCOPinFreq_Value,LSE_VALUE,LSI_VALUE,MCO1PinFreq_Value,MSI_VALUE,PLLN,PLLPoutputFreq_Value,PLLQoutputFreq_Value,PLLRCLKFreq_Value,PLLSAI1PoutputFreq_Value,PLLSAI1QoutputFreq_Value,PLLSAI1RoutputFreq_Value,PLLSourceVirtual,PWRFreq_Value,RNGFreq_Value,SAI1Freq_Value,SDMMCFreq_Value,SYSCLKFreq_VALUE,SYSCLKSource,UART4CLockSelection,UART4Freq_Value,USART1CLockSelection,USART1Freq_Value,USART2CLockSelection,USART2Freq_Value,USART3CLockSelection,USART3Freq_Value,USBFreq_Value,VCOInputFreq_Value,VCOOutputFreq_Value,VCOSAI1OutputFreq_Value
RCC.LPTIM1Freq_Value=80000000
RCC.LPTIM2Freq_Value=80000000
RCC.LPUART1Freq_Value=80000000
RCC.LSCOPinFreq_Value=32000
RCC.LSE_VALUE=32768
RCC.LSI_VALUE=32000
RCC.MCO1PinFreq_Value=80000000
RCC.MSI_VALUE=4000000
RCC.PLLN=20
RCC.PLLPoutputFreq_Value=22857142.85714286
RCC.PLLQoutputFreq_Value=80000000
RCC.PLLRCLKFreq_Value=80000000
RCC.PLLSAI1PoutputFreq_Value=9142857.142857144
RCC.PLLSAI1QoutputFreq_Value=32000000
RCC.PLLSAI1RoutputFreq_Value=32000000
RCC.PLLSourceVirtual=RCC_PLLSOURCE_HSE
RCC.PWRFreq_Value=80000000
RCC.RNGFreq_Value=32000000
RCC.SAI1Freq_Value=9142857.142857144
RCC.SDMMCFreq_Value=32000000
RCC.SYSCLKFreq_VALUE=80000000
RCC.SYSCLKSource=RCC_SYSCLKSOURCE_PLLCLK
RCC.UART4CLockSelection=RCC_UART4CLKSOURCE_SYSCLK
RCC.UART4Freq_Value=80000000
RCC.USART1CLockSelection=RCC_USART1CLKSOURCE_SYSCLK
RCC.USART1Freq_Value=80000000
RCC.USART2CLockSelection=RCC_USART2CLKSOURCE_SYSCLK
RCC.USART2Freq_Value=80000000
RCC.USART3CLockSelection=RCC_USART3CLKSOURCE_SYSCLK
RCC.USART3Freq_Value=80000000
RCC.USBFreq_Value=32000000
RCC.VCOInputFreq_Value=8000000
RCC.VCOOutputFreq_Value=160000000
RCC.VCOSAI1OutputFreq_Value=64000000