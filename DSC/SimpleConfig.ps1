configuration Test1 {
    param(
        [Parameter(Mandatory)]
        [string]$Gateway
    )

    Import-DscResource -ModuleName NetworkingDsc
    
    node localhost {
        WindowsFeature XpsViwer {
            Name = 'XPS-Viewer'
            Ensure = 'Absent'
        }

        File TestFile1 {
            DestinationPath = 'C:\TestFile1.txt'
            Ensure = 'Present'
            Contents = '123'
        }

        Service vds {
            Name = 'vds'
            StartupType = 'Automatic'
            State = 'Running'
        }

        IPAddress ipconfig {
            InterfaceAlias = 'DscWorkshop 0'
            IPAddress = '192.168.111.80'
            AddressFamily = 'IPv4'
        }

        DefaultGatewayAddress gw {
            InterfaceAlias = 'DscWorkshop 0'
            Address = $Gateway
            AddressFamily = 'IPv4'
        }
    }
}

Test1 -OutputPath C:\DSC -Verbose -Gateway 192.168.111.50

Start-DscConfiguration -Path C:\DSC -Wait -Verbose -Force
