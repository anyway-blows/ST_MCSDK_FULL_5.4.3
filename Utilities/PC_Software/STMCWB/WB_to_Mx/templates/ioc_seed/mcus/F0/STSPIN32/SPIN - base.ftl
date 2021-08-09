Mcu.Family=STM32F0
Mcu.Package=LQFP48
Mcu.Name=STM32F031C(4-6)Tx
Mcu.UserName=STM32F031C6Tx

${ Mcu.IPs ("NVIC", "RCC", "SYS") }
${ Mcu.PINs("VP_SYS_VS_Systick"
           ,"PA11"
           ,"PF6"
           ,"PF7"
           ) }
<#--<#global DAC1 = "DAC" >-->


NVIC.NonMaskableInt_IRQn=true\:0\:0\:false\:false\:false\:false
NVIC.PendSV_IRQn=true\:0\:0\:false\:false\:false\:false
NVIC.SVC_IRQn=true\:0\:0\:false\:false\:false\:false
NVIC.HardFault_IRQn=true\:0\:0\:false\:false\:false\:false\:false
NVIC.SysTick_IRQn=true\:2\:0\:true\:false\:false\:false\:false

PCC.Checker=false
PCC.Line=STM32F0x1
PCC.MCU=STM32F031C(4-6)Tx
PCC.PartNumber=STM32F031C6Tx
PCC.Seq0=0
PCC.Series=STM32F0
PCC.Temperature=25
PCC.Vdd=3.6

VP_SYS_VS_Systick.Mode=SysTick
VP_SYS_VS_Systick.Signal=SYS_VS_Systick

PA11.GPIOParameters=PinState,GPIO_Label,GPIO_PuPd
PA11.GPIO_Label=OC_SEL
PA11.GPIO_PuPd=GPIO_PULLDOWN
PA11.Locked=true
PA11.PinState=GPIO_PIN_SET
PA11.Signal=GPIO_Output

PF6.GPIOParameters=PinState,GPIO_Label,GPIO_PuPd
PF6.GPIO_Label=OCTH_STBY2
PF6.GPIO_PuPd=GPIO_PULLDOWN
PF6.Locked=true
PF6.PinState=${ (OCP_COMP_THRESHOLD!0.1)?switch
    ( 0.1 , "GPIO_PIN_RESET"
    , 0.25, "GPIO_PIN_SET"
    , 0.5 , "GPIO_PIN_SET"
    , "GPIO_PIN_RESET" )
    }
PF6.Signal=GPIO_Output

PF7.GPIOParameters=PinState,GPIO_Label,GPIO_PuPd
PF7.GPIO_Label=OCTH_STBY1
PF7.GPIO_PuPd=GPIO_PULLDOWN
PF7.Locked=true
PF7.PinState=${ (OCP_COMP_THRESHOLD!0.1)?switch
    ( 0.1 , "GPIO_PIN_SET"
    , 0.25, "GPIO_PIN_RESET"
    , 0.5 , "GPIO_PIN_SET"
    , "GPIO_PIN_RESET" )
    }
PF7.Signal=GPIO_Output
