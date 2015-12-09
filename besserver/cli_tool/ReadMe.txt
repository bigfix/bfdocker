***************************************************************
* Read me to explain what the scrtipts do and how to use them *
***************************************************************

All scripts require node to run! 

******************
* Real Data Tool *
******************

These two scripts can find all fixlets on a bigfix server that address CVEs 
and also have applicable computers. We will use it primarily to populate real data for our dashboards to use
until the QRadar team delivers a plugin that will do pretty much the same thing. 


1) npm install

2) node app.js QRadarScan.ojo <bigfixServer> <bfPort> <iemUser> <iemPassword> <maxNoComputers>
	
	- This produces a file called postStreamBody.xml which can be posted using the tool in step 3.

3) node postDashboardData.js postStreamBody.xml QRadarScan.ojo <bigfixServer> <bfPort> <iemUser> <iemPassword>


********************
* Mocked Data Tool *
********************

4)  MockQRPluginData.js - creates fake data for the qrplugin. It can be used to test the qrplugin under high loads but the
    data it produces will not appear in the console as it does not relate to real bigfix computers.

	node MockQRPluginData.js <numComputers> <numCVES> <DashboardStore>     
   	
   	e.g.
   	
   	node MockQRPluginData.js 100000 5 QRadarScan.ojo 

	- will produce a file caleed postBody_xx.xml that can be posted to the QRadarScan dashboard variable
	  with a 100000 computers with 5 CVEs each. To post the file use the script in step 3 above.
