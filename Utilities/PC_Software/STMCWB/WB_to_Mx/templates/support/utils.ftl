<#if ! _utils_ftl?? >
    <#global _utils_ftl = 1><#--

    -->

    <#function hash_to_str hash sep="\n">
        <#local xs = ["{"]>

        <#list hash as k,v>
            <#if v?is_hash>
                <#local valore = hash_to_str(v, " - ")>
            <#else>
                <#local valore = fp.f_identity(v)>
            </#if>
            <#local xs = xs + [ "${k} : ${valore}" ] >
        </#list>
        <#local xs = xs + [ "}" ] >
        <#return xs?join(sep)>
    </#function>

    <#--<#import "fp.ftl" as fp>-->
    <#function hasContent x><#return x?has_content ></#function>
    <#function is_macro str>
        <#return .vars[str]?? && .vars[str]?is_macro >
    </#function>

    <#function _valueOf x hashs=[] visited=[]>
        <#-- cyclic definition check -->
        <#if visited?seq_contains(x)>
            <#return x>

        <#elseif x?is_string >
            <#list hashs as hash>
                <#if hash?is_hash && hash[x]??
                    ><#return _valueOf(hash[x], hashs, visited+[x])
                ></#if>
            </#list>
<#--
            <#if              WB[x]?? ><#return _valueOf(         WB[x], visited+[x]) >
            <#elseif       .vars[x]?? ><#return _valueOf(      .vars[x], visited+[x]) >
            <#elseif    .globals[x]?? ><#return _valueOf(   .globals[x], visited+[x]) >
            <#elseif .data_model[x]?? ><#return _valueOf(.data_model[x], visited+[x]) >
            </#if>
-->
        </#if>

        <#return x>
    </#function>

    <#--this function retrieves the value of its argument x looking recursively within the hashs provided as "searchIn" argument
     # @searchIn is optional and defaulted to [WB, .vars, .globals, .data_model]
    -->
    <#function valueOf x searchIn=[]>
        <#if ! searchIn?has_content >
            <#return _valueOf(x, [WB!, .vars, .globals, .data_model], []) >
        <#else>
            <#return _valueOf(x, searchIn, [])>
        </#if>
    </#function>

    <#function m_value motor item>
        <#local m = (motor==1)?then('', '2')>
        <#return valueOf( "${item}${m}" ) >
    </#function>

    <#function v item motor=1>
        <#return (motor == 1)?then
            ( item?eval
            , ("${item}${motor}"?eval)!v(item,1))
            >
<#--
        <#if motor == 1>
            <#return item?eval >
        <#else>
            <#return ("${item}${m}"?eval)!v(item) >
        </#if>
-->
<#--
        <#local m = (motor==1)?then('', '2')>
        <#return ("${item}${m}"?eval)!(item?eval)  >
-->
        <#--<#return valueOf( "${item}${m}" ) >-->
    </#function>
    <#function iv motor item><#return v(item, motor)></#function>


    <#function mx_name name>
        <#import "names_map.ftl" as rr>
        <#return rr[name]!name >
<#--
        <#local ret = (names_map!{})[name]!name >
        <#return ret> &lt;#&ndash;name_mapper(name) >&ndash;&gt;
-->
    </#function>


    <#function defined x="">
        <#return x?has_content>
    </#function>

<#--
    <#function eq a="" b="">
        <#return toStr(valueOf(a)) == toStr(valueOf(b)) >
    </#function>

    <#macro assignValue name value >
        <@'<#global ${name}>${value}</#global>'?interpret />
    </#macro>

    <#macro setDefault name value >
        <#if ! defined(name?eval) >
            <@'<#global ${name} = "${value}" >'?interpret />
        </#if>
    </#macro>
-->

    <#function current_sensing_topology i>
<#--
        "ICS_SENSORS"
        "SINGLE_SHUNT"
        "THREE_SHUNT"
        "THREE_SHUNT_SHARED_RESOURCES"
        "THREE_SHUNT_INDEPENDENT_RESOURCES"
-->
        <#if i == 2 >
            <#local sense = CURRENT_READING_TOPOLOGY2 >
            <#local len = sense?length >
            <#return sense[0..*(len-1)] >
        <#else>
            <#return CURRENT_READING_TOPOLOGY >
        </#if>
    </#function>

    <#function short_sense sense>
        <#return sense?switch
        ( "THREE_SHUNT" , "3Sh"
        , "THREE_SHUNT_INDEPENDENT_RESOURCES" , "3Sh_IR"
        , "ICS_SENSORS" , "ICS"
        , "SINGLE_SHUNT", "1Sh"
        )>
    </#function>


    <#function str2seq txt>
        <#local sep="-äêïõú-">
        <#local xs=txt?replace("", sep)?split(sep)>
        <#return xs[1..*(xs?size-2)]>
    </#function>



    <#function _first_word text sep="_"><#return text?split(sep)?first></#function>
    <#function _last_word text sep="_"><#return text?split(sep)?last></#function>
    <#function _last_char text><#return text[text?length-1]></#function>
    <#-- gpio_port = GPIOx | gpio_pin = GPIO_Pin_X-->

    <#macro last_word text sep="_">${ text?split(sep)?last }</#macro>
    <#macro last_char text>${         text[text?length-1]  }</#macro>

    <#function toStr v>
        <#if v?is_boolean || v?is_number>
            <#return v?c>
        <#else>
            <#return v>
        </#if>
    </#function>


    <#function quote str><#return '"${str}"'></#function>

    <#function matches value="" rex=".*">
        <#local res=value?upper_case?matches(rex)>
        <#if res ><#return true>
        <#else   ><#return false></#if>
    </#function>



    <#function isTurnOFF value="">
        <#if value?is_boolean><#return !value></#if>
        <#return matches(value?upper_case, "0|FALSE|TURN_OFF")>
    </#function>
    <#function isTurnON value="">
        <#if value?is_boolean><#return value></#if>
        <#return matches(value?upper_case, "1|TRUE|TURN_ON")>
    </#function>
    <#function isActiveHigh value="">
        <#return value?upper_case?contains("ACTIVE_HIGH") >
    </#function>
    <#function isActiveLow value="">
        <#return value?upper_case?contains("ACTIVE_LOW") >
    </#function>

    <#function polarity idle_state_is_turn_on=false phase_xx_polarity="">
        <#local idle_state_is_turn_off = ! idle_state_is_turn_on    >

        <#local phase_pol_is_active_high = isActiveHigh(phase_xx_polarity) >
        <#local phase_pol_is_active_low  = isActiveLow( phase_xx_polarity) >

        <#if idle_state_is_turn_off && phase_pol_is_active_low
          || idle_state_is_turn_on  && phase_pol_is_active_high >
            <#return "SET">
        <#else>
            <#return "RESET">
        </#if>

    <#--############################################################################################################
     #  Comment from Marcello P.
     #  I dont know if the phase_xx_polarity can be only HIGH or LOW or it could have other values
     #
     #  in case phase_xx_polarity can be only HIGH or LOW
     #  I mean assert_equal( active_low || active_high, true); have to pass
     #         assert_equal( active_low, ! active_high);
     #  in this case:
     #
     #  <#if high_side_idle_state == active_high >
     #      <#return "SET">
     #  <#else>
     #      <#return "RESET">
     #  </#if>
     # is enough !
     -->
    </#function>
<#--



-->
</#if>
