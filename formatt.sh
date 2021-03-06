#!/usr/bin/env bash

echo -e "\nInstalling prereqs...\n$HR"
pacman -S --noconfirm gptfdisk 

echo "-------------------------------------------------"
echo "-------select your disk to format----------------"
echo "-------------------------------------------------"
lsblk
echo "Please enter disk: (example /dev/sda)"
read DISK
echo "--------------------------------------"
echo -e "\nFormatting disk...\n$HR"
echo "--------------------------------------"

# disk prep
sgdisk -Z ${DISK} # zap all on disk
sgdisk -a ${DISK} # new gpt disk 2048 alignment


# create partitions
sgdisk -n 1:0:+5000M ${DISK} # partition 1 (UEFI SYS), default start block, 5GB
sgdisk -n 2:0:+100000M ${DISK} # partition 2 (Root), default start block, 100GB


# set partition types
sgdisk -t 1:ef00 ${DISK}
sgdisk -t 2:8300 ${DISK}

# label partitions
sgdisk -c 1:"UEFISYS" ${DISK}
sgdisk -c 2:"ROOT" ${DISK}


# make filesystems
echo -e "\nCreating Filesystems...\n$HR"

mkfs.vfat -F32 -n "UEFISYS" "${DISK}1"
mkfs.ext4 -L "ROOT" "${DISK}2"

# mount target
#mount -t ext4 "${DISK}2" /mnt
#mkdir - p /mnt/boot/efi
#mount -t "${DISK}1" /mnt/boot/efi
#mount -t vfat "${DISK}1" /mnt/boot/efi


