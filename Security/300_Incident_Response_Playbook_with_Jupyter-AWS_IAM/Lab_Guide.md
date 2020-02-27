# Level 300: Incident Response Playbook with Jupyter - AWS IAM

## Authors

- Ben Potter, Security Lead, Well-Architected
- Byron Pogson, Solutions Architect, AWS

## Table of Contents

1. [Prerequisites](#prerequisites)
2. [Playbook Run](#playbook)
3. [Knowledge Check](#knowledge_check)

## 1. Prerequisites <a name="prerequisites"></a>

### 1.1 Install Python and Modules

Python 3 and a number of Python modules are required.

* [Python downloads](https://www.python.org/downloads/)
* [Installing pip](https://pip.pypa.io/en/stable/installing/) may be required also.

After installing Python, install the following packages by executing the following command in your command line or terminal:

`pip install boto3 pandas jupyter`

### 1.2 Install the AWS CLI

AWS CLI is not directly used for this lab, however it makes configuration of the AWS IAM credentials easier, and is useful for testing and general use.

1. Install AWS CLI:
* [Install the AWS CLI on macOS](https://docs.aws.amazon.com/cli/latest/userguide/install-macos.html)
* [Install the AWS CLI on Linux](https://docs.aws.amazon.com/cli/latest/userguide/install-linux.html)
* [Install the AWS CLI on Windows](https://docs.aws.amazon.com/cli/latest/userguide/install-windows.html)
2. In your command line or terminal run `aws configure` to configure your credentials. Note the user will require access to the IAM service.

A best practice is to enforce the use of MFA, so if you misplace your AWS Management console password and/or access/secret key, there is nothing anyone can do without your MFA credentials. You can follow the instructions [here](https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-role.html) to configure AWS CLI to assume a role with MFA enforced.

***

## 2. Playbook Run <a name="playbook"></a>

### 2.1 Download Playbook and Helper

Download the latest version of the notebook [Incident_Response_Playbook_AWS_IAM.ipynb](https://raw.githubusercontent.com/awslabs/aws-well-architected-labs/master/300_Incident_Response_Playbook_with_Jupyter-AWS_IAM/Code/Incident_Response_Playbook_AWS_IAM.ipynb) and helper [incident_response_helpers.py](https://raw.githubusercontent.com/awslabs/aws-well-architected-labs/master/300_Incident_Response_Playbook_with_Jupyter-AWS_IAM/Code/incident_response_helpers.py) from file from GitHub raw, or by [cloning](https://help.github.com/en/articles/cloning-a-repository) this repository.

### 2.2 Run the Playbook

1. In your command line or terminal change directory to where you downloaded or cloned the notebook and helper.
3. Enter `jupyter notebook` to start the local webserver, and connect to the url provided in the console e.g. *The Jupyter Notebook is running at:*, a web browser may automatically open to the correct url.
4. Click on the *Incident_Response_Playbook_AWS_IAM.ipynb* file to execute the playbook.
5. Follow the instructions in the playbook.

***

## 3. Knowledge Check <a name="knowledge_check"></a>

The security best practices followed in this lab are: <a name="best_practices"></a>

* [Analyze logs centrally](https://wa.aws.amazon.com/wat.question.SEC_4.en.html) Amazon CloudWatch is used to monitor, store, and access your log files. You can use AWS CloudWatch to analyze your logs centrally.
* [Automate alerting on key indicators](https://wa.aws.amazon.com/wat.question.SEC_4.en.html) AWS CloudTrail, AWS Config,Amazon GuardDuty and Amazon VPC Flow Logs provide insights into your environment.
* [Implement new security services and features:](https://wa.aws.amazon.com/wat.question.SEC_5.en.html) New features such as Amazon VPC Flow Logs have been adopted.
* [Implement managed services:](https://wa.aws.amazon.com/wat.question.SEC_7.en.html)
Managed services are utilized to increase your visibility and control of your environment.
* [Identify Tooling](https://wa.aws.amazon.com/wat.question.SEC_11.en.html)
Using the AWS Management Console and/or AWS CLI tools with prepared scripts will assist in your investigations.

***

## References & useful resources

* [AWS CLI Command Reference](https://docs.aws.amazon.com/cli/latest/reference/)
* [AWS Identity and Access Management User Guide](https://docs.aws.amazon.com/IAM/latest/UserGuide/introduction.html)
* [CloudWatch Logs Insights Query Syntax](https://docs.aws.amazon.com/AmazonCloudWatch/latest/logs/CWL_QuerySyntax.html)
* [Jupyter](https://jupyter.org/)

***

## License

Licensed under the Apache 2.0 and MITnoAttr License.

Copyright 2020 Amazon.com, Inc. or its affiliates. All Rights Reserved.

Licensed under the Apache License, Version 2.0 (the "License"). You may not use this file except in compliance with the License. A copy of the License is located at

    https://aws.amazon.com/apache2.0/

or in the "license" file accompanying this file. This file is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the License for the specific language governing permissions and limitations under the License.
