FROM ubuntu:trusty

# install curl

RUN apt-get -y update && \
  apt-get -y install curl

# install the bes client

ENV AGENT_DOWNLOAD_URL=http://software.bigfix.com/download/bes/92/BESAgent-9.2.1.48-ubuntu10.amd64.deb

# download the agent or alternatively copy it from the host
#COPY ./BESAgent.deb /tmp/BESAgent.deb

RUN curl $AGENT_DOWNLOAD_URL > /tmp/BESAgent.deb

RUN mkdir -p /etc/opt/BESClient && \
  dpkg -i /tmp/BESAgent.deb

# set up default configurations for client
# use \\\E to output the \E of \EnterpriseClient

# command polling

RUN echo \
    "[Software\BigFix\\\EnterpriseClient\Settings\Client\_BESClient_Comm_CommandPollIntervalSeconds] \nvalue = 300 \neffective date = Thu,%2001%20Jan%202015%2000:00:00%20+0000" \
    >> /var/opt/BESClient/besclient.config.default && \
  echo \
    "[Software\BigFix\\\EnterpriseClient\Settings\Client\_BESClient_Comm_CommandPollEnable] \nvalue = 1 \neffective date = Thu,%2001%20Jan%202015%2000:00:00%20+0000" \
    >> /var/opt/BESClient/besclient.config.default

# automatic relay selection

RUN echo \
    "[Software\BigFix\\\EnterpriseClient\Settings\Client\__RelaySelect_Automatic] \nvalue = 1 \neffective date = Thu,%2001%20Jan%202015%2000:00:00%20+0000" \
    >> /var/opt/BESClient/besclient.config.default

# cpu usage.  Use 10,480 for 1-2%.  Use 2,500 for < .5%

RUN echo \
    "[Software\BigFix\\\EnterpriseClient\Settings\Client\_BESClient_Resource_WorkIdle] \nvalue = 2 \neffective date = Thu,%2001%20Jan%202015%2000:00:00%20+0000" \
    >> /var/opt/BESClient/besclient.config.default && \
  echo \
    "[Software\BigFix\\\EnterpriseClient\Settings\Client\_BESClient_Resource_SleepIdle] \nvalue = 500 \neffective date = Thu,%2001%20Jan%202015%2000:00:00%20+0000" \
    >> /var/opt/BESClient/besclient.config.default



# install an endpoint manager instance specific masthead

ENV ROOT_SERVER=rootserver.bigfix.com:52311

# download from the root server or alternatively copy from the host
#COPY ./actionsite.afxm /etc/opt/BESClient/actionsite.afxm

RUN curl -k https://$ROOT_SERVER/masthead/masthead.afxm > /etc/opt/BESClient/actionsite.afxm

# run endpoint manager from script so it can be restarted

COPY ./bes-cmd.sh /
RUN chmod u+x /bes-cmd.sh
CMD ["/bes-cmd.sh"]
