function Install-TerraformVersion
{
    [CmdletBinding(DefaultParameterSetName="Version")]
    param(
        [Parameter(Mandatory, Position=0)]
        [Version] $Version,

        [Parameter()]
        [switch] $Force,

        [Parameter(ParameterSetName="Latest")]
        [switch] $Latest
    )

    if ($Latest)
    {
        $Version = Get-TerraformVersion -All |
            Select-Object -ExpandProperty Version |
            Sort-Object -Descending |
            Select-Object -First 1
    }

    $VersionPath = Join-Path -Path $script:Terramorph.Path.Versions -ChildPath $Version

    if((Test-Path -Path $VersionPath))
    {
        if(-not $Force)
        {
            Write-Warning "Version '$Version' is already installed, use -Force to reinstall"

            return [PSCustomObject] @{
                Version     = $Version
                Installed   = $false
                Reason      = "Already installed"
            }
        }

        Get-Item -Path $VersionPath | Remove-Item -Force -Recurse
    }

    $TempFilePath   = [IO.Path]::GetTempFileName()
    $ReleaseInfo    = Get-TerraformReleaseInfo -Version $Version
    $ReleaseUri     = "$($ReleaseInfo.BaseUrl)/$($ReleaseInfo.FileName)"

    Write-Verbose "Downloading terraform $Version from $ReleaseUri"

    try
    {
        $WebClient = [Net.WebClient]::new()
        $WebClient.DownloadFile($ReleaseUri, $TempFilePath)
    }
    catch [System.Net.WebException]
    {
        if($_.Exception.Response.StatusCode -eq "NotFound")
        {
            Write-Error "Version $Version is not available on releases.hashicorp.com"
        }

        throw $_
    }

    if(-not(Test-TerraformReleaseChecksum -Version $Version -FilePath $TempFilePath))
    {
        Remove-Item -Path $TempFilePath

        throw "Checksum verification failed for version $Version."
    }


    Write-Verbose "Installing terraform $Version into $VersionPath"

    New-Item -Path $VersionPath -ItemType Directory | Out-Null
    Expand-Archive -Path $TempFilePath -DestinationPath $VersionPath -Force

    [PSCustomObject] @{
        Version     = $Version
        Installed   = $true
    }
}