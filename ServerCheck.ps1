﻿<#============================================================================================================
   Script Name: ServerHealthReport.ps1
       Purpose: Produces a Health Report for servers. The list of servers is read from a .csv file.
         Notes: The report includes Drives, RAM, CPU, and UPTIME information.
        Author: Richard Wright
  Date Created: 8/24/2017
       Credits: This script was influenced by Michael J. Messano's code located here:
                https://github.com/mubix/PowerShell-1/blob/master/Report-DiskSpaceUsage.ps1
Special Thanks: SpiceHeads JeffLatham01, Onelinez, and spicehead-6751 for their suggestions and for testing.
     ChangeLog:    Date     Who  Description of changes
		----------  ---  ----------------------------------------------------------------------------
                10/26/2017  RMW  Replaced <b> and </b> with <strong> and </strong>
                09/06/2018  RMW  Added error checking to see if server is online, skips if not, formatting
                09/07/2018  RMW  Edited report to include "non responsive" servers
                10/23/2018  RMW  Removed all specific error handling catch routines to just have one
                10/31/2018  RMW  Added more code for catching errors
                11/15/2018  RMW  Server list file changed to .csv to allow descriptions of the servers
                09/10/2019  RMW  Added an Overview section
                12/31/2019  RMW  Added CPU Average Load %
                01/13/2023  RMW  Added CPU color alert for critical average load
                03/09/2023  RMW  Added OS
		----------  ---  ----------------------------------------------------------------------------

         Intro: This PowerShell script produces a report that shows drive, RAM, and CPU usage as well as uptime for a list of servers 
                read from a .csv file. The server list file contains the server name and description, one per line, comma separated, 
                as shown below:
                  Server1, Web Server
                  Server2, File Server

                You can have the report include an "Overview" section that lists any of the items noted above if they are in a warning 
                or critical state. You determine the values to identify those states. For example, setting the "$DrvWarning" variable to 
                15 will trigger the report to highlight any drive that is below 15% available space and to be color coded in the color you 
                designate in $BGColorWarn.
                You can also disable the "Overview" section entirely if it is of no value to you.
                Variables that you can adjust for your preferences definitions are described below. 
----------------------------------------------------------------------------------------------------------------------------------------------
In the section following this one, edit these variables with your preferences:
            $DateStamp = Your preferred format for showing the date in the report
           $ServerList = .CSV file with the list of server names and descriptions for the report; one per line
       $ReportFileName = Completed report filename
   $ReportFileOverview = Report filename showing just the Overview
      $ReportFileStats = Report filename showing just the server devices queried and their results
          $ReportTitle = Title of the report - shown at the top of the generated HTML file
           $BGColorTbl = Background color for tables
          $BGColorGood = Background color for "Good" results - #4CBB17 is a shade of green
          $BGColorWarn = Background color for "Warning" results - #FFFC33 is a shade of yellow
          $BGColorCrit = Background color for "Critical" results - #FF0000 is red
         $UptimeDayMax = Number of days of uptime to be alerted to if exceeded
              $RAMFree = Percentage of free RAM to be alerted to if less than
          $CPUCritical = CPU load % to indicate Critical (RED) in report
           $DrvWarning = Free drive space % to indicate Warning (Yellow) in report - must be more than $DrvCritical amount
          $DrvCritical = Free drive space % to indicate Critical (RED) in report - must be less than $DrvWarning amount
$ErrorActionPreference = Set default error action to 'Stop' for error handling
              $EmailTo = Email recipient
            $EmailFrom = Email "from" address
         $EmailSubject = Email subject
      $EmailAttachment = Email the report as an attachment? Yes or No - will aslo be included in the HTML body
           $SMTPServer = SMTP server
       $OverviewOption = Do you want to include the Overvew section on the report? Yes or No
        $Global:Alerts = Global counter for tracking the total number of alerts
======================================================================================================================#>
$ComputerName = $($env:COMPUTERNAME)
$ScriptPath = Get-Location
$Global:Alerts = 0

