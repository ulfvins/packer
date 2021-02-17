function Remove-TSPArtifacts {

    [cmdletbinding()]
    param()

    $fn = "[$($MyInvocation.MyCommand)]"
    Write-Verbose -Message $fn

    If(Test-Path "$script:ExecutionPath\build"){

        Write-Verbose "$fn Found build artifacts at $($script:ExecutionPath + "\build"), deleting..."
    
        Remove-Item -Path "$script:ExecutionPath\build" -Force -Recurse -ErrorAction SilentlyContinue
        Remove-Item -Path "$script:ExecutionPath\output-hyperv-iso" -Force -Recurse -ErrorAction SilentlyContinue
    }

    New-Item -Path "$script:ExecutionPath\build" -ItemType Directory -Force -ErrorAction SilentlyContinue | Out-Null
}

Export-ModuleMember "Remove-TSPArtifacts"