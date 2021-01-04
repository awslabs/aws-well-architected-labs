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

#### If the version number is less than 2.1.12 or you get "command not found"
* `curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"`
* `unzip awscliv2.zip`
* `sudo ./aws/install --update`

After typing the commands, you should see the following in your console:
![Upgrade1](/Common/awscliv2/Upgrade1.png)

For additional troubleshooting, see the [detailed installation instructions here](https://docs.aws.amazon.com/cli/latest/userguide/install-cliv2-linux.html)


### MacOS
See the [detailed MacOS installation instructions here](https://docs.aws.amazon.com/cli/latest/userguide/install-cliv2-mac.html)


### Windows
See the [detailed Windows installation instructions here](https://docs.aws.amazon.com/cli/latest/userguide/install-cliv2-windows.html)
