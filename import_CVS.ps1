$rows = Import-Csv -Path c:\Scripts\ip_addresses.csv
foreach ($row in $rows) {
    try {
        $output = @{
            IPAddress  = $row.IPAddress
            IsOnline   = $false
            HostName   = $null
            Error      = $null
        }
        if (Test-Connection $row.IPAddress -Count 1 -Quiet) {
            $output.IsOnline = $true
        }
        if ($hostname = (Resolve-DnsName -Name $row.IPAddress -ErrorAction Stop).Name){
            output.HostName = $hostName
        }
    } catch {
        $output.Error = $_.Exception.Message
    } finally { 
        [pscustomobject]$output
    }
}
