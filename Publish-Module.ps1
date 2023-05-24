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
Publish-PSResource -Path $moduleFolder.FullName -ApiKey ($ApiKey | ConvertFrom-SecureString -AsPlainText) -Repository $Repository -ErrorAction Stop