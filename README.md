## Overview
Build docker images with (BigFix) Endpoint Manager components like the server
and the agent.  See the READMEs in beserver and the individual OS folders in besclient for details.

The besserver now includes a Vagrant box so the server can be provisioned into a Vagrant VM, see the besserver README for details.

BES_CLIENT=NUMBER OF ENDPOINTS
E.G.
BES_CLIENT=1 (produces 1 x CentOS6 Endpoint, 1 x CentOS7 Endpoints, 1 x Ubuntu14 Endpoint. 3 Endpoints Total)
BES_CLIENT=2 (produces 2 x CentOS6 Endpoint, 2 x CentOS7 Endpoints, 2 x Ubuntu14 Endpoint. 6 Endpoints Total)
BES_CLIENT=3 (produces 3 x CentOS6 Endpoint, 3 x CentOS7 Endpoints, 3 x Ubuntu14 Endpoint. 9 Endpoints Total)

********************************************************************************
Launch vagrant with the following command
********************************************************************************
BES_CLIENT=2 BES_VERSION=9.2.6.94 BF_ACCEPT=true DASH_VAR=1 vagrant up
********************************************************************************
********************************************************************************

--------------------
to connect console:
--------------------
hostname: 127.0.0.1
username: EvaluationUser
pass: BigFix1t4Me

--------------------
to destroy vagrant vm:
--------------------
VAGRANT_DETECTED_OS=cygwin vagrant destroy

--------------------------------------
some hepler commands for development:
--------------------------------------
python checkSiteGathered.py localhost "EvaluationUser:BigFix1t4Me" "Bigfix4QRadar Test" 30 200 30 10 "domain" 52311
python subscribeSiteToAllComputers.py localhost "EvaluationUser:BigFix1t4Me" "Bigfix4QRadar Test" 200 60 "domain" 52311