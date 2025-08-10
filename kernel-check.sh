#!/usr/bin/env bash
set -euo pipefail

# Colors (optional)
ok='\033[1;32m'; warn='\033[1;33m'; bad='\033[1;31m'; dim='\033[2m'; nc='\033[0m'

running="$(uname -r)"

# /lib/modules is usually a symlink to /usr/lib/modules on Arch; either way works.
moddir="$(realpath /lib/modules 2>/dev/null || true)"
if [[ -z "${moddir}" || ! -d "${moddir}" ]]; then
  echo -e "${bad}No kernel modules directory found at /lib/modules.${nc}"
  exit 1
fi

# Find the newest installed kernel version by directory name
latest="$(
  find "$moddir" -mindepth 1 -maxdepth 1 -type d -printf '%f\n' \
    | sort -V | tail -1
)"

if [[ -z "${latest}" ]]; then
  echo -e "${bad}Couldn't determine installed kernel versions under ${moddir}.${nc}"
  exit 1
fi

echo -e "${dim}Modules dir:${nc} ${moddir}"
echo -e "Running kernel : ${ok}${running}${nc}"
echo -e "Newest installed: ${ok}${latest}${nc}"

if [[ "$running" == "$latest" ]]; then
  echo -e "${ok}✅ Running kernel matches the newest installed. No reboot needed.${nc}"
  exit 0
fi

# Compare versions using sort -V
first="$(printf '%s\n%s\n' "$running" "$latest" | sort -V | head -1)"
if [[ "$first" == "$running" ]]; then
  echo -e "${warn}⚠️  Running kernel is older than the newest installed.${nc}"
  echo -e "→ Consider: ${ok}sudo reboot${nc}"
else
  echo -e "${ok}ℹ️  Running kernel is newer than the newest modules dir (unusual but possible).${nc}"
fi
