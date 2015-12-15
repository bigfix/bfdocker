#!/bin/bash
cd /vagrant/scripts
./enableSite.sh -pltfrmname "localhost" -iemuser EvaluationUser:BigFix1t4Me -sitename "Bigfix4QRadar Test;" -domain "domain"
# Wait for background processes to finish for site enablement
wait
cd $(pwd)/../
# unzip python modules
tar -xvf ./modules/requests-2.8.1.tar.gz
wait
# pythonDir = present working directory
pythonDir="$(pwd)/requests-2.8.1"
# Change to pythonDir
cd $pythonDir
# install requests module
python ./setup.py install
wait
# Change bac kt obesserver directory
cd $(pwd)/../scripts
# Run python script to wait until all listed sites have gathered
python ./checkSiteGathered.py "127.0.0.1" EvaluationUser:BigFix1t4Me "Bigfix4QRadar Test" 180 200 60 15 "NONE" "52311"
wait
# Run python script to subscribe all computers to the sites in siteList
python ./subscribeSiteToAllComputers.py "127.0.0.1" EvaluationUser:BigFix1t4Me "Bigfix4QRadar Test" 200 60 "NONE" "52311"
wait