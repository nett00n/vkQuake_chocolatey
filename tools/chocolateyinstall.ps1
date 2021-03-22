$packageName = 'vkQuake'
$toolsPath   = Split-Path $MyInvocation.MyCommand.Definition
$vkQuake_folder = "$(Get-ToolsLocation)\vkQuake"

$packageArgs = @{
  packageName    = $packageName
  url            = "https://github.com/Novum/vkQuake/releases/download/1.05.2/vkquake-1.05.2_win64.zip"
  checksum       = "b7e5ed30a6369a3c2c31ce04dd74ebab064a0038db709cfcc661f70e8a1cb7a9"
  url64          = "https://github.com/Novum/vkQuake/releases/download/1.05.2/vkquake-1.05.2_win32.zip"
  checksum64     = "06920832fcd726e74274bd2c4d48e507879fc1ac7ae23cd4eacbbfcd3f9d9a21"
  checksumType   = 'sha256'
  unzipLocation  = $toolsPath
}
Install-ChocolateyZipPackage @packageArgs

$vkQuake_latest = (Get-ChildItem $toolsPath -Recurse -ErrorAction SilentlyContinue | Where-Object {$_.Name -like 'vkquake-*'} | sort-Object {$_.CreationTime} | select-Object -First 1).FullName
Robocopy "$vkQuake_latest" "$vkQuake_folder" /R:0 /W:0 /E /XO
Remove-Item "$vkQuake_latest" -Recurse -Force -ErrorAction SilentlyContinue

Install-ChocolateyShortcut -shortcutFilePath "$env:ALLUSERSPROFILE\Microsoft\Windows\Start Menu\Programs\vkQuake.lnk" "$vkQuake_folder\vkQuake.exe" -WorkingDirectory "$vkQuake_folder"
