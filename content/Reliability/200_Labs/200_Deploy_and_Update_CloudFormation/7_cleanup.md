---
title: "Tear down this lab"
date: 2020-04-24T11:16:09-04:00
chapter: false
pre: "<b>7. </b>"
weight: 7
---
When a CloudFormation stack is deleted, CloudFormation will automatically delete
the resources that it created.

{{% common/EventEngineVsOwnAccountCleanup %}}

### Remove AWS CloudFormation provisioned resources

You will now delete the **CloudFormationLab** CloudFormation stack.

#### How to delete an AWS CloudFormation stack

{{% common/DeleteCloudFormationStack %}}

#### How to delete an AWS CloudFormation StackSet

1.  Go to the [AWS CloudFormation StackSets console](https://console.aws.amazon.com/cloudformation/home#/stacksets)
1.  Select the StackSet you wish to delete
1.  Click on **Actions** and then **Delete stacks from StackSet**.
1.  Under **Accounts**, select **Deploy stacks in accounts** under **Deployment locations**.
1.  Under **Account numbers** enter the 12 digit AWS account ID for the account you are using for this lab. You can find this by clicking on the user/role drop down you have logged into the account with on the top right corner.
1.  For **Specify regions** click on **Add all regions**. This will automatically select the AWS Regions that the StackSet deployed stacks into.
1.  Click **Next**. Click **Submit** on the **Review** page.
1.  StackSets will now delete the individual stacks that were created in the different accounts/regions. The operation takes about 3 minutes to complete and the **Status** to change to _SUCCEEDED_.
1.  After the stacks have been deleted, click on **Actions** on the top right corner and then click on **Delete StackSet**.

---

## References & useful resources

* [What is AWS CloudFormation?](https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/Welcome.html)
* CloudFormation [AWS Resource and Property Types Reference](https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-template-resource-type-ref.html)
* [Working with AWS CloudFormation StackSets](https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/what-is-cfnstacksets.html)

{{< prev_next_button link_prev_url="../5_add_ec2/" title="Congratulations!" final_step="true" >}}
Now that you have completed the lab, if you have implemented this knowledge in your environment, you should re-evaluate the questions in the Well-Architected tool. This lab specifically helps you with [REL 8  How do you implement change?](https://docs.aws.amazon.com/wellarchitected/latest/framework/a-change-management.html)
{{< /prev_next_button >}}
