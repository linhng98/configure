#!/bin/bash

## detect laptop or pc
read -p 'this device is pc or laptop (1:pc, 2:laptop) ? ' device_type

## input username and password
read -p 'input root password : ' rootpass
read -p 'input user name : ' username
read -p 'input user password : ' userpass

## install intel-ucode
pacman -S --noconfirm intel-ucode

## install networkmanager and enable
pacman -S --noconfirm networkmanager
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

## set root password
echo "root:$rootpass" | chpasswd

## create new user and uncomment visudo for wheel group
useradd -m -G wheel -s /bin/bash $username
echo "$username:$userpass" | chpasswd
sed -i '/%wheel ALL=(ALL) ALL/s/^# //g' /etc/sudoers

## copy file config mirror list
cp /etc/pacman.d/mirrorlist /etc/pacman.d/mirrorlist.backup # backup mirror
cp /configure/Arch/mirrorlist /etc/pacman.d/mirrorlist

su $username <<'EOF'
## install xorg
sudo pacman -S --noconfirm xorg xorg-xinit
echo 'exec i3' >> ~/.xinitrc

## install i3 and i3-blocks
sudo pacman -S --noconfirm i3-wm i3blocks
mkdir -p ~/.config/i3
mkdir ~/.config/i3blocks
cp /configure/Arch/i3.config ~/.config/i3/config
cp /configure/Arch/i3blocks.conf ~/.config/i3blocks/config
sudo pacman -S --noconfirm sysstat

## install urxvt
sudo pacman -S --noconfirm rxvt-unicode
cp /configure/Arch/Xresources ~/.Xresources

## install gvim
sudo pacman -S --noconfirm gvim
cp /configure/Arch/vimrc ~/.vimrc

## install zsh
sudo pacman -S --noconfirm zsh zsh-completions
cp /configure/Arch/zshrc ~/.zshrc # copy config 

## audio
sudo pacman -S --noconfirm alsa-utils pulseaudio-alsa pamixer

## screenshot
sudo pacman -S --noconfirm xclip scrot

## install font
sudo pacman -S --noconfirm ttf-dejavu otf-ipafont ttf-hanazono

## install dmenu
sudo pacman -S --noconfirm dmenu

## file management
sudo pacman -S --noconfirm nautilus

## fcitx
sudo pacman -S --noconfirm fcitx fcitx-im fcitx-unikey fcitx-configtool fcitx-mozc

echo 'GTK_IM_MODULE=fcitx' >> ~/.pam_environment
echo 'QT_IM_MODULE=fcitx' >> ~/.pam_environment
echo 'XMODIFIERS=@im=fcitx' >> ~/.pam_environment

## install pikaur (aur helper)
git clone https://aur.archlinux.org/pikaur.git ~/pikaur
cd ~/pikaur
sudo pacman -S --noconfirm pyalpm python
makepkg
sudo pacman -U --noconfirm *.pkg.tar.xz
cd --
rm -rf ~/pikaur

## install i3lock-next
pikaur -S --noconfirm i3lock-next-git
EOF

usermod -s /bin/zsh $username # change default shell for user $username

## remove configure folder
rm -rf /configure
