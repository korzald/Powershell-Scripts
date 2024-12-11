Copy-Item -Path "c:\scans" -Destination $targetPathAndFile
Copy-Item -Path "c:\users\$username\AppData\Local\Google\Chrome\User Data\Default" -Destination $targetPathAndFile



    #If destination folder doesn't exist
    if (!(Test-Path $targetfolder -PathType Container)) {
        #Create destination folder
        New-Item -Path $targetfolder -ItemType Directory -Force
    }

Get-WmiObject -class Win32_MappedLogicalDisk | select name, providername, mappedto