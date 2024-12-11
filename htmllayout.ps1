$header = @"
<style>
    body {
        font-family: Arial, Helvetica, sans-serif;
    }
    h1 {
        color: #E68A00;
        font-size: 28px;
       }
    h2 {
        color: #000099;
        font-size: 16px;
    }
    table {
        font-size: 12px;
        border: 0px;
    }
    td {
        padding: 4px;
        margin: 0px;
        border: 0;
    }
    th {
        background: #395870;
        background: linear-gradient(#49708F, #293F50);
        color: #fff;
        font-size: 11px;
        text-transform: uppercase;
        padding: 10px 15px;
        vertical-align: middle;
	}
    tbody tr:nth-child(even) {
        background: #F0F0F2;
    }
        #CreationDate {
        font-family: Arial, Helvetica, sans-serif;
        color: #FF3300;
        font-size: 12px;
    }
</style>
"@
$ComputerName = "<h1>$env:computername</h1>"
$computerInfo = Get-ComputerInfo | ConvertTo-Html -As List -Property OsName, OsVersion, CsManufacturer, CsModel, CsName, CsUserName -Fragment -PreContent "<h2>Machine Info</h2>"
$computerService = Get-Service | Select-Object -First 10 | ConvertTo-Html -As List -Fragment -PreContent "<h2>Services</h2>"
$Report = ConvertTo-Html -Body "$computerName $computerInfo $computerService" -Title "Computer Information Report" -Head $header -PostContent "<p>Creation Date: $(Get-Date)</p>"
$Report | Out-File C:\Users\tyrone.conry\Desktop\ComputerInfo.html





9:38
$header = @" 
<style>
    body {
        font-family: Arial, Helvetica, sans-serif;
    }
    h1 {
        color: #E68A00;
        font-size: 28px;
       }
    h2 {
        color: #000099;
        font-size: 16px;
    }
    table {
        font-size: 12px;
        border: 0px;
    }
    td {
        padding: 4px;
        margin: 0px;
        border: 0;
    }
    th {
        background: #395870;
        background: linear-gradient(#49708F, #293F50);
        color: #fff;
        font-size: 11px;
        text-transform: uppercase;
        padding: 10px 15px;
        vertical-align: middle;
	}
    tbody tr:nth-child(even) {
        background: #F0F0F2;
    }
        #CreationDate {
        font-family: Arial, Helvetica, sans-serif;
        color: #FF3300;
        font-size: 12px;
    }
</style>
"@
$ComputerName = "<h1>$env:computername</h1>"
$computerInfo = Get-ComputerInfo | ConvertTo-Html -As List -Property OsName, OsVersion, CsManufacturer, CsModel, CsName, CsUserName -Fragment -PreContent "<h2>Machine Info</h2>"
$computerService = Get-Service | Select-Object -First 10 | ConvertTo-Html -As List -Fragment -PreContent "<h2>Services</h2>"
$Report = ConvertTo-Html -Body "$computerName $computerInfo $computerService" -Title "Computer Information Report" -Head $header -PostContent "<p>Creation Date: $(Get-Date)</p>"
$Report | Out-File C:\Users\tyrone.conry\Desktop\ComputerInfo.html
9:38
$header = @" 
<style>
    body {
        font-family: Arial, Helvetica, sans-serif;
    }
    h1 {
        color: #e68a00;
        font-size: 28px;
       }
    h2 {
        color: #000099;
        font-size: 16px;
    }
    table {
        font-size: 12px;
        border: 0px;
    }
    td {
        padding: 4px;
        margin: 0px;
        border: 0;
    }
    th {
        background: #395870;
        background: linear-gradient(#49708f, #293f50);
        color: #fff;
        font-size: 11px;
        text-transform: uppercase;
        padding: 10px 15px;
        vertical-align: middle;
	}
    tbody tr:nth-child(even) {
        background: #f0f0f2;
    }
        #CreationDate {
        font-family: Arial, Helvetica, sans-serif;
        color: #ff3300;
        font-size: 12px;
    }
</style>
"@
$ComputerName = "<h1>$env:computername</h1>"
$computerInfo = Get-ComputerInfo | ConvertTo-Html -As List -Property OsName, OsVersion, CsManufacturer, CsModel, CsName, CsUserName -Fragment -PreContent "<h2>Machine Info</h2>"
$computerService = Get-Service | Select-Object -First 10 | ConvertTo-Html -As List -Fragment -PreContent "<h2>Services</h2>"
$Report = ConvertTo-Html -Body "$computerName $computerInfo $computerService" -Title "Computer Information Report" -Head $header -PostContent "<p>Creation Date: $(Get-Date)</p>"
$Report | Out-File C:\Users\tyrone.conry\Desktop\ComputerInfo.html