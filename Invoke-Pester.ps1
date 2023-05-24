[CmdletBinding()]
param
(
    [Parameter(Mandatory)]
    [string]$TestPath
)

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
            New-PesterContainer -Path $TestPath
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