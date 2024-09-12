@{
    TestResult = @{
        Enabled      = $true
        OutputFormat = 'JUnitXml'
        OutputPath   = 'pester-Tests.xml'
    }
    Run = @{
        TestPaths = @(
            './tests/sa.Tests.ps1',
            './tests/webapp.Tests.ps1'
        )
    }
}