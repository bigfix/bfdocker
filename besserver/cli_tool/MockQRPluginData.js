var fs = require('fs');
var path = require('path');

if(process.argv.length < 5) {
  console.log("Error!!! Usage: <numComputers> <numCVES> <DashboardStore>");
  process.exit(1);
}

// Read in Params, No. of computers, No. of CVEs per computers
var numAssets = +process.argv[2]; 
var numCVEs = +process.argv[3];
var dashboardVariable = process.argv[4];
// create CVEs array, each asset will have the same CVEs
var cves = [];
for(var i = numCVEs; i--;) {
	var cve ={};
	cve.id = "CVE-2015-" + i;
	cve.risk = "1";
	cves.push(cve);
}
var date = new Date();
var date = new Date();
var month = date.getMonth() + 1 + '';
if(month.length !== 2) {
    month = '0' + month;
}
var dayOfMonth = date.getDate() + '';
if(dayOfMonth.length !== 2) {
    dayOfMonth = '0' + dayOfMonth;
}
var hour = date.getHours() + '';
if(hour.length !== 2) {
    hour = '0' + hour;
}
var minutes = date.getMinutes() + '';
if(minutes.length !== 2) {
    minutes = '0' + minutes;
}
var seconds = date.getSeconds() + '';
if(seconds.length !== 2) {
    seconds = '0' + seconds;
}
var milliSeconds = date.getMilliseconds() + '';
var maxLength = 3;
var missing = maxLength - milliSeconds.length;
for(var i=0,l=missing; i < l; i++) {
    milliSeconds = '0' + milliSeconds;
}
var name = '' + date.getFullYear() +'' + month  + '' + dayOfMonth + '.' + hour +'' + minutes + '' + seconds + '.' + milliSeconds + '.1 Mocked - QRadar Data';

var timeStamp = date.getHours() +  date.getMinutes() + date.getSeconds();
var fileName = path.join(__dirname, 'postBody_' + timeStamp + '.xml');
var start = '<?xml version="1.0"?>\n<BESAPI>\n<DashboardData>\n<Dashboard>' + dashboardVariable + '</Dashboard>\n<Name>' + name + '</Name>\n<IsPrivate>false</IsPrivate>\n<Value>{"name":"'+ name +'", "assets":[';
var end = ']}\n</Value>\n</DashboardData>\n</BESAPI>';

fs.appendFileSync(fileName, start);
// write Mock Data  to file
for(var k = numAssets; k--;) {
	var computer = {};
	computer.fqdn = "simulated.computer." + k;
	computer.besid = k.toString();
	computer.cves = cves;
	if(k === numAssets -1) {
		// No comma before first asset
		fs.appendFileSync(fileName, JSON.stringify(computer));
	} else {
		fs.appendFileSync(fileName, ',' + JSON.stringify(computer));
	}
}
fs.appendFileSync(fileName, end);
