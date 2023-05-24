param
(
    [Parameter(Mandatory)]
    [string]$ModulePath,

    [Parameter(Mandatory)]
    [string]$Repository,

    [Parameter(Mandatory)]
    [securestring]$ApiKey
)

#Find Module manifest
$moduleFolder = Get-Item -Path $ModulePath
Publish-Module -Path $moduleFolder.FullName -NuGetApiKey ($ApiKey | ConvertFrom-SecureString -AsPlainText) -Force -Repository $Repository -ErrorAction Stop