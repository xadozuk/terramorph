$RootPath = Join-Path -Path $HOME -ChildPath ".terramorph"

$script:Terramorph = @{
    Path = @{
        Root        = $RootPath
        Versions    = Join-Path -Path $RootPath -ChildPath "versions"
        Shims       = Join-Path -Path $RootPath -ChildPath "shims"
    }

    ConfigFile = @{
        GlobalTerraformVersion = Join-Path -Path $RootPath -ChildPath "terraform-version"
    }

    URI = @{
        ReleaseList = "https://releases.hashicorp.com/terraform"
        Release     = "https://releases.hashicorp.com/terraform/{0}/terraform_{0}_{1}_{2}.zip"
        Checksum    = "https://releases.hashicorp.com/terraform/{0}/terraform_{0}_SHA256SUMS"
    }
}