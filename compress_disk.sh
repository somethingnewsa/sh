#!/bin/bash

# 定义目标磁盘的 UUID
UUID="324dfdc2-eeb7-4f5c-a716-bc8481f8d989"

# 查找挂载点
MOUNT_POINT=$(findmnt -n -o TARGET -S UUID=$UUID)

if [ -z "$MOUNT_POINT" ]; then
    echo "错误：找不到 UUID 为 $UUID 的挂载点。请确保磁盘已挂载。"
    exit 1
fi

echo "正在处理挂载点: $MOUNT_POINT"

# 1. 重新挂载以启用压缩（使用 zstd，适合游戏，解压速度快）
echo "1. 重新挂载以启用 zstd 自动压缩..."
sudo mount -o remount,compress=zstd "$MOUNT_POINT"

if [ $? -eq 0 ]; then
    echo "挂载成功。"
else
    echo "错误：重新挂载失败。"
    exit 1
fi

# 2. 对已存在的文件进行递归压缩
echo "2. 正在对已有文件进行压缩处理 (btrfs defragment)..."
echo "这可能需要一些时间，取决于文件数量和磁盘速度..."
sudo btrfs filesystem defragment -r -v -czstd "$MOUNT_POINT"

echo "--------------------------------------"
echo "处理完成！"
echo "现在新写入该磁盘的文件会自动压缩。"
echo "建议：如果这是你的游戏盘，zstd 压缩通常能加快加载时间并节省空间。"
