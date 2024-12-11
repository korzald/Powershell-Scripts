#get what software is installed.

$computer_list = Get-Content c:\temp\test_list.txt


foreach ($currentItem in $computer_list){
#Change name to be what your looking for.
    Get-WmiObject -Class Win32_Product -ComputerName $currentItem | Select-Object -Property PSComputerName, Name, Version, InstallDate | Where-Object { $_.name -like "*Allscripts*"} 

}






