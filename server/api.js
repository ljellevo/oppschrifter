module.exports = function(app) {
  const Database = require("./database");
  var ObjcetId = require('mongodb').ObjectId;
  var crypto = require('crypto');
  var jwt = require('jsonwebtoken');
  var jwtsecret = require('./jwt_secret');
  var ascOrder = {order: 1};
  var newestFirst = {uploaded: -1};
  var oldestFirst = {uploaded: 1};



  app.post('/api/auth', function(req, res){
    if(!req.headers.cookie) {
      res.send(false);
      return;
    }
    var token = req.headers.cookie.split("=")[1];
    var decoded = jwt.verify(token, jwtsecret.config.secret);

    var database = new Database();
    database.query(function(client) {
      const collection = client.db("oppschrifter").collection("users");
      collection.findOne({username: decoded.username}, function(err, result) {
        if(err) console.log(err);
        if(result.password == decoded.password) {
          res.send(true);
        } else {
          res.send(false);
        }
      })
    });
  });

  /**
   * Not done
   */
  app.post('/api/login', function(req, res){
   var username = req.body.username;
   var clientPassword = req.body.password;
    var database = new Database();
    database.query(function(client) {
      const collection = client.db("oppschrifter").collection("users");
      collection.findOne({username: username}, function(err, result) {
        if(err) console.log(err);
        var password = crypto.pbkdf2Sync(clientPassword, result.salt, result.iterations, result.keylength, result.digest).toString('hex');
        if(result.password == password) {
          res.statusCode = 200;
          var token = jwt.sign({username: username, password: password}, jwtsecret.config.secret);
          res.send(token);
        } else {
          res.statusMessage = "Wrong password";
          res.status(400).end();
        }
      })
    });
  }); 

  /**
   * Not done
   */
  app.post('/api/register', function(req, res){
    var username = req.body.username;
    var clientPassword = req.body.password;
    var salt = crypto.randomBytes(128).toString('base64');
    var iterations = 10000;
    var keylength = 512;
    var digest = "sha512";
    var password = crypto.pbkdf2Sync(clientPassword, salt, iterations, keylength, digest).toString('hex');

    var userObject = {
      username: username,
      password: password,
      salt: salt,
      iterations: iterations,
      keylength: keylength,
      digest: digest
  };


    var database = new Database();
    database.query(function(client) {
      const collection = client.db("oppschrifter").collection("users");
      collection.find({username: username}).toArray(function(err, result) {
        if(err) console.log(err);
        if(result.length != 0) {

          res.statusMessage = "User exists";
          res.status(400).end();
        } else {
          database.query(function(client) {
            const collection = client.db("oppschrifter").collection("users");
            collection.insertOne(userObject, function(err, result) {
              if(err) console.log(err);
                res.statusCode = 200;
                //Send JWT
                var token = jwt.sign({username: username, password: password}, jwtsecret.config.secret);
                res.send(token);
            })
          });
        }
      })
    });
  });

  function authenticateRequest(request, callback) {
    if(!request.headers.cookie) {
      console.log("No header")
      return false;
    }
    var token = request.headers.cookie.split("=")[1];
    var decoded = jwt.verify(token, jwtsecret.config.secret);

    var database = new Database();
    database.query(function(client) {
      const collection = client.db("oppschrifter").collection("users");
      collection.findOne({username: decoded.username}, function(err, result) {
        console.log("Fetching user")
        if(err) console.log(err);
        if(result.password == decoded.password) {
          console.log("Passwords match")
          callback(true)
        } else {
          console.log("Passwords dont match")
          callback(false)
        }
      })
    });
  }

  app.get('/api/recipe/:query', function(req, res){
    var query = req.params.query;
    authenticateRequest(req, function(result) {
      console.log("Is request authnticated?: " + result);
      console.log("Getting recipe")
      var database = new Database();
      database.query(function(client) {
        const collection = client.db("oppschrifter").collection("recipes");
        //.sort(ascOrder)
        collection.find({tags: {$regex : new RegExp(".*" + query + ".*", "i")}}).toArray(function(err, result) {
          if(err) console.log(err);
          console.log(result)
          res.send(result);
        })
      });
    });
  });

  app.get('/api/recipe/', function(req, res){
    authenticateRequest(req, function(result) {
      console.log("Is request authnticated?: " + result);

      var database = new Database();
      database.query(function(client) {
        const collection = client.db("oppschrifter").collection("recipes");
        //.sort(ascOrder)
        collection.find({}).sort(newestFirst).toArray(function(err, result) {
          if(err) console.log(err);
          console.log(result)
          res.send(result);
        })
      });
    });
  });

  app.post('/api/recipe', function(req, res){

    /**
     * Need to implemet auth of request
     */
    authenticateRequest(req, function(result) {
      var database = new Database();
      database.query(function(client) {
        const collection = client.db("oppschrifter").collection("recipes");
        collection.insertMany([
          req.body
        ]);
        res.send("Done");
      });
    });
  });


}