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

# 1) 先将 C:\ubuntu 改名为 C:\ubuntu_1710

# 2) 用软件 EasyBCD 2.3　查看现在 ubuntu 17.10 所用的 ID
# identifier              {905b6225-f81c-11e5-8d07-e79e7f21200d}
# device                  partition=C:
# path                    \ubuntu\winboot\wubildr.mbr
# description             Ubuntu 17.10

# 3) 然后进入 command prompt 输入以下, 修改以上的 path
# > bcdedit /set {905b6225-f81c-11e5-8d07-e79e7f21200d} path \ubuntu_1710\winboot\wubildr.mbr

# 4) 将以上制作 C:\winboot　里的 5 个文件, 取代现在原有的 C:\ubuntu_1710\winboot
# 也要将 C:\wubildr 和 C:\wubildr.mbr 更换掉 (是否能进入 Grub 2, 这可是关键..)

# --------------------- Ubuntu 17.10 (进入系统修改设置) ---------------------

# 1) 进入 Grub 2, 选 ubuntu, 按 e, 进入编辑模式
# 将 2 处路径 /ubuntu/disks/root.disk 改为 /ubuntu_1710/disks/root.disk
# 然后按 ctrl+x 运行

# 2) 进入 ubuntu 后, 将 /etc/fstab 修改下 root.disk 与 swap.disk 的路径
# $ sudo gedit /etc/fstab
# /ubuntu/ 改为 /ubuntu_1710/

# 3) 更新 Grub 2
# $ sudo update-grub

