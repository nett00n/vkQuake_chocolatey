$packageName = 'vkQuake'
$toolsPath   = Split-Path $MyInvocation.MyCommand.Definition
$vkQuake_folder = "$(Get-ToolsLocation)\vkQuake"

$packageArgs = @{
  packageName    = $packageName
  url64          = "https://github.com//Novum/vkQuake/releases/download/1.12.2/vkquake-1.12.2_win64.zip"
  checksum64     = "49304558a6afebf912b3e231c958eb0ac7531947736d3c6ddbc4c211f1ea7a41"
  url            = "https://github.com//Novum/vkQuake/releases/download/1.12.2/vkquake-1.12.2_win32.zip"
  checksum       = "c5cca583cea3701157e9b38b0ef6c8f993720842cfb73db43a8deea32a454949"
  checksumType   = 'sha256'
  unzipLocation  = $toolsPath
}
Install-ChocolateyZipPackage @packageArgs

$vkQuake_latest = (Get-ChildItem $toolsPath -Recurse -ErrorAction SilentlyContinue | Where-Object {$_.Name -like 'vkquake-*'} | sort-Object {$_.CreationTime} | select-Object -First 1).FullName
Robocopy "$vkQuake_latest" "$vkQuake_folder" /R:0 /W:0 /E /XO
Remove-Item "$vkQuake_latest" -Recurse -Force -ErrorAction SilentlyContinue

Install-ChocolateyShortcut -shortcutFilePath "$env:ALLUSERSPROFILE\Microsoft\Windows\Start Menu\Programs\vkQuake.lnk" "$vkQuake_folder\vkQuake.exe" -WorkingDirectory "$vkQuake_folder"