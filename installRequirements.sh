#!/bin/bash

echo "Installing Prereqs..."
sudo pacman -S --needed xorg-xfd ttf-bigblueterminal-nerd alacritty starship rofi
echo ""
echo "Installing PreReqs from AUR..."
yay -S nordic-theme nordzy-icon-theme nordzy-cursors-theme librewolf-bin
echo ""
echo "Applying Default Themes & Configs..."
cp -R .config ~/
cp .xinitrc ~/
echo ""
echo "-------------"
echo "Requirements installed. You may now use the 'startx' command to start sigwm"
