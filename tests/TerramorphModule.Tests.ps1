BeforeAll {
    $Module = 'terramorph'
    $ModulePath = Join-Path -Path (Split-Path -Path $PSScriptRoot -Parent) -ChildPath $Module
}

Describe "PowerShell Module Tests" {
    It "has a root module" {
        (Join-Path -Path $ModulePath -ChildPath "$Module.psm1") | Should -Exist
    }

    It "has a manisfest file" {
        (Join-Path -Path $ModulePath -ChildPath "$Module.psd1") | Should -Exist
    }

    It "is importable" {
        { Import-Module $ModulePath -Force -ErrorAction Stop } | Should -Not -Throw
    }
}