#!/bin/bash
sig=$PWD
clear
echo "Installing Prereqs..."
sudo pacman -S --needed git base-devel xorg-server xorg-xinit xorg-xfd ttf-bigblueterminal-nerd alacritty starship rofi thunar eza
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
clear
echo "Applying Default Themes & Configs..."
cp -R .config ~/
cp .xinitrc ~/
mkdir -p ~/.src
clear
echo "Installing YaY"
cd ~/.src
git clone https://aur.archlinux.org/yay.git
cd yay
makepkg -si
clear
echo "Installing PreReqs from AUR..."
yay -S nordic-theme nordzy-icon-theme nordzy-cursors-theme librewolf-bin light fish
clear
echo "Switching to fish shell..."
chsh -s /usr/bin/fish
clear
echo "Installing extras..."
cd ~/.src
source ~/.bashrc
echo "Building rdir..."
git clone https://github.com/sigvaldr/rdir.git
cd rdir
cargo build --release
echo "Installing rdir..."
sudo cp target/release/rdir /usr/bin/
clear
echo "Buildilng boxr..."
cd ~/.src
git clone https://github.com/sigvaldr/boxr.git
cd boxr
cargo build --release
echo "Installing boxr..."
sudo cp target/release/boxr /usr/bin
sudo cp target/release/unboxr /usr/bin
clear
echo "  Requirements installed"
sudo usermod -aG audio $USER
sudo usermod -aG video $USER
echo "Building SIGWM..."
cd $sig
cargo build --release
sudo cp target/release/sigwm /usr/bin
echo "-----------------------------------"
echo "Installation complete."
echo "Please reboot into your new WM :)"
echo "-----------------------------------"