#----------------------------------
# Edit these with your preferences
#----------------------------------
$DateStamp = (Get-Date -Format D)
$ServerList = Import-CSV "$ScriptPath\ServerList.csv" –Header Server, Description
#$ServerList = Import-CSV "$ScriptPath\ServerList-small.csv" –Header Server, Description
$ReportFileName = "$ScriptPath\ServerHealthReport.html"
$ReportFileOverview = "$ScriptPath\ServerHealthReport1.html"
$ReportFileStats = "$ScriptPath\ServerHealthReport2.html"
$ReportTitle = "Server Health Report"
$BGColorTbl = "#EAECEE"
$BGColorGood = "#4CBB17"
$BGColorWarn = "#FFFC33"
$BGColorCrit = "#FF0000"
$UptimeDayMax = 45
$RAMFree = 15
$CPUCritical = 75
$DrvWarning = 15
$DrvCritical = 5
$ErrorActionPreference = 'Stop'
$EmailTo = "to@domain.com"
$EmailFrom = "noreply@domain.com"
$EmailSubject = "From $ComputerName - Server Health Report for $DateStamp"
$EmailAttachment = "Yes"
$SMTPServer = "smtp.domain.com"
$OverviewOption = "Yes"

#---------------------------------
# Do not edit below this section
#---------------------------------
# Clear screen then show progress
Clear
Write-Host "Creating report..." -Foreground Yellow

# Create output files and nullify display output
New-Item -ItemType file $ReportFileName -Force > $null
New-Item -ItemType file $ReportFileOverview -Force > $null
New-Item -ItemType file $ReportFileStats -Force > $null

#--------------------
# Main Report Header
#--------------------
Add-Content $ReportFileName "<html>"
Add-Content $ReportFileName "<head>"
Add-Content $ReportFileName "<meta http-equiv='Content-Type' content='text/html; charset=iso-8859-1'>"
Add-Content $ReportFileName "<title>$ReportTitle</title>"
Add-Content $ReportFileName '<STYLE TYPE="text/css">'
Add-Content $ReportFileName "td {"
Add-Content $ReportFileName "font-family: Cambria;"
Add-Content $ReportFileName "font-size: 11px;"
Add-Content $ReportFileName "border-top: 1px solid #999999;"
Add-Content $ReportFileName "border-right: 1px solid #999999;"
Add-Content $ReportFileName "border-bottom: 1px solid #999999;"
Add-Content $ReportFileName "border-left: 1px solid #999999;"
Add-Content $ReportFileName "padding-top: 0px;"
Add-Content $ReportFileName "padding-right: 0px;"
Add-Content $ReportFileName "padding-bottom: 0px;"
Add-Content $ReportFileName "padding-left: 0px;"
Add-Content $ReportFileName "}"
Add-Content $ReportFileName "body {"
Add-Content $ReportFileName "margin-left: 5px;"
Add-Content $ReportFileName "margin-top: 5px;"
Add-Content $ReportFileName "margin-right: 0px;"
Add-Content $ReportFileName "margin-bottom: 10px;"
Add-Content $ReportFileName "table {"
Add-Content $ReportFileName "border: thin solid #000000;"
Add-Content $ReportFileName "}"
Add-Content $ReportFileName "</style>"
Add-Content $ReportFileName "</head><body>"
Add-Content $ReportFileName "<table width='75%' align=`center`>"
Add-Content $ReportFileName "<tr bgcolor=$BGColorTbl>"
Add-Content $ReportFileName "<td colspan='7' height='25' align='center'>"
Add-Content $ReportFileName "<font face='Cambria' color='#003399' size='4'><a id='Top' name='Top'><strong>$ReportTitle<br/></strong></a></font>"
Add-Content $ReportFileName "<font face='Cambria' color='#003399' size='2'>$DateStamp</font><br><br>"  
Add-Content $ReportFileName "CPU will be in <FONT color=$BGColorCrit><strong>RED</strong></FONT> if avg. load % is more than $CPUCritical. <br>RAM will be in <FONT color=$BGColorCrit><strong>RED</strong></FONT> if free % is less than $RAMFree. <br>UPTIME will be in <FONT color=$BGColorCrit><strong>RED</strong></FONT> if greater than $UptimeDayMax days.</FONT>"
Add-Content $ReportFileName "</td></tr></table>"
Add-content $ReportFileName "<table width='60%' align=`center`>"  
Add-Content $ReportFileName "<tr>"  
Add-Content $ReportFileName "<td width='20%' bgcolor=$BGColorGood align='center'><strong>Disk Space > $DrvWarning% Free</strong></td>"  
Add-Content $ReportFileName "<td width='20%' bgcolor=$BGColorWarn align='center'><strong>Disk Space $DrvCritical-$DrvWarning% Free</strong></td>" 
Add-Content $ReportFileName "<td width='20%' bgcolor=$BGColorCrit align='center'><strong>Disk Space < $DrvCritical% Free</strong></td>"
Add-Content $ReportFileName "</tr></table>"

