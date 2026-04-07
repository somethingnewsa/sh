#!/bin/bash

# KDE Plasma 5/6 Chinese Input Method (Fcitx5) Installation Script for Arch/Manjaro
# Author: Antigravity

# Ensure the script is run with root privileges
if [ "$EUID" -ne 0 ]; then
  echo "Please run as root (use sudo)."
  exit 1
fi

echo "--- KDE Chinese Input Method (Fcitx5) Installation ---"

# KDE Plasma Chinese Input Method (Fcitx5) Installation Script
# Supports: Arch, Debian, Ubuntu, Fedora

# Detect Distro
if [ -f /etc/arch-release ] || [ -f /etc/manjaro-release ]; then
    DISTRO="arch"
    PKGMGR="pacman -Sy --needed --noconfirm"
    PKG_LIST="fcitx5-im fcitx5-chinese-addons fcitx5-pinyin-zhwiki noto-fonts-cjk adobe-source-han-sans-cn-fonts adobe-source-han-serif-cn-fonts"
elif [ -f /etc/debian_version ]; then
    DISTRO="debian"
    PKGMGR="apt update && apt install -y"
    PKG_LIST="fcitx5 fcitx5-chinese-addons fcitx5-frontend-gtk2 fcitx5-frontend-gtk3 fcitx5-frontend-qt5 fcitx5-module-lua fcitx5-config-qt fonts-noto-cjk"
elif [ -f /etc/fedora-release ]; then
    DISTRO="fedora"
    PKGMGR="dnf install -y"
    PKG_LIST="fcitx5 fcitx5-chinese-addons fcitx5-autostart fcitx5-gtk fcitx5-qt google-noto-cjk-fonts"
else
    echo "Unsupported distribution. Please install fcitx5 manually."
    exit 1
fi

echo "--- Installing on $DISTRO ---"
eval "$PKGMGR $PKG_LIST"

# 2. Configure Environment Variables
# For modern KDE (Wayland/X11 mixed), /etc/environment is the most reliable global place.
echo "Configuring environment variables in /etc/environment..."
ENV_FILE="/etc/environment"

# Function to add/update env if not exists
add_env() {
    local key=$1
    local value=$2
    if ! grep -q "^${key}=" "$ENV_FILE"; then
        echo "${key}=${value}" >> "$ENV_FILE"
    else
        sed -i "s/^${key}=.*/${key}=${value}/" "$ENV_FILE"
    fi
}

# Standard Fcitx5 Environment Variables
add_env "GTK_IM_MODULE" "fcitx"
add_env "QT_IM_MODULE" "fcitx"
add_env "XMODIFIERS" "@im=fcitx"
# For Wayland
add_env "INPUT_METHOD" "fcitx"
add_env "SDL_IM_MODULE" "fcitx"

# Clear im-config for Debian/Ubuntu (optional but recommended for Fcitx5)
if [ "$DISTRO" == "debian" ]; then
    im-config -n fcitx5
fi

echo "--- Done! ---"
echo "安装完成！请【重启系统】或【注销重新登录】以生效。"
echo "登录后，在 KDE 系统设置 -> 输入设备 -> 虚拟键盘 中选择 Fcitx5。"
echo "然后打开 fcitx5-configtool (或在系统设置里) 添加 Pinyin 即可。"
