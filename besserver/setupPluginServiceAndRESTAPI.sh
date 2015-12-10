#!/bin/bash
# Set archFile
archFile="archType.txt"
# Get the architecture type of the OS
getconf LONG_BIT > $archFile

# Check if architecture file exists
if [[ -e "$archFile" ]]
then 
	printf "The architecture file exists\n"
	# Read architecture type in archType.txt
	readarray architectureType < $archFile
	# Delete the archFile text file
	rm -rf $archFile
	# Setup the BES Plugin Service and Configure REST API
	# If old BES Plugin Service download exists then remove it
	if [[ -e "MFS-Linux.rpm" ]]
	then 
		printf "Removing old download of MFS-Linux.rpm..."
		rm -rf "MFS-Linux.rpm"
	fi
	# If old CryptoUtility Tool download exists then remove it
	if [[ -e "CryptoUtility" ]]
	then 
		printf "Removing old download of CryptoUtility Tool..."
		rm -rf "CryptoUtility"
	fi
	# If architecture is 64 bit / Else
	if [[ "${architectureType[0]}" -eq "64" ]]
	then
		# Download the BES Plugin Service (MFS-Linux)
		wget http://software.bigfix.com/download/bes/util/MFS-Linux-2.0.0.0-rhel.x86_64.rpm -O MFS-Linux.rpm
		# Download the Crypto Utility Tool
		wget http://software.bigfix.com/download/bes/util/CryptoUtility-linux-1.0.0.x64 -O CryptoUtility
	else
		# Download the Bes Plugin Service (MFS-Linux)
		wget http://software.bigfix.com/download/bes/util/MFS-Linux-2.0.0.0-rhel.i386.rpm -O MFS-Linux.rpm
		# Download the Crypto Utility Tool
		wget http://software.bigfix.com/download/bes/util/CryptoUtility-linux-1.0.0 -O CryptoUtility
	fi
	# Install the BES Plugin Service using MFS-Linux.rpm
	rpm -U MFS-Linux.rpm
	# Wait for install of BES Plugin Service to complete
	wait ${!}
	# Remove MFS-Linux.rpm
	rm -rf MFS-Linux.rpm
	# Start the BES Plugin Service
	/var/opt/BESServer/Applications/MFS-Linux
	# Make the CryptoUtility Tool executable
	chmod 700 CryptoUtility
	# Move the CryptoUtility Tool into the Applications Folder
	mv CryptoUtility /var/opt/BESServer/Applications/CryptoUtility
	# Run the CryptoUtility Tool with the password: BigFix1t4Me is the default password
	/var/opt/BESServer/Applications/CryptoUtility -i BigFix1t4Me -o /var/opt/BESServer/Applications/encrypted.txt
	# Read the stored encrypted password and store value for use in MasterOperatorCredentials file
	readarray encryptedPassword < "/var/opt/BESServer/Applications/encrypted.txt"
	# Create the MasterOperatorCredentials file and insert the necessary data
	echo "RESTUsername=EvaluationUser" > /var/opt/BESServer/Applications/MasterOperatorCredentials
	echo "RESTPassword=${encryptedPassword[0]}" >> /var/opt/BESServer/Applications/MasterOperatorCredentials
	echo "RESTURL=https://127/0/0/1:52311/api" >> /var/opt/BESServer/Applications/MasterOperatorCredentials
	# Modify the MasterOperatorCredentials File
	chmod 600 /var/opt/BESServer/Applications/MasterOperatorCredentials
	# Remove encrypted.txt
	rm -rf /var/opt/BESServer/Applications/encrypted.txt
fi