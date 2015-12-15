#!/bin/bash 
## Parameters:
##   @param platformName: Name of the server container.
##
##   @param iemuser - IEMserver user credentials base64.urlsafe_b64encode(<username>:<password>)
##
##   @param sitename - IEM sitename string with format 
## "<site name>;<site name>;<site name>" where <site name> is the Name 
## of the masthead <Name> rather than DisplayName.
##
##   @param logfile - Logfile name (Optional, defaults to enableSites.log).
##
##   @param verbose - Verbose logging option (Optional, defaults to off).
##
##   @param SERVVIRTUALPORT - IEMserver Port (Optional, defaults to 443).
##
##   @param workdir - Working directory for the script (Optional, 
## defaults to /home/waoper1/IEMSaaSScripts/EnableSites).
##
##   @param domain: the domain name of the platform.
##
##   @return - Return zero if successful or a non zero value 
## if an error occurs.


###############################################
#Functions
###############################################
usage()
{
   echo "Usage: $THISSCRIPTNAME -pltfrmname <target iemserver container name> -iemuser <iemserveruserdetails> -sitename <\"site name\"> -domain <\"domain\">  [-verbose] [-iemserverport <platform port>] [-workdir <workingdirectory>]" 
}

log()
{   
   if [ "$VERBOSE" == "1" ]; then
      echo $1
   fi
   echo "`date +%d.%m.%Y-%H:%M` [$$] $*" 
}

## Execute the POST request to Enables sites
##
##   @param IEMUSER - IEMserver user credentials base64.urlsafe_b64encode(<username>:<password>)
##
##   @param XMLFILE - XML file parameter for the IEM site.
##
##   @param SERVERDNSNAME - Target IEMserver dns name.
##
##   @param SERVVIRTUALPORT - IEMserver port within container.
##
##   @param VERBOSE - Verbose logging option, 0 == off, 1 == on.
##
## Write the response to a temporary file as the response from the REST API is asynchronous.
##
executeEnablePostRequest()
{
   log "About to execute: curl  --tlsv1.2 -s --header Authorization: Basic <user:password>' -w "%{http_code}" --insecure  -X POST --data-binary @$XMLFILE https://${SERVERDNSNAME}:${IEMSERVERPORT}/api/sites"   
   returncode="$(curl  --tlsv1.2 -s --header "Authorization:Basic ${IEMUSER}" -w "%{http_code}" --insecure -X POST --data-binary @${XMLFILE} https://${SERVERDNSNAME}:${IEMSERVERPORT}/api/sites -o /dev/null)"

   if [[ "$returncode" -ne "200" ]]; then
      log "Error: The POST request with ${XMLFILE} failed with return code ${returncode}."
	  exit 1
   fi

   ## Remove the xml file if not using verbose logging
   if [ "$VERBOSE" == "0" ]; then
      rm -f "$XMLFILE"
   fi
 }
 
## Handle script input parameters
##
## Set default values for optional parameters before handling to specified parameters.
##
handleInputParameters()
{
   numargs=$#

   WORKINGDIR="./"; export WORKINGDIR    
   VERBOSE=0; export VERBOSE ## verbose logging defaults to off
   IEMSERVERPORT="52311"; export IEMSERVERPORT
   THISSCRIPTNAME=$0; export THISSCRIPTNAME
   
   while [ $# -gt 0 ]; do
      INPUTPARM=$1; export INPUTPARM
      shift

      case $INPUTPARM in
         -u|usage)
            usage
            exit 0
         ;;

         -pltfrmname)
            PLTFRMNAME=$1; export PLTFRMNAME
            shift   ## Move to next parameter if there is one
         ;;

         -iemuser)
            IEMUSER1=$1;
            IEMUSER=$(echo -ne $IEMUSER1 | base64); export IEMUSER
            echo $IEMUSER;
            shift
         ;;
	
         -sitename)
            SITENAMESTRING=$1; export SITENAMESTRING
            shift
         ;;
										
				
         -verbose)
            VERBOSE=1; export VERBOSE
            ## No shift as there is only one paramater
         ;;
				
         -servervirtualport) 
            SERVVIRTUALPORT=$1; export SERVVIRTUALPORT
            shift
         ;;
			
         -workdir)
            WORKINGDIR=$1; export WORKINGDIR
            shift
         ;;
         
         -domain)
            DOMAIN=$1; export DOMAIN
            shift
         ;;
				
         *)
            log "Error: Unexpected command arguement."
            echo "Unexpected command arguement."
            usage
            exit 2
         ;;
      esac
   done

   if [ $numargs -lt 5 ]; then
      echo "Unexpected number of arguments: $#"
      usage
      exit 3
   fi

   LOGFILEDIR="${WORKINGDIR}"; export LOGFILEDIR 
   LOGFILEPATH=''
   if [ -n "$logFilename" ]; then
      LOGFILEPATH="${LOGFILEDIR}/${logFilename}"; export LOGFILEPATH
   fi
   
  
   
   if [[ -z $PLTFRMNAME ]] || [[ -z $DOMAIN ]]; then
	  echo "Either or both pltfrmname and domain have no value provided"
      usage
      exit 4
   else
	  SERVERDNSNAME=$PLTFRMNAME; export SERVERDNSNAME
   fi
}

