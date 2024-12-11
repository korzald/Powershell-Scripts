#Tools for information

#find all the disabled accounts
Search-ADAccount -PasswordExpired

# find all accounts that are inactive for last 90 days. 
Search-ADAccount -AccountInactive -TimeSpan 90.00:00:00 | FT Name,ObjectClass -A

#add a user by powershell
Add-ADGroupMember -Identity SALES -Members Ian.Richards

# Get a list of all active directory groups.
Get-ADGroup -filter * -properties * |select SAMAccountName, Description

# Get all users in a group
Get-ADGroupMember -Identity "HIPAA group Users" | Select-Object Name