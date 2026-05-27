#!/bin/bash

echo "Installing Prereqs..."
sudo pacman -S --needed xorg-xfd ttf-bigblueterminal-nerd alacritty starship rofi thunar eza
echo ""
echo "Installing PreReqs from AUR..."
yay -S nordic-theme nordzy-icon-theme nordzy-cursors-theme librewolf-bin
echo ""
echo "Switching to fish shell..."
chsh -s /usr/bin/fish
echo ""
echo "Applying Default Themes & Configs..."
cp -R .config ~/
cp .xinitrc ~/
echo ""
echo "Installing extras..."
mkdir -p ~/.src
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
