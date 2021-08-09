<#include "../../../utils.ftl" >
<#--####################################################################################################################
 #  SOURCES:                                                                                                           #
 #######################################################################################################################
 #  <define key="R_BRAKE_GPIO_PORT"          value="GPIOD"            />                                               #
 #  <define key="R_BRAKE_GPIO_PIN"           value="GPIO_Pin_5"       />                                               #
 #  <define key="DISSIPATIVE_BRAKE_POLARITY" value="DOUT_ACTIVE_HIGH" />                                               #
 ####################################################################################################################-->

<#function io_description motor>
    <#if motor == 1 >
        <#if (WB_ON_OVER_VOLTAGE == TURN_ON_R_BRAKE)!false >
            <#return
            { "label"    : "M1_DISSIPATIVE_BRK"
            , "port"     : R_BRAKE_GPIO_PORT
            , "pin"      : R_BRAKE_GPIO_PIN
            , "polarity" : DISSIPATIVE_BRAKE_POLARITY
            }>
        </#if>
    <#else>
        <#if (WB_ON_OVER_VOLTAGE2 == TURN_ON_R_BRAKE)!false >
            <#return
            { "label"    : "M2_DISSIPATIVE_BRK"
            , "port"     : R_BRAKE_GPIO_PORT2
            , "pin"      : R_BRAKE_GPIO_PIN2
            , "polarity" : DISSIPATIVE_BRAKE_POLARITY2
            }>
        </#if>
    </#if>

    <#local err_msg = "NO DISSIPATIVE BRAKE REQUIRED on M${motor}" >
    <#return {"error": err_msg }>
</#function>

<#macro dbrk_enable_test_mode >
    <#global
        WB_ON_OVER_VOLTAGE           = TURN_ON_R_BRAKE <#-- enabled -->
        R_BRAKE_GPIO_PORT            = "GPIOA"
        R_BRAKE_GPIO_PIN             = "GPIO_Pin_1"
        DISSIPATIVE_BRAKE_POLARITY   = "ACTIVE_HIGH"
        >
    <#global
        WB_ON_OVER_VOLTAGE2          = TURN_ON_R_BRAKE <#-- enabled -->
        R_BRAKE_GPIO_PORT2           = "GPIOB"
        R_BRAKE_GPIO_PIN2            = "GPIO_Pin_2"
        DISSIPATIVE_BRAKE_POLARITY2  = "ACTIVE_LOW"
        >
    <#global WB_NUM_MOTORS = 2>
</#macro>