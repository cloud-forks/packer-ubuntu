#!/bin/sh -e

apt-get install -y software-properties-common python-jsonpatch python-prettytable python-setuptools python-requests
dpkg -i /tmp/cloud-init_0.7.5-0ubuntu1_all.deb
rm -f /tmp/cloud-init_0.7.5-0ubuntu1_all.deb

