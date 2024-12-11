#script to get orphaned group ploicies. 

param(
      $domain = $env:userDNSdomain,
      [switch]$query,
      [switch]$help,
      [switch]$examples,
      [switch]$min,
      [switch]$full
      ) #end param

# Begin Functions

function Get-HelpTopic()
{
$descriptionText= `
@”
NAME: FindUnlinkedGPOs.ps1
DESCRIPTION: Finds GPOs that are not linked
anywhere in the domain. The domain can be
specified, or by default it runs against the
current domain.

PARAMETERS:
-domain Domain to query for unlinked GPOs
-query Executes the query
-help prints help description and parameters file
-examples prints only help examples of syntax
-full prints complete help information
-min prints minimal help. Modifies -help

“@ #end descriptionText

$examplesText= `
@”

SYNTAX:
FindUnlinkedGPOs.ps1

Displays missing query and calls help

FindUnlinkedGPOs.ps1 -query

Displays unlinked GPOs from the current domain

FindUnlinkedGPOs.ps1  -domain “nwtraders.com”

Displays unlinked GPOs from the nwtraders.com domain

FindUnlinkedGPOs.ps1 -help

Prints the help topic for the script

FindUnlinkedGPOs.ps1 -help -full

Prints full help topic for the script

FindUnlinkedGPOs.ps1 -help -examples

Prints only the examples for the script

FindUnlinkedGPOs.ps1 -examples

Prints only the examples for the script
“@ #end examplesText

$remarks = `
“
REMARKS
     For more information, type: $($MyInvocation.ScriptName) -help -full
” #end remarks

  if($examples) { $examplesText ; $remarks ; exit }
  if($full)     { $descriptionText; $examplesText ; exit }
  if($min)      { $descriptionText ; exit }
  $descriptionText; $remarks
  exit
} #end Get-HelpTopic function

function New-Line (
                  $strIN,
                  $char = “=”,
                  $sColor = “Yellow”,
                  $uColor = “darkYellow”,
                  [switch]$help
                 )
{
if($help)
  {
    $local:helpText = `
@”
     New-Line accepts inputs: -strIN for input string and -char for seperator
     -sColor for the string color, and -uColor for the underline color. Only
     the -strIn is required. The others have the following default values:
     -char: =, -sColor: Yellow, -uColor: darkYellow
     Example:
     New-Line -strIN “Hello world”
     New-Line -strIn “Morgen welt” -char “-” -sColor “blue” -uColor “yellow”
     New-Line -help
“@
   $local:helpText
   break
  } #end New-Line help
 
$strLine= $char * $strIn.length
Write-Host -ForegroundColor $sColor $strIN
Write-Host -ForegroundColor $uColor $strLine
} #end New-Line function

Function Get-UnlinkedGPO()
{
$gpm=New-Object -ComObject gpmgmt.gpm
$constants = $gpm.GetConstants()
$gpmDomain = $gpm.GetDomain($domain,$null,$constants.useanydc)
$gpmSearchCriteria = $gpm.CreateSearchCriteria()
$gpoList= $gpmDomain.SearchGPOs($gpmSearchCriteria)

New-Line(“GPO’s that are not linked anywhere in $domain”)
$unlinkedGPO = 0
foreach($objGPO in $gpoList)
{
  $gpmSearchCriteria = $gpm.CreateSearchCriteria()
  $gpmSearchCriteria.add($constants.SearchPropertySomLinks, $constants.SearchOpContains, $objGPO)
  $somList = $gpmDomain.SearchSoms($gpmSearchCriteria)
   if($somList.count -eq 0)
     {
      “$($objGPO.id) `t $($objGPO.displayname)”
      $unlinkedGPO +=1
     }
}
if($unlinkedGPO -eq 0)
  {
   New-Line -strin “There are no unlinked GPOs in $domain” -scolor green
  }
exit
} #end Get-UnlinkedGPO

# Entry Point

if($help)      { Get-HelpTopic }
if($examples)  { Get-HelpTopic }
if($full)      { Get-HelpTopic }
if($query)     { Get-UnlinkedGPO }
if(!$query)    { “Missing query.” ; Get-HelpTopic }