#${ Mcu.PINs( "PA5","PC13") }
${ Mcu.PINs( "PA5") }

PA5.GPIOParameters=GPIO_Speed,GPIO_PuPd,GPIO_Label,GPIO_ModeDefaultOutputPP
PA5.GPIO_Label=LD2 [green Led]
PA5.GPIO_ModeDefaultOutputPP=GPIO_MODE_OUTPUT_PP
PA5.GPIO_PuPd=GPIO_NOPULL
PA5.GPIO_Speed=GPIO_SPEED_FREQ_LOW
PA5.Locked=true
PA5.Signal=GPIO_Output
#
#PC13.GPIOParameters=GPIO_PuPd,GPIO_Label,GPIO_ModeDefaultEXTI
#PC13.GPIO_Label=B1 [Blue PushButton]
#PC13.GPIO_ModeDefaultEXTI=GPIO_MODE_IT_FALLING
#PC13.GPIO_PuPd=GPIO_NOPULL
#PC13.Locked=true
#PC13.Signal=GPXTI13
#

