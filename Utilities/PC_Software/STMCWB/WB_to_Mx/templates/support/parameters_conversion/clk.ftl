<#if ! _clk_ftl?? >
    <#assign _clk_ftl = 1 >

    <#function clk_freq_MHz>
        <#if CLOCK_FREQUENCY??>
            <#return CLOCK_FREQUENCY?split("_")[2]?number>
        <#else>
            <#return 1>
        </#if>
    </#function>

    <#global CPU_CLK_MHz  = clk_freq_MHz() > <#-- clock frequency in MHz -->
    <#global CPU_CLK_Hz   = CPU_CLK_MHz * 1000000 >
<#-- -->
    <#global HALL_TIM_CLK = CPU_CLK_Hz >
<#-- -->
    <#global ADV_TIM_CLK_Hz    = CPU_CLK_Hz  / TIM_CLOCK_DIVIDER >
    <#global ADV_TIM_CLK_MHz   = CPU_CLK_MHz / TIM_CLOCK_DIVIDER >
<#-- -->
    <#global ADC_CLK_Hz        = CPU_CLK_Hz  / ADC_CLOCK_WB_DIV >
    <#global ADC_CLK_MHz       = CPU_CLK_MHz / ADC_CLOCK_WB_DIV >
<#-- -->
    <#global PWM_PERIOD_CYCLES = ADV_TIM_CLK_Hz / PWM_FREQUENCY>
    <#global HALF_PWM_PERIOD   = PWM_PERIOD_CYCLES / 2 >
<#-- -->
    <#global SYS_TICK_FREQUENCY = 2000>

    <#global DEADTIME_NS = (LOW_SIDE_SIGNALS_ENABLING!"")?matches("ENABLE|LS_PWM_TIMER")?then(valueOf("SW_DEADTIME_NS"), valueOf("HW_DEAD_TIME_NS")) >
</#if>