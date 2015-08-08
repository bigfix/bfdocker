#!/bin/bash

set -e
set -x

# Turn on selinux to be more like production
sed -i 's/SELINUX=permissive/SELINUX=enforcing/' /etc/selinux/config
setenforce 1

# Add host entry for sandbox.bigfix.com
echo 127.0.0.1 sandbox.bigfix.com >> /etc/hosts

# Apply updates, required for latest docker
yum -y update

# Run docker install script
# see https://docs.docker.com/docker/installation/centos/
curl -sSL https://get.docker.com/ | sh

# Setup Makefile that points to the Makefile in the source directory
echo 'SOURCE=/vagrant' >> /home/vagrant/Makefile
echo 'include /vagrant/Makefile' >> /home/vagrant/Makefile

# Start docker
systemctl enable docker
systemctl start docker

# Pull official centos7 base image from docker hub
docker pull centos:7
