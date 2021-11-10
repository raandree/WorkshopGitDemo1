enum CarColor
{
    Black
    White
    Red
}

class Car {
    [string]$Manufacturer
    [string]$Model
    [CarColor]$Color
    [double]$Speed
    hidden [guid]$Id

    #hidden Car() {
    #    $this.Id = New-Guid
    #}

    Car([string]$Manufacturer, [string]$Model, [string]$Color) {
        $this.Id = New-Guid
        $this.Manufacturer = $Manufacturer
        $this.Model = $Model
        $this.Color = $Color
    }

    [void] Accelerate([int]$km) {
        $this.Speed += $km
    }

    [void] Brake([int]$km) {
        $this.Speed -= $km
    }
}

$car1 = [Car]::new('VW', 'Gold', 'Red')
#$car1.Manufacturer = 'VW'
#$car1.Model = 'Golf'
#$car1.Color = 'red'
$car1.Accelerate(50)
$car1.Accelerate(30)

$car1
