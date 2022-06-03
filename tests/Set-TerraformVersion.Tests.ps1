Describe "Set-TerraformVersion" {
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

    Context "version is not installed" {
        It "throws out an error" {
            { Set-TerraformVersion -Version "1.0.0" } | Should -Throw "Terraform version 1.0.0 is not installed.*"
        }
    }

    Context "version is installed" {
        BeforeAll {
            Install-TerraformVersion -Version "1.0.0"
        }

        AfterAll {
            Get-ChildItem -Path $VersionsPath | Remove-Item -Recurse -Force -ErrorAction SilentlyContinue
        }

        It "set the version in the global configuration and create a shim" {
            Mock -ModuleName $Module -CommandName Sync-TerraformShim {}

            $Result = Set-TerraformVersion -Version "1.0.0"

            Should -Invoke Sync-TerraformShim -ModuleName $Module -Times 1

            $Result | Should -Not -BeNullOrEmpty
            $Result.Version | Should -Be "1.0.0"
            $Result.IsDefault | Should -BeTrue

            $ConfigFile = Join-Path -Path $env:TERRAMORPH_HOME -ChildPath "terraform-version"
            $ConfigFile | Should -FileContentMatchExactly "1.0.0"
        }
    }
}