//const AWS = require('aws-sdk');
//const currentRegion = process.env.AWS_REGION;
//const computeoptimizer = new AWS.ComputeOptimizer({apiVersion: '2019-11-01', region: currentRegion});
//const ec2 = new AWS.EC2({apiVersion: '2016-11-15', region: currentRegion});
//const computeoptimizer = new AWS.ComputeOptimizer({apiVersion: '2019-11-01', region: 'ap-southeast-1'});
//const ec2 = new AWS.EC2({apiVersion: '2016-11-15', region: 'ap-southeast-1'});

async function checkTag(ec2Tags, workloadTagKey, workloadTagValue){
    try{
        for(const ec2Tag in ec2Tags){
            //only update notes when EC2 instance has the tag that workload has
            if((ec2Tags[ec2Tag].Key == workloadTagKey) && (ec2Tags[ec2Tag].Value == workloadTagValue))
                return true;
        }
        return false;
        
    } catch(err){
        console.error(err);
        return err;
    }
}

module.exports.checkTag = checkTag;
