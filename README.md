# Overview
Build docker images with (BigFix) Endpoint Manager components like the server
and the agent.  See the READMEs in beserver and the individual OS folders in besclient for details.

The besserver now includes a Vagrant box so the server can be provisioned into a Vagrant VM, see the besserver README for details.

## Using the Vagrant box
As an alternative to running this in a docker host a Vagrant file is included.

Prerequisites for this are [VirtualBox](https://www.virtualbox.org) and [Vagrant](https://www.vagrantup.com).

There are a number of BigFix configurations to choose from:

1. Evaluation edition (default)
2. Production edition, which requires a valid BigFix license.

### Evaluation edition

This creates a VirtualBox CentOS box (VM).
It then installs and configures docker and then builds the evaluation edition of BigFix server.  Finally docker containers running the BigFix agent can be added.


1. Set `BES_ACCEPT=true` to accept the BigFix license.
2. Optionally set BES_CLIENT=1 to create a CentOS7 container with the BigFix agent.
3. Optionally set the BigFix version using BES_VERSION.
4. Optionally set VM_BOX to the location of a base vagrant box
5. Optionally set `BES_PORTS=false` to turn off forwarding the BigFix ports 52311 and 80 to 52311 and 8080 on the Vagrant host respectively.
6. To put the box on the VirtualBox private network set `OHANA=1`; this will allow a console VM on the same host to connect to the server.  For example:

```
$ BES_CLIENT=1 BES_VERSION=9.2.6.94 BES_ACCEPT=true OHANA=1 vagrant up
```

### Production edition

This option requires a valid BigFix license.

This creates a VirtualBox CentOS box (VM).
It then installs and a configures a set of docker containers:
1.  DB2 container
2.  BigFIx server container
3.  BigFix agent container (optional)

To use

1. Place your BigFix license certificate (.crt) and key (.pvk) files (or license authorization file) in `besserver/production/license`.
2. Set `BES_CONFIG=prod`
3. Set `BES_ACCEPT=true` to accept the BigFix license.
4. Optionally set `BES_CLIENT=1` to create a CentOS7 container with the BigFix agent.
5. Optionally set the BigFix version using BES_VERSION.
6. Optionally set VM_BOX to the location of a base vagrant box
7. Optionally set `BES_PORTS=false` to turn off forwarding the BigFix ports 52311 and 80 to 52311 and 8080 on the Vagrant host respectively.
8. To put the box on the VirtualBox private network set `OHANA=1`; this will allow a console VM on the same host to connect to the server.  For example:

```
$ BES_CONFIG=prod BES_CLIENT=1 BES_VERSION=9.2.6.94 BES_ACCEPT=true OHANA=1 vagrant up
```