#----------------------
# Server Report Header
#----------------------
Add-Content $ReportFileStats '<STYLE TYPE="text/css">'
Add-Content $ReportFileStats "td {"
Add-Content $ReportFileStats "font-family: Cambria;"
Add-Content $ReportFileStats "font-size: 11px;"
Add-Content $ReportFileStats "border-top: 1px solid #999999;"
Add-Content $ReportFileStats "border-right: 1px solid #999999;"
Add-Content $ReportFileStats "border-bottom: 1px solid #999999;"
Add-Content $ReportFileStats "border-left: 1px solid #999999;"
Add-Content $ReportFileStats "padding-top: 0px;"
Add-Content $ReportFileStats "padding-right: 0px;"
Add-Content $ReportFileStats "padding-bottom: 0px;"
Add-Content $ReportFileStats "padding-left: 0px;"
Add-Content $ReportFileStats "}"
Add-Content $ReportFileStats "body {"
Add-Content $ReportFileStats "margin-left: 5px;"
Add-Content $ReportFileStats "margin-top: 5px;"
Add-Content $ReportFileStats "margin-right: 0px;"
Add-Content $ReportFileStats "margin-bottom: 10px;"
Add-Content $ReportFileStats "table {"
Add-Content $ReportFileStats "border: thin solid #000000;"
Add-Content $ReportFileStats "}"
Add-Content $ReportFileStats "</style>"

#-----------------
# Overview Header
#-----------------
Add-Content $ReportFileOverview '<STYLE TYPE="text/css">'
Add-Content $ReportFileOverview "td {"
Add-Content $ReportFileOverview "font-family: Cambria;"
Add-Content $ReportFileOverview "font-size: 11px;"
Add-Content $ReportFileOverview "border-top: 1px solid #999999;"
Add-Content $ReportFileOverview "border-right: 1px solid #999999;"
Add-Content $ReportFileOverview "border-bottom: 1px solid #999999;"
Add-Content $ReportFileOverview "border-left: 1px solid #999999;"
Add-Content $ReportFileOverview "padding-top: 0px;"
Add-Content $ReportFileOverview "padding-right: 0px;"
Add-Content $ReportFileOverview "padding-bottom: 0px;"
Add-Content $ReportFileOverview "padding-left: 0px;"
Add-Content $ReportFileOverview "}"
Add-Content $ReportFileOverview "body {"
Add-Content $ReportFileOverview "margin-left: 5px;"
Add-Content $ReportFileOverview "margin-top: 5px;"
Add-Content $ReportFileOverview "margin-right: 0px;"
Add-Content $ReportFileOverview "margin-bottom: 10px;"
Add-Content $ReportFileOverview "table {"
Add-Content $ReportFileOverview "border: thin solid #000000;"
Add-Content $ReportFileOverview "}"
Add-Content $ReportFileOverview "</style>"
Add-Content $ReportFileOverview "<br><table width='75%' align=`center`>"
Add-Content $ReportFileOverview "<tr bgcolor=$BGColorTbl>"
Add-Content $ReportFileOverview "<td colspan='7' height='25' align='center'>"
Add-Content $ReportFileOverview "<font face='Cambria' color='#003399' size='4'><strong>Overview<br/></strong></font>"
Add-Content $ReportFileOverview "<font face='Cambria' color='#003399' size='2'>The following servers have an item that is either at a warning or critical state.<br>Click on a server name to be taken to that section.</font><br>"
Add-Content $ReportFileOverview "<font face='Cambria' color='#003399' size='2'>Press the [HOME] key to return to this section.</font><br>"
Add-Content $ReportFileOverview "</td></tr></table>"
Add-Content $ReportFileOverview "<table width='25%' align='center'>"

#--------------------------------
# Function to write Table Header
#--------------------------------
Function writeTableHeader
{
	param($fileName)
	Add-Content $fileName "<tr bgcolor=$BGColorTbl>"
	Add-Content $fileName "<td width='10%' align='center'>Drive</td>"
	Add-Content $fileName "<td width='10%' align='center'>Drive Label</td>"
	Add-Content $fileName "<td width='15%' align='center'>Total Space (GB)</td>"
	Add-Content $fileName "<td width='15%' align='center'>Used Space (GB)</td>"
	Add-Content $fileName "<td width='15%' align='center'>Free Space (GB)</td>"
	Add-Content $fileName "<td width='10%' align='center'>Free Space %</td>"
	Add-Content $fileName "</tr>"
}


