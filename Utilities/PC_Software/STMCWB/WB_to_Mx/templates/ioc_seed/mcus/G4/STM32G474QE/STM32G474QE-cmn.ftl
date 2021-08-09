<#import "../../cmns/ioc_Mcu_PCC.ftl" as u >
<#include "../../../mcus/G4/cmns/JTMS_SWDIO-SWCLK_pins.ftl">
<#include "../../../mcus/cmns/cordic.ftl">


<#global DAC1 = "DAC1" >
<@u.ioc_Mcu_PCC
{ "Family"    : "STM32G4"
, "Package"   : "LQFP128"
, "Name"      : "STM32G474Q(B-C-E)Tx"
, "UserName"  : "STM32G474QETx"
, "Line"      : ""
} />
