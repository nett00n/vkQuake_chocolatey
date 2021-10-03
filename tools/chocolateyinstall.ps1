$packageName = 'vkQuake'
$toolsPath   = Split-Path $MyInvocation.MyCommand.Definition
$vkQuake_folder = "$(Get-ToolsLocation)\vkQuake"

$packageArgs = @{
  packageName    = $packageName
  url64          = "https://github.com//Novum/vkQuake/releases/download/1.11.0/vkquake-1.11.0_win64.zip"
  checksum64     = "5d447e3b907d7acb8dea201470d76afbe517d064def140e6e5cf0c63f5462dfe"
  url            = "https://github.com//Novum/vkQuake/releases/download/1.11.0/vkquake-1.11.0_win32.zip"
  checksum       = "9fef0f3e9e77a7ec378cd8f6c8046ddb56846b80dd8cf3bde0ceb0575634fd89"
  checksumType   = 'sha256'
  unzipLocation  = $toolsPath
}
Install-ChocolateyZipPackage @packageArgs

$vkQuake_latest = (Get-ChildItem $toolsPath -Recurse -ErrorAction SilentlyContinue | Where-Object {$_.Name -like 'vkquake-*'} | sort-Object {$_.CreationTime} | select-Object -First 1).FullName
Robocopy "$vkQuake_latest" "$vkQuake_folder" /R:0 /W:0 /E /XO
Remove-Item "$vkQuake_latest" -Recurse -Force -ErrorAction SilentlyContinue

Install-ChocolateyShortcut -shortcutFilePath "$env:ALLUSERSPROFILE\Microsoft\Windows\Start Menu\Programs\vkQuake.lnk" "$vkQuake_folder\vkQuake.exe" -WorkingDirectory "$vkQuake_folder"