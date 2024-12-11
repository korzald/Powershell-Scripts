#Server Health Checker
#Author: Peter Morrissey

#start-sleep 300

$target = "127.0.0.1"

#Get Last Bootup Time
$osprops = get-wmiobject -class win32_operatingsystem 
$lastboot = $osprops.ConvertToDateTime($osprops.LastBootUpTime)

#Log File
$error.clear()
$fulldate = Get-Date
$logfile = "c:\" + "Scripts\" + "ServerHealthChecks\" + $FullDate.ToString("yyyyMMddHHmm") + "-" + "$Target" + ".html"
$global:strname = $env:username
$global:html = @()
$html += "<html>"
$html += '<font face="courier">'
$html += "<title>Server Health Check - $Target</title>"
$html += "<h3>$FullDate</h3>"
$html += "<h4>Server Health Check Script - Run by $global:strname</h4>"
$html += "<h4>Target Server: $Target</h4>"
$html += "<h4>Hostname: $env:computername</h4>"
$html += "<h4>Last Boot: $lastboot </h4>"
$html += "<p>"
$html += "******************************************************************************************* <p>"

#Services Check
write-host "Getting Service Information"
$html += '<u>Service Report - Services with StartMode "Auto" and State not currently "Running" </u><p>'

$servicelist = invoke-command -computername $target {
        get-wmiobject -class Win32_Service | Where {$_.StartMode -eq "Auto" -and $_.State -ne "Running"} | Select DisplayName, Name, StartMode, State
        }
if ($servicelist){$temphtml = $servicelist | Select DisplayName, Name, StartMode, State | ConvertTo-HTML -fragment
                    ForEach ($line in $temphtml){$html += "$Line"} }
ELSE {write-host "All automatic services are running";$html += "All automatic services are running <p>"}

$html += "<p> ******************************************************************************************* <p>"

#EventLog Checks
write-host "Querying Application Log on $Target"
$appeventlog = invoke-command -computername $target {
        $targetDate = Get-Date
        $targetdate = $targetdate.adddays(-1)
        get-eventlog -logname "Application" -after $targetdate | where-object {$_.entrytype -ne "Information" -and $_.Source -ne "Print" -and $_.Source -ne "TermServDevices"} 
        }

if ($appeventlog){#write-host $AppEventLog
                  $html += "<u>Application Log Non-Information Events (Last 24 Hours)</u><p>" 
                  $temphtml = $appeventlog |  Select TimeGenerated, EntryType, Source, Message | ConvertTo-HTML -fragment
                  foreach ($line in $temphtml){$html += "$line"}
                  }
                  
ELSE {$html += "No non-informational events found in application log in past 24 hours <p>"}

$html += "<p>*******************************************************************************************<p>"

write-host "Querying System Log on $Target"

$syseventlog = invoke-command -computername $Target {
        $targetdate = get-date
        $targetdate = $targetdate.adddays(-1)
        get-eventlog -logname "System" -after $targetdate | where-object {$_.entrytype -ne "Information" -and $_.source -ne "Print" -and $_.source -ne "TermServDevices"} 
        }

if ($syseventlog){#write-host $syseventlog
                  $html += "<u>System Log Non-Information Events (Last 24 Hours)</u><p>"
                  $temphtml = $syseventlog | Select TimeGenerated, EntryType, Source, Message | ConvertTo-HTML -fragment
                  ForEach ($line in $temphtml){$html += "$Line"}
                  }
                  
else {$html += "No non-informational events found in system log in past 24 hours<p>"}

$html += "<p>*******************************************************************************************<p>"

#Local Disk Health Check
write-host "Getting logical disk information"
$diskreport = invoke-command -computername $target {
    Get-WmiObject Win32_logicaldisk | Select DeviceID, MediaType, VolumeName, `
    @{Name="Size(GB)";Expression={[decimal]("{0:N0}" -f($_.size/1gb))}}, `
    @{Name="Free Space(GB)";Expression={[decimal]("{0:N0}" -f($_.freespace/1gb))}}, `
    @{Name="Free (%)";Expression={"{0,6:P0}" -f(($_.freespace/1gb) / ($_.size/1gb))}} `
    }

