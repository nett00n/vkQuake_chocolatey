$packageName = 'vkQuake'
$toolsPath   = Split-Path $MyInvocation.MyCommand.Definition
$vkQuake_folder = "$(Get-ToolsLocation)\vkQuake"

$packageArgs = @{
  packageName    = $packageName
  url64          = "https://github.com//Novum/vkQuake/releases/download/1.05.3/vkquake-1.05.3_win64.zip"
  checksum64     = "52c9cfc2821d5685afca7c7494e4db2f60ae7853072d1917ae4bd2f091e39f8a"
  url            = "https://github.com//Novum/vkQuake/releases/download/1.05.3/vkquake-1.05.3_win32.zip"
  checksum       = "cb2c4227650fd080cd3bc861b6b97840409c8d84829f595ac25a50573108ca85"
  checksumType   = 'sha256'
  unzipLocation  = $toolsPath
}
Install-ChocolateyZipPackage @packageArgs

$vkQuake_latest = (Get-ChildItem $toolsPath -Recurse -ErrorAction SilentlyContinue | Where-Object {$_.Name -like 'vkquake-*'} | sort-Object {$_.CreationTime} | select-Object -First 1).FullName
Robocopy "$vkQuake_latest" "$vkQuake_folder" /R:0 /W:0 /E /XO
Remove-Item "$vkQuake_latest" -Recurse -Force -ErrorAction SilentlyContinue

Install-ChocolateyShortcut -shortcutFilePath "$env:ALLUSERSPROFILE\Microsoft\Windows\Start Menu\Programs\vkQuake.lnk" "$vkQuake_folder\vkQuake.exe" -WorkingDirectory "$vkQuake_folder"

    