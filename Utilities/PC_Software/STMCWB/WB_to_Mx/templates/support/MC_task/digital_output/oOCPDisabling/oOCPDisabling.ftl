<#--####################################################################################################################
 #  SOURCES:                                                                                                           #
 #######################################################################################################################
 #  <define key="OV_CURR_BYPASS_GPIO_PORT"         value="GPIOD"            />                                         #
 #  <define key="OV_CURR_BYPASS_GPIO_PIN"          value="GPIO_Pin_5"       />                                         #
 #  <define key="OVERCURR_PROTECTION_HW_DISABLING" value="DOUT_ACTIVE_HIGH" />                                         #
 ####################################################################################################################-->

<#function io_description motor>
    <#if motor == 1>
        <#if WB_HW_OV_CURRENT_PROT_BYPASS!false && (WB_ON_OVER_VOLTAGE == TURN_ON_LOW_SIDES)!false>
            <#return
            { "label"           : "M1_OCP_DISABLE"
            , "port"            : OV_CURR_BYPASS_GPIO_PORT
            , "pin"             : OV_CURR_BYPASS_GPIO_PIN
            , "polarity"        : OVERCURR_PROTECTION_HW_DISABLING
            }>
        </#if>
    <#else>
        <#if WB_HW_OV_CURRENT_PROT_BYPASS2!false && (WB_ON_OVER_VOLTAGE2 == TURN_ON_LOW_SIDES)!false >
            <#return
            { "label"           : "M2_OCP_DISABLE"
            , "port"            : OV_CURR_BYPASS_GPIO_PORT2!OV_CURR_BYPASS_GPIO_PORT
            , "pin"             : OV_CURR_BYPASS_GPIO_PIN2!OV_CURR_BYPASS_GPIO_PIN
            , "polarity"        : OVERCURR_PROTECTION_HW_DISABLING2!OVERCURR_PROTECTION_HW_DISABLING
            }>
        </#if>
    </#if>

    <#local err_msg = "NO OVER CURRENT PROTECTION REQUIRED on M${motor}" >
    <#return {"error": err_msg }>
</#function>

<#macro ocp_enable_test_mode >
    <#assign
        WB_HW_OV_CURRENT_PROT_BYPASS     = true
        WB_ON_OVER_VOLTAGE               = TURN_ON_LOW_SIDES
        OV_CURR_BYPASS_GPIO_PORT         = "GPIOD"
        OV_CURR_BYPASS_GPIO_PIN          = "GPIO_Pin_5"
        OVERCURR_PROTECTION_HW_DISABLING = "ACTIVE_HIGH"
        >
    <#assign
        WB_HW_OV_CURRENT_PROT_BYPASS2     = true
        WB_ON_OVER_VOLTAGE2               = TURN_ON_LOW_SIDES
        OV_CURR_BYPASS_GPIO_PORT2         = "GPIOA"
        OV_CURR_BYPASS_GPIO_PIN2          = "GPIO_Pin_2"
        OVERCURR_PROTECTION_HW_DISABLING2 = "ACTIVE_LOW"
        >
    <#assign WB_NUM_MOTORS = 2>
</#macro>