#!/bin/bash

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
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k

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
sudo pacman -S --noconfirm gvfs-mtp mtpfs unzip

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

# gcloud sdk
curl -LO https://dl.google.com/dl/cloudsdk/channels/rapid/downloads/google-cloud-sdk-340.0.0-linux-x86_64.tar.gz --output google-cloud-sdk.tar.gz
sudo tar -zxvf google-cloud-sdk.tar.gz -C /opt
sudo ln -sf /opt/google-cloud-sdk/bin/gcloud /usr/bin/gcloud
rm -rf 

# helm

# terraform
curl -L https://releases.hashicorp.com/terraform/0.14.11/terraform_0.14.11_linux_amd64.zip --output terraform.zip
sudo unzip terraform.zip -d /opt/terraform_v0.14.11
sudo ln -sf /opt/terraform_v0.14.11/terraform /usr/bin/terraform
rm -rf terraform.zip

# terragrunt
curl -L https://github.com/gruntwork-io/terragrunt/releases/download/v0.28.24/terragrunt_linux_amd64 --output terragrunt_v0.28.24
chmod +x terragrunt_v0.28.24
sudo mkdir /opt/terragrunt_v0.28.24
sudo mv terragrunt_v0.28.24 /opt/terragrunt_v0.28.24/terragrunt
sudo ln -sf /opt/terragrunt_v0.28.24/terragrunt /usr/bin/terragrunt


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

# get config
cd
git init 
git remote add origin https://github.com/nobabykill/dotfiles.git
git pull
git reset --hard origin/master
