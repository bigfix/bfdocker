#!/bin/bash
echo copying rest api file to container
docker cp /vagrant/scripts/setupPluginServiceAndRESTAPI.sh eval.mybigfix.com:/setupPluginServiceAndRESTAPI.sh

echo logging in to bf container
docker exec -ti eval.mybigfix.com bash

echo executing setup rest api script
/setupPluginServiceAndRESTAPI.sh