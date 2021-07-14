---
title: "Create Custom Data Collection Module (Optional)"
date: 2020-10-21T11:16:08-04:00
chapter: false
weight: 4
pre: "<b>4. </b>"
---

### Example Module Explanation
You can use this template to build your own data collection modules. In the next step we will be providing you with modules you can add to your template. These are sets of Infrastructure as code that have all the resources you need and is easy to add to your template. 

1.  **Download CloudFormation template** by clicking [here.](/Cost/300_Optimization_Data_Collection/Code/lambda_s3_athen_cf_template.yaml) This will be the foundation of the rest of this section and can be reused to build out the modules.

2. The first section we have **Parameters** which can be passed in from the main template. These are good for roles you will be using for reusable resources like the Amazon S3 Bucket or IAM Roles. There are also **Outputs** which  declares output values that you can import into other stacks in the template. 


3. To collect the data we have a lambda function which uses a role to have permissions for the resources its going to be utilizing.  By default the role can currently: 
    * Assume Management Role we setup
    * Access and place a file in S3 
    * Start a Glue Crawler

These are all needed actions for the basic lambda. If you need to add more to access the service you are collecting data from you need checkout documentation [here](https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-resource-iam-role.html) and add to the policy. 

4. The lambda function we have at the moment gives the base for your python code. In this we have an example of collecting S3 Object sizes. The key elements are:
* Collecting the data and storing them in a temporary json file (/tmp/file.json)
* Uploading the file into a partitioned folder in S3 (based on year and month)
* Starting the crawler to create/update the Athena Table

5. There is a Glue Crawler which is the one we triggered in the Lambda which reads from your S3 bucket and creates an Athena table based on the data. It used the Glue Role we made in the template.

6. To trigger the Lambda we use a Cloudwatch event which runs on a pre-defined schedule. You can find more options for scheduling [here](https://docs.aws.amazon.com/AmazonCloudWatch/latest/events/ScheduledEvents.html)

7. There is an example of a saved Athena query. This is useful if you know that you will be using the same query often and want to have it available.  

## Using the module in your Main CloudFormation Template

Once you have your module created you can add it to your CloudFormation Template from the first stage.  

1. Save this file in your own S3 bucket which will be referred to as your **Code Bucket** in your Cost Optimization account where your template is deployed.  

2. Once uploaded you can see your **Object URL** on the properties of the object. This will be used in the **TemplateURL** in the next step.
![Images/module_template_object_url.png](/Cost/300_Optimization_Data_Collection/Images/module_template_object_url.png)

3. In your Main file you can add a new CloudFormation Stack resource. In the example below you can see:
* Name of the stack
* An example link of the S3 object - Update with your url
* The Parameters needed for the template


      DataStack:
      Type: AWS::CloudFormation::Stack
      Properties:
        TemplateURL: https://s3-eu-west-1.amazonaws.com/<mybucket>/lambda_s3_athen_cf_template.yaml
        TimeoutInMinutes: 2
        Parameters:
          DestinationBucket: !Ref S3Bucket
          GlueRoleARN: !GetAtt GlueRole.Arn
          ManagementAccountRole: !Sub "arn:aws:iam::${ManagementAccountID}:role/${ManagementAccountRole}"
          
          
4. Now you have added your new module you can update your CloudFormation stack in the console by selecting your stack and clicking **Update**
![Images/Update_CF.png](/Cost/300_Optimization_Data_Collection/Images/Update_CF.png)


{{% notice note %}}
NOTE: If you would like more information on AWS CloudFormation checkout there [website](https://docs.aws.amazon.com/cloudformation/index.html)
{{% /notice %}}


{{< prev_next_button link_prev_url="../3_Data_Collection_Cloud_Formation_Modules/" link_next_url="../5_teardown/" />}}
