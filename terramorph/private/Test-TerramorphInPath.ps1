function Test-TerramorphInPath
{
    [CmdletBinding()]
    param()

    $Paths = $env:PATH -split [IO.Path]::PathSeparator

    $Paths -contains $script:Terramorph.Path.Shims
}