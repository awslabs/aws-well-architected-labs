## jq

`jq` is a command-line JSON processor. is like `sed` for JSON data. It is used in the workshop `bash` scripts to parse AWS CLI output.

* Run the following command

        $ jq --version
        jq-1.5-1-a5b5cbe
* Any version is fine.
* If you instead got `command not found` then you need to install `jq`. Follow the instructions at <https://stedolan.github.io/jq/download/>

* If that succeeded, then you are finished.  Return to the Lab Guide

### Alternate instructions for Linux

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
