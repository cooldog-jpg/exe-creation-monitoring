#===============================================#
#   PowerShell Script for extracting binary     #
#   samples for further analysis.               #
#-----------------------------------------------#
#   Developed by: Luis Lopez Miranda            #
#       cooldog_jpg@protonmail.com              #
#===============================================#

# Initialize the Watcher object
$Watcher = New-Object System.IO.FileSystemWatcher 

#Define constants and retrieve environment variables
$filename = "*.exe"
$global:Destination_drive = "C:\" # Change this

# Setting properties for the watcher object
$Watcher.Path = $env:appdata # Change this
$Watcher.Filter = $filename
$Watcher.NotifyFilter = [IO.NotifyFilters]"FileName, LastWrite"
$Watcher.IncludeSubdirectories = $False

# Define the action to be performed after the binary creation
Register-ObjectEvent $Watcher Created -SourceIdentifier FileCreated -Action {
	$name = $Event.SourceEventArgs.Name
	$changeType = $Event.SourceEventArgs.ChangeType
	$timeStamp = $Event.TimeGenerated
	
	$client = $env:computername
	$fileLocation = "$env:appdata\$name"
	$destination = "$global:Destination_drive\$client"
	$logfile = "$destination\log.txt" # Change this if you want

	Write-Host "=== New binary detected in $destination ===" -back white -fore black
	
	# Create directory and log file
	if (!(Test-Path $destination)){
		New-Item $destination -itemtype directory
		Out-File -FilePath $logfile -Append -InputObject "New folder and log file created for $client"
	}

	if (!(Test-Path "$destination\log.txt")){
		New-Item "$destination\log.txt" -itemtype file
	}
	
	# Collect hash and sample and copy binary to remote drive
	Try {
		$fp = Get-FileHash $fileLocation
		$hash = $fp.hash
	}
	Catch
	{
		$ErrorMessage = $_.Exception.Message
		$FailedItem = $_.Exception.ItemName
		$hash = $ErrorMessage
	}
	Write-Host $client ": The file $name was $changeType at $timeStamp" -fore green
	Out-File -FilePath $logfile -Append -InputObject "$client : The file '$name' was $changeType at $timeStamp | Hash: $hash"
	Write-Host "Copying $fileLocation to $destination"
	Copy-Item -Path $fileLocation -Destination $destination -Force -Verbose
}

#EOF
