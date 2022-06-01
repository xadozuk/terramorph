function Get-TerraformVersion
{
    [CmdletBinding(DefaultParameterSetName="Local")]
    [OutputType([object[]])]
    param(
        [Parameter(ParameterSetName="Online")]
        [switch] $All,

        [Parameter(ParameterSetName="Local")]
        [switch] $Current
    )

    # Check online
    if($All)
    {
        <#
        outerHTML                                      tagName href
        ---------                                      ------- ----
        <a href="/">../</a>                            A       /
        <a href="/terraform/1.2.1">terraform_1.2.1</a> A       /terraform/1.2.1
        <a href="/terraform/1.2.0">terraform_1.2.0</a> A       /terraform/1.2.0
        #>
        $Links = Invoke-WebRequest -Uri $script:Terramorph.TerraformBinaries.ReleasesBaseUrl |
            Select-Object -ExpandProperty Links

        $Links |
            # Remove non-semantic version (MAJOR.MINOR.PATCH.REVISION)
            Where-Object { $_.href -match "^/terraform/\d+\.\d+\.\d+(\.\d+)?$" } |
            Select-Object -ExpandProperty href |
            Foreach-Object {
                [PSCustomObject] @{
                    Version = [Version]($_ -replace '/terraform/', '')
                }
            } |
            Sort-Object Version -Descending
    }
    # Return installed version
    else
    {
        $GlobalVersion = Get-Content -Path $script:Terramorph.ConfigFile.GlobalTerraformVersion -ErrorAction SilentlyContinue

        $InstalledVersions = Get-ChildItem -Path $script:Terramorph.Path.Versions |
            Foreach-Object {
                [PSCustomObject] ([ordered] @{
                    Version   = [Version] $_.BaseName
                    IsDefault = $GlobalVersion -eq $_.BaseName
                })
            } |
            Sort-Object Version -Descending

        if($Current)
        {
            $InstalledVersions | Where-Object IsDefault | Select-Object -ExcludeProperty IsDefault
        }
        else
        {
            $InstalledVersions
        }
    }
}