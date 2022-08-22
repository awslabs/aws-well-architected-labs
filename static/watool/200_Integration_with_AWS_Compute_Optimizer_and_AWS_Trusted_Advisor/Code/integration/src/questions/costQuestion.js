const AWS = require('aws-sdk');
const currentRegion = process.env.AWS_REGION;
const computeoptimizer = new AWS.ComputeOptimizer({ apiVersion: '2019-11-01', region: currentRegion });
//const computeoptimizer = new AWS.ComputeOptimizer({ apiVersion: '2019-11-01', region: 'us-east-1' });
const { date } = require('../libraries/date');
const { describe } = require('../ec2/describe');
const { checkTag } = require('../ec2/checkTag');
const { getTAQ6, getTAQ7 } = require('../trustedadvisor/costTA');
const { updateNotes } = require('../wellarchitected/updateNotes');

async function question6(accountId, workloadId, workloadTagKey, workloadTagValue, questionId, taCheckId) {
    try {
        //console.log("event details: ", event);
        //get the current date
        const currentDate = await date();
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
            let savingsOpportunity = 'savingsOpportunity: ';

            console.log("ARN: ", arn);
            //comparison between a tag of ec2 and a tag of workload in Well-Architected tool
            console.log("Tag: ",ec2Tags, workloadTagKey,workloadTagValue);
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
                    
                    if(recommendations.finding = 'OVER_PROVISIONED'){
                        savingsOpportunity += JSON.stringify(recommendations.recommendationOptions[recommendationOption].savingsOpportunity.savingsOpportunityPercentage) + ' ';
                        //console.log(savingsOpportunity);
                    }
                }
                notes += arn + '\n' + name + '\n' + instanceType + '\n' + finding + '\n' + reason + '\n' + recommendedInstanceType + '\n' + savingsOpportunity +'\n';

            }
            //console.log("TagResult:", tagResult);            
        }
        //get EC2 Instance Recommendations from AWS Trusted Advisor
        const trustedAdvisor = await getTAQ6(taCheckId, workloadTagKey, workloadTagValue,taCheckId);
        notes += trustedAdvisor;
        //const reasonCodes = await findingReasonCodes(EC2InstanceRecommendations);
        notes += '     ============================ Done ============================     ' + '\n';
        
        //console.log("Notes:", notes);
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

        //console.log(updateNote);
        return notes;

    }
    catch (err) {
        console.error(err);
        return err;
    }
}

async function question7(accountId, workloadId, questionId, taCheckId) {
    try {
        //console.log("event details: ", event);
        //get the current date
        const currentDate = await date();
        // new updates in notes in Well-Architected Tool
        let notes = '     ================= ' + 'Updated at ' + currentDate + '=================     ' + '\n';
        //get Pricing Model Recommendations from AWS Trusted Advisor
        const trustedAdvisor = await getTAQ7(taCheckId);
        notes += trustedAdvisor;
        notes += '     ============================ Done ============================     ' + '\n';
        
        //console.log("Notes:", notes);
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

        //console.log(updateNote);
        return notes;

    }
    catch (err) {
        console.error(err);
        return err;
    }
}

module.exports.question6 = question6;
module.exports.question7 = question7;