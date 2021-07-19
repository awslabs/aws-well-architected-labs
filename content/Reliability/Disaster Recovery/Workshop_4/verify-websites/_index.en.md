+++
title = "Verify Websites"
date =  2021-05-11T11:43:28-04:00
weight = 3
+++

{{% notice note %}}
This is where you are going to need the values that you copied from your CloudFormation Outputs Tab from your `Active-Primary` Stack Creation.
{{% /notice %}}

{{< img pr-6.png >}}

Copy the **WebsiteURL** url value and paste into a browser.

Verify the website header says `The Unicorn Shop - us-east-1`.

{{< img vw-5.png >}}

{{% notice note %}}
This is where you are going to need the values that you copied from your CloudFormation Outputs Tab from your `Passive-Secondary` Stack Creation.
{{% /notice %}}


{{< img sr-6.png >}}

Copy the **WebsiteURL** url value and paste into a browser.

Verify the website header says `The Unicorn Shop - us-west-1`.

{{< img vw-6.png >}}