#-----------------------------
# Function to write Disk info
#-----------------------------
Function writeDiskInfo
{
	param(
			$ServerName
			,$FileName1
			,$FileName2
			,$devId
			,$volName
			,$frSpace
			,$totSpace
		)
	$totSpace 	= [Math]::Round(($totSpace/1073741824),2)
	$frSpace 	= [Math]::Round(($frSpace/1073741824),2)
	$usedSpace 	= $totSpace - $frspace
	$usedSpace 	= [Math]::Round($usedSpace,2)
	$freePercent 	= ($frspace/$totSpace)*100
	$freePercent 	= [Math]::Round($freePercent,0)
	Add-Content $FileName1 "<tr>"
	Add-Content $FileName1 "<td align='center'>$devid</td>"
	Add-Content $FileName1 "<td align='center'>$volName</td>"
	Add-Content $FileName1 "<td align='right'>$totSpace</td>"
	Add-Content $FileName1 "<td align='right'>$usedSpace</td>"
	Add-Content $FileName1 "<td align='right'>$frSpace</td>"

	if ($freePercent -gt $DrvWarning)
	{
	#Green for Good
		Add-Content $FileName1 "<td bgcolor=$BGColorGood align='center'>$freePercent</td>"
		Add-Content $FileName1 "</tr>"
	}
	elseif ($freePercent -le $DrvCritical)
	{
	#Red for Critical
		Add-Content $FileName1 "<td bgcolor=$BGColorCrit align=center>$freePercent</td>"
		Add-Content $FileName1 "</tr>"
		Add-Content $FileName2 "<tr>"
		Add-Content $FileName2 "<font face='Cambria' color='#003399' size='1'>"
		Add-Content $FileName2 "<td width='20%' align='center'><a href='#$ServerName'><strong>$ServerName</strong></a></td>"
		Add-Content $FileName2 "<td width='20%' bgcolor=$BGColorCrit align='center'><strong>$devid = $freePercent% free</strong></td>"
		Add-Content $FileName2 "</font></tr>"
                $Global:Alerts++
	}
	else
	{
	#Yellow for Warning
		Add-Content $FileName1 "<td bgcolor=$BGColorWarn align=center>$freePercent</td>"
		Add-Content $FileName1 "</tr>"
		Add-Content $FileName2 "<tr>"
		Add-Content $FileName2 "<font face='Cambria' color='#003399' size='1'>"
		Add-Content $FileName2 "<td width='20%' align='center'><a href='#$ServerName'><strong>$ServerName</strong></a></td>"
		Add-Content $FileName2 "<td width='20%' bgcolor=$BGColorWarn align='center'><strong>$devid = $freePercent% free</strong></td>"
		Add-Content $FileName2 "</font></tr>"
                $Global:Alerts++
	}
}

