#!/usr/bin/env bash

echo "-------------------------------------------------"
echo "Setting up mirrors for optimal download - US Only"
echo "-------------------------------------------------"
timedatectl set-ntp true
pacman -S --noconfirm pacman-contrib



echo -e "\nInstalling prereqs...\n$HR"
pacman -S --noconfirm gptfdisk btrfs-progs

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
sgdisk -n 2:0:+195000M ${DISK} # partition 2 (Root), default start block, 195GB


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

mount -t ext4 "${DISK}2" /mnt
mkdir -p /dev/"${DISK}1" /mnt/boot/efi

pacstrap /base linux linux-firmware nano sudo man git 
gensfstab -U /mnt >> /mnt/etc/fstab

arch-chroot /mnt

git clone https://github.com/dspates81/ArchInst.git

#./ArchInst/Arch_Installation.sh
