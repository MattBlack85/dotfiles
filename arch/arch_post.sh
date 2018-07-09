#!/bin/bash
ln -sf /usr/share/zoneinfo/Europe/Warsaw /etc/localtime
hwclock --systohc
sed -i -e 's/#en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/g' /etc/locale.gen
locale-gen
echo "archmatt" >> /etc/hostname
cat <<EOF > /etc/hosts
127.0.0.1	localhost
::1		localhost
127.0.1.1	archmatt.localdomain	archmatt
EOF
pacman -Sy sudo wpa_supplicant ntp efibootmgr grub xmobar python3 python-pip emacs firefox net-tools sbcl git chromium xorg-server zsh pulseaudio gzip unzip openssh wget rxvt-unicode xorg-xinit xmonad xmonad-contrib docker alsa-utils xrandr libxss gtk2 weechat make vlc linux-headers
passwd
useradd -m matt
passwd matt
# mount /data under /home
mkdir /home/matt/data
mount /dev/sdb1 /home/matt/data
if [ ! -d "/home/matt/data/repos" ]; then
    mkdir /home/matt/data/repos
fi

# Install the bootloader
grub-install --target=x86_64-efi --efi-directory=/boot --bootloader-id=GRUB
grub-mkconfig -o /boot/grub/grub.cfg

# Enable services at startup
systemctl enable dhcpcd docker ntpd

# Install stuff for python
pip install jedi epc autopep8

# Configure git
git config --global user.email "promat85@gmail.com"
git config --global user.name "Mattia Procopio"

# Add my user to docker group
usermod -aG docker matt

# Check if we have repos already available befoe checking them out
if [ ! -d "/home/matt/data/repos/dotfiles" ]; then
    git clone https://github.com/MattBlack85/dotfiles.git /home/matt/data/repos/dotfiles
fi
if [ ! -d "/home/matt/.oh-my-zsh" ]; then
    git clone https://github.com/robbyrussell/oh-my-zsh.git /home/matt/.oh-my-zsh
fi
if [ ! -d "/home/matt/data/repos/fonts" ]; then
    git clone https://github.com/powerline/fonts.git /home/matt/data/repos/fonts
fi

# Install fonts for powerline
export HOME=/home/matt/ && ./home/matt/data/repos/fonts/install.sh

# Link dotfile to locations where they are used for real so they will be synced with git repos
ln -s /home/matt/data/repos/dotfiles/.emacs /home/matt/.emacs
ln -s /home/matt/data/repos/dotfiles/zsh/.zshrc /home/matt/.zshrc
ln -s /home/matt/data/repos/dotfiles/.xmobarrc /home/matt/.xmobarrc
ln -s /home/matt/data/repos/dotfiles/.xinitrc /home/matt/.xinitrc
ln -s /home/matt/data/repos/dotfiles/.Xdefaults /home/matt/.Xdefaults
mkdir /home/matt/.xmonad
ln -s /home/matt/data/repos/dotfiles/.xmonad/xmonad.hs /home/matt/.xmonad/

# folders, links and files have been manipulated all by root, change owner
chown matt:matt /home/matt -R

# VERY IMPORTANT for powerline fonts
echo "LANG=en_US.UTF-8" > /etc/locale.conf
echo "KEYMAP=it" > /etc/vconsole.conf

# Set the best shell for my user
chsh -s /bin/zsh matt
exit
