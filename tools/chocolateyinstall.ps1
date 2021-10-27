$packageName = 'vkQuake'
$toolsPath   = Split-Path $MyInvocation.MyCommand.Definition
$vkQuake_folder = "$(Get-ToolsLocation)\vkQuake"

$packageArgs = @{
  packageName    = $packageName
  url64          = "https://github.com//Novum/vkQuake/releases/download/1.11.1/vkquake-1.11.1_win64.zip"
  checksum64     = "34e929c2ee8a61ba846ff6393f7dbaba3b5ac6206db657cb19b15738bd05f5c8"
  url            = "https://github.com//Novum/vkQuake/releases/download/1.11.1/vkquake-1.11.1_win32.zip"
  checksum       = "808a36f4ea7e6d6737cbc8c280145d8d294d8e12eed27a086550f4fe930d3b7e"
  checksumType   = 'sha256'
  unzipLocation  = $toolsPath
}
Install-ChocolateyZipPackage @packageArgs

$vkQuake_latest = (Get-ChildItem $toolsPath -Recurse -ErrorAction SilentlyContinue | Where-Object {$_.Name -like 'vkquake-*'} | sort-Object {$_.CreationTime} | select-Object -First 1).FullName
Robocopy "$vkQuake_latest" "$vkQuake_folder" /R:0 /W:0 /E /XO
Remove-Item "$vkQuake_latest" -Recurse -Force -ErrorAction SilentlyContinue

Install-ChocolateyShortcut -shortcutFilePath "$env:ALLUSERSPROFILE\Microsoft\Windows\Start Menu\Programs\vkQuake.lnk" "$vkQuake_folder\vkQuake.exe" -WorkingDirectory "$vkQuake_folder"