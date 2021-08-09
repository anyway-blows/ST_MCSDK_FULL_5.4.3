<#import "../../MC_task/oCurrSensor/fragments/Fx_commons/cs_cmn_create_adc_pin.ftl" as adc_pin>
<#import "../../MC_task/utils/meta_parameters.ftl"               as meta   >
<#import "../../MC_task/utils/ips_mng.ftl"                       as ns_ip  >
<#import "../../fp.ftl"                                          as fp     >
<#import "../../utils.ftl"                                       as utils  >


<#function cycle param>

   <#return  (param > 1)?then("CYCLES", "CYCLE")>

</#function>


<#function adc_setting>
    <#local  adc = ns_ip.collectIP(WB_PFC_ADC!"ADC2") >

    <#local IsamplingTime  = WB_ISAMPLINGTIMEVALUE >
    <#local ICycle         = cycle (IsamplingTime) >

    <#local VsamplingTime  = WB_VMSAMPLINGTIMEVALUE >
    <#local VCycle         = cycle(VsamplingTime)>


       <#local xs =
    {
        "AutoInjectedConv.Ext                           " : "DISABLE"
       ,"Channel-14\\#ChannelInjectedConversion         " : "${WB_ICHANNEL?upper_case}"
       ,"Channel-15\\#ChannelInjectedConversion         " : "${WB_ICHANNEL?upper_case}"
       ,"Channel-16\\#ChannelInjectedConversion         " : "${WB_VMCHANNEL?upper_case}"
       ,"Channel.Ext                                    " : "ADC_CHANNEL_0"
       ,"ContinuousConvMode                             " : "DISABLE"
       ,"DMAAccessMode_ADC1.Ext                         " : "ADC_DMAACCESSMODE_ENABLED"
       ,"DMAAccessMode_ADC2.Ext                         " : "ADC_DMAACCESSMODE_DISABLED"
       ,"DataAlign                                      " : "ADC_DATAALIGN_LEFT"
       ,"DiscontinuousConvMode                          " : "DISABLE"
       ,"EnableAnalogWatchDog                           " : "false"
       ,"EnableRegularConversion                        " : "DISABLE"
       ,"ExternalTrigConv.Ext                           " : "ADC_SOFTWARE_START"
       ,"ExternalTrigInjecConv                          " : "ADC_INJECTED_SOFTWARE_START"
       ,"InjNumberOfConversion                          " : "3"
       ,"InjectedConvMode                               " : "None"
       ,"InjectedDiscontinuousConvMode.Ext              " : "DISABLE"
       ,"InjectedOffset-14\\#ChannelInjectedConversion  " : "0"
       ,"InjectedOffset-15\\#ChannelInjectedConversion  " : "0"
       ,"InjectedOffset-16\\#ChannelInjectedConversion  " : "0"
       ,"InjectedOffset.Ext                             " : "0"
       ,"Mode.Ext                                       " : "__NULL"
       ,"NbrOfConversion.Ext                            " : "1"
       ,"NbrOfConversionFlag.Ext                        " : "0"
       ,"Rank-14\\#ChannelInjectedConversion            " : "1"
       ,"Rank-15\\#ChannelInjectedConversion            " : "2"
       ,"Rank-16\\#ChannelInjectedConversion            " : "3"
       ,"Rank.Ext                                       " : "1"
       ,"SamplingTime-14\\#ChannelInjectedConversion    " : "ADC_SAMPLETIME_${IsamplingTime}${ICycle}_5"
       ,"SamplingTime-15\\#ChannelInjectedConversion    " : "ADC_SAMPLETIME_${IsamplingTime}${ICycle}_5"
       ,"SamplingTime-16\\#ChannelInjectedConversion    " : "ADC_SAMPLETIME_${VsamplingTime}${VCycle}_5"
       ,"SamplingTime.Ext                               " : "ADC_SAMPLETIME_1CYCLE_5"
       ,"ScanConvMode                                   " : "ADC_SCAN_ENABLE"
    }>


        <#return meta._ip_params_to_str(adc, xs) >
</#function>

