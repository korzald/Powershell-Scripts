# Read from file
$Lines = Get-Content -Path c:\scripts\machines.txt 

# For each machine ...
foreach($Line in $Lines){
    # Split line, save name and domain
    $Tokens = $Line.Split(";")

    $MachineName = $Tokens[0]
    $Domain = $Tokens[1]
    $User = "westtexasretina\administrator"
    $Password=""

    # Switch username if someOtherDomain
    if ($Domain -eq "someOtherDomain"){
        $User = "someOtherDomain\someOtherUsername"
    }

    #set credentials and open connection
    cmdkey /add:$MachineName /user:$User /pass:$Password
    mstsc /v:$MachineName /console
}

# logging in with saved credintals not allowed. 