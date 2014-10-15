#!/bin/bash -ex

apt-get -y --force-yes install software-properties-common

add-apt-repository --yes ppa:juju/stable
apt-get -y --force-yes update
apt-get -y --force-yes install juju-core sudo python-yaml python3-yaml
useradd -G sudo -s /bin/bash -m -d /home/ubuntu ubuntu

cat <<EOF > /etc/sudoers.d/90-juju-ubuntu
ubuntu ALL=(ALL) NOPASSWD:ALL
EOF

su -l ubuntu <<EOF
mkdir -p /home/ubuntu/.ssh
mkdir -p /home/ubuntu/.juju/ssh/
ssh-keygen -t rsa -b 4096 -f /home/ubuntu/.juju/ssh/juju_id_rsa -N ''
test -f /home/ubuntu/.juju/ssh/juju_id_rsa.pub && cat /home/ubuntu/.juju/ssh/juju_id_rsa.pub >> /home/ubuntu/.ssh/authorized_keys

juju generate-config
juju switch manual
sed -i 's|somehost.example.com|127.0.0.1|g' /home/ubuntu/.juju/environments.yaml

juju bootstrap --debug
mkdir -p /home/ubuntu/charms/trusty
git clone https://github.com/vtolstov/charm-mysql /home/ubuntu/charms/trusty/mysql
git clone https://github.com/vtolstov/charm-wordpress /home/ubuntu/charms/trusty/wordpress
juju deploy --repository=/home/ubuntu/charms/ local:trusty/mysql --to 0
juju set mysql dataset-size=50%
juju set mysql query-cache-type=ON
juju set mysql query-cache-size=-1
juju deploy --repository=/home/ubuntu/charms/ local:trusty/wordpress --to 0
juju add-relation mysql wordpress

juju expose wordpress


while true; do
  juju run --service=wordpress "./health" | grep -q success && break
  juju run --service=wordpress "./health"
  sleep 5s
done

EOF
