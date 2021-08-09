<#import "../../utils.ftl" as utils>
<#import "../../fp.ftl" as fp >
<#import "../../../config.ftl" as config >

<#-- ########################################################################
 #  I need to collect the pin settings and postpone their encoding.         #
 #  This is indispensable for managing the sharing of the pin assignments.  #
 #  OPAMP_VINP and COMP_INP - OPAMP_VOUT and ADC_IN - COMP_INM and DAC...   #
 #########################################################################-->

<#function storePinConfig pin>
    <#--
        pin = { name   : String
              , label  : String
              , signal : String
              , mode   : String
              , ip     : { name:String , pin: String }
              }
    the DB is a hash table using the pinName as key and the whole pin info as value -->
    <#assign PINs_conf = updatePinConfig_DB( pin_c_DB(), pin ) >
    <#return pin >
</#function>
<#function resetDB>
    <#assign PINs_conf = {} >
    <#return PINs_conf >
</#function>
<#function pin_c_DB>
    <#return PINs_conf!{} >
</#function>
<#function updatePinConfig_DB db pin>
<#--
    pin = { name   : String
          , label  : String
          , signal : String
          , mode   : String
          , ip     : { name:String , pin: String }
          }
-->
    <#if ! (pin?has_content) >
        <#return db >

    <#elseif ! db[pin.name]?? >
        <#-- new item -->
        <#-- since it is new I just return add it -->
        <#return db + { pin.name : [pin] } >
    <#else>
        <#-- It is already present so I just update the content (using the operator "db + {updated item}" ) -->
        <#return db + { pin.name : db[pin.name] + [pin] } >
    </#if>
</#function>

<#function add_motor_info motor>
    <#local newDB = {} >

    <#list pin_c_DB() as pinName, defs>
        <#local pin_defs_plus_motor = fp.map_ctx(motor, _add_motor,  defs)>
        <#local newDB = newDB + { pinName: pin_defs_plus_motor } >
    </#list>

    <#assign _PINs_confs = (_PINs_confs![]) + [newDB] >
    <#return _PINs_confs >
</#function>
<#function _add_motor motor pin_def>
    <#return pin_def + {"motor": motor} >
</#function>

<#function condolidate_fuse_motors>
    <#return  fp.foldl( _fuse_defs, {}, _PINs_confs) >
</#function>

<#function _fuse_defs ret m_db>
    <#list m_db as pinName, defs>
        <#local ret = ret + { pinName : (ret[pinName]![]) + defs } >
    </#list>
    <#return ret>
</#function>






<#function genetate_pin_setting db>
    <#local ret = []>

    <#list db as pinName, defs>
        <#if defs?size == 1>
            <#local ret = ret + [ csf_pin_GPIO(defs[0]) ] >
        <#else >
            <#--<#local ret = ret + [ "# ${pinName}" ] >-->
            <#local ret = ret + [ csf_shared_pin_GPIO(pinName, defs) ] >
        </#if>
    </#list>

    <#return ret?join("\n\n") >
</#function>

<#function csf_shared_pin_GPIO pinName staked_ips>
<#--
    staked_ips : [ pins_definition ]
    pin_definition :
              { name   : String
              , label  : String
              , signal : String
              , mode   : String
              , motor  : String | Number

              , ip     : { name:String , pin: String }
              }
-->
    <#local sharers = []>
    <#local labels  = {}>
    <#local ips     = {}>
    <#local motors  = {}>

    <#local used_values = []>

    <#list staked_ips as pin_def>
        <#local idx = pin_def?index>

        <#if ! pin_def.str?has_content >

            <#if pin_def.signal?? >
                <#local pin_signal = pin_def.signal>
            <#else>
                <#local pin_signal = "AAAIII">
            </#if>

            <#local value = pin_def.mode?has_content?then("${pin_signal},${pin_def.mode}", "${pin_signal}") >
            <#if ! used_values?seq_contains( value ) >
                <#local used_values = used_values + [value]>
                <#local sharers = sharers + ["SH.SharedAnalog_${pin_def.name}.${sharers?size}=${value}"]  >
            </#if>

            <#-- this is a trick in order to have a set of used signals -->
            <#if pin_def.label?has_content >
                <#local labels = labels + {pin_def.label:""} >
            </#if>
            <#local ips    = ips    + {"${pin_def.ip.name}(${pin_def.ip.pin})":""} >


            <#local motors  = motors + { pin_def.motor : "" }>
        <#else>
            <#return pin_def.str >
            <#--<#return ui._comment( ["UUUIII"] + pin_def.str?split("\n") + [ "IIIUUU"] ) >-->
        </#if>
    </#list>

    <#local cmnt>Shared Pin among: ${ ips?keys?join(' and ') }</#local>
    <#local gpio_label = "M${motors?keys?join('_')}_${labels?keys?join('_&_')}">
    <#return (
        [ "${ui._left_comment_line( cmnt )}"
        , "${pinName}.GPIOParameters=GPIO_Label"
        , "${pinName}.GPIO_Label=${ gpio_label }"
        , "${pinName}.Locked=true"

        , "${pinName}.Signal=SharedAnalog_${pinName}"
        , "SH.SharedAnalog_${pinName}.ConfNb=${ sharers?size }"
        ] + sharers
        )?join('\n')
    >
<#--
    , "${pinName}.Staked"
-->
</#function>

<#function csf_pin_GPIO pin_def >
    <#if pin_def.str?has_content >
        <#return pin_def.str >
    <#else>
        <#local motor = pin_def.motor>

        <#if pin_def.sh_signal?? && (config.use_mx_shared_signal_name)!false >
            <#local sh_signal = pin_def.sh_signal >
        <#else>
            <#local sh_signal = "wbsh_${pin_def.signal}_${pin_def.name}" >
        </#if>

        <#if sh_signal?has_content >
            <#local signal_and_mode_declaration =
                [ "${pin_def.name}.Signal=${sh_signal}"
                , "SH.${sh_signal}.0=${pin_def.signal},${pin_def.mode}"
                , "SH.${sh_signal}.ConfNb=1"
                ] >
        <#else>
            <#local signal_and_mode_declaration =
                [ "${pin_def.name}.Signal=${ pin_def.signal }"
                , "${pin_def.name}.Mode=${ pin_def.mode }"
                ] >
        </#if>


        <#local gpio_label = ((pin_def.customLabel)!false)?then(pin_def.label, "M${motor}_${ pin_def.label }")  >
        <#local comment = (pin_def.comment)!gpio_label >

        <#return (
            [ "${ ui._left_comment_line( comment ) }"
            , "${pin_def.name}.GPIOParameters=GPIO_Label"
            , "${pin_def.name}.GPIO_Label=${gpio_label}"
            , "${pin_def.name}.Locked=true"
            ] + signal_and_mode_declaration
            )?join('\n') >
    </#if>
</#function>