#!/bin/bash

# Script to remove Windows Boot entry from GRUB menu
# Author: Antigravity

# Ensure root privileges
if [ "$EUID" -ne 0 ]; then
  echo "Please run as root (use sudo)."
  exit 1
fi

echo "--- GRUB Windows Boot Entry Removal Tool ---"

# 1. Option A: Disable os-prober (Safest, won't search for other OSs)
GRUB_DEFAULT_FILE="/etc/default/grub"
if grep -q "^GRUB_DISABLE_OS_PROBER=" "$GRUB_DEFAULT_FILE"; then
  sed -i 's/^GRUB_DISABLE_OS_PROBER=.*/GRUB_DISABLE_OS_PROBER=true/' "$GRUB_DEFAULT_FILE"
else
  echo "GRUB_DISABLE_OS_PROBER=true" >> "$GRUB_DEFAULT_FILE"
fi
echo "[+] Set GRUB_DISABLE_OS_PROBER=true in $GRUB_DEFAULT_FILE"

# 2. Option B: Remove Windows Boot Files from EFI partition (More thorough)
EFI_MOUNT=$(lsblk -o MOUNTPOINT | grep "/boot/efi" | head -n 1)
if [ -d "$EFI_MOUNT/EFI/Microsoft" ]; then
    echo "[!] Found Windows EFI files at $EFI_MOUNT/EFI/Microsoft"
    # Back up instead of delete, just to be safe
    BACKUP_DIR="${EFI_MOUNT}/EFI/Microsoft.bak-$(date +%s)"
    mv "$EFI_MOUNT/EFI/Microsoft" "$BACKUP_DIR"
    echo "[+] Moved Windows EFI files to $BACKUP_DIR"
else
    echo "[*] No Microsoft EFI folder found at $EFI_MOUNT/EFI/Microsoft"
fi

# 3. Update GRUB configuration
echo "--- Updating GRUB configuration ---"
if command -v update-grub &> /dev/null; then
    update-grub
elif command -v grub-mkconfig &> /dev/null; then
    grub-mkconfig -o /boot/grub/grub.cfg
else
    echo "[!] Could not find update-grub or grub-mkconfig tool. Please update GRUB manually."
    exit 1
fi

echo "--- Done! ---"
echo "Windows引导已移除。重启后 GRUB 菜单将不再显示 Windows 选项。"
