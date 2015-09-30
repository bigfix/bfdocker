# script to build an image with an evaluation edition of bes
# and create an instance of bes by running the installer
#!/bin/bash

if [[ ! "$BF_ACCEPT" = "true" ]]
then
  echo usage: set BF_ACCEPT to true to accept the BigFix license
  exit
else
  sed -e s/LA_ACCEPT=\"false\"/LA_ACCEPT=\"true\"/g  bes-install.rsp > \
   bes-install-accept.rsp
fi

if [[ ! $BES_VERSION ]]
then
  BES_VERSION=9.2.5.130
fi
# replace the default value in Dockerfile with the one set here
sed -e s/BES_VERSION=.*/BES_VERSION=$BES_VERSION/g Dockerfile \
    > Dockerfile_$$

docker build -t bfdocker/besinstaller -f Dockerfile_$$ .
rm Dockerfile_$$

# run the installer in a container
# hostname must match SRV_DNS_NAME used in the response file
docker run -e DB2INST1_PASSWORD=BigFix1t4Me \
  -e LICENSE=accept --hostname=eval.mybigfix.com --name=bfdocker_install_$$ \
  bfdocker/besinstaller /bes-install.sh

# clean up the respone file
rm bes-install-accept.rsp

# create a new image with the BigFix instance, tag and clean up
docker commit bfdocker_install_$$ bfdocker/besserver:$$
docker tag bfdocker/besserver:$$ bfdocker/besserver:latest

# clean up the intermedate container
docker rm bfdocker_install_$$

# clean up the intermedate image, can only remove after the container's deleted
docker rmi bfdocker/besinstaller
