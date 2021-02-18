Function Install-TSOSDPackageManager {

    $chocoExePath = 'C:\ProgramData\Chocolatey\bin'

    If ($($env:Path).ToLower().Contains($($chocoExePath).ToLower())) {
      Write-Verbose "Chocolatey found in PATH, skipping install..."
      Return
    }

    # Add to system PATH
    $systemPath = [Environment]::GetEnvironmentVariable('Path',[System.EnvironmentVariableTarget]::Machine)
    $systemPath += ';' + $chocoExePath
    [Environment]::SetEnvironmentVariable("PATH", $systemPath, [System.EnvironmentVariableTarget]::Machine)

    # Update local process' path
    $userPath = [Environment]::GetEnvironmentVariable('Path',[System.EnvironmentVariableTarget]::User)
    If($userPath) {
      $env:Path = $systemPath + ";" + $userPath
    } Else {
      $env:Path = $systemPath
    }

    # Run the installer
    Invoke-Expression ((New-Object net.webclient).DownloadString('https://chocolatey.org/install.ps1'))

    &choco feature enable -n allowGlobalConfirmation

}

# NOTE: https://github.com/cryps1s/DARKSURGEON
Function Install-TSOSDPackage {

	param(
		[Parameter(Mandatory=$true)]
		[String]$PackageName,

		[Array]$OptionalArguments, 

		[Int]$RetryCounter = 0,

		[Int]$RetryMax = 3,

		[Int]$SleepCounter = 30
	)

	Try
	{
		Do
		{
			If ($OptionalArguments -ne $null)
			{
				$Process = Start-Process -FilePath "choco.exe" -ArgumentList "install","$PackageName","--limit-output","$OptionalArguments" -NoNewWindow -PassThru -Wait 
			}
			else 
			{
				$Process = Start-Process -FilePath "choco.exe" -ArgumentList "install","$PackageName","--limit-output" -NoNewWindow -PassThru -Wait 
			}
			
			If ($Process.ExitCode -ne 0)
			{
				$RetryCounter += 1

				Write-Host "[!] Failed to install package $PackageName. Attempt $RetryCounter out of $RetryMax. Sleeping for $SleepCounter seconds before next retry."
				Start-Sleep -Seconds $SleepCounter
			}
		} Until (($Process.ExitCode -eq 0) -or ($RetryCounter -eq $RetryMax))
	
		If (($Process.ExitCode -ne 0))
		{
			Write-Host "[!] Failed to install $PackageName after $RetryMax attempts. Throwing fatal error and exiting."
		}
	}
	Catch
	{
		Write-Host "[!] Error occurred attempting to install $PackageName. Exiting."
		Write-Host $_.Exception | format-list -force
	}
}

# MAIN

Install-TSOSDPackageManager

$Packages = @(

    #Core Tools
    "7zip.install",
    "cmder",
    "microsoft-windows-terminal",
    "drawio",
    "keepass",

    #Web Tools
    "googlechrome",
    "firefox",
    "fiddler",
    "postman",

    #Developer Tools
    "git.install",
    "nodejs-lts",
    "visualstudiocode",
    "snyk",

    #Other
    "zoomit",
    "zap"
)

ForEach ($Package In $Packages)
{
    Try {
        Write-Host "Installing package $Package"
        Install-TSOSDPackage -PackageName $Package
    }
    Catch {
        Write-Host "Error installing package $Package"
    }
}