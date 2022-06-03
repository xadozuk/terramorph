Describe "Sync-TerraformShim" {
    BeforeAll {
        $Module = 'terramorph'
        $ModulePath = Join-Path -Path (Split-Path -Path $PSScriptRoot -Parent) -ChildPath $Module

        # Change default installation path for tests
        $env:TERRAMORPH_HOME = Join-Path -Path ([IO.Path]::GetTempPath()) -ChildPath "terramorph"
        $VersionsPath        = Join-Path -Path $env:TERRAMORPH_HOME -ChildPath "versions"
        $ShimsPath           = Join-Path -Path $env:TERRAMORPH_HOME -ChildPath "shims"

        Get-Module $Module | Remove-Module
        Import-Module $ModulePath -Force
    }

    AfterAll {
        Remove-Item -Path $env:TERRAMORPH_HOME -Recurse -Force -ErrorAction SilentlyContinue
    }

    Context "configuration is not set" {
        It "throws out an error" {
            { Sync-TerraformShim } | Should -Throw "Global terraform version not set.*"
        }
    }

    Context "configuration is set" {
        BeforeAll {
            Install-TerraformVersion -Version "1.0.0"

            $ConfigFile = Join-Path -Path $env:TERRAMORPH_HOME -ChildPath "terraform-version"
        }

        AfterAll {
            Get-ChildItem -Path $VersionsPath | Remove-Item -Recurse -Force -ErrorAction SilentlyContinue
        }

        Context "version is not installed" {
            It "throws out an error" {
                "0.0.1" | Out-File -FilePath $ConfigFile -Force

                { Sync-TerraformShim } | Should -Throw "Terraform version 0.0.1 is not installed.*"
            }
        }

        Context "version is installed" {
            It "create a shim targeting the version" {
                "1.0.0" | Out-File -FilePath $ConfigFile -Force

                Sync-TerraformShim

                # We don't test the symlink creation as we simply copy file on windows
                # Instead we test directly the terraform executable
                $TerraformShims = Get-ChildItem -Path $ShimsPath

                $TerraformShims | Should -HaveCount 1

                # Force string, else Powershell will split multiline output in an array
                [string](&"$($TerraformShims[0].FullName)" version) | Should -BeLike "Terraform v1.0.0*"
            }
        }
    }
}