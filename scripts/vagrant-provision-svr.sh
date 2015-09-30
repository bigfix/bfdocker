#!/bin/bash

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

# login to docker to get access to the db2express-c image
# redirect output to stop it echoing back through vagrant output
docker login -e $1 -u $2 -p $3

# build docker image with the evaluation edition of BigFix server (besserver)
cd /vagrant/besserver

# set BF_ACCEPT to accept licnese so BigFix installation response file is modified by build.sh
BF_ACCEPT=true BES_VERSION=$4 bash ./build.sh

# start a docker container running BigFix server (besserver)
docker run -d -p 52311:52311 -p 52311:52311/udp \
    -e DB2INST1_PASSWORD=BigFix1t4Me \
    -e LICENSE=accept --hostname=eval.mybigfix.com \
    --name=eval.mybigfix.com \
     bfdocker/besserver /bes-start.sh
