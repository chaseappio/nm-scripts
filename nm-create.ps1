
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
$startup = Get-Startup-Script

New-Item -Path $folder -Type directory -Force | Out-Null

if(Test-Path $vhdpath)
{
    $recreate = Read-Host -Prompt 'VHD already exists. Do you want to re-create ?'

    if($recreate -eq 'Y')
    {
        Remove-Item -Path $vhdpath
    }
    else{
        throw "VHD already exists."
    }
}

$partition = New-VHD -Path $vhdpath -SizeBytes $vhdsize |
Mount-VHD -NoDriveLetter -Passthru |
Initialize-Disk -Passthru |
New-Partition -UseMaximumSize 

Set-Content -Path $startup -Value "select vdisk file=""$vhdpath"""
Add-Content -Path $startup -Value "attach vdisk"
Add-Content -Path $startup -Value "assign mount=""$folder"""
Add-Content -Path $startup -Value "exit"

$trigger = New-JobTrigger -AtStartup -RandomDelay 00:00:10
$scriptblock = {
    param($p1) 
    diskpart /s $p1
}
Get-ScheduledJob -Name "Mount-Startup-$hash" -ErrorAction SilentlyContinue | Unregister-ScheduledJob -Force -ErrorAction SilentlyContinue

Register-ScheduledJob -Trigger $trigger -ScriptBlock $scriptblock -Name "Mount-Startup-$hash" -ArgumentList @($startup) | Out-Null

Format-Volume -NewFileSystemLabel $hash -Partition $partition -FileSystem NTFS -Confirm:$false -Force | Out-Null
Add-PartitionAccessPath -InputObject $partition -AccessPath $folder -ErrorAction Stop | Out-Null

