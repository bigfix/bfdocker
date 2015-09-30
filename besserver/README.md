## IMPORTANT NOTICE
This build is based on a db2express-c image provided by IBM.
Access to the image has been restricted. Currently the image is not publicly available on the docker hub.
To get the db2express-c image you can request access from the image owners.
See [here](https://registry.hub.docker.com/u/ibmcom/db2express-c/) for details  

Alternatively the docker file used by IBM to create the image is available [here](https://github.com/IMC3ofC/db2express-c.docker) on github.  Using this will require you to build the db2express-c image and modify this project's Dockerfile to refer to your own db2express-c image.

## Overview

Build an instance of the evaluation edition of BigFix Server.

The image is based on [ibmcom/db2express-c](https://registry.hub.docker.com/u/ibmcom/db2express-c/) which is CentOS7.

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

2.  Login to docker hub:
```
# docker login -e <email> -u <username> -p <password>
```
3. Set the BF_ACCEPT environment variable to true to accept the BigFix licence. Optionally set the BigFix version using BES_VERSION Then run the build script:

  ```
  # BES_VERSION=9.2.5.130 BF_ACCEPT=true bash ./build.sh
  ```

4.  Start a container:

  ```
  # docker run -d -p 52311:52311 -p 52311:52311/udp \
      -e DB2INST1_PASSWORD=BigFix1t4Me \
      -e LICENSE=accept --hostname=eval.mybigfix.com \
      --name=eval.mybigfix.com \
	     bfdocker/besserver /bes-start.sh
  ```

5. Connect a BigFix Console to the docker host.  

  The evaluation edition user
credentials are documented [here](http://www-01.ibm.com/support/knowledgecenter/#!/SS63NW_9.2.0/com.ibm.tivoli.tem.doc_9.2/Platform/Adm/c_types_of_installation_evaluation.html).  The password for EvaluationUser is that set to
DB2_ADMIN_PWD in `bes-install.rsp`.
The BigFix Console can be downloaded from http://support.bigfix.com/bes/release/

## Using the Vagrant box
As an alternative to running this in a docker host a Vagrant file is included.
This creates a VirtualBox CentOS box (VM), installs and configures docker and then builds the evaluation edition of BigFix server.

Prerequisites for this are [VirtualBox](https://www.virtualbox.org) and [Vagrant](https://www.vagrantup.com).

The Vagrant provisioner requires a docker hub account that has access to the db2express-c image.  See the notice at the top of this page for more details.  The docker hub account credentials should be passed to Vagrant as environment variables.  Set `BF_ACCEPT=true` to accept the BigFix license. Optionally set the BigFix version using BES_VERSION. To put the box on the VirtualBox private network set `OHANA=1`; this will allow a console VM on the same host to connect to the server.  For example:

```
$ BES_VERSION=9.2.5.130 BF_ACCEPT=true DOCKER_EMAIL=eval@bigfix.com DOCKER_PASSWORD=pwd DOCKER_USERNAME=bigfixit OHANA=1 vagrant up
```
