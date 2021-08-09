<#import "../support/MC_task/utils/ips_mng.ftl"  as ns_ip>
<#import "../support/MC_task/utils/pins_mng.ftl" as ns_pin>
<#import "../support/fp.ftl" as fp>
<#import "../support/ui.ftl" as ui>

<#function _mcu_xs header xs>
    <#local sep = "\n" + ", "?left_pad(header?length, ' ') >
    <#return ui._comment( "${header}${xs?join(sep)}" ) >
</#function>

<#function IPs ips... >
    <#local _ip  = fp.map( ns_ip.collectIP  , ips) >
    <#return _mcu_xs("Mcu.IPs  = ", ips) >
</#function>

<#function PINs pins... >
    <#local _pin = fp.map( ns_pin.collectPin, pins) >
    <#return _mcu_xs("Mcu.PINs = ", pins) >
</#function>
