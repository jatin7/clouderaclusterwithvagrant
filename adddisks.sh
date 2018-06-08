#!/bin/bash
# Adding disk vdb
cat <<EOF | sudo fdisk /dev/vdb
n
p
1


w
EOF
partprobe

#Adding disk vdc
cat <<EOF | fdisk /dev/vdc
n
p
1


w
EOF
partprobe

#Formatting the disks
cat <<EOF | sudo mkfs.ext4 /dev/vdb


EOF

cat <<EOF | sudo mkfs.ext4 /dev/vdc


EOF

#Creating the mounting points and mounting the disks
sudo mkdir /disk1
sudo mkdir /disk2
sudo mount /dev/vdb /disk1
sudo mount /dev/vdc /disk2

#Adding disk information to fstab file
echo -e "/dev/vdb    /disk0    ext4    defaults    1    1" | sudo tee -a /etc/fstab
echo -e "/dev/vdc    /disk1    ext4    defaults    1    1" | sudo tee -a /etc/fstab

