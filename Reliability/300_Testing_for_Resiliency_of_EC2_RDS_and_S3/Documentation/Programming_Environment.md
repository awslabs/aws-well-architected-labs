# Setting up an environment to run the workshop using a programming language

If you If you will be using bash for this workshop, STOP and return to the [Lab Guide instructions for setting up bash](../Lab_Guide.md#bash)

If you will not be using bash and prefer to use Python, Java, C#, or PowerShell for this workshop, then follow these steps

## 1. Set up AWS credentials

* Follow these steps no matter which language you will be using
* You will supply configuration and credentials used by the AWS SDK to access your AWS account. You identified these credentials [back in step 1 of the Lab Guide](../Lab_Guide.md#awslogin)
* Choose ONLY ONE option, either Option 1.1 or Option 1.2

### Option 1.1 AWS CLI

1. If `aws --version` succeeds, then you have the AWS CLI installed and can use it.  If not, then go to Option 1.2.
1. Run `aws configure` and provide the following values:

        $ aws configure
        AWS Access Key ID [*************xxxx]: <Your AWS Access Key ID>
        AWS Secret Access Key [**************xxxx]: <Your AWS Secret Access Key>
        Default region name: [us-east-2]: us-east-2
        Default output format [None]: json

### Option 1.2 Manually creating credential files

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
        region = us-east-2
        output = json

## 2. Language specific setup

Choose the appropriate section below for your language

### 2.1 Setting Up the Python Environment

1. The scripts are written in python with boto3. On Amazon Linux, this is already installed. Use your local operating system instructions to install boto3: <https://github.com/boto/boto3>

1. Download these three resiliency scripts to a location convenient for you to execute the scripts.  

        https://raw.githubusercontent.com/setheliot/aws-well-architected-labs/master/Reliability/300_Testing_for_Resiliency_of_EC2_RDS_and_S3/Code/FailureSimulations/python/fail_instance.py

        https://raw.githubusercontent.com/setheliot/aws-well-architected-labs/master/Reliability/300_Testing_for_Resiliency_of_EC2_RDS_and_S3/Code/FailureSimulations/python/fail_rds.py

        https://raw.githubusercontent.com/setheliot/aws-well-architected-labs/master/Reliability/300_Testing_for_Resiliency_of_EC2_RDS_and_S3/Code/FailureSimulations/python/fail_az.py

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

   * Next choose one of the following options.

1. Option A: If you are comfortable with git
   1. Clone the aws-well-architected-labs repo

          $ git clone https://github.com/awslabs/aws-well-architected-labs.git
          Cloning into 'aws-well-architected-labs'...
          ...
          Checking out files: 100% (1935/1935), done.

   1. go to the build directory

          cd aws-well-architected-labs/Reliability/300_Testing_for_Resiliency_of_EC2_RDS_and_S3/Code/FailureSimulations/java/appresiliency

1. Option B:
   1. Download the zipfile of the executables at the following URL <https://s3.us-east-2.amazonaws.com/aws-well-architected-labs-ohio/Reliability/javaresiliency.zip>
   1. go to the build directory: `cd java/appresiliency`

1. Build: `mvn clean package shade:shade`

1. `cd target` - this is where your `jar` files were built and where you can run from the command line

### 2.3 Setting Up the C# Environment

1. Download the zipfile of the executables at the following URL. [https://s3.us-east-2.amazonaws.com/aws-well-architected-labs-ohio/Reliability/csharpresiliency.zip](https://s3.us-east-2.amazonaws.com/aws-well-architected-labs-ohio/Reliability/csharpresiliency.zip)  

2. Unzip the folder in a location convenient for you to execute the command line programs.  

### 2.4 Setting up the Powershell Environment

1. If you do not have the AWS Tools for Powershell, download and install them following the instructions here. <https://aws.amazon.com/powershell/>

1. Download these three resiliency scripts to a location convenient for you to execute the scripts.  

        https://github.com/setheliot/aws-well-architected-labs/blob/master/Reliability/300_Testing_for_Resiliency_of_EC2_RDS_and_S3/Code/FailureSimulations/powershell/fail_instance.ps1

        https://github.com/setheliot/aws-well-architected-labs/blob/master/Reliability/300_Testing_for_Resiliency_of_EC2_RDS_and_S3/Code/FailureSimulations/powershell/failover_rds.ps1

        https://github.com/setheliot/aws-well-architected-labs/blob/master/Reliability/300_Testing_for_Resiliency_of_EC2_RDS_and_S3/Code/FailureSimulations/powershell/fail_az.ps1

1. If your PowerShell scripts are refused authorization to access your AWS account, consult [Getting Started with the AWS Tools for Windows PowerShell](https://docs.aws.amazon.com/powershell/latest/userguide/pstools-getting-started.html)

---
**[Click here to return to the Lab Guide](../Lab_Guide.md)**
