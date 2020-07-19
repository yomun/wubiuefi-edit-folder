#!/usr/bin/env bash

#
# https://jasonmun.blogspot.my
# http://jasonmun.blogspot.my/2017/07/ubuntu-wubi.html
# https://github.com/yomun
# 
# Copyright (C) 2017 Jason Mun
# 

NEW_FOLDER_NAME="ubuntu_1710"

cd ~

mkdir -p build/winboot

cp /host/ubuntu/winboot/wubildr.cfg build/winboot
cp /host/ubuntu/winboot/wubildr-bootstrap.cfg build/winboot

sed -i "s/\/ubuntu\//\/${NEW_FOLDER_NAME}\//g" build/winboot/wubildr.cfg

/usr/lib/grub/i386-pc/grub-ntldr-img --grub2 --boot-file=wubildr -o build/winboot/wubildr.mbr

cd build/winboot

tar cf wubildr.tar wubildr.cfg

cd ~
mkdir -p build/grubutil

grub-mkimage -O i386-pc -c build/winboot/wubildr-bootstrap.cfg -m build/winboot/wubildr.tar -o build/grubutil/core.img loadenv normal biosdisk part_msdos part_gpt fat ntfs ext2 ntfscomp iso9660 loopback search linux boot minicmd cat cpuid chain halt help ls reboot echo test configfile gzio sleep memdisk tar font gfxterm gettext true vbe vga video_bochs video_cirrus probe

cat /usr/lib/grub/i386-pc/lnxboot.img build/grubutil/core.img > build/winboot/wubildr

cp -r build/winboot /host

# --------------------- Windows 7 (修改 Windows Boot Manager 的设置和替换启动文件) ---------------------

# 1) 进入 Grub 2, 选 ubuntu, 按 e, 进入编辑模式

# 将 2 处路径 /ubuntu/disks/root.disk 
# 改为 
# /ubuntu_16/disks/root.disk

# 将 ro quiet splash $vt_handoff
# 改为
# rw single init=/bin/bash

# 然后按 Ctrl+x 运行, 进入单机模式 bash

# 2) 进入 bash 后, 将 /etc/fstab 修改下 root.disk 与 swap.disk 的路径

# $ root@none:/# vi /etc/fstab

# /ubuntu/ 改为 /ubuntu_16/

# 3) 更新 Grub 2

# $ root@none:/# update-grub

# 4) 运行, 进入 GNOME

# root@none:/# exec /sbin/init
