#Import module
Import-Module activedirectory
#Set password for new user 
$password = Read-Host -Prompt "Set Password" -AsSecureString
#Copy user - user01
$userInstance = Get-ADUser -Identity "user01" 
#Create a new user from user01
New-ADUser -SAMAccountName "user02"  -Instance $userInstance -DisplayName "User 02" -Name "My User 02" -UserPrincipalName "user02@domain.local" -AccountPassword $password
#Get AD user details of new user
$oupath = Get-aduser user02
$x = $oupath.DistinguishedName
#Move new user to Accounts OU
Move-ADObject -Identity $x -TargetPath "OU=Accounts,DC=domain,DC=local"


Param (
    
    [Parameter(Mandatory=$True)]
    $givenname,
    [Parameter(Mandatory=$True)]
    $surname,
    
    [Parameter(Mandatory=$True)]    
    $template,
    $password = "Newpass1",
    [switch]$enabled,
    $changepw = $true,
    $ou,
    [switch]$useTemplateOU
)
$name = "$givenname $surname"
$samaccountname = "$($givenname[0])$surname"
$password_ss = ConvertTo-SecureString -String $password -AsPlainText -Force
$template_obj = Get-ADUser -Identity $template
If ($useTemplateOU) {
    $ou = $template_obj.DistinguishedName -replace '^cn=.+?(?<!\\),'
}
$params = @{
    "Instance"=$template_obj
    "Name"=$name
    "DisplayName"=$name
    "GivenName"=$givenname
    "SurName"=$surname
    "AccountPassword"=$password_ss
    "Enabled"=$enabled
    "ChangePasswordAtLogon"=$changepw
}
If ($ou) {
    $params.Add("Path",$ou)
}
New-ADUser @params