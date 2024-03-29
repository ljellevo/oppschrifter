module.exports = function(app) {
  const Database = require("./database");
  var ObjcetId = require('mongodb').ObjectId;
  var crypto = require('crypto');
  var jwt = require('jsonwebtoken');
  var jwtsecret = require('./jwt_secret');
  var ascOrder = {order: 1};
  var newestFirst = {uploaded: -1};
  var mostViewed = {viewed: -1};
  var oldestFirst = {uploaded: 1};

  
  /**
   * Authenticates cookie
   * @returns Bool
   */
  app.post('/api/auth', function(req, res){
    console.log(req.headers.cookie)
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
   * Authenticates user
   * @returns JWT token
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
   * Registrates user
   * @returns JWT Token
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

  /**
   * Authenticates request by validating token in header of HTTP request
   * @param {*} request 
   * @param {*} callback 
   */
  function authenticateRequest(request, callback) {
    if(!request.headers.cookie) {
      console.log("No header")
      return null;
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
          callback(result)
        } else {
          console.log("Passwords dont match")
          callback(null)
        }
      })
    });
  }

 /**
  * Finds recipes that is found with a given query, need to filter on user
  * @returns JSON object with results
  */
  app.get('/api/recipes/:query', function(req, res){
    var query = req.params.query;
    authenticateRequest(req, function(token) {
      if(token != null) {
        console.log("Is request authnticated?: " + result);
        console.log("Getting recipe")
        var database = new Database();
        database.query(function(client) {
          const collection = client.db("oppschrifter").collection("recipes");
          collection.find({dbTags: {$regex : new RegExp(".*" + query + ".*", "i")}, owner: token._id}).sort(mostViewed).toArray(function(err, result) {
            if(err) console.log(err);
            console.log(result)
            res.send(result);
          })
        });
      } else {
        res.statusMessage = "Not authenticated";
        res.status(403).end();
      }
    });
  });

  /**
   * Finds all registrated recipes, need to filter on user
   * @returns JSON object with result
   */
  app.get('/api/recipes/', function(req, res){
    authenticateRequest(req, function(token) {
      if(token != null) {
        console.log("Is request authnticated?: " + token);
        var database = new Database();
        database.query(function(client) {
          const collection = client.db("oppschrifter").collection("recipes");
          collection.find({owner: token._id}).sort(newestFirst).toArray(function(err, result) {
            if(err) console.log(err);
            console.log(result)
            res.send(result);
          })
        });
      } else {
        res.statusMessage = "Not authenticated";
        res.status(403).end();
      }
    });
  });


  /**
   * Finds specific recipe, need to filter on user
   * @returns JSON object with result
   */
  app.get('/api/recipe/:id', function(req, res){
    function updateViews(record, token, callback) {
      var newView = record.viewed + 1
      var database = new Database();
      database.query(function(client) {
        const collection = client.db("oppschrifter").collection("recipes");
        collection.updateOne({_id: record._id, owner: token._id},{$set: {viewed: newView}}, function(err, result) {
          if(err) console.log(err);
          console.log(result)
          callback()
        })
      });
    }


    authenticateRequest(req, function(token) {
      if(token != null) {
        console.log("Is request authnticated?: " + token);
        var database = new Database();
        database.query(function(client) {
          const collection = client.db("oppschrifter").collection("recipes");
          collection.findOne({_id: new ObjcetId(req.params.id), owner: token._id}, function(err, fetchedRecipe) {
            if(err) console.log(err);
            updateViews(fetchedRecipe, token, function(){
              res.send(fetchedRecipe);
            })
          })
        });
      } else {
        res.statusMessage = "Not authenticated";
        res.status(403).end();
      }
    });
  });



  /**
   * Adds new recipe to db, needs to add user as uploader
   * @returns status
   */
  app.post('/api/recipe', function(req, res){
    console.log("Uploading recipe") 
    authenticateRequest(req, function(token) {
      
      if(token != null) {
        var object = {
          name: req.body.name,
          category: req.body.category,
          hasLink: req.body.hasLink,
          ingredients: req.body.ingredients,
          amounts: req.body.amounts,
          steps: req.body.steps,
          url: req.body.url,
          tags: req.body.tags,
          dbTags: req.body.dbTags,
          uploaded: req.body.uploaded,
          viewed: req.body.viewed,
          owner: token._id
        }
        var database = new Database();
        database.query(function(client) {
          const collection = client.db("oppschrifter").collection("recipes");
          collection.insertOne(object, function(err, result) {
            if(err) console.log(err);
            res.send("Inserted");
          });
        });
      } else {
        res.statusMessage = "Not authenticated";
        res.status(403).end();
      }
    });
  });

  /**
   * Deletes specific recipe
   */

  app.get('/api/recipe/:id/delete', function(req, res){
    authenticateRequest(req, function(token) {
      if(token != null) {
        console.log("Is request authnticated?: " + token);
        var database = new Database();
        database.query(function(client) {
          const collection = client.db("oppschrifter").collection("recipes");
          collection.deleteOne({_id: new ObjcetId(req.params.id), owner: token._id}, function(err, fetchedRecipe) {
            if(err) console.log(err);
            res.statusCode = 200;
            res.send("Deleted");
          })
        });
      } else {
        res.statusMessage = "Not authenticated";
        res.status(403).end();
      }
    });
  });
}


