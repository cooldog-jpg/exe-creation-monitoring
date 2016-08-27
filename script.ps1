#===============================================#
#   PowerShell Script for extracting binary     #
#   samples for further analysis.               #
#-----------------------------------------------#
#   Developed by: Luis Lopez Miranda            #
#       cooldog_jpg@protonmail.com              #
#===============================================#

#Define constants and retrieve environment variables
$path = $env:appdata 
$filename = "*.exe"
$destination = $env:userprofile
$logfile = $env:userprofile\files.log #Create the file before running the script
$client = $env:computername

# Initialize the Watcher object
$Watcher = New-Object System.IO.FileSystemWatcher 

# Setting properties for the watcher object
$Watcher.Path = $path
$Watcher.Filter = $filename
$Watcher.NotifyFilter = [IO.NotifyFilters]"FileName"
$Watcher.IncludeSubdirectories = $False

# Define the action to be performed after the binary creation
Register-ObjectEvent $Watcher Created -SourceIdentifier FileCreated -Action {
    $name = $Event.SourceEventArgs.Name
    $changeType = $Event.SourceEventArgs.ChangeType
    $timeStamp = $Event.TimeGenerated
    $hash = Get-FileHash "$path\$name" -Algorithm MD5
    $md5 = md5.hash
    Write-Host $client ": The file '$name' was $changeType at $timeStamp" -fore green
    Out-File -FilePath $logfile -Append -InputObject "$client : The file '$name' was $changeType at $timeStamp | MD5: $md5"
    Write-Host "Copying $path\$name to $destination\$client_$name"
    Copy-Item -Path "$path\$name" -Destination "$destination\$client_$name" -Force -Verbose
}

#EOF