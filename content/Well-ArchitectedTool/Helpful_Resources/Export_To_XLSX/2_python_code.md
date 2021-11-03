---
title: "Python Code"
date: 2021-05-04T11:16:09-04:00
chapter: false
weight: 2
pre: "<b>2. </b>"
---

## exportAnswersToXLSX.py
The purpose of this python script is to generate a XLSX template file that contains all of the questions, best practices, and improvement plans to conduct a review. This spreadsheet can be used to prepare for a AWS Well-Architected review by collecting information from teams before the workload review is entered into the tool. This also allow you perform a review offline if you are working in a AWS region that does not support the [Well-Architected Tool.](https://aws.amazon.com/well-architected-tool/)

In addition to generating the XLSX template, you can also use this script to export the contents of an existing Well-Architected Workload in a spreadsheet. This can be useful for printing and sharing with feedback sources that do not have access to the AWS Well-Architected tool.

This utility was created using the the [AWS SDK for Python (Boto3)](https://aws.amazon.com/sdk-for-python/). This file assumes you have already setup your AWS credential file, and uses the default profile for all interactions.  

{{% notice warning %}}
There is error checking for most of the various API calls, but the code should **not** be considered production ready. Please review before implementing in your environment.
{{% /notice %}}


## Parameters
```
usage: exportAnswersToXLSX.py [-h] [-p PROFILE] [-r REGION] [-w WORKLOADID] [-k] -f FILENAME [-v]

This utility has two options to run:
------------------------------------
1) If you provide a workloadid, this will gather all of the answers across all Well-Architected Lenss and export them to a spreadsheet.
2) If you do not provide a workloadid, the utility will generate a TEMP workload and auto-answer every question. It will then generate a spreadsheet with all of the questions, best practices, and even the improvement plan links for each.


optional arguments:
  -h, --help                              show this help message and exit
  -p PROFILE, --profile PROFILE           AWS CLI Profile Name
  -r REGION, --region REGION              From Region Name. Example: us-east-1
  -w WORKLOADID, --workloadid WORKLOADID  Workload Id to use instead of creating a TEMP workload
  -k, --keeptempworkload                  If you want to keep the TEMP workload created at the end of the export
  -f FILENAME, --fileName FILENAME        FileName to export XLSX (REQUIRED)
  -v, --debug                             print debug messages to stderr

```

## Limitations
1. None at this time

### Python Code {#duplicateWAFR_Code}
[Link to download the code](/watool/utilities/Code/exportAnswersToXLSX.py)

{{< readfile file="/static/watool/utilities/Code/exportAnswersToXLSX.py" code="true" lang="python" highlightopts="linenos=table">}}

{{< prev_next_button link_prev_url="../1_configure_env/" link_next_url="../3_executing/" />}}
