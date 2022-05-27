function Install-TerraformVersion
{
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, Position=0)]
        [string] $Version,

        [Parameter()]
        [switch] $Force
    )

    $VersionPath = Join-Path -Path $script:Terramorph.Path.Versions -ChildPath $Version

    if((Test-Path -Path $VersionPath))
    {
        if(-not $Force)
        {
            Write-Warning "Version '$Version' is already installed, use -Force to reinstall"
            return
        }

        Get-Item -Path $VersionPath | Remove-Item -Force -Recurse
    }

    New-Item -Path $VersionPath -ItemType Directory | Out-Null
    
    $VersionUri     = Get-TerraformReleaseUri -Version $Version
    $TempFilePath   = [IO.Path]::GetTempFileName()

    Write-Verbose "Downloading terraform $Version from $VersionUri"
    $WebClient = [Net.WebClient]::new()
    $WebClient.DownloadFile($VersionUri, $TempFilePath)

    # TODO: Validate checksum

    Write-Verbose "Installing terraform $Version into $VersionPath"
    Expand-Archive -Path $TempFilePath -DestinationPath $VersionPath -Force
}