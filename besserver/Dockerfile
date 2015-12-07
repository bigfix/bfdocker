# use the IBM's docker hub repo for db2express-c
# https://hub.docker.com/r/ibmcom/db2express-c
FROM ibmcom/db2express-c

# install additional BigFix prerequisites
RUN yum -y install  libpng12.x86_64

# BES Version so it can be modified at runtime
ENV BES_VERSION=9.2.6.94

# download the installer and expand
# parse the version number to form the download URL in the form
# http://software.bigfix.com/download/92/ServerInstaller-9.2.6.94-rhe6.x86_64.tgz

RUN echo $BES_VERSION | \
  sed 's/\([0-9]*\)\(\.\)\([0-9]*\)\(.*\)/http:\/\/software.bigfix.com\/download\/bes\/\1\3\/ServerInstaller_\1\2\3\4-rhe6.x86_64.tgz/g' \
	| xargs curl > /ServerInstaller.tgz

RUN tar -xzvf /ServerInstaller.tgz

COPY ./db2-start.sh /
COPY ./bes-install-accept.rsp /
COPY ./bes-install.sh /
COPY ./bes-start.sh /
RUN chmod u+x /db2-start.sh /bes-install.sh /bes-start.sh
