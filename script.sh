#!/bin/bash
set -e

# === Update and base tools ===
pacman -Syu --noconfirm

pacman -S --noconfirm \
	base-devel \
	git \
	curl \
	wget \
	unzip \
	zip \
	networkmanager \
	openssh \
	reflector \
	bash-completion \
	sudo \
	man-db \
	man-pages \
	zsh \
	linux-headers \
	eza \
	bat \
	lazygit

# Enable NetworkManager
systemctl enable NetworkManager

# === CPU Microcode ===
pacman -S --noconfirm intel-ucode

# === PipeWire (Audio) ===
pacman -S --noconfirm \
	pipewire \
	pipewire-pulse \
	pipewire-alsa \
	wireplumber \
	sof-firmware \
	alsa-utils

# === Wayland + Hyprland ===
pacman -S --noconfirm \
	hyprland \
	xdg-desktop-portal-hyprland \
	xdg-desktop-portal-wlr \
	xdg-desktop-portal \
	qt5-wayland \
	qt6-wayland \
	wl-clipboard \
	grim \
	slurp \
	rofi \
	waybar \
	wofi \
	kitty \
	neovim \
	nwg-displays

# === Intel graphics ===
pacman -S --noconfirm \
	mesa \
	libva-intel-driver \
	intel-media-driver \
	vulkan-intel \
	vulkan-icd-loader

# === Display Manager: SDDM ===
pacman -S --noconfirm sddm
systemctl enable sddm

# Create Hyprland .desktop session (if not already provided)
mkdir -p /usr/share/wayland-sessions
cat <<EOF >/usr/share/wayland-sessions/hyprland.desktop
[Desktop Entry]
Name=Hyprland
Comment=Wayland Compositor
Exec=Hyprland
Type=Application
DesktopNames=Hyprland
EOF

# === Fonts ===
pacman -S --noconfirm \
	ttf-dejavu \
	ttf-liberation \
	noto-fonts \
	noto-fonts-emoji

# === Common Apps ===
pacman -S --noconfirm \
	nautilus \
	file-roller \
	pavucontrol \
	htop \
	jq \
	unzip

# === AUR Helper: yay ===
echo "📦 Installing yay (AUR helper)..."
cd /opt
git clone https://aur.archlinux.org/yay.git
chown -R $(logname):$(logname) yay

cd yay
sudo -u $(logname) makepkg -si --noconfirm
cd ..
rm -rf yay

# === swaync (notification daemon) ===
echo "🔔 Installing swaync..."
sudo -u $(logname) yay -S --noconfirm swaync

# === hyprshot (screenshot tool) ===
echo "📸 Installing hyprshot..."
sudo -u $(logname) yay -S --noconfirm hyprshot

# === hyprlock (Wayland lockscreen) ===
echo "🔒 Installing hyprlock..."
sudo -u $(logname) yay -S --noconfirm hyprlock

# === hyprpaper (wallpaper daemon) ===
echo "🖼️ Installing hyprpaper..."
sudo -u $(logname) yay -S --noconfirm hyprpaper

echo "Installing hypridle..."
sudo -u $(logname) yay -S --noconfirm hypridle

echo "Installing nwg-look..."
sudo -u $(logname) yay -S --noconfirm nwg-look

# === Communication tools ===
echo "💬 Installing Slack, Zoom, and Discord..."
sudo -u $(logname) yay -S --noconfirm slack-desktop zoom discord_arch_electron

# === Web Browsers ===
echo "🌐 Installing qutebrowser and Microsoft Edge..."
pacman -S --noconfirm qutebrowser
sudo -u $(logname) yay -S --noconfirm microsoft-edge-stable

# === Bluetooth support ===
echo "🔷 Installing Bluetooth packages..."
pacman -S --noconfirm \
	bluez \
	bluez-utils \
	blueman
systemctl enable bluetooth

# === Zsh default shell for main user ===
echo "🐚 Setting Zsh as default shell for $(logname)..."
chsh -s /bin/zsh $(logname)

echo "✅ Post-install complete. Reboot and enjoy your Hyprland system with Nautilus, qutebrowser, and Edge!"
