# Windows 10 Enterprise Templates for Packer

### Introduction

This repository contains a Windows 10 template that can be used to create a Hyper-V box for
Vagrant using Packer ([Website](https://www.packer.io))
([Github](https://github.com/mitchellh/packer)).

This repository is a using some components from these repositories:
* [joefitzgerald](https://github.com/joefitzgerald/packer-windows)
* [StefanScherer](https://github.com/StefanScherer/packer-windows)
* [Bento](https://github.com/chef/bento)

### Packer Version

[Packer](https://github.com/mitchellh/packer/blob/master/CHANGELOG.md) `1.6+` is recommended.

### Product Keys

The `Autounattend.xml` files are configured to work correctly with trial ISOs
(which will be downloaded and cached for you the first time you perform a
`packer build`). If you would like to use retail or volume license ISOs, you
need to update the `UserData`>`ProductKey` element as follows:

* Uncomment the `<Key>...</Key>` element
* Insert your product key into the `Key` element

If you are going to configure your VM as a KMS client, you can use the product
keys at http://technet.microsoft.com/en-us/library/jj612867.aspx. These are the
default values used in the `Key` element.

### Using existing ISOs

If you have already downloaded the ISOs or would like to override them, set
these additional variables:

* iso_url - path to existing ISO
* iso_checksum - md5sum of existing ISO (if different)

```
packer build -var 'iso_url=./custom10.iso' .\w10e.json
```

### Windows Updates

The scripts in this repo will install all Windows updates � by default � during
Windows Setup. This is a _very_ time consuming process, depending on the age of
the OS and the quantity of updates released since the last service pack. You
might want to do yourself a favor during development and disable this
functionality, by commenting out the `WITH WINDOWS UPDATES` section and
uncommenting the `WITHOUT WINDOWS UPDATES` section in `Autounattend.xml`:

```xml
<!-- WITHOUT WINDOWS UPDATES -->
<SynchronousCommand wcm:action="add">
    <CommandLine>cmd.exe /c C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe -File a:\openssh.ps1 -AutoStart</CommandLine>
    <Description>Install OpenSSH</Description>
    <Order>99</Order>
    <RequiresUserInput>true</RequiresUserInput>
</SynchronousCommand>
<!-- END WITHOUT WINDOWS UPDATES -->
<!-- WITH WINDOWS UPDATES -->
<!--
<SynchronousCommand wcm:action="add">
    <CommandLine>cmd.exe /c a:\microsoft-updates.bat</CommandLine>
    <Order>98</Order>
    <Description>Enable Microsoft Updates</Description>
</SynchronousCommand>
<SynchronousCommand wcm:action="add">
    <CommandLine>cmd.exe /c C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe -File a:\openssh.ps1</CommandLine>
    <Description>Install OpenSSH</Description>
    <Order>99</Order>
    <RequiresUserInput>true</RequiresUserInput>
</SynchronousCommand>
<SynchronousCommand wcm:action="add">
    <CommandLine>cmd.exe /c C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe -File a:\win-updates.ps1</CommandLine>
    <Description>Install Windows Updates</Description>
    <Order>100</Order>
    <RequiresUserInput>true</RequiresUserInput>
</SynchronousCommand>
-->
<!-- END WITH WINDOWS UPDATES -->
```


### Hyper-V Support

If you are running Windows 10, Windows Server 2016 or later, then you can also use these packerfiles to build
a Hyper-V virtual machine. I have the ISO already downloaded to save time, and
only have Hyper-V installed on my laptop, so I run:

```
packer build --only hyperv-iso -var 'hyperv_switchname=Ethernet' -var 'iso_url=./server2016.iso' .\windows_2016_docker.json
```

Where `Ethernet` is the name of my default Hyper-V Virtual Switch. You then can use this box with Vagrant to spin up a Hyper-V VM.

#### Generation 2 VMs

Some of these images use Hyper-V "Generation 2" VMs to enable the latest features and faster booting. However, an extra manual step is needed to put the needed files into ISOs because Gen2 VMs don't support virtual floppy disks.

* `windows_server_insider.json`
* `windows_server_insider_docker.json`
* `windows_10_insider.json`

Before running `packer build`, be sure to run `./make_unattend_iso.ps1` first. Otherwise the build will fail on a missing ISO file

```none
hyperv-iso output will be in this color.

1 error(s) occurred:

* Secondary Dvd image does not exist: CreateFile ./iso/windows_server_insider_unattend.iso: The system cannot find the file specified.
```

## Related projects

A huge thank you to these related projects from which I taken inspiration and often used as a source for inspiration and some code.

* [joefitzgerald](https://github.com/joefitzgerald/packer-windows)
* [StefanScherer](https://github.com/StefanScherer/packer-windows)
* [Bento](https://github.com/chef/bento)