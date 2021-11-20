<!--
     region: AWS region in the form us-east-2 or similar
-->


{{ if .Get "region"}}
1. Go to the [AWS CloudShell console here](https://{{ .Get "region" }}.console.aws.amazon.com/cloudshell/home)
{{ else }}
1. Go to the [AWS CloudShell console here](https://console.aws.amazon.com/cloudshell/home)
{{ end }}
1. If this is your first time running CloudShell, then it will take less than a minute to create the environment. When you see a prompt like `[cloudshell-user@ip-10-0-49-48 ~]$`, then you can continue
1. Validate that credentials are properly setup. 
    * execute the command `aws sts get-caller-identity`
    * If the command succeeds, and the **Arn** contains **assumed-role/TeamRole/MasterKey**, then you can continue
1. Adjust font size and theme using the gear icon on the upper right
1. Explore the **Actions** menu (upper-right) - you can upload/download files or create new tabs