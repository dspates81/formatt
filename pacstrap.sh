#!/usr/bin/env bash

pacstrap -i /mnt base linux linux-firmware base-devel linux-headers sudo man nano git
genfstab -U /mnt >> /mnt/etc/fstab
arch-chroot /mnt
