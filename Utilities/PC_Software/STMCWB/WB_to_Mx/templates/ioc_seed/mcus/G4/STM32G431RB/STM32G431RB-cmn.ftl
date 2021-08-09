<#import "../../cmns/ioc_Mcu_PCC.ftl" as u >
<#include "../../../mcus/G4/cmns/JTMS_SWDIO-SWCLK_pins.ftl">
<#include "../../../mcus/cmns/cordic.ftl">


<#global DAC1 = "DAC1" >
<@u.ioc_Mcu_PCC
{ "Family"    : "STM32G4"
, "Package"   : "LQFP64"
, "Name"      : "STM32G431R(6-8-B)Tx"
, "UserName"  : "STM32G431RBTx"
, "Line"      : ""
} />
