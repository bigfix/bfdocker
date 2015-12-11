var datasource = require('./libs/queryRelevantCVEs');
var produceDashData = require('./libs/processIntoPost');
var postDashData = require('./libs/postDashboardData');

if(process.argv.length < 8) {
  console.log("Error!!! Usage: <dashboard name> <BFServer> <BFPort> <BFUser> <BFPassword> <maxNoComputers>");
  process.exit(1);
}

var connInfo = {};
var dashboardName = process.argv[2];
connInfo.bigFixServer = process.argv[3];
connInfo.restPort = process.argv[4];
connInfo.user = process.argv[5];
connInfo.password = process.argv[6];
datasource.queryCVEs(connInfo, processIntoPost);
//processIntoPost(null, 'cves.xml');
var start = new Date().getTime();


function processIntoPost(error, cvesFile) {
	if(error) {
		console.dir(error);
	}
	produceDashData.formatCVEData(cvesFile, postCVEData);
}

function postCVEData(error, postBody) {
	if(error) {
		console.dir(error);
	}
	var end = new Date().getTime();
	var timtaken = end - start; 
    console.log('Operation took: ' + timtaken/1000 + " seconds" );
}
