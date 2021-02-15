function Cleanup-TSOSDArtifacts {

    If(Test-Path "$global:ExecutionPath\build"){
        Remove-Item -Path "$global:ExecutionPath\build" -Force -Recurse -ErrorAction SilentlyContinue
        Remove-Item -Path "$global:ExecutionPath\output-hyperv-iso" -Force -Recurse -ErrorAction SilentlyContinue
    }

    New-Item -Path "$global:ExecutionPath\build" -ItemType Directory -Force -ErrorAction SilentlyContinue | Out-Null
}