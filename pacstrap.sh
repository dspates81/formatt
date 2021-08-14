#!/usr/bin/env bash

pacstrap -i /mnt base linux linux-firmware base-devel linux-headers openssh sudo git man nano
genfstab -U /mnt >> /mnt/etc/fstab
arch-chroot /mnt
