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
tar -xzf /ibm-1.2.0.6-node-v0.12.7-linux-x64.tar.gz -C /node

echo -----------------------------
echo doing cd /cli_tool
echo -----------------------------
cd /cli_tool

echo -----------------------------
echo Running node app.js
echo -----------------------------
/node/node-v0.12.7-linux-x64/bin/node app.js qui.ojo 127.0.0.1 52311 EvaluationUser BigFix1t4Me 100

echo -----------------------------
echo Running postDashboardData.js
echo -----------------------------
/node/node-v0.12.7-linux-x64/bin/node postDashboardData.js postStreamBody.xml qui.ojo 127.0.0.1 52311 EvaluationUser BigFix1t4Me