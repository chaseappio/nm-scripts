
function Config-Path {
    $path =  Join-Path -Path $env:USERPROFILE -ChildPath ".nm"
    $settingsPath = Join-Path -Path $path -ChildPath "settings.json"
    New-Item -Path $path -Type directory -Force | Out-Null
    return $settingsPath;
}

function Get-WorkingFolder{
    param (
        [string]
        $folder
    )

    if("" -eq $folder){
        $folder = (Get-Location).Path
    }

    return Join-Path -Path $folder -ChildPath "node_modules"
}
function Get-StringHash([String] $String,$HashName = "MD5") 
{ 
    $StringBuilder = New-Object System.Text.StringBuilder 
    [System.Security.Cryptography.HashAlgorithm]::Create($HashName).ComputeHash([System.Text.Encoding]::UTF8.GetBytes($String))|%{ 
    [Void]$StringBuilder.Append($_.ToString("x2")) 
    } 
    $StringBuilder.ToString() 
}

function Read-Config {
    $settingsPath = Config-Path
    if(-not (Test-Path -Path $settingsPath)){
        throw "nm was not configured yet. Please run nm-config first"
    }

    return Get-Content -Raw -Path $settingsPath | ConvertFrom-Json
}

function Get-VHD {
    param (
        [string]
        $folder
    )

    $folder = Get-WorkingFolder -Folder $folder
    $hash = Get-StringHash $folder
    $config = Read-Config
    return Join-Path -Path $config.DisksFolder -ChildPath "$hash.vhd"
}

function Get-Startup-Script {
    param (
        [string]
        $folder
    )

    $folder = Get-WorkingFolder -Folder $folder
    $hash = Get-StringHash $folder
    $config = Read-Config
    return Join-Path -Path $config.DisksFolder -ChildPath "$hash.txt"
}

function Write-Config {
    param (
        [bool] $DynamicDisk,
        [Int32] $DefaultDiskSize= 1GB,
        [Parameter(Mandatory = $true)]
        [string] $DisksFolder
    )
    
    $settingsPath = Config-Path
    
    $settings = @{}
    $settings.DefaultDiskSize = $DefaultDiskSize
    $settings.DisksFolder = $DisksFolder
    $settings.DynamicDisk = $DynamicDisk

    ConvertTo-Json -InputObject $settings | Out-File $settingsPath
}