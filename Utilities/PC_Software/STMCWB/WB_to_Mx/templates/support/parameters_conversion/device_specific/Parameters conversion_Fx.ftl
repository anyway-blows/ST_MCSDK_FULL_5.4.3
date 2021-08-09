<#function add_defines_pre_clk>

    <#if ( ! ADC_CLOCK_WB_DIV?? ) || ( ADC_CLOCK_WB_DIV < 1 ) >
        <#global ADC_CLOCK_WB_DIV = 1>
    </#if>
    <#global TIM_CLOCK_DIVIDER = 1 >
    <#global REP_COUNTER = REGULATION_EXECUTION_RATE * 2 - 1 >

    <#return true>
</#function>

<#function add_defines_post_clk correction_factor latency=0>
    <#import "dead_time.ftl" as dt>
<#--
    <#global DEAD_TIME_ADV_TIM_CLK_MHz = ADV_TIM_CLK_MHz * TIM_CLOCK_DIVIDER >
    <#global DEAD_TIME_COUNTS_1        = DEAD_TIME_ADV_TIM_CLK_MHz * DEADTIME_NS / 1000 >
-->

    <#global DEAD_TIME_COUNTS = dt.dead_time_counts( ADV_TIM_CLK_MHz * TIM_CLOCK_DIVIDER * DEADTIME_NS / 1000 ) >
    <#global SAMPLING_TIME_NS = (1000 * (correction_factor + CURR_SAMPLING_TIME) / ADC_CLK_MHz)?floor >
    <#global TMIN             = 1 + ( ((DEADTIME_NS + TRISE_NS + SAMPLING_TIME_NS + latency) * ADV_TIM_CLK_MHz) / 1000 )?floor >
    <#global HTMIN            = (TMIN / 2)?floor >

    <#return true>
</#function>