#!/bin/bash
# start db2, install the besserver
/db2-start.sh
/ServerInstaller*/install.sh -f /bes-install-accept.rsp
