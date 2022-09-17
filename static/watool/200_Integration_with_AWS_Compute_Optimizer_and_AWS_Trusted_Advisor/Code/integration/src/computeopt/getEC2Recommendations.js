const AWS = require('aws-sdk');
const currentRegion = process.env.AWS_REGION;
const computeoptimizer = new AWS.ComputeOptimizer({ apiVersion: '2019-11-01', region: currentRegion });

const { date } = require('../libraries/date');
const { describe } = require('../ec2/describe');
const { checkTag } = require('../ec2/checkTag');
const queries = require('../dynamodb/queries');
const { question6 , question7 } = require('../questions/costQuestion');

async function getEC2Recommendations(event) {
    try {
        //console.log("event details: ", event);
        //get the current date
        const currentDate = await date();
        const accountId = event.accountId; //AWS account ID
        const workloadId = event.workloadId //Well-Architected workload ID
        const workloadTagKey = Object.keys(event.tag)[0]; //Tag key
        const workloadTagValue = Object.values(event.tag)[0]; //Tag value
        //const questionId = 'type-size-number-resources';

        //EC2Recommendations are related to question #6 in Cost Optimization Pillar
        //Get QuestionId,TACheckId from mapping table between Trusted Advisor Checks and WA questions in DynamoDB
        //const pillarNumber = 'COST-6';
        const responses = await queries.mappingEngineQueries();
        for (const response of responses.Items) {
            const pillarNumber = response.PillarNumber;
            const pillarID = response.PillarId;
            const questionId = response.QuestionId;
            const taCheckId = response.TACheckId;

            console.log("questionID: ", questionId);
            console.log("TACheckID: ", taCheckId);
            console.log("Tag: ",workloadTagKey,workloadTagValue);

            if(questionId == 'type-size-number-resources'){
                const questio6Response = await question6(accountId, workloadId, workloadTagKey, workloadTagValue, questionId, taCheckId);
            } else if(questionId == 'pricing-model'){
                const questio7Response = await question7(accountId, workloadId, questionId, taCheckId);
            } else{
                console.log("Implementation of this question is needed.")
            }
        }
        return responses;

    }
    catch (err) {
        console.error(err);
        return err;
    }
}
module.exports.getEC2Recommendations = getEC2Recommendations;