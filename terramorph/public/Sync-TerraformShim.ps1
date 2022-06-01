function Sync-TerraformShim
{
    [CmdletBinding()]
    param()

    $GlobalVersion = [Version](Get-Content -Path $script:Terramorph.ConfigFile.GlobalTerraformVersion -ErrorAction SilentlyContinue)

    if([string]::IsNullOrWhiteSpace($GlobalVersion))
    {
        throw "Global terraform version not set.`nUse 'Set-TerraformVersion -Version <version>' to set the global version."
    }

    $ReleaseInfo = Get-TerraformReleaseInfo -Version $GlobalVersion

    $Params = @{
        ItemType    = "SymbolicLink"
        Target      = Join-Path -Path $script:Terramorph.Path.Versions -ChildPath $GlobalVersion -AdditionalChildPath $ReleaseInfo.ExecutableName
        Path        = Join-Path -Path $script:Terramorph.Path.Shims -ChildPath $ReleaseInfo.ExecutableName
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