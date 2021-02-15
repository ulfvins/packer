. .\module\TSOSDArtifacts.ps1
. .\module\TSOSDPackerTemplate.ps1 -Force
. .\module\TSOSDUnattendISO.ps1
. .\module\TSOSDAutounattededFile.ps1

$global:ExecutionPath = $PSScriptRoot

# MAIN
Cleanup-TSOSDArtifacts
Create-TSOSDAutounattededFile
Create-TSOSDUnattendISO
Create-TSOSDPackerTemplate

&packer build "$global:ExecutionPath\build\template.json"