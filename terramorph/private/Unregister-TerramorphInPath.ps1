function Unregister-TerramorphInPath
{
    [CmdletBinding()]
    param()

    # Windows have User-level environment variables
    if($IsWindows)
    {
        $UserPaths = [System.Collections.ArrayList]([Environment]::GetEnvironmentVariable('PATH', 'User') -split [IO.Path]::PathSeparator)
        if($UserPaths -contains $script:Terramorph.Path.Shims)
        {
            $UserPaths.Remove($script:Terramorph.Path.Shims)
            [System.Environment]::SetEnvironmentVariable('PATH', ($UserPaths -join [IO.Path]::PathSeparator), 'User')
        }
    }
    else
    {
        $ProfileContent = Get-Content -Path $PROFILE.CurrentUserAllHosts -ErrorAction SilentlyContinue

        if($ProfileContent -contains $script:Terramorph.Profile.ScriptLine)
        {
            $ProfileContent = $ProfileContent | Where-Object { $_ -ne $script:Terramorph.Profile.ScriptLine }
            $ProfileContent | Out-File -FilePath $PROFILE.CurrentUserAllHosts
        }
    }
}