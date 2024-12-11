#gets all software on local pc and exports info to a CSV file

Get-ItemProperty HKLM:\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall\* | Select-Object DisplayName, DisplayVersion, Publisher, InstallDate | Sort-Object DisplayName | Export-Csv C:\Users\username\Desktop\PC_Programs.csv