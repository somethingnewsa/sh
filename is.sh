#!/bin/bash

# 确保脚本以普通用户身份运行
echo "🚀 开始将 GNOME 彻底转换为 macOS Tahoe Light (浅色) 风格..."

# 1. 安装必要的依赖包
echo "📦 正在安装依赖项..."
sudo pacman -S --needed git gnome-tweaks extension-manager flatpak sassc glib2 imagemagick gnome-shell-extensions

# 2. 创建并清理临时工作目录
mkdir -p ~/tahoe-theme-build
cd ~/tahoe-theme-build

# 3. 创建主题存放目录
mkdir -p ~/.local/share/themes
mkdir -p ~/.local/share/icons
mkdir -p ~/.config/gtk-4.0

# 4. 安装 macOS Tahoe 图标主题
echo "🎨 正在下载并安装图标主题..."
if [ ! -d "MacTahoe-icon-theme" ]; then
    git clone https://github.com/vinceliuice/MacTahoe-icon-theme.git
fi
cd MacTahoe-icon-theme
./install.sh
cd ..

# 5. 安装 macOS Tahoe GTK 主题 (指定浅色版)
echo "🖌️ 正在下载并安装 GTK 和 Shell 主题 (Light)..."
if [ ! -d "MacTahoe-gtk-theme" ]; then
    git clone https://github.com/vinceliuice/MacTahoe-gtk-theme.git
fi
cd MacTahoe-gtk-theme

# 安装参数说明：
# -c light: 明确指定浅色版本
# -l: 安装 libadwaita 支持
./install.sh -n MacTahoe -d ~/.local/share/themes -c light -l --shell -i simple -h bigger --round

# 6. 解决 GTK4/libadwaita (新版应用) 不变色的问题
echo "⚙️ 正在强制应用 GTK4 浅色样式..."
# 清理旧的 GTK4 配置（防止冲突）
rm -rf ~/.config/gtk-4.0/*
if [ -d "$HOME/.local/share/themes/MacTahoe-Light/gtk-4.0" ]; then
    cp -r ~/.local/share/themes/MacTahoe-Light/gtk-4.0/* ~/.config/gtk-4.0/
fi

# 7. 应用 GDM 登录界面主题 (浅色)
echo "🖥️ 正在准备 GDM 主题 (浅色模式，需要输入密码)..."
sudo ./tweaks.sh -g -c light -nd

# 8. 配置 Firefox 与 Flatpak 适配
echo "🌐 优化 Firefox 和 Flatpak 样式..."
./tweaks.sh -f default -F
flatpak override --user --filesystem=xdg-config/gtk-4.0

# 9. 设置窗口按钮到左侧 (macOS 风格)
echo "📐 调整窗口按钮位置到左侧..."
gsettings set org.gnome.desktop.wm.preferences button-layout 'close,minimize,maximize:'

# 10. 自动应用主题 (GSettings)
echo "🪄 正在自动应用主题配置..."

# 设置全局颜色偏好为浅色
gsettings set org.gnome.desktop.interface color-scheme 'prefer-light'

# 设置 GTK 主题
gsettings set org.gnome.desktop.interface gtk-theme "MacTahoe-Light"

# 设置图标主题
gsettings set org.gnome.desktop.interface icon-theme "MacTahoe"

# 设置 Shell 主题 (需要 User Themes 扩展已启用)
gsettings set org.gnome.shell.extensions.user-theme name "MacTahoe-Light"

echo "--------------------------------------------------"
echo "✅ 安装与配置已完成！"
echo "--------------------------------------------------"
echo "💡 重要提示："
echo "1. 如果 Shell 主题没变，请在 '延伸插件管理器' 中启用 'User Themes' 插件。"
echo "2. 建议重启 GNOME Shell：按 Alt+F2 输入 r 并回车 (X11) 或 重新登录 (Wayland)。"
echo "3. 推荐安装以下扩展以获得完整体验："
echo "   - Dash to Dock (设置为底部居中，类似 macOS Dock)"
echo "   - Blur my Shell (让顶栏和 Dock 产生毛玻璃效果)"
echo "   - Compiz windows effect (神奇灯泡效果/神奇效果)"
echo "--------------------------------------------------"
