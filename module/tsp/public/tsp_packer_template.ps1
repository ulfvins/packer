function New-TSPPackerTemplate {

    [cmdletbinding()]
    param(
        $Builder         = "hyperv-iso",
        $ComputerName    = "Windows10",
        $ISOFileUrl      = "https://software-download.microsoft.com/download/pr/19041.264.200511-0456.vb_release_svc_refresh_CLIENTENTERPRISEEVAL_OEMRET_x64FRE_en-us.iso",
        $ISOFileChecksum = 'sha1:F57E034095E0423FEB575CA82855F73E39FFA713'
    )

    $fn = "[$($MyInvocation.MyCommand)]"
    Write-Verbose -Message $fn

$template = @"
{
  "builders": [
    {
      "type": "hyperv-iso",
      "boot_command": ["<enter>"],
      "boot_wait": "1ms",
      "communicator": "winrm",
      "cpus": 2,
      "disk_size": "61440",
      "enable_secure_boot": true,
      "enable_virtualization_extensions": true,
      "generation": 2,
      "guest_additions_mode": "disable",
      "iso_checksum": "$ISOFileChecksum",
      "iso_url": "$ISOFileUrl",
      "memory": "4096",
      "secondary_iso_images": ["./build/unattend.iso"],
      "shutdown_command": "shutdown /s /t 10 /f /d p:4:1 /c \"Packer Shutdown\"",
      "switch_name": "Default Switch",
      "vm_name": "$ComputerName",
      "winrm_password": "vagrant",
      "winrm_timeout": "2h",
      "winrm_username": "vagrant"
    }
  ],
  "provisioners": [{
    "type": "powershell",
    "scripts": [
      "scripts/test-1.ps1",
      "scripts/test-2.ps1",
      "scripts/install-programs.ps1"
    ]
  }]
}
"@

$templateVBox = @"
{
  "variables": {
    "autounattend": "./answer_files/10/Autounattend.xml",
    "cpus": "2",
    "disk_size": "61440",
    "headless": "true",
    "iso_url": "https://software-download.microsoft.com/download/pr/19041.264.200511-0456.vb_release_svc_refresh_CLIENTENTERPRISEEVAL_OEMRET_x64FRE_en-us.iso",
    "iso_checksum": "F57E034095E0423FEB575CA82855F73E39FFA713",
    "iso_checksum_type": "sha1",
    "memory_size": "2048",
    "vm_name": "packer-w10",
    "cd_files": "{{template_dir}}/answer_files/10/Autounattend.xml"
  },
  "builders": [
    {
      "type": "hyperv-iso",
      "vm_name": "{{user `vm_name`}}",

      "boot_wait": "2m",

      "switch_name": "Default Switch",

      "floppy_files": [
        "{{user `autounattend`}}",
        "./scripts/fixnetwork.ps1",
        "./scripts/disable-winrm.ps1",
        "./scripts/enable-winrm.ps1",
        "./scripts/microsoft-updates.bat",
        "./scripts/win-updates.ps1",
        "./scripts/chocolatey.bat",
        "./scripts/chocopacks.bat"
      ],

      "disk_size": "{{user `disk_size`}}",
      "cpus": "{{user `cpus`}}",
      "memory": "{{user `memory_size`}}",

      "shutdown_timeout": "15m",
      "skip_export": false,
      
      "headless": "{{user `headless`}}",
      
      "iso_checksum": "{{user `iso_checksum_type`}}:{{user `iso_checksum`}}",
      "iso_url": "{{user `iso_url`}}",
      
      "communicator": "winrm",
      "winrm_username": "vagrant",
      "winrm_password": "vagrant",
      "winrm_timeout": "12h",
      "winrm_insecure": true,

      "shutdown_command": "shutdown /s /t 10 /f /d p:4:1 /c \"Packer Shutdown\""
    }
  ]
}
"@

    $Utf8NoBomEncoding = New-Object System.Text.UTF8Encoding $False
    [System.IO.File]::WriteAllLines("$script:ExecutionPath\build\template.json", $template, $Utf8NoBomEncoding)

    &packer validate "$script:ExecutionPath\build\template.json"
}

Export-ModuleMember -Function "New-TSPPackerTemplate"