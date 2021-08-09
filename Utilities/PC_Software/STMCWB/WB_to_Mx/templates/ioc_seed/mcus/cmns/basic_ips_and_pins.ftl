<#include "basic_ips_and_pins_int.ftl">
<#--# Declares commonly used IPs
${ Mcu.IPs ("NVIC", "RCC", "SYS") }

# Virtual PIN for Systick
<#include "VP_SYS_VS_Systick.ftl">-->

# OSC_IN OSC_OUT
<#include "OSC_IN-OSC_OUT.ftl">