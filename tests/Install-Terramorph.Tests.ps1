Describe "Install-Terramorph" {
    BeforeAll {
        $Module = 'terramorph'
        $ModulePath = Join-Path -Path (Split-Path -Path $PSScriptRoot -Parent) -ChildPath $Module

        # Change default installation path for tests
        $env:TERRAMORPH_HOME = Join-Path -Path ([IO.Path]::GetTempPath()) -ChildPath "terramorph"
        $ShimsPath           = Join-Path -Path $env:TERRAMORPH_HOME -ChildPath "shims"

        $NeedCleanup = $env:PATH -notlike "*$ShimsPath*"

        Get-Module $Module | Remove-Module
        Import-Module $ModulePath -Force
    }

    AfterAll {
        Remove-Item -Path $env:TERRAMORPH_HOME -Recurse -Force -ErrorAction SilentlyContinue
    }

    It "add terramorph shims folder to PATH in User scope and current process" {
        Install-Terramorph

        $CurrentProcessPaths = $env:PATH -split [IO.Path]::PathSeparator
        $CurrentProcessPaths | Should -Contain $ShimsPath

        $PowerShellExecutable = (Get-Process -Id $PID).Path
        $NewProcessPaths = (&$PowerShellExecutable { $env:PATH }) -split [IO.Path]::PathSeparator
        $NewProcessPaths | Should -Contain $ShimsPath

        if($NeedCleanup)
        {
            InModuleScope -Module $Module -ScriptBlock {
                Unregister-TerramorphInPath
            }
        }
    }
}