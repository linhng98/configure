#!/bin/bash

## detect laptop or pc
read -p 'this device is pc or laptop (1:pc, 2:laptop) ? ' device_type

## install intel-ucode
pacman -S --noconfirm intel-ucode

## install networkmanager and enable
pacman -S --noconfirm network-manager
systemctl enable NetworkManager

## time zone
timedatectl set-timezone Asia/Ho_Chi_Minh
timedatectl set-local-rtc 1

## locale
sed -i '/en_US.UTF-8/s/^#//g' /etc/locale.gen
locale-gen
echo 'LANG=en_US.UTF-8' > /etc/locale.conf

## hostname
echo "ArchLinux" > /etc/hostname

## set root password
echo 'set root password'
passwd

## install boot loader
bootctl --path=/boot install

echo 'default arch' >> /boot/loader/loader.conf
echo 'timeout 0' >> /boot/loader/loader.conf
echo 'editor 0' >> /boot/loader/loader.conf

echo 'title Arch Linux' >> /boot/loader/entries/arch.conf
echo 'linux /vmlinuz-linux' >> /boot/loader/entries/arch.conf
echo 'initrd /intel-ucode.img' >> /boot/loader/entries/arch.conf
echo 'initrd /initramfs-linux.img' >> /boot/loader/entries/arch.conf
echo 'options root=/dev/sda2 rw' >> /boot/loader/entries/arch.conf

## create new user and uncomment visudo for wheel group
useradd -m -G wheel -s /bin/bash linh
echo 'set user linh password'
passwd linh
sed -i '/%wheel ALL=(ALL) ALL/s/^# //g' /etc/sudoers

## copy file config mirror list
cp /configure/Arch/mirrorlist /etc/pacman.d/mirrorlist

## install i3 and i3-blocks
pacman -S i3
cp /configure/Arch/i3.config /home/linh/.config/i3/config
cp /configure/Arch/i3blocks.conf /home/linh/.config/i3blocks/config
pacman -S --noconfirm sysstat

## install urxvt
pacman -S --noconfirm rxvt-unicode
cp /configure/Arch/Xresources /home/linh/.Xresources

## install gvim
pacman -S --noconfirm gvim
cp /configure/Arch/vimrc /home/linh/.vimrc

## install zsh
pacman -S --noconfirm zsh zsh-completions
cp /configure/Arch/zshrc /home/linh/.zshrc # copy config 
usermod -s /bin/zsh linh # change default shell for user linh

## audio
pacman -S --noconfirm alsamixer pulseaudio-alsa pamixer

## screenshot
pacman -S --noconfirm xclip scrot

## lock i3
pacman -S --noconfirm i3lock

## install font
pacman -S --noconfirm ttf-dejavu

## install chromium
pacman -S --noconfirm chromium

## file management
pacman -S --noconfirm nautilus

## remove configure folder
rm -Rns /configure
