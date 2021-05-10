---
title: "Configure Environment"
date: 2021-04-18T11:16:09-04:00
chapter: false
weight: 1
pre: "<b>1. </b>"
---

You must have the AWS SDK for Python (Boto3) installed to run this script. [Here is more information about installing and configuring the SDK.](https://boto3.amazonaws.com/v1/documentation/api/latest/guide/quickstart.html)

### Check Python SDK Version
You must verify that you are running at least v1.16.38 of the AWS SDK for Python to have all of the components necessary to use the Well-Architected API.

#### How to verify version
``` text {hl_lines=["4"]}
$ pip3 show boto3

Name: boto3
Version: 1.17.27
Summary: The AWS SDK for Python
Home-page: https://github.com/boto/boto3
Author: Amazon Web Services
Author-email: None
License: Apache License 2.0
Location: /usr/local/lib/python3.9/site-packages
Requires: botocore, jmespath, s3transfer
```

If the version number is less than 1.16.38, then you can upgrade boto3 via pip:
```
pip3 install boto3 --upgrade --user
```

### Other Python modules
You may need to install the following modules for this script to run:
1. [BeautifulSoup4](https://pypi.org/project/beautifulsoup4/)
    * pip install beautifulsoup4

{{< prev_next_button link_prev_url="../" link_next_url="../2_python_code/" />}}
