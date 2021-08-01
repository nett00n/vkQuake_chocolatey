$packageName = 'vkQuake'
$toolsPath   = Split-Path $MyInvocation.MyCommand.Definition
$vkQuake_folder = "$(Get-ToolsLocation)\vkQuake"

$packageArgs = @{
  packageName    = $packageName
  url64          = "https://github.com//Novum/vkQuake/releases/download/1.10.0-beta3/vkquake-1.10.0-beta3_win64.zip"
  checksum64     = "439c61f57f3f06b67ffbefda3bf1179621a9b8f2ba159c42921620c7f4cad6fa"
  url            = "https://github.com//Novum/vkQuake/releases/download/1.10.0-beta3/vkquake-1.10.0-beta3_win32.zip"
  checksum       = "a1f8d4698d70b9d6a97ae0d68b0e17caa43f04cb8b211c51703411a13c254bc5"
  checksumType   = 'sha256'
  unzipLocation  = $toolsPath
}
Install-ChocolateyZipPackage @packageArgs

$vkQuake_latest = (Get-ChildItem $toolsPath -Recurse -ErrorAction SilentlyContinue | Where-Object {$_.Name -like 'vkquake-*'} | sort-Object {$_.CreationTime} | select-Object -First 1).FullName
Robocopy "$vkQuake_latest" "$vkQuake_folder" /R:0 /W:0 /E /XO
Remove-Item "$vkQuake_latest" -Recurse -Force -ErrorAction SilentlyContinue

Install-ChocolateyShortcut -shortcutFilePath "$env:ALLUSERSPROFILE\Microsoft\Windows\Start Menu\Programs\vkQuake.lnk" "$vkQuake_folder\vkQuake.exe" -WorkingDirectory "$vkQuake_folder"