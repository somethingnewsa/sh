sudo pacman -S qt5-tools curl yay wget rsync git sassc kate unzip zip
sudo pacman -S gnome-terminal nautilus nautilus-share gnome-weather gnome-maps gnome-calendar gnome-clocks vlc
unzip -o $HOME/Downloads/plasma6macos-plasma-theme.zip "aurorae/*" "color-schemes/*" "plasma/*" "wallpapers/*" -d "$HOME/.local/share"
mkdir -p $HOME/.themes
unzip -o $HOME/Downloads/plasma6macos-gtk-theme.zip "MacTahoe-*" -d "$HOME/.themes/"
sudo pacman -S kvantum-qt5
mkdir -p $HOME/.config/Kvantum
unzip -o $HOME/Downloads/plasma6macos-kvantum-config.zip "kvantum.kvconfig" "MacSequoia/*" -d $HOME/.config/Kvantum
curl -L -o "$HOME/Downloads/darkly-0.5.37-x86_64.pkg.zst" https://github.com/Bali10050/Darkly/releases/download/v0.5.37/darkly-0.5.37-x86_64.pkg.zst

sudo pacman -U $HOME/Downloads/darkly-0.5.37-x86_64.pkg.zst
mkdir -p $HOME/.local/share/icons
unzip -o $HOME/Downloads/plasma6macos-icons.zip -d $HOME/.local/share/icons
ls -al $HOME/.local/share/icons
mkdir -p $HOME/.icons
unzip -o $HOME/Downloads/plasma6macos-cursors.zip -d $HOME/.icons
unzip -o $HOME/Downloads/plasma6macos-fonts.zip -d $HOME/.local/share/fonts
ls -al ~/.local/share/fonts
sudo unzip -o $HOME/Downloads/plasma6macos-wallpapers.zip -d /
ls -al /usr/share/wallpapers/Plasma-Tahoe
unzip -o $HOME/Downloads/plasma6macos-plasmoids.zip "plasmoids/*" -d "$HOME/.local/share/plasma/"
ls -al $HOME/.local/share/plasma/plasmoids
sudo pacman -S --needed --noconfirm \
cmake extra-cmake-modules gcc make gettext \
qt6-base qt6-declarative \
kservice kcoreaddons kdeclarative kwindowsystem \
ksvg kcmutils kirigami milou kiconthemes \
kio \
plasma-workspace libplasma \
git
cd $HOME/Downloads
git clone https://github.com/xarbit/plasma6-applet-appgrid.git
cd plasma6-applet-appgrid
cmake -B build -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=/usr
cmake --build build -j$(nproc)
sudo cmake --install build
cd ~/Downloads
cd ~
unzip -o $HOME/Downloads/plasma6macos-kwin-effect.zip "kwin/*" -d $HOME/.local/share/
unzip -o $HOME/Downloads/plasma6macos-kwin-effect.zip "wallpapers/*" -d "$HOME/.local/share/plasma"
ls -al $HOME/.local/share/kwin && ls -al $HOME/.local/share/plasma/wallpapers
sudo pacman -S cava
unzip -o $HOME/Downloads/plasma6macos-cava.zip -d "$HOME/.config/"
paru -S fastfetch
mkdir -p "$HOME/.local/share/fastfetch"
unzip -o $HOME/Downloads/plasma6macos-fastfetch.zip "ascii/*" "presets/*" -d "$HOME/.local/share/fastfetch/"
fastfetch --config sysinfo
sudo pacman -S --noconfirm flatpak
sudo flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
sudo flatpak install flathub io.bassi.Amberol -y
mkdir -p $HOME/.local/share/flatpak/overrides
echo -e "[Context]\nfilesystems=~/.local/share/icons;~/.themes;xdg-config/gtk-4.0;xdg-config/gtk-3.0" >> $HOME/.local/share/flatpak/overrides/global
sudo pacman -S sddm sddm-kcm
sudo systemctl disable plasmalogin
sudo systemctl enable sddm
reboot


rm -rf "$HOME/.config/gtk-4.0"
mkdir -p "$HOME/.config/gtk-4.0"
ln -sf "$HOME/.themes/MacTahoe-Light/gtk-4.0/"{assets,gtk.css,gtk-dark.css} "$HOME/.config/gtk-4.0/"
unzip -o $HOME/Downloads/plasma6macos-gnome-config.zip -d $HOME/Downloads/
$HOME/Downloads/plasma6macos-gnome-config.sh
kquitapp6 plasmashell
unzip -o $HOME/Downloads/plasma6macos-kde-config.zip "gtk-3.0/*" "gtk-4.0/*" "xsettingsd/*" "Trolltech.conf" "darklyrc" "dolphinrc" "gtkrc" "gtkrc-2.0" "kcminputrc" "kded5rc" "kded6rc" "kdeglobals" "kscreenlockerrc" "ksmserverrc" "ksplashrc" "kwinrc" "mimeapps.list" "plasma-org.kde.plasma.desktop-appletsrc" "plasmarc" "plasmashellrc" "kdedefaults/*" -d "$HOME/.config"
unzip -oj "$HOME/Downloads/plasma6macos-kde-config.zip" "conf-cachyos/plasma-org.kde.plasma.desktop-appletsrc" -d "$HOME/.config"
kstart plasmashell &> /dev/null &
qdbus-qt5 org.kde.Shutdown /Shutdown org.kde.Shutdown.logout
cd $HOME/Downloads
git clone https://github.com/linuxscoop/safarifox-theme.git
cd safarifox-theme
./install.sh -f
sudo pacman -S zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" -- --unattended
git clone https://github.com/zsh-users/zsh-autosuggestions ~/.oh-my-zsh/custom/plugins/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ~/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting
git clone https://github.com/zsh-users/zsh-history-substring-search ~/.oh-my-zsh/custom/plugins/zsh-history-substring-search
curl -sS https://starship.rs/install.sh | sh
unzip -o $HOME/Downloads/plasma6macos-zshstarship-konsole.zip -d $HOME
