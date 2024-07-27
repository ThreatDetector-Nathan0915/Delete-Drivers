# Define the list of driver files to search for and remove
$targetDrivers = @(
    "lvbflt64.sys",
    "lvrs64.sys",
    "lvuvc64.sys",
    "NewTek_WDM_KS.sys",
    "wdcsam64.sys",
    "wdcsam64_prewin8.sys"
)

# Function to find drivers using Get-PnpDevice and Get-WmiObject
function Find-Drivers {
    param (
        [string[]]$driverNames
    )

    $problematicDrivers = @()

    # Search using Get-WmiObject
    $wmiDrivers = Get-WmiObject Win32_PnPSignedDriver | Select-Object DeviceName, Manufacturer, DriverVersion, DriverDate, InfName, DriverName
    foreach ($driver in $wmiDrivers) {
        if ($driverNames -contains ([System.IO.Path]::GetFileName($driver.InfName)) -or
            $driverNames -contains ([System.IO.Path]::GetFileName($driver.DriverName))) {
            $problematicDrivers += $driver
        }
    }

    # Search using Get-PnpDevice
    $pnpDevices = Get-PnpDevice -PresentOnly | Select-Object InstanceId, FriendlyName, Class, ClassGuid, Manufacturer, DriverVersion, Inf
    foreach ($device in $pnpDevices) {
        if ($driverNames -contains ([System.IO.Path]::GetFileName($device.Inf))) {
            $problematicDrivers += $device
        }
    }

    return $problematicDrivers
}

# Function to forcefully remove drivers using pnputil and sc.exe
function Remove-Drivers {
    param (
        [array]$drivers
    )

    foreach ($driver in $drivers) {
        Write-Host "Attempting to remove driver: $($driver.DeviceName) - $($driver.InfName)"

        try {
            # Disable the service before removing it
            Set-Service -Name $driver.DriverName -StartupType Disabled -ErrorAction SilentlyContinue
            Stop-Service -Name $driver.DriverName -Force -ErrorAction SilentlyContinue

            # Use sc.exe to delete the service
            sc.exe delete $driver.DriverName

            # Use pnputil to delete the driver package
            pnputil /delete-driver $driver.InfName /uninstall /force

            # Remove the driver using WMI
            Get-WmiObject Win32_PnPSignedDriver | Where-Object { $_.InfName -eq $driver.InfName } | Remove-WmiObject -ErrorAction SilentlyContinue

            Write-Host "Driver $($driver.DeviceName) removed successfully."
        } catch {
            Write-Host "Failed to remove driver: $($driver.DeviceName). Error: $_"
        }
    }
}

# Find the target drivers
$foundDrivers = Find-Drivers -driverNames $targetDrivers

# Display the details of the target drivers
if ($foundDrivers.Count -gt 0) {
    Write-Host "Target drivers found on this device:"
    $foundDrivers | Format-Table -AutoSize

    # Remove the target drivers
    Remove-Drivers -drivers $foundDrivers
} else {
    Write-Host "No target drivers found on this device."
}
