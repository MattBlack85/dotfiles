#!/bin/bash
pacstrap /mnt base
genfstab -U /mnt >> /mnt/etc/fstab
wget https://github.com/MattBlack85/dotfiles/blob/master/arch/arch_post.sh
cp arch_post.sh /mnt/chroot.sh
arch-chroot /mnt
rm /mnt/chroot.sh
