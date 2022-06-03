function Register-TerramorphInPath
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [switch] $Persist
    )

    if($Persist)
    {
        # Windows have User-level environment variables
        if($IsWindows)
        {
            $UserPaths = [Environment]::GetEnvironmentVariable('PATH', 'User') -split [IO.Path]::PathSeparator
            if($UserPaths -notcontains $script:Terramorph.Path.Shims)
            {
                $UserPaths += $script:Terramorph.Path.Shims
                [System.Environment]::SetEnvironmentVariable('PATH', ($UserPaths -join [IO.Path]::PathSeparator), 'User')
            }
        }
        else
        {
            $ProfileContent = Get-Content -Path $PROFILE.CurrentUserAllHosts -ErrorAction SilentlyContinue

            if($ProfileContent -notcontains $script:Terramorph.Profile.ScriptLine)
            {
                # Create profile file if it doesn't exists
                if(-not (Test-Path -Path $PROFILE.CurrentUserAllHosts))
                {
                    New-Item -Path $PROFILE.CurrentUserAllHosts -ItemType File -Force | Out-Null
                }

                $ProfileContent += "$($script:Terramorph.Profile.ScriptLine)"
                $ProfileContent | Out-File -FilePath $PROFILE.CurrentUserAllHosts
            }
        }
    }

    if(-not (Test-TerramorphInPath))
    {
        $env:PATH = @($env:PATH, $script:Terramorph.Path.Shims) -join [IO.Path]::PathSeparator
    }
}