$ProjectPath = "$PSScriptRoot\..\..\.." | Convert-Path
$ProjectName = ((Get-ChildItem -Path $ProjectPath\*\*.psd1).Where{
        ($_.Directory.Name -match 'source|src' -or $_.Directory.Name -eq $_.BaseName) -and
        $(try { Test-ModuleManifest $_.FullName -ErrorAction Stop } catch { $false } )
    }).BaseName

Import-Module $ProjectName

InModuleScope $ProjectName {
    Describe Get-SmallFile {
        #Mock Get-PrivateFunction { $PrivateData }

        Context 'Return values' {
            BeforeEach {
                $return = Get-SmallFile -Path C:\
                $verification = dir -Path C:\ | Where-Object { $_.Length -lt 100KB } | Measure-Object -Property Length -Sum
            }

            It 'Returns a single object' {
                ($return | Measure-Object).Count | Should -Be 1
            }

            It 'Returns the correct number of files' {
                #Assert-MockCalled Get-PrivateFunction -Times 1 -Exactly -Scope It
                $return.FileCount | Should -Be $verification.Count
            }

            It 'Returns the correct size of files' {
                #Assert-MockCalled Get-PrivateFunction -Times 1 -Exactly -Scope It
                $return.Size | Should -Be $verification.Sum
            }
        }
    }
}
