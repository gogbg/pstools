[CmdletBinding()]
param
(
    [Parameter(Mandatory)]
    [string]$TestLocation
)

#initialize dev environment
$initializeDevEnvScript = Join-Path $PSScriptRoot -ChildPath 'Initialize-DevEnvironment.ps1'
& $initializeDevEnvScript

#install dependencies
Install-PSResource -RequiredResource @{
    Pester = @{
        Version    = '5.4.1.0'
        Repository = 'PSGallery'
    }
} -Quiet -AcceptLicense -Scope CurrentUser -TrustRepository -ErrorAction Stop

#invoke tests
$pesterConfig = New-PesterConfiguration -Hashtable @{
    Run          = @{
        Container = @(
            New-PesterContainer -Path $TestLocation
        )
    }
    TestResult   = @{
        Enabled      = $true
        OutputFormat = 'NUnitXml'
    }
    Output       = @{
        Verbosity           = 'Detailed'
        StackTraceVerbosity = 'None'
    }
    CodeCoverage = @{
        Enabled = $true
    }
}
Invoke-Pester -Configuration $pesterConfig