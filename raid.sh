#!/bin/bash

# Create RAID5
mdadm --zero-superblock --force /dev/sd{b..f}
mdadm --create --verbose /dev/md0 -l5 -n5 /dev/sd{b..f}

# Save config
mkdir -p /etc/mdadm
echo "DEVICE partitions" > /etc/mdadm/mdadm.conf
mdadm --detail --scan --verbose | awk '/ARRAY/ {print}' >> /etc/mdadm/mdadm.conf

# Hot add-remove
mdadm /dev/md0 --fail /dev/sdd
mdadm /dev/md0 --remove /dev/sdd
mdadm /dev/md0 --add /dev/sdd

# Make partitions
parted -s /dev/md0 mklabel gpt
for start in `seq 0 20 80`; do end=$(( start + 20 )); \
    parted /dev/md0 mkpart primary ext4 "$start%" "$end%"; done;

# Make filesystems
seq 1 5 | xargs -I{} mkfs.ext4 /dev/md0p{}

# Mount filesystems
mkdir -p /raid/part{1..5}
seq 1 5 | xargs -I{} mount /dev/md0p{} /raid/part{}
