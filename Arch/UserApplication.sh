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
yay -S --noconfirm libxft-bgra

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
sudo pacman -S --noconfirm xclip scrot flameshot

## install dmenu
sudo pacman -S --noconfirm dmenu feh

## file management
sudo pacman -S --noconfirm nautilus

## ibus
sudo pacman -S --noconfirm ibus
yay -S --noconfirm ibus-bamboo ibus-mozc

## compton
sudo pacman -S picom

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
sudo pacman -S --noconfirm virt-manager qemu vde2 dnsmasq bridge-utils gnu-netcat ovmf
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
git config --global user.name "linhng98" 

## lightdm
sudo pacman -S --noconfirm lightdm lightdm-gtk-greeter 
sudo systemctl enable lightdm

## utilize multi threads compress
sudo sed -i -e "s/COMPRESSXZ=.*$/COMPRESSXZ=(xz -c -z - --threads=`grep -c ^processor /proc/cpuinfo`)/g" /etc/makepkg.conf 
sudo sed -i -e "s/COMPRESSZST=.*$/COMPRESSZST=(zstd -c -z -q - --threads=`grep -c ^processor /proc/cpuinfo`)/g" /etc/makepkg.conf 

## enable android caple connection file transfer
sudo pacman -S --noconfirm gvfs-mtp mtpfs unzip

## install utility command
# k9s
curl -L -O https://github.com/derailed/k9s/releases/download/v0.26.6/k9s_Linux_x86_64.tar.gz
tar -zxvf k9s_Linux_x86_64.tar.gz -C /tmp
sudo mv /tmp/k9s /usr/bin/k9s

# kubectl
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
chmod +x kubectl
sudo mv kubectl /usr/bin/kubectl

# docker
sudo pacman -S --noconfirm docker docker-compose
sudo groupadd docker
sudo usermod -aG docker $USER

cd /tmp

# gcloud sdk
curl -L https://dl.google.com/dl/cloudsdk/channels/rapid/downloads/google-cloud-sdk-404.0.0-linux-x86_64.tar.gz --output google-cloud-sdk.tar.gz
sudo tar -zxvf google-cloud-sdk.tar.gz -C /opt
sudo ln -sf /opt/google-cloud-sdk/bin/gcloud /usr/bin/gcloud

# aws cli
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install

# azure cli
git clone https://github.com/dmakeienko/azcli.git ~/.oh-my-zsh/custom/plugins/azcli
curl -L https://raw.githubusercontent.com/Azure/azure-cli/dev/az.completion -o ~/.oh-my-zsh/custom/az.completion
sudo pacman -S --noconfirm python-pip
pip install azure-cli
pip install argcomplete

# ansible
sudo pacman -S --noconfirm ansible

# helm
helm_version="v3.10.0"
curl -L "https://get.helm.sh/helm-${helm_version}-linux-amd64.tar.gz" --output helm.tar.gz
tar -zxvf helm.tar.gz
sudo mv linux-amd64 /opt/helm_${helm_version}
sudo ln -sf /opt/helm_${helm_version}/helm /usr/bin/helm

# kubectl
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
chmod +x kubectl
sudo mv kubectl /usr/bin

# terraform
curl -L https://releases.hashicorp.com/terraform/1.3.1/terraform_1.3.1_linux_amd64.zip --output terraform.zip
sudo unzip terraform.zip -d /opt/terraform_v1.3.1
sudo ln -sf /opt/terraform_v1.3.1/terraform /usr/bin/terraform
rm -rf terraform.zip

# terragrunt
curl -L https://github.com/gruntwork-io/terragrunt/releases/download/v0.38.0/terragrunt_linux_amd64 --output terragrunt_v0.38.0
chmod +x terragrunt_v0.38.0
sudo mkdir /opt/terragrunt_v0.38.0
sudo mv terragrunt_v0.38.0 /opt/terragrunt_v0.38.0/terragrunt
sudo ln -sf /opt/terragrunt_v0.38.0/terragrunt /usr/bin/terragrunt

# rust
sudo pacman -S --noconfirm rustup
rustup toolchain install stable
rustup default stable
rustup component add rls rust-analysis rust-src

# vagrant
sudo pacman -S --noconfirm vagrant
vagrant plugin install vagrant-libvirt


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
git remote add origin https://github.com/linhng98/dotfiles.git
git pull
git reset --hard origin/master
git config status.showuntrackedfiles no

