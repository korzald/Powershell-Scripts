#gets all AD users in a security group (specified by -identity) then exports to a CSV

$group = Read-Host -Prompt "Enter the Exact Name of the Security Group"

#adjust fileppath to where you want file
$filepath = "C:\users\user\desktop\Users_in_$group"
Get-ADGroupMember -Identity $group | Select SamAccountName | Export-Csv $filepath.csv -NoTypeInformation