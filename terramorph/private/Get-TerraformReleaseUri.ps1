function Get-TerraformReleaseUri
{
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [string] $Version
    )

    $OS = switch($true)
        {
            { $IsWindows }  { "windows" }
            { $IsMacOS }    { "darwin" }
            { $IsLinux }    { "linux" }

            default { throw "Unable to determine OS" }
        }

    $Arch   = if([Environment]::Is64BitOperatingSystem) { "amd64" }
              else { "386" }

    $script:Terramorph.URI.Release -f $Version, $OS, $Arch
}