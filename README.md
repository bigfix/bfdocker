## Overview
Build docker images with (BigFix) Endpoint Manager components like the server
and the agent.  See the READMEs in beserver and the individual OS folders in besclient for details.

The besserver now includes a Vagrant box so the server can be provisioned into a Vagrant VM, see the besserver README for details.

BES_CLIENT=1 BES_VERSION=9.2.6.94 BF_ACCEPT=true OHANA=1 vagrant up
BES_CLIENT=1 BES_VERSION=9.2.6.94 BF_ACCEPT=true DASH_VAR=1 vagrant up

--------------------
to connect console:
--------------------
127.0.0.1
EvaluationUser
BigFix1t4Me

--------------------
to destroy vagrant vm:
--------------------
VAGRANT_DETECTED_OS=cygwin vagrant destroy