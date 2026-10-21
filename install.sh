#!/usr/bin/env bash
set -euo pipefail

# インストール先の指定
mapfile -t disks < <(lsblk -ndo NAME,SIZE,TYPE | awk '$3=="disk" && $1!~/^loop/ {print $1, $2}')
echo "== Select target disk =="
for i in "${!disks[@]}"; do
  printf "%2d) /dev/%s (%s)\n" $((i+1)) "$(awk '{print $1}' <<<"${disks[$i]}")" "$(awk '{print $2}' <<<"${disks[$i]}")"
done
read -rp 'Index: ' idx
DISK="/dev/$(awk '{print $1}' <<<"${disks[idx-1]}")"

neet-disk format --device $DISK

neet-disk mount /mnt

#nixos-install --flake .#neet-vm
