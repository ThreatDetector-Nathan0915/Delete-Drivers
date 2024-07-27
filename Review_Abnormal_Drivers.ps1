# Retrieve all installed drivers
$drivers = Get-WmiObject Win32_PnPSignedDriver

# Select and format driver properties for detailed display
$drivers | Select-Object DeviceName, Manufacturer, DriverVersion, DriverDate, InfName, DriverName, Description, Service, HardwareID | 
Format-Table -Property DeviceName, Manufacturer, DriverVersion, @{Name="DriverDate";Expression={[datetime]::ParseExact($_.DriverDate, "yyyyMMddHHmmss.ffffff-000", $null)}}, InfName, DriverName, Description, Service, HardwareID -AutoSize

# Example: Filter and display only drivers from Microsoft
$msDrivers = $drivers | Where-Object { $_.Manufacturer -eq "Microsoft" }
$msDrivers | Select-Object DeviceName, Manufacturer, DriverVersion, DriverDate, InfName, DriverName, Description, Service, HardwareID | 
Format-Table -Property DeviceName, Manufacturer, DriverVersion, @{Name="DriverDate";Expression={[datetime]::ParseExact($_.DriverDate, "yyyyMMddHHmmss.ffffff-000", $null)}}, InfName, DriverName, Description, Service, HardwareID -AutoSize

# Example: Group by Driver Version
$drivers | Group-Object -Property DriverVersion | ForEach-Object {
    $_.Group | Select-Object DeviceName, Manufacturer, DriverVersion, DriverDate, InfName, DriverName, Description, Service, HardwareID | 
    Format-Table -Property DeviceName, Manufacturer, DriverVersion, @{Name="DriverDate";Expression={[datetime]::ParseExact($_.DriverDate, "yyyyMMddHHmmss.ffffff-000", $null)}}, InfName, DriverName, Description, Service, HardwareID -AutoSize
}

# Example: Export detailed driver information to a CSV file
$drivers | Select-Object DeviceName, Manufacturer, DriverVersion, DriverDate, InfName, DriverName, Description, Service, HardwareID | 
Export-Csv -Path "DriverDetails.csv" -NoTypeInformation
