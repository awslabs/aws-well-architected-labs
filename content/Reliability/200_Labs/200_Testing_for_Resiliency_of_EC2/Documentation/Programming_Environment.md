---
title: "Setting up an environment to run the workshop using a programming language"
date: 2020-04-24T11:16:09-04:00
chapter: false
hidden: true
---
If you will be using Bash for this workshop, STOP and return to the [Lab Guide instructions for setting up Bash]({{< relref "../2_simple_web_app_failure#bash" >}})

If you will not be using Bash and prefer to use Python, Java, C#, or PowerShell for this workshop, then follow these steps

## 1. Set up AWS credentials

If you have not yet setup your AWS credentials, then [follow this guide]({{< relref "../2_simple_web_app_failure#aws_credentials" >}})

## 2. Language specific setup

Choose the appropriate section below for your language

### 2.1 Setting Up the Python Environment

1. The scripts are written in python with boto3. On Amazon Linux, this is already installed. Use your local operating system instructions to install boto3: <https://github.com/boto/boto3>



1. Download the **fail_instance.py** from the {{% githublink link_name="resiliency Python scripts on GitHub" path="static/Reliability/300_Testing_for_Resiliency_of_EC2_RDS_and_S3/Code/FailureSimulations/python/" %}} to a location convenient for you to execute it. You can use the following link to download the script:
      * [python/fail_instance.py](/Reliability/300_Testing_for_Resiliency_of_EC2_RDS_and_S3/Code/FailureSimulations/python/fail_instance.py)

### 2.2 Setting Up the Java Environment

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

### 2.3 Setting Up the C# Environment

1. Download the zipfile of the executables at the following URL. [https://s3.us-east-2.amazonaws.com/aws-well-architected-labs-ohio/Reliability/csharpresiliency.zip](https://s3.us-east-2.amazonaws.com/aws-well-architected-labs-ohio/Reliability/csharpresiliency.zip)  

2. Unzip the folder in a location convenient for you to execute the command line programs.  

### 2.4 Setting up the Powershell Environment

1. If you do not have the AWS Tools for Powershell, download and install them following the instructions here. <https://aws.amazon.com/powershell/>



1. Download the **fail_instance.sh** script from the {{% githublink link_name="resiliency PowerShell scripts on GitHub" path="static/Reliability/300_Testing_for_Resiliency_of_EC2_RDS_and_S3/Code/FailureSimulations/powershell/" %}} to a location convenient for you to execute it. You can use the following link to download the script:
      * [powershell/fail_instance.sh](/Reliability/300_Testing_for_Resiliency_of_EC2_RDS_and_S3/Code/FailureSimulations/powershell/fail_instance.ps1)

1. If your PowerShell script is refused authorization to access your AWS account, consult [Getting Started with the AWS Tools for Windows PowerShell](https://docs.aws.amazon.com/powershell/latest/userguide/pstools-getting-started.html)

---
**[Click here to return to the Lab Guide]({{< relref "../2_simple_web_app_failure" >}})**
