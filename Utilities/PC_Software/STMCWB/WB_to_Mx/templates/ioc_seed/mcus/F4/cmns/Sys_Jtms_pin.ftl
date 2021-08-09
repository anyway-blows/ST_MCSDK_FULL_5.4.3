# Initial SYS config
${ Mcu.PINs( "PA13","PA14") }

PA13.Locked=true
PA13.Mode=Serial_Wire
PA13.Signal=SYS_JTMS-SWDIO

PA14.GPIOParameters=GPIO_Label
PA14.GPIO_Label=TCK
PA14.Locked=true
PA14.Mode=Serial_Wire
PA14.Signal=SYS_JTCK-SWCLK
