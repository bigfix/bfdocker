FROM centos:6

# prerequisites for the Endpoint Manager CentOS patch application

RUN yum -y install \
  bzip2 \
  tar && \
  yum clean all

# install the bes client by downloading it from bigfix

# BES Version so it can be modified at runtime

ENV BES_VERSION=9.2.5.130

# Download the agent or alternatively copy it from the host

#COPY ./BESAgent.rpm /tmp/BESAgent.rpm

# parse the BES_VERSION number to form the download URL in the form
# http://software.bigfix.com/download/92/ServerAgent-9.2.5.130-rhe5.x86_64.rpm

RUN echo $BES_VERSION | \
  sed 's/\([0-9]*\)\(\.\)\([0-9]*\)\(.*\)/http:\/\/software.bigfix.com\/download\/bes\/\1\3\/BESAgent-\1\2\3\4-rhe5.x86_64.rpm/g' \
	| xargs curl > /tmp/BESAgent.rpm

RUN mkdir -p /etc/opt/BESClient && \
  rpm -ivh /tmp/BESAgent.rpm

# set up default configurations for client
# use \\\E to output the \E of \EnterpriseClient with echo's -e option

# command polling

RUN echo -e \
    "[Software\BigFix\\\EnterpriseClient\Settings\Client\_BESClient_Comm_CommandPollIntervalSeconds] \nvalue = 300 \neffective date = Thu,%2001%20Jan%202015%2000:00:00%20+0000" \
    >> /var/opt/BESClient/besclient.config.default && \
  echo -e \
    "[Software\BigFix\\\EnterpriseClient\Settings\Client\_BESClient_Comm_CommandPollEnable] \nvalue = 1 \neffective date = Thu,%2001%20Jan%202015%2000:00:00%20+0000" \
    >> /var/opt/BESClient/besclient.config.default

# automatic relay selection

RUN echo -e \
    "[Software\BigFix\\\EnterpriseClient\Settings\Client\__RelaySelect_Automatic] \nvalue = 1 \neffective date = Thu,%2001%20Jan%202015%2000:00:00%20+0000" \
    >> /var/opt/BESClient/besclient.config.default

# cpu usage.  Use 10,480 for 1-2%.  Use 2,500 for < .5%

RUN echo -e \
    "[Software\BigFix\\\EnterpriseClient\Settings\Client\_BESClient_Resource_WorkIdle] \nvalue = 2 \neffective date = Thu,%2001%20Jan%202015%2000:00:00%20+0000" \
    >> /var/opt/BESClient/besclient.config.default && \
  echo -e \
    "[Software\BigFix\\\EnterpriseClient\Settings\Client\_BESClient_Resource_SleepIdle] \nvalue = 500 \neffective date = Thu,%2001%20Jan%202015%2000:00:00%20+0000" \
    >> /var/opt/BESClient/besclient.config.default

# run endpoint manager from script so it can be restarted

COPY ./bes-cmd.sh /
RUN chmod u+x /bes-cmd.sh
CMD ["/bes-cmd.sh"]

# set default environment variable of bes root server used by bes-cmd.sh to get
# the masthead

ENV ROOT_SERVER=eval.mybigfix.com:52311
