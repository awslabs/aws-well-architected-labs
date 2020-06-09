---
title: "Install Python & AWS CLI"
menutitle: "Install Python & AWS CLI"
date: 2020-04-24T11:16:09-04:00
chapter: false
weight: 1
pre: "<b>1. </b>"
---

### 1.1 Install Python and Modules

Python 3 and a number of Python modules are required.

* [Python downloads](https://www.python.org/downloads/)
* [Installing pip](https://pip.pypa.io/en/stable/installing/) may be required also.

After installing Python, install the following packages by executing the following command in your command line or terminal:

```shell
pip install boto3 pandas jupyter
```  


### 1.2 Install the AWS CLI

AWS CLI is not directly used for this lab, however it makes configuration of the AWS IAM credentials easier, and is useful for testing and general use.

1. Install AWS CLI:
* [Install the AWS CLI on macOS](https://docs.aws.amazon.com/cli/latest/userguide/install-macos.html)
* [Install the AWS CLI on Linux](https://docs.aws.amazon.com/cli/latest/userguide/install-linux.html)
* [Install the AWS CLI on Windows](https://docs.aws.amazon.com/cli/latest/userguide/install-windows.html)
2. In your command line or terminal run `aws configure` to configure your credentials. Note the user will require access to the IAM service.

A best practice is to enforce the use of MFA, so if you misplace your AWS Management console password and/or access/secret key, there is nothing anyone can do without your MFA credentials. You can follow the instructions [here](https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-role.html) to configure AWS CLI to assume a role with MFA enforced.
