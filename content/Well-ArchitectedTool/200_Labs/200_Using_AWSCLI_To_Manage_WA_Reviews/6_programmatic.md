---
title: "Optional - Programmatic access via API"
menutitle: "Programmatic access via API"
date: 2021-01-15T11:16:09-04:00
chapter: false
pre: "<b>6. </b>"
weight: 6
---

## Choose which programming language you wish to use
* [Python]({{< relref "#python" >}})
* [PowerShell]({{< relref "#powershell" >}})


## Python version using Boto3 Library {#python}
The lab uses AWS CLI to perform all of the tasks, but you can also use the [AWS SDK for Python (Boto3)](https://aws.amazon.com/sdk-for-python/) to perform the same steps. As a reference, you can [download the code LabExample.py](/watool/200_Using_AWSCLI_To_Manage_WA_Reviews/Code/LabExample.py) which will perform all of steps from the lab in a single python file.  This file assumes you have already setup your AWS credential file, and uses the default profile for all interactions.  

The code has been broken up into functions which accept various parameters, so you can pull those out and place them into integration points in your environment. There is error checking for most of the various API calls, but the code should not be considered production ready. Please review before implementing in your environment.


### Python code
{{< readfile file="/static/watool/200_Using_AWSCLI_To_Manage_WA_Reviews/Code/LabExample.py" code="true" lang="python" >}}

## PowerShell version using AWS Tools for PowerShell {#powershell}
The lab uses AWS CLI to perform all of the tasks, but you can also use the [AWS Tools for PowerShell](https://aws.amazon.com/powershell/) to perform the same steps. As a reference, you can [download the code LabExample.ps1](/watool/200_Using_AWSCLI_To_Manage_WA_Reviews/Code/LabExample.ps1) which will perform all of steps from the lab in a single PowerShell script.  This file assumes you have already installed the [AWS.Tools PowerShell module](https://docs.aws.amazon.com/powershell/latest/userguide/pstools-getting-set-up-windows.html#ps-installing-awstools) installed as well as the AWS.Tools.WellArchitected module using Install-AWSToolsModule command. It also assumes you have setup your AWS credential file and it will uses the default profile for all interactions.  

There is no error checking for most of the various API calls, so the code should not be considered production ready. Please review before implementing in your environment.

### PowerShell code
{{< readfile file="/static/watool/200_Using_AWSCLI_To_Manage_WA_Reviews/Code/LabExample.ps1" code="true" lang="powershell" >}}

{{< prev_next_button link_prev_url="../5_view_report/" link_next_url="../7_cleanup/" />}}
