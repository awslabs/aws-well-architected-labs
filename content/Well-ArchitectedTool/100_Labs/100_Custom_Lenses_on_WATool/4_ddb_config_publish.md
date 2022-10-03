---
title: "Publish my Custom Lens on WA Tool"
date: 2020-04-24T11:16:09-04:00
chapter: false
weight: 4
pre: "<b>4. </b>"
---


### Create a Custom Lens

In previous steps, we demonstrated how to draft a question and options, collect and link the reference resource to each best practice option and create conditional logic for risk level. We will repeat this process to cover all the questions in the pillar and then again for all the pillars we want to include in our custom lens.

#### Upload to AWS Console and Publish
Now we have the full scope of the custom lens in JSON format. It's time to publish this custom lens into the AWS Well-Architected Tool.

* Open AWS Console > Well-Architected Tool > Custom Lenses

* Click "**Create Custom Lens**" > upload the finalized JSON we produced from step 3.

* For more detail on best practices for publishing a custom lens, please refer to [this blog](https://aws.amazon.com/blogs/aws/well-architected-custom-lenses-internal-best-practices/).

* After you have published your custom lens, [create a workload](../../100_walkthrough_of_the_well-architected_tool/2_create_workload/) on the tool, then you can select the custom lens for your workload.

* A workload with custom lens review:

![create-a-workload-with-custom-lens](/watool/100_Custom_Lenses_on_WATool/images/4_1_create_workload_with_custom_lens.png)


#### Test the **riskRules** and check all the information is ready

* After we created a custom lens and workload review, we can start to check if the **riskRules** work as expected.

* We want to make sure all the **"helpfulResource"** is providing clear and accurate guidance to reviewers. 

* In this example we see the option indicating "Amazon DynamoDB Point-In-Time Recovery feature". 
It also helps to gain readability if we put a brief text on the **"displayText"** attribute. 
The **"url"** can point to an external page like the service documentation or the developer guide.

```
"choices": [
	{
     "id":"ddbops1_2",
     "title":"Enable DynamoDB PITR",
     "description":"Some helpful choice description",
     "helpfulResource":{
        "displayText":"Point-in-time recovery (PITR) provides continuous backups of your DynamoDB table data. When enabled, DynamoDB maintains incremental backups of your table for the last 35 days until you explicitly turn it off.",
        "url":"https://aws.amazon.com/dynamodb/pitr/"
     },
     "improvementPlan":{
        "displayText":"Enable Dynamodb PITR",
        "url":"https://aws.amazon.com/dynamodb/pitr/"
     }
	},
	{
		...
	}
]
```

* Assuming all the resource attributes are ready in the JSON, it will build the linkage between the review discussion to recommended best practices, also give a real time detailed explanations, and provide a reference link. 

![check-best-practices](/watool/100_Custom_Lenses_on_WATool/images/4_2_check_best_practices_info.jpg)

#### JSON Example:

* With the previous steps completed, now we have a full structure for our first question, including  **pillar id**, **pillar name**, **question id**, **question description**, **choice id**, and all the related resources. The JSON structure for AWS Well-Architected Tool will looks like this:

```
{
   "schemaVersion":"2021-11-01",
   "name":"DynamoDB Best Practice Lens",
   "description":"Best practices for optimization your DynamoDB",
   "pillars":[
        {
         "id":"DDBOPS",
         "name":"Operational Excellence",
         "questions":[
            {
               "id":"ddbops1",
               "title":"How do you backup DynamoDB tables?",
               "description":"With proper backup process, you will be able to prevent unexpected data lost.",
               "choices":[
                  {
                     "id":"ddbops1_1",
                     "title":"Manually trigger Amazon DynamoDB Backup process",
                     "description":"Either use AWS Console or CLI to trigger a table backup.",
                     "helpfulResource":{
                        "displayText":"Amazon DynamoDB supports stand-alone on-demand backup and restores features. Those features are available to you independent of whether you use AWS Backup.",
                        "url":"https://docs.aws.amazon.com/amazondynamodb/latest/developerguide/BackupRestore.html"
                     },
                     "improvementPlan":{
                        "displayText":"Have a regular process to trigger backup process on Amazon DynamoDB",
                        "url":"https://docs.aws.amazon.com/amazondynamodb/latest/developerguide/BackupRestore.html"
                     }
                  },
                  {
                     "id":"ddbops1_2",
                     "title":"Enable DynamoDB PITR",
                     "description":"Some helpful choice description",
                     "helpfulResource":{
                        "displayText":"Point-in-time recovery (PITR) provides continuous backups of your DynamoDB table data. When enabled, DynamoDB maintains incremental backups of your table for the last 35 days until you explicitly turn it off.",
                        "url":"https://aws.amazon.com/dynamodb/pitr/"

                     },
                     "improvementPlan":{
                        "displayText":"Enable Dynamodb PITR",
                        "url":"https://aws.amazon.com/dynamodb/pitr/"
                     }
                  },
                  {
                     "id":"ddbops1_3",
                     "title":"Use AWS Backup for DynamoDB tables",
                     "description":"Some helpful choice description",
                     "helpfulResource":{
                        "displayText":"AWS Backup is a fully-managed service that makes it easy to centralize and automate data protection across AWS services, in the cloud, and on premises.",
                        "url":"https://docs.aws.amazon.com/aws-backup/latest/devguide/about-backup-plans.html"
                     },
                     "improvementPlan":{
                        "displayText":"Use AWS Backup"
                     }
                  },
                  {
                     "id":"ddbops1_4",
                     "title":"Export DynamoDB to other storage media",
                     "description":"Some helpful choice description",
                     "helpfulResource":{
                        "displayText":"Using DynamoDB table export, you can export data from an Amazon DynamoDB table from any time within your point-in-time recovery window to an Amazon S3 bucket.",
                        "url":"https://docs.aws.amazon.com/amazondynamodb/latest/developerguide/DataExport.html"
                     },
                     "improvementPlan":{
                        "displayText":"Export Dynamodb To S3"
                     }
                  },
                  {
                     "id":"ddbops1_5",
                     "title":"None of above",
                     "description":"Some helpful choice description",
                     "helpfulResource":{
                        "displayText":"-"
                     },
                     "improvementPlan":{
                        "displayText":"Setup backup process"
                     }
                  }
               ],
               "riskRules":[
                  {
                     "condition":"ddbops1_1 && ddbops1_2 && ddbops1_3 && ddbops1_4",
                     "risk":"NO_RISK"
                  },
                  {
                     "condition":"(!ddbops1_1) || ddbops1_5",
                     "risk":"HIGH_RISK"
                  },
                  {
                     "condition":"default",
                     "risk":"MEDIUM_RISK"
                  }
               ]
            }
         }]
      }
   ]
}
```

#### Sample JSON files ####
And for the 
[Custom lenses sample - Dynamodb Configuration Check](https://github.com/aws-samples/custom-lens-wa-sample/tree/main/dynamodb), please check the latest update in aws-samples [repository](https://github.com/aws-samples/custom-lens-wa-sample/). 


{{< prev_next_button link_prev_url="../3_ddb_config_options_risks/" link_next_url="../5_ddb_config_share_and_update/" />}}
