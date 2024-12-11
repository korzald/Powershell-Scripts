#just test if the servers is up
    #$content = Get-Content C:\scripts\ServerLists.txt
    [Array] $servers =(Get-ADComputer -Filter * -Properties *) | 
    where {$_.OperatingSystem -like "*server*"} | 
    sort name | 
    select -ExpandProperty name

    foreach ($line in $servers){
      if (Test-Connection $line -Count 2 -ErrorAction SilentlyContinue) {
        Write-Host "$line => OK" -ForegroundColor DarkGreen
      }else{
        Write-Host "$line => NOT-OK" -ForegroundColor Red
      }
    }