function Install-Terramorph
{
    [CmdletBinding()]
    param()

    Write-Verbose "Adding terramorph shims to `$PATH"
    Register-TerramorphInPath -Persist

    Write-Host "Terramorph has been added to your `$PATH environment variable." -ForegroundColor Green
}