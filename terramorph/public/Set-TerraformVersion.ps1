function Set-TerraformVersion
{
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, Position=0)]
        [string] $Version
    )

    if($Version -notin @(Get-TerraformVersion).Version)
    {
        Write-Error "Terraform version $Version is not installed.`nInstall it with 'Install-TerraformVersion -Version $Version' first."
        exit
    }
    
    $Version | Out-File -FilePath $script:Terramorph.ConfigFile.GlobalTerraformVersion

    Sync-TerraformShim
}