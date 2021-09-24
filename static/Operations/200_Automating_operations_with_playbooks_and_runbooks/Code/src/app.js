'use strict';
const AWS = require('aws-sdk');
const AWSXRay = require('aws-xray-sdk');
const kmsClient = AWSXRay.captureAWSClient(new AWS.KMS({region: process.env.REGION }));
const secretsmanager = AWSXRay.captureAWSClient(new AWS.SecretsManager({region: process.env.REGION }));
const express = require('express');
const router = express.Router();
const bodyParser = require("body-parser");
var mysql = AWSXRay.captureMySQL(require('mysql'));
const zlib = require('zlib');


// Constants
const PORT = 80;
const HOST = '0.0.0.0';

// App
const app = express();
app.use(AWSXRay.express.openSegment('mysecretapp-api'));


app.use(bodyParser.urlencoded({ extended: false }));
app.use(bodyParser.json());


const DBHOST = process.env.DBHOST;
const KeyId  = process.env.KeyId;
const DBSecret = process.env.DBSecret;

function hydrateDBCreds( DBSecret ){
  var promise = new Promise(function(resolve,reject){
    var params = {
      SecretId: DBSecret
    };
    secretsmanager.getSecretValue(params, function(err, data) {
      if (err){
        console.log(err);
        reject(err);
      } 
      else{
        var secString = data['SecretString']
        var secObj = JSON.parse(secString)
        process.env.DBUSER = secObj['username']
        process.env.DBPASS = secObj['password']
        resolve ( data );
      }
                 // successful response
    });  
  });
  return promise;
};

function encryptData( KeyId, Plaintext ){
  var promise = new Promise(function(resolve,reject){
    kmsClient.encrypt({ KeyId, Plaintext }, (err, data) => {
      if (err) {
        console.log(err)
        reject(err); // an error occurred
      }
      else {
        const { CiphertextBlob } = data;
        resolve ( CiphertextBlob );
      };
    });
  
  });
  return promise;
};


function decryptData( KeyId, CiphertextBlob ){
  var promise = new Promise(function(resolve,reject){
    kmsClient.decrypt({ CiphertextBlob, KeyId }, (err, data) => {
      if (err) {
        console.log(err)
        reject(err); // an error occurred
      }
      else {
        const { Plaintext } = data;
        resolve ( Plaintext.toString() );
      };
    });
  
  });
  return promise;
};



function decryptData( KeyId, CiphertextBlob ){
  var promise = new Promise(function(resolve,reject){
    kmsClient.decrypt({ CiphertextBlob, KeyId }, (err, data) => {
      if (err) {
        console.log(err)
        reject(err); // an error occurred
      }
      else {
        const { Plaintext } = data;
        resolve ( Plaintext.toString() );
      };
    });
  
  });
  return promise;
};



function createDB(DBSecret){
  
  var promise = new Promise(function(resolve,reject){
  try
    {
        var con = mysql.createConnection({host: DBHOST,user: process.env.DBUSER ,password: process.env.DBPASS});
        var sql = "CREATE DATABASE IF NOT EXISTS mydb";
        con.query(sql, function (err, result) {
          if (err) {
            con.end();
            reject(err);
          }
          else{
            con.end();
            resolve("database create done");
          }
        });
      }
    catch(err){
      reject(err);
    }
  });
  return promise;
};

function createTable(){
  var promise = new Promise(function(resolve,reject){
  try
    {
    var con = mysql.createConnection({host: DBHOST,user: process.env.DBUSER ,password: process.env.DBPASS,database: "mydb"});
    var sql = "CREATE TABLE IF NOT EXISTS peoplesecret (name VARCHAR(244) NOT NULL, secret TEXT, PRIMARY KEY (name) )";
    con.query(sql, function (err, result) {
      if (err) {
        con.end();
        reject(err);
      }
      else{
        con.end();
        resolve("table create done");
      }
    });
    }
    catch(err){
      reject(err);
    }
  });
  return promise;
};

