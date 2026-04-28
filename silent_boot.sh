#!/bin/bash

# 必须用 sudo 运行
if [ "$EUID" -ne 0 ]; then
  echo "请使用 sudo 运行: sudo bash $0"
  exit 1
fi

# 定义终极静默参数
NEW_PARAMS="quiet splash loglevel=3 rd.systemd.show_status=false rd.udev.log_level=3 vt.global_cursor_default=0"

echo "正在强制配置静默开机参数..."

# 1. 针对 systemd-boot (CachyOS 默认)
if [ -f /etc/kernel/cmdline ]; then
    echo "检测到 systemd-boot 配置..."
    # 备份
    cp /etc/kernel/cmdline /etc/kernel/cmdline.bak
    # 清空并重新写入：保留现有的 UUID 等信息，但强制加入静默参数
    # 这里我们读取原有的 root=UUID=... 部分，然后拼接新参数
    OLD_LINE=$(cat /etc/kernel/cmdline)
    # 移除已有的 quiet splash 等关键字防止重复
    CLEAN_LINE=$(echo "$OLD_LINE" | sed -e 's/quiet//g' -e 's/splash//g' -e 's/loglevel=[0-9]//g' -e 's/rd.systemd.show_status=[a-z]*//g')
    echo "$CLEAN_LINE $NEW_PARAMS" | tr -s ' ' > /etc/kernel/cmdline

    echo "正在同步内核引导项..."
    reinstall-kernels
fi

# 2. 针对 GRUB
if [ -f /etc/default/grub ]; then
    echo "检测到 GRUB 配置..."
    cp /etc/default/grub /etc/default/grub.bak
    # 直接修改 GRUB_CMDLINE_LINUX_DEFAULT 行
    sed -i '/GRUB_CMDLINE_LINUX_DEFAULT/d' /etc/default/grub
    echo "GRUB_CMDLINE_LINUX_DEFAULT=\"nowatchdog nvme_load=YES $NEW_PARAMS\"" >> /etc/default/grub

    echo "正在更新 GRUB..."
    grub-mkconfig -o /boot/grub/grub.cfg
fi

echo "------------------------------------------------"
echo "配置完成！请重启。"
echo "重启后请再次运行 cat /proc/cmdline 检查是否有 'quiet' 字样。"
