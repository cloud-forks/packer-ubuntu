#!/bin/sh -ex

update-grub

apt-get -y --force-yes install qemu-guest-agent
