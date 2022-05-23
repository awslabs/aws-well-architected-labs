---
title: "FAQ"
#menutitle: "FAQs"
date: 2020-09-07T11:16:08-04:00
chapter: false
weight: 7
hidden: false
---
#### Last Updated
April 2022

If you wish to provide feedback on this lab, there is an error, or you want to make a suggestion, please email:  costoptimization@amazon.com

### My region is not covered in the 'Code Bucket' Parameter
{{%expand "Click here to expand step by step instructions" %}}

We have set this up in the most common regions. If your region is not in the list please email costoptimization@amazon.com and we will create this resource for you

{{% /expand%}}


### Compute Optimizer Module Failing 
{{%expand "Click here to expand step by step instructions" %}}
Please make sure you enable Compute Optimizer following this [guide.](https://docs.aws.amazon.com/organizations/latest/userguide/services-that-can-integrate-compute-optimizer.html)

{{% /expand%}}

### I need to edit my StackSet
{{%expand "Click here to expand step by step instructions" %}}

If, when you deployed your StackSets, you chose to deploy to all accounts and you now wish to edit you will need to get your **Root ID**.

This can be found in your AWS Organizations part of the console. 

{{% /expand%}}

### Why should I have a separate cost account?
{{%expand "Click here to expand for more information" %}}

There are two main reasons for this:

1. We recommend customer avoid deploying workloads to the organization’s management account in general:

"Since privileged operations can be performed within an organization’s management account and SCPs do not apply to the management account, we recommend that you limit access to an organization’s management account. You should also limit the cloud resources and data contained in the management account to only those that must be managed in the management account." from [here](https://docs.aws.amazon.com/whitepapers/latest/organizing-your-aws-environment/design-principles-for-organizing-your-aws-accounts.html)
 

2. As there are lambda function deployed in the account these could benefit from Compute Savings plans. This means that there could be higher savings missed in other accounts because they are used on the lambdas first:

"In a Consolidated Billing Family, Savings Plans are applied first to the owner account's usage, and then to other accounts' usage. This occurs only if you have sharing enabled." from [Here](https://docs.aws.amazon.com/savingsplans/latest/userguide/sp-applying.html)


{{% /expand%}}



{{% notice tip %}}
This page will be updated regularly with new answers. If you have a FAQ you'd like answered here, please reach out to us here costoptimization@amazon.com. 
{{% /notice %}}
