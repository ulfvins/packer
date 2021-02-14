#packer build --only=vmware-iso `
#       --var disk_size=102400 `
#       --var iso_url=C:/packer_cache/Win10_1607_English_x64.iso `
#       --var iso_checksum=sha1:99fd8082a609997ae97a514dca22becf20420891 `
#       --var autounattend=./tmp/10/Autounattend.xml `
#       windows_10.json

# bigger disk for hyperv
Param(
    [ValidateSet("Default","Gen2")]
    $imageType = "Default",

    [ValidateSet("Base","Backoffice","Development")]
    $Role = "Base"
)

function Cleanup-Artifacts {

    If(Test-Path .\build){

    }
}


# TODO: Create a packer.json file dynamically in the build folder...
# TODO: If we have a Gen2 Hyper-V machine, create a ISO with files

if($image -eq "Gen2"){
    packer build w10e-uefi.json -force
}
else {
    packer build w10e.json -force
}
