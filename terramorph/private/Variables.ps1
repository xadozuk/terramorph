$RootPath = if($env:TERRAMORPH_HOME) { $env:TERRAMORPH_HOME }
            else { Join-Path -Path $HOME -ChildPath ".terramorph" }

$ShimsPath = Join-Path -Path $RootPath -ChildPath "shims"

$script:Terramorph = @{
    Path = @{
        Root        = $RootPath
        Versions    = Join-Path -Path $RootPath -ChildPath "versions"
        Shims       = $ShimsPath
    }

    ConfigFile = @{
        GlobalTerraformVersion = Join-Path -Path $RootPath -ChildPath "terraform-version"
    }

    TerraformBinaries = @{
        ReleasesBaseUrl         = "https://releases.hashicorp.com/terraform"
        FileNameFormat          = "terraform_{0}_{1}_{2}.zip"
        ChecksumFileNameFormat  = "terraform_{0}_SHA256SUMS"
    }

    Profile = @{
        ScriptLine = "`$env:PATH = @(`$env:PATH, `"$($ShimsPath)`") -join [IO.Path]::PathSeparator"
    }
}