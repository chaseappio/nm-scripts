
param (
    [string] $folder
)
    
$ErrorActionPreference = "Stop"

. "$PSScriptRoot\nm-functions.ps1"

$folder = Get-WorkingFolder -Folder $folder

$hash = Get-StringHash $folder
$config = Read-Config
$vhdsize = $config.DefaultDiskSize
$vhdpath = Get-VHD

New-Item -Path $folder -Type directory -Force | Out-Null

if(Test-Path $vhdpath)
{
    throw "VHD already exists"
}

$partition = New-VHD -Path $vhdpath -Fixed -SizeBytes $vhdsize |
Mount-VHD -NoDriveLetter -Passthru |
Initialize-Disk -Passthru |
New-Partition -UseMaximumSize 

Format-Volume -NewFileSystemLabel $hash -Partition $partition -FileSystem NTFS -Confirm:$false -Force | Out-Null
Add-PartitionAccessPath -InputObject $partition -AccessPath $folder -ErrorAction Stop | Out-Null

