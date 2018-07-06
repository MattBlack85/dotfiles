#!/bin/bash
ln -sf /usr/share/zoneinfo/Europe/Warsaw /etc/localtime
hwclock --systohc
sed -i -e 's/#en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/g' /etc/locale.gen
locale-gen
echo "archmatt" >> /etc/hostname
cat <<EOF > /etc/hosts
127.0.0.1	localhost
::1		localhost
127.0.1.1	achmatt.localdomain	archmatt
EOF
pacman -Sy sudo wpa_supplicant efibootmgr grub xmonad xmobar emacs firefox net-tools sbcl git xorg-server zsh pulseaudio gzip unzip openssh wget rxvt-unicode
passwd
useradd -m matt
passwd matt
grub-install --target=x86_64-efi --efi-directory=/boot --bootloader-id=GRUB
grub-mkconfig -o /boot/grub/grub.cfg
systemctl enable dhcpcd
git clone https://github.com/MattBlack85/dotfiles.git /home/data/repos/dotfiles
git clone https://github.com/robbyrussell/oh-my-zsh.git /home/matt/.oh-my-zsh
git clone https://github.com/powerline/fonts.git /home/matt/repos/fonts
export $HOME=/home/matt/ && ./home/matt/repos/fonts/install.sh
ln -s /home/data/repos/dotfiles/.emacs /home/matt/.emacs
ln -s /home/data/repos/dotfiles/zsh/.zshrc /home/matt/.zshrc
ln -s /home/data/repos/dotfiles/.xmobarrc /home/matt/.xmobarrc
ln -s /home/data/repos/dotfiles/.xinitrc /home/matt/.xinitrc
ln -s /home/data/repos/dotfiles/.Xdefaults /home/matt/.Xdefaults
mkdir /home/matt/.xmonad
ln -s /home/data/repos/dotfiles/.xmonad/.xmonad.hs /home/matt/.xmonad/.xmonad.hs
exit
