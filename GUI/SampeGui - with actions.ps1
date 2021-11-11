#PowerShell does not load the 'PresentationFramework' assembly by default
#[System.AppDomain]::CurrentDomain.GetAssemblies()
#loading the missing assembly
Add-Type -AssemblyName PresentationFramework

$ui = [xml](Get-Content -Path $PSScriptRoot\SampleGui\SampleGui\MainWindow.xaml)
[void]$ui.Window.Attributes.Remove($ui.Window.Attributes.Where({ $_.Name -eq 'x:Class' })[0])
[void]$ui.Window.Attributes.Remove($ui.Window.Attributes.Where({ $_.Name -eq 'mc:Ignorable' })[0])
$reader = [System.Xml.XmlNodeReader]::new($ui)
$window = [System.Windows.Markup.XamlReader]::Load($reader)
$window.ShowDialog()

