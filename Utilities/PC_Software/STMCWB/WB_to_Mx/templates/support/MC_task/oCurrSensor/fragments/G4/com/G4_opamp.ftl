<#import "../../../../../utils.ftl" as utils>
<#import "../../../../../fp.ftl" as fp>

<#import "../../../../utils/pins_mng.ftl" as ns_pin>
<#import "../../../../utils/ips_mng.ftl"  as ns_ip >
<#import "../../../../utils/meta_parameters.ftl" as meta>

<#import "../../../../../../support/ui.ftl" as ui>



<#--
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
~ for OPAMP x
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
, "OPAMP_SELECTION" : utils._last_word( utils.v("OPAMP_SELECTION", motor)
, "OPAMP_VINP_GPIO" : "OPAMP_NONINVERTINGINPUT"
, "OPAMP_VINM_GPIO" : "OPAMP_INVERTINGINPUT"
, "OPAMP_VOUT_GPIO" : "OPAMP_OUT"

, "USE_INTERNAL_OPAMP" : use_int_opamp
}
+ m_item("OPAMP_TYPE_GAIN"        , motor)
+ m_item("OPAMP_PGAGAIN"          , motor)

~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
~ for OPAMP 1
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
, "OPAMP_SELECTION" : utils._last_word( utils.v("OPAMP1_SELECTION", motor)
, "OPAMP_VINP_GPIO" : "OPAMP1_NONINVERTINGINPUT_PHA"
, "OPAMP_VINM_GPIO" : "OPAMP1_INVERTINGINPUT"
, "OPAMP_VOUT_GPIO" : "OPAMP1_OUT"

, "USE_INTERNAL_OPAMP" : use_int_opamp
}
+ m_item("OPAMP_TYPE_GAIN"        , motor)
+ m_item("OPAMP_PGAGAIN"          , motor)

~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
~ for OPAMP 2
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
, "OPAMP_SELECTION" : utils._last_word( utils.v("OPAMP2_SELECTION", motor)
, "OPAMP_VINP_GPIO" : "OPAMP2_NONINVERTINGINPUT_PHB"
, "OPAMP_VINM_GPIO" : "OPAMP2_INVERTINGINPUT"
, "OPAMP_VOUT_GPIO" : "OPAMP2_OUT"

, "USE_INTERNAL_OPAMP" : use_int_opamp
}
+ m_item("OPAMP_TYPE_GAIN"        , motor)
+ m_item("OPAMP_PGAGAIN"          , motor)

 ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
~ in 3Shunt R3_4_F3 I have to configure additional Pin as SharedAnalog
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
OPAMP1_NONINVERTINGINPUT_PHB
OPAMP2_NONINVERTINGINPUT_PHB
-->

<#function opamp_srcs motor who>
    <#import "../../../../../../config.ftl" as config >

    <#local use_int_opamp = utils.v("USE_INTERNAL_OPAMP", motor) >

    <#local i                 = ["",    "1",    "2",    "3"][who]>

    <#local f_opamp_vinp_gpio = [opamp_vinp, opamp_1_vinp, opamp_2_vinp, opamp_3_vinp][who]>

    <#local opamp_name = utils._last_word( utils.v("OPAMP${i}_SELECTION", motor) ) >

    <#local opamp_type_gain        = utils.v("OPAMP_TYPE_GAIN"       , motor)!"EXTERNAL"   >
    <#local feedback_net_filtering = utils.v("FEEDBACK_NET_FILTERING", motor)!false >

    <#if opamp_type_gain == "EXTERNAL" >
        <#local opamp_mode = "Standalone" >
    <#else>
         <#if WB_USE_3OPAMPS!false>
            <#local opamp_mode = feedback_net_filtering?then("PGA Connected-INVERTINGINPUT_IO0_BIAS","PGA Not Connected" )>
         <#else>
            <#local opamp_mode = feedback_net_filtering?then("PGA Connected","PGA Not Connected" )>
         </#if>
    </#if>


    <#return
    { "name"  : opamp_name
    , "idx"   : utils._last_char(opamp_name)
    , "nic"   : i
    , "motor" : motor
    , "sensing" : utils.current_sensing_topology(motor)

    , "mode"  : opamp_mode

    , "OPAMP_SELECTION" : opamp_name

    , "OPAMP_VINP_GPIO" : f_opamp_vinp_gpio
    , "OPAMP_VINM_GPIO" : "OPAMP${i}_INVERTINGINPUT"
    , "OPAMP_VOUT_GPIO" : "OPAMP${i}_OUT"

    , "USE_INTERNAL_OPAMP"    : use_int_opamp

    , "OPAMP_TYPE_GAIN"       : opamp_type_gain
    }
    + m_item("OPAMP_PGAGAIN"          , motor)
    >



</#function>
<#function m_item item m>
    <#return { item : utils.v(item, m) } >