#------
# Main
#------
Write-Host "Collecting data for servers in list..."
ForEach ($Server in $Serverlist)
{
$ServerName = $($Server.Server)
$ServerDesc = $($Server.Description)
	try {
		Write-Host "Total Alerts: $Global:Alerts"
		Write-Host "`nServer Name: $ServerName, $ServerDesc" -Foreground Green
		$OS = (Get-ADComputer -Identity $ServerName -Properties OperatingSystem).OperatingSystem
		$CPUs = (Get-WMIObject Win32_ComputerSystem -Computername $ServerName -ErrorAction Stop).numberofprocessors
                $CPUavg = Get-WmiObject win32_processor -computername $ServerName | Measure-Object -property LoadPercentage -Average
                $CPUavg=$CPUavg.Average
		Get-WMIObject -computername $ServerName -class win32_processor -ErrorAction Stop | ForEach {$TotalCores = $TotalCores + $_.numberofcores}
		$ComputerSystem = Get-WmiObject -ComputerName $ServerName -Class Win32_operatingsystem -Property CSName, TotalVisibleMemorySize, FreePhysicalMemory -ErrorAction Stop
		$BootTime = (Get-WmiObject win32_operatingSystem -computer $ServerName -ErrorAction Stop).lastbootuptime
		}
	catch {
		Write-Host "ERROR collecting data for $ServerName " -ForegroundColor Yellow
		$_.Exception
		"Continuing..."
		Add-Content $ReportFileStats "<br>"
		Add-Content $ReportFileStats "<a id='$ServerName' name='$ServerName'></a>"
		Add-Content $ReportFileStats "<table width='75%' align=`center`>"
		Add-Content $ReportFileStats "<tr bgcolor=$BGColorTbl>"
		Add-Content $ReportFileStats "<td width='75%' align='center' colSpan=6><font face='Cambria' color='#003399' size='2'><strong> $ServerName </strong></font><br>"
		Add-Content $ReportFileStats "$ServerDesc<br>"
		Add-Content $ReportFileStats "<FONT face='Cambria' color=$BGColorCrit><strong>Communication Error</strong></td>"
		Add-Content $ReportFileStats "</tr><br>"
		Add-Content $ReportFileOverview "<tr>"
		Add-Content $ReportFileOverview "<font face='Cambria' color='#003399' size='1'>"
		Add-Content $ReportFileOverview "<td width='20%' align='center'><a href='#$ServerName'><strong>$ServerName</strong></a></td>"
		Add-Content $ReportFileOverview "<td width='20%' bgcolor=$BGColorCrit align='center'><strong>Communication Error</strong></td>"
		Add-Content $ReportFileOverview "</font></tr>"
                $Global:Alerts++
		Continue
		}

	Add-Content $ReportFileStats "</table><br>"

#----------
# CPU Info
#----------
$TotalCores = 0 
Get-WMIObject -computername $ServerName -class win32_processor | ForEach {$TotalCores = $TotalCores + $_.numberofcores}
If ($TotalCores -eq 1)
	{$CPUSpecs = "CPU: $CPUs with 1 core, Avg Load %: $CPUavg"}
else
	{$CPUSpecs = "CPU: $CPUs with $TotalCores cores, Avg Load %: $CPUavg"}

#Set $CPUSpecs color depending on $CPUavg value
IF ($CPUavg -ge $CPUCritical)
	{
		$FontColorCPU = $BGColorCrit
	}
	Else
	{
		$FontColorCPU = $BGColorGood
        }

#----------
# RAM Info
#----------
$MachineName = $ComputerSystem.CSName
$FreePhysicalMemory = ($ComputerSystem.FreePhysicalMemory) / (1mb)
$TotalVisibleMemorySize = ($ComputerSystem.TotalVisibleMemorySize) / (1mb)
$TotalVisibleMemorySizeR = “{0:N2}” -f $TotalVisibleMemorySize
$TotalFreeMemPerc = ($FreePhysicalMemory/$TotalVisibleMemorySize)*100
$TotalFreeMemPercR = “{0:N2}” -f $TotalFreeMemPerc
$RAMSpecs = "RAM: $TotalVisibleMemorySizeR GB with $TotalFreeMemPercR% free"

#--------
# Uptime
#--------
$BootTime = [System.Management.ManagementDateTimeconverter]::ToDateTime($BootTime)
$Now = Get-Date
$span = New-TimeSpan $BootTime $Now 
	$Days	 = $span.days
	$Hours   = $span.hours
	$Minutes = $span.minutes 
	$Seconds = $span.seconds

#Remove plurals if the value = 1
	If ($Days -eq 1)
		{$Day = "1 day "}
	else
		{$Day = "$Days days "}

	If ($Hours -eq 1)
		{$Hr = "1 hr "}
	else
		{$Hr = "$Hours hrs "}

	If ($Minutes -eq 1)
		{$Min = "1 min "}
	else
		{$Min = "$Minutes mins "}

	If ($Seconds -eq 1)
		{$Sec = "1 sec"}
	else
		{$Sec = "$Seconds secs"}

$Uptime = $Day + $Hr + $Min + $Sec
$ServerUptime = "UPTIME: " + $Uptime

#------------------------------------------
# Set visual alerts FONT color for Overview
#------------------------------------------
# % of CPU load
IF ($CPUavg -ge $CPUCritical)
	{
		$FontColorRAM=$BGColorCrit
		Add-Content $ReportFileOverview "<tr>"
		Add-Content $ReportFileOverview "<font face='Cambria' color='#003399' size='1'>"
		Add-Content $ReportFileOverview "<td width='20%' align='center'><a href='#$ServerName'><strong>$ServerName</strong></a></td>"
		Add-Content $ReportFileOverview "<td width='20%' bgcolor=$BGColorCrit align='center'><strong>CPU Avg Load % = $CPUavg</strong></td>"
		Add-Content $ReportFileOverview "</font></tr>"
                $Global:Alerts++
	}

# % of free RAM
IF ($TotalFreeMemPerc -le $RAMFree)
	{
		$FontColorRAM=$BGColorCrit
		Add-Content $ReportFileOverview "<tr>"
		Add-Content $ReportFileOverview "<font face='Cambria' color='#003399' size='1'>"
		Add-Content $ReportFileOverview "<td width='20%' align='center'><a href='#$ServerName'><strong>$ServerName</strong></a></td>"
		Add-Content $ReportFileOverview "<td width='20%' bgcolor=$BGColorCrit align='center'><strong>RAM = $TotalFreeMemPercR% Free</strong></td>"
		Add-Content $ReportFileOverview "</font></tr>"
                $Global:Alerts++
	}
	Else
	{
		$FontColorRAM=$BGColorGood
	}

# UPTIME days
IF ($Days -gt $UptimeDayMax)
	{
		$FontColorUp=$BGColorCrit
		Add-Content $ReportFileOverview "<tr>"
		Add-Content $ReportFileOverview "<font face='Cambria' color='#003399' size='1'>"
		Add-Content $ReportFileOverview "<td width='20%' align='center'><a href='#$ServerName'><strong>$ServerName</strong></a></td>"
		Add-Content $ReportFileOverview "<td width='20%' bgcolor=$BGColorCrit align='center'><strong>UPTIME = $Days days</strong></td>"
		Add-Content $ReportFileOverview "</font></tr>"
                $Global:Alerts++
	}
	Else
	{
		$FontColorUp=$BGColorGood
	}

Add-Content $ReportFileStats "<table width='75%' align=`center`>"
Add-Content $ReportFileStats "<tr bgcolor=$BGColorTbl>"
Add-Content $ReportFileStats "<a id='$ServerName' name='$ServerName'></a>"
Add-Content $ReportFileStats "<td width='75%' align='center' colSpan=6><font face='Cambria' color='#003399' size='2'><strong> $ServerName </strong></font><br>"
Add-Content $ReportFileStats "<font face='Cambria' color='#003399'>$ServerDesc<br>"
Add-Content $ReportFileStats "$OS<br>"
#Add-Content $ReportFileStats "$CPUSpecs<br>"
Add-Content $ReportFileStats "<FONT face='Cambria' color=$FontColorCPU><strong>$CPUSpecs</strong><br>"
Add-Content $ReportFileStats "<FONT face='Cambria' color=$FontColorRAM><strong>$RAMSpecs</strong><br>"
Add-Content $ReportFileStats "<FONT face='Cambria' color=$FontColorUp><strong>$ServerUptime</strong></td>"
Add-Content $ReportFileStats "</tr>"
writeTableHeader $ReportFileStats

#--------------------------
# Begin Server Disk tables
#--------------------------
$dp = Get-WmiObject -Class Win32_LogicalDisk -Filter "DriveType=3" -Computer $ServerName
ForEach ($item in $dp)
	{
		Write-Host  $ServerName $item.DeviceID  $item.VolumeName $item.FreeSpace $item.Size
		writeDiskInfo $ServerName $ReportFileStats $ReportFileOverview $item.DeviceID $item.VolumeName $item.FreeSpace $item.Size
	}
Add-Content $ReportFileStats "</table>"
}

