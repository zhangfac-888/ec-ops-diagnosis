#!/usr/bin/env bash
# 电商运营诊断 Skill · 一键安装（macOS / Linux / Claude Code）
# 用法：在解压后的文件夹里运行：  bash install.sh
set -euo pipefail
SKILL="电商运营诊断"
SRC="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DEST="$HOME/.claude/skills/$SKILL"

echo "正在安装「$SKILL」Skill ..."
mkdir -p "$DEST"

if command -v rsync >/dev/null 2>&1; then
  rsync -a --delete \
    --exclude install.sh --exclude install.ps1 \
    --exclude install-remote.sh --exclude install-remote.ps1 \
    --exclude bin --exclude node_modules \
    --exclude package.json --exclude package-lock.json \
    --exclude '.git' --exclude '.gitignore' --exclude '.gitattributes' \
    "$SRC"/ "$DEST"/
else
  cp -R "$SRC"/. "$DEST"/
  rm -f "$DEST"/install.sh "$DEST"/install.ps1 \
        "$DEST"/install-remote.sh "$DEST"/install-remote.ps1 \
        "$DEST"/package.json "$DEST"/package-lock.json \
        "$DEST"/.gitignore "$DEST"/.gitattributes
  rm -rf "$DEST"/bin "$DEST"/node_modules "$DEST"/.git
fi

echo "✅ 已安装到：$DEST"
echo ""
echo "重启 Claude Code，对它说「跑电商运营诊断」或「给我的产品做个体检」即可调用。"
echo "（用 Codex/扣子：把本目录 agents/openai.yaml 一起上传即可一句话唤起。）"
