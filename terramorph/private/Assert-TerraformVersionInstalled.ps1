function Assert-TerraformVersionInstalled
{
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, Position=0)]
        [Version] $Version
    )

    if($Version -notin @(Get-TerraformVersion).Version)
    {
        throw "Terraform version $Version is not installed.`nInstall it with 'Install-TerraformVersion -Version $Version' first."
    }
}