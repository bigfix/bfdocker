## Overview

Build an instance of the evaluation edition of BigFix Server.

The image is based on [ibmcom/db2express-c](https://registry.hub.docker.com/r/ibmcom/db2express-c/) which is CentOS7.

Tested on a CentOS7 host with docker 1.6.0 and 1.8

`build.sh` runs the build process.  The outcome is a docker image named bfdocker/besserver:latest that contains an instance of BigFix Server.

Dockerfile downloads the BigFix server installer and adds files.

### Note
At this time, neither running BigFix server on CentOS nor running it in docker containers are supported options.  Details of supported platforms can be found in the IBM product documentation [site](http://www-01.ibm.com/support/docview.wss?rs=1015&uid=swg21684809).


## To use

### Increase the default container filesystem
By default docker is configured to create containers with a 10GB filesystem.  This is too small and needs to be increased.  20GB is suggested.  For RedHat7/CentOS7 this is done using the docker daemon's `--storage-opt` options.  See the `vagrant-provision-svr.sh` script, which shows one way this can be done.

### Build and run
1. Review and edit as required the bes-install.rsp file
  1. review the db2 password and the hostname and change as appropriate.
  2. if you change the default db2 password and hostname ensure you also change
the values of `DB2INST1_PASSWORD` and `--hostname` in `build.sh` and when you start
containers from the final image.

2. Set the BES_ACCEPT environment variable to true to accept the BigFix licence. Optionally set the BigFix version using BES_VERSION Then run the build script:

  ```
  # BES_VERSION=9.2.6.94 BES_ACCEPT=true bash ./build.sh
  ```

3.  Start a container:

  ```
  # docker run -d  \
      -e DB2INST1_PASSWORD=BigFix1t4Me \
      -e LICENSE=accept --hostname=eval.mybigfix.com \
      --name=eval.mybigfix.com \
      -p 80:80 \
      -p 52311:52311 -p 52311:52311/udp \
	     bfdocker/besserver /bes-start.sh
  ```

4. Connect a BigFix Console to the docker host.  

  The evaluation edition user
credentials are documented [here](http://www-01.ibm.com/support/knowledgecenter/#!/SS63NW_9.2.0/com.ibm.tivoli.tem.doc_9.2/Platform/Adm/c_types_of_installation_evaluation.html).  The password for EvaluationUser is that set to
DB2_ADMIN_PWD in `bes-install.rsp`.
The BigFix Console can be downloaded from http://support.bigfix.com/bes/release/

## Using the Vagrant box
As an alternative to running this in a docker host a Vagrant file is included.

Prerequisites for this are [VirtualBox](https://www.virtualbox.org) and [Vagrant](https://www.vagrantup.com).

There are a number of BigFix configurations to choose from:

1. Evaluation edition (default)
2. Remote database configuration, which requires a valid BigFix license.

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

### Remote database edition

This option requires a valid BigFix license.  See the remotedb README.md for more details.

This creates a VirtualBox CentOS box (VM).
It then installs and a configures a set of docker containers:
1.  DB2 container
2.  BigFIx server container
3.  BigFix agent container (optional)

To use

1. Set `BES_CONFIG=remdb`
2. Set `BES_ACCEPT=true` to accept the BigFix license.
2. Optionally set `BES_CLIENT=1` to create a CentOS7 container with the BigFix agent.
3. Optionally set the BigFix version using BES_VERSION.
4. Optionally set VM_BOX to the location of a base vagrant box
5. Optionally set `BES_PORTS=false` to turn off forwarding the BigFix ports 52311 and 80 to 52311 and 8080 on the Vagrant host respectively.
6. To put the box on the VirtualBox private network set `OHANA=1`; this will allow a console VM on the same host to connect to the server.  For example:

```
$ BES_CONFIG=remdb BES_CLIENT=1 BES_VERSION=9.2.6.94 BES_ACCEPT=true OHANA=1 vagrant up
```
