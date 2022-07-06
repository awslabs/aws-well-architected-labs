const AWS = require('aws-sdk');
const currentRegion = process.env.AWS_REGION;
const dynamodb = new AWS.DynamoDB({ region: currentRegion });
const documentClient = new AWS.DynamoDB.DocumentClient({ service: dynamodb });

async function mappingEngineQueries(event){
    try{
        const PillarNumber = event;
        //console.log("PillarNumber: ", PillarNumber);
        const result = await documentClient.get({
            TableName : process.env.DatabaseTable,
            Key: { PillarNumber } ,
        }).promise();

        return result.Item;

    } catch(err){
        console.error(err);
        return err;
    }

}

module.exports.mappingEngineQueries = mappingEngineQueries;