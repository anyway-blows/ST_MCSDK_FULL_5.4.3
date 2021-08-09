<#import "../../ioc_seed/hw_info.ftl" as hw >

<#function targetToolchan declared_by_wb>
        <#return declared_by_wb?switch
        ( "MDK-ARM", "MDK-ARM V5"
         , declared_by_wb) >
</#function>

<#function fromIocIfUpdate param default>
  <#-- Looks for an entry with key 'param' in the ioc_parameter global Map if it exists and return
       its value. If ioc_parameter does not exists, the value of 'default'is returned instead. 
       This allows for reusing values of parameters coming from the original IOC in the context of 
       the Update IOC feature.
   -->
  <#return (ioc_parameters??)?then(ioc_parameters[param],default)>
</#function>


<#macro _project_settings>
ProjectManager.ProjectFileName=${projectName}.ioc
ProjectManager.ProjectName=${projectName}
ProjectManager.TargetToolchain=${ targetToolchan(TARGET_TOOLCHAIN!"EWARM") }
ProjectManager.AskForMigrate=true
ProjectManager.BackupPrevious=false
ProjectManager.ComputerToolchain=false
ProjectManager.CoupleFile=${fromIocIfUpdate("ProjectManager.CoupleFile", "false")}
ProjectManager.CompilerOptimize=${fromIocIfUpdate("ProjectManager.CompilerOptimize", 5)}
ProjectManager.LibraryCopy=0

<#local stm32_FW = TARGET_STM32FW!"Latest" >
<#if stm32_FW == "Latest">
ProjectManager.LastFirmware=true
<#else>
ProjectManager.LastFirmware=false
ProjectManager.FirmwarePackage=STM32Cube FW_${hw.cpu.family} V${stm32_FW}
</#if>

ProjectManager.DefaultFWLocation=true
ProjectManager.DeletePrevious=true
ProjectManager.FreePins=false
ProjectManager.HalAssertFull=false
ProjectManager.KeepUserCode=true
ProjectManager.PreviousToolchain=
ProjectManager.ToolChainLocation=
ProjectManager.ProjectBuild=false
ProjectManager.UnderRoot=false
ProjectManager.HeapSize= ${(hw.cpu.family == "F0")?then("0x80","0x200")}
ProjectManager.StackSize=0x400
</#macro>
