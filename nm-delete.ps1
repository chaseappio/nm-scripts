param (
    [string] $folder
)
    
$ErrorActionPreference = "Stop"

. "$PSScriptRoot\nm-functions.ps1"

$path = Get-VHD $folder
$working = Get-WorkingFolder $folder
Dismount-VHD -Path $path -ErrorAction SilentlyContinue
Remove-Item $working -Recurse -Force -ErrorAction SilentlyContinue
Remove-Item $path -Recurse -Force -ErrorAction SilentlyContinue