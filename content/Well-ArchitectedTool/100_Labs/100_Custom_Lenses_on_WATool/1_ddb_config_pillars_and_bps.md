---
title: "Structure of a custom lenses - Pillars, Questions, and Best Practices"
date: 2020-04-24T11:16:09-04:00
chapter: false
weight: 1
pre: "<b>1. </b>"
---


### Prerequisites:

Read through [this blog](
https://aws.amazon.com/blogs/aws/well-architected-custom-lenses-internal-best-practices/), it has step-by-step instructions as:
1. Download a JSON template from AWS Console - Well-Architected Tool.
2. Create a Custom lens and publish it.
3. Create a workload with a Custom lens. 

### Download Custom Lenses Template:
1. Sign in to the AWS Management Console and open the AWS Well-Architected Tool console at https://console.aws.amazon.com/wellarchitected/.
2. In the left navigation pane, choose Custom lenses.
3. Choose Create custom lens.
4. Choose Download file to download the JSON template file.

### Get Started:

In this lab, we will explain how to draft and create a custom lens hierarchically. Each custom lens should be aligned with structure of AWS Well-Architected Tool.

```
- Pillars
   +- Questions
        +- Choices
```

The first thing to consider when drafting a custom lens is how many **"pillars"** it will cover. According to the JSON template, there will be pillars and questions within each pillar.

As shown in the map hierarchy, each question includes **“choices”** and **“riskRules”** that correspond directly to each area of best practices we would like to cover.

```
{
    "schemaVersion": "2021-11-01",
    "name": "My Test Lens",
    "description": "This is a description of my test lens.",
    "pillars": [
        {
            "id": "pillar_red",
            "name": "Red Pillar",
            "questions": [
                {
                    "id": "pillar_1_q1",
                    "title": "How do you get started with this pillar?",
                    "description": "Optional description.",
                    "choices": [
                        {
                            "id": "choice1",
                            "title": "Best practice #1",
                            "helpfulResource": {
                                "displayText": "This is helpful text for the first choice.",
                                "url": "https://aws.amazon.com"
                            },
                            "improvementPlan": {
                                "displayText": "This is text that will be shown for improvement of this choice."
                            }
                        },
                        {
                            "id": "choice2",
                            "title": "Best practice #2",
                            ...
                        }
                    ],
                    "riskRules": [
                        {
                            "condition": "choice1 && choice2",
                            "risk": "NO_RISK"
                        },
                        {
                            "condition": "choice1 && !choice2",
                            "risk": "MEDIUM_RISK"
                        },
                        {
                            "condition": "default",
                            "risk": "HIGH_RISK"
                        }
                    ]
                }
            ]
            ...
        },
        ...
    ]
}
```

Take Amazon DynamoDB configuration as an example, we want to build a configuration standard review with following ***custom pillars***(example) :
* *Operating Readiness*
* *Security* 
* *Application Performance*
* *Cost Model Optimization* 

Under this definition, the JSON structure now looks like this:
```
{
    "schemaVersion": "2021-11-01",
    "name": "My Test Lens for organization DynamoDB Check",
    "description": "This is a description of my test lens.",
    "pillars": [
        {
            "id": "pillar_oper",
            "name": "Operating Readiness",
            "questions": [
                {...
                    }
            ]
            ...
        },
        {
            "id": "pillar_security",
            "name": "Security",
            "questions": [
                {...
                    }
            ]
            ...
        },
        ...
    ]
}
```

After we have our pillars defined, we move on to next level in the pillar. 


{{< prev_next_button link_prev_url="../" link_next_url="../2_ddb_config_questions/" />}}
