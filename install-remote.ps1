# EC Ops Diagnosis Skill - remote one-line installer (public repo, no auth needed)
# Usage:
#   irm https://raw.githubusercontent.com/zhangfac-888/ec-ops-diagnosis/main/install-remote.ps1 | iex
$ErrorActionPreference = "Stop"
$repo = "zhangfac-888/ec-ops-diagnosis"
$tmp  = Join-Path $env:TEMP ("ec-" + [guid]::NewGuid().ToString())
New-Item -ItemType Directory -Force $tmp | Out-Null
$zip = Join-Path $tmp "main.zip"
Write-Host "Downloading EC Ops Diagnosis Skill ..."
Invoke-WebRequest -UseBasicParsing "https://github.com/$repo/archive/refs/heads/main.zip" -OutFile $zip
Expand-Archive -Path $zip -DestinationPath $tmp -Force
powershell -ExecutionPolicy Bypass -File (Join-Path $tmp "ec-ops-diagnosis-main\install.ps1")
