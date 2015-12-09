# fire up bd2 and bes

#!/bin/bash
/db2-start.sh

service besserver start
service besfilldb start
service besgatherdb start
service beswebreports start
service besclient start

/setupPluginServiceAndRESTAPI.sh

while [[ true ]]; do
	sleep 600
done
