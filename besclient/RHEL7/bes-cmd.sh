#!/bin/bash

#if there's no masthead get it from the ROOT_SERVER
if [ ! -f /etc/opt/BESClient/actionsite.afxm ]
then
 curl -k https://$ROOT_SERVER/masthead/masthead.afxm > /etc/opt/BESClient/actionsite.afxm
fi

#start agent in background and keep running
/opt/BESClient/bin/BESClient
while true
do
	sleep 300
done