function storeSecret(Payload){
  
  var promise = new Promise(function(resolve,reject){
    try{
    var con = mysql.createConnection({host: DBHOST,user: process.env.DBUSER ,password: process.env.DBPASS,database: "mydb"});
    var sql = "INSERT INTO peoplesecret (name, secret) VALUES ('" + Payload['Name'] + "', '" + Payload['Text'] + "' ) ON DUPLICATE KEY UPDATE name= '"+ Payload['Name']  +"', secret='" +  Payload['Text'] + "'" ;
    con.query(sql, function (err, result) {
      if (err) {
        con.end();
        reject(err);
      }
      else{
        con.end();
        resolve("1 record inserted");
      }
    });
    }
    catch(err){
      reject(err);
    }
  });
  return promise;
};

function getSecret(Payload){
  
  var promise = new Promise(function(resolve,reject){
    try{
      var con = mysql.createConnection({host: DBHOST,user: process.env.DBUSER ,password: process.env.DBPASS,database: "mydb"});
      var sql = "SELECT secret from peoplesecret WHERE name='"+ Payload['Name'] +"'";
      con.query(sql, function (err, result) {
        if (err) {
          con.end();
          reject(err);
        }
        else{
          if(result.length < 1){
            con.end();
            reject('no record found');
          } 
          else{
            con.end();
            resolve(result[0].secret);
          }
        }
      });
    }
    catch(err){
      reject(err)
    }
  });
  return promise;
};



router.get('/', (req, res) => {
      res.status(200).send( 'OK' );
});

router.post('/encrypt', (req, res) => {
  const Payload = {
    'Name': req.body.Name,
    'Text': req.body.Text
  }

  hydrateDBCreds(DBSecret)
  .then(function(response){
    encryptData(KeyId, Payload['Text'])
    .then(function(response) {
      var encryptedData = response;
      const EncryptedDataBase64Str = zlib.gzipSync(JSON.stringify(encryptedData)).toString('base64');
      Payload['Text'] = EncryptedDataBase64Str
      return Payload;
    })
    .then(function(response) {
      var Payload = response;
  
      //Prepare Database & Table
      createDB()
      .then(function(res){
        
          createTable()
          .then(function(res){
            //Insert Record
            storeSecret(Payload)
            .then(function(response){
              console.log(response);
              return response;
            })
            .catch(function(err){
              console.log(err);
              res.status(500).send( {'Message':'oops something went wrong !' });
            });
          })
          .catch(function(err){
            console.log(err);
            res.status(500).send( {'Message':'oops something went wrong !' });
          });
      
      })
      .catch(function(err){
        console.log(err);
        res.status(500).send( {'Message':'oops something went wrong !' });
        process.exit(500)
      });
      return Payload;
    })
    .then(function(response){   
        var output = {
          'Message':'Data encrypted and stored, keep your key save',
          'Key' : KeyId 
        };
        //console.log(response)
        res.status(200).send( output );
    })
    .catch(function(err) {
        console.log(err);
        
        res.status(400).send( {'Message':'Data encryption failed, check logs for more details' });
    });
    return response
  })
  .catch(function(err){
      console.log(err);
      res.status(400).send( {'Message':'Failed Hydrating Credentials' });
  })
});

router.get('/decrypt', (req, res) => {
  const Payload = {
    'Name': req.body.Name,
    'Key': req.body.Key
  }
  hydrateDBCreds(DBSecret)
  .then(function(response){
    getSecret(Payload)
    .then(function(response) {
      var secretText = response;
      const originalObj = JSON.parse(zlib.unzipSync(Buffer.from(secretText, 'base64')));
      var buf = Buffer.from(originalObj, 'utf8');
      decryptData(Payload['Key'],buf)
      .then(function(response){
        var output = {
          'Text':response,
        };
        res.status(200).send( output );
      })
      .catch(function(err){
        res.status(400).send( {'Message':'Data decryption failed, make sure you have the correct key' });
      });
      return response;
    })
    .catch(function(err) {
        res.status(400).send( {'Message':'Failed getting secret text, check the user name' });
    });
  return response;
  })
  .catch(function(err){
      console.log(err);
      res.status(400).send( {'Message':'Failed Hydrating Credentials' });
  })
});

app.use("/",router);
app.use(AWSXRay.express.closeSegment());


app.listen(PORT, HOST);
console.log(`Running on http://${HOST}:${PORT}`);