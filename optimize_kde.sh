#!/bin/bash

# KDE Plasma 6 Memory & Performance Optimization Script (Arch/Manjaro)
# Author: Antigravity

# Ensure root privileges
if [ "$EUID" -ne 0 ]; then
  echo "Please run as root (use sudo)."
  exit 1
fi

echo "--- KDE Plasma 6 极致性能优化工具 ---"

# 1. 禁用 Baloo 文件索引 (最耗内存和CPU的服务)
echo "[+] 正在禁用 Baloo 文件索引器..."
# 针对当前用户执行，脚本需要作为 sudo 运行，但有些命令需要用户环境
# 我们先通过 sudo 给权限，再运行
sudo -u "$SUDO_USER" balooctl6 disable || true
sudo -u "$SUDO_USER" balooctl6 purge || true
echo "[*] Baloo 已禁用并清理索引数据。"

# 2. 移除/停用 Akonadi (PIM 数据库组件，如果你不用 KDE 邮箱/日历建议关掉)
echo "[+] 正在禁用 Akonadi 数据库进程..."
sudo -u "$SUDO_USER" akonadictl stop || true
# 为了防止它自动启动，如果你想彻底重命名执行文件可以用下面注释掉的代码
# mv /usr/bin/akonadi_control /usr/bin/akonadi_control.bak || true

# 3. 安装并启用 EarlyOOM (类似 GNOME 的 OOM 守护进程，防止假死)
echo "[+] 正在配置 EarlyOOM 内存守护进程..."
if ! pacman -Qs earlyoom &> /dev/null; then
    pacman -S --needed --noconfirm earlyoom
fi
systemctl enable --now earlyoom
echo "[*] EarlyOOM 已启用。当内存在极端情况下爆满时，它会优先杀掉浏览器标签页而非卡死系统。"

# 4. 针对 ZRAM 的内核参数优化 (Sysctl)
echo "[+] 正在优化内核交换策略 (针对 ZRAM)..."
SYSCTL_CONF="/etc/sysctl.d/99-kde-performance.conf"
cat > "$SYSCTL_CONF" <<EOF
# 配合 ZRAM 建议将 swappiness 设高，优先使用压缩内存
vm.swappiness = 100
# 降低 cache 回收频率，提高系统文件浏览响应速度
vm.vfs_cache_pressure = 50
# 脏页写入限制
vm.dirty_ratio = 10
vm.dirty_background_ratio = 5
EOF
sysctl -p "$SYSCTL_CONF"
echo "[*] 内核参数已应用到 $SYSCTL_CONF。"

# 5. 清理冗余的日志占用
echo "[+] 正在清理系统日志文件 (Journal)..."
journalctl --vacuum-time=1w
journalctl --vacuum-size=200M

# 6. 设置 SSD 自动修剪 (有助于 I/O 性能)
systemctl enable --now fstrim.timer

echo "--- 优化完成！ ---"
echo "1. Baloo 文件检索已关 (可显著释放 RAM/CPU)。"
echo "2. EarlyOOM 已加入后台 (保护系统不卡死)。"
echo "3. 内核参数已针对 ZRAM 进行调优。"
echo "建议重启系统以应用所有配置。"
