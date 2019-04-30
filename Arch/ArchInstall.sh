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

## install boot loader
bootctl --path=/boot install

rm -rf /boot/loader/loader.conf
echo 'default arch' >> /boot/loader/loader.conf
echo 'timeout 0' >> /boot/loader/loader.conf
echo 'editor 0' >> /boot/loader/loader.conf

echo 'title Arch Linux' >> /boot/loader/entries/arch.conf
echo 'linux /vmlinuz-linux' >> /boot/loader/entries/arch.conf
echo 'initrd /intel-ucode.img' >> /boot/loader/entries/arch.conf
echo 'initrd /initramfs-linux.img' >> /boot/loader/entries/arch.conf
echo 'options root=/dev/sda2 rw' >> /boot/loader/entries/arch.conf
