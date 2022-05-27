function Sync-TerraformShim
{
    [CmdletBinding()]
    param()
    
    $GlobalVersion = Get-Content -Path $script:Terramorph.ConfigFile.GlobalTerraformVersion -ErrorAction SilentlyContinue

    if([string]::IsNullOrWhiteSpace($GlobalVersion))
    {
        Write-Error "Global terraform version not set.`nUse 'Set-TerraformVersion -Version <version>' to set the global version."
        exit
    }

    $TerraformExecutable = Get-TerraformExecutableName

    $Params = @{
        ItemType    = "SymbolicLink"
        Target      = Join-Path -Path $script:Terramorph.Path.Versions -ChildPath $GlobalVersion -AdditionalChildPath $TerraformExecutable
        Path        = Join-Path -Path $script:Terramorph.Path.Shims -ChildPath $TerraformExecutable
        Force       = $true
    }

    Write-Verbose "Shimming terraform $GlobalVersion with '$($Params.Path)'"
    
    # Because windows required admin privilege to create symbolic link, we will simply copy terraform binary
    if($IsWindows)
    {
        Copy-Item -Path $Params.Target -Destination $Params.Path -Force | Out-Null
    }
    else
    {
        New-Item @Params | Out-Null
    }
}