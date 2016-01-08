#!/bin/bash
echo building remote db configuraiotn of BigFix
# build docker image with the evaluation edition of BigFix server (besserver)
cd /vagrant/besserver/production

# start a docker container running BigFix server (besserver)
/usr/local/bin/docker-compose up -d
