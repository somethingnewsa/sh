#!/bin/bash

# 确保脚本以普通用户身份运行
echo "🚀 开始将 GNOME 彻底转换为 macOS Tahoe 风格..."

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

# 5. 安装 macOS Tahoe GTK 主题
echo "🖌️ 正在下载并安装 GTK 和 Shell 主题..."
if [ ! -d "MacTahoe-gtk-theme" ]; then
    git clone https://github.com/vinceliuice/MacTahoe-gtk-theme.git
fi
cd MacTahoe-gtk-theme

# 修正安装命令：
# -n MacTahoe: 保持首字母大写
# -d ~/.local/share/themes: 指定正确的主题目录
# --shell: 安装 Shell 主题
# -l: 为 libadwaita 安装
./install.sh -n MacTahoe -d ~/.local/share/themes -l --shell -i simple -h bigger --round

# 6. 解决 GTK4/libadwaita (新版应用) 不变色的问题
echo "⚙️ 正在强制应用 GTK4 样式..."
if [ -d "$HOME/.local/share/themes/MacTahoe-Dark/gtk-4.0" ]; then
    cp -r ~/.local/share/themes/MacTahoe-Dark/gtk-4.0/* ~/.config/gtk-4.0/
fi

# 7. 应用 GDM 登录界面主题 (可选)
echo "🖥️ 正在准备 GDM 主题 (可能需要 sudo)..."
sudo ./tweaks.sh -g -nd

# 8. 配置 Firefox 与 Flatpak 适配
echo "🌐 优化 Firefox 和 Flatpak 样式..."
./tweaks.sh -f default -F
flatpak override --user --filesystem=xdg-config/gtk-4.0

# 9. 设置窗口按钮到左侧 (macOS 风格)
echo "📐 调整窗口按钮位置到左侧..."
gsettings set org.gnome.desktop.wm.preferences button-layout 'close,minimize,maximize:'

# 10. 自动应用主题 (无需手动在 Tweaks 里选)


echo "--------------------------------------------------"
echo "✅ 安装与配置已完成！"
echo "--------------------------------------------------"
echo "💡 如果部分应用没有立即变色："
echo "1. 按 Alt+F2 输入 r 并回车 (X11) 或重新登录 (Wayland)。"
echo "2. 确保 'User Themes' 扩展在 '延伸插件管理器' 中已启用。"
echo "3. 推荐安装以下扩展以获得完整体验："
echo "   - Dash to Dock (Dock 栏)"
echo "   - Blur my Shell (毛玻璃效果)"
echo "--------------------------------------------------"
