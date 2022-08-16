const AWS = require('aws-sdk');
const currentRegion = process.env.AWS_REGION;
const wellarchitected = new AWS.WellArchitected({apiVersion: '2020-03-31', region: currentRegion});

async function updateNotes(event){
    try{
        const params = {
            LensAlias: 'wellarchitected', /* this lab will use only Well-Architected Framework */
            QuestionId: event.questionId, /* required */
            WorkloadId: event.workloadId, /* required and change it to your own workload*/
            Notes: event.notes,
            };
        const updateResult = await wellarchitected.updateAnswer(params).promise();
        return updateResult;

    } catch(err){
        console.error(err);
        return err;
    }
}
module.exports.updateNotes = updateNotes;