+++
title = "Verify Websites"
date =  2021-05-11T11:43:28-04:00
weight = 5
+++

### Verify the Active-Primary Website

{{% notice warning %}}
**All previous modifications to resources must be finished before continuing on to this section.**
{{% /notice %}}

{{% notice note %}}
You will need the Amazon CloudFormation output parameter values from the **Active-Primary** stack to complete this section.  For help, refer to the [CloudFormation Outputs](../prerequisites/cfn-outputs/) **Primary Region** section of the workshop.
{{% /notice %}}

{{< img pr-6.png >}}

1.1 Copy the **WebsiteURL** url value into a browser window.

1.2 Verify the website header says **The Unicorn Shop - us-east-1**.

{{< img vw-5.png >}}

### Verify the Passive-Secondary Website

{{% notice note %}}
You will need the Amazon CloudFormation output parameter values from the **Passive-Secondary** stack to complete this section. For help, refer to the [CloudFormation Outputs](../prerequisites/cfn-outputs/) **Secondary Region** section of the workshop.
{{% /notice %}}

{{< img sr-6.png >}}

2.1 Copy the **WebsiteURL** url value into a browser window.

2.2 Verify the website header says **The Unicorn Shop - us-west-1**.

{{< img vw-6.png >}}

{{< prev_next_button link_prev_url="../configure-websites/" link_next_url="../setup-cloudfront/" />}}

