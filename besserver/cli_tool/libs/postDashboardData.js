//Load the request module
var request = require('request');
//Load fs module
var fs = require('fs');

function postDashData(connInfo, dataStore, postBody, callback) {
    if (!fs.existsSync(postBody)) {
        var error = 'Cannot find CVEs file.... Aborting!';
        console.error(error);
        callback(error);
    }

    var stats = fs.statSync(postBody);
    var fileSizeInBytes = stats.size;
    console.log('FileSize: ', fileSizeInBytes);
    // Create Read Stream
    var source = fs.createReadStream(postBody,{ bufferSize: 64 * 1024 });

    // allow unsecure connection
    process.env.NODE_TLS_REJECT_UNAUTHORIZED = "0";

    auth = "Basic " + new Buffer(connInfo.user + ':' + connInfo.password).toString("base64");
    // prepare the header
    var postheaders = {
        'Content-Type' : 'text/xml',
        'Content-Length' : fileSizeInBytes,
        'Authorization' : auth
    };

    // the post options
    var optionspost = {
        rejectUnauthorized: false,
        uri : 'https://' + connInfo.bigFixServer + ':' + connInfo.restPort + '/api/dashboardvariables/' + dataStore,
        method : 'POST',
    	headers : postheaders
    };
    var start = new Date().getTime();
    source.pipe(request(optionspost, function (err, resp, body) {
        var end = new Date().getTime();
        console.log("-->Entering Callback");
        if (err) {
            callback(err);
        } else {
            process.stdout.write("\nPost response code: " + resp.statusCode + '\n');
            //process.stdout.write('\n' + console.dir(resp));
    	}
        var timtaken = end - start; 
        console.log('Operation took: ' + timtaken/1000 + " seconds" );
        callback(null, resp.statusCode);
    }));

}

exports.postDashData = postDashData;