
## Overview

Build an instance of the evaluation edition of BigFix Server.

The image is based on [ibmcom/db2express-c](https://registry.hub.docker.com/u/ibmcom/db2express-c/) which is CentOS7.

Tested on a CentOS7 host with docker 1.6.0.

`build.sh` runs the build process.  The outcome is a docker image named bfdocker/besserver:latest that contains an instance of BigFix Server.

Dockerfile downloads the BigFix server installer and adds files.

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
