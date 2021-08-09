<#import "support/ui.ftl" as ui >

<#macro do_more>
    <@test_ADC_cs_info />
</#macro>

<#macro test_ADC_cs_info>
    <#import "support/MC_task/ADC/ADC_cs_info.ftl" as info >
    <@ui.boxed_loop "ADC_cs_info" 1..WB_NUM_MOTORS " "; idx, m>
        <#local title = "Motor ${m}"
        phses = ["U","V","W","x"]
        >
        <@ui.boxed_loop title phses ". "; idx2, p >
            <#local o = info.adc_info(m, p)>
            <@ui.comment
            [ "   Phase ${p}"
            , "       ADC       = ${ o.src.ADC       }"
            , "       CHANNEL   = ${ o.src.CHANNEL   }"
            , "       GPIO_PORT = ${ o.src.GPIO_PORT }"
            , "       GPIO_PIN  = ${ o.src.GPIO_PIN  }"
            , "                                                  "
            , "       what = ${  o.what }                        "
            , "       ch   = ${  o.channel.idx   }               "
            , "       adcs = [${ o.channel.adcs?join(', ')   }]  "
            , "       gpio = ${  o.gpio }                        "
            ] />
        </@ui.boxed_loop>
    </@ui.boxed_loop>
</#macro>
