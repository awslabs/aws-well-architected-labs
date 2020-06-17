---
title: "Configure Execution Environment"
menutitle: "Execution Environment"
date: 2020-04-24T11:16:09-04:00
chapter: false
weight: 2
pre: "<b>2. </b>"
---

Failure injection is a means of testing resiliency by which a specific failure type is simulated on a service and its response is assessed.

You have a choice of environments from which to execute the failure injections for this lab. Bash scripts are a good choice and can be used from a Linux command line. If you prefer Python, Java, Powershell, or C#, then instructions for these are also provided.

### 2.1 Setup AWS credentials and configuration

Your execution environment needs to be configured to enable access to the AWS account you are using for the workshop. This includes

* Credentials - You identified these credentials [back in step 1]({{< ref "./1_deploy_infra.md#awslogin" >}})
    * AWS access key
    * AWS secret access key
    * AWS session token (used in some cases)

* Configuration
    * Region: us-east-2
    * Default output: JSON

Note: **us-east-2** is the **Ohio** region

If you already know how to configure these, please do so now. If you need help or if you are planning to use **PowerShell** for this lab, then [follow these instructions]({{< ref "Documentation/AWS_Credentials.md" >}})

### 2.2 Set up the bash environment {#bash}

{{% expand "Click here for instructions if using bash:" %}}

Using bash is an effective way to execute the failure injection tests for this workshop. The bash scripts make use of the AWS CLI. If you will be using bash, then follow the directions in this section. If you cannot use bash, then [skip to the next section](#notbash).

1. Prerequisites

     * `awscli` AWS CLI installed

            $ aws --version
            aws-cli/1.16.249 Python/3.6.8...
         * Version 1.1 or higher is fine
         * If you instead got `command not found` then [see instructions here to install `awscli`]({{< ref "Documentation/Software_Install.md#install-aws-cli" >}})

     * `jq` command-line JSON processor installed.

            $ jq --version
            jq-1.5-1-a5b5cbe
         * Version 1.4 or higher is fine
         * If you instead got `command not found` then [see instructions here to install `jq`]({{< ref "Documentation/Software_Install.md#jq" >}})



1. Download the {{% githublink link_name="resiliency bash scripts from GitHub" path="static/Reliability/300_Testing_for_Resiliency_of_EC2_RDS_and_S3/Code/FailureSimulations/bash" %}} to a location convenient for you to execute them. You can use the following links to download the scripts:
      * [bash/fail_instance.sh](/Reliability/300_Testing_for_Resiliency_of_EC2_RDS_and_S3/Code/FailureSimulations/bash/fail_instance.sh)
      * [bash/failover_rds.sh](/Reliability/300_Testing_for_Resiliency_of_EC2_RDS_and_S3/Code/FailureSimulations/bash/failover_rds.sh)
      * [bash/fail_az.sh](/Reliability/300_Testing_for_Resiliency_of_EC2_RDS_and_S3/Code/FailureSimulations/bash/fail_az.sh)

1. Set the scripts to be executable.  

        chmod u+x fail_instance.sh
        chmod u+x failover_rds.sh
        chmod u+x fail_az.sh

{{% /expand %}}

### 2.3 Set up the programming language environment (for Python, Java, C#, or PowerShell) {#notbash}

Choose the appropriate section below for your language

{{% expand "Click here for instructions if using Python:" %}}

1. The scripts are written in python with boto3. On Amazon Linux, this is already installed. Use your local operating system instructions to install boto3: <https://github.com/boto/boto3>


1. Download the {{% githublink link_name="resiliency Python scripts from GitHub" path="static/Reliability/300_Testing_for_Resiliency_of_EC2_RDS_and_S3/Code/FailureSimulations/python/" %}} to a location convenient for you to execute them. You can use the following links to download the scripts:
      * [python/fail_instance.py](/Reliability/300_Testing_for_Resiliency_of_EC2_RDS_and_S3/Code/FailureSimulations/python/fail_instance.py)
      * [python/fail_rds.py](/Reliability/300_Testing_for_Resiliency_of_EC2_RDS_and_S3/Code/FailureSimulations/python/fail_rds.py)
      * [python/fail_az.py](/Reliability/300_Testing_for_Resiliency_of_EC2_RDS_and_S3/Code/FailureSimulations/python/fail_az.py)


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

      * Next choose one of the following options: **Option A** or **Option B**.

1. **Option A**: If you are comfortable with git
      1. Clone the aws-well-architected-labs repo

              $ git clone https://github.com/awslabs/aws-well-architected-labs.git
              Cloning into 'aws-well-architected-labs'...
              ...
              Checking out files: 100% (1935/1935), done.

      1. go to the build directory

              cd aws-well-architected-labs/Reliability/300_Testing_for_Resiliency_of_EC2_RDS_and_S3/Code/FailureSimulations/java/appresiliency

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



1. Download the {{% githublink link_name="resiliency PowerShell scripts from GitHub" path="static/Reliability/300_Testing_for_Resiliency_of_EC2_RDS_and_S3/Code/FailureSimulations/powershell/" %}} to a location convenient for you to execute them. You can use the following links to download the scripts:
      * [powershell/fail_instance.ps1](/Reliability/300_Testing_for_Resiliency_of_EC2_RDS_and_S3/Code/FailureSimulations/powershell/fail_instance.ps1)
      * [powershell/failover_rds.ps1](/Reliability/300_Testing_for_Resiliency_of_EC2_RDS_and_S3/Code/FailureSimulations/powershell/failover_rds.ps1)
      * [powershell/fail_az.ps1](/Reliability/300_Testing_for_Resiliency_of_EC2_RDS_and_S3/Code/FailureSimulations/powershell/fail_az.ps1)

1. If your PowerShell scripts are refused authorization to access your AWS account, consult [Getting Started with the AWS Tools for Windows PowerShell](https://docs.aws.amazon.com/powershell/latest/userguide/pstools-getting-started.html)

{{% /expand %}}