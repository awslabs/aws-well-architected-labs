/*! Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
 *  SPDX-License-Identifier: MIT-0
 */

// dependencies
//const AWS = require('aws-sdk');
//const moment = require('moment');
//const documentClient = new AWS.DynamoDB.DocumentClient();
/*
exports.handler =  async (event) => {
    let params = {
        TableName : process.env.DatabaseTable,
        Item: {
        ID: Math.floor(Math.random() * Math.floor(10000000)).toString(),
        created:  moment().format('YYYYMMDD-hhmmss'),
        metadata:JSON.stringify(event),
        }
    }
    try {
        let data = await documentClient.put(params).promise()
    }
    catch (err) {
        console.log(err)
        return err
    }
    return {
        statusCode: 200,
        body: 'OK!',
    }
}
*/

const AWS = require('aws-sdk');
//const currentRegion = process.env.AWS_REGION;
//const wellarchitected = new AWS.WellArchitected({apiVersion: '2020-03-31', region: currentRegion});
const { getEC2Recommendations } = require('./computeopt/getEC2Recommendations');

exports.handler = async (event) => {
    try{
        //Check if tag is associated
        //Tag is being used to check if AWS resources are being used for your workload
        const tag = event.detail.requestParameters.Tags;
        if (tag != null)
        {
            //Will need AWS account, Workload ID and Tag 
            //to get EC2 Recommendation from AWS Compute Optimizer
            //to update notes in Well-Architected Tool
            var param = {
                accountId: event.account,
                workloadId: event.detail.responseElements.WorkloadId,
                tag: event.detail.requestParameters.Tags,
            };
            const ec2Recommendations = await getEC2Recommendations(param);
            
            return true;
        } else{
            //if there is no tag, notes in Well-Architected Tool won't be updated 
            console.log("Please attach the appropriate tag to AWS resources!");
            return false;
        }

    } catch(err){
        console.error(err);
        return err;
    }
}