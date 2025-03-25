# Basic script to test the execution of a PowerShell script

Write-Host "----------------------------------------
This is the Kitchen Sink Test script
Author: Liam Osler
Date: 2025-03-25
"

Write-Host "----------------------------------------
Testing Network Connection:"

Test-Connection -ComputerName google.com -Count 1

Write-Host "----------------------------------------
Testing Disk Space"

Get-WmiObject Win32_LogicalDisk -Filter "DriveType=3" | Select-Object DeviceID, @{Name="FreeSpace (GB)";Expression={[math]::Round($_.FreeSpace / 1GB, 2)}}, @{Name="Size (GB)";Expression={[math]::Round($_.Size / 1GB, 2)}}

Write-Host "----------------------------------------
Testing CPU Usage"

Get-WmiObject Win32_Processor | Select-Object Name, LoadPercentage

Write-Host "----------------------------------------
Testing Memory Usage"

Get-WmiObject Win32_OperatingSystem | Select-Object TotalVisibleMemorySize, FreePhysicalMemory, @{Name="FreeMemory (GB)";Expression={[math]::Round($_.FreePhysicalMemory / 1GB, 2)}}