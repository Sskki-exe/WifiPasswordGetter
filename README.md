# WifiPasswordGetter
Save all wifi passwords stored on a Windows device into an output txt file. ("wifiPassOutput.txt")

## Installation
You can run the batch file from __any__ directory, including removable drives. It does __not__ require admin priveledges.
When you first run the batch file, it will create a file called "wifiPassOutput.txt" as well as display its output in the terminal.

## How it works
1. Disable echo (printing out each command before running them)
```batch
@echo off
```
2. Overwrite "wifiPassOutput.txt" with a header containing the device/computer name, real _fancy_ stuff.⋅⋅
⋅⋅⋅`>` is used to overwrite files while `>>` is used to append (add to the end of) files; this process is called _redirection_.⋅⋅
⋅⋅⋅`echo. >> wifiPassOutput.txt` appends an empty line to "wifiPassOutput.txt"
```batch
echo =================================================== > wifiPassOutput.txt
echo   Network Keys (wifi passwords) stored on %ComputerName% >> wifiPassOutput.txt
echo =================================================== >> wifiPassOutput.txt
echo. >> wifiPassOutput.txt
```
2. Not sure why, but this line allows _for loops_ to work.
```batch
setlocal EnableDelayedExpansion
```
3. `netsh wlan show profile` (Network Shell Wireless Local Area Network show profile) will display the name of each wifi network a computer has previously connected to.
⋅⋅⋅This is piped (the output is used as an input to) into a `findstr` (find string) which filters out lines starting with `"    All User Profile     : "`.
⋅⋅⋅Then this is redirected into a temporary file "a.txt".
```batch
netsh wlan show profile | findstr /C:"    All User Profile     : " > a.txt
```
4. For loops are declared using `for` (duh).
⋅⋅⋅`/f` indicates that the loop will iterate through a file's contents.
⋅⋅⋅`"delims="` means no delimiter (character that separates each string in the file) will be used, meaning the loop will iterate through each line, _"storing"_ it as parameter `%%a` in `(a.txt)`.
```batch
for /f "delims=" %%a in (a.txt) DO (
```
5. Each line will be saved as variable `x` because substrings cannot be made from parameters.
⋅⋅⋅`!x:~27!` is a substring of `x` with the first 27 characters ("    All User Profile     : ") removed so that it is just the network name by itself
⋅⋅⋅`echo   Network: !x:~27! >> wifiPassOutput.txt` appends the word _"Network: "_ and the network name to "wifiPassOutput.txt"
```batch
set x=%%a
echo   Network: !x:~27! >> wifiPassOutput.txt
```
6. `netsh wlan show profile "!x:~27!" key=clear` will display various information about the network, specified by `"!x:~27!"`, stored on the computer.
⋅⋅⋅This is piped into a `findstr` for `"    Key Content            :"` which is the line of information containing the wifi password.
⋅⋅⋅This is redirected into another temporary file "b.txt".
⋅⋅⋅`||` makes the following command run if the previous one encounters an error, eg. there is no line containing the words `"    Key Content            :"`. This usually happens on school networks.
⋅⋅⋅If a network has no _"password"_ append `       Key: none` to "wifiPassOutput.txt".
```batch
netsh wlan show profile "!x:~27!" key=clear | findstr /C:"    Key Content            :" > b.txt || (echo       Key: none >> wifiPassOutput.txt)
```
7. For each line in "b.txt", append the word _"Key: "_ and the wifi password to "wifiPassOutput.txt".⋅⋅
⋅⋅⋅Add an empty line and close the outside for loop
```batch
for /f "delims=" %%b in (b.txt) DO (
set y=%%b
echo       Key: !y:~28! >> wifiPassOutput.txt
)
echo. >> wifiPassOutput.txt
)
```
8. Delete the temporary files "a.txt" and "b.txt".⋅⋅
⋅⋅⋅Print out the contents of "wifiPassOutput.txt".⋅⋅
⋅⋅⋅Print an empty line then pause (create an "Press any key to continue..."). Pressing any key will make the script finish and close.
```batch
del a.txt
del b.txt
type wifiPassOutput.txt
echo.
pause
```