Describe "Install-Terramorph" {
    BeforeAll {
        $Module = 'terramorph'
        $ModulePath = Join-Path -Path (Split-Path -Path $PSScriptRoot -Parent) -ChildPath $Module

        # Change default installation path for tests
        $env:TERRAMORPH_HOME = Join-Path -Path ([IO.Path]::GetTempPath()) -ChildPath "terramorph"
        $ShimsPath           = Join-Path -Path $env:TERRAMORPH_HOME -ChildPath "shims"

        Get-Module $Module | Remove-Module
        Import-Module $ModulePath -Force
    }

    AfterAll {
        Remove-Item -Path $env:TERRAMORPH_HOME -Recurse -Force -ErrorAction SilentlyContinue
    }

    It "add terramorph shims folder to PATH in User scope and current process" {
        Install-Terramorph

        $UserPaths = [System.Collections.ArrayList]([Environment]::GetEnvironmentVariable('PATH', 'User') -split [IO.Path]::PathSeparator)
        $UserPaths | Should -Contain $ShimsPath

        $ProcessPaths = $env:PATH -split [IO.Path]::PathSeparator
        $ProcessPaths | Should -Contain $ShimsPath


        $UserPaths.Remove($ShimsPath)
        [Environment]::SetEnvironmentVariable('PATH', ($CleanupPaths -join [IO.Path]::PathSeparator), 'User')
    }
}