<#import "../../../../../utils.ftl"        as utils>
<#import "../../../../../fp.ftl"           as fp >
<#import "../../../../utils/ips_mng.ftl"   as ns_ip>

<#import "../../Fx_commons/cs_cmn_create_adc_pin.ftl" as adc_pin>

<#import "../../../../ADC/ADC_cs_info.ftl" as info >

<#function F4_2Ms_adc_pins motor sense>
    <#local adc1 = ns_ip.collectIP( utils.v("ADC_1_PERIPH", motor) )>
    <#local adc2 = ns_ip.collectIP( utils.v("ADC_2_PERIPH", motor) )>

    <#return fp.map_ctx(motor, _createPin, pins_by_sense(adc1, adc2, sense)) >
</#function>

<#function _createPin motor, dati>
    <#return adc_pin.cs_create_adc_pins( {"adc" : dati.adc}, info.adc_info(motor, dati.phase) ) >
</#function>


<#--####################################################################################################################
#                                                 F4 2Motors 3Sh                                                       #
########################################################################################################################
                                   +-------+
                   ( U )-----------|       |
                                   | ADC_1 |
                              +----|       |
                              |    +-------+
                   ( V )------+
                              |    +-------+
                              +----|       |
                                   | ADC_2 |
                   ( W )-----------|       |
                                   +-------+

########################################################################################################################
#                                                 F4 2Motors ICS                                                       #
########################################################################################################################
                                   +-------+
                                   |       |
                   ( U )-----------| ADC_1 |
                                   |       |
                                   +-------+

                                   +-------+
                                   |       |
                   ( V )-----------| ADC_2 |
                                   |       |
                                   +-------+                                                                         -->


<#function pins_by_sense adc1, adc2, sense>
    <#return sense?switch
        ( "3Sh_IR"
        , [ {"adc" : adc1, "phase": "U" }
          , {"adc" : adc1, "phase": "V" }
          , {"adc" : adc2, "phase": "V" }
          , {"adc" : adc2, "phase": "W" } ]

        , "ICS"
        , [ {"adc" : adc1, "phase": "U" }
          , {"adc" : adc2, "phase": "V" } ]

        , []
        ) >
</#function>