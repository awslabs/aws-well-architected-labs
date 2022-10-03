const AWS = require('aws-sdk');
const currentRegion = process.env.AWS_REGION;
const computeoptimizer = new AWS.ComputeOptimizer({apiVersion: '2019-11-01', region: currentRegion});
const ec2 = new AWS.EC2({apiVersion: '2016-11-15', region: currentRegion});
//const computeoptimizer = new AWS.ComputeOptimizer({apiVersion: '2019-11-01', region: 'ap-southeast-1'});
//const ec2 = new AWS.EC2({apiVersion: '2016-11-15', region: 'ap-southeast-1'});

async function describe(event){
    try{
        const getTag = {
            InstanceIds: [
                event,
            ]
            };
        const ec2Details = await ec2.describeInstances(getTag).promise();
        //get all tags associated with EC2 instance
        const ec2Tags = ec2Details.Reservations[0].Instances[0].Tags;
        return ec2Tags;

    } catch(err){
        console.error(err);
        return err;
    }
}

module.exports.describe = describe;
