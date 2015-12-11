var saxpath = require('saxpath');
var fs = require('fs');
var sax = require('sax');
var parseString = require('xml2js').parseString;
var builder = require('xmlbuilder');
var util = require('util');

var saxParser = sax.createStream(true);
var streamer = new saxpath.SaXPath(saxParser, '/BESAPI/Query/Result/Tuple');
var computers = [];
var count = 0;
var postStream = fs.createWriteStream('postStreamBody.xml');
var finalCB = null;
var thatRef = null;
var maxNoComputers = process.argv[7];

function formatCVEData(cvesFile, callback, thisRef) {
    finalCB = callback;
    thatRef = thisRef;
    if (!fs.existsSync(cvesFile)) {
        var error = 'Cannot find CVEs file.... Aborting!';
        console.error(error);
        callback(error);
    }
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
<<<<<<< HEAD
    postStream.write('<?xml version="1.0"?>\n<BESAPI>\n<DashboardData>\n<Dashboard>' + process.argv[2] +'</Dashboard>\n<Name>' + "assets" + '</Name>\n<IsPrivate>false</IsPrivate>\n<Value>{"assets":[');
=======
    postStream.write('<?xml version="1.0"?>\n<BESAPI>\n<DashboardData>\n<Dashboard>' + process.argv[2] +'</Dashboard>\n<Name>' + name + '</Name>\n<IsPrivate>false</IsPrivate>\n<Value>{"name":"'+ name +'","assets":[');
>>>>>>> master
    streamer.on('match', createAssets);
    streamer.on('end', closeXML);
    fs.createReadStream(cvesFile).pipe(saxParser);
}
/*
 * Callback Functions
 */
function createAssets(xml) {
    if(count < maxNoComputers) {
        if(count !== 0) {
            postStream.write(',');
            count++;
        } else {
            count++;
        }
        parseString(xml, function (err, result) {
            var computer = {};
            computer.fqdn = result.Tuple.Answer[0]._;
            computer.besid = result.Tuple.Answer[1]._;
            //computer.addr = [];
            //computer.addr.push({ipv4: result.Tuple.Answer[2]._});
            //computer.addr.push({mac: ''});
            cveIDsStr = result.Tuple.Answer[2]._;
            if(cveIDsStr && typeof cveIDsStr !== 'undefined') {
                if(cveIDsStr.indexOf(';')) {
                    cveIDsStr = cveIDsStr.replace(/;/g,',');
                }
                cveIds = cveIDsStr.split(',');
                var cves = [];
                var totalRisk = 0.0;
                var cveLength = cveIds.length;
                for(var i = cveLength; i--;) {
                    var cve = {};
                    cve.id = cveIds[i].trim();
                    cve.id = cve.id.replace('CVE-','');
                    cve.risk = 1;
                    totalRisk += cve.risk;
                    cves.push(cve);
                }
                computer.cves = cves;
                computer.risk = totalRisk;
            }
            else {
                computer.cves = [];
                computer.risk = 0.0;

            }
            postStream.write(JSON.stringify(computer));
            computers.push(computer);
        });
    }
}

function closeXML(err, result) {
    if(err) {
        console.log(err);
    }
    postStream.write(']}\n</Value>\n</DashboardData>\n</BESAPI>');
    finalCB.call(thatRef);
}

exports.formatCVEData = formatCVEData;