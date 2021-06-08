from jinja2 import Template
from re import split
import hashlib
import os
import requests


def main():
    global github_prefix
    github_prefix = "https://github.com/"
    github_user = "Novum"
    github_repo = "vkQuake"

    github_html_data_lines = get_data_from_github(github_user, github_repo)
    latest_version = get_latest_version_from_html(github_html_data_lines)
    win64_url = get_download_url_from_html("win64", github_html_data_lines, latest_version)
    win32_url = get_download_url_from_html("win32", github_html_data_lines, latest_version)
    win64_hashsum = get_sha256_from_url(win64_url)
    win32_hashsum = get_sha256_from_url(win32_url)
    render_choco_files(latest_version, win64_url, win32_url, win64_hashsum, win32_hashsum)

def get_sha256_from_url(url):
    r = requests.get(url)
    with open('tmp_file', 'wb') as f:
        f.write(r.content)
    with open('tmp_file',"rb") as f:
        bytes = f.read()
        readable_hash = hashlib.sha256(bytes).hexdigest();
    if os.path.exists('tmp_file'):
        os.remove('tmp_file')
    return(readable_hash)

def render_choco_files(latest_version, win64_url, win32_url, win64_hashsum, win32_hashsum):
    nuspec_xml = define_nuspec_template()
    nuspec_xml_text = nuspec_xml.render(latest_version = latest_version)
    # print(nuspec_xml_text)
    file = open('vkquake.nuspec', 'w')
    file.write(nuspec_xml_text)
    file.close()
    chocolateyinstall_ps1 = define_chocolateinstall_template()
    chocolateyinstall_ps1_text = chocolateyinstall_ps1.render(win64_url = win64_url, win64_hashsum = win64_hashsum, win32_url = win32_url, win32_hashsum = win32_hashsum,)
    file = open('tools/chocolateyinstall.ps1', 'w')
    file.write(chocolateyinstall_ps1_text)
    file.close()
    # print(chocolateyinstall_ps1_text)

def define_nuspec_template():
    template_text ="""<?xml version="1.0"?>
<package xmlns="http://schemas.microsoft.com/packaging/2011/08/nuspec.xsd">
  <metadata>
    <id>vkQuake</id>
    <version>{{ latest_version }}</version>
    <title>vkQuake (Install)</title>
    <authors>Novum</authors>
    <owners>nett00n</owners>
    <licenseUrl>https://github.com/Novum/vkQuake/blob/master/LICENSE.txt</licenseUrl>
    <projectUrl>https://github.com/Novum/vkQuake</projectUrl>
    <iconUrl>https://rawcdn.githack.com/nett00n/vkQuake_chocolatey/b5016b97892e64a240198a0bd16690b42ed441a1/quake-vulkan.png</iconUrl>
    <requireLicenseAcceptance>false</requireLicenseAcceptance>
    <description>Vulkan Quake port based on QuakeSpasm </description>
    <summary>
      vkQuake is a Quake 1 port using Vulkan instead of OpenGL for rendering. It is based on the popular QuakeSpasm port and runs all mods compatible with it like Arcane Dimensions. Due to the port using Vulkan and other optimizations it can achieve much better frame rates.

      Compared to QuakeSpasm vkQuake also features a software Quake like underwater effect, has better color precision, generates mipmap for water surfaces at runtime and has native support for anti-aliasing and AF. Furthermore frame rates above 72FPS do not break physics.

      vkQuake also serves as a Vulkan demo application that shows basic usage of the API. For example it demonstrates render passes and sub passes, pipeline barriers and synchronization, compute shaders, push and specialization constants, CPU/GPU parallelism and memory pooling.
    </summary>
    <releaseNotes>https://github.com/Novum/vkQuake/releases</releaseNotes>
    <copyright>Novum</copyright>
    <tags>quake engine game id portable</tags>
    <projectSourceUrl>https://github.com/Novum/vkQuake</projectSourceUrl>
    <packageSourceUrl>https://github.com/nett00n/vkQuake_chocolatey</packageSourceUrl>
    <bugTrackerUrl>https://github.com/Novum/vkQuake/issues</bugTrackerUrl>
  </metadata>
  <files>
    <file src="tools\\*.ps1" target="tools"/>
  </files>
</package>
    """
    jinja_template = Template(template_text)
    return(jinja_template)

def define_chocolateinstall_template():
    template_text = '''$packageName = 'vkQuake'
$toolsPath   = Split-Path $MyInvocation.MyCommand.Definition
$vkQuake_folder = "$(Get-ToolsLocation)\\vkQuake"

$packageArgs = @{
  packageName    = $packageName
  url64          = "{{ win64_url }}"
  checksum64     = "{{ win64_hashsum }}"
  url            = "{{ win32_url }}"
  checksum       = "{{ win32_hashsum }}"
  checksumType   = 'sha256'
  unzipLocation  = $toolsPath
}
Install-ChocolateyZipPackage @packageArgs

$vkQuake_latest = (Get-ChildItem $toolsPath -Recurse -ErrorAction SilentlyContinue | Where-Object {$_.Name -like 'vkquake-*'} | sort-Object {$_.CreationTime} | select-Object -First 1).FullName
Robocopy "$vkQuake_latest" "$vkQuake_folder" /R:0 /W:0 /E /XO
Remove-Item "$vkQuake_latest" -Recurse -Force -ErrorAction SilentlyContinue

Install-ChocolateyShortcut -shortcutFilePath "$env:ALLUSERSPROFILE\\Microsoft\\Windows\\Start Menu\\Programs\\vkQuake.lnk" "$vkQuake_folder\\vkQuake.exe" -WorkingDirectory "$vkQuake_folder"

    '''
    jinja_template = Template(template_text)
    return(jinja_template)

def get_data_from_github(github_user, github_repo):
    github_postfix = "/releases"
    RemoteURL = github_prefix + github_user + "/" + github_repo + github_postfix
    RemoteData = requests.get(RemoteURL)
    lines = RemoteData.text
    return(lines.split("\n"))


def get_download_url_from_html(keyphrase, github_html_data_lines, version):

    for line in github_html_data_lines:
        if "href" not in line:
            continue
        if "/releases/" not in line:
            continue
        if "download" not in line:
            continue
        if version not in line:
            continue
        fields = line.split('"')
        if keyphrase not in line:
            continue
        url = github_prefix + fields[1]
        return(url)

def get_latest_version_from_html(github_html_data_lines):
    version = ''

    for line in github_html_data_lines:
        if "href" not in line:
            continue
        if "/releases/" not in line:
            continue
        if "/tag/" in line:
            test1 = line.split('"')
            test2 = test1[1].split('/')
            version = test2[-1]
            return(version)


if __name__ == "__main__":
    main()