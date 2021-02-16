function Set-TSPExecutionPath {

    [cmdletbinding()]
    param(
        $ExecutionPath
    )

    $fn = "[$($MyInvocation.MyCommand)]"
    Write-Verbose -Message $fn

    Write-Verbose -Message "$fn Settings ExcecutionPath to: $ExecutionPath"
    $Script:ExecutionPath = $ExecutionPath
}

Export-ModuleMember "Set-TSPExecutionPath"