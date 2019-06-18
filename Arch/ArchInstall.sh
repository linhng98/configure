#!/bin/bash

## detect laptop or pc
read -p 'this device is pc or laptop (1:pc, 2:laptop) ? ' device_type

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
echo "ArchLinux" > /etc/hostname

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

su $username <<'EOF'
## install xorg
sudo pacman -S --noconfirm xorg xorg-xinit
echo 'exec i3' >> ~/.xinitrc

## install i3 and i3-blocks
sudo pacman -S --noconfirm i3-wm i3blocks
mkdir -p ~/.config/i3
mkdir ~/.config/i3blocks
cp /configure/Arch/config_file/i3 ~/.config/i3/config
cp /configure/Arch/config_file/i3blocks ~/.config/i3blocks/config
sudo pacman -S --noconfirm sysstat

## install urxvt
sudo pacman -S --noconfirm rxvt-unicode
cp /configure/Arch/config_file/Xresources ~/.Xresources

## install gvim
sudo pacman -S --noconfirm gvim
cp /configure/Arch/config_file/vimrc ~/.vimrc

## install zsh
sudo pacman -S --noconfirm zsh zsh-completions dash
cp /configure/Arch/config_file/zshrc ~/.zshrc # copy config 

## audio
sudo pacman -S --noconfirm alsa-utils pulseaudio-alsa pamixer

## screenshot
sudo pacman -S --noconfirm xclip scrot

## install font
sudo pacman -S --noconfirm ttf-dejavu noto-fonts-emoji otf-ipafont ttf-hanazono

## install dmenu
sudo pacman -S --noconfirm dmenu

## file management
sudo pacman -S --noconfirm nautilus

## fcitx
sudo pacman -S --noconfirm fcitx fcitx-im fcitx-unikey fcitx-configtool fcitx-mozc
cp /configure/Arch/config_file/pam_environment ~/.pam_environment

## time zone
sudo timedatectl set-timezone Asia/Ho_Chi_Minh
sudo timedatectl set-local-rtc 1

## compton
sudo pacman -S --noconfirm compton
cp /configure/Arch/config_file/compton ~/.config/compton.conf
EOF

usermod -s /bin/zsh $username # change default shell for user $username

## remove configure folder
rm -rf /configure
