Describe "Get-TerraformVersion" {
    BeforeAll {
        $Module = 'terramorph'
        $ModulePath = Join-Path -Path (Split-Path -Path $PSScriptRoot -Parent) -ChildPath $Module

        # Change default installation path for tests
        $env:TERRAMORPH_HOME = Join-Path -Path ([IO.Path]::GetTempPath()) -ChildPath "terramorph"
        $VersionsPath = Join-Path -Path $env:TERRAMORPH_HOME -ChildPath "versions"

        Get-Module $Module | Remove-Module
        Import-Module $ModulePath -Force
    }

    AfterAll {
        Remove-Item -Path $env:TERRAMORPH_HOME -Recurse -Force -ErrorAction SilentlyContinue
    }

    It "return a list of available versions when -All is used" {
        $Result = Get-TerraformVersion -All

        $Result | Should -Not -HaveCount 0
        $Result.Version | Should -Contain "1.0.0"
    }

    Context "when no version is installed" {
        It "returns an empty list of installed version" {
            $Result = Get-TerraformVersion

            $Result | Should -HaveCount 0
        }
    }

    Context "with some versions installed" {
        BeforeAll {
            Install-TerraformVersion -Version 1.0.0
            Install-TerraformVersion -Version 1.1.0
        }

        AfterAll {
            Get-ChildItem -Path $VersionsPath | Remove-Item -Recurse -Force -ErrorAction SilentlyContinue
        }

        It "returns a list of installed version order by descending order" {
            $Result = Get-TerraformVersion

            $Result | Should -HaveCount 2
            $Result[0].Version | Should -Be "1.1.0"
            $Result[0].IsDefault | Should -BeFalse

            $Result[1].Version | Should -Be "1.0.0"
            $Result[1].IsDefault | Should -BeFalse
        }

        Context "a default version is not yet configured" {
            It "show an empty list with -Current" {
                $Result = Get-TerraformVersion -Current

                $Result | Should -HaveCount 0
            }
        }

        Context "a default version is configured" {
            BeforeAll {
                Set-TerraformVersion -Version "1.0.0"
            }

            It "show the configuration status" {
                $Result = Get-TerraformVersion

                $Result | Should -HaveCount 2
                $Result[0].Version | Should -Be "1.1.0"
                $Result[0].IsDefault | Should -BeFalse

                $Result[1].Version | Should -Be "1.0.0"
                $Result[1].IsDefault | Should -BeTrue
            }

            It "show the current version with -Current" {
                $Result = Get-TerraformVersion -Current

                $Result | Should -HaveCount 1
                $Result[0].Version | Should -Be "1.0.0"
            }
        }
    }
}