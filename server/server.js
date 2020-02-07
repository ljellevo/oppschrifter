const express = require('express');
const cors = require('cors');
const app = express();
var path = require('path');

//Middleware
app.use(cors())
app.use(express.json());
app.use(express.static('bin'));

const api = require("./api")(app);  

/*
app.get('/api/test', function(req, res){
  res.send("Hello world");
});
*/

app.get('/*', function (req, res) {
  res.sendFile(path.resolve(__dirname, '../bin/index.html'))
});

app.listen(3000, function(){
  console.log("Listening on port 3000!")
});

