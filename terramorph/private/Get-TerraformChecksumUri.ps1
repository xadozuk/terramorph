function Get-TerraformChecksumUri
{
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [string] $Version
    )

    $script:Terramorph.URI.Checksum -f $Version
}