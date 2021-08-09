########################################################################################################################
# Pins for External crystal/ceramic resonator                                                                          #
########################################################################################################################
${ Mcu.PINs("PF0-OSC_IN" ,"PF1-OSC_OUT")}

# PINs for the External OSCILLATOR
PF0-OSC_IN.Locked=true
PF0-OSC_IN.Mode=HSE-External-Oscillator
PF0-OSC_IN.Signal=RCC_OSC_IN
PF1-OSC_OUT.Locked=true
PF1-OSC_OUT.Mode=HSE-External-Oscillator
PF1-OSC_OUT.Signal=RCC_OSC_OUT
########################################################################################################################


########################################################################################################################
# 48 MHz - external 8 MHz crystal/ceramic resonator - settings                                                         #
########################################################################################################################
RCC.AHBFreq_Value=48000000
RCC.APB1Freq_Value=48000000
RCC.APB1TimFreq_Value=48000000
RCC.EnbaleCSS=true
RCC.FCLKCortexFreq_Value=48000000
RCC.FamilyName=M
RCC.HCLKFreq_Value=48000000
RCC.I2SFreq_Value=48000000
RCC.IPParameters=AHBFreq_Value,APB1Freq_Value,APB1TimFreq_Value,EnbaleCSS,FCLKCortexFreq_Value,FamilyName,HCLKFreq_Value,I2SFreq_Value,MCOFreq_Value,PLLCLKFreq_Value,PLLMCOFreq_Value,PLLMUL,PLLSourceVirtual,SYSCLKFreq_VALUE,SYSCLKSource,TimSysFreq_Value,USART1Freq_Value,VCOOutput2Freq_Value
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
########################################################################################################################
