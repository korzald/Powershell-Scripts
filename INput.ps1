$name = Read-Host -Prompt "Please enter your name"
Write-Output "Congratulations $name! You have written your first code with PowerShell!"

#function Check_Program_Installed( $programName ) {
#$wmi_check = (Get-WMIObject -Query "SELECT * FROM Win32_Product Where Name Like '%$programName%'").Length -gt 0
#return $wmi_check;
#}
 
#Check_Program_Installed("Microsoft SQL")