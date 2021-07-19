+++
title = "Cleanup"
weight = 6

+++
-----------


### Deleting AWS resources deployed in this lab
To remove all resources you added in this lab, follow these steps:

1. On CloudEndure user console, go to Project Actions in the upper right. Choose Delete Current Project, as shown in the following screenshot.
![Delete Project](/lab1/delete_current_project.png?classes=shadow,border&width=20pc)
2. Go to [CloudFormation AWS Console](https://eu-west-1.console.aws.amazon.com/cloudformation/home?region=eu-west-1#/stacks?filteringStatus=active&filteringText=TargetVPC&viewNested=false&hideStacks=false).  In the stack details pane, choose **Delete**.
3. Go to [CloudFormation AWS Console](https://us-east-1.console.aws.amazon.com/cloudformation/home?region=us-east-1#/stacks?filteringStatus=active&filteringText=source&viewNested=false&hideStacks=false) and select the **source-simulated** stack. In the stack details pane, choose **Delete**.