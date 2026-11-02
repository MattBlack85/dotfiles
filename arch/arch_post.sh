#!/bin/bash

# Override these values for custom username/hostname
SCRIPT_HOSTNAME=albireo
SCRIPT_USER=matt

# Set the right timezone
ln -sf /usr/share/zoneinfo/Europe/Warsaw /etc/localtime

# Set the RTC from the system time
hwclock --systohc

# Uncomment en_US UTF8 and generate locale files
sed -i -e 's/#en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/g' /etc/locale.gen
locale-gen

# set the hostname to HOSTNAME
echo $SCRIPT_HOSTNAME >> /etc/hostname
cat <<EOF > /etc/hosts
127.0.0.1	localhost
::1		localhost
127.0.1.1	${SCRIPT_HOSTNAME}.localdomain	${SCRIPT_HOSTNAME}
EOF

# Install some base packages
pacman -Sy sudo wpa_supplicant ntp efibootmgr grub python \
           python-pip emacs firefox net-tools htop sbcl git chromium \
           networkmanager zsh pipewire pipewire-pulse gzip unzip openssh \
           wget docker alsa-utils libxss make vlc linux-headers acpid \
           dnsutils dhcpcd direnv pyenv kitty hyprland nerdfonts \
           hyprpolkitagent xdg-desktop-portal-hyprland wl-clipboard cliphist --noconfirm

# Prompt for a new password for ROOT
passwd

# Create a new USER and prompt for a new password for USER
useradd -m $SCRIPT_USER
passwd $SCRIPT_USER

# mount /data under /home
mkdir /home/$SCRIPT_USER/data
mount /dev/sdb1 /home/matt/data
if [ ! -d "/home/"$SCRIPT_USER"/data/repos" ]; then
    mkdir /home/$SCRIPT_USER/data/repos
fi

# Install the bootloader
grub-install --target=x86_64-efi --efi-directory=/boot --bootloader-id=GRUB
grub-mkconfig -o /boot/grub/grub.cfg

# Enable services at startup
systemctl enable dhcpcd ntpd NetworkManager acpid

# Install stuff for python - be aware that these are installed globally
pip install jedi epc autopep8 flake8

# Configure git
git config --global user.email "promat85@gmail.com"
git config --global user.name "Mattia Procopio"

# Add $SCRIPT_USER to docker group
usermod -aG docker $SCRIPT_USER

# Add $SCRIPT_USER to tty group
usermod -aG uucp $SCRIPT_USER

# Check if we have repos already available before checking them out
if [ ! -d "/home/"$SCRIPT_USER"/data/repos/dotfiles" ]; then
    git clone https://github.com/MattBlack85/dotfiles.git /home/matt/data/repos/dotfiles
fi
if [ ! -d "/home/"$SCRIPT_USER"/.oh-my-zsh" ]; then
    git clone https://github.com/robbyrussell/oh-my-zsh.git /home/matt/.oh-my-zsh
fi
if [ ! -d "/home/"$SCRIPT_USER"/data/repos/fonts" ]; then
    git clone https://github.com/powerline/fonts.git /home/matt/data/repos/fonts
fi

# Install fonts for powerline
export HOME=/home/$SCRIPT_USER/ && ./home/$SCRIPT_USER/data/repos/fonts/install.sh

# Orbitron (cyberpunk font used by the eww keybinds popup), SIL Open Font License.
# Not in the official repos and paru can't run as root, so install the file system-wide.
if [ ! -f /usr/local/share/fonts/orbitron/Orbitron.ttf ]; then
    mkdir -p /usr/local/share/fonts/orbitron
    wget -q -O /usr/local/share/fonts/orbitron/Orbitron.ttf \
        'https://github.com/google/fonts/raw/main/ofl/orbitron/Orbitron%5Bwght%5D.ttf'
    fc-cache -f
fi

# Link dotfiles to locations where they are used for real so they will be synced with git repos
ln -s /home/$SCRIPT_USER/data/repos/dotfiles/.emacs /home/$SCRIPT_USER/.emacs
ln -s /home/$SCRIPT_USER/data/repos/dotfiles/zsh/.zshrc /home/$SCRIPT_USER/.zshrc
# Wayland / Hyprland
mkdir -p /home/$SCRIPT_USER/.config/eww
ln -s /home/$SCRIPT_USER/data/repos/dotfiles/hypr /home/$SCRIPT_USER/.config/hypr
ln -s /home/$SCRIPT_USER/data/repos/dotfiles/fuzzel /home/$SCRIPT_USER/.config/fuzzel
ln -s /home/$SCRIPT_USER/data/repos/dotfiles/eww/eww.yuck /home/$SCRIPT_USER/.config/eww/
ln -s /home/$SCRIPT_USER/data/repos/dotfiles/eww/eww.scss /home/$SCRIPT_USER/.config/eww/
ln -s /home/$SCRIPT_USER/data/repos/dotfiles/eww/scripts /home/$SCRIPT_USER/.config/eww/scripts

# folders, links and files have been manipulated all by root, change owner
chown $SCRIPT_USER:$SCRIPT_USER /home/$SCRIPT_USER -R

# VERY IMPORTANT for powerline fonts
echo "LANG=en_US.UTF-8" > /etc/locale.conf
echo "KEYMAP=it" > /etc/vconsole.conf

# Set the best shell for my user
chsh -s /bin/zsh $SCRIPT_USER

exit 0
