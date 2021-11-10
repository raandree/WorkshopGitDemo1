Install-Module -Name SplitPipeline -Force

function f1 {
    Get-Random
}

1..100 | ForEach-Object {
    Start-Sleep -Milliseconds 100
    [pscustomobject]@{
        Time  = Get-Date
        Value = "Test $_"
        Random = f1
    }
}

$data = 1..100 | Split-Pipeline {
    process {
        Start-Sleep -Milliseconds 100
        [pscustomobject]@{
            Time  = Get-Date
            Value = "Test $_"
            Random = f1
        }
        
    }
} -Verbose -Function f1