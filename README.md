# Driver Removal Script

This repository contains a PowerShell script to find and remove specific drivers from a Windows system. The script searches for specified driver files and attempts to remove them forcefully.

## Target Drivers

The script targets the following driver files:
- `lvbflt64.sys`
- `lvrs64.sys`
- `lvuvc64.sys`
- `NewTek_WDM_KS.sys`
- `wdcsam64.sys`
- `wdcsam64_prewin8.sys`

## Usage

### Prerequisites

- A Windows machine
- Administrator privileges to remove drivers

### Script Overview

The script includes two main functions:
1. `Find-Drivers`: Searches for the specified drivers using `Get-PnpDevice` and `Get-WmiObject`.
2. `Remove-Drivers`: Removes the found drivers using `pnputil` and `sc.exe`.

### Running the Script

Open PowerShell as an Administrator and run the following script:
