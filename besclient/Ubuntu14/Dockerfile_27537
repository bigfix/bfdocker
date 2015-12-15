FROM ubuntu:trusty

# install curl

RUN apt-get -y update && \
  apt-get -y install curl

# install the bes client

# BES Version so it can be modified at runtime
ENV BES_VERSION=9.2.6.94

# download the agent or alternatively copy it from the host
#COPY ./BESAgent.deb /tmp/BESAgent.deb

# parse the BES_VERSION number to form the download URL in the form
# http://software.bigfix.com/download/92/ServerAgent-9.2.6.94-ubuntu10.amd64.deb

RUN echo $BES_VERSION | \
  sed 's/\([0-9]*\)\(\.\)\([0-9]*\)\(.*\)/http:\/\/software.bigfix.com\/download\/bes\/\1\3\/BESAgent-\1\2\3\4-ubuntu10.amd64.deb/g' \
	| xargs curl > /tmp/BESAgent.deb

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

# run endpoint manager from script so it can be restarted

COPY ./bes-cmd.sh /
RUN chmod u+x /bes-cmd.sh
CMD ["/bes-cmd.sh"]

# set default environment variable of bes root server used by bes-cmd.sh to get
# the masthead
ENV ROOT_SERVER=eval.mybigfix.com:52311
