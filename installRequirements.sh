#!/bin/bash

echo "Installing Audio & Video..."
sudo pacman -Sy
sudo pacman -S xorg-server xorg-xinit intel-media-driver libva-intel-driver mesa vulkan-intel vulkan-nouveau vulkan-radeon xf86-video-amdgpu xf86-video-ati xf86-video-nouveau pipewire
echo ""
echo "Installing Prereqs..."
sudo pacman -S --needed git base-devel xorg-xfd ttf-bigblueterminal-nerd alacritty starship rofi thunar eza
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
echo ""
echo "Switching to fish shell..."
chsh -s /usr/bin/fish
echo ""
echo "Applying Default Themes & Configs..."
cp -R .config ~/
cp .xinitrc ~/
echo ""
mkdir -p ~/.src
echo "Installing YaY"
cd ~/src
git clone https://aur.archlinux.org/yay.git
cd yay
makepkg -si
echo ""
echo "Installing PreReqs from AUR..."
yay -S nordic-theme nordzy-icon-theme nordzy-cursors-theme librewolf-bin light
echo ""
echo "Installing extras..."
cd ~/.src
echo "Building rdir..."
git clone https://github.com/sigvaldr/rdir.git
cd rdir
cargo build --release
echo "Installing rdir..."
sudo cp target/release/rdir /usr/bin/
echo ""
echo "Buildilng boxr..."
cd ~/.src
git clone https://github.com/sigvaldr/boxr.git
cd boxr
cargo build --release
echo "Installing boxr..."
sudo cp target/release/boxr /usr/bin
sudo cp target/release/unboxr /usr/bin
echo ""
echo "-------------"
echo "Requirements installed. You may now use the 'startx' command to start sigwm"
