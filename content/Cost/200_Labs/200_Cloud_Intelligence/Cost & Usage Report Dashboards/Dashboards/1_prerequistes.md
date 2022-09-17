---
title: "Prerequisites"
date: 2020-07-26T11:16:08-04:00
chapter: false
weight: 1
pre: "<b>1. </b>"
---


### Install or Update the AWS CLI
CLI commands are required to complete the dashboard setup. If you need to enable your AWS CLI, follow the steps below. 

{{%expand "Click here - to use AWS Cloudshell - Recommended option" %}}

**AWS CloudShell** is a browser-based, pre-authenticated shell that you can launch directly from the AWS Management Console. You can run AWS CLI commands against AWS services using your preferred shell (Bash, PowerShell, or Z shell). And you can do this without needing to download or install command line tools.
**If you are working out of one of these Regions**: US East (Ohio), US East (N. Virginia), US West (Oregon), Asia Pacific (Tokyo), or Europe (Ireland), using AWS CloudShell is the simplest option.

To launch AWS CloudShell:

+ From the **AWS Management Console**, you can launch AWS CloudShell by choosing the following options available on the navigation bar:

    + Choose the **AWS CloudShell** icon.

    + Start typing "cloudshell" in the Search box and then choose the **CloudShell** option.

    When AWS CloudShell launches in a new browser window for the first time, a welcome panel displays and lists key features. After you close this panel, status updates are provided while the shell configures and forwards your console credentials. When the command prompt displays, the shell is ready for interaction.

+ To choose an **AWS Region** to work in, go to the **Select a Region menu** and select a supported AWS Region to work in. (Available Regions are highlighted.)

{{% /expand%}}

{{%expand "Click here - if you are using Docker" %}}

#### Prerequisites

