#!/bin/bash
# create a set of new containers
# $1 no. containers
# $2 image name
# $3 hostname and container name prefix
# $4 sleep between container startup
for (( i = 0; i < $1; i++ )); do
	docker run -d --hostname=$3$i --name=$3$i $2
	sleep $4
done
