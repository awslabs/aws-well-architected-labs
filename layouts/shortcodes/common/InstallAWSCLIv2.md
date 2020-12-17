## Install AWS CLI v2

The AWS Command Line Interface (AWS CLI) is a unified tool that provides a consistent interface for interacting with all parts of AWS.

### Linux
This includes:
  * AWS CloudShell
  * All native Linux installs
  * Windows Subsystem for Linux (WSL)

Verify existing version:
* Run the following command
    ` aws --version `
![Step1](/Common/awscliv2/Step1.png)

#### If the version number is less than 2.1.12
* `curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"`
* `unzip awscliv2.zip`
* `sudo ./aws/install --update`

After typing the commands, you should see the following in your console:
![Upgrade1](/Common/awscliv2/Upgrade1.png)

#### If you get "command not found" then you need to install awscli:
![NotFound1](/Common/awscliv2/NotFound1.png)

Install using these commands:
* `curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"`
* `unzip awscliv2.zip`
* `sudo ./aws/install`

After typing the commands, you should see the following in your console:
![NotFound2](/Common/awscliv2/NotFound2.png)

For additional troubleshooting, see the [detailed installation instructions here](https://docs.aws.amazon.com/cli/latest/userguide/install-cliv2-linux.html)


### MacOS
```
curl "https://awscli.amazonaws.com/AWSCLIV2.pkg" -o "AWSCLIV2.pkg"
sudo installer -pkg AWSCLIV2.pkg -target /
```
For additional troubleshooting, see the [detailed MacOS installation instructions here](https://docs.aws.amazon.com/cli/latest/userguide/install-cliv2-mac.html)


### Windows
See the [detailed Windows installation instructions here](https://docs.aws.amazon.com/cli/latest/userguide/install-cliv2-windows.html)
