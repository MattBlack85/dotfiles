#!/bin/bash
pacstrap /mnt base
genfstab -U /mnt >> /mnt/etc/fstab
wget https://raw.githubusercontent.com/MattBlack85/dotfiles/master/arch/arch_post.sh
chmod u+x arch_post.sh
cp arch_post.sh /mnt/chroot.sh
arch-chroot /mnt
rm /mnt/chroot.sh
