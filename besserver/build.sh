# script to build an image with an evaluation edition of bes
# and create an instance of bes by running the installer
#!/bin/bash
docker build -t bfdocker/besinstaller -f Dockerfile .

# run the installer in a container
# hostname must match SRV_DNS_NAME used in the response file
docker run -e DB2INST1_PASSWORD=BigFix1t4Me \
  -e LICENSE=accept --hostname=eval.mybigfix.com --name=bfdocker_install_$$ \
	bfdocker/besinstaller /bes-install.sh

# create a new image with the BigFix instance, tag and clean up
docker commit bfdocker_install_$$ bfdocker/besserver:$$
docker tag bfdocker/besserver:$$ bfdocker/besserver:latest
docker rm bfdocker_install_$$
