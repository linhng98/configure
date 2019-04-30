#!/bin/bash

## detect laptop or pc
read -p 'this device is pc or laptop (1:pc, 2:laptop) ? ' device_type

## create new user and uncomment visudo for wheel group
useradd -m -G wheel -s /bin/bash linh
passwd linh
sed -i '/%wheel ALL=(ALL) ALL/s/^# //g' /etc/sudoers

## install intel-ucode
pacman -S intel-ucode

## install networkmanager and enable
pacman -S network-manager
systemctl enable NetworkManager

## install zsh
pacman -S zsh zsh-completions
cp /configure/zshrc /home/linh/.zshrc # copy config 
usermod -s /bin/zsh linh # change default shell for user linh

## install urxvt
pacman -S rxvt-unicode
cp /configure/Xresources /home/linh/.Xresources

## remove configure folder
rm -Rns /configure
