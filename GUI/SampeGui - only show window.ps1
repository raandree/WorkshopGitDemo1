function Update-Gui {
    $window.Dispatcher.Invoke([System.Windows.Threading.DispatcherPriority]::Background, [action]{})
}

#PowerShell does not load the 'PresentationFramework' assembly by default
#[System.AppDomain]::CurrentDomain.GetAssemblies()
#loading the missing assembly
Add-Type -AssemblyName PresentationFramework

$ui = [xml](Get-Content -Path $PSScriptRoot\SampleGui\SampleGui\MainWindow.xaml)
[void]$ui.Window.Attributes.Remove($ui.Window.Attributes.Where({ $_.Name -eq 'x:Class' })[0])
[void]$ui.Window.Attributes.Remove($ui.Window.Attributes.Where({ $_.Name -eq 'mc:Ignorable' })[0])
$reader = [System.Xml.XmlNodeReader]::new($ui)
$window = [System.Windows.Markup.XamlReader]::Load($reader)

$btnGo = $window.FindName('btnGo')
$lstFiles = $window.FindName('lstFiles')
$txtDirectory = $window.FindName('txtDirectory')
$btnGo.Add_Click({
    $files = dir -Path $txtDirectory.Text
    foreach ($file in $files) {
        Start-Sleep -Seconds 1
        $lstFiles.AddChild($file.FullName)
        Update-Gui
    }
})

$window.ShowDialog()

