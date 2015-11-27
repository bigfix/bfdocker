#!/bin/bash
echo running commmon provisioner
cp /vagrant/resources/motd /etc/motd
set -e
set -x

# Turn on selinux to be more like production
sed -i 's/SELINUX=permissive/SELINUX=enforcing/' /etc/selinux/config
setenforce 1

# Add host entry for sandbox.bigfix.com
echo 127.0.0.1 sandbox.bigfix.com >> /etc/hosts

# Apply updates, required for latest docker
#yum -y update

# Run docker install script
# see https://docs.docker.com/docker/installation/centos/
curl -sSL https://get.docker.com/ | sh

# change the docker config to allocate 20G to containers
# see https://docs.docker.com/articles/systemd/ for info on configuration
mkdir -p /etc/systemd/system/docker.service.d
echo '[Service]' > /etc/systemd/system/docker.service.d/docker.conf
echo 'ExecStart=' >> /etc/systemd/system/docker.service.d/docker.conf
echo "ExecStart=/usr/bin/docker -d -s=devicemapper --storage-opt dm.basesize=20G -H fd:// " \
    >>  /etc/systemd/system/docker.service.d/docker.conf
systemctl daemon-reload

# Start docker and set to start on boot
systemctl start docker
systemctl enable docker

# install docker compose
curl -L \
  https://github.com/docker/compose/releases/download/1.4.2/docker-compose-`uname -s`-`uname -m` \
  > /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose
