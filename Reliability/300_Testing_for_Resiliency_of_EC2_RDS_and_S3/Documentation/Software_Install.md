# Software Install

This reference will help you install software necessary to setup your workshop environment

1. [AWS CLI](#awscli)
1. [jq](#jq)

## AWS CLI <a name="awscli"></a>

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
* If that succeeded, then you are finished.  Return to the [Lab Guide](../Lab_Guide.md)

If that does not work, then do the following:

* See the [detailed installation instructions here](https://docs.aws.amazon.com/cli/latest/userguide/install-bundle.html)

**STOP HERE and return to the [Lab Guide](../Lab_Guide.md)**

---

## jq

`jq` is a command-line JSON processor. is like `sed` for JSON data. It is used in the workshop `bash` scripts to parse AWS CLI output.

* Run the following command

        $ jq --version
        jq-1.5-1-a5b5cbe
* Any version is fine.
* If you instead got `command not found` then you need to install `jq`. Follow the instructions at https://stedolan.github.io/jq/download/

* If that succeeded, then you are finished.  Return to the [Lab Guide](../Lab_Guide.md)

#### Alternate instructions for Linux

If the steps above did not work, and you are running Linux, then try the following

1. Download the `jq` executable

        $ wget https://github.com/stedolan/jq/releases/download/jq-1.6/jq-linux64
        
        [...lots of output...]
        jq-linux64                    100%[=================================================>]   3.77M  1.12MB/s    in 3.5s

        2019-10-11 17:41:42 (1.97 MB/s) - ‘jq-linux64’ saved [3953824/3953824]

1. You can find out what your execution path is with the following command.

        $ echo $PATH
        /usr/local/bin:/bin:/usr/bin:/usr/local/sbin:/usr/sbin:/sbin:/opt/aws/bin:/home/ec2-user/.local/bin:/home/ec2-user/bin

1. If you have sudo rights, then copy the executable to /usr/local/bin/jq and make it executable.  

        $ sudo cp jq-linux64 /usr/local/bin/jq
        $ sudo chmod 755 /usr/local/bin/jq

1. If you do not have sudo rights, then copy it into your home directory under a /bin directory.

        $ cp jq-linux64 ~/bin/jq
        $ chmod 755 ~/bin/jq

**[Click here to return to the Lab Guide](../Lab_Guide.md)**
