# Invoke-Command -ComputerName 172.20.1.25 -ScriptBlock

# gets each user in a group
Get-ADGroupMember -Identity "Support Team" | ft
#same as above but more properties and better readablity. 
Get-ADGroupMember -Identity "Support Team" | Get-ADUser -Properties DisplayName,EmailAddress | Select Name,DisplayName,EmailAddress,SAMAccountName
#expands any groups in the list
Get-ADGroupMember -Identity "Mapped Drives - Drug Specialist" -Recursive | ft

#lists out all the empty groups ie. No users
get-adgroup -Properties Members -Filter *|where {$_.members.count -eq 0}

#get a list of all gps By Displayname. 
Get-GPO -All -Domain "westtexasretina.com" | Select DisplayName