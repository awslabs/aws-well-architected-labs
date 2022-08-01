---
title: "Structure of a custom lens - Questions"
date: 2020-04-24T11:16:09-04:00
chapter: false
weight: 2
pre: "<b>2. </b>"
---


### Questions in Custom Pillars:

After pillars been defined, we start to work on related key items we want to focus in each pillar. We aggregated different options for a best practices, and design the logic behind the question, to identify if that was a potential high risk or in medium level. 

We go to the first custom pillar - *Operating Readiness*.

From operation aspect, we should spend time collecting feedback from key stakeholders who hold an operational role in the organization, like cloud operators, DevOps engineers, Managers and Tech lead, etc. If these domain sponsors indicated a valid backup for DynamoDB table is extremely important, we should start from this as a check point. From operational excellence perspective, we will deep dive into the flow related to this table backup. 
- Do we have backup? 
- Do we have standard process of backup?
- Do we have a validation process of each backup?
- Do we ever test it, or recover from a backup?

Then we aggregate all the related questions into a bigger title:

#### How to backup your data in DynamoDB table?

Follow the JSON syntex, we assigned an unique id to this question, and put the question sentense into **Title** of **"question"** in JSON structure.

```
...
         "questions":[
            {
               "id":"ddbops1",
               "title":"How do you backup DynamoDB tables?",
               "description":"With proper backup process, you will be able to prevent unexpected data lost.",
               "choices":[

```

Reference on [Amazon DynamoDB Developer Guide](https://docs.aws.amazon.com/amazondynamodb/latest/developerguide/), we found a clear guidance on [Backing Up a DynamoDB Table](https://docs.aws.amazon.com/amazondynamodb/latest/developerguide/Backup.Tutorial.html) providing two options: *Create a table backup from Console* and *Create a Table backup from CLI*. These two options were both require manual process. 
So here we have one "Choice" been appended:

`Manually trigger Amazon DynamoDB Backup process` - *Means backup process been handled by it's native backup feature, a full backup.*

To improve the operating process as a long term goal, also aligned with the Design Principle - "Perform operations as code" (AWS Well-Architected Framework, Operational Excellence Pillar), we start to collect more possible options on backup automation. 
We found that DynamoDB natively support the Point-in-time recovery (PITR) feature, it provides continuous backups for DynamoDB table data. Also AWS Backup is another fully-managed service that can automate the backup process. Thus, we have two more "Choices":

`Enable Amazon DynamoDB PITR Feature` - *A native support feature, but it provide point-in-time restore.*

`Use AWS Backup for Amazon DynamoDB tables` - *Leverage another service, which might aligned with broader backup purpose and multiple data sources.*

In some cases, we found the operating team could use [Amazon DynamoDB Data Export](https://docs.aws.amazon.com/amazondynamodb/latest/developerguide/DataExport.html) feature to have a full duplication of the table. This documentation also gives us an insight that this can also be achieved with direct API call or table scan. We can append a new choice to cover the option to export and store the backup into preferred storage media.

`Export DynamoDB to other storage media` 

After researching and collecting all the relevant options for this question, the structure for this question now will looks like this:

```
.....
                   "choices": [
                        {
                            "id": "ddbops_1",
                            "title": "Manually trigger Amazon DynamoDB Backup process",
                            ...
                            },
                            "improvementPlan": {
                                "displayText": "This is text that will be shown for improvement of this choice."
                            }
                        },
                        {
                            "id": "ddbops_2",
                            "title": "Enable Amazon DynamoDB PITR Feature",
                            ...
                        },
                        {
                            "id": "ddbops_3",
                            "title": "Use AWS Backup for Amazon DynamoDB tables",
                            ...
                        },
                        {
                            "id": "ddbops_4",
                            "title": "Export DynamoDB to other storage media",
                            ...
                        }

                        ....

```

Here, you can see we assigned an ***unique choice id*** for each choice in this question. The id cannot be duplicated in this whole lens structure. 

In next step we will explain how to setup the logic and risk level for AWS Well-Architected Tool. 

In some case, we need to setup an default option if there is none of options been selected. 

```
                        {
                            "id": "choice5",
                            "title": "None of Above",
                            ...
                        }
```

{{< prev_next_button link_prev_url="../1_ddb_config_pillars_and_bps/" link_next_url="../3_ddb_config_options_risks/" />}}
