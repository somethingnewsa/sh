#!/bin/bash

# 确保脚本以普通用户身份运行，部分命令会根据需要请求 sudo
echo "开始将 GNOME 转换为 macOS Tahoe 风格..."

# 1. 安装必要的依赖包
echo "正在安装依赖项 (git, gnome-tweaks, flatpak, sassc)..."
sudo pacman -S --needed git gnome-tweaks extension-manager flatpak sassc glib2 imagemagick

# 2. 创建临时工作目录
mkdir -p ~/tahoe-theme-build
cd ~/tahoe-theme-build

# 3. 安装 macOS Tahoe 图标主题
echo "正在下载并安装图标主题..."
git clone https://github.com/vinceliuice/MacTahoe-icon-theme.git
cd MacTahoe-icon-theme
./install.sh
cd ..

# 4. 安装 macOS Tahoe GTK 主题
echo "正在下载并安装 GTK 主题..."
git clone https://github.com/vinceliuice/MacTahoe-gtk-theme.git
cd MacTahoe-gtk-theme
# 使用视频中推荐的参数：全颜色分支、支持 libadwaita、调整 Shell 高度及圆角
./install.sh -n mactahoe -d all -l --shell -i simple -h bigger --round

# 5. 应用 GDM 登录界面主题 (需要 sudo)
echo "正在应用 GDM 主题..."
sudo ./tweaks.sh -g -nd

# 6. 配置 Firefox 与 Flatpak 适配
echo "正在优化 Firefox 和 Flatpak 样式..."
./tweaks.sh -f default -F
flatpak override --user --filesystem=xdg-config/gtk-4.0

# 7. 设置窗口按钮到左侧 (macOS 风格)
echo "调整窗口按钮位置到左侧..."
gsettings set org.gnome.desktop.wm.preferences button-layout 'close,minimize,maximize:'

echo "--------------------------------------------------"
echo "基础主题安装完成！"
echo "请手动执行以下最后步骤："
echo "1. 打开 '延伸插件管理器' (Extension Manager) 安装并启用以下插件："
echo "   - User Themes (用于更改 Shell 主题)"
echo "   - Dash to Dock (设置为底部居中，类似 Dock 栏)"
echo "   - Blur my Shell (增加毛玻璃效果)"
echo "   - Just Perfection (隐藏不需要的 UI 元素)"
echo "2. 打开 '优化' (Gnome Tweaks) -> '外观'："
echo "   - 更改 '图标' 为 MacTahoe"
echo "   - 更改 '外壳' (Shell) 为 MacTahoe-Dark"
echo "   - 更改 '旧版应用' 为 MacTahoe-Dark"
echo "--------------------------------------------------"