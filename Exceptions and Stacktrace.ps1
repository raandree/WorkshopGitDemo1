Add-Type -TypeDefinition @'
using System;

namespace My
{
    public class DataMissingException : Exception
    {
        public DataMissingException(string missingDataFieldName, Exception ex) : base("", ex)
        {
            MissingDataFieldName = missingDataFieldName;
        }

        public DataMissingException(string missingDataFieldName) : base()
        {
            MissingDataFieldName = missingDataFieldName;
        }
        public string MissingDataFieldName { get; set; }
    }
}
'@

function f1 {
    [CmdletBinding()]
    param ()
    Get-Item -Path C:\Windows
    f2 -p1 123
}

function f2 {
    param([string]$p1)

    'x1'

    if (-not $p1) {
        $ex = [My.DataMissingException]::new('GivenName')
        Write-Error -Exception $ex
    }
}

try {
    Write-Host 'Starting...'
    f1 -ErrorAction Stop
    Write-Host 'finished'
}
catch [System.Management.Automation.ItemNotFoundException] {
    Write-Error 'Not good, please contact your administrator.' -Exception $_.Excetion
}
catch [My.DataMissingException] {
    Write-Error "Please check your inout. The field '$($_.Exception.MissingDataFieldName)' is missing"
}
catch {
    Write-Error 'Something else went wrong'
}
finally {
    Write-Host 'Doing Cleanup'
}