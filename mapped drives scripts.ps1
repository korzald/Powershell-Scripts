Get-WmiObject Win32_MappedLogicalDisk | select name, providername

$computername = Get-Content 'I:\NodeList\SNL.txt'
$CSVpath = "C:\MSI\Mps.csv"

remove-item $CSVpath 

$Report = @() 

foreach ($computer in $computername) {
Write-host $computer 

$colDrives = Get-WmiObject Win32_MappedLogicalDisk -ComputerName $computer 

foreach ($objDrive in $colDrives) { 
    # For each mapped drive - build a hash containing information
    $hash = @{ 
        ComputerName       = $computer
        MappedLocation     = $objDrive.ProviderName 
        DriveLetter   = $objDrive.DeviceId 
    } 
    # Add the hash to a new object
    $objDriveInfo = new-object PSObject -Property $hash
    # Store our new object within the report array
    $Report += $objDriveInfo
} 

# Export our report array to CSV and store as our dynamic file name
$Report | Export-Csv -NoType $CSVpath #$filenamestring

}