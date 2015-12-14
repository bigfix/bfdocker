#!/usr/local/bin/python
import sys
import requests
import xml.etree.ElementTree as ET
import base64

"""Description:
	Module cperforms a GET request to get the xml for a given site. It then updates the ssubscription tag to specify "All" computers.
    """	
def getXml(serverDNS, headers, siteName, siteWithoutSpaces, successStatus, restTimeOutLength, serverPort):
	
	print "Performing GET request to get xml for \"" + siteName + "\" site..."
	
	response = requests.get("https://" + str(serverDNS) + ":" + str(serverPort) + "/api/site/external/" + siteWithoutSpaces,verify=False,timeout=int(restTimeOutLength),headers=headers)
	
	root = ET.fromstring(response.text)	
	
	for externalSite in root.findall('ExternalSite'):
		mode = externalSite.find('Subscription').find('Mode')
		if mode is not None:
			externalSite.find('Subscription').find('Mode').text = "All"
			return ET.tostring(root)
		else:
			print "Not found xml..."
			exit(1)
	return False
	

"""Description:
	Module calls the module "getXml" to get the xml to send with a PUT request to subscribe the specified site to all computers.
    """		
def subscribeToAllComps(serverDNS, iemCreds, siteName, siteWithoutSpaces, successStatus, restTimeOutLength, serverPort):
	
	headers = {"Authorization": "Basic '" + iemCreds + "'"}
	
	xml = getXml(serverDNS, headers, siteName, siteWithoutSpaces, successStatus, restTimeOutLength, serverPort)
	
	if xml != False:	
		print "Performing PUT request to subscribe all computers to \"" + siteName + "\" site..."
		
		response = requests.put("https://" + str(serverDNS) + ":" + str(serverPort) + "/api/site/external/" + siteWithoutSpaces,data=xml,verify=False,timeout=int(restTimeOutLength),headers=headers)
		if response.status_code != int(successStatus):
			raise Exception("ERROR: carrying out rest call: " + response.text + " status_code: " + str(response.status_code))
	else:
		return False

"""Description:
	Module checks if the arguement passed on execution of the script is a string and has a length > 1. If not it returns an errormsg detailing the errors.
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
	Module checks if the arguement passed on execution of the script has a length > 1 and is numeric by attempting to convert it to an integer. If not it returns an errormsg detailing the errors.
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
	Code performs a GET request to get the xml for the site to subscribe all computers to. Next the value "All" is added to the child node "Mode" for the subscription tag. Finally it submits a PUT request to the site to submit the computer subscription changes.
	:param param platformName: Name of the server container.
	:param iemCreds: Encoded user;pwd value.
	:param siteNames: List of the sites to subscribe all computers to seperated by a ;.
	:param successStatus: status to compare with return status of a REST call (successfull call returns a status code of 200).
	:param restTimeOutLength: timeout time for REST call in seconds.
	:param domain: the domain name of the platform.
    """
def main():
	
	if len(sys.argv) != 8:	#NOTE: len(sys.argv) counts the name of the file as the first arg. 
		print "ERROR: incorrect number of arguements passed to script..."
		exit(1)
	
	platformName = sys.argv[1]
	iemCreds = base64.standard_b64encode(sys.argv[2])
	siteNames = sys.argv[3]
	siteList = siteNames.split(";")
	successStatus = sys.argv[4]
	restTimeOutLength = sys.argv[5]
	domain = sys.argv[6]
	serverPort = sys.argv[7]
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
	arguementErrors += verifyIntArguement(successStatus, "successStatus")
	arguementErrors += verifyIntArguement(restTimeOutLength, "restTimeOutLength")
	arguementErrors += verifyIntArguement(serverPort, "serverPort")
	if len(arguementErrors)	> 0:
		print "ERROR:\n" + arguementErrors
		exit(2)
	
	try:
		for siteName in siteList:
			print "Subscribing all computers to \"" + siteName + "\" site..."
			siteWithoutSpaces = siteName.replace(" ", "%20")					
			response = subscribeToAllComps(serverDNS, iemCreds, siteName, siteWithoutSpaces, successStatus, restTimeOutLength, serverPort)
			if response != False:
				print "All computers subscribed to \"" + siteName + "\" site..."
			else:
				print "ERROR: getting xml for \"" + siteName + "\" site..."
				exit(3)
		exit(0)
	
	except Exception as e:         
		print("Exception::message="+str(e.args))
		exit(4)
	
if __name__ == "__main__":
	main()