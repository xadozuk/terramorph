# Terramorph

Terraform version manager for PowerShell

## Install

### Install PowerShell module

```powershell
Install-Module -Name terramorph
```

### Configure Terramorph

To add terramorph shim folder into your PATH:

```powershell
Install-Terramorph
```

## Terraform version management

### List version

To list available version:
```powershell
Get-TerraformVersion -All
```

To list installed version:
```powershell
Get-TerraformVersion
```

### Install a version

To install a terraform, specify a specific version:
```powershell
Install-TerraformVersion -Version 1.2.1
```

You can also install the latest version:
```powershell
Install-TerraformVersion -Latest
```

To reinstall terraform, you can add `-Force`:
```powershell
Install-TerraformVersion -Version 1.2.1 -Force
```

### Set default terraform version

```powershell
Set-TerraformVersion -Version 1.2.1
```

To get the current configured version:
```powershell
Get-TerraformVersion -Current
```

**Info:**
If you need to to recreate shim, you can use:
```powershell
Sync-TerraformShim
```

This will recreate the shim based on your current default terraform version.