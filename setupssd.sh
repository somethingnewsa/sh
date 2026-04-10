#!/bin/bash

# 配置变量
DISK="/dev/sda1"
MOUNT_POINT="/mnt/Games"
LABEL="Games"
USER_NAME="xiaofan"

echo "开始自动配置 Games 磁盘..."

# 1. 强制卸载
sudo umount -l $DISK 2>/dev/null

# 2. 格式化为 Btrfs
echo "正在格式化 $DISK 为 Btrfs (名称: $LABEL)..."
sudo mkfs.btrfs -L $LABEL -f $DISK

# 3. 获取 UUID
UUID=$(sudo blkid -s UUID -o value $DISK)
echo "磁盘 UUID 为: $UUID"

# 4. 创建挂载点
sudo mkdir -p $MOUNT_POINT

# 5. 配置 /etc/fstab (开机自动挂载 + 自动压缩)
# 先删除旧的配置（防止重复添加）
sudo sed -i "\| $MOUNT_POINT |d" /etc/fstab
sudo sed -i "\|$DISK|d" /etc/fstab

# 添加新配置
FSTAB_LINE="UUID=$UUID $MOUNT_POINT btrfs defaults,compress=zstd:3,autodefrag,discard=async,nofail 0 0"
echo "正在更新 /etc/fstab..."
echo "$FSTAB_LINE" | sudo tee -a /etc/fstab

# 6. 生效并挂载
sudo systemctl daemon-reload
sudo mount -a

# 7. 设置权限（让普通用户可以直接读写）
sudo chown $USER_NAME:$USER_NAME $MOUNT_POINT

echo "------------------------------------------"
echo "恭喜！配置已经全部完成："
echo "1. 格式: Btrfs"
echo "2. 挂载位置: $MOUNT_POINT"
echo "3. 开启了实时压缩 (zstd) 和开机自启"
echo "------------------------------------------"

