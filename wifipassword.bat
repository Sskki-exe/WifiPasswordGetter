@echo off
echo =================================================== > wifiPassOutput.txt
echo   Network Keys (wifi passwords) stored on %ComputerName% >> wifiPassOutput.txt
echo =================================================== >> wifiPassOutput.txt
echo. >> wifiPassOutput.txt
setlocal EnableDelayedExpansion

netsh wlan show profile | findstr /C:"    All User Profile     : " > a.txt
for /f "delims=" %%a in (a.txt) DO (
set x=%%a
echo   Network: !x:~27! >> wifiPassOutput.txt

netsh wlan show profile "!x:~27!" key=clear | findstr /C:"    Key Content            :" > b.txt || (echo       Key: none >> wifiPassOutput.txt)
for /f "delims=" %%b in (b.txt) DO (
set y=%%b
echo       Key: !y:~28! >> wifiPassOutput.txt
)
echo. >> wifiPassOutput.txt
)
del a.txt
del b.txt
type wifiPassOutput.txt
echo.
pause