function Get-TerraformExecutableName
{
    [CmdletBinding()]
    [OutputType([String])]
    param()

    switch($true)
    {
        { $IsWindows }            { "terraform.exe" }
        { $IsLinux -or $IsMacOS } { "terraform" }

        default { throw "Unable to determine terraform executable name" }
    }

}