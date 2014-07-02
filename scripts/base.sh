#!/bin/sh -ex


sed -i 's,UUID=[^[:blank:]]*,/dev/sda1,' /etc/fstab
sed -i 's,UUID=[^[:blank:]]*,/dev/sda1,' /boot/grub/grub.cfg
