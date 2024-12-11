$computer_list = Get-Content c:\Downloads\listing.txt


foreach ($currentItem in $computer_list){

    Invoke-Command -ComputerName $currentItem -ScriptBlock { Set-ItemProperty -Path HKLM:\SOFTWARE\WOW6432Node\CompuSense\ntierHealth\StandardSettings -Name "Application Server" -Value allscripts03 } -Credential westtexasretina\administrator

} 