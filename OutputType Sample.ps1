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
