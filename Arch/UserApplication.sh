#!/bin/bash

git clone --bare https://github.com/nobabykill/dotfiles.git $HOME/.dotfiles
/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME checkout -f

## detect laptop or pc
read -p 'this device is pc or laptop (1:pc, 2:laptop) ? ' device_type

# populate key
sudo pacman-key --populate archlinux

## yay
git clone https://aur.archlinux.org/yay.git
cd yay
makepkg -si --noconfirm
cd -
rm -rf yay

## install xorg
sudo pacman -S --noconfirm xorg xorg-xinit git
echo 'exec i3' >> ~/.xinitrc

## install i3 and i3status
sudo pacman -S --noconfirm i3-gaps i3blocks
yay -S --noconfirm i3lock-color

## install st
git clone https://github.com/khuedoan/st.git
cd st
sed -i 's/*font.*$/*font = "DejaVuSansMono Nerd Font Mono:pixelsize=17:antialias=true:autohint=true";/' config.h
sudo make clean install
cd ..
rm -rf st

## install tmux
sudo pacman -S --noconfirm tmux

## install nvim
sudo pacman -S --noconfirm neovim nodejs yarn
git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
sudo ln -sf /usr/bin/nvim /usr/bin/vi
sudo ln -sf /usr/bin/nvim /usr/bin/vim

## install zsh
sudo pacman -S --noconfirm zsh zsh-completions dash
sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" --unattended
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions

## audio
sudo pacman -S --noconfirm alsa-utils pulseaudio-alsa pamixer

## screenshot
sudo pacman -S --noconfirm xclip scrot

## install dmenu
sudo pacman -S --noconfirm dmenu

## file management
sudo pacman -S --noconfirm nautilus

## ibus
sudo pacman -S --noconfirm ibus
yay -S --noconfirm ibus-bamboo ibus-mozc

## compton
yay -S --noconfirm compton-tryone-git feh

## wallpaper
mkdir ~/Pictures
cp -R ~/configure/Arch/wallpaper ~/Pictures/

## font
sudo pacman -S --noconfirm ttf-dejavu ttf-liberation otf-ipafont ttf-hanazono 
yay -S --noconfirm nerd-fonts-source-code-pro nerd-fonts-dejavu-complete

## theme and icon
sudo pacman -S --noconfirm  arc-icon-theme deepin-gtk-theme

## miscellaneous
sudo pacman -S --noconfirm tree neofetch thefuck 
sudo pacman -S --noconfirm network-manager-applet

## kvm
sudo pacman -S --noconfirm virt-manager qemu vde2 ebtables dnsmasq bridge-utils openbsd-netcat ovmf
sudo bash -c 'echo nvram = [\"/usr/share/ovmf/x64/OVMF_CODE.fd:/usr/share/ovmf/x64/OVMF_VARS.fd\"] >> /etc/libvirt/qemu.conf'
sudo cp ~/configure/Arch/config_file/50-libvirt.rules /etc/polkit-1/rules.d/50-libvirt.rules
sudo usermod -aG kvm $USER

## change default shell for user
sudo usermod -s /bin/zsh $USER 

## time zone
sudo timedatectl set-timezone Asia/Ho_Chi_Minh
sudo timedatectl set-local-rtc 1 --adjust-system-clock

## git
git config --global core.editor vim
git config --global credential.helper store
git config --global user.email "linh1612340@gmail.com"
git config --global user.name "nobabykill" 

## lightdm
sudo pacman -S --noconfirm lightdm lightdm-webkit2-greeter 
sudo systemctl enable lightdm
sudo sed -i 's/#greeter-session=example-gtk-gnome/greeter-session=lightdm-webkit2-greeter/g' /etc/lightdm/lightdm.conf

## utilize multi threads compress
sudo sed -i -e "s/COMPRESSXZ=.*$/COMPRESSXZ=(xz -c -z - --threads=`grep -c ^processor /proc/cpuinfo`)/g" /etc/makepkg.conf 
sudo sed -i -e "s/COMPRESSZST=.*$/COMPRESSZST=(zstd -c -z -q - --threads=`grep -c ^processor /proc/cpuinfo`)/g" /etc/makepkg.conf 

## enable android caple connection file transfer
sudo pacman -S --noconfirm gvfs-mtp mtpfs

## install utility command
# k9s
sudo pacman -S --noconfirm k9s
# kubectl
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
chmod +x kubectl
sudo mv kubectl /usr/bin/kubectl

# docker
sudo pacman -S --noconfirm docker docker-compose
sudo groupadd docker
sudo usermod -aG docker $USER

## check if device is laptop
if [ $device_type -eq 2 ] 
then
    ## brightness
    sudo pacman -S --noconfirm xorg-xbacklight xf86-video-intel
    sudo cp ~/configure/Arch/config_file/20-intel.conf /etc/X11/xorg.conf.d/20-intel.conf

    ## touchpad
    sudo pacman -S --noconfirm xf86-input-libinput
    sudo cp ~/configure/Arch/config_file/30-touchpad.conf /etc/X11/xorg.conf.d/30-touchpad.conf
fi
