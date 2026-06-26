# 电商运营诊断 Skill · 一键安装（Windows / Claude Code）
# 用法：在解压后的文件夹里打开 PowerShell，运行：
#   powershell -ExecutionPolicy Bypass -File .\install.ps1
$ErrorActionPreference = "Stop"
$skill = "电商运营诊断"
$src   = $PSScriptRoot
$dest  = Join-Path $HOME ".claude\skills\$skill"

Write-Host "正在安装「$skill」Skill ..." -ForegroundColor Cyan
# 覆盖式安装：先清空旧目录，避免上个版本删掉的文件残留
if (Test-Path -LiteralPath $dest) { Remove-Item -LiteralPath $dest -Recurse -Force }
New-Item -ItemType Directory -Force $dest | Out-Null

# 复制 skill 全部内容，排除安装脚本、包元数据与 git 元数据
$exclude = @(
  "install.ps1", "install.sh", "install-remote.ps1", "install-remote.sh",
  "bin", "node_modules", "package.json", "package-lock.json",
  ".git", ".gitignore", ".gitattributes"
)
Get-ChildItem -LiteralPath $src -Force |
  Where-Object { $exclude -notcontains $_.Name } |
  ForEach-Object { Copy-Item -LiteralPath $_.FullName -Destination $dest -Recurse -Force }

Write-Host "✅ 已安装到：$dest" -ForegroundColor Green
Write-Host ""
Write-Host "重启 Claude Code，对它说「跑电商运营诊断」或「给我的产品做个体检」即可调用。"
Write-Host "（用 Codex/扣子：把本目录 agents/openai.yaml 一起上传即可一句话唤起。）"
