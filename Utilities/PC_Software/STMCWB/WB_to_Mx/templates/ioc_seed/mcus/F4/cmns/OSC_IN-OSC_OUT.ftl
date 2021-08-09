# PINs for the External OSCILLATOR1
#
${ Mcu.PINs( "PH0\\ -\\ OSC_IN", "PH1\\ -\\ OSC_OUT")}

# PINs for the External OSCILLATOR
PH0\ -\ OSC_IN.Locked=true
PH0\ -\ OSC_IN.Mode=HSE-External-Oscillator
PH0\ -\ OSC_IN.Signal=RCC_OSC_IN


PH1\ -\ OSC_OUT.Locked=true
PH1\ -\ OSC_OUT.Mode=HSE-External-Oscillator
PH1\ -\ OSC_OUT.Signal=RCC_OSC_OUT

