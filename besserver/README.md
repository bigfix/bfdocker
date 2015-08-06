## IMPORTANT NOTICE
This build is based on a db2express-c image provided by IBM.
Access to the image has been restricted. Currently the image is not publicly available on the docker hub.
To get the db2express-c image you can request access from the image owners.
See [here](https://registry.hub.docker.com/u/ibmcom/db2express-c/) for details  

Alternatively the docker file used by IBM to create the image is available [here](https://github.com/IMC3ofC/db2express-c.docker) on github.  Using this will require you to build the db2express-c image and modify this project's Dockerfile to refer to your own db2express-c image.

## Overview

Build an instance of the evaluation edition of BigFix Server.

The image is based on [ibmcom/db2express-c](https://registry.hub.docker.com/u/ibmcom/db2express-c/) which is CentOS7.

Tested on a CentOS7 host with docker 1.6.0.

`build.sh` runs the build process.  The outcome is a docker image named bfdocker/besserver:latest that contains an instance of BigFix Server.

Dockerfile downloads the BigFix server installer and adds files.

### Note
At this time, neither running BigFix server on CentOS nor runing it in docker containers are supported options.  Details of supported platforms can be found in the IBM product documentation [site](http://www-01.ibm.com/support/docview.wss?rs=1015&uid=swg21684809).

## To use

1. Edit the bes-install.rsp
  1. change `LA_ACCEPT="false"` to true to accept the license.
  2. review the db2 password and the hostname and change as appropriate.
  3. if you change the default db2 password and hostname ensure you also change
the values of DB2INST1_PASSWORD and --hostname in build.sh and when you start
containers from the final image.

2.  Run the build script:

  `bash ./build.sh`

3.  Start a container:

  ```
  docker run -d -p 52311:52311 -p 52311:52311/udp \
      -e DB2INST1_PASSWORD=BigFix1t4Me \
      -e LICENSE=accept --hostname=eval.mybigfix.com \
	     bfdocker/besserver /bes-start.sh
  ```

4. Connect a BigFix Console to the docker host.  

  The evaluation edition user
credentials are documented [here](http://www-01.ibm.com/support/knowledgecenter/#!/SS63NW_9.2.0/com.ibm.tivoli.tem.doc_9.2/Platform/Adm/c_types_of_installation_evaluation.html).  The password for EvaluationUser is that set to
DB2_ADMIN_PWD in `bes-install.rsp`.
The BigFix Console can be downloaded from http://support.bigfix.com/bes/release/
