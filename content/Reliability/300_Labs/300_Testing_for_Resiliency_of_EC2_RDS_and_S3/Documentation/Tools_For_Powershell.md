---
title: "Install AWS Tools for Powershell"
date: 2021-09-28T11:16:09-04:00
chapter: false
hidden: true
---

The AWS documentation for  AWS Tools for Powershell is here: https://aws.amazon.com/powershell/

If you run into trouble using the instructions below, please consult the AWS documentation.

1. Open Windows PowerShell using **Run as administrator**

1. If you have not done so already, setup your AWS credentials
    * Configure your AWS credentials with the following PowerShell commands. Note that if you are using an instructor supplied AWS account, you must include the **SessionToken** flag and value as shown below in brackets (omit the brackets when running the command):

    ```powershell
    Set-AWSCredentials -AccessKey <Your access key> -SecretKey <Your secret key> `
    [ -SessionToken <your session key> ] -StoreAs <SomeProfileName>

    Initialize-AWSDefaults -ProfileName <SomeProfileName> -Region us-east-2
    ```
1. Run the following commands to install these respective packages using PowerShellGet. It is recommended you run these commands one by one.  They will each require a response - you should respond `[A] Yes to All`.

    ```powershell
    Install-Module -Name AWS.Tools.Common

    Install-Module -Name AWS.Tools.EC2

    Install-Module -Name AWS.Tools.RDS

    Install-Module -Name AWS.Tools.AutoScaling
    ```

_Troubleshooting_

If you get this error: `Install-Module : Administrator rights are required to install modules...`,
then make sure you are running PowerShell as Administrator. 

For other problems with authorization to access your AWS account, consult [AWS Tools for Windows PowerShell - Using AWS Credentials](https://docs.aws.amazon.com/powershell/latest/userguide/specifying-your-aws-credentials.html)

**Return to the [Lab Guide]({{< ref "../2_configure_env.md#setupenv" >}})**