# WifiPasswordGetter
Save all wifi passwords stored on a Windows device into an output txt file. ("wifiPassOutpu.txt")

## Installation
You can run the batch file from any directory, including removable drives. It does not require admin priveledges.

## How it works
```batch
@echo off
echo =================================================== > wifiPassOutput.txt
echo   Network Keys (wifi passwords) stored on %ComputerName% >> wifiPassOutput.txt
echo =================================================== >> wifiPassOutput.txt
echo. >> wifiPassOutput.txt
```