You must have Docker installed. For installation instructions, see the [Docker website](https://docs.docker.com/get-docker/)

To verify your installation of Docker, run the following command and confirm there is an output. 
```dockerfile
$ docker --version
Docker version 19.03.1
```

#### Run the official AWS CLI version 2 Docker image

The official AWS CLI version 2 Docker image is hosted on DockerHub in the `amazon/aws-cli` repository. The first time you use the `docker run` command, the latest Docker image is downloaded to your computer. Each subsequent use of the `docker run` command runs from your local copy.

To run the AWS CLI version 2 Docker image, use the `docker run` command.

```dockerfile
$ docker run --rm -it amazon/aws-cli <command>
```

This is how the command functions:

+ `docker run --rm --it amazon/aws-cli` – The equivalent of the `aws` executable. Each time you run this command, Docker spins up a container of your downloaded `amazon/aws-cli` image, and executes your `aws` command. By default, the Docker image uses the latest version of the AWS CLI version 2.

    For example, to call the `aws --version` command in Docker, you run the following.

    ```dockerfile
    $ docker run --rm -it amazon/aws-cli --version
    aws-cli/2.1.22 Python/3.7.3 Linux/4.9.184-linuxkit botocore/2.0.0dev10
    ```

+ `--rm` – Specifies to clean up the container after the command exits.

+ `-it` – Specifies to open a pseudo-TTY with `stdin`. This enables you to provide input to the AWS CLI version 2 while it's running in a container, for example, by using the `aws configure` and `aws help` commands. If you are running scripts, `-it` is not needed. If you are experiencing errors with your scripts, omit `-it` from your Docker call.

For more information about the docker run command, see the [Docker reference guide](https://docs.docker.com/engine/reference/run/)

#### Update to the latest Docker image

Because the latest Docker image is downloaded to your computer only the first time you use the `docker run` command, you need to manually pull an updated image. To manually update to the latest version, we recommend you pull the `latest` tagged image. Pulling the Docker image downloads the latest version to your computer. 
```dockerfile
$ docker pull amazon/aws-cli:latest
```

{{% /expand%}}

{{%expand "Click here - if you are using Linux x86 (64-bit)" %}}
#### Prerequisites
+ You must be able to extract or "unzip" the downloaded package. If your operating system doesn't have the built-in `unzip` command, use an equivalent.

+ The AWS CLI version 2 uses `glibc`, `groff`, and `less`. These are included by default in most major distributions of Linux.

+ We support the AWS CLI version 2 on 64-bit versions of recent distributions of CentOS, Fedora, Ubuntu, Amazon Linux 1, and Amazon Linux 2.

+ Because AWS doesn't maintain third-party repositories, we can’t guarantee that they contain the latest version of the AWS CLI.

#### Install the AWS CLI version 2 on Linux
Follow these steps from the command line to install the AWS CLI

**For the latest version of the AWS CLI**, use the following command block:
 ```linux
$ curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
 unzip awscliv2.zip
 sudo ./aws/install
```

**For a specific version of the AWS CLI**, append a hyphen and the version number to the filename. For this example the filename for version `2.0.30` would be `awscli-exe-linux-x86_64-2.0.30.zip` resulting in the following command:
```linux
$ curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64-2.0.30.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install
```
For a list of versions, see the [AWS CLI version 2 changelog](https://github.com/aws/aws-cli/blob/v2/CHANGELOG.rst) on GitHub.

#### Update the AWS CLI version 2 on Linux
To update your copy of the AWS CLI version 2, from the Linux command line, follow these steps.

1. **Download** the installation file in one of the following ways:
    
    + **Using the curl command** – The options on the following example command write the downloaded file to the current directory with the local name `awscliv2.zip`.
    
        The `-o` option specifies the file name that the downloaded package is written to. In this example, the file is written to `awscliv2.zip` in the current directory.

        **For the latest version of the AWS CLI**, use the following command block:
        ```linux
        $ curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
        ```
        **For a specific version of the AWS CLI**, append a hyphen and the version number to the filename. For this example the filename for version `2.0.30` would be `awscli-exe-linux-x86_64-2.0.30.zip` resulting in the following command:
        ```linux
        $ curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64-2.0.30.zip" -o "awscliv2.zip"
        ```
        For a list of versions, see the [AWS CLI version 2 changelog](https://github.com/aws/aws-cli/blob/v2/CHANGELOG.rst).

    + **Downloading from the URL** – To download the installer using your browser, use one of the following URLs. You can verify the integrity and authenticity of the installation file after you download it. For more information before you unzip the package, see [Verify the integrity and authenticity of the downloaded installer files](https://docs.aws.amazon.com/cli/latest/userguide/install-cliv2-linux.html#v2-install-linux-validate).

        **For the latest version of the AWS CLI**: https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip
        
        **For a specific version of the AWS CLI**: Append a hyphen and the version number to the filename. For this example the filename for version `2.0.30` would be `awscli-exe-linux-x86_64-2.0.30.zip` resulting in the following link https://awscli.amazonaws.com/awscli-exe-linux-x86_64-2.0.30.zip. For a list of versions, see the [AWS CLI version 2 changelog](https://github.com/aws/aws-cli/blob/v2/CHANGELOG.rst) on GitHub.

1. Unzip the installer. If your Linux distribution doesn't have a built-in `unzip` command, use an equivalent to install it. The following example command unzips the package and creates a directory named `aws` under the current directory.

    ```linux
    $ unzip awscliv2.zip
    ```

1. To ensure that the update installs in the same location as your current AWS CLI version 2, **locate the existing symlink and installation directory**.

    + Use the `which` command to find your symlink. This will then display the path to use with the `--bin-dir` parameter.

        ```linux
        $ which aws
        /usr/local/bin/aws
        ```
    + Use the `ls -l` command against the value returned above to find the directory that your symlink points to. This will display the path to use with the `--install-dir` parameter.

        ```linux
        $ ls -l /usr/local/bin/aws
        lrwxrwxrwx 1 ec2-user ec2-user 49 Oct 22 09:49 /usr/local/bin/aws -> /usr/local/aws-cli/v2/current/bin/aws
        ```

1. Use your symlink and installer information to construct the `install` command with the `--update` parameter.

    ```linux
    $ sudo ./aws/install --bin-dir /usr/local/bin --install-dir /usr/local/aws-cli --update
    ```

1. Confirm the installation.

    ```linux
    $ aws --version
    aws-cli/2.1.24 Python/3.7.4 Linux/4.14.133-113.105.amzn2.x86_64 botocore/2.0.0
    ```

{{% /expand%}}

{{%expand "Click here - if you are using Linux ARM" %}}
#### Prerequisites
+ You must be able to extract or "unzip" the downloaded package. If your operating system doesn't have the built-in `unzip` command, use an equivalent.

+ The AWS CLI version 2 uses `glibc`, `groff`, and `less`. These are included by default in most major distributions of Linux.

+ We support the AWS CLI version 2 on 64-bit Linux ARM.

+ Because AWS doesn't maintain third-party repositories, we can’t guarantee that they contain the latest version of the AWS CLI.

#### Install the AWS CLI version 2 on Linux ARM

**For the latest version of the AWS CLI**, use the following command block:
 ```linux
$ curl "https://awscli.amazonaws.com/awscli-exe-linux-aarch64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install
```

**For a specific version of the AWS CLI**, append a hyphen and the version number to the filename. For this example the filename for version `2.0.30` would be `awscli-exe-linux-x86_64-2.0.30.zip` resulting in the following command:

```linux
$ curl "https://awscli.amazonaws.com/awscli-exe-linux-aarch64-2.0.30.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install
```

#### Update the AWS CLI version 2 on Linux
To update your copy of the AWS CLI version 2, from the Linux command line, follow these steps.

1. **Download** the installation file in one of the following ways:
    
    + **Using the curl command** – The options on the following example command write the downloaded file to the current directory with the local name `awscliv2.zip`.
    
        The `-o` option specifies the file name that the downloaded package is written to. In this example, the file is written to `awscliv2.zip` in the current directory.

        **For the latest version of the AWS CLI**, use the following command block:
        ```linux
        $ curl "https://awscli.amazonaws.com/awscli-exe-linux-aarch64.zip" -o "awscliv2.zip"
        ```
        **For a specific version of the AWS CLI**, append a hyphen and the version number to the filename. For this example the filename for version `2.0.30` would be `awscli-exe-linux-x86_64-2.0.30.zip` resulting in the following command:
        ```linux
        $ curl "https://awscli.amazonaws.com/awscli-exe-linux-aarch64-2.0.30.zip" -o "awscliv2.zip"
        ```
        For a list of versions, see the [AWS CLI version 2 changelog](https://github.com/aws/aws-cli/blob/v2/CHANGELOG.rst).

    + **Downloading from the URL** – To download the installer using your browser, use one of the following URLs. You can verify the integrity and authenticity of the installation file after you download it. For more information before you unzip the package, see [Verify the integrity and authenticity of the downloaded installer files](https://docs.aws.amazon.com/cli/latest/userguide/install-cliv2-linux.html#v2-install-linux-validate).

        **For the latest version of the AWS CLI**: https://awscli.amazonaws.com/awscli-exe-linux-aarch64.zip
        
        **For a specific version of the AWS CLI**: Append a hyphen and the version number to the filename. For this example the filename for version `2.0.30` would be `awscli-exe-linux-x86_64-2.0.30.zip` resulting in the following link https://awscli.amazonaws.com/awscli-exe-linux-aarch64-2.0.30.zip. For a list of versions, see the [AWS CLI version 2 changelog](https://github.com/aws/aws-cli/blob/v2/CHANGELOG.rst) on GitHub.

1. Unzip the installer. If your Linux distribution doesn't have a built-in `unzip` command, use an equivalent to install it. The following example command unzips the package and creates a directory named `aws` under the current directory.

    ```linux
    $ unzip awscliv2.zip
    ```

1. To ensure that the update installs in the same location as your current AWS CLI version 2, **locate the existing symlink and installation directory**.

    + Use the `which` command to find your symlink. This will then display the path to use with the `--bin-dir` parameter.

        ```linux
        $ which aws
        /usr/local/bin/aws
        ```
    + Use the `ls -l` command against the value returned above to find the directory that your symlink points to. This will display the path to use with the `--install-dir` parameter.

        ```linux
        $ ls -l /usr/local/bin/aws
        lrwxrwxrwx 1 ec2-user ec2-user 49 Oct 22 09:49 /usr/local/bin/aws -> /usr/local/aws-cli/v2/current/bin/aws
        ```

1. Use your symlink and installer information to construct the `install` command with the `--update` parameter.

    ```linux
    $ sudo ./aws/install --bin-dir /usr/local/bin --install-dir /usr/local/aws-cli --update
    ```

1. Confirm the installation.

    ```linux
    $ aws --version
    aws-cli/2.1.24 Python/3.7.4 Linux/4.14.133-113.105.amzn2.x86_64 botocore/2.0.0
    ```
{{% /expand%}}

{{%expand "Click here - if you are using MacOS" %}}
#### Prerequisites
+ We support the AWS CLI version 2 on Apple-supported versions of 64-bit macOS.

+ Because AWS doesn't maintain third-party repositories, we can’t guarantee that they contain the latest version of the AWS CLI.

#### Install and update the AWS CLI version 2 using the macOS user interface

The following steps show how to install or update to the latest version of the AWS CLI version 2 by using the standard macOS user interface and your browser. If you are updating to the latest version, use the same installation method that you used for your current version.

1. In your browser, download the macOS `pkg` file:

    + **For the latest version of the AWS CLI**: https://awscli.amazonaws.com/AWSCLIV2.pkg

    + **For a specific version of the AWS CLI**: Append a hyphen and the version number to the filename. For this example the filename for version `2.0.30` would be `AWSCLIV2-2.0.30.pkg` resulting in the following link https://awscli.amazonaws.com/AWSCLIV2-2.0.30.pkg. For a list of versions, see the [AWS CLI version 2 changelog on GitHub](https://github.com/aws/aws-cli/blob/v2/CHANGELOG.rst).

1. Double-click the downloaded file to launch the installer.

1. Follow the on-screen instructions. You can choose to install the AWS CLI version 2 in the following ways:

    + **For all users on the computer (requires `sudo`)**

        + You can install to any folder, or choose the recommended default folder of `/usr/local/aws-cli`.

        + The installer automatically creates a symlink at `/usr/local/bin/aws` that links to the main program in the installation folder you chose.
    + **For only the current user (doesn't require `sudo`)**

        + You can install to any folder to which you have write permission.

        + Due to standard user permissions, after the installer finishes, you must manually create a symlink file in your `$PATH` that points to the `aws` and `aws_completer` programs by using the following commands at the command prompt. If your `$PATH` includes a folder you can write to, you can run the following command without `sudo` if you specify that folder as the target's path. If you don't have a writable folder in your `$PATH`, you must use `sudo` in the commands to get permissions to write to the specified target folder. The default location for a symlink is `/usr/local/bin/`.
        ```text
        $ sudo ln -s /folder/installed/aws-cli/aws /usr/local/bin/aws
        $ sudo ln -s /folder/installed/aws-cli/aws_completer /usr/local/bin/aws_completer
        ```

#### Install and update the AWS CLI version 2 for all users using the macOS command line 

You can download, install, and update from the command line. If you are updating to the latest version, use the same installation method that you used in your current version. You can install the AWS CLI version 2.

**For the latest version of the AWS CLI**, use the following command block:

```text
$ curl "https://awscli.amazonaws.com/AWSCLIV2.pkg" -o "AWSCLIV2.pkg"
$ sudo installer -pkg AWSCLIV2.pkg -target /
```

**For a specific version of the AWS CLI**, append a hyphen and the version number to the filename. For this example the filename for version `2.0.30` would be `AWSCLIV2-2.0.30.pkg` resulting in the following command:

```text
$ curl "https://awscli.amazonaws.com/AWSCLIV2-2.0.30.pkg" -o "AWSCLIV2.pkg"
$ sudo installer -pkg AWSCLIV2.pkg -target /
```

#### Install and update the AWS CLI version 2 for only the current user using the macOS command line

1. To specify which folder the AWS CLI is installed to, you must create an XML file. This file is an XML-formatted file that looks like the following example. Leave all values as shown, except you must replace the path */Users/myusername* in line 9 with the path to the folder you want the AWS CLI version 2 installed to. **The folder must already exist, or the command fails.** This XML example specifies that the installer installs the AWS CLI in the folder `/Users/myusername`, where it creates a folder named `aws-cli`.

    ```xml
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
    <plist version="1.0">
      <array>
        <dict>
          <key>choiceAttribute</key>
          <string>customLocation</string>
          <key>attributeSetting</key>
          <string>/Users/myusername</string>
          <key>choiceIdentifier</key>
          <string>default</string>
        </dict>
      </array>
    </plist>
    ```

1. Download the `pkg` installer using the `curl` command. The `-o` option specifies the file name that the downloaded package is written to. In this example, the file is written to `AWSCLIV2.pkg` in the current folder.

1. **For the latest version of the AWS CLI**, use the following command block:

    ```text
    $ curl "https://awscli.amazonaws.com/AWSCLIV2.pkg" -o "AWSCLIV2.pkg"
    ```
    **For a specific version of the AWS CLI**, append a hyphen and the version number to the filename. For this example the filename for version 2.0.30 would be AWSCLIV2-2.0.30.pkg resulting in the following command:

    ```text
    $ curl "https://awscli.amazonaws.com/AWSCLIV2-2.0.30.pkg" -o "AWSCLIV2.pkg"
    ```

    For a list of versions, see the [AWS CLI version 2 changelog on GitHub](https://github.com/aws/aws-cli/blob/v2/CHANGELOG.rst).

1. Run the standard macOS `installer` program with the following options:

    + Specify the name of the package to install by using the `-pkg` parameter.

    + Specify a *current user only* installation by setting the parameter `--target CurrentUserHomeDirectory`.

    + Specify the path (relative to the current folder) and name of the XML file that you created in the `--applyChoiceChangesXML` parameter

    The following example installs the AWS CLI in the folder `/Users/myusername/aws-cli`.

    ```text
    $ installer -pkg AWSCLIV2.pkg \
                -target CurrentUserHomeDirectory \
                -applyChoiceChangesXML choices.xml
    ```

1. Because standard user permissions typically don't allow writing to folders in your `$PATH`, the installer in this mode doesn't try to add the symlinks to the `aws` and `aws_completer` programs. For the AWS CLI to run correctly, you must manually create the symlinks after the installer finishes. If your `$PATH` includes a folder you can write to and you specify the folder as the target's path, you can run the following command without `sudo`. If you don't have a writable folder in your `$PATH`, you must use `sudo` for permissions to write to the specified target folder. The default location for a symlink is `/usr/local/bin/`.
    ```text
    $ sudo ln -s /folder/installed/aws-cli/aws /usr/local/bin/aws
    $ sudo ln -s /folder/installed/aws-cli/aws_completer /usr/local/bin/aws_completer
    ```

    After installation is complete, debug logs are written to /var/log/install.log.

#### Verify the installation

To verify that the shell can find and run the aws command in your `$PATH`, use the following commands.

```text
$ which aws
/usr/local/bin/aws 
$ aws --version
aws-cli/2.1.24 Python/3.7.4 Darwin/18.7.0 botocore/2.0.0
```

{{% /expand%}}

{{%expand "Click here - if you are using Windows" %}}
#### Prerequisites

Before you can install or update the AWS CLI version 2 on Windows, be sure you have the following:

+ A 64-bit version of Windows XP or later

+ Admin rights to install software

#### Install or update the AWS CLI version 2 on Windows using the MSI installer

1. Download the AWS CLI MSI installer for Windows (64-bit):

    + **For the latest version of the AWS CLI**: https://awscli.amazonaws.com/AWSCLIV2.msi

    + **For a specific version of the AWS CLI**: Append a hyphen and the version number to the filename. For this example the filename for version `2.0.30` would be `AWSCLIV2-2.0.30.msi` resulting in the following link https://awscli.amazonaws.com/AWSCLIV2-2.0.30.msi. For a list of versions, see the [AWS CLI version 2 changelog on GitHub](https://github.com/aws/aws-cli/blob/v2/CHANGELOG.rst).

    To update your current installation of AWS CLI version 2 on Windows, download a new installer each time you update to overwrite previous versions. AWS CLI is updated regularly. To see when the latest version was released, see the [AWS CLI version 2 changelog on GitHub](https://github.com/aws/aws-cli/blob/v2/CHANGELOG.rst).

1. Run the downloaded MSI installer and follow the on-screen instructions. By default, the AWS CLI installs to `C:\Program Files\Amazon\AWSCLIV2`.

1. To confirm the installation, open the **Start** menu, search for `cmd` to open a command prompt window, and at the command prompt use the `aws --version` command.

    Don't include the prompt symbol (`C:\>`) when you type a command. These are included in program listings to differentiate commands that you type from output returned by the AWS CLI.

    ```text
    C:\> aws --version
    aws-cli/2.1.24 Python/3.7.4 Windows/10 botocore/2.0.0
    ```

    If Windows is unable to find the program, you might need to close and reopen the command prompt window to refresh the path, or add the installation directory to your PATH environment variable manually.
{{% /expand%}}

**Full details on installing, updating, and uninstalling AWS CLI from supported operating systems is available [here](https://docs.aws.amazon.com/cli/latest/userguide/install-cliv2.html).**


{{% notice note %}}
The Cloud Intelligence Dashboards support Multi-Payer Cost and Usage Report (CUR) reporting. **After using the steps below to setup a CUR in each payer account, visit [this section](/cost/200_labs/200_cloud_intelligence/faq/) of the lab on combining multiple CURs for the Cloud Intelligence Dashboards before returning here**    
{{% /notice %}}

### Prepare Cost & Usage Report
The Cost & Usage Report is the foundation for these dashboards. You must have a Cost & Usage Report created with the following format
- Additional report details: Include **Resource IDs**
- Time Granularity: **Hourly**
- Report Versioning: **Overwrite existing report**
- Report data integration for: **Amazon Athena**
- Compression type: **Parquet** 


If you do not have a Cost & Usage Report that meets this criteria follow the *steps for preparing your Cost & Usage report* setup guide below. 

{{% notice note %}}
It can take up to 24 hours for AWS to start delivering reports to your Amazon S3 bucket. After delivery starts, AWS updates the AWS Cost and Usage Reports files at least once a day.
{{% /notice %}}

{{%expand "Click here see steps for preparing your Cost & Usage report" %}}
#### Configure CUR
1. [Sign in](https://console.aws.amazon.com/billing/home#/) to the Billing and Cost Management console.

1. On the navigation pane, choose **Cost & Usage Reports**.

1. Choose **Create report**.

1. For **Report name**, enter a name for your report.

1. Under **Additional report details**, select **Include resource IDs** to include the IDs of each individual resource in the report.
**Note:** Including resource IDs will create individual line items for each of your resources. This can increase the size of your Cost and Usage Reports files significantly, based on your AWS usage.
    ------------ | -------------
1. For **Data refresh settings**, select whether you want the AWS Cost and Usage Reports to refresh if AWS applies refunds, credits, or support fees to your account after finalizing your bill. When a report refreshes, a new report is uploaded to Amazon S3.

1. Choose **Next**.

1. For S3 bucket, choose **Configure**.

1. In the Configure **S3 Bucket** dialog box, do one of the following:

    + Select an existing bucket from the drop down list and choose **Next**.

    + Enter a bucket name and the Region where you want to create a new bucket and choose **Next**.

1. Review the bucket policy, and select **I have confirmed that this policy is correct** and choose **Save**.
1. For **Report path prefix**, enter the report path prefix that you want prepended to the name of your report.
**Note:** Make sure that report path prefix doesn't include a double slash (//) as Athena doesn't support such table location.
    ------------ | -------------
1. For **Time granularity**, choose **Hourly**.

1. For **Report versioning**, choose **Overwrite existing report**.

1. For **Enable report data integration for**, select **Amazon Athena**.

1. Now CUR will be set to **Parquet** format, this format is **mandatory** for the workshop completion.

1. Choose **Next**.

1. After you have reviewed the settings for your report, choose **Review and Complete**.

{{% /expand%}}

### Enable your Cost & Usage Reports in Athena
The dashboards use Athena as the QuickSight data source for generating your dashboards. If you do not have your Cost & Usage Report enabled in Athena please click to expand the setup guide below. 

{{%expand "Click here - to follow the steps for setting up Athena for the first time" %}}
#### Configure Athena
##### 1. Prepare Athena
If this is the first time you will be using Athena you will need to complete a few setup steps before you are able to create the views needed. If you are already a regular Athena user you can skip these steps and move on to step 2 **Prepare CUR & Athena Integration** 

To get Athena warmed up:

1. From the services list, choose **S3**

1. Create a new S3 bucket for Athena queries to be logged to (ex: `aws-athena-query-results-cid-${AWS::AccountId}-${AWS::Region}` ). Keep to the same region as the S3 bucket created for your Cost & Usage Report.

1. From the services list, choose **Athena**

1. Select **Get Started** to enable Athena and start the basic configuration

1. At the top of this screen select **Before you run your first query, you need to set up a query result location in Amazon S3.**

    ![Image of Athena Query Editor](/Cost/200_Cloud_Intelligence/Images/AthenaS3.png?classes=lab_picture_small)

1. Enter the path of the bucket created for Athena queries, it is recommended that you also select the AutoComplete option **NOTE:** The trailing “/” in the folder path is required!

1. Make sure you configured s3 bucket results location for both Athena Query Editor and the 'Primary' Workgroup.

##### 2. Prepare CUR & Athena Integration
{{% notice note %}}
Before you can use the AWS CloudFormation template to automate an Athena integration, you must wait for the first Cost and Usage Report to be delivered to your Amazon S3 bucket.
{{% /notice %}}

To streamline and automate integration of your Cost and Usage Reports with Athena, AWS provides an AWS CloudFormation template with several key resources along with the reports you setup for Athena integration. The AWS CloudFormation template includes an AWS Glue crawler, an AWS Glue database, and an AWS Lambda event.

If you are not deploying the CIDs in your payer acacount, or wish to deploy them on top of multiple payer accounts, please follow [these instructions](https://wellarchitectedlabs.com/cost/200_labs/200_cloud_intelligence/faq/) in lieu of the below. Come back for the QuickSight prerequisites.

1. From the services list, choose **S3**

1. Navigate to the S3 bucket where the **Cost & Usage Report** was saved

1. Select the Object named after the **prefix** defined when your Cost & Usage Report was created (Step 11 in [Prepare Cost & Usage Report](#prepare-cost--usage-report) --> Configure Cur)

1. Select the Object named after the **Cost & Usage Report**

1. Download the **crawler-cfn.yml** file

1. Navigate to the **CloudFormation** service

1. Ensure you are in the same Region as your Cost & Usage Report S3 bucket

1. Deploy the CloudFormation template by clicking **Create stack - With new resources (standard)**

1. Select **Upload a template file**

1. Click **Choose file** and locate your `crawler-cfn.yml` file

1. Click **Next**

1. Enter a Stack Name to identify this as part of your CUDOS Dashboard setup

1. Click **Next**

1. Define Stack options including tags, permissions and rollback configurations.

1. Click **Next**

1. Enable **"I acknowledge that AWS CloudFormation might create IAM resources."** and click **Create Stack**

{{% /expand%}}


### Enable QuickSight 
QuickSight is the AWS Business Intelligence tool that will allow you to not only view the Standard AWS provided insights into all of your accounts, but will also allow to produce new versions of the Dashboards we provide or create something entirely customized to you. If you are already a regular QuickSight user you can skip these steps and move on to the next step. If not, complete the steps below.

{{%expand "Click here - to setup QuickSight" %}}
#### Enable QuickSight:

1. Log into your AWS Account and search for **QuickSight** in the list of Services

1. You will be asked to **sign up** before you will be able to use it

    ![QuickSight Sign up Workflow Image](https://wellarchitectedlabs.com/Cost/200_Cloud_Intelligence/Images/QS-signup.png?classes=lab_picture_small)

1. After pressing the **Sign up** button you will be presented with 2 options, please ensure you select the **Enterprise Edition** during this step

1. Select **continue** and you will need to fill in a series of options in order to finish creating your account. 

    + Ensure you select the region that is most appropriate based on where your S3 Bucket is located containing your Cost & Usage Report file.

        ![Select Region and Amazon S3 Discovery](/Cost/200_Cloud_Intelligence/Images/QS-s3.png?classes=lab_picture_small)
    
    + Enable the Amazon S3 option and select the bucket where your **Cost & Usage Report** is stored, as well as your **Athena** query bucket

        ![Image of s3 buckets that are linked to the QuickSight account. Enable bucket and give Athena Write permission to it.](/Cost/200_Cloud_Intelligence/Images/QS-bucket.png?classes=lab_picture_small)

1. Click **Finish** and wait for the congratulations screen to display

1. Click **Go to Amazon QuickSight**

![](/Cost/200_Cloud_Intelligence/Images/Congrats-QS.png?classes=lab_picture_small)
{{% /expand%}}



{{< prev_next_button link_prev_url="./cost-usage-report-dashboards/" link_next_url="../2_deploy_dashboards" />}}
