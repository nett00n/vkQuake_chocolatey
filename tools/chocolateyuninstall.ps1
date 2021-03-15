$icon_name = (Get-ChildItem "$env:ALLUSERSPROFILE\Microsoft\Windows\Start Menu\Programs" -Filter "vkQuake.lnk" -ErrorAction SilentlyContinue).FullName
$vkQuake_folder = "$(Get-ToolsLocation)\vkQuake"
Remove-Item $icon_name -ErrorAction SilentlyContinue
Remove-Item -Recurse -Force $vkQuake_folder
