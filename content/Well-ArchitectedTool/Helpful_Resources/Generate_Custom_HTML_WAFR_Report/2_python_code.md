---
title: "Python Code"
date: 2021-04-18T11:16:09-04:00
chapter: false
weight: 2
pre: "<b>2. </b>"
---


## Python version using Boto3 Library {#python}
This utility was created using the the [AWS SDK for Python (Boto3)](https://aws.amazon.com/sdk-for-python/). This file assumes you have already setup your AWS credential file, and uses the default profile for all interactions.  

The code has been broken up into functions which accept various parameters, so you can pull those out and place them into integration points in your environment. There is error checking for most of the various API calls, but the code should not be considered production ready. Please review before implementing in your environment.

## Parameters
```
usage: generateWAFReport.py [-h] [--profile PROFILE] --workloadid WORKLOADID [--region REGION]

optional arguments:
  -h, --help                show this help message and exit
  --profile PROFILE         AWS CLI Profile Name
  --workloadid WORKLOADID   WorkloadID. Example: 1e5d148ab9744e98343cc9c677a34682
  --region REGION           From Region Name. Example: us-east-1

```

## Limitations
1. The HTML generated is staticly defined in the code and not based on a templating language of any kind.


### Python Code {#duplicateWAFR_Code}
[Link to download the code](/watool/utilities/Code/generateWAFReport.py)

{{< readfile file="/static/watool/utilities/Code/generateWAFReport.py" code="true" lang="python" >}}
