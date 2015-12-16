#!/bin/bash
printf "Usage blueprint: ./launchInstall.sh <numberOfClientSets> <besVersion> <bigfixAccept> <dashboardVariables> <runPythonScripts>\n"
printf "Sample Usage: ./launchInstall.sh 3 9.2.6.94 true true true\n"
# Run dos2unix conversion script
./convertDosToUnix.sh
wait
# Set variables given cmd line arguments, if unset/null then use default values
numberOfClientSets=${1:-2}
besVersion=${2:-9.2.6.94}
bigfixAccept=${3:-true}
dashboardVariables=${4:-true}
runPythonScripts=${5:-true}
# Run vagrant up given specified/default values
BES_CLIENT=$numberOfClientSets BES_VERSION=$besVersion BF_ACCEPT=$bigfixAccept DASH_VAR=$dashboardVariables PYTHON_SCRIPTS=$runPythonScripts vagrant up