const AWS = require('aws-sdk');
const currentRegion = process.env.AWS_REGION;
const dynamodb = new AWS.DynamoDB({ region: currentRegion });
const documentClient = new AWS.DynamoDB.DocumentClient({ service: dynamodb });

async function mappingEngineQueries(){
    try{
        const result = await documentClient.scan({
            TableName : process.env.DatabaseTable
        }).promise();
        
        console.log("Table Items: ", result);
        return result;

    } catch(err){
        console.error(err);
        return err;
    }

}

module.exports.mappingEngineQueries = mappingEngineQueries;