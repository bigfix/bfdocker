#!/bin/bash
#
# START BUILDING CLIENT CONTAINERS
############################################################################################
echo building CentOS 7 container with BigFix agent
# build docker image with the centos7 BigFix agent
cd /vagrant/besclient/CentOS7

BES_VERSION=9.2.6.94 bash ./build.sh

############################################################################################
echo building CentOS 6 container with BigFix agent
# build docker image with the centos6 BigFix agent
cd /vagrant/besclient/CentOS6

BES_VERSION=9.2.6.94 bash ./build.sh

############################################################################################
echo building Ubuntu 14 container with BigFix agent
# build docker image with the ubuntu14 BigFix agent
cd /vagrant/besclient/Ubuntu14

BES_VERSION=9.2.6.94 bash ./build.sh

############################################################################################
############################################################################################
echo Starting containers
# start a docker containers
for (( i = 1; i < 6; i++ )); do
	echo Starting centos7 container
	docker run --name="centos7Endpoint"$i --hostname="centos7Endpoint"$i -d -e "ROOT_SERVER=eval.mybigfix.com:52311" \
    --link=eval.mybigfix.com bfdocker/centos7
	sleep 5
	echo Starting centos6 container
	docker run --name="centos6Endpoint"$i --hostname="centos6Endpoint"$i -d -e "ROOT_SERVER=eval.mybigfix.com:52311" \
    --link=eval.mybigfix.com bfdocker/centos6
	sleep 5
	echo Starting ubuntu14 container
	docker run --name="ubuntu14Endpoint"$i --hostname="ubuntu14Endpoint"$i -d -e "ROOT_SERVER=eval.mybigfix.com:52311" \
    --link=eval.mybigfix.com bfdocker/ubuntu14
	sleep 5
done