Write-Host "Finishing report..." -Foreground Yellow

Write-Host "Total Alerts: $Global:Alerts"
If ($Global:Alerts -eq 0) {
	Write-Host "Adding content to $ReportFileOverview"
	Add-Content $ReportFileOverview "<center><font face='Cambria' color='#003399' size='2'>There are no known Server Health issues at this time.</font></center>"  
}

Add-Content $ReportFileStats "</body></html><br>"
Add-Content $ReportFileStats "<center><a href='#Top'>Top of Report</a></center>"
Add-Content $ReportFileOverview "</table>"
Write-Host

#---------------
# Merge Reports
#---------------
If ($OverviewOption -eq "Yes") {
	Get-Content $ReportFileOverview,$ReportFileStats | Add-Content $ReportFileName
} ELSE {
	Get-Content $ReportFileStats | Add-Content $ReportFileName
}

#------------
# Send Email
#------------
$BodyReport = Get-Content "$ReportFileName" -Raw
If ($EmailAttachment -eq "Yes") {
	$EmailOptions = @{
	From = $EmailFrom
	To = $EmailTo
	Subject = $EmailSubject
	BodyAsHtml = $true
	Body = $BodyReport
	Attachment = $ReportFileName
	SMTPServer = $SMTPServer
}
} ELSE {
	$EmailOptions = @{
	From = $EmailFrom
	To = $EmailTo
	Subject = $EmailSubject
	BodyAsHtml = $true
	Body = $BodyReport
	SMTPServer = $SMTPServer 
}
}

Send-MailMessage @EmailOptions

Write-Host "End of script."