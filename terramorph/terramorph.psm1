#requires -Version 7

$Public = @(Get-ChildItem -Path "$PSScriptRoot\public\*.ps1" -Recurse -ErrorAction SilentlyContinue)
$Private = @(Get-ChildItem -Path "$PSScriptRoot\private\*.ps1" -Recurse -ErrorAction SilentlyContinue)

foreach($import in @($Private + $Public))
{
    try 
    {
        . $import.FullName
    }
    catch
    {
        Write-Error -Message "Failed to import function $($import.FullName): $_"
    }
}

Export-ModuleMember -Function @($Public.Basename + $Private.Basename)

# Bootstrap
try
{
    Initialize-Terramorph
}
catch
{
    Write-Error "Unable to initialize terramorph: $_"
}