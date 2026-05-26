#!/bin/bash

echo "Installing Prereqs..."
sudo pacman -S xorg-xfd ttf-bigblueterminal-nerd alacritty
echo ""
echo "Installing PreReqs from AUR..."
yay -S nordic-theme nordzy-icon-theme nordzy-cursors-theme librewolf-bin
