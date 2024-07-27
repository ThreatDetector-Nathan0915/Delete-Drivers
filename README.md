Incompatible Driver Removal Script
This repository contains a PowerShell script designed to identify and forcefully remove specific incompatible drivers from a Windows system. This script is particularly useful for resolving issues with memory protection and enabling secure boot features.

Prerequisites
PowerShell 5.1 or later
Administrator privileges (Run PowerShell as Administrator)
Drivers Targeted
The script targets the following drivers:
lvbflt64.sys (Logitech)
lvrs64.sys (Logitech)
lvuvc64.sys (Logitech)
NewTek_WDM_KS.sys (NewTek Partners LLP)
wdcsam64.sys (Western Digital Technologies)
wdcsam64_prewin8.sys (Western Digital Technologies)
Script Description
The script performs the following steps:

Identify Incompatible Drivers: Uses Get-WmiObject and Get-PnpDevice to locate installed drivers matching the specified file names.
Disable and Stop Services: Attempts to disable and stop services associated with the identified drivers.
Remove Driver Services: Uses sc.exe to delete the service entries.
Uninstall Drivers: Uses pnputil to forcefully uninstall the driver packages.
Remove Driver Entries: Uses WMI to remove driver entries from the system.
