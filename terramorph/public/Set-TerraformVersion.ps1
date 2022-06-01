function Set-TerraformVersion
{
    [CmdletBinding(SupportsShouldProcess)]
    param(
        [Parameter(Mandatory, Position=0)]
        [Version] $Version
    )

    if($Version -notin @(Get-TerraformVersion).Version)
    {
        throw "Terraform version $Version is not installed.`nInstall it with 'Install-TerraformVersion -Version $Version' first."
    }

    if($PSCmdlet.ShouldProcess("Set global terraform version to $Version", "global", "SetVersion"))
    {
        $Version.ToString() | Out-File -FilePath $script:Terramorph.ConfigFile.GlobalTerraformVersion

        Sync-TerraformShim

        return [PSCustomObject] @{
            Version     = $Version
            IsDefault   = $true
        }
    }
}