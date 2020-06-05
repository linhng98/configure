#!/bin/bash

## input username and password
read -p 'input root password : ' rootpass
read -p 'input user name : ' username
read -p 'input user password : ' userpass

## copy file config mirror list
cp /etc/pacman.d/mirrorlist /etc/pacman.d/mirrorlist.backup # backup mirror
cp /configure/Arch/config_file/mirrorlist /etc/pacman.d/mirrorlist
pacman -Syyu

## install intel-ucode
pacman -S --noconfirm intel-ucode

## install networkmanager and enable
pacman -S --noconfirm networkmanager
systemctl enable NetworkManager

## locale
sed -i '/en_US.UTF-8/s/^#//g' /etc/locale.gen
locale-gen
echo 'LANG=en_US.UTF-8' > /etc/locale.conf

## hostname
echo "Arch" > /etc/hostname

## install boot loader
bootctl --path=/boot install

cp /configure/Arch/config_file/loader.conf /boot/loader/loader.conf
cp /configure/Arch/config_file/arch.conf /boot/loader/entries/arch.conf

## set root password
echo "root:$rootpass" | chpasswd

## create new user and uncomment visudo for wheel group
useradd -m -G wheel -s /bin/bash $username
echo "$username:$userpass" | chpasswd
sed -i '/%wheel ALL=(ALL) ALL/s/^# //g' /etc/sudoers

## remove configure folder
rm -rf /configure
