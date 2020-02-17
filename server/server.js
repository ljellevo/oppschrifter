const express = require('express');
const cors = require('cors');
const app = express();
const bodyParser = require('body-parser');
var enforce = require('express-sslify');

var path = require('path');

//Middleware
app.use(cors())
app.use(express.json());
app.use(express.static('bin'));
app.use(bodyParser.urlencoded({ extended: true }));
if(process.env.PORT ) {
  app.use(enforce.HTTPS({ trustProtoHeader: true }))
}


const api = require("./api")(app);  

/*
app.get('/api/test', function(req, res){
  res.send("Hello world");
});
*/

app.get('/*', function (req, res) {
  res.sendFile(path.resolve(__dirname, '../bin/index.html'))
});

const PORT = process.env.PORT || 3000;
app.listen(PORT, function(){
  console.log("Listening on port: " + PORT)
});

