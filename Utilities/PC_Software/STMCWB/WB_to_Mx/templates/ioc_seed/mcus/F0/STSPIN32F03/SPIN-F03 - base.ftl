<#import "../../cmns/ioc_Mcu_PCC.ftl" as u >
<@u.ioc_Mcu_PCC
{ "Family"    : "STM32F0"
, "Package"   : "LQFP48"
, "Name"      : "STM32F031C(4-6)Tx"
, "UserName"  : "STM32F031C6Tx"
, "Line"      : "STM32F0x1"
} />


${ Mcu.IPs ("NVIC", "RCC", "SYS") }
${ Mcu.PINs("VP_SYS_VS_Systick"
            ,"PA11"
            ,"PA13"
            ,"PA14"
            ) }

VP_SYS_VS_Systick.Mode=SysTick
VP_SYS_VS_Systick.Signal=SYS_VS_Systick

PA13.Locked=true
PA13.Mode=Serial_Wire
PA13.Signal=SYS_SWDIO
PA14.Locked=true
PA14.Mode=Serial_Wire
PA14.Signal=SYS_SWCLK

PA11.GPIOParameters=PinState,GPIO_Label
PA11.GPIO_Label=M1_ENABLE
PA11.Locked=true
PA11.PinState=GPIO_PIN_SET
PA11.Signal=GPIO_Output



NVIC.NonMaskableInt_IRQn=true\:0\:0\:false\:false\:true\:false\:false
NVIC.PendSV_IRQn=true\:0\:0\:false\:false\:true\:false\:false
NVIC.SVC_IRQn=true\:0\:0\:false\:false\:false\:false
NVIC.HardFault_IRQn=true\:0\:0\:false\:false\:false\:false\:false
NVIC.SysTick_IRQn=true\:2\:0\:true\:false\:false\:false\:false
