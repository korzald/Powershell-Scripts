### TOTAL NUMBER OF GROUP ACCOUNTS
$TotalADGroups = (Get-ADGroup -filter *).count

### TOTAL NUMBER OF EMPTY GROUPS
$EmptyGroups = (Get-ADGroup -Filter * -Properties Members | where {-not $_.members}).count
### TOTAL NUMBER OF DISTRIBUTION GROUPS
$TotalDistributionGroup = (Get-DistributionGroup -resultsize unlimited -filter *).count
### TOTAL NUMBER OF SECURITY GROUPS
$TotalADSecurityGroups = (Get-ADGroup -filter {GroupCategory -eq "security"}).count 
### TOTAL NUMBER OF DYNAMIC GROUPS
$TotalDynamicDistributionGroup = (Get-DynamicDistributionGroup -resultsize unlimited -filter *).count
### TOTAL NUMBER OF DOMAIN LOCAL
$TotalADDomainLocalGroups = (Get-ADGroup -filter {GroupScope -eq "DomainLocal"}).count
### TOTAL NUMBER OF GLOBAL
$TotalADUniversalGroups = (Get-ADGroup -filter {GroupScope -eq "Global"}).count
### TOTAL NUMBER OF UNIVERSAL
$TotalADUniversalGroups = (Get-ADGroup -filter {GroupScope -eq "Universal" }).count
### TOTAL NUMBER OF CONTACTS
$TotalContactsUsers = (Get-MailContact -filter *).count
### TOTAL NUMBER OF MAIL ENABLED ACCOUNTS
$TotalMailAccounts = (Get-Mailbox -resultsize unlimited).count
### TOTAL NUMBER OF USERS WITH MAILBOXES
$TotalUserMailAccounts = (Get-Recipient -RecipientTypeDetails usermailbox -ResultSize Unlimited).count
### TOTAL NUMBER OF ROOM MAILBOXES
(Get-Mailbox -ResultSize unlimited -Filter {(RecipientTypeDetails -eq 'RoomMailbox')}).count
### TOTAL NUMBER OF SHARED MAILBOXES
$TotalSharedMailboxAccounts = (Get-Recipient -RecipientTypeDetails sharedmailbox -ResultSize Unlimited).count
### TOTAL NUMBER OF Disconnected mailboxes
$dbs = Get-MailboxDatabase
$TotalDisconnectedMailboxes = ($dbs | foreach {Get-MailboxStatistics -Database $_.DistinguishedName} | where {$_.DisconnectReason -eq "SoftDeleted"}).count