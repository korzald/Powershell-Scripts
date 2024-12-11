Get-ChildItem -re -in * |
  ?{ -not $_.PSIsContainer } |
  sort Length -descending |
  select -first 10