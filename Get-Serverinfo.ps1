$serversOuPath = 'OU="Domain Controllers",DC=westtexasretina,DC=com'
$servers = Get-ADComputer -SearchBase $serversOuPath -Filter * | Select-Object -ExpandProperty Name
foreach ($server in $servers) {
    Write-Host $server 
}