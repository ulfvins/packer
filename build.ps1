#TODO: Start timer, build time...

Import-Module .\module\tsp -Verbose -Force
Set-TSPExecutionPath -ExecutionPath $PSScriptRoot -Verbose

# MAIN
# TODO: Ensure-TSOSDPacker...
Remove-TSPArtifacts -Verbose

New-TSPAutounattededFile -Verbose
New-TSPUnattendISO -Verbose
New-TSPPackerTemplate -Verbose

&packer build "$PSScriptRoot\build\template.json"

Write-Host "Complete!" -ForegroundColor Green