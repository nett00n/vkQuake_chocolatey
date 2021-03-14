$ErrorActionPreference = 'Stop'

$packageName = 'vkQuake_x64'
$url32       = 'https://github.com/Novum/vkQuake/releases/download/1.05.2/vkquake-1.05.2_win64.zip'
$checksum32  = 'B7E5ED30A6369A3C2C31CE04DD74EBAB064A0038DB709CFCC661F70E8A1CB7A9'
$toolsPath   = Split-Path $MyInvocation.MyCommand.Definition
$vkQuake_x64_folder = "$(Get-ToolsLocation)\vkQuake_x64"

$packageArgs = @{
  packageName    = $packageName
  url            = $url32
  checksum       = $checksum32
  checksumType   = 'sha256'
  unzipLocation  = $toolsPath
}

If (Get-Item "$env:ChocolateyInstall\lib-bkp\vkQuake_x64\tools\vkQuake_x64\vkQuake_x64.exe" -ErrorAction SilentlyContinue) {
	Write-Output "Migrating vkQuake_x64 location to $vkQuake_x64_folder"
	Move-Item "$env:ChocolateyInstall\lib-bkp\vkQuake_x64\tools\vkQuake_x64" "$(Get-ToolsLocation)" -Force
	Remove-Item "$env:ChocolateyInstall\lib\vkQuake_x64\tools\vkQuake_x64" -Recurse -Force -ErrorAction SilentlyContinue
}

Install-ChocolateyZipPackage @packageArgs

$latest = (Get-ChildItem $toolsPath -Recurse -ErrorAction SilentlyContinue | Where-Object {$_.Name -like 'vkquake-*'} | sort-Object {$_.CreationTime} | select-Object -First 1).FullName
Robocopy "$latest" "$vkQuake_x64_folder" /R:0 /W:0 /E /XO
Remove-Item "$latest" -Recurse -Force -ErrorAction SilentlyContinue

Install-ChocolateyShortcut -shortcutFilePath "$env:ALLUSERSPROFILE\Microsoft\Windows\Start Menu\Programs\vkQuake x64.lnk" "$vkQuake_x64_folder\vkQuake.exe" -WorkingDirectory "$vkQuake_x64_folder"
