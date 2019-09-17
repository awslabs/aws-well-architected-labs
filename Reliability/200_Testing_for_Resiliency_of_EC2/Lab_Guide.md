# Level 200: Testing for Resiliency of EC2

## Authors
- Rodney Lester, Reliability Lead, Well-Architected
# Table of Contents
1. [Discussion and Example Failure Scenarios](#simple_web_app_failure)
2. [Failure Modes](#failure_modes)
2. [Tear Down](#tear_down)

## 1. Discussion and Example Failure Scenarios <a name="simple_web_app_failure"></a>
Please note a prerequisite to this lab is that you have deployed the static web application stack in the lab [Automated Deployment of EC2 Web Application](../../Security/200_Automated_Deployment_of_EC2_Web_Application) with the default parameters and recommended stack name. This step will test the web application and it's EC2 components inside the VPC you have created previously. 

There is a choice of environments to execute the failure simulations in. Linux command line (bash), Python, Java, and C#.  The instructions for each environment are in separate sections.
### 1.1 Setting Up the bash Environment
All the command line scripts use a utility called jq. You can download it from the site and leave it in your local directory, as long as that is in your execution path:  
[https://stedolan.github.io/jq/](https://stedolan.github.io/jq/)  
1. You can find out what your execution path is with the following command.
```
$ echo $PATH
/usr/local/bin:/bin:/usr/bin:/usr/local/sbin:/usr/sbin:/sbin:/opt/aws/bin:/home/ec2-user/.local/bin:/home/ec2-user/bin
```
2. If you have sudo rights, then copy the executable to /usr/local/bin/jq and make it executable.  
```
$ sudo cp jq-linux64 /usr/local/bin/jq
$ sudo chmod 755 /usr/local/bin/jq
```
3. If you do not have sudo rights, then copy it into your home directory under a /bin directory. In Amazon linux, this is typically /home/ec2-user/bin.  
```
$ cp jq-linux64 ~/bin/jq
$ chmod 755 ~/bin/jq
```
4. Install the AWS Command Line Interface (CLI) if you do not have it installed (it is installed by default on Amazon Linux).  
[https://aws.amazon.com/cli/](https://aws.amazon.com/cli/)
5. Run the aws configure command to configure your command line options. This will prompt you for the AWS Access Key ID, AWS Secret Access Key, and default region name. Enter the key information if you do not already have them installed, and set the default region to the region you have deployed your web app into and set the default output format as “json”.  
```
$ aws configure
AWS Access Key ID [*************xxxx]: <Your AWS Access Key ID>
AWS Secret Access Key [**************xxxx]: <Your AWS Secret Access Key>
Default region name: [us-east-2]: <The AWS Region you have deployed the web app>
Default output format [None]: json
```
6. Download the zip file of the resiliency bash scripts at the following URL:  
[https://s3.us-east-2.amazonaws.com/aws-well-architected-labs-ohio/Reliability/bashresiliency.zip](https://s3.us-east-2.amazonaws.com/aws-well-architected-labs-ohio/Reliability/bashresiliency.zip)
7. Unzip the folder in a location convenient for you to execute the scripts.  
8. They are also available in the [300 -  Testing for Resiliency of EC2, RDS, and S3/Code/](../300 - Testing for Resiliency of EC2, RDS, and S3/Code/FailureSimulations/) directory.

### 1.2 Setting up a Programming Language Based Environment
You will need the same files that the AWS command line uses for credentials. You can either install the command line and use the ‘aws configure’ command as outlined in the bash set up, or you can manually create the configuration files. To create the files manually, create a .aws folder/directory in your home directory.  
1. Bash and powershell use the same command.  
```
mkdir ~/.aws
```
2. Change directory to that directory to create the configuration file.  
Bash
```
cd ~/.aws
```
Powershell
```
cd ~\.aws
```
3. Use a text editor (vim, emacs, notepad, wordpad) to create a text file (no extension) named “credentials”. In this file you should have the following text:
```
[default]
aws_access_key_id = <Your access key>
aws_secret_access_key = <Your secret key>
```
4. Create a text file (no extension) named "config". In this file you should have the following text:
```
[default]
region = us-east-2
output = json
```
### 1.3 Setting Up the Python Environment
1. The scripts are written in python with boto3. On Amazon Linux, this is already installed. Use your local operating system instructions to install boto3: [https://github.com/boto/boto3](https://github.com/boto/boto3)
2. Download the zip file of the resiliency scripts at the following URL.[https://s3.us-east-2.amazonaws.com/aws-well-architected-labs-ohio/Reliability/pythonresiliency.zip](https://s3.us-east-2.amazonaws.com/aws-well-architected-labs-ohio/Reliability/pythonresiliency.zip)   
3. Unzip the folder in a location convenient for you to execute the scripts.  

### 1.4 Setting Up the Java Environment
1. The command line utility in Java requires Java 8 SE. In Amazon Linux, you need to install Java 8 and remove Java 7.  
```
$ sudo yum install java-1.8.0-openjdk
$ sudo yum remove java-1.7.0-openjdk
```
2. Download the zipfile of the executables at the following URL [https://s3.us-east-2.amazonaws.com/aws-well-architected-labs-ohio/Reliability/javaresiliency.zip](https://s3.us-east-2.amazonaws.com/aws-well-architected-labs-ohio/Reliability/javaresiliency.zip).   
3. Unzip the folder in a location convenient for you to execute the command line programs.  

### 1.5 Setting Up the C# Environment
1. Download the zipfile of the executables at the following URL. [https://s3.us-east-2.amazonaws.com/aws-well-architected-labs-ohio/Reliability/csharpresiliency.zip](https://s3.us-east-2.amazonaws.com/aws-well-architected-labs-ohio/Reliability/csharpresiliency.zip)  
2. Unzip the folder in a location convenient for you to execute the command line programs.  

### 1.6 Setting up the Powershell Environment
1. If you do not have the AWS Tools for Powershell, download and install them following the instructions here. [https://aws.amazon.com/powershell/](https://aws.amazon.com/powershell/)  
2. Follow the “Getting Started” instructions for configuring credentials. [https://docs.aws.amazon.com/powershell/latest/userguide/pstools-getting-started.html](https://docs.aws.amazon.com/powershell/latest/userguide/pstools-getting-started.html)  
3. Download the zipfile of the scripts at the following URL. [https://s3.us-east-2.amazonaws.com/aws-well-architected-labs-ohio/Reliability/powershellresiliency.zip](https://s3.us-east-2.amazonaws.com/aws-well-architected-labs-ohio/Reliability/powershellresiliency.zip)  
4. Unzip the folder in a location convenient for you to execute the scripts.

## 2. Failure Modes <a name="failure_modes"></a>
### 2.1 EC2 Failure Mode
1. The first failure mode will be to fail a web server. To prepare for this, you should have two consoles open: VPC and EC2. From the AWS Console, click the downward facing icon to the right of the word “Services.” This will bring up the list of services. Type “EC2” in the search box and press the enter key.  
![EnteringEC2](Images/EnteringEC2.png)  
2. You also need the VPC Console. From the AWS Console, click the downward facing icon to the right of the word “Services.” This will bring up the list of services. Type “VPC” in the search box, then right click on the “VPC Isolate Cloud Resources” text and open the link in a new tab or window. You can then click the upward facing icon to the right of the word “Services” to make the menu of services disappear.  
![EnteringVPC](Images/EnteringVPC.png)  
3. On the EC2 Console, click “Instances” on the left side to bring up the list of instances.  
![SelectingInstances](Images/SelectingInstances.png)  
4. Use this as the command line argument to the scripts/programs below.  
  * Instance Failure in bash
Execute the failure mode script for failing an instance:
```
$./fail_instance.sh <vpc-id>
```
  * Instance Failure in Python: Execute the failure mode script for failing an instance:
```
$ python fail_instance.py <vpc-id>
```
  * Instance Failure in Java: Execute the failure mode program for failing an instance:
```
$ java -jar app-resiliency-1.0.jar EC2 <vpc-id>
```
  * Instance Failure in C#: Execute the failure mode program for failing an instance:
```
$ .\AppResiliency EC2 <vpc-id>
```
  * Instance Failure in Powershell: Execute the failure mode script for failing an instance:
```
$ .\fail_instance.ps1 <vpc-id>
```
5. Watch the behavior of the Load Balancer Target Group and its Targets in the EC2 Console. See it get marked unhealthy and replaced by the Auto Scaling Group.  
![TargetGroups](Images/TargetGroups.png)  

***

## 3. Tear down this lab <a name="tear_down"></a>
The following instructions will remove the resources that you have created in this lab.

There are no new resources to remove in this lab.

***

## References & useful resources:
[AWS CloudFormation User Guide](https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/Welcome.html)  
[Amazon EC2 User Guide for Linux Instances](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/concepts.html)

***

## License
Licensed under the Apache 2.0 and MITnoAttr License. 

Copyright 2019 Amazon.com, Inc. or its affiliates. All Rights Reserved.

Licensed under the Apache License, Version 2.0 (the "License"). You may not use this file except in compliance with the License. A copy of the License is located at

    https://aws.amazon.com/apache2.0/

or in the "license" file accompanying this file. This file is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the License for the specific language governing permissions and limitations under the License.
