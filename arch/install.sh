#!/bin/bash

# mount /root
mount /dev/sda2 /mnt

# make dirs
mkdir /mnt/home
mkdir /mnt/var
mkdir /mnt/boot

# mount /home and make data dir
mount /dev/sda5 /mnt/home
mkdir /mnt/home/data

# mount /var
mount /dev/sda4 /mnt/var

# mount /boot
mount /dev/sda1 /mnt/boot

# mount /data under /home
mount /dev/sdb1 /mnt/home/data

# create and mount swap
mkswap /dev/sda3
swapon /dev/sda3

pacstrap /mnt base
genfstab -U /mnt >> /mnt/etc/fstab
wget https://raw.githubusercontent.com/MattBlack85/dotfiles/master/arch/arch_post.sh
cp arch_post.sh /mnt/chroot.sh
chmod +x /mnt/arch_post.sh
arch-chroot /mnt ./chroot.sh
rm /mnt/chroot.sh
