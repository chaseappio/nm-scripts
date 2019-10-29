
param (
    [bool] $DynamicDisk,
    [Int32] $DefaultDiskSize= 1GB,
    [Parameter(Mandatory = $true)]
    [string] $DisksFolder
)

. "$PSScriptRoot\nm-functions.ps1"

Write-Config -DefaultDiskSize $DefaultDiskSize -DisksFolder $DisksFolder -DynamicDisk $DynamicDisk