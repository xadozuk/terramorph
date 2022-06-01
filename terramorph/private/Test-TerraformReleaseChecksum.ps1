function Test-TerraformReleaseChecksum
{
    param(
        [Parameter(Mandatory)]
        [Version] $Version,

        [Parameter(Mandatory)]
        [string] $FilePath
    )

    $ReleaseInfo = Get-TerraformReleaseInfo -Version $Version

    $ActualChecksum = Get-FileHash -Path $FilePath -Algorithm SHA256

    try
    {
        $WebClient = [Net.WebClient]::new()
        $Checksums = $WebClient.DownloadString("$($ReleaseInfo.BaseUrl)/$($ReleaseInfo.ChecksumFileName)").Split("`n")
    }
    catch
    {
        Write-Error "Unable to retreive checksums from HashiCorp for version $Version"
        return $false
    }

    # Checksum file format
    # <hash>  <filename>
    # c6672d137f10cce0800ff449e9f976dc1fc46af44d3ca3eef97ade5748f4d67d  terraform_1.2.1_linux_386.zip
    # 8cf8eb7ed2d95a4213fbfd0459ab303f890e79220196d1c4aae9ecf22547302e  terraform_1.2.1_linux_amd64.zip

    $ExpectedVersionChecksum = ($Checksums | Where-Object { $_ -like "*$($ReleaseInfo.FileName)"}) -split "\s+" | Select-Object -First 1

    return $ExpectedVersionChecksum -eq $ActualChecksum.Hash
}