#!/bin/bash

# Prompt the user to enter the disk name
read -p "Enter the disk name (e.g., /dev/sdb): " disk_name

# Check if the disk exists
if [ ! -e "$disk_name" ]; then
    echo "Error: Disk $disk_name does not exist."
    exit 1
fi

# Initialize the disk with LVM
echo "Initializing disk $disk_name with LVM..."
pvcreate $disk_name

# Create a volume group
read -p "Enter the volume group name: " vg_name
vgcreate $vg_name $disk_name

# Create a logical volume
read -p "Enter the logical volume name: " lv_name
read -p "Enter the size of the logical volume (e.g., 10G): " lv_size
lvcreate -n $lv_name -L $lv_size $vg_name

# Prompt the user to select the filesystem type
echo "Select the filesystem type:"
echo "1. ext4"
echo "2. xfs"
read -p "Enter your choice (1 or 2): " fs_choice

case $fs_choice in
    1)
        fs_type="ext4"
        ;;
    2)
        fs_type="xfs"
        ;;
    *)
        echo "Invalid choice. Defaulting to ext4."
        fs_type="ext4"
        ;;
esac

# Format the logical volume
echo "Formatting the logical volume with $fs_type filesystem..."
mkfs.$fs_type /dev/$vg_name/$lv_name

# Mount the logical volume
read -p "Enter the mount point for the logical volume: " mount_point
mkdir -p $mount_point
mount /dev/$vg_name/$lv_name $mount_point

# Add the logical volume to /etc/fstab for auto-mounting on boot
echo "/dev/$vg_name/$lv_name   $mount_point   $fs_type    defaults   0 0" >> /etc/fstab

echo "LVM setup completed successfully."

