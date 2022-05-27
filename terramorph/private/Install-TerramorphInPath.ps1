function Install-TerramorphInPath
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [ValidateSet("User", "Process")]
        [string] $Scope = "Process"
    )

    if(-not (Test-TerramorphInPath -Scope $Scope))
    {
        $Path = @([Environment]::GetEnvironmentVariable('PATH', $Scope), $script:Terramorph.Path.Shims) -join [IO.Path]::PathSeparator
        [Environment]::SetEnvironmentVariable('PATH', $Path, $Scope)
    }
}