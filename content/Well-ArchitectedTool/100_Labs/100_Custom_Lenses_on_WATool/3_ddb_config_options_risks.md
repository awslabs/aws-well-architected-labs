---
title: "Structure of a custom lens - Risk and Rule"
date: 2020-04-24T11:16:09-04:00
chapter: false
weight: 3
pre: "<b>3. </b>"
---

### Choices for question and the log for Risk level:

In the previous step, we setup a question and the best pracitices. We collected all the necessary resources like developer guide and blog posts as guidance reference. Our next step is to create a logical rule for these options to indicate the risk level if the best practices was not applied.


#### Rule Collections

Referencing the [Custom Lenses Format Specification](https://docs.aws.amazon.com/wellarchitected/latest/userguide/lenses-format-specification.html), we can see all the **"riskRules"** are combinations of **"choice id"** and **operators** - 

As a result, we list out all the options defined in the previous step as well as the risk level we want the operating team to be aware of. We also need to assign a unique **"choice id"** for each best practice option.

||Choice|Risk Level if not applied.|Choices[]["id"]|
| ----------- | ----------- | ----------- | ----------- |
|1|`Manually trigger Amazon DynamoDB Backup process`|High|ddbops1_1|
|2|`Enable Amazon DynamoDB PITR Feature`|Medium, if covered by other backup process.|ddbops1_2|
|3|`Use AWS Backup for Amazon DynamoDB tabls`|Medium, if covered by other backup process.|ddbops1_3|
|4|`Export DynamoDB to other storage media`|Medium, if covered by other backup process.|ddbops1_4|
|5|`None of Above`|High|ddbops1_5|

#### Rule Conditions:

We now need to design our rule logic for this question:

* If every choice in the questions must be applied in order to result in **"NO_RISK"**, the conditional rule must include all options. The **"AND"** operator **"&&"** need to be applied.

```
	{	
     "condition":"ddbops1_1 && ddbops1_2 && ddbops1_3 && ddbops1_4",
     "risk":"NO_RISK"
     }
```

For some cases, one of the options being applied will be good enough. We can design our rule by using **"OR"** operator (**"||"**):

```
	{	
     "condition":"ddbops1_1 || ddbops1_2 || ddbops1_3 || ddbops1_4",
     "risk":"NO_RISK"
     }
```

* When we want certain rules to be higher priority, use the "OR" operator to cover more cases. 

Usually the "None of Above" answer is one frequent option of question we can see. Here if "None of Above" (ddbops1_5) was checked, we should set it as "HIGH_RISK".

```

	{ 
	"condition":"(!ddbops1_1) || ddbops1_5",
    "risk":"HIGH_RISK"
	}
```
#### Aggregate into one rule set

After we listed out all the different risk conditions, we can put it all together and go to next step. 

```
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

```


{{< prev_next_button link_prev_url="../2_ddb_config_questions/" link_next_url="../4_ddb_config_publish/" />}}
