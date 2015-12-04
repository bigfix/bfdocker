#!/bin/bash
# Script to convert dos file format to unix format
scriptsPrefix="./scripts/"
scriptFiles=("vagrant-provision-common.sh" "vagrant-proivision-remdb.sh" "vagrant-provision-svr.sh")

besserverPrefix="./besserver/"
besserverFiles=("bes-install.sh" "bes-start.sh" "build.sh" "db2-start.sh")

besserverRemotedbPrefix="./besserver/remotedb/"
besserverRemotedbFiles=("bes-install.sh" "bes-start.sh")

besclientCentOS6Prefix="./besclient/CentOS6/"
besclientCentOS6Files=("bes-cmd.sh" "build.sh")

besclientCentOS7Prefix="./besclient/CentOS7/"
besclientCentOS7Files=("bes-cmd.sh" "build.sh")

besclientCommonPrefix="./besclient/Common/"
besclientCommonFiles=("start.sh")

besclientRHEL7Prefix="./besclient/RHEL7/"
besclientRHEL7Files=("bes-cmd.sh" "build.sh")

besclientUbuntu14Prefix="./besclient/Ubuntu14/"
besclientUbuntu14Files=("bes-cmd.sh" "build.sh")

# Loop through each set of files for their given prefix and convert to unix file format
# besserver
for i in "${besserverFiles[@]}"
do
	fileLoc=$besserverPrefix$i
	echo $fileLoc
	dos2unix -o $fileLoc
	printf "\n"
done

# beserverRemotedb
for i in "${besserverRemotedbFiles[@]}"
do
	fileLoc=$besserverRemotedbPrefix$i
	echo $fileLoc
	dos2unix -o $fileLoc
	printf "\n"
done

# besclient - CentOS6
for i in "${besclientCentOS6Files[@]}"
do
	fileLoc=$besclientCentOS6Prefix$i
	echo $fileLoc
	dos2unix -o $fileLoc
	printf "\n"
done

# besclient - CentOS7
for i in "${besclientCentOS7Files[@]}"
do
	fileLoc=$besclientCentOS7Prefix$i
	echo $fileLoc
	dos2unix -o $fileLoc
	printf "\n"
done

# besclient - Common
for i in "${besclientCommonFiles[@]}"
do
	fileLoc=$besclientCommonPrefix$i
	echo $fileLoc
	dos2unix -o $fileLoc
	printf "\n"
done

# besclient - RHEL7
for i in "${besclientRHEL7Files[@]}"
do
	fileLoc=$besclientRHEL7Prefix$i
	echo $fileLoc
	dos2unix -o $fileLoc
	printf "\n"
done

# besclient - Ubuntu14
for i in "${besclientUbuntu14Files[@]}"
do
	fileLoc=$besclientUbuntu14Prefix$i
	echo $fileLoc
	dos2unix -o $fileLoc
	printf "\n"
done