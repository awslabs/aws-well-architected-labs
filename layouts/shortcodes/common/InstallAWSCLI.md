## Install AWS CLI

The AWS Command Line Interface (AWS CLI) is a unified tool that provides a consistent interface for interacting with all parts of AWS.

### Linux

* This includes:
  * All native Linux installs
  * MacOS
  * Windows Subsystem for Linux (WSL)
  * Run the following command

        $ aws --version
        aws-cli/1.16.249 Python/3.6.8...
* AWS CLI version 1.0 or higher is fine
* If you instead got `command not found` then you need to install `awscli`:

       $ pip3 install awscli --upgrade --user
       ...(lots of output)...
       Successfully installed...
* If that succeeded, then you are finished.  Return to the Lab Guide

If that does not work, then do the following:

* See the [detailed installation instructions here](https://docs.aws.amazon.com/cli/latest/userguide/install-bundle.html)

### Other environments (not Linux)

* See the instructions here <https://docs.aws.amazon.com/cli/latest/userguide/install-cliv1.html>
