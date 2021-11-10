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

    if ($PSCmdlet.ParameterSetName -eq 'ByName') {
        if ($Domain) {
            if ($Force) {
                Get-ComputerInternal -ComputerName $ComputerName -Domain $Domain -Force
            }
            else {
                Get-ComputerInternal -ComputerName $ComputerName -Domain $Domain
            }
            
        }
        else {
            Get-ComputerInternal -ComputerName $ComputerName
        }
        
    }
    else {
        Get-ComputerInternal -IpAddress $IpAddress -AddressFamily $AddressFamily   
    }
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
        [string]$AddressFamily = 'IpV4',

        [switch]$Force
    )

    $x = $PSBoundParameters
    $x
}

Get-Computer -ComputerName c1 -Domain contoso -Force