$html += "<u>Logical Disk Report</u><p>"
$temphtml = $DiskReport | Select DeviceID, VolumeName, "Size(GB)", "Free Space(GB)", "Free (%)" | ConvertTo-HTML -fragment
foreach ($Line in $temphtml)
    {
    if ($line -like "*%<*")
        {
        $lineindex = [array]::IndexOf($temphtml, $line)
        $templine = $line -split "%"
        $templine = $templine -replace(" ","")
        $templine = $templine[0] -split "<td>"
        $templine = $templine[5]
        $templine = $templine.trim()
        $templine = [decimal]$templine
               
        if ($templine -le 20 -and $templine -ge 10){$temphtml[$lineindex] = $temphtml[$lineindex].Replace("<td>",'<td><font color="orange">')}
        if ($templine -lt 10 ){$temphtml[$lineindex] = $temphtml[$lineindex].Replace("<td>",'<td><font color="red">');
                                $smtpclient = new-object system.net.mail.smtpClient 
                                $mailmessage = New-Object system.net.mail.mailmessage 
                                $smtpclient.Host = "192.168.0.5" 
                                $mailmessage.from = ("alerts@mitx.dynu.com") 
                                $mailmessage.To.add("peter@mitx.dynu.com")
                                $mailmessage.Subject = “Server Health Check Alert - Disk Space Low - $target"
                                $mailmessage.Body = "Low disk space found on $target -  $temphtml"
                                $mailmessage.IsBodyHtml = $true
                                $smtpclient.Send($mailmessage)
                                $mailmessage.dispose()
                              }
        }
    }

foreach ($line in $temphtml){$html += "$line"}

$html += "<p>*******************************************************************************************<p>"

#Check CPU Load
write-host "Getting CPU Stats"
$cpudata = get-wmiobject win32_processor -computername $target | measure-object -property LoadPercentage -average | select Average
$html += "<u>CPU Load (Average)</u><p>"
$cpuusage = $($cpudata.average)
    if ($cpuusage -ge 80 -and $cpuusage -le 90){$html += '<font color="orange">' + "Average CPU Load: $cpuusage%" + '</font>'}
    elseif ($cpuusage -gt 90){$html += '<font color="red">' + "Average CPU Load: $cpuusage%" + '</font>'}
    elseif ($cpuusage -lt 80){$html += '<font color = "green">' + "Average CPU Load: $cpuusage%" + '</font>'}
$html += "<p>*******************************************************************************************<p>"

#Check Memory Usage
write-host "Getting Memory Usage"
$html += "<u>Memory Usage Report</u><p>"
$memdata = get-wmiobject win32_operatingsystem -computername $target | select FreePhysicalMemory, FreeVirtualMemory, TotalVirtualMemorySize, TotalVisibleMemorySize
$freephysicalmem = $($memdata.freephysicalmemory)
$freevirtualmem = $($memdata.freevirtualmemory)
$totalvirtualmem = $($memdata.totalvirtualmemorysize)
$totalvisiblemem = $($memdata.totalvisiblememorysize)
$memusage = ($totalvisiblemem - $freephysicalmem) / $totalvisiblemem * 100
$freemem = $freephysicalmem / $totalvisiblemem * 100
[decimal]$freemem = "{0:N0}" -f $freemem

if ($freemem -lt 10){$html += '<font color="red">' + "Free Memory (%): $freemem" + '</font>'}
elseif ($freemem -gt 10 -and $freemem -le 20){$html += '<font color="orange">' + "Free Memory (%): $freemem" + '</font>'}
elseif ($freemem -gt 20){$html += '<font color="green">' + "Free Memory (%): $freemem" + '</font>'}
$html += "<p>*******************************************************************************************<p>"

#Export Log File
$html | out-file $LogFile

#Open Log File in Internet Explorer
#Invoke-Item $Logfile

<#
#Send Log File via Email
$smtpclient = new-object system.net.mail.smtpClient 
$mailmessage = New-Object system.net.mail.mailmessage 
$smtpclient.Host = "mail.server.com" 
$mailmessage.from = ("user@domain.com") 
$mailmessage.To.add("user@domain.com")
$mailmessage.Subject = “Server Health Check Results - $target"
$mailmessage.Body = "Server Health Check Results for $target"
$mailmessage.Attachments.Add($LogFile)
$mailmessage.IsBodyHtml = $true
$smtpclient.Send($mailmessage)
$mailmessage.dispose()
#>