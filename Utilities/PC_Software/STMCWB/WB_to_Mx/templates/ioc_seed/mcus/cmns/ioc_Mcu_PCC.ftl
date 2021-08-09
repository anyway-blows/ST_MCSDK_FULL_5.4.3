<#macro ioc_Mcu_PCC u>
Mcu.Family=${              u.Family    }
Mcu.Package=${             u.Package   }
Mcu.Name=${                u.Name      }
Mcu.UserName=${            u.UserName  }
ProjectManager.DeviceId=${ u.UserName  }

PCC.Line=${                u.Line      }
PCC.MCU=${                 u.Name      }
PCC.PartNumber=${          u.UserName  }
PCC.Series=${              u.Family    }
PCC.Checker=false
PCC.Seq0=0
PCC.Temperature=25
PCC.Vdd=3.6
</#macro>
