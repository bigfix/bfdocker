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

1. Check that ENV AGENT_DOWNLOAD_URL in the `Dockerfile` points to a version of the agent that is
compatible with your IEM instance.  If it's not, then change it to a compatible version.

2. Build the image.

3. Run container in daemon mode, passing in the `ROOT_SERVER` environment variable set to name and port of the root server. The agent will start, download the masthead and register with the root server. You should see it appear in the console as a computer. For example:

```
docker run -d bfdocker/centos6 \
    -e "ROOT_SERVER=eval.mybigfix.com:52311" \
    --hostname="no1.centos6.mybigfix.com"
```

If a besserver is running in a container on the same host use the `--link`
option using the name of the besserver container.

```
docker run -d -e "ROOT_SERVER=eval.mybigfix.com:52311" \
    --link=eval.mybigfix.com bfdocker/centos6
```
