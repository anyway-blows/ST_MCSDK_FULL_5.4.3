<#import "../../ioc_collect_pins_and_ips.ftl" as Mcu>

# Declares commonly used IPs
${ Mcu.IPs ("NVIC", "RCC", "SYS") }

# Virtual PIN for Systick
<#include "VP_SYS_VS_Systick.ftl">
