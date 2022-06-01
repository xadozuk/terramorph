function Get-TerraformReleaseInfo
{
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [string] $Version
    )

    $Arch   = if([Environment]::Is64BitOperatingSystem) { "amd64" }
              else { "386" }

    $OS = switch($true)
        {
            { $IsWindows }  { "windows" }
            { $IsMacOS }    { "darwin" }
            { $IsLinux }    { "linux" }

            default { throw "Unable to determine OS" }
        }

    $ExecutableName = switch($true)
        {
            { $IsWindows }            { "terraform.exe" }
            { $IsLinux -or $IsMacOS } { "terraform" }

            default { throw "Unable to determine terraform executable name" }
        }

    [PSCustomObject] @{
        Version             = $Version
        OS                  = $OS
        Arch                = $Arch
        BaseUrl             = "$($script:Terramorph.TerraformBinaries.ReleasesBaseUrl)/$Version"
        FileName            = $script:Terramorph.TerraformBinaries.FileNameFormat -f $Version, $OS, $Arch
        ChecksumFileName    = $script:Terramorph.TerraformBinaries.ChecksumFileNameFormat -f $Version
        ExecutableName      = $ExecutableName
    }
}