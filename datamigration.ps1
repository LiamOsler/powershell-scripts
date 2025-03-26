#Super Cool Data Migration Tool (Ingest)
#Author: Liam Osler
#Date: 2025-03-26
#Version: 1.0
#Description: This script migrates data from one location to another

#Clear the screen
Clear-Host

#Write-Host
Write-Host "----------------------------------------"
Write-Host "Data Migration Tool by Liam Osler"
Write-Host "Step 1: User Data Ingest Tool"
Write-Host "Place this tool in the root of a removable drive"
Write-Host "Run this script to copy user data to the removable drive"
Write-Host "When data is copied, eject drive and run Step 2"
Write-Host "----------------------------------------"

#Pre-flight checks:
#Check if the script is running with administrative privileges
if (-NOT ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Write-Host "Please run this script as an administrator."
    Exit
}

#Data folder erasure warning:
Write-Host "WARNING: This script will erase the contents of the 'Data' folder on the removable drive."
Write-Host "Make sure you have backed up any important data before proceeding."
Write-Host "Press any key to continue, or CTRL+C to exit."

#Wait for user input
$null = $Host.UI.RawUI.ReadKey('NoEcho,IncludeKeyDown');

Write-Host "Erasing 'Data' folder... Please wait."
#Remove all files and folders in the 'Data' folder
Remove-Item -Path ".\Data" -Recurse -Force

#Create a new 'Data' folder
New-Item -Path ".\Data" -ItemType Directory | Out-Null

Write-Host "Data folder erased successfully."
Write-Host "----------------------------------------"

#Get the location of the data migration tool
$scriptPath = $MyInvocation.MyCommand.Path
Write-Host "Script Path: $scriptPath"

#Get the user's profile folder
$userProfile = $env:USERPROFILE
Write-Host "User Profile Folder: $userProfile"

#Display the size of the user's profile folder
$profileSize = Get-ChildItem -Path $userProfile -Recurse | Measure-Object -Property Length -Sum
Write-Host "User Profile Size: $($profileSize.Sum / 1MB) MB"

#Check the available space on the removable drive
$driveLetter = (Get-WmiObject -Class Win32_Volume | Where-Object { $_.DriveLetter -ne $null }).DriveLetter
$driveSize = Get-WmiObject Win32_LogicalDisk | Where-Object { $_.DeviceID -eq $driveLetter } | Select-Object -ExpandProperty Size
$driveFreeSpace = Get-WmiObject Win32_LogicalDisk | Where-Object { $_.DeviceID -eq $driveLetter } | Select-Object -ExpandProperty FreeSpace

Write-Host "Removable Drive: $driveLetter"
Write-Host "Drive Size: $($driveSize / 1GB) GB"
Write-Host "Free Space: $($driveFreeSpace / 1GB) GB"

#Check if there is enough space on the removable drive
if ($profileSize.Sum -gt $driveFreeSpace) {
    Write-Host "Not enough space on the removable drive. Please free up space and try again."
    Exit
}else{
    Write-Host "Enough space available on the removable drive."
}

#Count the number of files and folders in the user's profile folder
$profileItemCount = (Get-ChildItem -Path $userProfile -Recurse | Measure-Object).Count
Write-Host "Number of items in user profile: $profileItemCount"

#Copy user data to the 'Data' folder on the removable drive
# Write-Host "Copying user data to the 'Data' folder... Please wait."
# Copy-Item -Path $userProfile -Destination ".\Data" -Recurse -Force

# Write-Host "User data copied successfully."

