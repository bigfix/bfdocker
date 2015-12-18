var https = require('https');
var fs = require('fs');
var path = require('path');
var PropertiesReader = require('properties-reader');

function queryBigFixCVEs(connInfo, callback) {
    if(!connInfo) {
        callback('required connInfo Object was null');
        return;
    }
    auth = "Basic " + new Buffer(connInfo.user + ':' + connInfo.password).toString("base64");
    //var body = "relevance=(hostname of it, id of it, ip addresses of it, cve id lists of relevant fixlets whose ( name of site of it contains \"CentOS\" and cve id list of it does not contain \"N/A\") of it) of bes computers";
    //var body = "relevance=(name of it, id of it, concatenation \", \" of unique values of cve id lists of relevant fixlets whose (cve id list of it is not \"N/A\" and cve id list of it is not \"Unspecified\" and cve id list of it is not \"\") of it) of bes computers whose (operating system of it starts with \"Win\")";
    var body = "relevance=(name of it, id of it, concatenation \", \" of unique values of cve id lists of relevant fixlets whose (cve id list of it is not \"N/A\" and cve id list of it is not \"Unspecified\" and cve id list of it is not \"\") of it) of bes computers";
    // prepare the header
    var postheaders = {
        'Content-Type' : 'text/plain',
        'Content-Length': Buffer.byteLength(body),
        "Authorization" : auth
    };
    // the post options
    var optionspost = {
        rejectUnauthorized: false,
        host : connInfo.bigFixServer,
        port : connInfo.restPort,
        path : '/api/query',
        method : 'POST',
        headers : postheaders
    };
    var date = new Date();
    var fileName = 'cves.xml';//path.join(__dirname, 'relCVEData_' + date.getHours() +  date.getMinutes() + date.getSeconds());
    var writeStream = fs.createWriteStream(fileName );

    // do the POST call
    var reqPost = https.request(optionspost, function(res) {
        res.pipe(writeStream);

        res.on('end', function() {
            callback(null, fileName);
        });
    });

    reqPost.write(body);
    reqPost.end();
    reqPost.on('error', function(e) {
        console.log('POST Error');
        console.error(e);
    });

    reqPost.on('end', function() {
        console.log('Retrieved data from Bigfix');
    });
}

exports.queryCVEs = queryBigFixCVEs;