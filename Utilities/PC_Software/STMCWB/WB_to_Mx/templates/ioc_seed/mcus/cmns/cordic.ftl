<#import "../../ioc_collect_pins_and_ips.ftl" as Mcu>

# Declares commonly used IPs

${ Mcu.IPs ("CORDIC") }


${ Mcu.PINs("VP_CORDIC_VS_CORDIC") }
VP_CORDIC_VS_CORDIC.Mode=CORDIC_Activate
VP_CORDIC_VS_CORDIC.Signal=CORDIC_VS_CORDIC


