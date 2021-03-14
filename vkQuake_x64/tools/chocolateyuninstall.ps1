$icon_name = (Get-ChildItem "$env:ALLUSERSPROFILE\Microsoft\Windows\Start Menu\Programs" -Filter "vkQuake x64.lnk" -ErrorAction SilentlyContinue).FullName
$vkQuake_x64_folder = "$(Get-ToolsLocation)\vkQuake_x64"
Remove-Item $icon_name -ErrorAction SilentlyContinue
Remove-Item -Recurse -Force $vkQuake_x64_folder