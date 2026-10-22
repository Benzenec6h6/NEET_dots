#!/usr/bin/env bash
set -euo pipefail

# 1. カレントディレクトリの Flake から、neet-vm 用の neet-disk をビルド
echo "== Building diskTool for target =="
DISK_TOOL=$(nix build --no-link --print-out-paths .#nixosConfigurations.neet-vm.config.system.build.diskTool)
NEET_DISK="$DISK_TOOL/bin/neet-disk"

# 2. インストール先の指定
mapfile -t disks < <(lsblk -ndo NAME,SIZE,TYPE | awk '$3=="disk" && $1!~/^loop/ {print $1, $2}')
echo "== Select target disk =="
for i in "${!disks[@]}"; do
  printf "%2d) /dev/%s (%s)\n" $((i+1)) "$(awk '{print $1}' <<<"${disks[$i]}")" "$(awk '{print $2}' <<<"${disks[$i]}")"
done
read -rp 'Index: ' idx
DISK="/dev/$(awk '{print $1}' <<<"${disks[idx-1]}")"

# 3. ビルドした neet-disk を使ってフォーマット＆マウント
"$NEET_DISK" format --device "$DISK"

"$NEET_DISK" mount /mnt

#neet-install --flake .#neet-vm
