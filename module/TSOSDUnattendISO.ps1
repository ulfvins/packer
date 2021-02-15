function Create-TSOSDUnattendISO {

    Param(
        $Source = @(
            "$global:ExecutionPath\build\Autounattend.xml"
            "$global:ExecutionPath\scripts\fixnetwork.ps1",
            "$global:ExecutionPath\scripts\disable-screensaver.ps1",
            "$global:ExecutionPath\scripts\disable-winrm.ps1",
            "$global:ExecutionPath\scripts\enable-winrm.ps1",
            "$global:ExecutionPath\scripts\microsoft-updates.bat",
            "$global:ExecutionPath\scripts\win-updates.ps1"
        )
    )

($options = new-object System.CodeDom.Compiler.CompilerParameters).CompilerOptions = '/unsafe'

# NOTE: This code only runs on PowerShell 3-5, not Core+
Add-Type -CompilerParameters $options -TypeDefinition @'
public class ISOFile
{
  public unsafe static void Create(string Path, object Stream, int BlockSize, int TotalBlocks)
  {
    int bytes = 0;
    byte[] buf = new byte[BlockSize];
    var ptr = (System.IntPtr)(&bytes);
    var o = System.IO.File.OpenWrite(Path);
    var i = Stream as System.Runtime.InteropServices.ComTypes.IStream;

    if (o != null) {
      while (TotalBlocks-- > 0) {
        i.Read(buf, BlockSize, ptr); o.Write(buf, 0, bytes);
      }
      o.Flush(); o.Close();
    }
  }
}
'@

    ($Image = New-Object -com IMAPI2FS.MsftFileSystemImage -Property @{VolumeName="Unattend"}).ChooseImageDefaultsForMediaType(2)

    foreach($item in $Source) {

        if($item -isnot [System.IO.FileInfo] -and $item -isnot [System.IO.DirectoryInfo]) {
            $item = Get-Item -LiteralPath $item
        }

        if($item) {

            try { 
                $Image.Root.AddTree($item.FullName, $true)
            } 
            catch {
                Write-Error -Message ($_.Exception.Message.Trim() + ' Try a different media type.') }
            }
    }

    $Result = $Image.CreateResultImage()
    $Target = New-Item -Path "$global:ExecutionPath\build\unattend.iso" -ItemType File -Force:$Force -ErrorAction SilentlyContinue
    [ISOFile]::Create($Target.FullName,$Result.ImageStream,$Result.BlockSize,$Result.TotalBlocks)

}
