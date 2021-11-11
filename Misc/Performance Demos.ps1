$al = New-Object System.Collections.ArrayList

Measure-Command {
    1..10000 | ForEach-Object { $al.Add("Test$_") | Out-Null }
}

Measure-Command {
    1..10000 | ForEach-Object { $null = $al.Add("Test$_") }
}

Measure-Command {
    foreach ($i in 1..10000) { $null = $al.Add("Test$i") }
}

Measure-Command {
    $al | Where-Object { $_ -like '*555*' }
}

Measure-Command {
    $al.Where({ $_ -like '*555*' })
}