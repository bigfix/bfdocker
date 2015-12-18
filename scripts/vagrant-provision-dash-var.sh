#!/bin/bash
echo -----------------------------
echo Sleeping for 180 seconds
echo -----------------------------
sleep 180

echo -----------------------------
echo Preparing to install node
curl --silent --location https://rpm.nodesource.com/setup | bash -
wait
echo Installing node
yum -y install nodejs
echo -----------------------------

echo -----------------------------
echo doing cd /vagrant/besserver/cli_tool
echo -----------------------------
cd /vagrant/besserver/cli_tool

echo -----------------------------
echo Running node app.js
echo -----------------------------
node app.js qui.ojo localhost 52311 EvaluationUser BigFix1t4Me 100
sleep 5
echo -----------------------------
echo Running postDashboardData.js
echo -----------------------------
node postDashboardData.js postStreamBody.xml qui.ojo localhost 52311 EvaluationUser BigFix1t4Me