#!/usr/bin/env bash

pacstrap /mnt base linux linux-firmware nano sudo git man
genfstab -U /mnt >> /mnt/etc/fstab
arch-chroot /mnt
git clone https://github.com/dspates81/ArchInst
