$packageName = 'vkQuake'
$url64       = 'https://github.com/Novum/vkQuake/releases/download/1.05.2/vkquake-1.05.2_win64.zip'
$checksum64  = 'b7e5ed30a6369a3c2c31ce04dd74ebab064a0038db709cfcc661f70e8a1cb7a9'
$url32       = 'https://github.com/Novum/vkQuake/releases/download/1.05.2/vkquake-1.05.2_win32.zip'
$checksum32  = '06920832fcd726e74274bd2c4d48e507879fc1ac7ae23cd4eacbbfcd3f9d9a21'
$toolsPath   = Split-Path $MyInvocation.MyCommand.Definition
$vkQuake_folder = "$(Get-ToolsLocation)\vkQuake"

try {
  $processor = Get-WmiObject Win32_Processor
  $is64bit = $processor.AddressWidth -eq 64
  $is32bit = $processor.AddressWidth -eq 32
  if($is32bit) {
    $packageArgs = @{
      packageName    = $packageName
      url            = $url32
      checksum       = $checksum32
      checksumType   = 'sha256'
      unzipLocation  = $toolsPath
    }
    Install-ChocolateyZipPackage @packageArgs
  }

  if($is64bit) {
    $packageArgs = @{
      packageName    = $packageName
      url            = $url64
      checksum       = $checksum64
      checksumType   = 'sha256'
      unzipLocation  = $toolsPath
    }
    Install-ChocolateyZipPackage @packageArgs
  }

  # the following is all part of error handling
  Write-ChocolateySuccess $packageName
} catch {
  Write-ChocolateyFailure $packageName "$($_.Exception.Message)"
  throw
}


If (Get-Item "$env:ChocolateyInstall\lib-bkp\vkQuake\tools\vkQuake\vkQuake.exe" -ErrorAction SilentlyContinue) {
	Write-Output "Migrating vkQuake location to $vkQuake_folder"
	Move-Item "$env:ChocolateyInstall\lib-bkp\vkQuake\tools\vkQuake" "$(Get-ToolsLocation)" -Force
	Remove-Item "$env:ChocolateyInstall\lib\vkQuake\tools\vkQuake" -Recurse -Force -ErrorAction SilentlyContinue
}

$vkQuake_latest = (Get-ChildItem $toolsPath -Recurse -ErrorAction SilentlyContinue | Where-Object {$_.Name -like 'vkquake-*'} | sort-Object {$_.CreationTime} | select-Object -First 1).FullName
Robocopy "$vkQuake_latest" "$vkQuake_folder" /R:0 /W:0 /E /XO
Remove-Item "$vkQuake_latest" -Recurse -Force -ErrorAction SilentlyContinue

Install-ChocolateyShortcut -shortcutFilePath "$env:ALLUSERSPROFILE\Microsoft\Windows\Start Menu\Programs\vkQuake.lnk" "$vkQuake_folder\vkQuake.exe" -WorkingDirectory "$vkQuake_folder"
