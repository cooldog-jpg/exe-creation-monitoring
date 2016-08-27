# exe-creation-monitoring
PowerShell automation for monitoring executables being created in a folder. The script must be modified prior to execution.

###Requirements:
-.Net Framework 4

###How to use:
- Edit the script and change the folder paths you want to use.
- Create the log file you included in the script constants.
- Run a command prompt, then type in:
...
PowerShell -noexit -windowstyle hidden -ExecutionPolicy UnRestricted -File %USERPROFILE%\script.ps1
...

This should make the script run in the background. The script can be stopped by killing the PowerShell process.The script only runs when manually executed through the above means, it will not execute on startup (only if you move it to the StartUp folder)