</#function>

<#--
    <#local p_idx = phase?switch("U", 0, "V", 1, "W", 2) >
    opamp 0 ~~> OPAMP_NONINVERTINGINPUT
    opamp 1 ~~> OPAMP${ 1 }_NONINVERTINGINPUT${ ["_PHA", "_PHB", "_PHB"][p_idx] }
    opamp 2 ~~> OPAMP${ 2 }_NONINVERTINGINPUT${ ["_PHA", "_PHB", "_PHC"][p_idx] }
-->
<#function opamp_vinp phase>
    <#return "OPAMP_NONINVERTINGINPUT" >
</#function>
<#function opamp_1_vinp phase>
    <#local ph = phase?switch(
          "U", "_PHA"
        , "V", "_PHB"
        , "W", "_PHC") >
    <#return "OPAMP1_NONINVERTINGINPUT${ ph }" >
</#function>
<#function opamp_2_vinp phase>
    <#local ph = phase?switch(
          "U", "_PHA"
        , "V", "_PHB"
        , "W", "_PHC") >
    <#return "OPAMP2_NONINVERTINGINPUT${ ph }" >
</#function>

<#function opamp_3_vinp phase>
    <#local ph = phase?switch(
      "U", "_PHA"
    , "V", "_PHB"
    , "W", "_PHC") >
    <#return "OPAMP3_NONINVERTINGINPUT${ ph }" >
</#function>


<#function cs_single_OPAMP_settings opamp phase>
    <#local opamp_name = ns_ip.collectIP( opamp.name ) >

    <#local ip_params =
    { "SelfCalibration"        : "Disable"
    , "UserTrimming"           : "OPAMP_TRIMMING_FACTORY"
    , "TimerControlledMuxmode" : "OPAMP_TIMERCONTROLLEDMUXMODE_DISABLE"
    }>

    <#if opamp.OPAMP_TYPE_GAIN == "INTERNAL" >
        <#local pga_gain = utils._last_word( opamp.OPAMP_PGAGAIN ) >
        <#local pga_gain2 =  pga_gain?number >
        <#local ip_params = {"PgaGain" : "OPAMP_PGA_GAIN_${pga_gain}_OR_MINUS_${pga_gain2-1}"} + ip_params>
    </#if>

    <#local ip_params = ip_params
                      + meta.comment("opamp_mode: ${opamp.mode}")
                      >

    <#local general_settings = meta.ip_params_to_str(opamp.name, ip_params) >

    <#local ctx = { "opamp" : opamp
                  , "phase" : phase} >
    <#return
        { "ctx"      : ctx
        , "settings" : { "${opamp.name} settings for Current Sense" : general_settings }
        , "GPIOs"    : cs_OPAMPs_GPIO_settings(ctx)
        }>
</#function>

<#function cs_OPAMPs_GPIO_settings ctx>
<#--
    <#local pins =
    [ {"idx": 0, "pin": "VINP" }
    , {"idx": 2, "pin": "VOUT" } ] ><#if ctx.opamp.mode != "PGA Not Connected" ><#local pins = pins +
    [ {"idx": 1, "pin": "VINM" } ] ></#if>
    <#return fp.map_ctx(ctx, create_opamp_pin , pins?sort_by("idx") ) >
-->
    <#local pins = (ctx.opamp.mode != "PGA Not Connected")?then
        ( ["VINP", "VINM", "VOUT"]
        , ["VINP",         "VOUT"]
        )>

    <#return fp.map_ctx(ctx, create_opamp_pin , pins) >
</#function>

<#function create_opamp_pin ctx pin>
    <#local opamp = ctx.opamp >
    <#local phase = ctx.phase >

    <#local sense = opamp.sensing?contains("ICS")?then("ICS", "SHUNT") >

    <#local pinLabel = (pin)?switch
        ( "VINP", concatenate("CURR", sense, phase )
        , "VINM", '${opamp.name}_${ (opamp.mode == "Standalone")?then("EXT_GAIN", "INT_GAIN") }'
        , "VOUT", "${opamp.name}_OUT"
        )>
<#--, "VINM", concatenate(phase  , (opamp.mode == "Standalone")?then("OPAMP_GAIN", "OPAMP_INTGAIN") )-->

    <#local pinName_src = opamp["OPAMP_${ pin }_GPIO"] >
    <#local pinName = ns_pin.name2(opamp.motor, pinName_src?is_macro?then( pinName_src(phase), pinName_src ) ) >

    <#return
        { "name"   : pinName
        , "label"  : pinLabel
        , "signal" : "${opamp.name}_${pin}"
        , "mode"   : opamp.mode
        , "ip"     : {"name": opamp.name, "pin" : pin}
        }>
</#function>

<#function concatenate items...>
    <#return fp.filter(utils.hasContent, items)?join("_") >
</#function>
