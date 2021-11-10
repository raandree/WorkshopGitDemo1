#Splatting helps keep command lines short

Set-PSFLoggingProvider -Name 'sql' -InstanceName 'MyTask' -SqlServer 'DSCCASQL01.contoso.com' -Database 'LoggingDB' -Table 'Logs' -Enabled $true -Credential $cred

$paramSetPSFLoggingProvider = @{
    Name         = 'sql'
    #InstanceName = 'MyTask'
    SqlServer    = 'DSCCASQL01.contoso.com'
    Database     = 'LoggingDB'
    Table        = 'Logs'
    Enabled      = $true
    Credential   = $cred
}
Set-PSFLoggingProvider @paramSetPSFLoggingProvider


