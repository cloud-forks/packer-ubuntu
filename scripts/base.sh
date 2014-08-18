#!/bin/sh -ex

cat <<EOF > /etc/sysctl.d/9999_ipv6.conf
net.ipv6.conf.all.use_tempaddr = 0
net.ipv6.conf.default.use_tempaddr = 0
EOF

apt-get -y --force-yes update
apt-get -y --force-yes install qemu-guest-agent
apt-get -y --force-yes dist-upgrade

cat <<EOF > /etc/fstab
# /etc/fstab: static file system information.
#
# Use 'blkid' to print the universally unique identifier for a
# device; this may be used with UUID= as a more robust way to name devices
# that works even if disks are added and removed. See fstab(5).
#
# <file system> <mount point>   <type>          <options>                        <dump>  <pass>
/dev/sda1       /               ext4    defaults,relatime,discard,errors=panic      0       1
EOF

export DEBIAN_FRONTEND=noninteractive DEBCONF_NONINTERACTIVE_SEEN=true
dpkg-reconfigure grub-pc
