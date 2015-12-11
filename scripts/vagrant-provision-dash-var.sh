#!/bin/bash
echo -----------------------------
echo Sleeping for 180 seconds
echo -----------------------------
sleep 180

echo -----------------------------
echo Installing unzip
echo -----------------------------
yum install unzip

echo -----------------------------
echo Making dir /node
echo -----------------------------
mkdir /node

echo -----------------------------
echo Untarring node
echo -----------------------------
tar xvf /vagrant/besserver/ibm-1.2.0.6-node-v0.12.7-linux-x64.tar.gz -C /node

echo -----------------------------
echo doing cd /vagrant/besserver/cli_tool
echo -----------------------------
cd /vagrant/besserver/cli_tool

echo -----------------------------
echo Running node app.js
echo -----------------------------
/node/node-v0.12.7-linux-x64/bin/node app.js qui.ojo localhost 52311 EvaluationUser BigFix1t4Me 100
sleep 5
echo -----------------------------
echo Running postDashboardData.js
echo -----------------------------
/node/node-v0.12.7-linux-x64/bin/node postDashboardData.js postStreamBody.xml qui.ojo localhost 52311 EvaluationUser BigFix1t4Me