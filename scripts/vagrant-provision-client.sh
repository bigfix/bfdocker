#!/bin/bash
echo building CentOS container with BigFix agent
# build docker image with the evaluation edition of BigFix server (besserver)
cd /vagrant/besclient/CentOS7

# start a docker container running BigFix server (besserver)
/usr/local/bin/docker-compose up -d
