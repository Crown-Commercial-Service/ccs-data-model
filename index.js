

var SwaggerParser = require('swagger-parser');

myAPI= ""
SwaggerParser.validate(myAPI, function(err, api) {
    if (err) {
        console.error(err);
    }
    else {
        console.log("API name: %s, Version: %s", api.info.title, api.info.version);
    }
});
