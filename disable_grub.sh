#!/bin/bash

# Script to disable GRUB menu and set timeout to 0
# Based on the operations performed to fix persistent GRUB menu

GRUB_CONFIG="/etc/default/grub"
BACKUP_CONFIG="/etc/default/grub.bak"

# Ensure the script is run with sudo
if [ "$EUID" -ne 0 ]; then
  echo "Please run as root (use sudo)"
  exit 1
fi

echo "Creating backup of $GRUB_CONFIG to $BACKUP_CONFIG..."
cp "$GRUB_CONFIG" "$BACKUP_CONFIG"

echo "Applying configuration changes..."

# Function to update or add a configuration line
update_config() {
    local key=$1
    local value=$2
    if grep -q "^$key=" "$GRUB_CONFIG"; then
        sed -i "s/^$key=.*/$key=$value/" "$GRUB_CONFIG"
    else
        echo "$key=$value" >> "$GRUB_CONFIG"
    fi
}

# Apply recommended settings to hide GRUB
update_config "GRUB_TIMEOUT" "0"
update_config "GRUB_TIMEOUT_STYLE" "hidden"
update_config "GRUB_RECORDFAIL_TIMEOUT" "0"
update_config "GRUB_DISABLE_OS_PROBER" "true"

# Some systems use GRUB_TIMEOUT_STYLE=menu by default, ensure it's hidden
sed -i 's/GRUB_TIMEOUT_STYLE=menu/GRUB_TIMEOUT_STYLE=hidden/g' "$GRUB_CONFIG"

echo "Configuration updated. Updating GRUB bootloader..."

if command -v update-grub > /dev/null 2>&1; then
    update-grub
else
    grub-mkconfig -o /boot/grub/grub.cfg
fi

echo "Done! GRUB menu should now be hidden on next boot."
echo "If you need to access GRUB, hold 'Shift' or tap 'Esc' during boot."
