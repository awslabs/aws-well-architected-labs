---
title: "Structure of a custom lens - Pillars, Questions and Best Practices"
date: 2020-04-24T11:16:09-04:00
chapter: false
weight: 1
pre: "<b>1. </b>"
---

### Get Started:

Custom lenses are defined using a specific JSON format. To ensure you follow the required data structure, you have the option to download a template JSON file from the AWS Well-Architected Tool in the AWS console.

### Download Custom Lenses Template:
1. Sign in to the AWS Management Console and open the [AWS Well-Architected Tool console.](https://console.aws.amazon.com/wellarchitected/)
2. In the left navigation pane, choose `Custom lenses`.
3. Choose `Create custom lens`.
4. Choose `Download file` to download the JSON template file.

### Lens Structure

You can use the JSON template file as the basis for your custom lens as it defines the basic structure for the pillars, questions, best practices and improvement plan. For more detail please read the [Lens format specification](https://docs.aws.amazon.com/wellarchitected/latest/userguide/lenses-format-specification.html) documentation.

```
- Pillars
   +- Questions
        +- Choices
```

The first thing to consider when drafting a custom lens is how many **"pillars"** it will cover. Depending on your requirements, you can include one or more pillars, each containing one or more questions.

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
As an example, we are going to use the best practices for configuring an Amazon DynamoDB Database for our custom lens and are going to use the following configuration categories as our ***custom pillars***:
* *Operating Readiness*
* *Security*
* *Application Performance*
* *Cost Model Optimization*

Using these categories as our custom pillars, the JSON structure now looks like this:
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

After we have pillars defined, we move on to the next step in the lab which will cover question creation in the lens. 

{{< prev_next_button link_prev_url="../" link_next_url="../2_ddb_config_questions/" />}}
