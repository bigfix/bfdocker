//Load the request module
var request = require('request');
//Load fs module
var fs = require('fs');

console.log("Num Args: " + process.argv.length);
if(process.argv.length < 8) {
  console.log("Error!!! Usage: <xmlFile> <dashboard name> <iemServer> <iemPort> <iemUser> <iemPassword>");
  process.exit(1);
}

var stats = fs.statSync(process.argv[2]);
var fileSizeInBytes = stats.size;
console.log('FileSize: ', fileSizeInBytes);
// Create Read Stream
var source = fs.createReadStream(process.argv[2],{ bufferSize: 64 * 1024 });

// allow unsecure connection
process.env.NODE_TLS_REJECT_UNAUTHORIZED = "0";

auth = "Basic " + new Buffer(process.argv[6] + ':' + process.argv[7]).toString("base64");
// prepare the header
var postheaders = {
    'Content-Type' : 'text/xml',
    'Content-Length' : fileSizeInBytes,
    'Authorization' : auth
};

// the post options
var optionspost = {
    rejectUnauthorized: false,
    uri : 'https://' + process.argv[4] + ':' + process.argv[5] + '/api/dashboardvariables/' + process.argv[3],
    method : 'POST',
	headers : postheaders
};
var start = new Date().getTime();
source.pipe(request(optionspost, function (err, resp, body) {
    var end = new Date().getTime();
    //console.log("-->Entering Callback");
    //console.dir(err);
    if (err) {
        process.stderr.write('\nError!:' + err);
    } else {
        process.stdout.write("\nPost response code: " + resp.statusCode + '\n');
        //process.stdout.write('\n' + console.dir(resp));
	}
    var timtaken = end - start; 
    console.log('Operation took: ' + timtaken/1000 + " seconds" );
}));