if($null -eq $env:GITHUB_REF)
{
    throw "Script must be run as a GitHub Action on release creation."
}

$ReleaseVersion = [Version]($env:GITHUB_REF -replace 'refs/tags/', '')
Update-ModuleManifest -Path "./terramorph/terramorph.psd1" -ModuleVersion $ReleaseVersion