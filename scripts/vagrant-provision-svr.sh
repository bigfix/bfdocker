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

# Store the docker list in a text file
docker ps > dockerList.txt
readarray dockerContainters < dockerList.txt

status=0

for container in "${dockerContainers[@]}";
do
	if [[ container != *"eval.mybigfix.com"* ]]
	then
	  $status=0
	  else
	  $status=1
	  printf "BESServer creation successful\n"
	  break
	fi
done
# Delete the docker list test file
rm -rf dockerList.txt
# If the status is 0, the server creation failed, try again if there are tries remaining (default to 3 tries before quit)
if [[ $status -eq "0" ]]
then
	if [[ -e "remainingTries.txt" ]]
	then
		readarray tries < remainingTries.txt
		if [[ "${tries[0]}" -eq "0" ]]
		then
			printf "Failed to create server...exiting\n"
		else
			newTries=${tries[0]}-1
			$newTries > remainingTries.txt
			./vagrant-provision-svr.sh
		fi
	else
		"2" > remainingTries.txt
	fi
else
	if [[ -e "remainingTries.txt" ]]
	then
		rm -rf remainingTries.txt
	fi
fi