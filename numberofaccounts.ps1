### TOTAL USER ACCOUNTS
$TotalADUsers = (Get-ADUser -filter * -ResultSize Unlimited).count

### TOTAL ENABLED USER ACCOUNTS
$TotalADEnabledUsers = (Get-AdUser -filter * |Where {$_.enabled -eq "True"}).count

### TOTAL DISABLED USER ACCOUNTS
$TotalADDisabledUsers = (Get-ADUser -filter * |Where {$_.enabled -ne "False"}).count

### USERS WITH MAILBOXES
$TotalUsersWithMailboxes = (Get-User -RecipientTypeDetails UserMailbox -ResultSize Unlimited).count