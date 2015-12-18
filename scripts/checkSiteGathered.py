#!/usr/local/bin/python
import sys
import datetime
import time
import requests
import xml.etree.ElementTree as ET
import base64

"""Description:
	Module performs a GET request to return a list of analysis for the given site. If an analysis is found it returns True, else it returns False.
    """
def checkSiteGathered(serverDNS, iemCreds, site, successStatus, restTimeOutLength, serverPort):
	
	print "Performing GET request to get list of analysis for \"" + site + "\" site..."
	
	siteWithoutSpaces = site.replace(" ", "%20")
	headers = {"Authorization": "Basic '" + iemCreds + "'"}
	
	response = requests.get("https://" + str(serverDNS) + ":" + str(serverPort) + "/api/analyses/external/" + siteWithoutSpaces,verify=False,timeout=int(restTimeOutLength),headers=headers)
	if response.status_code != int(successStatus):
		raise Exception("ERROR: carrying out rest call to check site gathered: " + response.text + " status_code: " + str(response.status_code))

	root = ET.fromstring(response.text)
	
	print "Checking response for an analysis..."
	
	for analysis in root.findall('Analysis'):
		analysisName = analysis.find('Name').text
		if analysisName: #Empty strings are "falsy" which means they are considered false in a Boolean context, so a non empty string is truthy
			#found an analysis therefore site must be gathered
			return True
	return False		

"""Description:
	Module checks if the arguement passed on execution of the script is a string and has a length > 1. If not it returns an errormsg detailing the errors

	:param arguement: the value to check.
	:param name: the param name.
    """		
def verifyStringArguement(arguement, name):
	errors = ""
	if len(arguement) <= 1:
		errors += "Arguement " + name + "[" + str(arguement) + "] has a length <= 1.\n"
	if not isinstance(arguement, basestring):
		errors += "Arguement" + name + "[" + str(arguement) + "] is not a string.\n"
	return errors

"""Description:
	Module checks if the arguement passed on execution of the script has a length > 1 and is numeric by attempting to convert it to an integer. If not it returns an errormsg detailing the errors

	:param arguement: the value to check.
	:param name: the param name.
    """
def verifyIntArguement(arguement, name):
	errors = ""
	if len(arguement) <= 1:
		errors += "Arguement " + name + "[" + str(arguement) + "] has a length <= 1.\n"
	try:
		int(arguement)
	except Exception as e:
		errors += "Arguement " + name + "[" + str(arguement) + "] is not an integer.\n"
	return errors
	
"""Description:
	Code performs a get request to retrieve the list of analysis for a given site name
	Once an analysis is found for the site, it is assumed that the site is gathered
	If an analysis is not found for all sites within the assigned timeout time the code exits with an error status.

	:param platformName: Name of the server container.
	:param iemCreds: Encoded user;pwd value.
	:param siteNames: List of the sites to check seperated by ;.
	:param checkGatheredTimeOutLength: length of time in minutes to continue checking sites gathered, if not gathered script exits with a failed exit code.
	:param successStatus: status to compare with return status of a REST call (successfull call returns a status code of 200).
	:param restTimeOutLength: timeout time for REST call in seconds.
	:param waitTime: time in seconds to wait before re-checking if site is gathered (must be >= 2 digits).
	:param domain: the domain name of the platform.
    """
def main():

	if len(sys.argv) != 10:	#NOTE: len(sys.argv) counts the name of the file as the first arg. 
		print "ERROR: incorrect number of arguements passed to script..."
		exit(1)
	
	platformName = sys.argv[1]
	iemCreds = base64.standard_b64encode(sys.argv[2])
	siteNames = sys.argv[3]
	checkGatheredTimeOutLength = sys.argv[4]
	timeOutTime = datetime.datetime.now() + datetime.timedelta(minutes=int(checkGatheredTimeOutLength))
	successStatus = sys.argv[5]
	restTimeOutLength = sys.argv[6]
	waitTime = sys.argv[7]
	domain = sys.argv[8]
	serverPort = sys.argv[9]
	siteList = siteNames.split(";")
	numberSitesGathered = 0
	numberOfSites = len(siteList)
	sitesGathered = list()
	if domain == "NONE":
		print "No domain name provided..."
		serverDNS = platformName
	else:
		serverDNS = platformName + "." + domain
	
	#check arguements are valid
	arguementErrors = ""
	arguementErrors += verifyStringArguement(serverDNS, "serverDNS")
	arguementErrors += verifyStringArguement(iemCreds, "iemCreds")
	arguementErrors += verifyStringArguement(siteNames, "siteNames")
	arguementErrors += verifyIntArguement(checkGatheredTimeOutLength, "checkGatheredTimeOutLength")
	arguementErrors += verifyIntArguement(successStatus, "successStatus")
	arguementErrors += verifyIntArguement(restTimeOutLength, "restTimeOutLength")
	arguementErrors += verifyIntArguement(waitTime, "waitTime")
	arguementErrors += verifyIntArguement(serverPort, "serverPort")
	if len(arguementErrors)	> 0:
		print "ERROR:\n" + arguementErrors
		exit(2)
	
	try:
		while datetime.datetime.now() < timeOutTime and numberSitesGathered < numberOfSites:
			for siteName in siteList:
				print "Checking if " + siteName + " site is gathered..."
				response = checkSiteGathered(serverDNS, iemCreds, siteName, successStatus, restTimeOutLength, serverPort)
				if response == False:
					print siteName + " site is not gathered..."
				else:
					print siteName + " site is gathered..."
					numberSitesGathered += 1
					sitesGathered.append(siteName)
			if numberSitesGathered < numberOfSites:
				for gatheredSiteName in sitesGathered:
					if gatheredSiteName in siteList:
						siteList.remove(gatheredSiteName)
				print "Waiting " + waitTime + " seconds before checking again..."
				time.sleep(float(waitTime))
			
		if numberSitesGathered < numberOfSites:
			print "ERROR: gathering sites, time-out of " + str(checkGatheredTimeOutLength) + " minutes reached..."
			exit(3)
		else:
			print "All required sites gathered..."
			exit(0)
	except Exception as e:         
		print("Exception::message="+str(e.args))
		exit(4)
	
if __name__ == "__main__":
	main()