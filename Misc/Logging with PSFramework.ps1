function f1 {
    f2 -p1 'testarg'
}

function f2 {
    param($p1)
    # Verbose
    Write-PSFMessage -Message "Test Message" -Tag Demo

    # Host
    Write-PSFMessage -Level Host -Message "Message visible to the user"

    # Debug
    Write-PSFMessage -Level Debug -Message "Very well hidden message"

    # Warning
    Write-PSFMessage -Level Warning -Message "Warning Message"

    Does-NotExist
    Write-PSFMessage -Level Critical -Message 'Something went wrong' -ErrorRecord $Error[0]
}

f1
return
# Verbose
Write-PSFMessage -Message "Test Message" -Tag Demo

# Host
Write-PSFMessage -Level Host -Message "Message visible to the user"

# Debug
Write-PSFMessage -Level Debug -Message "Very well hidden message"

# Warning
Write-PSFMessage -Level Warning -Message "Warning Message"

Does-NotExist
Write-PSFMessage -Level Critical -Message 'Something went wrong' -ErrorRecord $Error[0]

Get-PSFMessage
start $env:APPDATA\WindowsPowerShell\PSFramework\Logs

Get-PSFConfigValue -FullName PSFramework.Logging.FileSystem.ErrorLogFileEnabled
Set-PSFConfig -FullName PSFramework.Logging.FileSystem.ErrorLogFileEnabled -Value $true

Get-PSFConfigValue -FullName PSFramework.Logging.FileSystem.LogPath
Set-PSFConfig -FullName PSFramework.Logging.FileSystem.LogPath -Value "$($env:APPDATA)\WindowsPowerShell\PSFramework\Logs", C:\Logs


# For current process only
Set-PSFConfig -FullName PSFramework.Logging.FileSystem.ModernLog -Value $true

# Permanently for all users on this computer
Set-PSFConfig -FullName PSFramework.Logging.FileSystem.ModernLog -Value $true -PassThru | Register-PSFConfig -Scope SystemDefault

Install-PSFLoggingProvider -Name eventlog

$EventLogName = 'DCS-Log'
$EventSourceName = "DCS Powershell Automation"
New-Eventlog -LogName "$EventLogName" -Source "$EventSourceName" -ErrorAction SilentlyContinue 

Set-PSFLoggingProvider -Name eventlog -Enabled $true #TODO: define own event log

$cred = New-Object pscredential('contoso\install', ('Somepass1' | ConvertTo-SecureString -AsPlainText -Force))


Install-PSFLoggingProvider -Name sql

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

Get-PSFLoggingProvider

Write-PSFMessage -Message "Tagged Message" -Tag special, custom, whatever

Write-PSFMessage -Message "Doing something" -Target TestMachine1