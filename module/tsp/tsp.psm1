#Get public and private function definition files.
Write-Verbose "About to import functions..."

$ImageOption = [ordered]@{
    ComputerName        = $null
    SystemLocale        = $null
    UserLocale          = $null
    TimeZone            = $null
    ISOurl              = $null
    ISOChecksum         = $null
    VagrantToken        = $null
}

New-Variable -Name ImageOption -Value $ImageOption -Scope Script -Force

New-Variable -Name ExecutionPath -Value $null -Scope Script -Force

$Public  = @( Get-ChildItem -Path $PSScriptRoot\public\*.ps1 -ErrorAction SilentlyContinue )
$Private = @( Get-ChildItem -Path $PSScriptRoot\private\*.ps1 -ErrorAction SilentlyContinue )

#Dot source the files
Foreach($import in @($Public + $Private))
{
    Try
    {
        Write-Verbose -Message "Importing $import.fullname"
        . $import.fullname
    }
    Catch
    {
        Write-Error -Message "Failed to import function $($import.fullname): $_"
    }
}

# Here I might...
    # Read in or create an initial config file and variable
    # Export Public functions ($Public.BaseName) for WIP modules
    # Set variables visible to the module and its functions only

Export-ModuleMember -Function $Public.Basename