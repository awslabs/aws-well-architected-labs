---
title: "Optional - Programmatic access via API"
menutitle: "Programmatic access via API"
date: 2021-01-15T11:16:09-04:00
chapter: false
pre: "<b>6. </b>"
weight: 6
---

## Python version using Boto3 Library
The lab uses AWS CLI to perform all of the tasks, but you can also use the Boto3 Python library to perform the same steps. As a reference, you can [download the code LabExample.py](/watool/200_Using_AWSCLI_To_Manage_WA_Reviews/Code/LabExample.py) which will perform all of steps from the lab in a single python file.  This file assumes you have already setup your AWS credential file, and uses the default profile for all interactions.  

The code has been broken up into functions which accept various parameters, so you can pull those out and place them into integration points in your environment. There is error checking for most of the various API calls, but the code should not be considered production ready. Please review before implementing in your environment.


### Python code
{{< readfile file="/static/watool/200_Using_AWSCLI_To_Manage_WA_Reviews/Code/LabExample.py" code="true" lang="python" >}}


<!--
## Powershell version using AWS SDK for Powershell
**Coming soon** -->


{{< prev_next_button link_prev_url="../5_view_report/" link_next_url="../7_cleanup/" />}}
