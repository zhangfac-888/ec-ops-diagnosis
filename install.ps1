# 电商运营诊断 Skill · 一键安装（Windows / Claude Code）
# 用法：在解压后的文件夹里打开 PowerShell，运行：
#   powershell -ExecutionPolicy Bypass -File .\install.ps1
$ErrorActionPreference = "Stop"
$skill = "电商运营诊断"
$src   = $PSScriptRoot
$dest  = Join-Path $HOME ".claude\skills\$skill"

Write-Host "正在安装「$skill」Skill ..." -ForegroundColor Cyan
New-Item -ItemType Directory -Force $dest | Out-Null

# 复制 skill 全部内容，排除安装脚本与 git 元数据
$exclude = @("install.ps1", "install.sh", ".git", ".gitignore")
Get-ChildItem -LiteralPath $src -Force |
  Where-Object { $exclude -notcontains $_.Name } |
  ForEach-Object { Copy-Item -LiteralPath $_.FullName -Destination $dest -Recurse -Force }

Write-Host "✅ 已安装到：$dest" -ForegroundColor Green
Write-Host ""
Write-Host "重启 Claude Code，对它说「跑电商运营诊断」或「给我的产品做个体检」即可调用。"
Write-Host "（用 Codex/扣子：把本目录 agents/openai.yaml 一起上传即可一句话唤起。）"
