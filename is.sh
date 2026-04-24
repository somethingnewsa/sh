#!/bin/bash

# 确保脚本以普通用户身份运行
echo "🚀 开始将 GNOME 彻底转换为 macOS Tahoe 风格..."

# 1. 安装必要的依赖包
echo "📦 正在安装依赖项..."
sudo pacman -S --needed git gnome-tweaks extension-manager flatpak sassc glib2 imagemagick

# 2. 创建并清理临时工作目录
mkdir -p ~/tahoe-theme-build
cd ~/tahoe-theme-build

# 3. 创建主题存放目录 (防止路径识别不到)
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

# 使用 -p 参数强制安装到 local 目录，确保 Shell 主题能被插件读取
./install.sh -n mactahoe -d all -l --shell -i simple -h bigger --round -p ~/.local/share/themes

# 6. 解决 GTK4/libadwaita (新版应用) 不变色的问题
echo "⚙️ 正在强制应用 GTK4 样式..."
cp -r ~/.local/share/themes/MacTahoe-Dark/gtk-4.0/* ~/.config/gtk-4.0/

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

echo "--------------------------------------------------"
echo "✅ 基础安装已完成！"
echo "--------------------------------------------------"
echo "💡 请务必执行以下手动操作以激活主题："
echo "1. 打开 '延伸插件管理器' (Extension Manager)："
echo "   - 搜索并启用 'User Themes' (这是显示 Shell 选项的关键)"
echo "   - 搜索并启用 'Dash to Dock' (Dock 栏)"
echo "   - 搜索并启用 'Blur my Shell' (毛玻璃)"
echo ""
echo "2. 打开 '优化' (Gnome Tweaks) -> '外观'："
echo "   - 更改 '图标' (Icons) 为: MacTahoe"
echo "   - 更改 '外壳' (Shell) 为: MacTahoe-Dark"
echo "   - 更改 '旧版应用' (Legacy Applications) 为: MacTahoe-Dark"
echo ""
echo "⚠️ 如果在 Tweaks 里看不到选项，请按 Alt+F2 输入 r 重启 GNOME，或重新登录。"
echo "--------------------------------------------------"
