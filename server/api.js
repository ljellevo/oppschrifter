module.exports = function(app) {
  const Database = require("./database");
  var ObjcetId = require('mongodb').ObjectId;
  var ascOrder = {order: 1};



  
  app.get('/api/widgets', function(req, res){
    var database = new Database();
    database.query(function(client) {
      const collection = client.db("static").collection("categories");
      collection.find({}).sort(ascOrder).toArray(function(err, result) {
        if(err) console.log(err);
        res.send(result);
      })
    });
  });


  app.get('/api/widgets/:category', function(req, res){
    var category = req.params.category
    var database = new Database();
    database.query(function(client) {
      const collection = client.db("static").collection("catalogue");
      collection.find({category: category}).sort(ascOrder).toArray(function(err, result) {
        if(err) console.log(err);
        res.send(result);
      })
    });
  });

  app.get('/api/widgets/:category/:name', function(req, res){
    var name = req.params.name
    var database = new Database();
    database.query(function(client) {
      const collection = client.db("static").collection("catalogue");
      collection.findOne({name:  new RegExp("^" + name + "$", "i") }, function(err, result){
        if(err) console.log(err);
        res.send(result);
      })  
    });
  });



  app.get('/api/guides', function(req, res){
    var database = new Database();
    database.query(function(client) {
      const collection = client.db("static").collection("quick-start-guides");
      collection.find({}, {projection: {_id: 1, title: 1, desc: 1}}).toArray(function(err, result) {
        if(err) console.log(err);
        //Need to add order to guides and sort them with ascOrder
        res.send(result);
      })
    });
  });

  app.get('/api/guides/:id', function(req, res){
    var id = req.params.id
    console.log(id);
    var database = new Database();
    database.query(function(client) {
      const collection = client.db("static").collection("quick-start-guides");
      collection.findOne({_id: ObjcetId(id)}, function(err, result){
        if(err) console.log(err);
        res.send(result);
      })
    });
  });

  app.get('/api/news', function(req, res) {
    var database = new Database();
    var decDate = {date: -1};
    console.log("Getting news")
    database.query(function(client) {
      const collection = client.db("static").collection("news");
      collection.find({}).limit(3).sort(decDate).toArray(function(err, result) {
        console.log("Getting news inside")
        if(err) console.log(err);
        res.send(result);
      })
    });
  });
}