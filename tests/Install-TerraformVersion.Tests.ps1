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

Describe "Install-TerraformVersion" {
    Context "Target version is not installed" {
        It "install the specified terraform version" {
            $Result = Install-TerraformVersion -Version "1.0.0"

            $Result | Should -Not -BeNullOrEmpty

            $Result.Version | Should -Be "1.0.0"
            $Result.Installed | Should -BeTrue

            Get-ChildItem -Path (Join-Path -Path $VersionsPath -ChildPath "1.0.0")  | Should -Not -HaveCount 0
        }
    }

    Context "Target version is already installed" {
        BeforeEach {
            $Version = [Version]"1.0.0"
            $V1Path  = Join-Path -Path $VersionsPath -ChildPath $Version

            New-Item -Path $V1Path -ItemType Directory -Force | Out-Null
        }

        AfterEach {
            Remove-Item -Path $V1Path -Recurse -Force -ErrorAction SilentlyContinue
        }

        It "does not override already installed version by default" {
            $Result = Install-TerraformVersion -Version $Version

            $Result | Should -Not -BeNullOrEmpty

            $Result.Version | Should -Be $Version
            $Result.Installed | Should -BeFalse
            $Result.Reason | Should -Be "Already installed"
        }

        It "overrides installed version when using -Force" {
            $Result = Install-TerraformVersion -Version $Version -Force

            $Result | Should -Not -BeNullOrEmpty

            $Result.Version | Should -Be $Version
            $Result.Installed | Should -BeTrue

            Get-ChildItem -Path $V1Path | Should -Not -HaveCount 0
        }
    }
}