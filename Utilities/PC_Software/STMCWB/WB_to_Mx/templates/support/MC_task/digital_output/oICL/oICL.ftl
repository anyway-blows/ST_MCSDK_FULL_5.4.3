<#include "../../../utils.ftl" >
<#--####################################################################################################################
 #  SOURCES:                                                                                                           #
 #######################################################################################################################
 #  <define key="INRUSH_CURRLIMIT_GPIO_PORT"    value="GPIOD"            />                                            #
 #  <define key="INRUSH_CURRLIMIT_GPIO_PIN"     value="GPIO_Pin_4"       />                                            #
 #  <define key="INRUSH_CURR_LIMITER_POLARITY"  value="DOUT_ACTIVE_HIGH" />                                            #
 ####################################################################################################################-->

<#function io_description motor>
    <#if motor == 1>
        <#if WB_INRUSH_CURRLIMIT_ENABLING !false>
            <#return
            { "label"    : "M1_ICL_SHUT_OUT"
            , "port"     : INRUSH_CURRLIMIT_GPIO_PORT
            , "pin"      : INRUSH_CURRLIMIT_GPIO_PIN
            , "polarity" : INRUSH_CURR_LIMITER_POLARITY
            }>
        </#if>
    <#else>
        <#if WB_INRUSH_CURRLIMIT_ENABLING2 !false>
            <#return
            { "label"    : "M2_ICL_SHUT_OUT"
            , "port"     : INRUSH_CURRLIMIT_GPIO_PORT2   !INRUSH_CURRLIMIT_GPIO_PORT
            , "pin"      : INRUSH_CURRLIMIT_GPIO_PIN2    !INRUSH_CURRLIMIT_GPIO_PIN
            , "polarity" : INRUSH_CURR_LIMITER_POLARITY2 !INRUSH_CURR_LIMITER_POLARITY
            }>
        </#if>
    </#if>

    <#local err_msg = "NO INRUSH CURRRENT LIMIT REQUIRED for M${motor}" >
    <#return {"error"  : err_msg} >
</#function>

<#macro icl_enable_test_mode >
    <#assign
        WB_INRUSH_CURRLIMIT_ENABLING   = true
        INRUSH_CURRLIMIT_GPIO_PORT     = "GPIOA"
        INRUSH_CURRLIMIT_GPIO_PIN      = "GPIO_Pin_1"
        INRUSH_CURR_LIMITER_POLARITY   = "ACTIVE_HIGH"
        >
    <#assign
        WB_INRUSH_CURRLIMIT_ENABLING2  = true
        INRUSH_CURRLIMIT_GPIO_PORT2    = "GPIOB"
        INRUSH_CURRLIMIT_GPIO_PIN2     = "GPIO_Pin_2"
        INRUSH_CURR_LIMITER_POLARITY2  = "ACTIVE_LOW"
        >
    <#global WB_NUM_MOTORS = 2>
</#macro>