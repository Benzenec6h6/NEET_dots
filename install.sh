#!/usr/bin/env bash
set -euo pipefail

#インストール時にセキュアブートの下地を完成させれないか検証
sbctl create-keys

mkdir -p /mnt/var/lib
cp -a /var/lib/sbctl /mnt/var/lib/

chmod 0700 /mnt/var/lib/sbctl/keys

# 1. インストール先の指定（ユーザーに対話式で選ばせる）
mapfile -t disks < <(lsblk -ndo NAME,SIZE,TYPE | awk '$3=="disk" && $1!~/^loop/ {print $1, $2}')
echo "== Select target disk =="
for i in "${!disks[@]}"; do
  printf "%2d) /dev/%s (%s)\n" $((i+1)) "$(awk '{print $1}' <<<"${disks[$i]}")" "$(awk '{print $2}' <<<"${disks[$i]}")"
done
read -rp 'Index: ' idx
DISK="/dev/$(awk '{print $1}' <<<"${disks[idx-1]}")"

# 2. 本丸の neet-install を呼び出す
# （※ --device フラグをつけて渡す）
neet-install --flake .#neet-vm --device "$DISK"
