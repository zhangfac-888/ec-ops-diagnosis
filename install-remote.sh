#!/usr/bin/env bash
# EC Ops Diagnosis Skill - remote one-line installer (public repo, no auth needed)
# Usage:
#   curl -fsSL https://raw.githubusercontent.com/zhangfac-888/ec-ops-diagnosis/main/install-remote.sh | bash
set -euo pipefail
REPO="zhangfac-888/ec-ops-diagnosis"
TMP="$(mktemp -d)"
trap 'rm -rf "$TMP"' EXIT
echo "Downloading EC Ops Diagnosis Skill ..."
curl -fsSL "https://github.com/$REPO/archive/refs/heads/main.tar.gz" | tar -xz -C "$TMP"
bash "$TMP/ec-ops-diagnosis-main/install.sh"
