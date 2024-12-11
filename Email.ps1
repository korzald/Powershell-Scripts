#Email functions
$body = Get-wmiobject -Class Win32_LocalTime -ComputerName NTRCPDC2, WTRCDC2, WTRCDC1, 172.20.1.6, 172.20.1.28, 172.20.1.27, 172.20.1.23, 172.20.1.20, 172.20.3.8, 172.20.2.25, 172.20.2.35 | 
    ft @{Label="DC & Servers"; Expression={$_.PSComputerName}; align="center"}, @{Label="Hour"; Expression={$_.hour}; align="center"}, 
    @{Label="Minute"; Expression={$_.Minute}; align="center"}, @{Label="Second"; Expression={$_.second}; align="center"} -AutoSize

# Get the credential
$credential = Get-Credential
## Define the Send-MailMessage parameters
$mailParams = @{
    SmtpServer                 = 'WIN-ISI7CF6KJQO.westtexasretina.com'
    Port                       = '587' 
    UseSSL                     = $true
    Credential                 = $credential
    From                       = 'bran team <brane.team@branesystems.com>'
    To                         = 'Tyrone Conry <Tyrone.Conry@wtxretina.com>', 'Dale.Massey@branesystems.com'
    Subject                    = "Server Time Check - $(Get-Date -Format g)"
    Body                       = $body
    Attachment                 = 
    #DeliveryNotificationOption = 'OnFailure', 'OnSuccess'
}

## Send the message
Send-MailMessage @mailParams