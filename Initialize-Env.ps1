<#
.SYNOPSIS
Configure the local system with commonly required SDLC settings

.DESCRIPTION
Configure the local system with commonly required SDLC settings. Will install commonly used powershell modules.

.EXAMPLE
./Initialize-DevEnvironment

#>
[CmdletBinding(DefaultParameterSetName = 'default')]
param
()

#install PowerShellGet/3
try
{
    $modulesInfo = @{
        Name           = 'PowerShellGet'
        InstallVersion = '3.0.21-beta21'
        DetectVersion  = '3.0.21'
    }
    $moduleExist = Get-Module -FullyQualifiedName @{ModuleName = $modulesInfo['Name']; RequiredVersion = $modulesInfo['DetectVersion'] } -ListAvailable -Refresh -ErrorAction SilentlyContinue
    if (-not $moduleExist)
    {
        Write-Information "Install module: '$($modulesInfo['Name'])/$($modulesInfo['DetectVersion'])' started" -InformationAction Continue
        $installModuleParams = @{
            Name            = $modulesInfo['Name']
            RequiredVersion = $modulesInfo['InstallVersion']
            AllowClobber    = $true
            AllowPrerelease = $true
            Scope           = 'CurrentUser'
            Force           = $true
            Confirm         = $false
            Repository      = 'PSGallery'
        }
        if ($Env:HTTPS_PROXY)
        {
            $installModuleParams.Add('Proxy', $Env:HTTPS_PROXY)
        }
        Install-Module @installModuleParams -ErrorAction Stop
        Import-Module -Name $modulesInfo['Name'] -RequiredVersion $modulesInfo['DetectVersion'] -ErrorAction Stop
        Write-Information "Install module: '$($modulesInfo['Name'])/$($modulesInfo['DetectVersion'])' completed" -InformationAction Continue
    }
    else
    {
        Write-Information "Install module: '$($modulesInfo['Name'])/$($modulesInfo['DetectVersion'])' skipped because it already exists" -InformationAction Continue
    }
}
catch
{
    Write-Error -Message "Install module: '$($modulesInfo['Name'])/$($modulesInfo['DetectVersion'])' failed: $_" -ErrorAction Stop
}

#register PSGallery
$psGalleryRepo = Get-PSResourceRepository -Name PSGallery -ErrorAction SilentlyContinue
if (-not $psGalleryRepo)
{
    Write-Information 'Register PSResource repository: "PSGallery" started' -InformationAction Continue
    Register-PSResourceRepository -PSGallery -Trusted -ErrorAction Stop
    Write-Information 'Register PSResource repository: "PSGallery" completed' -InformationAction Continue
}
else
{
    Write-Information 'Register PSResource repository: "PSGallery" skipped because it already exists' -InformationAction Continue
}
