<#function cpu_name_and_family workbench_declared_device>

    <#local res = workbench_declared_device?matches(r"^ST(M|SPIN)32([FGHL][0-7]).*$") >
    <#if res?is_sequence && res?groups?is_sequence && res?groups?size gte 3 >
        <#return
            { "name"  : res?groups[0] <#-- mcu    -->
            , "family": res?groups[2] <#-- family -->
            } >
    <#else>
        <#return
            { "name"  : workbench_declared_device
            , "family": "unknown"
            } >
    </#if>
</#function>

<#function wb_board>
    <#local name = BOARD!"CUSTOM">
    <#return
    { "name"    : name
    , "mcu"     : MCU!(MCU_TYPE!"")
    , "isCustom": (name == "CUSTOM")
    }>
</#function>

<#--
		<define key="STM32F446xC_xE" value="TRUE" />
		<define key="MCU_TYPE" value="STM32F446xC_xE" />
		<define key="MCU_SUPPLY_VOLTAGE" value="3.30" />

		<define key="CLOCK_SOURCE" value="EXTERNAL" />
		<define key="EXT_CLOCK_FREQUENCY" value="EXT_CLK_8_MHZ" />
		<define key="CPU_CLK_180_MHZ" value="TRUE" />
		<define key="CLOCK_FREQUENCY" value="CPU_CLK_180_MHZ" />
-->
<#assign
    board       = wb_board()
    cpu         = cpu_name_and_family(MCU_TYPE) + {"PN": MCU}

    clk_MHz     = CLOCK_FREQUENCY?split("_")[2]
    ext_clk_MHz = EXT_CLOCK_FREQUENCY?split("_")[2]
    ext_clk_src = ( (CLOCK_SOURCE!"EXTERNAL")?upper_case == "EXTERNAL" )!true
    int_clk_src = ( (CLOCK_SOURCE!"EXTERNAL")?upper_case != "EXTERNAL" )!false

    hw_info =
        { "board"       : board
        , "cpu"         : cpu
        , "clk_MHz"     : clk_MHz
        , "ext_clk_MHz" : ext_clk_MHz
        , "ext_clk_src" : ext_clk_src
        , "int_clk_src" : int_clk_src
        }
    >
