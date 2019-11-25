# Setup AWS credentials and configuration

* You will supply configuration and credentials used by the AWS SDK to access your AWS account. You identified these credentials [back in step 1 of the Lab Guide](../Lab_Guide.md#awslogin)

## Choose an option

Choose _ONLY ONE_ option, either **Option 1**, **Option 2**, **Option 3**, or **Option 4** (PowerShell only)

### Option 1 For instructor supplied AWS accounts

If BOTH of the following are true then you may use **Option 1**

* **If you are attending an in-person workshop and were provided with an AWS account by the instructor** then you should use this option
* You are running the workshop on system where environment variables are set using the `export` command, such as Bash on Amazon Linux

Otherwise you should choose **Option 2** or **Option 3**

1. You should have already copied the credentials for your account. If not then [follow the directions here](Workshop_AWS_Account.md)

1. The copied credentials are already in the form of `export` statements. Run these from your shell command line. Use _your_ values, _not_ the ones below

        export AWS_ACCESS_KEY_ID=ASIIAMFAKENOPZLX6J5L
        export AWS_SECRET_ACCESS_KEY=w0pE4j5k4FlUrkIIAMFAKEdiLMKLGZlxyct+GpTam
        export AWS_SESSION_TOKEN=FQoGZXIvYXdzEDwaIIAMFAKEn0LVImWNQHiLuAWKe+KFkLeIvpOHEruWjyCjrEdyjtW8WCbnmJGM1ES20xq1fcaS5TERHDUabZJ60Kk6nc9uHoCDb1QKHi+MerRIcKJTi3OKz0QMVPAGVqVWgvOBBSQ2lylLVjtMMSQF+yLZsP1bvehQ0ke/Bl/X6RJySOHg2TZGyESPL/INqJiZyEHi+MelAnThepVgWUKFPD5mESBVlpy2LVCE3xPpHFqOm0Q79svRSSW2jLj5NkRXL+xhkcvt+g8vNt1ODEwixwMGpFB2sBHryv6EXNeX6c88vxJ8Zyfkmsqi0xmCW1f9jWAPIXNkt/nEYW4J4coyLKP7QU=
        export AWS_DEFAULT_REGION=us-east-2

1. Also run this command as written below

        export AWS_DEFAULT_OUTPUT=json

1. Note that if you end your session, or start a new one, you will need to re-execute the `export` statements

If you completed **Option 1** then **STOP HERE and return to the [Lab Guide](../Lab_Guide.md)**

### Option 2 AWS CLI

This option uses the AWS CLI. If you do not have this installed, or do not want to install it, then use **Option 3**

1. To see if the AWS CLI is installed:

          $ aws --version
          aws-cli/1.16.249 Python/3.6.8...

     * AWS CLI version 1.1 or higher is fine
     * If you instead got `command not found` then either  [install the AWS CLI](Software_Install.md#awscli) or use **Option 3**

1. Run `aws configure` and provide the following values:

        $ aws configure
        AWS Access Key ID [*************xxxx]: <Your AWS Access Key ID>
        AWS Secret Access Key [**************xxxx]: <Your AWS Secret Access Key>
        Default region name: [us-east-2]: us-east-2
        Default output format [None]: json

### Option 3 Manually creating credential files

If you already did **Option 2**, then skip this

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

## Configure a session token as part of your credentials

If you used **Option 2** or **Option 3**, please follow these steps:

1. Determine if you need to configure a session token as part of your credentials

| AWS Account | Do you need a session token? |
| :--- | :---: |
|You are attending an in-person workshop and were provided with an AWS account by the instructor | yes |
| | |
|You are using your own AWS account, and using credentials from an **IAM User** (most common case) | no |
| | |
|You are using your own AWS account, and using credentials from an **IAM Role** | yes |

1. Do this _only_ if "yes", you need to configure a session token
     * Edit the file `~/.aws/credentials`
     * The `default` profile will already be present.  Under it add an entry for `aws_session_token`

            [default]
            aws_access_key_id = <Your access key>
            aws_secret_access_key = <Your secret key>
            aws_session_token = <your session token> 

### Clear environment variables

If you used **option 2** or **option 3** then you have put your credentials into files that will be used by the AWS CLI or AWS SDK. However these systems preferentially will use credentials and configuration in environment variables.  Therefore ensure that the following env variables are **not** set:

* `AWS_ACCESS_KEY_ID`
* `AWS_SECRET_ACCESS_KEY`
* `AWS_SESSION_TOKEN`
* `AWS_DEFAULT_REGION`
* `AWS_DEFAULT_OUTPUT`
* `AWS_PROFILE`

How to do this varies depending on system.  For Linux:

      # Use echo $varname to see if it ise set
      $ echo $AWS_ACCESS_KEY_ID
      ASIATWOQ3L72RPLOP222

      # use unset
      $ unset AWS_ACCESS_KEY_ID

      # This now returns no value
      $ echo $AWS_ACCESS_KEY_ID

For your convenience:

      unset AWS_ACCESS_KEY_ID
      unset AWS_SECRET_ACCESS_KEY
      unset AWS_SESSION_TOKEN
      unset AWS_DEFAULT_REGION
      unset AWS_DEFAULT_OUTPUT
      unset AWS_PROFILE

### Option 4 (PowerShell only)

Configuration for PowerShell requires Windows PowerShell for AWS, part of the software package [AWS Tools for Powershell](https://aws.amazon.com/powershell/).

If this software is not present on your Start Menu:

1. Download the software and install it from the above link.

1. Start a Windows PowerShell for AWS session. If prompted for AWS Secret Key during initialization, type Control-D to break out of the dialog download it and start a Windows PowerShell for AWS session.

Establish your AWS Credentials for this PowerShell as follows:

1. Configure your AWS Credentials with the following PowerShell commands. If you are using an instructor provided account, include the SessionToken parameter and its value as well.

        Set-AWSCredentials -AccessKey <Your access key> -SecretKey <Your secret key> \
        [ -SessionToken <your session key> \] -StoreAs <SomeProfileName>
        Initialize-AWSDefaults -ProfileName SomeProfileName -Region us-east-2

---
**[Click here to return to the Lab Guide](../Lab_Guide.md)**
