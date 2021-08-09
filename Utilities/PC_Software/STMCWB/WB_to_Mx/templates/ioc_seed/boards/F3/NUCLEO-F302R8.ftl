<#-- Here I'm going to include a file that can be referenced by WB with custom boards.
     It is located within the mcus folder
-->
<#include "../../mcus/F3/STM32F302R8/STM32F302R8 - 72 MHz.ftl" >



<#include "../../mcus/cmns/FreeRTOS_IsAvaliable.ftl">
<#include "../../mcus/cmns/OSC_IN-OSC_OUT.ftl" >


#############################################################
# SYS Debug Serial Wire + Green LED                         #
#############################################################
<#import "../../ioc_collect_pins_and_ips.ftl" as Mcu>
${ Mcu.PINs ("PA13", "PA14", "PB13") }

# JTMS/SWDIO
PA13.GPIOParameters=GPIO_Label
PA13.GPIO_Label=TMS
PA13.Locked=true
PA13.Mode=Serial_Wire
PA13.Signal=SYS_JTMS-SWDIO

# JTCK/SWCLK
PA14.GPIOParameters=GPIO_Label
PA14.GPIO_Label=TCK
PA14.Locked=true
PA14.Mode=Serial_Wire
PA14.Signal=SYS_JTCK-SWCLK

# PB3.GPIOParameters=GPIO_Label
# PB3.GPIO_Label=SWO
# PB3.Locked=true
# PB3.Mode=Trace_Asynchronous_SW
# PB3.Signal=SYS_JTDO-TRACESWO

# GREEN LED
PB13.GPIOParameters=GPIO_Label
PB13.GPIO_Label=LD2 [Green Led]
PB13.Locked=true
PB13.Signal=GPIO_Output
#############################################################
