#!/bin/bash

# default to using an authorisation file
if [[ ! $BES_INSTALL_FILE ]]
then
  BES_INSTALL_FILE=/bes-install-auth.rsp
fi

# install bes if it's not there
if [[ ! -f /etc/init.d/besserver ]]
then
  BES_INSTALL_FILE=$BES_INSTALL_FILE bash /bes-install.sh \
    >/var/log/bfinstall.log 2>&1
else
  # fire up bes
  service besserver start
  service besfilldb start
  service besgatherdb start
  service beswebreports start
  service besclient start
fi

# keep the container running
while [[ true ]]; do
	sleep 600
done
