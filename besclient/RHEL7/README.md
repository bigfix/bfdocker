## Overview

The Dockerfile will build a basic docker image with the Endpoint Manager agent.
The agent is configured as follows:

1. Use command polling so it is not necessary for it to bind a network interface on the docker host.
2. CPU is set to < .5% to allow for larger numbers of containers on a host
3. Automatic relay selection is enabled.  If the host is a BES Relay then containers can use it as a relay and receive UDP messages from the root server.

The container uses a script to start the bes agent so that the container does not stop if bes agent is stopped or restarted.

## Dockerfile

The build will download the bigfix agent package from https://support.bigfix.com.

## Usage

1. Check the version of your BigFix server and its compatible agents.  See the BigFix support [site](http://support.bigfix.com/bes/release/) for information

2. Build the image using the build script, passing the version of BigFix agent via the environment.  The default value is 9.2.5.130
```
$ sudo BES_VERSION=9.2.5.130 bash ./build.sh
```
3. Run container in daemon mode, passing in the `ROOT_SERVER` environment variable set to name and port of the root server. The agent will start, download the masthead and register with the root server. You should see it appear in the console as a computer. For example:

```
$ sudo docker run -d bfdocker/rhel7 \
    -e "ROOT_SERVER=eval.mybigfix.com:52311" \
    --hostname="no1.rhel7.mybigfix.com"
```

If a besserver is running in a container on the same host use the `--link`
option using the name of the besserver container.

```
$ sudo docker run -d -e "ROOT_SERVER=eval.mybigfix.com:52311" \
    --link=eval.mybigfix.com bfdocker/rhel7
```
