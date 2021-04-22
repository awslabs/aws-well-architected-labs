---
title: "Python Code"
date: 2021-04-18T11:16:09-04:00
chapter: false
weight: 2
pre: "<b>2. </b>"
---


## Python version using Boto3 Library {#python}
This utility was created using the the [AWS SDK for Python (Boto3)](https://aws.amazon.com/sdk-for-python/). This file assumes you have already setup your AWS credential file, and uses the default profile for all interactions.  

{{% notice warning %}}
There is error checking for most of the various API calls, but the code should **not** be considered production ready. Please review before implementing in your environment.
{{% /notice %}}

## Parameters
```
usage: duplicateWAFR.py [-h] [--fromaccount FROMACCOUNT] [--toaccount TOACCOUNT] --workloadid WORKLOADID [--fromregion FROMREGION] [--toregion TOREGION]

optional arguments:
  -h, --help                show this help message and exit
  --fromaccount FROMACCOUNT AWS CLI Profile Name or will use the default session for the shell
  --toaccount TOACCOUNT     AWS CLI Profile Name or will use the default session for the shell
  --workloadid WORKLOADID   WorkloadID. Example: 1e5d148ab9744e98343cc9c677a34682
  --fromregion FROMREGION   From Region Name. Example: us-east-1
  --toregion TOREGION       To Region Name. Example: us-east-2
```

## Limitations
1. The code has been tested against multiple accounts, but it does not include full error handling for all situations. Please limit the use to interactive sessions at this time.
1. Because this is simply copying the data to a new WA review in the target account, the target workloadId will be different.
1. This will not copy any of the Workload Sharing features to the target workload.
1. If a Workload exists in the target account with the same name, the script will just attempt to update the review with the data from the source, not create a new one.

### Python Code {#duplicateWAFR_Code}
[Link to download the code](/watool/utilities/Code/duplicateWAFR.py)

{{< readfile file="/static/watool/utilities/Code/duplicateWAFR.py" code="true" lang="python" highlightopts="linenos=table" >}}
