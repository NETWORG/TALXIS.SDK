function Set-WorkingFolder {
    param (
        [string] $Path
    )
    $tempFolder = (Join-Path -Path ([IO.Path]::GetTempPath()) -ChildPath "TALXIS.SDK.TempFolder")
    mkdir -p $tempFolder
    $global:workingDirPath = $tempFolder
}

Set-WorkingFolder

#-------------------------------------------
## Load Script Libraries
##-------------------------------------------
$functions =  @(Get-ChildItem -Path $PSScriptRoot\Functions\*.ps1 -Recurse -ErrorAction SilentlyContinue)
$model =  @(Get-ChildItem -Path $PSScriptRoot\Model\*.ps1 -Recurse -ErrorAction SilentlyContinue)



#Dot source the files
Foreach($import in @($model + $functions))
{
    Try
    {
        . $import.fullname
        Write-Host " IMPORTING SCRIPT: $($import.fullname)" -ForegroundColor Cyan
    }
    Catch
    {
        Write-Error -Message "Failed to import function $($import.fullname): $_"
    }
}

Export-ModuleMember -Function $functions.Basename
Export-ModuleMember -Function $model.Basename

Install-PowerPlatformSDK