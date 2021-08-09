Mcu.Family=STM32F0
Mcu.Package=LQFP64
Mcu.Name=STM32F051R8Tx
Mcu.UserName=STM32F051R8Tx

${ Mcu.IPs ("NVIC", "RCC", "SYS") }
${ Mcu.PINs( "PF0-OSC_IN"
           , "PF1-OSC_OUT"
           , "VP_SYS_VS_Systick"
           ) }

<#global DAC1 = "DAC1" >


NVIC.NonMaskableInt_IRQn=true\:0\:0\:false\:false\:false\:false
NVIC.PendSV_IRQn=true\:0\:0\:false\:false\:false\:false
NVIC.SVC_IRQn=true\:0\:0\:false\:false\:false\:false
NVIC.HardFault_IRQn=true\:0\:0\:false\:false\:false\:false\:false
NVIC.SysTick_IRQn=true\:2\:0\:true\:false\:false\:false\:false

PCC.Checker=false
PCC.Line=STM32F0x1
PCC.MCU=STM32F051R8Tx
PCC.PartNumber=STM32F051R8Tx
PCC.Seq0=0
PCC.Series=STM32F0
PCC.Temperature=25
PCC.Vdd=3.3

# PINs for the External OSCILLATOR
PF0-OSC_IN.Locked=true
PF0-OSC_IN.Mode=HSE-External-Oscillator
PF0-OSC_IN.Signal=RCC_OSC_IN
PF1-OSC_OUT.Locked=true
PF1-OSC_OUT.Mode=HSE-External-Oscillator
PF1-OSC_OUT.Signal=RCC_OSC_OUT

VP_SYS_VS_Systick.Mode=SysTick
VP_SYS_VS_Systick.Signal=SYS_VS_Systick

RCC.AHBFreq_Value=48000000
RCC.APB1Freq_Value=48000000
RCC.APB1TimFreq_Value=48000000
RCC.CECFreq_Value=32786.88524590164
RCC.EnbaleCSS=true
RCC.FCLKCortexFreq_Value=48000000
RCC.FamilyName=M
RCC.HCLKFreq_Value=48000000
RCC.HSICECFreq_Value=32786.88524590164
RCC.I2SFreq_Value=48000000
RCC.IPParameters=AHBFreq_Value,APB1Freq_Value,APB1TimFreq_Value,CECFreq_Value,EnbaleCSS,FCLKCortexFreq_Value,FamilyName,HCLKFreq_Value,HSICECFreq_Value,I2SFreq_Value,MCOFreq_Value,PLLCLKFreq_Value,PLLMCOFreq_Value,PLLMUL,PLLSourceVirtual,SYSCLKFreq_VALUE,SYSCLKSource,TimSysFreq_Value,USART1Freq_Value,VCOOutput2Freq_Value
RCC.MCOFreq_Value=48000000
RCC.PLLCLKFreq_Value=48000000
RCC.PLLMCOFreq_Value=24000000
RCC.PLLMUL=RCC_PLL_MUL6
RCC.PLLSourceVirtual=RCC_PLLSOURCE_HSE
RCC.SYSCLKFreq_VALUE=48000000
RCC.SYSCLKSource=RCC_SYSCLKSOURCE_PLLCLK
RCC.TimSysFreq_Value=48000000
RCC.USART1Freq_Value=48000000
RCC.VCOOutput2Freq_Value=8000000
