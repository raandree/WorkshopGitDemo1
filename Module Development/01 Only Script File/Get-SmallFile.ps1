<#
        .SYNOPSIS
        Finds small files in a specified folder

        .DESCRIPTION
        This function finds files smaller than a specific size in a specified folder.
        You'll get a few statistics on every folder examined.
        You may enter the folder path directly or through the pipeline (see Get-Help).
        Inaccessible folders are skipped without notification.

        .PARAMETER Path
        The folder path you want to examine.

        .PARAMETER MaxSize
        The maximum file size in byte to examine. The functions ignores files larger than that size.

        .EXAMPLE
        Get-SmallFile -MaxSize 100000 -Path C:\Windows

        .EXAMPLE
        'C:\Windows' | Get-SmallFile -MaxSize 100000

        .EXAMPLE
        Get-Item -Path C:\Windows | Get-SmallFile -MaxSize 100000

        .EXAMPLE
        Get-ChildItem -Directory -Path C:\Windows | Get-SmallFile -MaxSize 100000

        .NOTES
        I hope that was fun.
    #>
    function Get-SmallFile {
    param(
        [Parameter(Mandatory, ValueFromPipeline, HelpMessage = "Enter computer names separated by commas.")]
        [ValidateScript({ Test-Path -Path $_ -PathType Container })]
        [string[]]$Path,
        
        [ValidateRange(1, [long]::MaxValue)]
        [long]$MaxSize = 100KB,

        [switch]$AddSummary
    )

    begin {
        Write-Host 'Beginning...'
        $summary = [pscustomobject]@{
            Path      = 'Summary'
            FileCount = 0
            FileSizeSum      = 0
            MaxSize   = $MaxSize
        }
    }

    process {
        $Path = $Path | Resolve-Path
        foreach ($p in $Path) {
            $result = Get-ChildItem -Path $p -File | 
                Where-Object Length -LT $MaxSize | 
                Measure-Object -Property Length -Sum -Average

            [pscustomobject]@{
                Path        = $p
                MaxSize     = $MaxSize
                FileSizeSum = $result.Sum
                AverageSize = [System.Math]::Round($result.Average, 2)
                FileCount = $result.Count
            }

            $summary.FileCount += $result.Count
            $summary.MaxSize += $result.Sum
        }
    }

    end {
        if ($AddSummary) {
            $summary
        }
        Write-Host '...finished'
    }
}

Get-SmallFile

return
'c:\p*', 'c:\w*', 'd:\' | Get-SmallFile
Get-SmallFile -Path c:\p*, c:\w*, d:\