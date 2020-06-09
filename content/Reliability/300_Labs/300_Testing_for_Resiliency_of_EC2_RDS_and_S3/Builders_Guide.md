---
title: "Builders Guide for 300 - Testing for Resiliency of EC2, RDS, and S3"
date: 2020-04-24T11:16:09-04:00
hidden: true
chapter: false
weight: 99
---
## Introduction

This guide contains the instructions for how to build the Lambda functions, the web application, and the modifications needed for the AWS CloudFormation templates' parameters as well as the JSON passed to the AWS Step Functions state machine to perform the deployment.

This guide will also give some specific instructions on the limitations of how you can deploy and what AWS regions it can be run in.

## Prerequisites

* An 
[AWS Account](https://portal.aws.amazon.com/gp/aws/developer/registration/index.html) that you are able to use for tesintg, that is not used for production or other purposes.
* Python installer program (pip)
* Go language development environment
* Comfort with JSON

***

## License
### Documentation License

Licensed under the [Creative Commons Share Alike 4.0](https://creativecommons.org/licenses/by-sa/4.0/) license.


## Building and uploading the AWS Lambda Functions

Each function also has a makefile included. This make file will use pip to install dependent packages, then zip the entire directory's contents into a zip file that will be located one directory up. You can deploy these to the region you wish to run the Lambda functions using the AWS Command Line Interface (CLI) as follows:

    % cd <LambdaDirectory>
    % make
    % cd ..
    % aws s3 cp <lambda>.zip s3://<S3 bucket>/<directory prefix>/<lambda>.zip

## Debugging the AWS Lambda Functions

The Lambda functions are all written in Python. They can be run on the command line with the python debugger, pdb, as follows:

    % python -m pdb <lambda_function>.py

The lambda functions all have an event that is passed in the main function that can be used to test your environment. The parameters are the same as they are to the AWS Step Functions state machine:

* log_level: This is the python logger logging level. To make it verbose in the logs, use the value "DEBUG"
* region_name: This is the region that the infrastructure is going to be deployed to
* secondary_region_name: This is the region where the red replica for this region will be deployed. (optional)
* workshop: A name to be added to the tags of the deployed infrastructure
* cfn_region: This is the region where the bucket that contains the AWS CloudFormation template is located
* cfn_bucket: This is the name of the S3 bucket where the AWS CloudFormation template is stored.
* folder: This is the apparent "folder" (actually a key prefix) where the CloudFormation template is located in the cfn_bucket.
* boot_bucket: This is the bucket in the region_name where the boot scripts and executables are located.
* boot_prefix: This is the apparent "folder" (actually a key prefix) where the boot scripts and executables are located.
* boot_object: This is the script executed on the instances to bootstrap the application.

This is an JSON string that looks like the following:

    {
      'log_level'             : 'DEBUG',
      'region_name'           : 'us-west-2',
      'secondary_region_name' : 'us-east-2',
      'workshop'              : '300 - Testing for Resiliency',
      'cfn_region'            : 'us-east-2',
      'cfn_bucket'            : 'aws-well-architected-labs-ohio',
      'folder'                : 'Reliability/',
      'boot_bucket'           : 'aws-well-architected-labs-ohio',
      'boot_prefix'           : 'Reliability/',
      'boot_object'           : 'bootstrap300Reliability.sh',
      'websiteimage'          : 'https://s3.us-east-2.amazonaws.com/arc327-well-architected-for-reliability/Cirque_of_the_Towers.jpg'
    }
    
There is considerable "shared knowledge" between the state machine functions that is all hard-coded, like stack names.

The state machine passes state of stacks between functions to indicate if the stack has been deployed or not. These take the form of a nested JSON object:

    {
      'vpc' : {
        'stackname' : 'ResiliencyVPC',
        'status'    : 'CREATE_COMPLETE'
      }
    }
      
There will be a status for each stack as they deploy to prevent any attempt to deploy when a previous stack is either not present, or not complete. The applications all have the relevant nested stacks passed in the debug event, so you need to ensure you test them in the same order that the state machine deploys them within.

The Troubleshooting guide has additional details on how to debug the function when it is executing in AWS Lambda.

## Building and Uploading the Web Application

The web application is written in the Go programming langauage. You must have the go language installed where you are building the executable. There is also a makefile to build this application. You can also upload the executable using the same method as follows:

    % cd go
    % make
    % aws s3 cp FragileWebApp s3://<S3 bucket>/<diretory prefix>/FragileWebapp

The web application is very fragile in that it will always write an entry on every hit it receives. This will cause the application to be tightly coupled to the database (a violation of the AWS Well-Architected Reliability Pillar!). However, it is small and easy to understand and deploy.

## The Bootstrapping Script

The bootstrapping script assumes 4 things:

1. The name of the SQL to run to create the table used is hardcoded to "createIPTable.sql"
1. The password is hardcoded to match the hardcoded password in the CloudFormation template that creates the RDS instance.
1. The name of the Executable is "FragileWebApp"

The bucket location(s) should really be passed as a 5th and/or 6th command line variable and is marked as TODOs.

## The SQL in the Bootstrapping Script

The database and table are hard coded to match what the executable is expecting. There are also commands required to support AWS Database Migration Service (DMS) replication to set the retention configuration of the binlog, and add permisssions for the user that AWS DMS uses.

## Deploying the State Machine

The AWS Step Functions state machine must be deployed in the same region as the bucket where you uploaded the zipped code. This is because the Lambda functions can only be created in the same AWS Region as the location of the bucket. In addition, the Lambda functions must be in the same AWS Region as the state machine in order for the state machine to invoke it.

## CloudFormation templates

The CloudFomation templates and the bootstrapping scripts need to be deployed in the same region. This is not a limitation, except for the fact that the parameters built in the Lambda function make this assumption. Also, the Amazon Machine Images (AMIs) for the web servers are only mapped into us-east-2 (Ohio) and us-west-2 (Oregon).

