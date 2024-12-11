$username = Read-Host 'What username?'
$main_directory = "C:\Users"
$destination = "\\172.20.6.32\Shared Folder\users\computer-swaps"


robocopy $main_directory\$username\Desktop  $destination\$username\Desktop
robocopy $main_directory\$username\Documents  $destination\$username\Documents
robocopy $main_directory\$username\Downloads  $destination\$username\Downloads
robocopy $main_directory\$username\Favorites  $destination\$username\Favorites
robocopy "c:\scans" $destination\$username\scans
Get-ChildItem "C:\Users\$username\appdata\local\Google\Chrome\User Data\Default\Bookmarks" | Copy-Item -Destination "$destination\$username\"


