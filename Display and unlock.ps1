#Get locked user accounts
#Need to ask for creditials after connecting to DC
#Invoke-Command -ComputerName COMPUTER -ScriptBlock { COMMAND } -credential USERNAME

## Will display any locked user accounts

#Search-ADAccount -LockedOut | FT Name, ObjectClass -A

-Credential westtexasretinal\administrator

# Will unlock any locked user accounts

#Search-ADAccount -LockedOut | Unlock-ADAccount

Invoke-Command -ComputerName 172.20.1.25 -ScriptBlock { Search-ADAccount -LockedOut | FT Name, ObjectClass -A $response = Read-Hosts -Prompt 'Do you want to clear the names?[y or n]' switch ($response) { 'y' { Search-ADAccount -LockedOut | Unlock-ADAccount } 'n' { return }}} -Credential westtexasretinal\administrator