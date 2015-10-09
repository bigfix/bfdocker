#!/bin/bash

echo building evaluation edition of BigFix
# build docker image with the evaluation edition of BigFix server (besserver)
cd /vagrant/besserver

# set BF_ACCEPT to accept licnese so BigFix installation response file is modified by build.sh
BF_ACCEPT=true BES_VERSION=$1 bash ./build.sh

# start a docker container running BigFix server (besserver)
docker run -d  \
    -e DB2INST1_PASSWORD=BigFix1t4Me \
    -e LICENSE=accept --hostname=eval.mybigfix.com \
    --name=eval.mybigfix.com \
    -p 80:80 \
    -p 52311:52311 -p 52311:52311/udp \
    --restart=on-failure:10 \
     bfdocker/besserver /bes-start.sh
