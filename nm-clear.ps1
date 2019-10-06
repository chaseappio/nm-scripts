param (
    [string] $folder
)
    
$ErrorActionPreference = "Stop"

. "$PSScriptRoot\nm-functions.ps1"

$folder = Get-WorkingFolder -Folder $folder

$hash = Get-StringHash $folder
Format-Volume -FileSystemLabel $hash -NewFileSystemLabel $hash -Force -Confirm -ErrorAction SilentlyContinue -ErrorVariable volumeError | Out-Null

if($volumeError.Count -gt 0){
    if($volumeError.CategoryInfo.Category -eq "ObjectNotFound"){
        throw "Volume for $folder  not found. Please run nm-create first."
    }
    throw $volumeError
}


