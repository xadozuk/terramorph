function Set-TerraformVersion
{
    [CmdletBinding(SupportsShouldProcess)]
    param(
        [Parameter(Mandatory, Position=0)]
        [Version] $Version
    )

    if($Version -notin @(Get-TerraformVersion).Version)
    {
        Write-Error "Terraform version $Version is not installed.`nInstall it with 'Install-TerraformVersion -Version $Version' first."
        exit
    }

    if($PSCmdlet.ShouldProcess("Set global terraform version to $Version", "global", "SetVersion"))
    {
        $Version | Out-File -FilePath $script:Terramorph.ConfigFile.GlobalTerraformVersion

        Sync-TerraformShim

        return [PSCustomObject] @{
            Version     = $Version
            IsDefault   = $true
        }
    }
}