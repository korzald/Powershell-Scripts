#Lists out users from an OU and the groups they belong to. 

Import-Module ActiveDirectory
Get-ADUser -SearchBase "OU=OST,DC=westtexasretina,DC=com" -Filter * | foreach-object {
write-host "User:" $_.Name -foreground green
    Get-ADPrincipalGroupMembership $_.SamAccountName | foreach-object {
        write-host "Member Of:" $_.name
    }
}