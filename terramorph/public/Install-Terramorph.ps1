function Install-Terramorph
{
    [CmdletBinding()]
    param()

    Write-Verbose "Adding terramorph shims to `$PATH"
    Install-TerramorphInPath -Scope User

    # Add terramorph to current process so it can be used direclty
    Write-Verbose "Adding terramorph shims into the current process"
    Install-TerramorphInPath -Scope Process
}