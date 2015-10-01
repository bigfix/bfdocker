#!/bin/bash

# script to build an image with a given verion of BigFix agent
if [[ ! $BES_VERSION ]]
then
  BES_VERSION=9.2.5.130
fi

# replace the default value in Dockerfile with the one set here
sed -e s/BES_VERSION=.*/BES_VERSION=$BES_VERSION/g Dockerfile \
    > Dockerfile_$$

# build an image that contains the BES installer
docker build -t bfdocker/rhel7:$BES_VERSION -f Dockerfile_$$ .
rm Dockerfile_$$
