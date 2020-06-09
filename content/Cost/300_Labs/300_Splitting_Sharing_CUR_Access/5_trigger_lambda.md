---
title: "Trigger the Lambda When a CUR is Delivered"
date: 2020-04-24T11:16:09-04:00
chapter: false
pre: "<b>5. </b>"
weight: 5
---

It is assumed that you have completed 300_Automated_CUR_Updates_and_Ingestion, so there is an existing Lambda function that is being executed when a new CUR file is delivered.  We will add code into this setup to trigger the new Lambda function.

1 - Go to the CloudFormation service Dashboard

2 - Select the current stack which updates the Glue database

3 - Download the current template (crawler-cfn.yml file), and save this for later (if Teardown is required)

4 - Open the template up in a text editor of your choice

5 - A sample crawler file is below:  
[./Code/crawler-cfn.md]({{< ref "Code/crawler-cfn.md" >}})

6 - Update the ** AWSCURCrawlerLambdaExecutor** IAM role section, inside the PolicyName **AWSCURCrawlerLambdaExecutor** section:

**Add** the following Action:
```
    'lambda:InvokeFunction'
```

**Edit the following line**, and **add** the following resource
```
    - 'arn:aws:lambda:<region>:<accountID>:function:SubAcctSplit'
```                  

7 - Make the following amendments to the **AWSCURInitializer** Lambda function section, inside the **else** statement after the glue section:

```
    var lambda = new AWS.Lambda();

    var params = {
      FunctionName: 'SubAcctSplit'
    };

    lambda.invoke(params, function(err, data) {
      if (err) console.log(err, err.stack); // an error occurred
      else     console.log(data);           // successful response
    });
```

8 - Save the new template file

9 - In the CloudFormation console **update** the stack

10 - Replace the current template with the new one, and upload your modified template

11 - After the stack has successfully updated, you can test the function

12 - Go to the S3 service dashboard, navigate to the **source bucket** and folder containing the current months original master/payer CUR file

13 - Download the CUR file, and delete the object from the bucket

14 - Re-upload the current CUR file back into its bucket

15 - Navigate to the **output bucket and folder** for the current month

16 - Check the **Last modified** time stamp on the object/s is/are the current time, and check that it has the correct **Grantees** in the permissions

Setup is now complete for the payer account. When new CUR files are delivered, it will execute the Athena queries and extract the required data for the current month, and output it to the required S3 folder with the required permissions.  
