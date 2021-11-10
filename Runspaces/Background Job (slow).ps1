$j = Start-Job -Name dir -ScriptBlock { dir -Path D:\ -Recurse }
while ($j.State -ne 'Completed') {
    Write-Host '.' -NoNewline
    Start-Sleep -Seconds 1
}
$data = $j | Receive-Job