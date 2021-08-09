
#######################################################
${ Mcu.PINs( "PA11","PA12") }
#######################################################
PA11.GPIOParameters=GPIO_Label
PA11.GPIO_Label=USB_DM
PA11.Mode=Device_Only
PA11.Signal=USB_OTG_FS_DM
PA11.Locked=true

PA12.GPIOParameters=GPIO_Label
PA12.GPIO_Label=USB_DP
PA12.Mode=Device_Only
PA12.Signal=USB_OTG_FS_DP
PA12.Locked=true
#######################################################


#######################################################
${ Mcu.PINs( "PG6","PG7") }
#######################################################
PG6.GPIOParameters=GPIO_Label
PG6.GPIO_Label=USB_PowerSwitchOn [STMPS2151STR_EN]
PG6.Signal=GPIO_Output
PG6.Locked=true

PG7.GPIOParameters=GPIO_Label
PG7.GPIO_Label=USB_OverCurrent [STMPS2151STR_FAULT]
PG7.Signal=GPIO_Input
PG7.Locked=true

USB_OTG_FS.IPParameters=VirtualMode
USB_OTG_FS.VirtualMode=Device_Only
#######################################################
