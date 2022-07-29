const AWS = require('aws-sdk');
const currentRegion = process.env.AWS_REGION;
const computeoptimizer = new AWS.ComputeOptimizer({ apiVersion: '2019-11-01', region: currentRegion });

const { date } = require('../libraries/date');
const { describe } = require('../ec2/describe');
const { checkTag } = require('../ec2/checkTag');
const { updateNotes } = require('../wellarchitected/updateNotes');
const { getTA } = require('../trustedadvisor/getTA');
const queries = require('../dynamodb/queries');

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

            const params = {
                accountIds: [
                    this.accountIds, /* AWS Account ID */
                ],
            };
            // new updates in notes in Well-Architected Tool
            let notes = '     ================= ' + 'Updated at ' + currentDate + '=================     ' + '\n';
            notes += '[AWS Compute Optimizer]' + '\n';
            let name = '';
            let instanceType = '';
            let finding = '';
            let reason = '';

            //get EC2 Instance Recommendations from AWS Compute Optimizer
            const EC2InstanceRecommendations = await computeoptimizer.getEC2InstanceRecommendations(params).promise();

            console.log("Compute Optimizer Recommendations: ", EC2InstanceRecommendations);

            for (const EC2InstanceRecommendation in EC2InstanceRecommendations.instanceRecommendations) {
                console.log("EC2 Loop:");
                const recommendations = EC2InstanceRecommendations.instanceRecommendations[EC2InstanceRecommendation];
                //console.log(recommendations);
                //Make sure if EC2 instance is being used for the particular workload using tag
                const arn = 'arn: ' + recommendations.instanceArn;
                const instanceId = arn.split('instance/').pop();
                //get all tags attached to EC2
                const ec2Tags = await describe(instanceId);
                let recommendedInstanceType = 'recommendedInstanceType: ';

                console.log("ARN: ", arn);
                //comparison between a tag of ec2 and a tag of workload in Well-Architected tool
                const tagResult = await checkTag(ec2Tags, workloadTagKey, workloadTagValue);

                //only update notes when EC2 instance has the tag that workload has
                if (tagResult) {
                    //results for notes in WA tool
                    name = 'name: ' + recommendations.instanceName;
                    instanceType = 'instanceType: ' + recommendations.currentInstanceType;
                    finding = 'finding: ' + recommendations.finding;
                    reason = 'reason: ' + recommendations.findingReasonCodes;
                    for (const recommendationOption in recommendations.recommendationOptions) {
                        recommendedInstanceType += recommendations.recommendationOptions[recommendationOption].instanceType + ' ';
                    }
                    notes += arn + '\n' + name + '\n' + instanceType + '\n' + finding + '\n' + reason + '\n' + recommendedInstanceType + '\n';
                }
                console.log("TagResult:", tagResult);
                
            }


            //get EC2 Instance Recommendations from AWS Trusted Advisor
            const trustedAdvisor = await getTA(taCheckId, workloadTagKey, workloadTagValue);
            notes += trustedAdvisor;
            //const reasonCodes = await findingReasonCodes(EC2InstanceRecommendations);
            notes += '     ============================ Done ============================     ' + '\n';
            
            console.log("Notes:", notes);
            
            //update notes 
            const noteParams = {
                currentDate,
                accountId,
                workloadId,
                questionId,
                notes,
            };
            
            console.log("Notes Params", noteParams);
            
            const updateNote = await updateNotes(noteParams);

            console.log(updateNote);
        }
        return responses;

    }
    catch (err) {
        console.error(err);
        return err;
    }
}
module.exports.getEC2Recommendations = getEC2Recommendations;
