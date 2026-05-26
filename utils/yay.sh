#!/bin/bash

echo "Installing yay..."
sudo pacman -S --needed git base-devel
mkdir -p ~/src
cd ~/src
git clone https://aur.archlinux.org/yay-bin.git
cd yay
makepkg -si
