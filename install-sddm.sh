#!/bin/bash

sudo pacman -S --noconfirm sddm sddm-kcm

sudo systemctl disable plasmalogin 2>/dev/null
sudo systemctl enable sddm

cat << 'EOF' | sudo tee /etc/sddm.conf > /dev/null
[Autologin]
Relogin=false
Session=
User=

[General]
DisplayServer=wayland
GreeterEnvironment=QT_SCALE_FACTOR=1.25
HaltCommand=/usr/bin/systemctl poweroff
InputMethod=
RebootCommand=/usr/bin/systemctl reboot
Numlock=none

[Theme]
Current=breeze
CursorTheme=breeze_cursors
DisableAvatarsThreshold=7
EnableAvatars=true
FacesDir=/usr/share/sddm/faces
ThemeDir=/usr/share/sddm/themes

[Users]
DefaultPath=/usr/local/bin:/usr/bin:/bin
HideShells=
HideUsers=
MaximumUid=60513
MinimumUid=1000
RememberLastSession=true
RememberLastUser=true
ReuseSession=true

[Wayland]
EnableHiDPI=true
SessionCommand=/usr/share/sddm/scripts/wayland-session
SessionDir=/usr/local/share/wayland-sessions,/usr/share/wayland-sessions
SessionLogFile=.local/share/sddm/wayland-session.log

[X11]
DisplayCommand=/usr/share/sddm/scripts/Xsetup
DisplayStopCommand=/usr/share/sddm/scripts/Xstop
EnableHiDPI=true
ServerArguments=-nolisten tcp
ServerPath=/usr/bin/X
SessionCommand=/usr/share/sddm/scripts/Xsession
SessionDir=/usr/local/share/xsessions,/usr/share/xsessions
SessionLogFile=.local/share/sddm/xorg-session.log
XephyrPath=/usr/bin/Xephyr
EOF

echo "SDDM 安装配置完成！"
echo "缩放 1.25 倍，主题 Breeze"
echo "重启后生效，或执行: sudo systemctl restart sddm"
