---
title: "Configure Environment"
date: 2021-04-18T11:16:09-04:00
chapter: false
weight: 1
pre: "<b>1. </b>"
---


<!-- {{% common/InstallAWSCLIv2 %}} -->
Ensure you are running at least v1.16.38 of the Boto3 library.

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
[Here is more information about installing and configuring boto3](https://boto3.amazonaws.com/v1/documentation/api/latest/guide/quickstart.html)

## Python Modules required:
1. boto3
1. jmespath
1. webbrowser
1. BeautifulSoup4


<!-- {{< prev_next_button link_prev_url="../" link_next_url="../2_create_workload/" />}} -->
