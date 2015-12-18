#!/bin/bash
printf "Usage blueprint: ./launchInstall.sh <numberOfClientSets> <besVersion> <bigfixAccept> <dashboardVariables> <runPythonScripts> <productionLicenseType> <vagrantCommandOne> <vagrantCommandTwo>\n"
printf "Sample Usage: ./launchInstall.sh 3 9.2.6.94 true true true eval up\n"
printf "Sample Usage: ./launchInstall.sh 3 9.2.6.94 true true true auth up --provision\n"
printf "Sample Usage: ./launchInstall.sh 3 9.2.6.94 true true true auth provision\n"
#printf "Sample Usage: ./launchInstall.sh 3 9.2.6.94 true true true prod provision\n"
# Run dos2unix conversion script
./convertDosToUnix.sh
wait
# Set variables given cmd line arguments, if unset/null then use default values
numberOfClientSets=${1:-2}
besVersion=${2:-9.2.6.94}
bigfixAccept=${3:-true}
dashboardVariables=${4:-true}
runPythonScripts=${5:-true}
productionLicenseType=${6:-false}
vagrantCommandOne=${7:-up}
vagrantCommandTwo=${8:-""}

if [[ $productionLicenseType == "eval" ]]
then
	printf "Installing with Evaluation License\n"
	# Run vagrant up given specified/default values
	BES_CLIENT=$numberOfClientSets BES_VERSION=$besVersion BF_ACCEPT=$bigfixAccept DASH_VAR=$dashboardVariables PYTHON_SCRIPTS=$runPythonScripts vagrant $vagrantCommandOne $vagrantCommandTwo
else
	if [[ $productionLicenseType == "auth" ]]
	then
		printf "Installing with production license BESLicenseAuthorization file\n"
		# Run vagrant up given specified/default values
		BES_CLIENT=$numberOfClientSets BES_VERSION=$besVersion BF_ACCEPT=$bigfixAccept DASH_VAR=$dashboardVariables PYTHON_SCRIPTS=$runPythonScripts BES_CONFIG=remdb vagrant $vagrantCommandOne $vagrantCommandTwo
	else	
		printf "Installin with production license private key and certificate files\n"
		# Run vagrant up given specified/default values
		#BES_CLIENT=$numberOfClientSets BES_VERSION=$besVersion BF_ACCEPT=$bigfixAccept DASH_VAR=$dashboardVariables PYTHON_SCRIPTS=$runPythonScripts BES_CONFIG=remdb vagrant $vagrantCommandOne $vagrantCommandTwo
	fi
fi