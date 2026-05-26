#!/bin/bash

echo "Installing Prereqs..."
sudo pacman -S xorg-xfd ttf-bigblueterminal-nerd alacritty starship
echo ""
echo "Installing PreReqs from AUR..."
yay -S nordic-theme nordzy-icon-theme nordzy-cursors-theme librewolf-bin
echo ""
echo "Applying Default Themes & Configs..."
cp -R .config ~/
echo ""
echo "-------------"
echo "Requirements installed. You may now use the 'startx' command to start sigwm"
