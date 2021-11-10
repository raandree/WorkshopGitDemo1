#Install-Module -Name ThreadJob -Force

$jobs = 1..50 | ForEach-Object {
    Start-Job -Name "Test $_" -ScriptBlock { Get-Date; Start-Sleep -Seconds 10 }
}

$jobs = 1..50 | ForEach-Object {
    Start-ThreadJob -Name "Test $_" -ScriptBlock { Get-Date; Start-Sleep -Seconds 10 }
}

$j = Start-ThreadJob -Name dir -ScriptBlock { dir -Path D:\ -Recurse }
while ($j.State -ne 'Completed') {
    Write-Host '.' -NoNewline
    Start-Sleep -Seconds 1
}
$data = $j | Receive-Job