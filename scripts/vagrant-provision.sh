#!/bin/bash

set -e
set -x

# Turn on selinux to be more like production
sed -i 's/SELINUX=permissive/SELINUX=enforcing/' /etc/selinux/config
setenforce 1

# Add host entry for sandbox.bigfix.com
echo 127.0.0.1 sandbox.bigfix.com >> /etc/hosts

# apply OS updates
yum -y update

# run docker install script
# see https://docs.docker.com/docker/installation/centos/
curl -sSL https://get.docker.com/ | sh

# Setup Makefile that points to the Makefile in the source directory
echo 'SOURCE=/vagrant' >> /home/vagrant/Makefile
echo 'include /vagrant/Makefile' >> /home/vagrant/Makefile

# Start docker now
systemctl enable docker
systemctl start docker

# pull official centos base image from docker hub
#docker pull centos:7

# on box restart vboxadd fails to start workaround by updating the tools
# https://gist.github.com/cedricpim/5986a839ff40e6bded86
# requires gcc and kernel-devel to build the tools
yum -y install gcc kernel-devel
mount /vagrant/resources/VBoxGuestAdditions_4.3.28.iso -o loop /mnt
sh /mnt/VBoxLinuxAdditions.run --nox11
