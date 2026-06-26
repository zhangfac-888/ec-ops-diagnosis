#!/usr/bin/env node
/**
 * 电商运营诊断 Skill · 跨平台安装器（零依赖，纯 Node）
 *
 * 用法：
 *   npx github:zhangfac-888/ec-ops-diagnosis     # 免发布，直接从 GitHub 装
 *   npx ec-ops-diagnosis                          # 发布到 npm 后
 *   node bin/cli.js                               # 本地 clone 后
 *
 * 行为：把整套 skill 复制进 ~/.claude/skills/电商运营诊断/，
 *       覆盖式安装（先清空目标目录，避免旧版本残留文件）。
 *   --dry-run   只打印将要做什么，不实际写盘
 *   -h/--help   显示帮助
 */
"use strict";

const fs = require("fs");
const os = require("os");
const path = require("path");

const SKILL = "电商运营诊断";
const SRC = path.resolve(__dirname, "..");
const DEST = path.join(os.homedir(), ".claude", "skills", SKILL);

// 安装时不复制进 skill 目录的东西（安装器自身 / 包元数据 / git 元数据）
const EXCLUDE = new Set([
  "bin",
  "node_modules",
  "package.json",
  "package-lock.json",
  ".git",
  ".gitignore",
  ".gitattributes",
  "install.sh",
  "install.ps1",
  "install-remote.sh",
  "install-remote.ps1",
]);

const args = process.argv.slice(2);
if (args.includes("-h") || args.includes("--help")) {
  console.log(
    [
      `电商运营诊断 Skill 安装器`,
      ``,
      `用法：`,
      `  npx github:zhangfac-888/ec-ops-diagnosis`,
      `  npx ec-ops-diagnosis        （发布到 npm 后）`,
      `  node bin/cli.js`,
      ``,
      `选项：`,
      `  --dry-run   只打印将要复制的文件，不写盘`,
      `  -h, --help  显示本帮助`,
      ``,
      `安装位置：${DEST}`,
    ].join("\n")
  );
  process.exit(0);
}
const DRY = args.includes("--dry-run");

let fileCount = 0;

// 手写递归复制：避开 Node 在 Windows 上 fs.cpSync 的偶发 bug
function copyRecursive(from, to) {
  const stat = fs.statSync(from);
  if (stat.isDirectory()) {
    if (!DRY) fs.mkdirSync(to, { recursive: true });
    for (const name of fs.readdirSync(from)) {
      copyRecursive(path.join(from, name), path.join(to, name));
    }
  } else {
    if (!DRY) {
      fs.mkdirSync(path.dirname(to), { recursive: true });
      fs.copyFileSync(from, to);
    }
    fileCount++;
  }
}

function main() {
  console.log(`正在安装「${SKILL}」Skill ...`);

  const entries = fs
    .readdirSync(SRC, { withFileTypes: true })
    .map((d) => d.name)
    .filter((name) => !EXCLUDE.has(name));

  if (entries.length === 0) {
    console.error("❌ 没找到要安装的文件，请确认在 skill 包根目录运行。");
    process.exit(1);
  }

  if (!DRY) {
    // 覆盖式安装：先清空旧目录，避免上个版本删掉的文件残留
    fs.rmSync(DEST, { recursive: true, force: true });
    fs.mkdirSync(DEST, { recursive: true });
  }

  for (const name of entries) {
    if (DRY) console.log(`  + ${name}`);
    copyRecursive(path.join(SRC, name), path.join(DEST, name));
  }

  if (DRY) {
    console.log(`\n（dry-run）共 ${fileCount} 个文件，会装进：${DEST}`);
    return;
  }

  console.log(`✅ 已安装 ${fileCount} 个文件到：${DEST}`);
  console.log("");
  console.log(
    "重启 Claude Code，对它说「跑电商运营诊断」或「给我的产品做个体检」即可调用。"
  );
  console.log(
    "（用 Codex/扣子：把 agents/openai.yaml 一起上传即可一句话唤起。）"
  );
}

try {
  main();
} catch (err) {
  console.error(`❌ 安装失败：${err && err.message ? err.message : err}`);
  process.exit(1);
}
