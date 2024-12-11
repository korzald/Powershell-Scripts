# Version 3 corrects not having a lowercase letter and what happens if a user doesn't have a atleast 4 letters in the last name.
# Get the info
$first_name = Read-Host -Prompt "Enter Users First Name"
$first_name_l = $first_name.ToLower()
$last_name = Read-Host -Prompt "Enter Users Last Name"
$last_name_l = $last_name.ToLower()
$title = Read-Host -Prompt "Enter Title"
$report = Read-Host -Prompt "Enter name of Report to"
$last4 = Read-Host -Prompt "Enter Last 4 of SSN"
$full_name = "$first_name $last_name"

$first_inital = $first_name_l[0]
$first_4 = $last_name_l[0..3] -join''
$Username1 = "$first_name_l.$last_name_l"
$Username2 = $first_inital + $last_name_l

# Define the departments
$choice1 = New-Object System.Management.Automation.Host.ChoiceDescription "&wtxretina", "wtxretina"
$choice2 = New-Object System.Management.Automation.Host.ChoiceDescription "&ntxretina", "ntxretina"
$choice3 = New-Object System.Management.Automation.Host.ChoiceDescription "&asc", "asc"
$choice4 = New-Object System.Management.Automation.Host.ChoiceDescription "&icr", "icr"
$choice5 = New-Object System.Management.Automation.Host.ChoiceDescription "&srg", "srg"

# Create an array of the choices
$options = [System.Management.Automation.Host.ChoiceDescription[]]($choice1, $choice2, $choice3, $choice4, $choice5)

# Define the prompt
$title_1 = "Choose an Option"
$message = "Please select one of the following options:"

# Prompt the user for a choice
$result = $host.ui.PromptForChoice($title_1, $message, $options, 0)

# Handle the user's choice
switch ($result) {
    0 { $company = "wtxretina.com" }
    1 { $company = "ntxretina.com" }
    2 { $company = "asc1tx.com" }
    3 { $company = "txicr.com" }
    4 { $company = "txsrg.com" }
    
}

$email = $Username1 + "@" + $company


# Generate 4 random letters for passwords.
$TokenSet = @{
    U = [Char[]]'ABCDEFGHIJKLMNOPQRSTUVWXYZ'
    L = [Char[]]'abcdefghijklmnopqrstuvwxyz'
}
    
$Upper = Get-Random -Count 5 -InputObject $TokenSet.U
$Lower = Get-Random -Count 5 -InputObject $TokenSet.L

$StringSet = $Upper +$Lower 

$random_4 = (Get-Random -Count 4 -InputObject $StringSet) -join ''

$password_1 = $random_4 + $last4 +"!!"

$password_2 = $first_4 + $last4


# Word Document creation 

$word = New-Object -ComObject Word.Application
$word.Visible = $true

$doc = $word.Documents.Add()

$selection = $word.selection
$selection.WholeStory
$selection.Style = "No Spacing"

$selection = $word.Selection

$selection.TypeText("Employee: $full_name")

$selection.ParagraphFormat.Alignment = [Microsoft.Office.Interop.Word.WdParagraphAlignment]::wdAlignParagraphCenter

$Selection.TypeParagraph()

$selection.TypeText("Title: $title")

$selection.ParagraphFormat.Alignment = [Microsoft.Office.Interop.Word.WdParagraphAlignment]::wdAlignParagraphCenter

$Selection.TypeParagraph()

$selection.TypeText("Email Address: $email")

$selection.ParagraphFormat.Alignment = [Microsoft.Office.Interop.Word.WdParagraphAlignment]::wdAlignParagraphCenter

$Selection.TypeParagraph()

$selection.TypeText("Reports to: $report")

$selection.ParagraphFormat.Alignment = [Microsoft.Office.Interop.Word.WdParagraphAlignment]::wdAlignParagraphCenter

$Selection.TypeParagraph()

$selection.TypeText("---------------------------------------------------- Login Information ------------------------------------------------")

$selection.ParagraphFormat.Alignment = [Microsoft.Office.Interop.Word.WdParagraphAlignment]::wdAlignParagraphCenter

$Selection.TypeParagraph()

$Selection.Font.Bold = 1
$Selection.Font.Underline = 1

$selection.TypeText("Web Email: $Username1")

$selection.ParagraphFormat.Alignment = [Microsoft.Office.Interop.Word.WdParagraphAlignment]::wdAlignParagraphLeft

$Selection.TypeParagraph()
$Selection.TypeParagraph()

$Selection.Font.Bold = 1
$Selection.Font.Underline = 1

$selection.TypeText("Computer Logon")

$Selection.TypeParagraph()

$Selection.Font.Bold = 0
$Selection.Font.Underline = 0
$selection.TypeText("User: $Username1")

$Selection.TypeParagraph()

$selection.TypeText("Password: $password_1")

$Selection.TypeParagraph()
$Selection.TypeParagraph()
$Selection.TypeParagraph()

$Selection.Font.Bold = 1
$Selection.Font.Underline = 1

$selection.TypeText("AllScripts")

$Selection.TypeParagraph()
$Selection.Font.Bold = 0
$Selection.Font.Underline = 0
$selection.TypeText("User: $Username2")

$Selection.TypeParagraph()

$selection.TypeText("Password: $password_1")

$Selection.TypeParagraph()
$Selection.TypeParagraph()
$Selection.TypeParagraph()

$Selection.Font.Bold = 1
$Selection.Font.Underline = 1

$selection.TypeText("MDI")

$Selection.TypeParagraph()

$Selection.Font.Bold = 0
$Selection.Font.Underline = 0

$selection.TypeText("Account: wtxretina")

$Selection.TypeParagraph()

$selection.TypeText("User: $email")

$Selection.TypeParagraph()

$selection.TypeText("Password: This will come in email")

$Selection.TypeParagraph()
$Selection.TypeParagraph()
$Selection.TypeParagraph()

$Selection.Font.Bold = 1
$Selection.Font.Underline = 1

$selection.TypeText("Paystub")
$Selection.TypeParagraph()
$selection.TypeText("WaspTime")

$Selection.TypeParagraph()

$Selection.Font.Bold = 0
$Selection.Font.Underline = 0

$selection.TypeText("Login: $Username1")

$Selection.TypeParagraph()

$selection.TypeText("Password: $password_2")

$Selection.TypeParagraph()
$Selection.TypeParagraph()
$Selection.TypeParagraph()

$Selection.Font.Bold = 1
$Selection.Font.Underline = 1
$selection.TypeText("Brane")

$Selection.TypeParagraph()
$Selection.Font.Bold = 0
$Selection.Font.Underline = 0
$selection.TypeText("Login: $Username2")

$Selection.TypeParagraph()

$selection.TypeText("Password: $password_1")

$Selection.TypeParagraph()
$Selection.TypeParagraph()
$Selection.TypeParagraph()

$Selection.Font.Bold = 1
$Selection.Font.Underline = 1

$selection.TypeText("Healthicity")

$Selection.TypeParagraph()
$Selection.Font.Bold = 0
$Selection.Font.Underline = 0
$selection.TypeText("Login: $email")

$Selection.TypeParagraph()

$selection.TypeText("Password: You will create this yourself.")
$Selection.TypeParagraph()
$Selection.TypeParagraph()
$Selection.TypeParagraph()

$selection.TypeText("Badge number: $last4")






#$doc.SaveAs([ref]"c:\scripts\output.docx")
#$doc.Close()
#$word.quit()