<#assign
    forward_defines_to_mx     = true
    show_new_GPIO_def_comment = false

    currentSense          = true
    speedSense            = true
    tempAndBusSense       = true
    gateDriver            = true
    digitalIO             = true
    mcu                   = true

    ui =
        { "dac"            : true
        , "serial"         : true
        , "lcd"            : true
        , "start_stop_btn" : true
        }

    pfc =
        { "tim"            : true
        }

    use_internal_opamp_default = false
    ScanConvMode = { "fixed": "ADC_SCAN_ENABLE" }

    use_mx_shared_signal_name = false

    syncTimers_min_num_motors = 1
    >