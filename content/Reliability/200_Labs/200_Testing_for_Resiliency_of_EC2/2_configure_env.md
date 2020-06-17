---
title: "Configure Execution Environment"
menutitle: "Execution Environment"
date: 2020-04-24T11:16:09-04:00
chapter: false
weight: 2
pre: "<b>2. </b>"
---

Failure injection is a means of testing resiliency by which a specific failure type is simulated on a service and its response is assessed.

You have a choice of environments from which to execute the failure injections for this lab. Bash scripts are a good choice and can be used from a Linux command line. If you prefer Python, Java, Powershell, or C# instructions for these are also provided.

### 2.1 Setup AWS credentials and configuration {#aws_credentials}

Your execution environment needs to be configured to enable access to the AWS account you are using for the workshop. This includes

* Credentials
    * AWS access key
    * AWS secret access key
    * AWS session token (used in some cases)

* Configuration
    * Region: us-east-2 (or region where you deployed your WebApp)
    * Default output: JSON

Note: **us-east-2** is the **Ohio** region

* If you already know how to configure these, please do so now and proceed to the next step [**2.2 Set up the bash environment**](#bash)
* If you need help then follow the instructions in either Option A or Option B below

#### Option A - AWS CLI

This option uses the AWS CLI. If you do not have this installed, or do not want to install it, then use **Option B**

1. To see if the AWS CLI is installed:

          $ aws --version
          aws-cli/1.16.249 Python/3.6.8...

     * AWS CLI version 1.1 or higher is fine
     * If you instead got `command not found` then either  [install the AWS CLI]({{< ref "/common/documentation/software_install#install-aws-cli" >}}) or use **Option B**

1. Run `aws configure` and provide the following values:

        $ aws configure
        AWS Access Key ID [*************xxxx]: <Your AWS Access Key ID>
        AWS Secret Access Key [**************xxxx]: <Your AWS Secret Access Key>
        Default region name: [us-east-2]: us-east-2 (or your chosen region)
        Default output format [None]: json

#### Option B - Manually creating credential files

If you already did **Option A**, then skip this

1. create a `.aws` directory under your home directory

        mkdir ~/.aws

1. Change directory to there

        cd ~/.aws

1. Use a text editor (vim, emacs, notepad) to create a text file (no extension) named `credentials`. In this file you should have the following text.  

        [default]
        aws_access_key_id = <Your access key>
        aws_secret_access_key = <Your secret key>

1. Create a text file (no extension) named `config`. In this file you should have the following text:

        [default]
        region = us-east-2 (or your chosen region)
        output = json

### 2.2 Set up the bash environment {#bash}

{{% expand "Click here for instructions if using bash:" %}}

Using bash is an effective way to execute the failure injection tests for this workshop. The bash scripts make use of the AWS CLI. If you will be using bash, then follow the directions in this section. If you cannot use bash, then [skip to the next section](#notbash).

1. Prerequisites

     * `awscli` AWS CLI installed
        * If you already installed AWS CLI as part of the AWS credentials and configuration setup, you can skip this and proceed to installing `jq`
        
                $ aws --version
                aws-cli/1.16.249 Python/3.6.8...
         * Version 1.1 or higher is fine
         * If you instead got `command not found` then [see instructions here to install `awscli`]({{< ref "/common/documentation/software_install#install-aws-cli" >}})

     * `jq` command-line JSON processor installed.

            $ jq --version
            jq-1.5-1-a5b5cbe
         * Version 1.4 or higher is fine
         * If you instead got `command not found` then [see instructions here to install `jq`]({{< ref "/common/documentation/software_install#jq" >}})



1. Download the **fail_instance.sh** script from {{% githublink link_name="the resiliency bash scripts on GitHub" path="static/Reliability/300_Testing_for_Resiliency_of_EC2_RDS_and_S3/Code/FailureSimulations/bash" %}} to a location convenient for you to execute it. You can use the following link to download the script:
      * [bash/fail_instance.sh](/Reliability/300_Testing_for_Resiliency_of_EC2_RDS_and_S3/Code/FailureSimulations/bash/fail_instance.sh)

1. Set the script to be executable.  

        chmod u+x fail_instance.sh

{{% /expand %}}

### 2.3 Set up the programming language environment (for Python, Java, C#, or PowerShell) {#notbash}

Choose the appropriate section below for your language

{{% expand "Click here for instructions if using Python:" %}}

1. The scripts are written in python with boto3. On Amazon Linux, this is already installed. Use your local operating system instructions to install boto3: <https://github.com/boto/boto3>



1. Download the **fail_instance.py** from the {{% githublink link_name="resiliency Python scripts on GitHub" path="static/Reliability/300_Testing_for_Resiliency_of_EC2_RDS_and_S3/Code/FailureSimulations/python/" %}} to a location convenient for you to execute it. You can use the following link to download the script:
      * [python/fail_instance.py](/Reliability/300_Testing_for_Resiliency_of_EC2_RDS_and_S3/Code/FailureSimulations/python/fail_instance.py)

{{% /expand %}}
{{% expand "Click here for instructions if using Java:" %}}

1. The command line utility in Java requires Java 8 SE.  

        $ java -version
        openjdk version "1.8.0_222"
        OpenJDK Runtime Environment (build 1.8.0_222-8u222-b10-1ubuntu1~18.04.1-b10)
        OpenJDK 64-Bit Server VM (build 25.222-b10, mixed mode)

1. If you have java 1.7 installed (as will be the case for In Amazon Linux), you need to install Java 8 and remove Java 7.

      * For Amazon Linux and RedHat

            $ sudo yum install java-1.8.0-openjdk
            $ sudo yum remove java-1.7.0-openjdk

      * For Debian, Ubuntu

            $ sudo apt install openjdk-8-jdk
            $ sudo apt install openjdk-7-jdk

      * Next choose one of the following options: **Option A** or **Option B**

1. **Option A**: If you are comfortable with git
      1. Clone the aws-well-architected-labs repo

              $ git clone https://github.com/awslabs/aws-well-architected-labs.git
              Cloning into 'aws-well-architected-labs'...
              ...
              Checking out files: 100% (1935/1935), done.

      1. go to the build directory

              cd static/Reliability/300_Testing_for_Resiliency_of_EC2_RDS_and_S3/Code/FailureSimulations/java/appresiliency

1. **Option B**:
      1. Download the zipfile of the executables at the following URL <https://s3.us-east-2.amazonaws.com/aws-well-architected-labs-ohio/Reliability/javaresiliency.zip>
      1. go to the build directory: `cd java/appresiliency`

1. Build: `mvn clean package shade:shade`

1. `cd target` - this is where your `jar` files were built and where you can run from the command line

{{% /expand %}}
{{% expand "Click here for instructions if using C#:" %}}


1. Download the zipfile of the executables at the following URL. [https://s3.us-east-2.amazonaws.com/aws-well-architected-labs-ohio/Reliability/csharpresiliency.zip](https://s3.us-east-2.amazonaws.com/aws-well-architected-labs-ohio/Reliability/csharpresiliency.zip)  

2. Unzip the folder in a location convenient for you to execute the command line programs.  

{{% /expand %}}
{{% expand "Click here for instructions if using PowerShell:" %}}

1. If you do not have the AWS Tools for Powershell, download and install them following the instructions here. <https://aws.amazon.com/powershell/>



1. Download the **fail_instance.sh** script from the {{% githublink link_name="resiliency PowerShell scripts on GitHub" path="static/Reliability/300_Testing_for_Resiliency_of_EC2_RDS_and_S3/Code/FailureSimulations/powershell/" %}} to a location convenient for you to execute it. You can use the following link to download the script:
      * [powershell/fail_instance.sh](/Reliability/300_Testing_for_Resiliency_of_EC2_RDS_and_S3/Code/FailureSimulations/powershell/fail_instance.ps1)

1. If your PowerShell script is refused authorization to access your AWS account, consult [Getting Started with the AWS Tools for Windows PowerShell](https://docs.aws.amazon.com/powershell/latest/userguide/pstools-getting-started.html)

{{% /expand %}}
