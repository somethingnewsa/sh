#!/bin/bash

# Script to setup 16GB zram Swap (Arch/Manjaro)
# Author: Antigravity

# Ensure root privileges
if [ "$EUID" -ne 0 ]; then
  echo "Please run as root (use sudo)."
  exit 1
fi

echo "--- Setting up 16GB zram Swap ---"

# 1. Install zram-generator (modern Arch standard)
echo "[+] Installing zram-generator..."
if ! pacman -Qs zram-generator &> /dev/null; then
    pacman -S --needed --noconfirm zram-generator
fi

# 2. Configure zram-generator
echo "[+] Configuring /etc/systemd/zram-generator.conf..."
cat > /etc/systemd/zram-generator.conf <<EOF
[zram0]
zram-size = 16384
compression-algorithm = zstd
swap-priority = 100
fs-type = swap
EOF

# 3. Apply changes
echo "[+] Reloading systemd and starting zram..."
systemctl daemon-reload
systemctl start /dev/zram0 2>/dev/null || true # Generator creates the device

# Sometimes you need to restart the generator service
# The easiest way on Arch is to just reload it.

# 4. Verify
echo "--- Verification ---"
zramctl
swapon --show

echo "--- Done! ---"
echo "16GB zram 已设置完成（默认使用 zstd 压缩算法）。"
echo "设置是持久化的，重启后依然有效。"
