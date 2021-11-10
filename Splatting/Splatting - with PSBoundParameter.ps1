function Get-Computer {
    param (
        [Parameter(Mandatory, ParameterSetName = 'ByName')]
        [string]$ComputerName,

        [Parameter(ParameterSetName = 'ByName')]
        [string]$Domain,

        [Parameter(Mandatory, ParameterSetName = 'ByIp')]
        [string]$IpAddress,

        [Parameter(ParameterSetName = 'ByIp')]
        [ValidateSet('IpV4', 'IpV6')]
        [string]$AddressFamily = 'IpV4',

        [switch]$Force
    )

    $PSBoundParameters.Remove('Force')
    Get-ComputerInternal @PSBoundParameters
    Write-Host "Force is $force" -ForegroundColor Magenta
}

function Get-ComputerInternal {
    param (
        [Parameter(Mandatory, ParameterSetName = 'ByName')]
        [string]$ComputerName,

        [Parameter(ParameterSetName = 'ByName')]
        [string]$Domain = 'contoso.com',

        [Parameter(Mandatory, ParameterSetName = 'ByIp')]
        [string]$IpAddress,

        [Parameter(ParameterSetName = 'ByIp')]
        [ValidateSet('IpV4', 'IpV6')]
        [string]$AddressFamily = 'IpV4'
    )

    $x = $PSBoundParameters
    $x
}

Get-Computer -ComputerName c1 -Domain contoso -Force