## Write XML File
##
##   @param XMLFILE - XML file name.
##
##   @param MASTHEADFILENAME - MASTHEAD filename for IEM site.
##
## Write the start of the xml file that will be passed in the POST request to IEM REST API.
##	<BES xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:noNamespaceSchemaLocation="BES.xsd">
##		<ExternalSite>
##			<Name>External Site</Name>
##			<Masthead><![CDATA[external site masthead content]]></Masthead>
##		</ExternalSite>
##	</BES>
##	
writeXMLFile()
{
   echo "<?xml version=\"1.0\" encoding=\"UTF-8\"?>" > $XMLFILE
   echo "<BES xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xsi:noNamespaceSchemaLocation=\"BES.xsd\">" >> $XMLFILE
   echo "   <ExternalSite>" >> $XMLFILE
   echo "      <Name>External Site</Name>" >> $XMLFILE
   mastheadContents=`cat "$MASTHEADFILENAME"`
   echo "      <Masthead><![CDATA[$mastheadContents]]></Masthead>" >> $XMLFILE
   echo "   </ExternalSite>" >> $XMLFILE
   echo "</BES>" >> $XMLFILE
   if [ -f "$XMLFILE" ]; then
      log "Generated xml file ${XMLFILE}. This file will remain in the log directory if this script is run in verbose mode."
   fi
}

## main 

## Use the following IFS to tokenise the site names string 
## IFS Internal Field Seperator for List of Site Names
IFS=';' 
mastheadDir="IEMExternalSiteMasthead"
numberOfSitesEnabled=0

handleInputParameters "$@"	



## Preserve spaces in site names and tokenise the string 
## with IFS to create siteList array of site names
if [ -n "$SITENAMESTRING" ]; then
   read -ra siteList <<< "$SITENAMESTRING"
   for site in "${siteList[@]}"; do
	  ## Create xml parameter file and execute POST request
	  XMLFILE="${LOGFILEDIR}/${site}.xml"
      MASTHEADFILENAME="/vagrant/${mastheadDir}/${site}.efxm"
      if [ -f "$MASTHEADFILENAME" ]; then
         writeXMLFile
	  else
         log "Error: Could not generate an xml file for the POST request as ${MASTHEADFILENAME} was not found. ${numberOfSitesEnabled} have been enabled."
		 exit 5
      fi
      
      if [ -f "$XMLFILE" ]; then
         executeEnablePostRequest
         ((numberOfSitesEnabled++))     	 
      else
         log "Error: Could not send POST request as ${XMLFILE} was not successfully created. ${numberOfSitesEnabled} have been enabled."
		 exit 6
      fi
   done ## end of for SITE loop
else
   log "Error: Could not enable site as unexpected value for sitename. ${numberOfSitesEnabled} have been enabled."
   exit 7
fi

log "Enable site process complete. All ${numberOfSitesEnabled} enable site requests were successful."
