1..10000 | ForEach-Object {
    if ($_ % 10 -eq 0) {
        Write-Host '.' -NoNewline
    }
    Start-Sleep -Milliseconds 100
} 



$numbers = 1,2,3
$chars = 'a','b','c'

[System.Collections.ArrayList]$result = foreach ($char in $chars) {
    
    foreach ($number in $numbers) {
        #if ($number -eq '2') {
        #    break
        #}
        
        "$char - $number"
    }
}

<#
a - 1
a - 2
...
c - 2
c - 3
#> 



function f1 {
    [CmdletBinding()]
    [OutputType([datetime], ParameterSetName="datetime")]
    [OutputType("string", ParameterSetName="string")]
    param (
        [Parameter(Mandatory, ParameterSetName = 'datetime')]
        [switch]$AsDateTime,

        [Parameter(Mandatory, ParameterSetName = 'string')]
        [switch]$AsString
    )
    
    if ($PSCmdlet.ParameterSetName -eq 'string') {
        (Get-Date).ToString()
    }
    else {
        Get-Date
    }

}

$d1 = f1 -AsDateTime
$d2 = f1 -AsString
