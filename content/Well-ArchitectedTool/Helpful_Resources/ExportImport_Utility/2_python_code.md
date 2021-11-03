---
title: "Python Code"
date: 2021-05-19T11:16:09-04:00
chapter: false
weight: 2
pre: "<b>2. </b>"
---

## exportImportWAFR.py
The purpose of this python script is to either generate a JSON file that contains the results of a Well-Architected review or import the contents of a JSON file into the [Well-Architected Tool.](https://aws.amazon.com/well-architected-tool/) This would allow you to create a backup copy of your workload properties to use in another system or to interchange with others if the cannot access your AWS environment.

This utility was created using the the [AWS SDK for Python (Boto3)](https://aws.amazon.com/sdk-for-python/). This file assumes you have already setup your AWS credential file, and uses the default profile for all interactions.  

{{% notice warning %}}
There is error checking for most of the various API calls, but the code should **not** be considered production ready. Please review before implementing in your environment.
{{% /notice %}}


## Parameters
```
usage: exportImportWAFR.py [-h] (--exportWorkload | --importWorkload) [-p PROFILE] [-r REGION] [-w WORKLOADID] -f FILENAME [-v]

This utility has two options to run:
------------------------------------
1) Export - Export the contents of a workload from the Well-Architected tool
2) Import - Create a new workload from the JSON export file generated in export


optional arguments:
  -h, --help                              show this help message and exit
  --exportWorkload                        export the workload to a file
  --importWorkload                        import the workload from a file
  -p PROFILE, --profile PROFILE           AWS CLI Profile Name
  -r REGION, --region REGION              From Region Name. Example: us-east-1
  -w WORKLOADID, --workloadid WORKLOADID  Workload Id to use instead of creating a TEMP workload
  -f FILENAME, --fileName FILENAME        FileName to export JSON file to
  -v, --debug                             print debug messages to stderr
```

## Limitations
1. You can export any version of a Well-Architected review, but you can only import reviews that are the latest version supported by the tool

### Python Code {#duplicateWAFR_Code}
[Link to download the code](/watool/utilities/Code/exportImportWAFR.py)

{{< readfile file="/static/watool/utilities/Code/exportImportWAFR.py" code="true" lang="python" highlightopts="linenos=table">}}

{{< prev_next_button link_prev_url="../1_configure_env/" link_next_url="../3_executing/" />}}
