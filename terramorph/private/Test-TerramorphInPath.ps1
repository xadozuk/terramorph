function Test-TerramorphInPath
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [ValidateSet("User", "Process")]
        [string] $Scope = "Process"
    )

    $AllPaths = [Environment]::GetEnvironmentVariable('PATH', $Scope) -split [IO.Path]::PathSeparator
    return $AllPaths -contains $script:Terramorph.Path.Shims
}