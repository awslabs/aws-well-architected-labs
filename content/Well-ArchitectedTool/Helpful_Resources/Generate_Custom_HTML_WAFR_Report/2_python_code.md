---
title: "Python Code"
date: 2021-04-18T11:16:09-04:00
chapter: false
weight: 2
pre: "<b>2. </b>"
---

## generateWAFReport.py
The purpose of this python script is to generate a HTML file that displays some basic Well-Architected Workload information as well as each best practice that was unchecked for any question that has been answered. As part of the report generation, it will also incorporate the specific improvement plan content and display it in-line with each unchecked best practice.

This utility was created using the the [AWS SDK for Python (Boto3)](https://aws.amazon.com/sdk-for-python/). This file assumes you have already setup your AWS credential file, and uses the default profile for all interactions.  

{{% notice warning %}}
There is error checking for most of the various API calls, but the code should **not** be considered production ready. Please review before implementing in your environment.
{{% /notice %}}


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
1. The HTML generated is statically defined in the code and not based on a templating language of any kind.
1. The report will only generate for the base wellarchitected framework, it does not support lenses at this time.

### Python Code {#duplicateWAFR_Code}
[Link to download the code](/watool/utilities/Code/generateWAFReport.py)

{{< readfile file="/static/watool/utilities/Code/generateWAFReport.py" code="true" lang="python" >}}

{{< prev_next_button link_prev_url="../1_configure_env/" link_next_url="../3_executing/" />}}
