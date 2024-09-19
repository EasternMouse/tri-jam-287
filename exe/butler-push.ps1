[int]$Version = Get-Content "..\src\version.txt"
butler.exe push .\windows\ easternmouse/late-harvest:windows --userversion $Version
butler.exe push .\linux\ easternmouse/late-harvest:linux --userversion $Version
butler.exe push '.\mac\LateHarvest.zip' easternmouse/late-harvest:mac --userversion $Version
butler.exe push .\html5\ easternmouse/late-harvest:html5 --userversion $Version
$Version ++
Set-Content -Path "..\src\version.txt" -Value $Version
Start-Sleep -s 4
butler.exe status easternmouse/late-harvest
Read-Host -Prompt "Press Enter to exit"
