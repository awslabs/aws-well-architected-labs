---
title: "Structure of a custom lens - Questions"
date: 2020-04-24T11:16:09-04:00
chapter: false
weight: 2
pre: "<b>2. </b>"
---


### Questions in Custom Pillars:

After our pillars have been defined, we start to work on related key items and best practices we want to focus in each pillar. We aggregate different options for a best practices, and design the logic behind the question, to identify if not selecting that option would result in a potential high risk or medium risk issue.

We go to the first custom pillar - *Operating Readiness*.

From operation aspect, we should spend time collecting feedback from key stakeholders who hold an operational role in the organization, like cloud operators, DevOps engineers, managers and tech leads. If these domain sponsors indicated a valid backup for DynamoDB table is extremely important, we should start from this as a check point. From operational excellence perspective, we will deep dive into the flow related to this table backup.
- Do we have backup?
- Do we have standard process of backup?
- Do we have a validation process of each backup?
- Do we ever test it, or recover from a backup?

Then we aggregate all the related questions and information into a bigger question:

#### How do you backup your DynamoDB tables?

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

After reading the [Amazon DynamoDB Developer Guide](https://docs.aws.amazon.com/amazondynamodb/latest/developerguide/), we found clear guidance on [Backing Up a DynamoDB Table](https://docs.aws.amazon.com/amazondynamodb/latest/developerguide/Backup.Tutorial.html) providing two options: *Create a table backup from Console* and *Create a Table backup from CLI*. These two options both require manual processes.

So now we can append one "Choice":

`Manually trigger Amazon DynamoDB Backup process` - *Means the backup process been handled by it's native backup feature, a full backup.*

To improve the operating process as a long term goal, and to align with the design principle - "Perform operations as code" (AWS Well-Architected Framework, Operational Excellence Pillar), we start to collect more possible options on backup automation.

We found that DynamoDB natively supports the Point-in-time recovery (PITR) feature, and provides continuous backups for DynamoDB table data. AWS Backup is another fully-managed service that can automate the backup process. Thus, we have two more "Choices":

`Enable Amazon DynamoDB PITR Feature` - *A native support feature, but it provides point-in-time restore.*

`Use AWS Backup for Amazon DynamoDB tables` - *Leverage another service, which might aligned with broader backup purpose and multiple data sources.*

In some cases, we found the operating team could use the [Amazon DynamoDB Data Export](https://docs.aws.amazon.com/amazondynamodb/latest/developerguide/DataExport.html) feature to have full duplication of the table. This documentation also gives us an insight that this can also be achieved with a direct API call or table scan. We can append a new choice to cover the option to export and store the backup into our preferred storage media.

`Export DynamoDB to other storage media`

After researching and collecting all the relevant options for this question, the structure for this question will now look like this:

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

Here you can see we assigned a ***unique choice id*** for each choice in this question. The id cannot be duplicated in this whole lens data structure. 

In next step we will explain how to setup the conditional logic for the risk level for AWS Well-Architected Tool.

We need to setup a default option if none of the options have been selected. Adding a choice with a suffix of _no will act as a None of these choice for the question.

```
                        {
                            "id": "choice5_no",
                            "title": "None of Above",
                            ...
                        }
```

{{< prev_next_button link_prev_url="../1_ddb_config_pillars_and_bps/" link_next_url="../3_ddb_config_options_risks/" />}}
