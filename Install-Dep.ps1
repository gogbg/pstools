param
(
    [Parameter(Mandatory)]
    [string]$ModulePath
)

#Find Module manifest
$moduleFolder = Get-Item -Path $ModulePath
$maduleManifestFile = Join-Path -Path $moduleFolder -ChildPath "$($moduleFolder.BaseName).psm1"
$moduleManifest = Import-PowerShellDataFile -Path $maduleManifestFile -ErrorAction Stop

#Install module requiredmodules
$installPsResourceParams = @{
    RequiredResource = @{}
    Quiet            = $true
    AcceptLicense    = $true
    Scope            = 'CurrentUser'
    TrustRepository  = $true 
}
foreach ($rm in $moduleManifest.RequiredModules)
{
    $installPsResourceParams.RequiredResource.Add($rm.ModuleName, @{
            Version    = $rm.RequiredVersion
            Repository = 'PSGallery'
        })
}
if ($installPsResourceParams.RequiredResource.Count -gt 0)
{
    Install-PSResource @installPsResourceParams -ErrorAction Stop
}