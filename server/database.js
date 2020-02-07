
module.exports = class Database {

  constructor(){}

  query(callback) {
    var config = require('./database_config');
    const MongoClient = require('mongodb').MongoClient;
    const uri = config.config.url;
    
    const client = new MongoClient(uri, {useNewUrlParser: true, useUnifiedTopology: true});
    client.connect(err => {
      if(err) console.log(err)
      callback(client);
      client.close();
    });
  }
}

