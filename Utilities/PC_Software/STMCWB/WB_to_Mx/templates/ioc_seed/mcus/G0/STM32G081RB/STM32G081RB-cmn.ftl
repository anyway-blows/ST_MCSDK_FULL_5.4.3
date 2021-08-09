<#import "../../cmns/ioc_Mcu_PCC.ftl" as u >

<#--<#include "../cmns/OSC_IN-OSC_OUT.ftl">-->
<#include "../cmns/NVIC_seed.ftl" >
<#include "../cmns/Sys_Jtms_pin.ftl" >

<#global DAC1 = "DAC1" >
<@u.ioc_Mcu_PCC
{ "Family"    : "STM32G0"
, "Package"   : "LQFP64"
, "Name"      : "STM32G081RBTx"
, "UserName"  : "STM32G081RBTx"
, "Line"      : ""
} />
