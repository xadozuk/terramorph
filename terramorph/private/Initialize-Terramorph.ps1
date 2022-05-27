function Initialize-Terramorph
{
    [CmdletBinding()]
    param()

    # Ensure folder structure exists
    foreach($Path in $script:Terramorph.Path.GetEnumerator())
    {
        Write-Debug "Creating path '$($Path.Value)'"
        New-Item -Path $Path.Value -ItemType Directory -Force | Out-Null
    }

    # Hide root folder
    $Root = (Get-Item -Path $script:Terramorph.Path.Root -Force)
    $Root.Attributes = $Root.Attributes -bor "Hidden"

    # PATH management
    if(-not (Test-TerramorphInPath -Scope Process))
    {
        Install-TerramorphInPath -Scope Process

        Write-Warning ("Terramorph is not present in the `$PATH`n" +
                      "It has been automatically added to the current process`n" +
                      "You can add it to your user session by executing the command 'Install-Terramorph'")
    }
}