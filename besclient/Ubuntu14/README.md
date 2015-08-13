The Dockerfile will build a basic docker image with the Endpoint Manager agent.
The agent is configured as follows:
1. Use command polling so it is not necessary for it to bind a network interface on the docker host.
2. CPU is set to < .5% to allow for larger numbers of containers on a host
3. Automatic relay selection is enabled.  If the host is a BES Relay then containers can use it as a relay and receive UDP messages from the root server.

The container uses a script to start the bes agent so that the container does not stop if bes agent is stopped or restarted.

ockerfile

The build will download the bigfix agent package from https://support.bigfix.com.

1.  Edit Dockerfile and change ENV ROOT_SERVER to be your IEM server.
2.  Check that ENV AGENT_DOWNLOAD_URL points to a version of the agent that is
compatible with your IEM instance

Run container in daemon mode, the agent will start, download the masthead and register with the root server. You should see it appear in the console as a computer. For example:

```
docker run -d bfdocker/ubuntu14 \
    --hostname="no1.ubuntu14.mybbigfix.com"
```

If a besserver is running in a container on the same host use the `--link`
option using the name of the besserver container.

```
docker run -d --link=eval.mybigfix.com bfdocker/ubuntu14
```
